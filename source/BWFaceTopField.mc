using Toybox.WatchUi as Ui;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class BWFaceTopField extends BWFaceField {

    var font;
    var descent;  
    
	protected var dayPadding = 0;	
	protected var wdsize;
	protected var dsize;
	protected var y;		
	protected var yc;		
	
    function initialize(dictionary,newProperties){
		BWFaceField.initialize(dictionary,newProperties);	
		font = properties.fonts.weekDayFont;
		
		descent = Gfx.getFontDescent(properties.fonts.weekDayFont);
		topY = 0;		
		dayPadding = dictionary[:dayPadding];
		
		wdsize = properties.dc.getTextDimensions("OOOO", properties.fonts.weekDayFont);
		dsize  = properties.dc.getTextDimensions("0 OOO", properties.fonts.weekDayFont);
		yc     = locY+wdsize[1]-descent+dayPadding;
		bottomY = yc + dsize[1];				
    }

    function draw(today){        	
    	var weekDay = today.day_of_week.toString().toUpper();
		var day;									
    	if (System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_SEMI_ROUND){
    		day = Lang.format("$1$$2$",[today.day,today.month]).toUpper();
    	}
    	else {
    		day = Lang.format("$1$ $2$",[today.day,today.month]).toUpper();
    	}
    	
		/*var descent = Gfx.getFontDescent(properties.fonts.weekDayFont);
		var topY = 0;		
		var dayPadding = dictionary[:dayPadding];
		
		var wdsize  = properties.dc.getTextDimensions("OOOO", properties.fonts.weekDayFont);
		var dsize   = properties.dc.getTextDimensions("0 OOO", properties.fonts.weekDayFont);
		var yc      = locY+wdsize[1]-descent+dayPadding;
		var bottomY = yc + dsize[1];	*/			
    	
		properties.dc.setColor(properties.labelColor, Gfx.COLOR_TRANSPARENT);				
		properties.dc.drawText(locX, locY,  properties.fonts.weekDayFont, weekDay, Gfx.TEXT_JUSTIFY_CENTER);		
		properties.dc.drawText(locX, yc, properties.fonts.weekDayFont, day,     Gfx.TEXT_JUSTIFY_CENTER);
    }
}
