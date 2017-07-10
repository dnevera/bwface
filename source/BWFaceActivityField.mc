using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.ActivityMonitor as Monitor;
using Toybox.Math as Math;

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
	
	protected var partialFields = [null,null,null];
	
	function setup(){

		leftField = null;
		midField = null;
		rightField = null;
		partialFields = [null,null,null];
		faceValue = null;
										
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
			rect0 = [-framePadding, locY, wf+framePadding,0,-framePadding];
			rect1 = [w/2,           locY, wf,             0, wf+1];
			rect2 = [w/d*2+1,       locY, wf+framePadding,  0, w/d*2+2];
		}
		else {
			rect0 = [0,       locY, wf+6,  0, 0];
			rect1 = [w/2-1,   locY, wf-12, 0, wf+7];
			rect2 = [w/d*2-5, locY, wf+5,  0, w/d*2-4];
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
				
		setupPartial();
	}
	
	function setupPartial(){
		hasSeconds = false;
		if (properties.activityLeftField==BW_Seconds) {
			partialFields[0] = leftField;
		}
		else {
			partialFields[0] = null;
		}
		if (properties.activityMidField==BW_Seconds) {
			partialFields[1] = midField;
		}
		else {
			partialFields[1] = null;
		}
		if (properties.activityRightField==BW_Seconds) {
			partialFields[2] = rightField;
		}
		else {
			partialFields[2] = null;
		}
		for( var i = 0; i < partialFields.size(); i++ )
		{	
			if ( partialFields[i] != null) {
				hasSeconds = true;
				break;
			}
		}	
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
			for( var i = 0; i < partialFields.size(); i++ ) {
				var f = partialFields[i];
				if (f != null ){ 
					f.partialDraw(faceValue.value(BW_Seconds).format("%02d"), null, true);
				}
			}
		}
	}
}