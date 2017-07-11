using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Activity as Act;

class BWFaceMetricField extends BWFaceField {
  
 	protected var dc;
 	protected var drawTopTitles = true;
 	protected var faceValue;
 	protected var title;
 	function initialize(dictionary,newProperties){
		BWFaceField.initialize(dictionary,newProperties);
		dc = properties.dc;
		faceValue = new BWFaceValue(properties);	
		setup();	
 	}
 	
 	
 	function setup(){
 		title = " "+ faceValue.info(properties.metricField)[:title];
 	}
 	
 	function draw(tickPosX,tickPosY){ 	
 	 	
    	var hr    = faceValue.value(properties.metricField); 
    		
		var size      = dc.getTextDimensions(hr, properties.fonts.infoFont);

	 	var x = tickPosX;
 		var y = tickPosY;
		
		dc.setColor(properties.labelColor, Gfx.COLOR_TRANSPARENT);	    	
		dc.drawText(x, y, properties.fonts.infoFont, hr, Gfx.TEXT_JUSTIFY_LEFT);
		
		if (drawTopTitles) {
	    	var xc;
	    	var yc;
	    	if (Sys.getDeviceSettings().screenShape == System.SCREEN_SHAPE_SEMI_ROUND){
	    		xc = x-3;
	    		yc = y + size[1];
	    	}
	    	else {
	    		xc = x+size[0]+properties.fractionNumberPadding;
	    		yc = y+2;
	    	}
			dc.drawText(xc, yc, properties.fonts.infoTitleFontTiny, title, Gfx.TEXT_JUSTIFY_LEFT);
		}
	}
 }