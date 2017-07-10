using Toybox.System as Sys;
using Toybox.ActivityMonitor as Monitor;
using Toybox.Math as Math;

enum {
	BW_Distance = 0,
	BW_Steps    = 1,
	BW_Calories = 2,
	BW_Seconds  = 3
}

class BWFaceValue {

	var properties;
	var monitor = Monitor.getInfo(); 
	var partialUpdatesAllowed;
		
	function initialize(_properties){
		partialUpdatesAllowed = ( Toybox.WatchUi.WatchFace has :onPartialUpdate );	
		properties = _properties;
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
		}
		return value;
	} 

}