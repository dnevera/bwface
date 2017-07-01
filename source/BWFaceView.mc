using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Application as App;
using Toybox.Activity as Info;
using Toybox.ActivityMonitor as Act;
using Toybox.Sensor as Snsr;
using Toybox.UserProfile as User;

class BWFaceView extends Ui.WatchFace {
        
	var batterySize = [18,9]; 
        
    var iconsFont = null;
        
	var clockFont = null;
	var colonFont = null;
	
	var calendarFont = Gfx.FONT_SYSTEM_LARGE;
	var weekDayFont = Gfx.FONT_SYSTEM_MEDIUM;
	
	var infoFont      = Gfx.FONT_SYSTEM_SMALL;
	var infoTitleFont = Gfx.FONT_SYSTEM_SMALL;
	var infoFractFont = Gfx.FONT_SYSTEM_SMALL;
	var weelDayPadding   = 4;
	var calendarPadding  = 6;
	var clockPadding  = -7;
	var batteryPadding= 4;
	var infoPadding   = 8;
	var activityPadding = 2;
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

	var stepsTitle;
	var caloriesTitle;
	var distanceTitle;
    var userBmr;
    
    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
       
		System.println("dim: w="+dc.getWidth() + " h="+dc.getHeight());

        stepsTitle = Ui.loadResource( Rez.Strings.StepsTitle );
        caloriesTitle = Ui.loadResource( Rez.Strings.CaloriesTitle );
        distanceTitle = Ui.loadResource( Rez.Strings.DistanceTitle );
        
        if (dc.getHeight()<=180){
        	clockFont = Ui.loadResource(Rez.Fonts.digits7monoTinyFont);
        	clockPadding  = -8;
		}
		else if (dc.getWidth()<=218){
        	clockFont = Ui.loadResource(Rez.Fonts.digits7monoSmallFont);
			clockPadding  = -8;
		}
		else {
        	clockFont = Ui.loadResource(Rez.Fonts.digits7monoFont);
        }	
        	
        colonFont = Ui.loadResource(Rez.Fonts.digits7Font);	        
        //iconsFont = Ui.loadResource(Rez.Fonts.iconsFont);
        
        if (dc.getHeight()<=180){
        	//
        	// Use system fonts
        	//
        	weelDayPadding   =  1;
			calendarPadding  = -4;  
			infoPadding   = 8;
			framePadding  = 4;
			frameRadius   = 2;		     
        }
        else if (dc.getWidth()<=218){        	
        	calendarFont   = Ui.loadResource(Rez.Fonts.calendarSmallFont);	
        	weekDayFont    = Ui.loadResource(Rez.Fonts.weekDaySmallFont);
        	infoFont      = Ui.loadResource(Rez.Fonts.infoFont);	
        	infoTitleFont = Ui.loadResource(Rez.Fonts.infoTitleFont);	
        	infoFractFont = Ui.loadResource(Rez.Fonts.infoFractFont);	        	
        }	        
        else {
        	calendarFont   = Ui.loadResource(Rez.Fonts.calendarFont);	
        	weekDayFont    = Ui.loadResource(Rez.Fonts.weekDayFont);
        	infoFont      = Ui.loadResource(Rez.Fonts.infoFont);	
        	infoTitleFont = Ui.loadResource(Rez.Fonts.infoTitleFont);	
        	infoFractFont = Ui.loadResource(Rez.Fonts.infoFractFont);	        	
        }
        	        
        labelColor   = App.getApp().getProperty("ForegroundColor");
        bgColor      = App.getApp().getProperty("BackgroundColor");
        hoursColor   = App.getApp().getProperty("HoursColor");
        colonColor   = App.getApp().getProperty("TimeColonColor");
        minutesColor = App.getApp().getProperty("MinutesColor");
        framesColor  = App.getApp().getProperty("FramesColor");
        batteryLowColor = App.getApp().getProperty("BatteryLowColor");
        batteryWarnColor = App.getApp().getProperty("BatteryWarnColor");
        
        colonSize    = dc.getTextDimensions(colonString, colonFont);
    
