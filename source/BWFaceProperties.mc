using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as System; 

class BWFaceProperties{

	var settings =  System.getDeviceSettings();

	var clockPadding = 0;
	var caloriesCircleTickWidth = 10;
	var caloriesCircleWidth     = 6;
	var activityPadding =  -8;
	var framePadding    =  4;
	var frameRadius     =  3;
	var topFieldPadding =  4;
	var dayPadding      = -2;
	var bmrTopPadding   =  4;
	var sysinfoTopPadding =  4;

	var dc;

    var surplusColor;
    var deficitColor;
            	                	       
	var labelColor;
    var bgColor; 
	var hoursColor;   
	var colonColor;   
	var minutesColor; 
	var framesColor; 
	var batteryLowColor; 
	var batteryWarnColor;     	

    var useDayLightSavingTime;
    var caloriesCircleTickOn12;

	var fonts = new BWFaceFonts();	
	var strings = new BWFaceStrings();

	function initialize(_dc){
		dc = _dc;
	}

	function getProperty(key,default_value) {
		var v = App.getApp().getProperty(key);
		return v == null ? default_value : v;
	}

	function setup(){
		
        if (dc.getHeight()<=180){ // 735xt
        	clockPadding = -12;
        	caloriesCircleTickWidth = 8;
        	topFieldPadding = 2;
			bmrTopPadding   =  6;        	
			activityPadding = -2;  
			sysinfoTopPadding = 6;									      
		}
		else {
			if (dc.getWidth()<=148) { // vivoactive
				caloriesCircleTickWidth = 6;
				caloriesCircleWidth = 4;	
				clockPadding = 12;
				activityPadding = 0; 
				sysinfoTopPadding = -2;	
				bmrTopPadding = 1;					
			}
			else if  (dc.getHeight()<=218){
				activityPadding = -6;  
				clockPadding = 8;
				bmrTopPadding = 1;				
			}
			else {
				clockPadding = 7;
				activityPadding =  -11;	
				sysinfoTopPadding =  4;	
				bmrTopPadding = 2;				
			}
		}		
		
		caloriesCircleTickOn12 = getProperty("CaloriesCheckPointOn12", false);
		useDayLightSavingTime = getProperty("UseDayLightSavingTime", false);
		
        surplusColor = getProperty("SurplusColor",0x7F2400);                
        deficitColor = getProperty("DeficitColor",0x247F00);
        	                	                	        
        labelColor   = getProperty("ForegroundColor",0xEFEFEF);
        hoursColor   = getProperty("HoursColor",0xEFEFEF);
        colonColor   = getProperty("TimeColonColor",0xEFEFEF);
        minutesColor = getProperty("MinutesColor",0xEFEFEF);

        bgColor          = 0x000000;
        framesColor      = 0x4F4F4F; 
        batteryLowColor  = 0xF42416;
        batteryWarnColor = 0xFFA500;    	
		
	}
}
