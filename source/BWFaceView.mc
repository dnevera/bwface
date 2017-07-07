using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time.Gregorian as Calendar;
//using Toybox.Application as App;
//using Toybox.Activity as Info;
//using Toybox.ActivityMonitor as Monitor;
//using Toybox.Sensor as Snsr;
using Toybox.UserProfile as User;
//using Toybox.Math as Math;

class BWFaceView extends Ui.WatchFace {
        
	var batterySize = [18,9]; 
        
	var clockFont    = Gfx.FONT_SYSTEM_NUMBER_THAI_HOT;	
	var calendarFont = Gfx.FONT_SYSTEM_LARGE;
	var weekDayFont  = Gfx.FONT_SYSTEM_MEDIUM;
	
	var infoFont      = Gfx.FONT_SYSTEM_MEDIUM;
	var infoFontSmall = Gfx.FONT_SYSTEM_SMALL;
	var infoTitleFont = Gfx.FONT_SYSTEM_SMALL;
	var infoTitleFontTiny = Gfx.FONT_SYSTEM_TINY;
	var infoFractFont = Gfx.FONT_SYSTEM_SMALL;
	
	var weekDayPadding   = -4;
	var calendarPadding  = -8;
	var clockPadding     =  0;
	var batteryPadding   = -4;
	var infoPadding      =  4;
	var activityPadding  = -12;
	var framePadding     =  4;
	var frameRadius      =  4;
	var topActibitiesPadding =  0;
	var caloriesCircleTickWidth = 10;
	var caloriesCircleWidth     = 6;
	    
    var timeUnderLinePos;
    var timeAboveLinePos;
    var infoUnderLinePos;

	var stepsTitle;
	var caloriesTitle;
	var distanceTitle;
	var bpmTitle;
    var userBmr;
    var drawTopTitles = true;
    
	var properties;
	var topField; 
	var clockField;
    var activityField;	    	
    var sysinfoField;	
    var bmrMeter;	
    	
    function handlSettingUpdate(){    	
    	properties.setup();    	
	}
    
    function initialize() {
        WatchFace.initialize();   
    }

    function onLayout(dc) {
		properties = new BWFaceProperties(dc);
		 
		properties.setup();

		var clockPadding = 0;
        if (dc.getHeight()<=180){ // 735xt
        	clockPadding = -12;
		}
		 
		topField   = new BWFaceTopField({
				:identifier => "TopField", 
				:locX=>dc.getWidth()/2, 
				:locY=>2, 
				:dayPadding=>-2}, properties);
		
		clockField = new BWFaceClockField({
				:identifier => "ClockField", 
				:locX=>dc.getWidth()/2, 
				:locY=>topField.bottomY+clockPadding}, properties);
                          
		activityField = new BWFaceActivityField({
				:identifier => "ActivityField", 
				:locX=>dc.getWidth()/2, 
				:locY=>clockField.bottomY,
				:framePadding=>4,
				:frameRadius=>3}, properties);
                        
		var sysPadding = (dc.getHeight()-activityField.bottomY)/2;                        
                          
		sysinfoField = new BWFaceSysinfoField({
				:identifier => "SysInfoField", 
				:locX=>dc.getWidth()/2, 
				:locY=>activityField.bottomY,
				:framePadding=>4}, properties);
  	
  		bmrMeter = new BWFaceDBmrMeter({
				:identifier => "SysInfoField", 
				:locX=>dc.getWidth()/2, 
				:locY=>clockField.topY-2}, properties);
    		                                                        
        /*stepsTitle    = Ui.loadResource( Rez.Strings.StepsTitle );
        caloriesTitle = Ui.loadResource( Rez.Strings.CaloriesTitle );
        distanceTitle = Ui.loadResource( Rez.Strings.DistanceTitle );
        bpmTitle      = Ui.loadResource( Rez.Strings.BPMTitle );
        
        if (dc.getHeight()<=180){
        	clockFont = Ui.loadResource(Rez.Fonts.clockFontTiny);
        	drawTopTitles = false;
		}
		else if (dc.getWidth()<=218){
        	clockFont = Ui.loadResource(Rez.Fonts.clockFontSmall);
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
        	
        	weekDayPadding   = -8;
			calendarPadding  = -3;  
			infoPadding   = 4;
			framePadding  = 4;
			frameRadius   = 2;		     
        	activityPadding  = -6;   
        	clockPadding     =  -14;
        	topActibitiesPadding = -14;   
        	batteryPadding   = -2;        	  	
        }
        else if (dc.getWidth()<=240){   
        	if  (dc.getWidth()<=218){    	
        		calendarFont  = Ui.loadResource(Rez.Fonts.calendarFontSmall);
	        	infoFont      = Ui.loadResource(Rez.Fonts.infoFontSmall);	
	        	infoFractFont = Ui.loadResource(Rez.Fonts.infoFractFontSmall);
            	infoTitleFont = Ui.loadResource(Rez.Fonts.infoTitleFontSmall);	
        		calendarPadding  = -4;
        		activityPadding  = -6;   
        		clockPadding     = -3;     		
        	}
        	else {
	        	calendarFont  = Ui.loadResource(Rez.Fonts.calendarFontLarge);	
	        	infoFont      = Ui.loadResource(Rez.Fonts.infoFont);
	        	infoFractFont = Ui.loadResource(Rez.Fonts.infoFractFont);	        		
	        	infoTitleFont = Ui.loadResource(Rez.Fonts.infoTitleFont);
	        	batteryPadding   = -4;        	  	
        	}
        	weekDayFont   = calendarFont; 
        	infoFontSmall = Ui.loadResource(Rez.Fonts.infoFontSmall);	
        	infoTitleFontTiny = Ui.loadResource(Rez.Fonts.infoTitleFontTiny);
        }	        

		handlSettingUpdate();
		           
        userBmr = bmr();   */     
    }

		

	
	var currentCalories;
	var caloriesLinePos;
	var caloriesTitleLinePos;
	var caloriesOffsetPos;


	function heatRateDraw(dc) {
	
    	var info = Info.getActivityInfo();
    	var hr = info.currentHeartRate;
    	hr = hr == null ? "-- " : hr.format("%d");   	
    	var title = " "+bpmTitle;
    	dc.setColor(properties.labelColor, Gfx.COLOR_TRANSPARENT);	
		dc.drawText(caloriesOffsetPos, caloriesLinePos, infoFont, hr, Gfx.TEXT_JUSTIFY_LEFT);
		if (drawTopTitles) {
	    	var size = dc.getTextDimensions(hr,  infoFont);
			dc.drawText(caloriesOffsetPos+size[0],   caloriesTitleLinePos, infoTitleFontTiny, title, Gfx.TEXT_JUSTIFY_LEFT);
		}
    }
    
	
	function currentTime(){
			var clockTime = Sys.getClockTime();
			
			var t = Time.now();	
			
			if (properties.useDayLightSavingTime) {	
				var offset = new Time.Duration(clockTime.dst);
				t=t.add(offset);
			}		
		
			return  Calendar.info(t, Time.FORMAT_MEDIUM); 			
	}
	
    function onUpdate(dc) {
    	    	    	
    	dc.setColor(properties.bgColor, properties.bgColor);
		dc.clear();
		
		var today = currentTime();
		topField.draw(today);
		clockField.draw(today);
		activityField.draw();
		sysinfoField.draw();
		bmrMeter.draw(activityField.currentCalories);
		
	    //caloriesRestDraw(dc,currentCalories);
	    //heatRateDraw(dc);	  	    	           
    }

    function onShow() {}

    function onHide() {}

    function onExitSleep() {}

    function onEnterSleep() {}
    
}
