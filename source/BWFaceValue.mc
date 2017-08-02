using Toybox.System as Sys;
using Toybox.Math as Math;
using Toybox.Activity as Activity;
using Toybox.ActivityMonitor as Monitor;
using Toybox.Time.Gregorian as Calendar;

enum {
	BW_Distance    = 0,
	BW_Steps       = 1,
	BW_Calories    = 2,
	BW_Seconds     = 3,
	BW_Sunrise     = 4,
	BW_Sunset      = 5,
	BW_Altitude    = 6,
	BW_HeartRate   = 7,
	BW_Temperature = 8,
	BW_Pressure    = 9,
	BW_PressureMmHg= 10,
	BW_PressurehPa = 1001, // NOTE: currently i can't read sys configuration
	BW_UserBMR     = 11,
	BW_ActivityFactor    = 12,
	BW_FloorsClimbed     = 13,	
	BW_Elevation         = 14,	
	BW_Climbed     = 15	
}

class BWFaceValue {

	var properties;
	var geoInfo;
	
		
	function initialize(_properties){
		properties = _properties;
		geoInfo = new BWFaceGeoInfo(properties);
	}
		
	function info(id) {
		var dict = {:scale=>1,:delim=>"",:title=>"", :format=>"%d", :prec=>3};
		switch (id) {
			case BW_Distance: // distance
				dict[:title] = properties.strings.distanceTitle;
				dict[:scale] = 10;
				dict[:delim] = ",";
				break;
			case BW_Steps: 
				dict[:title] = properties.strings.stepsTitle;
				break;
			case BW_Calories: 
				dict[:title] = properties.strings.caloriesTitle;
				break;
			case BW_Seconds: 
				dict[:title] = properties.strings.secondsTitle;
				break;
			case BW_Sunrise: 
				dict[:title] = properties.strings.sunriseTitle;
				break;
			case BW_Sunset: 
				dict[:title] = properties.strings.sunsetTitle;
				break;
			case BW_Altitude: 
				dict[:title] = properties.strings.altitudeTitle;
				break;
			case BW_HeartRate:
				dict[:title] = properties.strings.bpmTitle;
				break;
			case BW_Temperature:
				dict[:title] = properties.strings.temperatureTitle;
				break;
			case BW_Pressure:
				dict[:title] = properties.strings.pressureTitle;
				break;
			case BW_PressurehPa:
				dict[:title] = properties.strings. pressurehPaTitle;
				break;
			case BW_PressureMmHg:
				dict[:title] = properties.strings.pressuremmHgTitle;
				break;
			case BW_UserBMR :
				dict[:title] = properties.strings.userBMRTitle;
				break;
			case BW_ActivityFactor :
				dict[:title] = properties.strings.activityFactorTitle;
				dict[:scale] = 10;
				dict[:delim] = ",";
				
				break;
			case BW_FloorsClimbed :
				dict[:title] = properties.strings.floorsClimbedTitle;
				break;
			case BW_Climbed :
				dict[:title] = properties.strings.climbedTitle;
				break;
			case BW_Elevation :
				dict[:title] = properties.strings.elevationTitle;
				break;
		}
		return dict;
	}

