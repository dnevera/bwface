using Toybox.WatchUi as Ui;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class BWFaceTopField extends BWFaceField {

    var font;
    var descent;
    
	protected var dayPadding = 0;	
	protected var y;
	protected var yc;		
	
    function initialize(dictionary,newProperties){
		BWFaceField.initialize(dictionary,newProperties);	
		font = properties.fonts.weekDayFont;
		
		descent = Gfx.getFontDescent(properties.fonts.weekDayFont);
		topY = 0;		
		dayPadding = dictionary[:dayPadding];

        var wdsize = properties.dc.getTextDimensions("OOOO", properties.fonts.weekDayFont);
		var dsize  = properties.dc.getTextDimensions("00 OOO", properties.fonts.weekDayFont);
		yc     = locY+wdsize[1]-descent+dayPadding;
		bottomY = yc + dsize[1];				
    }

    function draw(today){

        var months = Ui.loadResource(Rez.Strings.Months);
        var weekDays = Ui.loadResource(Rez.Strings.WeekDays);

        var ss = "";

        var topFont;
        var topY = locY;

    	var weekDay = 4*(today.day_of_week-1);
        var month = 5*(today.month-1);

        month   = months.substring(month,month+5);
        var s = month.find(" ");
        if (s != null){
            month = month.substring(0,s);
        }

        weekDay = weekDays.substring(weekDay,weekDay+4);
        s = weekDay.find(" ");
        if (s != null){
            weekDay = weekDay.substring(0,s);
        }

		var day;
    	if (System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_SEMI_ROUND
    	||
    	properties.getProperty("DateFieldType", 100) == 100
    	){
    	    ss = weekDay.toString().toUpper();
    		day = Lang.format("$1$ $2$",[today.day,month]).toUpper();
    		topFont = properties.fonts.weekDayFont;
    	}
    	else {
    		day = Lang.format("$1$ $2$ $3$",[weekDay, today.day,month]).toUpper();
            var pv = new BWFaceValue(properties);
            ss = pv.value(BW_Sunrise).toString().toUpper();
            ss += "  " + pv.value(BW_Sunset).toString().toUpper();
            topFont = properties.fonts.infoFractFont;
            var dsize  = properties.dc.getTextDimensions(day, topFont);
            topY = locY+properties.sunHoursPadding;//-properties;
    	}

		properties.dc.setColor(properties.labelColor, Gfx.COLOR_TRANSPARENT);				
		properties.dc.drawText(locX, topY,  topFont, ss, Gfx.TEXT_JUSTIFY_CENTER);
		properties.dc.drawText(locX, yc, properties.fonts.weekDayFont, day,     Gfx.TEXT_JUSTIFY_CENTER);
    }
}
