using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Calendar;
using Toybox.UserProfile as User;
using Toybox.Sensor;
using Toybox.SensorHistory;
using Toybox.System;
using Toybox.Timer;
using Toybox.ActivityMonitor;

class BWFaceView extends Ui.WatchFace {
        
	var clockPadding     =  0;
	var infoPadding      =  4;
	var caloriesCircleTickWidth = 10;
	var caloriesCircleWidth     = 6;
	    
    var timeUnderLinePos;
    var timeAboveLinePos;
    var infoUnderLinePos;
    
	var properties = null;
	var topField; 
	var clockField;
    var activityField;	    	
    var sysinfoField;	
    var bmrMeter;	
    var metricRateField;	

    var _dc;

    function handlSettingUpdate(){    	
    	properties.setup();  
    	activityField.setup(); 
    	metricRateField.setup();
    	//onLayout(_dc);
	}
    	
    function initialize() {
        WatchFace.initialize();
        if (properties!=null){
            properties.setup();
        }
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
				:identifier => "MetricField", 
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
	
    function onUpdateBase(dc) {

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
    }
	
	function onUpdate(dc) {
		onUpdateBase(dc);
		metricRateField.draw(bmrMeter.tickPosX+properties.metricPadding, bmrMeter.tickPosY);
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

class BWFaceView5 extends BWFaceView {
	
	function initialize() {
        BWFaceView.initialize();
    }
	
	function onUpdate(dc) {
		BWFaceView.onUpdateBase(dc);	
		if ( properties.getProperty("CaloriesBarGraphsOn", false) ){
			graphsField(dc, dc.getWidth()/2, clockField.topY, properties.graphsHeight);
		}	
		metricRateField.draw(bmrMeter.tickPosX+properties.metricPadding, bmrMeter.tickPosY);		
	}

	 function graphsField(dc,locX,locY, height) {
    	var hist = ActivityMonitor.getHistory();
    	var calories = activityField.currentCalories;
    	
    	var font = properties.fonts.infoTitleFontTiny;
    	var colSize = dc.getTextDimensions("W", font);
    	var w      = (colSize[0]+properties.framePadding/2) * 2;
    	var offset = w/2+properties.framePadding/2;

        var count;
        var start;
        var start0 = 8;
        var shift;

        if (
        properties.metricField == BW_HeartRate ||
        properties.metricField == BW_Temperature ||
        properties.metricField == BW_Pressure
        ) {
            count = 8;
            start = hist.size()-1;
            shift = 0;
        }
        else {
            count = 7;
            start = hist.size()-2;
            shift = colSize[0]/2;
            start0 -= 1;
        }

    	var x0 = locX - (offset)*count/2+properties.graphsPadding + shift;
    	var y = locY+colSize[1]+properties.framePadding+properties.graphsTopPadding;
    	var x = x0;
    	
    	if (hist.size()==0){
    	
	    	for (var i = start0; i>=0; i--){
	    		var m = new Time.Moment(Time.today().value()-3600*24*i);
	    		var t = Calendar.info(m, Time.FORMAT_MEDIUM); 
	    		dc.drawText(x, y, font, t.day_of_week.toString().substring(0, 1), Gfx.TEXT_JUSTIFY_CENTER);
	    		dc.fillRectangle(x-colSize[0]/2, y-1, w/2, 1);
	    		x +=  offset;
	    	}
    		return;
    	}
    	    	
    	x = x0+properties.framePadding/2;
    	var min0 = 100000;
    	var max0 = 0.1;
    	for (var i = start; i>=0; i--){
    		var t = Calendar.info(hist[i].startOfDay, Time.FORMAT_MEDIUM); 

    		if (hist[i].calories<min0) { min0 = hist[i].calories; }
    		if (hist[i].calories>max0) { max0 = hist[i].calories; }

    		dc.drawText(x, y, font, t.day_of_week.toString().substring(0, 1), Gfx.TEXT_JUSTIFY_CENTER);
    		x +=  offset;
    	}
	
		var m = new Time.Moment(Time.today().value());
	    var t = Calendar.info(m, Time.FORMAT_MEDIUM); 
		dc.drawText(x, y, font, t.day_of_week.toString().substring(0, 1), Gfx.TEXT_JUSTIFY_CENTER);	
	
	    if (calories<min0) { min0 = calories; }
    	if (calories>max0) { max0 = calories; }
	
		var threshold = properties.getProperty("ActivityFactorThreshold", 1.5);
		var bmr = properties.bmr();
		x = x0-colSize[0]/2;
		var avrg = 0;
		var avrgAf = 0;
    	var color;
    	for (var i = start; i>=0; i--){
    		var af = hist[i].calories/bmr;
    		avrgAf += af;
    		var h = height * hist[i].calories/max0;
    		if (af<1){
    			color = properties.surplusColor; 
    		} 		
    		else if (af>=threshold) {
    			color = properties.deficitColor;
    		}
    		else {
    		    color = properties.getProperty("ActivityColor",0xD06900);
    		}
    		dc.setColor(color,  Gfx.COLOR_TRANSPARENT);
    		dc.fillRectangle(x, y-h, w/2, h);
    		x +=  offset;
    		avrg += h;
		}	
		
		var af = calories/bmr;
		avrgAf += calories/bmr;
		var h = height * calories/max0;
		avrg += h;
		
		if (af<1){
			color = properties.surplusColor; 
		} 		
		else {
			color = af<=threshold ? properties.getProperty("ActivityColor",0xD06900) : properties.deficitColor;
		}
		dc.setColor(color,  Gfx.COLOR_TRANSPARENT);
		dc.fillRectangle(x, y-h, w/2, h);
		x +=  w+properties.framePadding/2;
		
		avrg /= hist.size();	
		avrgAf /= hist.size();
		
		if (avrgAf>=threshold){
			color = properties.deficitColor;
		}
		else {
			color = properties.surplusColor;
		}
		
		dc.setColor(color,  Gfx.COLOR_TRANSPARENT);
		var x1 = x0-colSize[0]/2;
		var x2 = x-w/2-1;
		var y1 = y-avrg;
		dc.drawLine(x1, y1, x2, y1);
		dc.drawLine(x1, y1+1, x2, y1+1);

		dc.setColor(properties.bgColor,  Gfx.COLOR_TRANSPARENT);
		dc.drawLine(x1, y1+2, x2, y1+2);
		dc.drawLine(x1, y1-1, x2, y1-1);
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
        BWFace.partialUpdatesAllowed=false;
    }
}
