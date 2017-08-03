using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as System; 
using Toybox.UserProfile as User;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Graphics as Gfx;

class BWFaceProperties{

	var activityLeftField  = BW_Distance;
	var activityMidField   = BW_Steps;
	var activityRightField = BW_Calories;
	var metricField        = BW_HeartRate;
	
	var clockPadding            =  0;
	var caloriesCircleTickWidth =  8;
	var caloriesCircleWidth     =  6;
	var activityPadding         = -8;
	var fractionNumberPadding   = -3;
	var framePadding      =  4;
	var frameRadius       =  3;
	var topFieldPadding   =  4;
	var dayPadding        = -2;
	var sunHoursPadding   =  9;
	var bmrTopPadding     =  4;
	var bmrPadding        =  4;
	var sysinfoTopPadding =  4;
	
	var metricPadding     = 0;	
	var graphsHeight      = 21;
	var graphsPadding     = 0;
	var graphsTopPadding  = 0;
	
	var btIconSize     = 6;
	var btIconPenWidth = 1;
	var btIconColor    = Gfx.COLOR_BLUE;

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
	var statuteFactor = 1;
	
	var fonts = new BWFaceFonts();	

	function initialize(_dc){
		dc = _dc;
	}

	function getProperty(key,default_value) {
		var v = App.getApp().getProperty(key);
		return v == null ? default_value : v;
	}

	function setProperty(key,value) {
		App.getApp().setProperty(key, value);
	}

	function setup(){

        if (dc.getHeight()<=180){ // 735xt
        	clockPadding = -6;
        	caloriesCircleTickWidth = 6;
        	topFieldPadding = 1;
			dayPadding      = 0;        	
			bmrTopPadding   =  12;
			bmrPadding      =  4;
			activityPadding = -6;
			sysinfoTopPadding = 6;
			metricPadding = 8;
		}
		else {
			var f = !getProperty("CaloriesBarGraphsOn", false);// && System.getDeviceSettings().screenShape != System.SCREEN_SHAPE_SEMI_ROUND;
			if (dc.getWidth()<=148) { // vivoactive
				caloriesCircleTickWidth = 6;
				caloriesCircleWidth = 4;	
				clockPadding = 12;
				activityPadding = 0; 
				sysinfoTopPadding = -4;
				bmrTopPadding = 1;
				framePadding  =  4;									
				fractionNumberPadding = -4;
	            sunHoursPadding   =  6;
	            dayPadding        = 9;
			}
			else if  (dc.getHeight()<=218){ // 5s
			    graphsHeight    = 18;
				activityPadding = -11;
				clockPadding = 9;
				bmrTopPadding = 0;
				bmrPadding    = 4;
				sysinfoTopPadding =  7;	
				metricPadding = 0;
				graphsPadding = -2;
				graphsTopPadding = -1;
				sunHoursPadding  =  8;
//				if (f) {
//				    bmrTopPadding += 3;
//				    bmrPadding -= 6;
//				    metricPadding = 8;
//				    clockPadding += -1;
//				}
			}
			else {
				clockPadding    = 10;
				topFieldPadding = 4;
				dayPadding      = -1; 
				activityPadding =  -12;
				sysinfoTopPadding =  4;	
				bmrTopPadding = -2;
				bmrPadding    = 5;
            	sysinfoTopPadding =  5;
				metricPadding = 3;
				graphsPadding = 0;
				graphsTopPadding = 1;
//				if (f) {
//				    activityPadding += 1;
//				    clockPadding += -2;
//				    bmrTopPadding += 5;
//				    bmrPadding -= 6;
//				    metricPadding = 12;
//				    //sunHoursPadding += -2;
//				    topFieldPadding += 2;
//				}
			}
		}		
		
		activityLeftField  = getProperty("ActivityLeftField", BW_Distance);
		activityMidField   = getProperty("ActivityMidField",  BW_Steps);
		activityRightField = getProperty("ActivityRightField",BW_Calories);
		metricField        = getProperty("MetricField",BW_HeartRate);
		
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

		if (System.getDeviceSettings().distanceUnits == System.UNIT_STATUTE) {
		   statuteFactor = 1.609344;
		} 
	    else {
	       statuteFactor = 1;
	   }		
	}
	
	function getLocation() {
		
		var actInfo  = Activity.getActivityInfo();
		
		if (actInfo == null ) {
			actInfo = Activity.getActivityInfo();			
		}
		else if (actInfo.currentLocation == null ) {
			actInfo = Activity.getActivityInfo();
		}
				
        if(actInfo != null)
        {
            var deg = actInfo.currentLocation;
            if(deg != null)
            {
               var degArray = deg.toDegrees();
               setProperty("CurrentLocation", degArray);                  
               return degArray;
            }
        }        
        return getProperty("CurrentLocation", null);
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
}
