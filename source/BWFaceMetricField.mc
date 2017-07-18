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
 	 	
    	var hr  = faceValue.value(properties.metricField); 
		if (!(hr instanceof Toybox.Lang.String)) {
			hr = hr.format(faceValue.info(properties.metricField)[:format]); 
		}    		
		
		var right = null;
		if ((Toybox.WatchUi.WatchFace has :onPartialUpdate ) && properties.getProperty("CaloriesBarGraphsOn", false) ){
			if (hr.length()>3){
				right = hr.substring(1,hr.length());	
				hr = hr.substring(0,1);
			}
		}
		
		var size      = dc.getTextDimensions(hr, properties.fonts.infoFont);
				
	 	var x = tickPosX;
 		var y = tickPosY;
		
		dc.setColor(properties.labelColor, Gfx.COLOR_TRANSPARENT);	    	
		dc.drawText(x, y, properties.fonts.infoFont, hr, Gfx.TEXT_JUSTIFY_LEFT);
		if (right!=null){
			var sizer  = dc.getTextDimensions(right, properties.fonts.infoFractFont);
			dc.drawText(x+size[0]+1, y+size[1]-sizer[1], properties.fonts.infoFractFont, right, Gfx.TEXT_JUSTIFY_LEFT);
		}
		
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
			
			dc.setColor(properties.bgColor, Gfx.COLOR_TRANSPARENT);
			dc.drawText(xc-1, yc-1, properties.fonts.infoTitleFontTiny, title, Gfx.TEXT_JUSTIFY_LEFT);
			dc.drawText(xc+1, yc+1, properties.fonts.infoTitleFontTiny, title, Gfx.TEXT_JUSTIFY_LEFT);
			dc.drawText(xc-1, yc+1, properties.fonts.infoTitleFontTiny, title, Gfx.TEXT_JUSTIFY_LEFT);
			dc.drawText(xc+1, yc-1, properties.fonts.infoTitleFontTiny, title, Gfx.TEXT_JUSTIFY_LEFT);
			
			dc.setColor(properties.labelColor, Gfx.COLOR_TRANSPARENT);
			dc.drawText(xc, yc, properties.fonts.infoTitleFontTiny, title, Gfx.TEXT_JUSTIFY_LEFT);	    			
		}
		
		bottomY = y;
	}
 }