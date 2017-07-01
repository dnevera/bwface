using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Application as App;
using Toybox.Activity as Info;
using Toybox.ActivityMonitor as Act;
using Toybox.Sensor as Snsr;

class BWFaceView extends Ui.WatchFace {
        
	var batterySize = [18,9]; 
        
    var iconsFont = null;
        
	var digitsFont = null;
	var digitsMonoFont = null;
	var calendarFont = Gfx.FONT_SYSTEM_LARGE;
	var weekDayFont = Gfx.FONT_SYSTEM_MEDIUM;
	
	var infoFont      = Gfx.FONT_SYSTEM_SMALL;
	var infoTitleFont = Gfx.FONT_SYSTEM_SMALL;
	var infoFractFont = Gfx.FONT_SYSTEM_SMALL;
	var clockPadding  = -12;
	var infoPadding   = 8;
	var framePadding  = 4;
	var frameRadius   = 4;
	
	var labelColor = null;
	var hoursColor = null;
	var colonColor = null;
	var minutesColor = null;
	var bgColor = null;
	var framesColor = null;
	var batteryLowColor = null;
	var batteryWarnColor = null;
	
	var colonString  = ":";
    var colonSize = 10;
    
    var timeUnderLinePos;
    var infoUnderLinePos;
    
    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
        
        iconsFont      = Ui.loadResource(Rez.Fonts.iconsFont);	        
        digitsFont     = Ui.loadResource(Rez.Fonts.digits7Font);	
        digitsMonoFont = Ui.loadResource(Rez.Fonts.digits7monoFont);	
        calendarFont   = Ui.loadResource(Rez.Fonts.calendarFont);	
        weekDayFont    = Ui.loadResource(Rez.Fonts.weekDayFont);
        	
        infoFont      = Ui.loadResource(Rez.Fonts.infoFont);	
        infoTitleFont = Ui.loadResource(Rez.Fonts.infoTitleFont);	
        infoFractFont = Ui.loadResource(Rez.Fonts.infoFractFont);	
        
        labelColor   = App.getApp().getProperty("ForegroundColor");
        bgColor      = App.getApp().getProperty("BackgroundColor");
        hoursColor   = App.getApp().getProperty("HoursColor");
        colonColor   = App.getApp().getProperty("TimeColonColor");
        minutesColor = App.getApp().getProperty("MinutesColor");
        framesColor  = App.getApp().getProperty("FramesColor");
        batteryLowColor = App.getApp().getProperty("BatteryLowColor");
        batteryWarnColor = App.getApp().getProperty("BatteryWarnColor");
        
