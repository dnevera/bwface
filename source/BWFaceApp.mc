using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as System; 

class BWFaceApp extends App.AppBase {

	var mainView;
	
    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {    	
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
    	mainView = new BWFaceView();
        return [ mainView ];
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() {
    	//properties.setup();
    	mainView.handlSettingUpdate();
        Ui.requestUpdate();
    }

}