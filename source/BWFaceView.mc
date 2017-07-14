using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time.Gregorian as Calendar;
using Toybox.UserProfile as User;
using Toybox.Sensor;
using Toybox.SensorHistory;
using Toybox.System;
using Toybox.Timer;


class BWFaceView extends Ui.WatchFace {
        
	var clockPadding     =  0;
	var infoPadding      =  4;
	var caloriesCircleTickWidth = 10;
	var caloriesCircleWidth     = 6;
	    
    var timeUnderLinePos;
    var timeAboveLinePos;
    var infoUnderLinePos;
    
	var properties;
	var topField; 
	var clockField;
    var activityField;	    	
    var sysinfoField;	
    var bmrMeter;	
    var metricRateField;	
    			
    function handlSettingUpdate(){    	
    	properties.setup();  
    	activityField.setup(); 
    	metricRateField.setup();
	}
    	
    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
        
		properties = new BWFaceProperties(dc);		 
		properties.setup();
		 
		topField   = new BWFaceTopField({
				:identifier => "TopField", 
				:locX=>dc.getWidth()/2, 
				:locY=>properties.topFieldPadding, 
				:dayPadding=>properties.dayPadding}, properties);
		
		clockField = new BWFaceClockField({
				:identifier => "ClockField", 
				:locX=>dc.getWidth()/2, 
				:locY=>topField.bottomY+properties.clockPadding}, properties);
                          
		activityField = new BWFaceActivityField({
				:identifier => "ActivityField", 
				:locX=>dc.getWidth()/2, 
				:locY=>clockField.bottomY+properties.activityPadding,
				:framePadding=>properties.framePadding,
				:frameRadius=>properties.frameRadius}, properties);
                        
        var bmrlocY = topField.bottomY+properties.bmrTopPadding; 
        var sysInfoY = activityField.bottomY+properties.sysinfoTopPadding;
  		
  		if  (System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_SEMI_ROUND) {
  		 	bmrlocY = properties.bmrTopPadding;
  		}
		else if (System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_RECTANGLE) {
  		 	bmrlocY = dc.getHeight()-properties.caloriesCircleWidth+properties.bmrTopPadding;
  		 	clockField.topY;
  		 	sysInfoY = topField.bottomY+(clockField.topY-topField.bottomY)/2+properties.clockPadding/2+properties.sysinfoTopPadding;
		}   		
                          
		sysinfoField = new BWFaceSysinfoField({
				:identifier => "SysInfoField", 
				:locX=>dc.getWidth()/2, 
				:locY=>sysInfoY,
				:framePadding=>properties.framePadding}, properties);
  		  	
  		bmrMeter = new BWFaceDBmrMeter({
				:identifier => "DeficitBMRMeter", 
				:locX=>dc.getWidth()/2, 
				:locY=>bmrlocY}, properties);
				
		metricRateField = new  BWFaceMetricField({
				:identifier => "SysInfoField", 
				:locX=>0, 
				:locY=>bmrlocY}, properties);   				
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
    	
    	//if(BWFace.partialUpdatesAllowed) {dc.clearClip();}
    	    		    	
		dc.setClip(0, 0, dc.getWidth(), dc.getHeight());    		    	
    	dc.setColor(properties.bgColor, properties.bgColor);
		dc.clear();
		
		var today = currentTime();
		
		topField.draw(today);
		clockField.draw(today);
		activityField.draw();
		sysinfoField.draw();
		if (activityField.currentCalories instanceof Toybox.Lang.String){
			bmrMeter.draw(0);
		}
		else {
			bmrMeter.draw(activityField.currentCalories);
		}
		metricRateField.draw(bmrMeter.tickPosX,bmrMeter.tickPosY);		
    }
	
	function onPartialUpdate(dc) {
		activityField.partialDraw();
	}
	

    function onShow() {}

    function onHide() {}

    function onExitSleep() {
    	BWFace.partialUpdatesAllowed = Toybox.WatchUi.WatchFace has :onPartialUpdate;
    	if(!BWFace.partialUpdatesAllowed) {Ui.requestUpdate();} 
    }

    function onEnterSleep() {
    	if(!BWFace.partialUpdatesAllowed) {Ui.requestUpdate();}
    }
    
}

// https://forums.garmin.com/forum/developers/connect-iq/1229818-watch-face-onpartialupdate-does-not-work-on-all-devices-which-support-this-function

// with onPartialUpdate, the println()'s are useful for debugging.  
// If you exceed the budget, you can see by how much, etc.  The do1hz is used in onUpdate()
// and is key.
class BWFaceDelegate extends Ui.WatchFaceDelegate
{

	function initialize() {
		WatchFaceDelegate.initialize();	
	}

    function onPowerBudgetExceeded(powerInfo) {
        //Sys.println( "Average execution time: " + powerInfo.executionTimeAverage );
        //Sys.println( "Allowed execution time: " + powerInfo.executionTimeLimit );
        BWFace.partialUpdatesAllowed=false;
    }
}
