using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class BWFaceStrings {
	    var stepsTitle    = Ui.loadResource( Rez.Strings.StepsTitle );
        var caloriesTitle = Ui.loadResource( Rez.Strings.CaloriesTitle );
        var distanceTitle = Ui.loadResource( Rez.Strings.DistanceTitle );
        var bpmTitle      = Ui.loadResource( Rez.Strings.BPMTitle );
        var secondsTitle  = Ui.loadResource( Rez.Strings.SecondsTitle );
        var sunriseTitle  = Ui.loadResource( Rez.Strings.SunriseTitle );
        var sunsetTitle   = Ui.loadResource( Rez.Strings.SunsetTitle );
        var altitudeTitle = Ui.loadResource( Rez.Strings.AltitudeTitle );
        
        function setup(sysunits){
		    if (sysunits.distanceUnits == Sys.UNIT_STATUTE) {
		    	distanceTitle = Ui.loadResource( Rez.Strings.DistanceMilesTitle );
		    } 
	        else {
	        	distanceTitle = Ui.loadResource( Rez.Strings.DistanceTitle );
	        }
	       
	       	if (sysunits.elevationUnits == Sys.UNIT_STATUTE) {
		    	 altitudeTitle = Ui.loadResource( Rez.Strings.AltitudeFeetTitle );
		    } 
	        else {
	        	 altitudeTitle = Ui.loadResource( Rez.Strings.AltitudeTitle );
	        }	        
        }	
}