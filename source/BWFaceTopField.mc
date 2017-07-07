using Toybox.WatchUi as Ui;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class BWFaceTopField extends BWFaceField {

    var font;  
	       
    function initialize(newProperties){
		BWFaceField.initialize({:identifier => "TopField"}, newProperties);	
		font = properties.fonts.weekDayFont;
		System.println("BWFaceTopField font ascent = " + Gfx.getFontAscent(font) + " descent = " + Gfx.getFontDescent(font) + " h = " + Gfx.getFontHeight(font));
    }

    function draw(dc){
    	
		//self.setLocation(0, 0);
    	
		var today = Calendar.info(Time.now(), Time.FORMAT_MEDIUM);
		var day = Lang.format("$1$ $2$",[today.day,today.month]);

		var wdsize = dc.getTextDimensions(today.day_of_week, font);
		var dsize  = dc.getTextDimensions(day, font);
				
		System.println("BWFaceTopField weekday size = " + wdsize + " day size = " + dsize);
		
		var x = dc.getWidth()/2;
		var y = 0;
		var yc = y+wdsize[1]-Gfx.getFontDescent(font);
		dc.setColor(properties.labelColor, Gfx.COLOR_TRANSPARENT);
					
		dc.drawText(x, y,  font, today.day_of_week, Gfx.TEXT_JUSTIFY_CENTER);		
		dc.drawText(x, yc, font, day,               Gfx.TEXT_JUSTIFY_CENTER);
    }
}
