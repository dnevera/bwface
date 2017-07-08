using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class BWFaceStrings {
	    var stepsTitle    = Ui.loadResource( Rez.Strings.StepsTitle );
        var caloriesTitle = Ui.loadResource( Rez.Strings.CaloriesTitle );
        var distanceTitle = Ui.loadResource( Rez.Strings.DistanceTitle );
        var bpmTitle      = Ui.loadResource( Rez.Strings.BPMTitle );
        
        function setup(sysunits){
		    if (sysunits.distanceUnits == Sys.UNIT_STATUTE) {
		    	distanceTitle = Ui.loadResource( Rez.Strings.DistanceMilesTitle );
		    } 
	        else {
	        	distanceTitle = Ui.loadResource( Rez.Strings.DistanceTitle );
	        }
        }	
}