        colonSize    = dc.getTextDimensions(colonString, digitsFont);
    
    }

	function heatRateDraw(dc) {
    	var info = Info.getActivityInfo();
    	var hr = info.currentHeartRate;    	
    	System.println("hr:" + hr);    	
    }

	function calendarDraw(dc){
		var today = Calendar.info(Time.now(), Time.FORMAT_MEDIUM);
		var day = Lang.format(
    		"$1$/$2$",
    		[
        	today.day,
        	today.month
    	]
		);

		var dsize = dc.getTextDimensions(day, calendarFont);
		var wdsize = dc.getTextDimensions(today.day_of_week, weekDayFont);
		
		dc.setColor(labelColor, bgColor);
		dc.drawText(dc.getWidth()/2, wdsize[1]+2, calendarFont, day, Gfx.TEXT_JUSTIFY_CENTER);		
		dc.drawText(dc.getWidth()/2, 2, weekDayFont, today.day_of_week, Gfx.TEXT_JUSTIFY_CENTER);		
	}

	function clockDraw(dc){
		var clockTime = Sys.getClockTime();
		
		var hours   = clockTime.hour;
		var minutes = clockTime.min;		
		
        if (!Sys.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (App.getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
            }
        }
        
        hours   = hours.format("%02d");
		minutes = minutes.format("%02d");		
		
		var hoursSize = dc.getTextDimensions(hours, digitsMonoFont);
		var minutesSize = dc.getTextDimensions(minutes, digitsMonoFont);
		
		var x = dc.getWidth()/2;
		var y = dc.getHeight()/2-hoursSize[1]/2-framePadding+clockPadding;
		var yc= dc.getHeight()/2-colonSize[1]/2-framePadding+clockPadding;
		
		dc.setColor(hoursColor, bgColor);
		dc.drawText(x-colonSize[0]-hoursSize[0]+2, y,   digitsMonoFont, hours, Gfx.TEXT_JUSTIFY_LEFT);

		dc.setColor(colonColor, bgColor);
		dc.drawText(x, yc, digitsFont, colonString, Gfx.TEXT_JUSTIFY_CENTER);
	
		dc.setColor(minutesColor, bgColor);
		dc.drawText(x+colonSize[0]+minutesSize[0]-2, y, digitsMonoFont, minutes, Gfx.TEXT_JUSTIFY_RIGHT);

		timeUnderLinePos = x+hoursSize[1]/2-infoPadding+clockPadding;
	}

	var stepTitle = "шагов";
	var stepDraft = "99999";
		
	function decimals(n){
		var t0=(n.toDouble()-0.5)/1000.0;
		var t1=(n.toDouble()+0.5)/1000.0;
		return [(t0 - 0.5/1000.0).toLong(),((t1 - n.toLong()/1000)*1000).toLong()]; 
	}
	
	function decFields(n){
		if (n==null) {
			return ["--",""];
		} 
		var dec  = decimals(n);	
		return [dec[0].toString(),","+dec[1].toString()];
	}
	
	function activityDraw(dc) {
		var info = Info.getActivityInfo();
		var monitor = Act.getInfo();
		
		var calories = decFields(info.calories);//info.calories == null ? "--" : info.calories.format("%02d");
		var distance = decFields(monitor.distance);
		var steps    = monitor.steps == null ? "--" : monitor.steps.format("%02d");
				
		System.println("dist:" + distance[0] + distance[1] + " .. calories = "+info.calories);
		
		var sSize = dc.getTextDimensions(stepDraft, infoFont);
		var dSize = dc.getTextDimensions(distance[0], infoFont);
		var cSize = dc.getTextDimensions(calories[0], infoFont);
		
		var stepTitleSize = dc.getTextDimensions(stepTitle, infoTitleFont);
		
		var distx = dc.getWidth()/2-sSize[0]/2-infoPadding;
		var caloriesx = dc.getWidth()/2+sSize[0]/2+infoPadding;
		var stepx = dc.getWidth()/2+1;
		var stepy = timeUnderLinePos;
		var stepw = sSize[0]+framePadding;
		var stepTitlew = stepTitleSize[0]+framePadding;
		var steph = sSize[1]+framePadding + stepTitleSize[1]; 
		
		stepw = stepw>stepTitlew ? stepw : stepTitlew;
		
		dc.setColor(labelColor, bgColor);
		
		var size = dc.getTextDimensions(distance[1], infoFractFont);
		
		dc.drawText(distx-framePadding-size[0], timeUnderLinePos, infoFont, distance[0], Gfx.TEXT_JUSTIFY_RIGHT);
		dc.drawText(distx-framePadding, timeUnderLinePos, infoFractFont, distance[1], Gfx.TEXT_JUSTIFY_RIGHT);
		dc.drawText(distx-framePadding, timeUnderLinePos+dSize[1], infoTitleFont, "km", Gfx.TEXT_JUSTIFY_RIGHT);
		
		dc.drawText(stepx, timeUnderLinePos, infoFont, steps, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(stepx, timeUnderLinePos+dSize[1], infoTitleFont, stepTitle, Gfx.TEXT_JUSTIFY_CENTER);
				
		dc.drawText(caloriesx+framePadding, timeUnderLinePos, infoFont, calories[0], Gfx.TEXT_JUSTIFY_LEFT);
		dc.drawText(caloriesx+framePadding+cSize[0], timeUnderLinePos, infoFractFont, calories[1], Gfx.TEXT_JUSTIFY_LEFT);
		dc.drawText(caloriesx+framePadding, timeUnderLinePos+dSize[1], infoTitleFont, "kCal", Gfx.TEXT_JUSTIFY_LEFT);
		
		dc.setColor(framesColor, bgColor);
		
		var frameH = steph+1;
		dc.drawRoundedRectangle(stepx-(stepw+framePadding)/2, stepy, stepw+framePadding/2, frameH, frameRadius);
				
		var dh = dc.getWidth()/2-(stepw+framePadding)/2;
		dc.drawRoundedRectangle(0,         stepy, dh,         frameH, frameRadius);		

		var cx = stepx-(stepw+framePadding)/2 + stepw+framePadding/2+1;
		dc.drawRoundedRectangle(cx, stepy, dc.getWidth(), frameH, frameRadius);
		
		infoUnderLinePos = stepy +  frameH;
	}

	function sysInfoDraw(dc) {
	
		var systemStats = Sys.getSystemStats();
		var battery = systemStats.battery;
        var fbattery =  battery.format("%d") + "%";
        var fsize = dc.getTextDimensions(fbattery, infoTitleFont);
		var w = batterySize[0];
		var h = batterySize[1];
        var x = dc.getWidth()/2-w/2-fsize[0]/2;
		var y = infoUnderLinePos+h/2+2;
        
        if (battery>50){
        	dc.setColor(labelColor, bgColor);
        }
        else if (battery>20){
        	dc.setColor(batteryWarnColor, bgColor);
        }
        else {
        	dc.setColor(batteryLowColor, bgColor);
        }
        
        dc.drawRectangle(x+w, y+h/3.0, 1.5, h/2.0-1);
        dc.drawRoundedRectangle(x, y, w, h, 2);
        dc.fillRoundedRectangle(x, y, w*battery/100, h, 2);
        
        dc.drawText(x+w+framePadding, y-fsize[1]/2+h/2-2, infoTitleFont,fbattery , Gfx.TEXT_JUSTIFY_LEFT);
	}

    function onUpdate(dc) {
    	dc.setColor(bgColor, bgColor);
		dc.clear();
	    clockDraw(dc); 
	    calendarDraw(dc);
	    activityDraw(dc);
	    sysInfoDraw(dc);
	    heatRateDraw(dc);       
    }

    function onShow() {}

    function onHide() {}

    function onExitSleep() {}

    function onEnterSleep() {}
    
}
