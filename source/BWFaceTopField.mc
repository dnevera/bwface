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
		
		descent = Gfx.getFontDescent(font);
		topY = 0;		
		dayPadding = dictionary[:dayPadding];
		
		wdsize = properties.dc.getTextDimensions("OOOO", font);
		dsize  = properties.dc.getTextDimensions("0 OOO", font);
		y      = locY;		
		yc     = y+wdsize[1]-descent+dayPadding;
		bottomY = yc + dsize[1];				
    }

    function draw(today){        	
		var day = Lang.format("$1$ $2$",[today.day,today.month]);									
		properties.dc.setColor(properties.labelColor, Gfx.COLOR_TRANSPARENT);				
		properties.dc.drawText(locX, y,  font, today.day_of_week, Gfx.TEXT_JUSTIFY_CENTER);		
		properties.dc.drawText(locX, yc, font, day,               Gfx.TEXT_JUSTIFY_CENTER);
    }
}
