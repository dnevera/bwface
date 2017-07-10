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
    var heartRateField;	
    			
    function handlSettingUpdate(){    	
    	properties.setup();  
    	activityField.setup(); 
	}
    	
    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
    
    	//partialUpdatesAllowed = ( Toybox.WatchUi.WatchFace has :onPartialUpdate );    	
    	//System.println("partialUpdatesAllowed = "+partialUpdatesAllowed);
    
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
  		
  		if  (properties.settings.screenShape == System.SCREEN_SHAPE_SEMI_ROUND) {
  		 	bmrlocY = properties.bmrTopPadding;
  		}
		else if (properties.settings.screenShape == System.SCREEN_SHAPE_RECTANGLE) {
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
				
		heartRateField = new  BWFaceHRField({
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
		/*var sensorIter =  getIterator();
		if  ( sensorIter != null ){   	    	    	
			var n = sensorIter.next();
			var t = Calendar.info(n.when, Time.FORMAT_MEDIUM);
			System.println(" SENSOR " + sensorIter.getNewestSampleTime() + " w = " + t.hour + ":" + t.min + " data = "+n.data);
    	}*/
    		    	
		dc.setClip(0, 0, dc.getWidth(), dc.getHeight());    		    	
    	dc.setColor(properties.bgColor, properties.bgColor);
		dc.clear();
		
		var today = currentTime();
		
		topField.draw(today);
		clockField.draw(today);
		activityField.draw();
		sysinfoField.draw();
		bmrMeter.draw(activityField.currentCalories);
		heartRateField.draw(bmrMeter.tickPosX,bmrMeter.tickPosY);		
    }
	
	function onPartialUpdate(dc) {
		activityField.partialDraw();
	}
	
	// Create a method to get the SensorHistoryIterator object
	function getIterator() {
	    // Check device for SensorHistory compatability
	    if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getPressureHistory)) {
	        // Set up the method with parameters
	        var getMethod = new Lang.Method
	            (
	            Toybox.SensorHistory,
	            :getPressureHistory
	            );
	        // Invoke the method with the given parameters
	        return getMethod.invoke({:order=>SensorHistory.ORDER_NEWEST_FIRST,:period=>1});
	    }
	    return null;
	}

    function onShow() {}

    function onHide() {}

    function onExitSleep() {
    }

    function onEnterSleep() {
    }
    
}
