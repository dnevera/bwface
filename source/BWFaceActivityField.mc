using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.ActivityMonitor as Monitor;
using Toybox.Math as Math;


class BWFaceActivityField extends BWFaceField {
	
	var leftField;
	var midField;
	var rightField;
	
	var currentCalories;
		       
	protected var dc;
	protected var framePadding;
	protected var frameRadius;	
	protected var widthFactor = 3;
	
    function initialize(dictionary,newProperties){
		BWFaceField.initialize(dictionary,newProperties);
		dc = properties.dc;		
		framePadding = dictionary[:framePadding];
		frameRadius = dictionary[:frameRadius]; 
		
		var dict = {:font=>properties.fonts.infoFont,
					:fontFraction=>properties.fonts.infoFractFont,
					:fontTitle=>properties.fonts.infoTitleFont,
					:delim => "",
					:scale => 1,
					:framePadding=>framePadding,
					:frameRadius=>frameRadius,
					:color=>properties.labelColor,
					:frameColor=>properties.framesColor};
					
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

		dict[:title] = properties.strings.distanceTitle;
		dict[:justification] = Gfx.TEXT_JUSTIFY_RIGHT;
		dict[:scale] = 10;
		dict[:delim] = ",";
		
		leftField = new BWFaceNumber(dc, rect0, dict);
	
		dict[:title] = properties.strings.stepsTitle;
		dict[:justification] = Gfx.TEXT_JUSTIFY_CENTER;
		dict[:scale] = 1;
		dict[:delim] = "";
		
		midField = new BWFaceNumber(dc, rect1, dict);
	
		dict[:title] = properties.strings.caloriesTitle;
		dict[:justification] = Gfx.TEXT_JUSTIFY_LEFT;
		dict[:scale] = 1;
		dict[:delim] = "";
		
		rightField = new BWFaceNumber(dc, rect2, dict);
			
		topY = locY;
		bottomY = locY+midField.h+framePadding*2; 				
    }

    function draw(){		
		var monitor = Monitor.getInfo(); 
		currentCalories = monitor.calories;
				
		leftField.draw(monitor.distance.toDouble()/100.0/properties.statuteFactor, true);
		midField.draw(monitor.steps, true);
		rightField.draw(monitor.calories, true);								
	}
}