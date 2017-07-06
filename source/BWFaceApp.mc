using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as System; 

class BWProperties{

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

    var useDayLightSavingTime = true;
    var caloriesCircleTickOn12;

	function getProperty(key,default_value) {
		var v = App.getApp().getProperty(key);
		return v == null ? default_value : v;
	}

	function setup(){
		
		useDayLightSavingTime = getProperty("UseDayLightSavingTime", false);
		
        surplusColor = getProperty("SurplusColor",0x7F2400);                
        deficitColor = getProperty("DeficitColor",0x247F00);
        	                	        
        caloriesCircleTickOn12 = getProperty("CaloriesCheckPointOn12", false);
        	        
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


class BWFaceApp extends App.AppBase {

	var properties = new BWProperties();

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    	properties.setup();
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new BWFaceView() ];
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() {
    	properties.setup();
        Ui.requestUpdate();
    }

}