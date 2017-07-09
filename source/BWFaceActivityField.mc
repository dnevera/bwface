using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.ActivityMonitor as Monitor;
using Toybox.Math as Math;

class BWFaceValue {

	var properties;
	var monitor = Monitor.getInfo(); 
	
	function initialize(_properties){
		properties = _properties;
	}
	
	function info(id) {
		var dict = {:scale=>1,:delim=>"",:title=>""};
		switch (id) {
			case 0: // distance
				dict[:title] = properties.strings.distanceTitle;
				dict[:scale] = 10;
				dict[:delim] = ",";
				break;
			case 1: 
				dict[:title] = properties.strings.stepsTitle;
				break;
			case 2: 
				dict[:title] = properties.strings.caloriesTitle;
				break;
			case 3: 
				dict[:title] = properties.strings.secondsTitle;
				break;
		}
		return dict;
	}

	function value(id) {
		var value = 0;
		switch (id) {
			case 0: // distance
				return monitor.distance.toDouble()/100.0/properties.statuteFactor;
				break;
			case 1: 
				return monitor.steps;
				break;
			case 2: 
				return monitor.calories;
				break;
			case 3: 
				return Sys.getClockTime().sec;
				break;
		}
		return value;
	} 

}

class BWFaceActivityField extends BWFaceField {
	
	var leftField;
	var midField;
	var rightField;
	
	var hasSeconds = false;
	var currentCalories;
		       
	protected var dc;
	protected var framePadding;
	protected var frameRadius;	
	protected var widthFactor = 3;
	
	protected var faceValue;
	
	function setup(){
	
		Sys.println(" field0 =" + properties.activityLeftField);
		Sys.println(" field1 =" + properties.activityMidField);
		Sys.println(" field2 =" + properties.activityRightField);
		
		if (properties.activityMidField==3 || properties.activityRightField==3 || properties.activityLeftField==3) {
			hasSeconds = true;
		}
		else {
			hasSeconds = false;
		}
								
		faceValue = new BWFaceValue(properties);
		
		var dict = {:font=>properties.fonts.infoFont,
					:fontFraction=>properties.fonts.infoFractFont,
					:fontTitle=>properties.fonts.infoTitleFont,
					:delim => "",
					:scale => 1,
					:framePadding=>framePadding,
					:frameRadius=>frameRadius,
					:color=>properties.labelColor,
					:frameColor=>properties.framesColor,
					:bgColor=>properties.bgColor};
					
		var w = dc.getWidth();
		
		var d  = widthFactor;
		var wf = dc.getWidth()/d;

		var rect0;
		var rect1;
		var rect2;
		
		if (settings.screenShape == System.SCREEN_SHAPE_RECTANGLE) {
			rect0 = [-framePadding, locY, wf+framePadding-2,0,-framePadding];
			rect1 = [w/2,           locY, wf,               0, wf-1];
			rect2 = [w/d*2,         locY, wf+framePadding,  0, w/d*2];
		}
		else {
			rect0 = [0,        locY, wf+2, 0, 0];
			rect1 = [w/2,      locY, wf-6, 0, wf+3];
			rect2 = [w/d*2-2,  locY, wf,   0, w/d*2-2];
		}

		dict[:justification] = Gfx.TEXT_JUSTIFY_RIGHT;
		var info = faceValue.info(properties.activityLeftField);
		dict[:title] = info[:title];
		dict[:scale] = info[:scale];
		dict[:delim] = info[:delim];
		
		leftField = new BWFaceNumber(dc, rect0, dict);
	
		dict[:justification] = Gfx.TEXT_JUSTIFY_CENTER;
		info = faceValue.info(properties.activityMidField);
		dict[:title] = info[:title];
		dict[:scale] = info[:scale];
		dict[:delim] = info[:delim];
		
		midField = new BWFaceNumber(dc, rect1, dict);
	
		dict[:justification] = Gfx.TEXT_JUSTIFY_LEFT;
		info = faceValue.info(properties.activityRightField);
		dict[:title] = info[:title];
		dict[:scale] = info[:scale];
		dict[:delim] = info[:delim];
		
		rightField = new BWFaceNumber(dc, rect2, dict);	
	}
	
    function initialize(dictionary,newProperties){
        
		BWFaceField.initialize(dictionary,newProperties);
	
		dc = properties.dc;		
		framePadding = dictionary[:framePadding];
		frameRadius = dictionary[:frameRadius]; 
		
		setup();
					
		topY = locY;
		bottomY = locY+midField.h+framePadding*2; 				
    }

    function draw(){	
		currentCalories = faceValue.value(2);								
		leftField.draw(faceValue.value(properties.activityLeftField), true,properties.activityLeftField==3);
		midField.draw(faceValue.value(properties.activityMidField), true,properties.activityMidField==3);
		rightField.draw(faceValue.value(properties.activityRightField), true,properties.activityRightField==3);										
	}
	
	function partialDraw(){
		if (hasSeconds){
			if (properties.activityLeftField==3){
				leftField.partialDraw(faceValue.value(properties.activityLeftField).format("%0d"), null);
			}
			if (properties.activityMidField==3){
				midField.partialDraw(faceValue.value(properties.activityMidField).format("%0d"), null);
			}
			if (properties.activityRightField==3){
				rightField.partialDraw(faceValue.value(properties.activityRightField).format("%0d"), null);
			}									    	
		}
	}
}