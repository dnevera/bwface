using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Application as App;
using Toybox.Activity as Info;
using Toybox.ActivityMonitor as Monitor;
using Toybox.Sensor as Snsr;
using Toybox.UserProfile as User;
using Toybox.Math as Math;

class BWFaceView extends Ui.WatchFace {
        
	var batterySize = [18,9]; 
        
	var clockFont    = Gfx.FONT_SYSTEM_NUMBER_THAI_HOT;	
	var calendarFont = Gfx.FONT_SYSTEM_LARGE;
	var weekDayFont  = Gfx.FONT_SYSTEM_MEDIUM;
	
	var infoFont      = Gfx.FONT_SYSTEM_SMALL;
	var infoTitleFont = Gfx.FONT_SYSTEM_SMALL;
	var infoFractFont = Gfx.FONT_SYSTEM_SMALL;
	
	var weekDayPadding   =  2;
	var calendarPadding  =  2;
	var clockPadding     = -2;
	var batteryPadding   = -4;
	var infoPadding      =  4;
	var activityPadding  = -8;
	var framePadding     =  4;
	var frameRadius      =  4;
	var caloriesCircleTickWidth = 12;
	var caloriesCircleWidth     = 6;
	
	var surplusColor = Gfx.COLOR_RED;
	var deficitColor = Gfx.COLOR_DK_GREEN;
	var labelColor = null;
	var hoursColor = null;
	var colonColor = null;
	var minutesColor = null;
	var bgColor = null;
	var framesColor = null;
	var batteryLowColor = null;
	var batteryWarnColor = null;
	    
    var timeUnderLinePos;
    var timeAboveLinePos;
    var infoUnderLinePos;

	var stepsTitle;
	var caloriesTitle;
	var distanceTitle;
	var bpmTitle;
    var userBmr;
    
    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
              
       	//setLayout(Rez.Layouts.WatchFace(dc));
              
        stepsTitle = Ui.loadResource( Rez.Strings.StepsTitle );
        caloriesTitle = Ui.loadResource( Rez.Strings.CaloriesTitle );
        distanceTitle = Ui.loadResource( Rez.Strings.DistanceTitle );
        bpmTitle = Ui.loadResource( Rez.Strings.BPMTitle );
        
        if (dc.getHeight()<=180){
        	clockFont = Ui.loadResource(Rez.Fonts.clockFontTiny);
        	clockPadding  = -7;
		}
		else if (dc.getWidth()<=218){
        	clockFont = Ui.loadResource(Rez.Fonts.clockFontSmall);
			clockPadding  = -7;
		}
		else {
        	clockFont = Ui.loadResource(Rez.Fonts.clockFont);
        }	
        	
        if (dc.getHeight()<=180){
        	//
        	// Use system fonts
        	//
        	calendarFont = Gfx.FONT_SYSTEM_MEDIUM;
			weekDayFont  = Gfx.FONT_SYSTEM_MEDIUM;
        	
        	weekDayPadding   =  1;
			calendarPadding  = -3;  
			infoPadding   = 8;
			framePadding  = 4;
			frameRadius   = 2;		     
        }
        else if (dc.getWidth()<=218){        	
        	calendarFont  = Ui.loadResource(Rez.Fonts.calendarSmallFont);	
        	weekDayFont   = Ui.loadResource(Rez.Fonts.weekDaySmallFont);
        	infoFont      = Ui.loadResource(Rez.Fonts.infoFont);	
        	infoTitleFont = Ui.loadResource(Rez.Fonts.infoTitleFont);	
        	infoFractFont = Ui.loadResource(Rez.Fonts.infoFractFont);	        	
        }	        
        else {
        	calendarFont  = Ui.loadResource(Rez.Fonts.calendarFontLarge);	
        	weekDayFont   = calendarFont; //Ui.loadResource(Rez.Fonts.weekDayFont);
        	infoFont      = Ui.loadResource(Rez.Fonts.infoFont);	
        	infoTitleFont = Ui.loadResource(Rez.Fonts.infoTitleFont);	
        	infoFractFont = Ui.loadResource(Rez.Fonts.infoFractFont);	        	
        }

        surplusColor = App.getApp().getProperty("SurplusColor");
        deficitColor = App.getApp().getProperty("DeficitColor");
        	        
