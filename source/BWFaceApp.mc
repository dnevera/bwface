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

    function onStart(state) {}

    function onStop(state) {}

    // Return the initial view of your application here
    function getInitialView() {
    	if( Toybox.WatchUi.WatchFace has :onPartialUpdate ) {
	    	mainView = new BWFaceView5();
        	return [ mainView, new BWFaceDelegate() ];
    	}
    	else {
        	mainView = new BWFaceView();
        	return [ mainView ];
        }
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() {
    	mainView.handlSettingUpdate();
        Ui.requestUpdate();
    }    
}

class Background extends Ui.Drawable {

    function initialize() {
        var dictionary = {
            :identifier => "Background"
        };

        Drawable.initialize(dictionary);
    }

    function draw(dc) {
        // Set the background color then call to clear the screen
        //dc.setColor(Gfx.COLOR_TRANSPARENT, BWFace.getColor("BackgroundColor"));
        dc.clear();
    }

}
