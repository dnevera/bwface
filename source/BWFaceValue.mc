using Toybox.System as Sys;
using Toybox.Math as Math;
using Toybox.Activity as Activity;
using Toybox.ActivityMonitor as Monitor;

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
	BW_UserBMR     = 11
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
				var sensorIter =  getTemperatureIterator();
				if  ( sensorIter != null ){   	    	    	
					value = sensorIter.next();
					value = value == null ? "--" : value.data == null ? "--" : value.data.format("%.0f");
		    	}			
				else {
					value = "--";
				}
				break;
			case BW_Pressure:
				value =  pressure(0.001, "%.1f");
				break;
			case BW_PressurehPa:
				value =  pressure(0.01, "%.2f");
				break;
			case BW_PressureMmHg:
				value =  pressure(0.00750062, "%.1f");
				break;
				
			case BW_UserBMR :
				value =  properties.bmr();
				break;
							
		}
		return value;
	} 

	function sunrise(){
	    var sunRise = geoInfo.computeSunrise(true);
	    if (sunRise==null) {
	    	return "--"; 
	    }
	    sunRise=sunRise/1000/60/60;    
		var r = Lang.format("$1$:$2$", [Math.floor(sunRise).format("%02.0f"), Math.floor((sunRise-Math.floor(sunRise))*60).format("%02.0f")]);
		return r;
	}
	
	function sunset(){
        var sunSet = geoInfo.computeSunrise(false);
	    if (sunSet==null) {
	    	return "--"; 
	    }
        sunSet=sunSet/1000/60/60;
        var r = Lang.format("$1$:$2$", [Math.floor(sunSet).format("%02.0f"), Math.floor((sunSet-Math.floor(sunSet))*60).format("%02.0f")]);
		return r;
	}

	function pressure(factor, format){
		var sensorIter =  getPressureIterator();
		if  ( sensorIter != null ){   	    	    	
			var n = sensorIter.next();
			if (n.data == null){
				return "--";
			}
			return (n.data*factor).format(format);
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

}