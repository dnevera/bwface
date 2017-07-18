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
        var temperatureTitle  = Ui.loadResource( Rez.Strings.TemperatureTitle );
        var pressureTitle     = Ui.loadResource( Rez.Strings.PressureTitle );
        var pressuremmHgTitle = Ui.loadResource( Rez.Strings.PressureMmHgTitle );
        var pressurehPaTitle  = Ui.loadResource( Rez.Strings.PressurehPaTitle );
        var userBMRTitle      = Ui.loadResource( Rez.Strings.UserBMRTitle );
        var activityFactorTitle  = Ui.loadResource( Rez.Strings.ActivityFactorTitle );
        var floorsClimbedTitle   = Ui.loadResource( Rez.Strings.FloorsClimbedTitle );
        var climbedTitle         = Ui.loadResource( Rez.Strings.ClimbedTitle );
        
        var elevationTitle       = Ui.loadResource( Rez.Strings.ElevationTitle );
        
        function setup(sysunits){
		    if (sysunits.distanceUnits == Sys.UNIT_STATUTE) {
		    	distanceTitle = Ui.loadResource( Rez.Strings.DistanceMilesTitle );
		    } 
	        else {
	        	distanceTitle = Ui.loadResource( Rez.Strings.DistanceTitle );
	        }
	       
	       	if (sysunits.elevationUnits == Sys.UNIT_STATUTE) {
		    	 altitudeTitle  = Ui.loadResource( Rez.Strings.AltitudeFeetTitle );
		    	 elevationTitle = Ui.loadResource( Rez.Strings.ElevationFeetTitle );
		    	 climbedTitle = Ui.loadResource( Rez.Strings.ClimbedFeetTitle );
		    } 
	        else {
	        	 altitudeTitle = Ui.loadResource( Rez.Strings.AltitudeTitle );
	        	 elevationTitle= Ui.loadResource( Rez.Strings.ElevationTitle );
	        	 climbedTitle  = Ui.loadResource( Rez.Strings.ClimbedTitle );	        	 
	        }	
	        
	        if (sysunits.temperatureUnits == Sys.UNIT_STATUTE) {
		    	 temperatureTitle = Ui.loadResource( Rez.Strings.TemperatureFahrTitle );
		    } 
	        else {
	        	 temperatureTitle = Ui.loadResource( Rez.Strings.TemperatureTitle );
	        }	        
        }	
}