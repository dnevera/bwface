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

 	var string_HR;
    var HR_graph;
        
    var iconsFont = null;
        
	var digitsFont = null;
	var digitsMonoFont = null;
	var calendarFont = Gfx.FONT_SYSTEM_LARGE;
	var weekDayFont = Gfx.FONT_SYSTEM_MEDIUM;
	
	var infoFont      = Gfx.FONT_SYSTEM_SMALL;
	var infoTitleFont = Gfx.FONT_SYSTEM_SMALL;
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
        //Snsr.setEnabledSensors( [Snsr.SENSOR_HEARTRATE] );
        //Snsr.enableSensorEvents( method(:onSnsr) );  
        //HR_graph = new LineGraph( 20, 10, Gfx.COLOR_RED );     
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
    	
        /*dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();

        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );

        dc.drawText(dc.getWidth() / 2, 90, Gfx.FONT_LARGE, string_HR, Gfx.TEXT_JUSTIFY_CENTER);*/

        //HR_graph.draw(dc, [0, 0], [dc.getWidth(), dc.getHeight()]);
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
		/*var caledar = Lang.format(
    		"$1$ $2$/$3$",
    		[
        	today.day_of_week,
        	today.day,
        	today.month
    	]
		);*/

		var dsize = dc.getTextDimensions(day, calendarFont);
		var wdsize = dc.getTextDimensions(today.day_of_week, weekDayFont);

		System.println("size:" + dsize);
		System.println("date:" + day);
		
		dc.setColor(labelColor, bgColor);
		dc.drawText(dc.getWidth()/2, wdsize[1]+2, calendarFont, day, Gfx.TEXT_JUSTIFY_CENTER);		
		dc.drawText(dc.getWidth()/2, 2, weekDayFont, today.day_of_week, Gfx.TEXT_JUSTIFY_CENTER);		
	}

	function clockDraw(dc){
		var clockTime = Sys.getClockTime();
		
		 var hours = clockTime.hour;
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
		var minutes = clockTime.min.format("%02d");		
		
		var hoursSize = dc.getTextDimensions(hours, digitsMonoFont);
		dc.setColor(hoursColor, bgColor);
		dc.drawText(dc.getWidth()/2-colonSize[0]-hoursSize[0], dc.getHeight()/2-hoursSize[1]/2, digitsMonoFont, hours, Gfx.TEXT_JUSTIFY_LEFT);

		dc.setColor(colonColor, bgColor);
		dc.drawText(dc.getWidth()/2, dc.getHeight()/2-colonSize[1]/2, digitsFont, colonString, Gfx.TEXT_JUSTIFY_CENTER);
	
		var minutesSize = dc.getTextDimensions(minutes, digitsMonoFont);
		dc.setColor(minutesColor, bgColor);
		dc.drawText(dc.getWidth()/2+colonSize[0]+minutesSize[0], dc.getHeight()/2-minutesSize[1]/2, digitsMonoFont, minutes, Gfx.TEXT_JUSTIFY_RIGHT);

		timeUnderLinePos = dc.getHeight()/2+hoursSize[1]/2;
	}

	var stepTitle = "steps";
	
	function activityDraw(dc) {
		var info = Info.getActivityInfo();
		var monitor = Act.getInfo();
		var calories = info.calories == null ? "--" : info.calories.format("%02d"); 
		var dist     = monitor.steps == null ? "--" : (monitor.distance/100/1000).format("%02d");
		var steps    = monitor.steps == null ? "--" : monitor.steps.format("%02d");
		
		var dSize = dc.getTextDimensions(dist, infoFont);
		var sSize = dc.getTextDimensions(steps, infoFont);
		var cSize = dc.getTextDimensions(calories, infoFont);
		
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
		
		dc.drawText(distx-framePadding, timeUnderLinePos, infoFont, dist, Gfx.TEXT_JUSTIFY_RIGHT);
		dc.drawText(distx-framePadding, timeUnderLinePos+dSize[1], infoTitleFont, "km", Gfx.TEXT_JUSTIFY_RIGHT);
		
		dc.drawText(stepx, timeUnderLinePos, infoFont, steps, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(stepx, timeUnderLinePos+dSize[1], infoTitleFont, stepTitle, Gfx.TEXT_JUSTIFY_CENTER);
		
		dc.drawText(caloriesx+framePadding, timeUnderLinePos, infoFont, calories, Gfx.TEXT_JUSTIFY_LEFT);
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
		var size = [20,20]; //dc.getTextDimensions("d", iconsFont);
        var fbattery =  battery.format("%d") + "%";
        var fsize = dc.getTextDimensions(fbattery, infoTitleFont);
		var w = size[0];
		var h = size[1]/2;
        var x = dc.getWidth()/2-w/2-fsize[0]/2;
		var y = infoUnderLinePos+h/2+2;
		//dc.drawText( x, y, iconsFont, "d",  Gfx.TEXT_JUSTIFY_LEFT);
        //dc.fillRectangle(x, y, w*battery/100-2, h/2);
        
        if (battery>50){
        	dc.setColor(labelColor, bgColor);
        }
        else if (battery>20){
        	dc.setColor(batteryWarnColor, bgColor);
        }
        else {
        	dc.setColor(batteryLowColor, bgColor);
        }
        
        dc.drawRectangle(x+w, y+h/3, 2, h/2-1);
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

    function onShow() {
    }

    function onHide() {
    }

    function onExitSleep() {
    }

    function onEnterSleep() {
    }
    
     function onSnsr(sensor_info)
    {
        var HR = sensor_info.heartRate;
        var bucket;
        if( sensor_info.heartRate != null )
        {
            string_HR = HR.toString() + "bpm";

            //Add value to graph
            HR_graph.addItem(HR);
        }
        else
        {
            string_HR = "---bpm";
        }

        Ui.requestUpdate();
    }
    
}
