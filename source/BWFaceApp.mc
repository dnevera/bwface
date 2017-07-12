using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as System; 
using Toybox.Timer;
using Toybox.Lang;

class BWFaceApp extends App.AppBase {

	var mainView;
	
    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) { 
    }

    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
    	mainView = new BWFaceView();
    	if( Toybox.WatchUi.WatchFace has :onPartialUpdate ) {
        	return [ mainView, new BWFaceDelegate() ];
    	}
    	else {
        	return [ mainView ];
        }
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() {
    	mainView.handlSettingUpdate();
        Ui.requestUpdate();
    }    
}