using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as System; 

class BWFaceApp extends App.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    	//System.println("Hello ....");
    	System.println("Hello... ");
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
        Ui.requestUpdate();
    }

}