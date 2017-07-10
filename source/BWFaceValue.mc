using Toybox.System as Sys;
using Toybox.ActivityMonitor as Monitor;
using Toybox.Math as Math;

enum {
	BW_Distance = 0,
	BW_Steps    = 1,
	BW_Calories = 2,
	BW_Seconds  = 3,
	BW_Sunrise  = 4,
	BW_Sunset   = 5,
	BW_Altitude = 6
}

class BWFaceValue {

	var properties;
	var monitor = Monitor.getInfo(); 
	var geoInfo;
	
	var partialUpdatesAllowed;
		
	function initialize(_properties){
		partialUpdatesAllowed = ( Toybox.WatchUi.WatchFace has :onPartialUpdate );	
		properties = _properties;
		geoInfo = new BWFaceGeoInfo(properties);
	}
		
	function info(id) {
		var dict = {:scale=>1,:delim=>"",:title=>""};
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
		}
		return dict;
	}

	function value(id) {
		var value = 0;
		switch (id) {
			case BW_Distance: // distance
				return monitor.distance.toDouble()/100.0/properties.statuteFactor;
				break;
			case BW_Steps: 
				return monitor.steps;
				break;
			case BW_Calories: 
				return monitor.calories;
				break;
			case BW_Seconds: 
				if (partialUpdatesAllowed){
					return Sys.getClockTime().sec;
				}
				else {
					return "--";
				}
				break;
			case BW_Sunrise: 
				return sunrise();
				break;
			case BW_Sunset: 
				return sunset();
				break;
			case BW_Altitude: 
				var a = geoInfo.getAltitude();				
				return a == null ? "--" : a;
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

}