        labelColor   = App.getApp().getProperty("ForegroundColor");
        bgColor      = App.getApp().getProperty("BackgroundColor");
        hoursColor   = App.getApp().getProperty("HoursColor");
        colonColor   = App.getApp().getProperty("TimeColonColor");
        minutesColor = App.getApp().getProperty("MinutesColor");
        framesColor  = App.getApp().getProperty("FramesColor");
        batteryLowColor = App.getApp().getProperty("BatteryLowColor");
        batteryWarnColor = App.getApp().getProperty("BatteryWarnColor");
            
        userBmr = bmr();
    }

	
	function calendarDraw(dc){
		var today = Calendar.info(Time.now(), Time.FORMAT_MEDIUM);
		var day = Lang.format("$1$ $2$",[today.day,today.month]);

		var wdsize = dc.getTextDimensions(today.day_of_week, weekDayFont);
		var dsize  = dc.getTextDimensions(day, calendarFont);
		
		var x = dc.getWidth()/2;
		var y =  weekDayPadding+caloriesCircleWidth;
		var yc = y+wdsize[1]+calendarPadding;
		dc.setColor(labelColor, Gfx.COLOR_TRANSPARENT);
		
		dc.drawText(x, y,  weekDayFont,  today.day_of_week, Gfx.TEXT_JUSTIFY_CENTER);		
		dc.drawText(x, yc, calendarFont, day,               Gfx.TEXT_JUSTIFY_CENTER);		
		//dc.drawText(dc.getWidth()/2, wdsize[1]+calendarPadding, calendarFont, day, Gfx.TEXT_JUSTIFY_CENTER);
		
		timeAboveLinePos = yc+dsize[1];  		
	}

	function clockDraw(dc){
		var clockTime = Sys.getClockTime();
		
		var hours   = clockTime.hour;
		var minutes = clockTime.min;		
		var hformat = "";	
		var ampm    = null;	
        if (!Sys.getDeviceSettings().is24Hour) {
            if ( hours >= 12 ) {
            	ampm = "PM";
            }
            else {
            	ampm = "AM";
            }
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (App.getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
            }
			hformat = "02";		
        }
        
        hours   = hours.format("%"+hformat+"d");
		minutes = minutes.format("%02d");		
		
		var hoursSize   = dc.getTextDimensions(hours, clockFont);
		var minutesSize = dc.getTextDimensions(minutes, clockFont);
		
		var x = dc.getWidth()/2;
		var y = dc.getHeight()/2-hoursSize[1]/2-framePadding+clockPadding;		
		
		var colonSize = [12,22,8,8,1];
		var yc= dc.getHeight()/2-colonSize[1]/2-framePadding+clockPadding;
		
		dc.setColor(colonColor, Gfx.COLOR_TRANSPARENT);
		dc.fillRectangle(x-colonSize[2]/2, yc,              colonSize[2], colonSize[3]);
		dc.fillRectangle(x-colonSize[2]/2, yc+colonSize[1], colonSize[2], colonSize[3]);
		
		dc.setColor(hoursColor, Gfx.COLOR_TRANSPARENT);
		dc.drawText(x-colonSize[0]-hoursSize[0], y, clockFont, hours, Gfx.TEXT_JUSTIFY_LEFT);
				
		dc.setColor(minutesColor, Gfx.COLOR_TRANSPARENT);
		dc.drawText(x+colonSize[0]-colonSize[4], y, clockFont, minutes, Gfx.TEXT_JUSTIFY_LEFT);

		if (ampm!=null){
			dc.setColor(hoursColor, Gfx.COLOR_TRANSPARENT);
			var ampmsize = dc.getTextDimensions(ampm, infoTitleFont);
			dc.drawText(framePadding+caloriesCircleWidth, 
			dc.getHeight()/2-framePadding+clockPadding, infoTitleFont, ampm, Gfx.TEXT_JUSTIFY_LEFT);
		}  
		
		timeUnderLinePos = y+hoursSize[1]+activityPadding+clockPadding;
		//timeAboveLinePos = y - activityPadding + clockPadding; //dc.getHeight()/2-hoursSize[1]/2+framePadding;
		
		timeAboveLinePos += (y-timeAboveLinePos)/2;
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
		var today = Calendar.info(Time.now(), Time.FORMAT_LONG);
		var w   = profile.weight;
		var h   = profile.height;
		var g   = profile.gender; 
		var birthYear = profile.birthYear;
		if (birthYear<100) {
		    // simulator
			birthYear = 1900+birthYear;
		}
		var age = today.year - birthYear;
				
		if (g == User.GENDER_FEMALE) {		
			bmrvalue = 655.0 + (9.6*w/1000.0) + (1.8*h) - (4.7*age);
		}
		else {
			bmrvalue = 66 + (13.7*w/1000.0) + (5.0*h) - (6.8*age);
		}		
		return bmrvalue;
	}
	
	var currentCalories;
	
	function activityDraw(dc) {
		var monitor = Monitor.getInfo(); 
		
		currentCalories = monitor.calories;
		var calories = decFields(currentCalories," ",1,3);
		var distance = decFields(monitor.distance.toDouble()/100.0,",",10,2);
		var steps    = monitor.steps == null ? "--" : monitor.steps.format("%02d");
						
		var sSize = dc.getTextDimensions(stepDraft, infoFont);
		sSize[0]=dc.getWidth()/3.5;
		
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
		
		dc.setColor(labelColor, Gfx.COLOR_TRANSPARENT);
		
		var size = dc.getTextDimensions(distance[1], infoFractFont);
		
		dc.drawText(distx-framePadding-size[0], timeUnderLinePos, infoFont, distance[0], Gfx.TEXT_JUSTIFY_RIGHT);
		dc.drawText(distx-framePadding, timeUnderLinePos, infoFractFont, distance[1], Gfx.TEXT_JUSTIFY_RIGHT);
		dc.drawText(distx-framePadding, timeUnderLinePos+dSize[1], infoTitleFont, distanceTitle, Gfx.TEXT_JUSTIFY_RIGHT);
		
		dc.drawText(stepx, timeUnderLinePos, infoFont, steps, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(stepx, timeUnderLinePos+dSize[1], infoTitleFont, stepsTitle, Gfx.TEXT_JUSTIFY_CENTER);
				
		dc.drawText(caloriesx+framePadding, timeUnderLinePos, infoFont, calories[0], Gfx.TEXT_JUSTIFY_LEFT);
		dc.drawText(caloriesx+framePadding+cSize[0], timeUnderLinePos, infoFractFont, calories[1], Gfx.TEXT_JUSTIFY_LEFT);
		dc.drawText(caloriesx+framePadding, timeUnderLinePos+dSize[1], infoTitleFont, caloriesTitle, Gfx.TEXT_JUSTIFY_LEFT);
		
		dc.setColor(framesColor, Gfx.COLOR_TRANSPARENT);
		
		var frameH = steph+1;
		dc.drawRoundedRectangle(stepx-(stepw+framePadding)/2, stepy, stepw+framePadding/2, frameH, frameRadius);
				
		var dh = dc.getWidth()/2-(stepw+framePadding)/2;
		dc.drawRoundedRectangle(0,         stepy, dh,         frameH, frameRadius);		

		var cx = stepx-(stepw+framePadding)/2 + stepw+framePadding/2+1;
		dc.drawRoundedRectangle(cx, stepy, dc.getWidth(), frameH, frameRadius);
		
		infoUnderLinePos = stepy +  frameH;
					
	}
	
	var caloriesLinePos;
	var caloriesOffsetPos;
	function caloriesRestDraw(dc, calories) {
	
		var cl = calories - userBmr;
		var isDeficit =  cl>=0;
		var prcnt = cl/userBmr;
		
		var color = isDeficit ? deficitColor : surplusColor ;
		
		cl = cl.abs();
		
		//var fixed = userBmr.format("%d")+" BRM";
		//var txt = userBmr.format("%d") + " " + cl.format("%d") + " " + prcnt.format("%.2f");
		
		//System.println( userBmr.format("%d") + " " + cl.format("%d") + " " + prcnt.format("%.2f"));
		
		var txt = cl.format("%d")+" "+caloriesTitle;
		var size = dc.getTextDimensions(txt, infoTitleFont);	
	
		var x = dc.getWidth().toFloat()/2;
		var y = dc.getHeight().toFloat()/2;
		var r = x-caloriesCircleWidth/2;
		
		var tickW = caloriesCircleTickWidth;
		//var txtY  = y - timeAboveLinePos+size[1]/2+caloriesCircleWidth/2;
		var txtY  = timeAboveLinePos+size[1]; //y - timeAboveLinePos+caloriesCircleWidth/2;
		var cat   = y - txtY + caloriesCircleWidth/2-0.5;
		
		var sin   = cat.toFloat()/r.toFloat();
		var angle = Math.asin(sin);
		
		var circleX = Math.cos(angle)*r+x;
		var txtX = circleX-size[0]-tickW;
				
		var s = angle*180.0/Math.PI;
								
		dc.setColor(color,  Gfx.COLOR_TRANSPARENT);
		dc.setPenWidth(caloriesCircleWidth*2);
				
		var start;
		var end;
		var dir;
		if (isDeficit) {
			start = s;
			end   = s-360*prcnt.abs();
			dir =  Gfx.ARC_CLOCKWISE;
		}
		else {
			start = 360-360*prcnt.abs()+s;
			end = 360 + s;
			dir =  Gfx.ARC_COUNTER_CLOCKWISE;
		}
				
		dc.drawArc(x, y, r+caloriesCircleWidth/2, dir, start, end);

		// pseudo antialiasing
		dc.setPenWidth(1);

		dc.setColor(bgColor,  bgColor);
		dc.drawArc(x, y, r-caloriesCircleWidth/2, dir, start, end);
							
		caloriesLinePos = txtY-size[1]/2-2;
		
		dc.setColor(color,  Gfx.COLOR_TRANSPARENT);
		dc.setPenWidth(caloriesCircleWidth-1);
		dc.drawLine(circleX-tickW, txtY, dc.getWidth()-1, txtY);

		dc.setColor(labelColor,  Gfx.COLOR_TRANSPARENT);
		dc.drawText(txtX-caloriesCircleWidth, caloriesLinePos, infoTitleFont, txt, Gfx.TEXT_JUSTIFY_LEFT);

		dc.setPenWidth(1);		
		caloriesOffsetPos = dc.getWidth()-(txtX+size[0]);
	}
	
	function heatRateDraw(dc) {
	
    	var info = Info.getActivityInfo();
    	var hr = info.currentHeartRate;
    	hr = hr == null ? "-- " + bpmTitle : hr.format("%d")+ " " + bpmTitle;    	
    	
    	dc.setColor(labelColor, Gfx.COLOR_TRANSPARENT);	
		dc.drawText(caloriesOffsetPos+caloriesCircleTickWidth, 
		caloriesLinePos, infoTitleFont, hr, Gfx.TEXT_JUSTIFY_LEFT);
    }
    
	function sysInfoDraw(dc) {
	
		var systemStats = Sys.getSystemStats();
		var battery = systemStats.battery;
        var fbattery =  battery.format("%d") + "%";
        var fsize = dc.getTextDimensions(fbattery, infoTitleFont);
		var w = batterySize[0];
		var h = batterySize[1];
        var x = dc.getWidth()/2-w/2-fsize[0]/2;
		var y = dc.getHeight() - (dc.getHeight()-infoUnderLinePos-batteryPadding)/2 - h/2;// - caloriesCircleWidth;
        
        if (battery>50){
        	dc.setColor(labelColor, Gfx.COLOR_TRANSPARENT);
        }
        else if (battery>20){
        	dc.setColor(batteryWarnColor, Gfx.COLOR_TRANSPARENT);
        }
        else {
        	dc.setColor(batteryLowColor, Gfx.COLOR_TRANSPARENT);
        }
        
        dc.drawRectangle(x+w, y+h/3.0, 2, h/2.0-1);
        dc.drawRoundedRectangle(x, y, w, h, 2);
        dc.fillRoundedRectangle(x, y, w*battery/100, h, 2);
        
        dc.drawText(x+w+framePadding, y-fsize[1]/2+h/2-2, infoTitleFont, fbattery , Gfx.TEXT_JUSTIFY_LEFT);
	}

    function onUpdate(dc) {
    	
    	dc.setColor(bgColor, bgColor);
		dc.clear();
		
	    calendarDraw(dc);
	    clockDraw(dc); 
	    
	    activityDraw(dc);
	    sysInfoDraw(dc);	    
	    caloriesRestDraw(dc,currentCalories);
	    heatRateDraw(dc);	  	    	           
    }

    function onShow() {}

    function onHide() {}

    function onExitSleep() {}

    function onEnterSleep() {}
    
}
