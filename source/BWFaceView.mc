using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.UserProfile as User;

class BWFaceView extends Ui.WatchFace {

	var digitsFont = null;
	var digitsMonoFont = null;
	
	var hoursColor = null;
	var colonColor = null;
	var minutesColor = null;
	var bgColor = null;
	var colonString  = ":";
    var colonSize = 10;
    
    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
        
        digitsFont = Ui.loadResource(Rez.Fonts.digits7Font);	
        digitsMonoFont = Ui.loadResource(Rez.Fonts.digits7monoFont);	
        
        bgColor      = App.getApp().getProperty("BackgroundColor");
        hoursColor   = App.getApp().getProperty("HoursColor");
        colonColor   = App.getApp().getProperty("TimeColonColor");
        minutesColor = App.getApp().getProperty("MinutesColor");
        colonSize    = dc.getTextDimensions(colonString, digitsFont);
    
    }

	function mydraw(dc){
		dc.setColor(bgColor, bgColor);
		dc.clear();
		var clockTime = Sys.getClockTime();
		
		 var hours = clockTime.hour;
        if (!Sys.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (App.getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
            }
        }
        
        hours   = hours.format("%02d");
		var minutes = clockTime.min.format("%02d");		
		
		var hoursSize = dc.getTextDimensions(hours, digitsMonoFont);
		dc.setColor(hoursColor, bgColor);
		dc.drawText(dc.getWidth()/2-colonSize[0]-hoursSize[0], dc.getHeight()/2-hoursSize[1]/2, digitsMonoFont, hours, Gfx.TEXT_JUSTIFY_LEFT);

		dc.setColor(colonColor, bgColor);
		dc.drawText(dc.getWidth()/2, dc.getHeight()/2-colonSize[1]/2, digitsFont, colonString, Gfx.TEXT_JUSTIFY_CENTER);
	
		var minutesSize = dc.getTextDimensions(minutes, digitsMonoFont);
		dc.setColor(minutesColor, bgColor);
		dc.drawText(dc.getWidth()/2+colonSize[0]+minutesSize[0], dc.getHeight()/2-minutesSize[1]/2, digitsMonoFont, minutes, Gfx.TEXT_JUSTIFY_RIGHT);

	}

    function onUpdate(dc) {
	    mydraw(dc);        
    }

    function onShow() {
    }

    function onHide() {
    }

    function onExitSleep() {
    }

    function onEnterSleep() {
    }

}