	function value(id) {
		var value = 0;
		switch (id) {
			case BW_Distance: // distance
				value = Monitor.getInfo().distance;
				value = value == null ? "--" : value/100.0/properties.statuteFactor;
				break;

			case BW_FloorsClimbed: 
			    if (Toybox.ActivityMonitor.Info has :floorsClimbed) {
					value = Monitor.getInfo().floorsClimbed;
					value = value == null ? "--" : value;
				}
				else {
					value = "--";
				}
				break;

			case BW_Climbed: 
			    if (Toybox.ActivityMonitor.Info has :metersClimbed) {
					value = Monitor.getInfo().metersClimbed;
					value = value == null ? "--" : value/properties.statuteFactor;
				}
				else {
					value = "--";
				}
				break;
				
			case BW_Steps: 
				value = Monitor.getInfo().steps;
				value = value== null ? "--" : value;
				break;
				
			case BW_Calories: 
				value = Monitor.getInfo().calories;
				break;
				
			case BW_Seconds: 
				if (BWFace.partialUpdatesAllowed){
					value = Sys.getClockTime().sec;
					value = value== null ? "--" : value.format("%02.0f");
				}
				else {
					value = "--";
				}
				break;
				
			case BW_Sunrise: 
				value = sunrise();				
				break;
				
			case BW_Sunset: 
				value = sunset();				
				break;
				
			case BW_Altitude: 
				value = geoInfo.getAltitude();				
				value = value == null ? "--" : value;
				break;
								
			case BW_HeartRate:
				var a = Activity.getActivityInfo();
				if (a!=null){
					value = a.currentHeartRate;
				}
				if (value == null){
					var sensorIter= getHeartRateIterator();
					if  ( sensorIter != null ){   	    	    	
						value = sensorIter.next();
						value = value == null ? "--" : value.data == null ? "--" : value.data.format("%d");
			    	}			
					else {
						value = "--";
					}				
				}
				else {
					value = value.format("%d");
				}
				break;  	

			case BW_Temperature:
				value = temperature();
				break;
			case BW_Pressure:
				value =  pressure(0.001, "%.1f", 10);
				break;
			case BW_PressurehPa:
				value =  pressure(0.01, "%.2f", 100);
				break;
			case BW_PressureMmHg:
				value =  pressure(0.00750062, "%.1f", 10);
				break;
				
			case BW_UserBMR :
				value =  properties.bmr();
				break;

			case BW_ActivityFactor :
				var c = Monitor.getInfo().calories;
				if (c>0) {
					value =  (c/properties.bmr()*1000);
					
				}
				else {
					value = "--";
				}
				break;
				
			case BW_Elevation:{
				var sensorIter = getElevationIterator();
				if  ( sensorIter != null ){   	    	    	
					value = sensorIter.next();
					value = value == null ? "--" : value.data == null ? "--" : value.data/properties.statuteFactor;
		    	}			
				else {
					value = "--";
				}
				}
				break;							
		}
		return value;
	} 

    function toSysHour(hour){
        if (Sys.getDeviceSettings().is24Hour){
            return (Math.floor(hour).toLong() % 24).format("%02.0f");
        }
        else {
            var h = Math.floor(hour).toLong() % 12;
            if(h==0){
                h=12;
            }
            return h.format("%2.0f");
        }
    }

	function sunrise(){
	    var sunRise = geoInfo.computeSunrise(true);
	    if (sunRise==null) {
	    	return "--"; 
	    }
	    sunRise=sunRise/1000/60/60;
		var r = Lang.format("$1$:$2$", [toSysHour(sunRise), Math.floor((sunRise-Math.floor(sunRise))*60).format("%02.0f")]);
		return r;
	}
	
	function sunset(){
        var sunSet = geoInfo.computeSunrise(false);
	    if (sunSet==null) {
	    	return "--"; 
	    }
        sunSet=sunSet/1000/60/60;

        var r = Lang.format("$1$:$2$", [toSysHour(sunSet), Math.floor((sunSet-Math.floor(sunSet))*60).format("%02.0f")]);
		return r;
	}

	function pressure(factor, format, scale){
		var sensorIter =  getPressureIterator();
		if  ( sensorIter != null ){   	    	    	
			var n = sensorIter.next();
			if (n.data == null){
				return "--";
			}
			n = n.data;
			return (Math.round(n*factor*scale)/scale).format(format);
    	}			
		else {
			return "--";
		}
	}

	function temperature(){
        var sensorIter =  getTemperatureIterator();
        if  ( sensorIter != null ){
            var value = sensorIter.next();
            if (value.data == null) {
                return "--";
            }
            value = value.data;
            if (Sys.getDeviceSettings().temperatureUnits == Sys.UNIT_STATUTE) {
                value = value * 9/5 + 32;
            }
            return (Math.round(value)).format("%.0f");
        }
        else {
            return "--";
        }
	}

	function getPressureIterator() {
	    if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getPressureHistory)) {
	        return Toybox.SensorHistory.getPressureHistory({:order=>SensorHistory.ORDER_NEWEST_FIRST,:period=>1});
	    }
	    return null;
	}
	
	function getTemperatureIterator() {
	    if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getTemperatureHistory)) {
	        return Toybox.SensorHistory.getTemperatureHistory({:order=>SensorHistory.ORDER_NEWEST_FIRST,:period=>1});
	    }
	    return null;
	}

	function getHeartRateIterator() {
	    if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getHeartRateHistory)) {
	        return Toybox.SensorHistory.getHeartRateHistory({:order=>SensorHistory.ORDER_NEWEST_FIRST,:period=>1});
	    }
	    return null;
	}
	
	function getElevationIterator() {
	    if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getElevationHistory)) {
	        return Toybox.SensorHistory.getElevationHistory({:order=>SensorHistory.ORDER_NEWEST_FIRST,:period=>1});
	    }
	    return null;
	}

}