        userBmr = bmr();
        System.println("user bmr: " + userBmr);    
    }

	function heatRateDraw(dc) {
    	var info = Info.getActivityInfo();
    	var hr = info.currentHeartRate;    	
    	//System.println("hr:" + hr);    	
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
		dc.drawText(dc.getWidth()/2, weelDayPadding, weekDayFont, today.day_of_week, Gfx.TEXT_JUSTIFY_CENTER);		
		dc.drawText(dc.getWidth()/2, wdsize[1]+calendarPadding, calendarFont, day, Gfx.TEXT_JUSTIFY_CENTER);		
	}

	function clockDraw(dc){
		var clockTime = Sys.getClockTime();
		
		var hours   = clockTime.hour;
		var minutes = clockTime.min;		
		var hformat = "";	
		var ampm    = null;	
        if (!Sys.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
            if ( hours >= 12 ) {
            	ampm = "PM";
            }
            else {
            	ampm = "AM";
            }
        } else {
            if (App.getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
            }
			hformat = "02";		
        }
        
        hours   = hours.format("%"+hformat+"d");
		minutes = minutes.format("%02d");		
		
		var hoursSize = dc.getTextDimensions(hours, clockFont);
		var minutesSize = dc.getTextDimensions(minutes, clockFont);
		
		var x = dc.getWidth()/2;
		var y = dc.getHeight()/2-hoursSize[1]/2-framePadding+clockPadding;
		var yc= dc.getHeight()/2-colonSize[1]/2-framePadding+clockPadding;
		
		dc.setColor(hoursColor, bgColor);
		dc.drawText(x-colonSize[0]-hoursSize[0]+2, y,   clockFont, hours, Gfx.TEXT_JUSTIFY_LEFT);
				
		dc.setColor(colonColor, bgColor);
		dc.drawText(x, yc, colonFont, colonString, Gfx.TEXT_JUSTIFY_CENTER);
	
		dc.setColor(minutesColor, bgColor);
		dc.drawText(x+colonSize[0]+minutesSize[0]-2, y, clockFont, minutes, Gfx.TEXT_JUSTIFY_RIGHT);

		if (ampm!=null){
			dc.setColor(hoursColor, bgColor);
			var ampmsize = dc.getTextDimensions(ampm, infoTitleFont);
			//dc.drawText(x-hoursSize[0]-colonSize[0]-ampmsize[0]/2, dc.getHeight()/2-framePadding+clockPadding, infoTitleFont, ampm, Gfx.TEXT_JUSTIFY_LEFT);
			dc.drawText(framePadding, dc.getHeight()/2-framePadding+clockPadding, infoTitleFont, ampm, Gfx.TEXT_JUSTIFY_LEFT);
		}  
		
		timeUnderLinePos = y+hoursSize[1]+activityPadding+clockPadding;
	}

	var stepDraft = "99999";
		
	function decimals(n,scale){
		var t0=(n.toDouble()-0.5)/1000.0;
		var t1=(n.toDouble()+0.5)/1000.0;
		var fract = ((((t1 - n.toLong()/1000)*1000).toFloat())/scale.toFloat()).toLong();
		return [(t0 - 0.5/1000.0).toLong(),fract]; 
	}
	
	function decFields(n,f,scale,prec){
		if (n==null) {
			return ["--",""];
		} 
		var dec  = decimals(n,scale);	
		return [dec[0].toString(),f+dec[1].format("%0"+prec+"d")];
	}
	
	function bmr(){
		var profile = User.getProfile();		
		var bmrvalue;
		var today = Calendar.info(Time.now(), Time.FORMAT_MEDIUM);
		var w   = profile.weight;
		var h   = profile.height;
		var g   = profile.gender; 
		var age = profile.birthYear;
		
		System.println("profile: gender="+profile.gender+" weight="+profile.weight+", height="+profile.height+", age="+age+" years="+profile.birthYear);
		
		if (g == User.GENDER_FEMALE) {		
			bmrvalue = 655.0 + (9.6*w/1000.0) + (1.8*h) - (4.7*age);
		}
		else {
			bmrvalue = 66 + (13.7*w/1000.0) + (5.0*h) - (6.8*age);
		}		
		return bmrvalue;
	}
	
	function activityDraw(dc) {
		//var info = Info.getActivityInfo();
		var monitor = Act.getInfo();
		
		var calories = decFields(monitor.calories," ",1,3);
		var distance = decFields(monitor.distance.toDouble()/100.0,",",10,2);
		var steps    = monitor.steps == null ? "--" : monitor.steps.format("%02d");
						
		var sSize = dc.getTextDimensions(stepDraft, infoFont);
		sSize[0]=dc.getWidth()/3.2;
		
		var dSize = dc.getTextDimensions(distance[0], infoFont);
		var cSize = dc.getTextDimensions(calories[0], infoFont);
		
		var stepTitleSize = dc.getTextDimensions(stepsTitle, infoTitleFont);
		
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
		dc.drawText(distx-framePadding, timeUnderLinePos+dSize[1], infoTitleFont, distanceTitle, Gfx.TEXT_JUSTIFY_RIGHT);
		
		dc.drawText(stepx, timeUnderLinePos, infoFont, steps, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(stepx, timeUnderLinePos+dSize[1], infoTitleFont, stepsTitle, Gfx.TEXT_JUSTIFY_CENTER);
				
		dc.drawText(caloriesx+framePadding, timeUnderLinePos, infoFont, calories[0], Gfx.TEXT_JUSTIFY_LEFT);
		dc.drawText(caloriesx+framePadding+cSize[0], timeUnderLinePos, infoFractFont, calories[1], Gfx.TEXT_JUSTIFY_LEFT);
		dc.drawText(caloriesx+framePadding, timeUnderLinePos+dSize[1], infoTitleFont, caloriesTitle, Gfx.TEXT_JUSTIFY_LEFT);
		
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
		var y = dc.getHeight() - (dc.getHeight()-infoUnderLinePos-batteryPadding)/2 - h/2 ; //infoUnderLinePos+h/2+batteryPadding;
        
        if (battery>50){
        	dc.setColor(labelColor, bgColor);
        }
        else if (battery>20){
        	dc.setColor(batteryWarnColor, bgColor);
        }
        else {
        	dc.setColor(batteryLowColor, bgColor);
        }
        
        dc.drawRectangle(x+w, y+h/3.0, 2, h/2.0-1);
        dc.drawRoundedRectangle(x, y, w, h, 2);
        dc.fillRoundedRectangle(x, y, w*battery/100, h, 2);
        
        dc.drawText(x+w+framePadding, y-fsize[1]/2+h/2-2, infoTitleFont, fbattery , Gfx.TEXT_JUSTIFY_LEFT);
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
