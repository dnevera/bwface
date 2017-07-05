using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as System; 

class BWProperties{

	//var infoTitleFontTiny;	
    var surplusColor;
    var deficitColor;
            	                	       
    var caloriesCircleTickOn12;
	var labelColor;
    var bgColor; 
	var hoursColor;   
	var colonColor;   
	var minutesColor; 
	var framesColor; 
	var batteryLowColor; 
	var batteryWarnColor;     	

	function setup(){
		
        surplusColor = App.getApp().getProperty("SurplusColor");
        deficitColor = App.getApp().getProperty("DeficitColor");
        	                	        
        caloriesCircleTickOn12   = App.getApp().getProperty("CaloriesCheckPointOn12");
        	        
        labelColor   = App.getApp().getProperty("ForegroundColor");
        hoursColor   = App.getApp().getProperty("HoursColor");
        colonColor   = App.getApp().getProperty("TimeColonColor");
        minutesColor = App.getApp().getProperty("MinutesColor");

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