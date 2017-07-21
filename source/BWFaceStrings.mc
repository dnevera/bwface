using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class BWFaceStrings {
	    var stepsTitle    = Ui.loadResource( Rez.Strings.StepsTitle ).toUpper();
        var caloriesTitle = Ui.loadResource( Rez.Strings.CaloriesTitle ).toUpper();
        var distanceTitle = Ui.loadResource( Rez.Strings.DistanceTitle ).toUpper();
        var bpmTitle      = Ui.loadResource( Rez.Strings.BPMTitle ).toUpper();
        var secondsTitle  = Ui.loadResource( Rez.Strings.SecondsTitle ).toUpper();
        var sunriseTitle  = Ui.loadResource( Rez.Strings.SunriseTitle ).toUpper();
        var sunsetTitle   = Ui.loadResource( Rez.Strings.SunsetTitle ).toUpper();
        var altitudeTitle = Ui.loadResource( Rez.Strings.AltitudeTitle ).toUpper();
        var temperatureTitle  = Ui.loadResource( Rez.Strings.TemperatureTitle ).toUpper();
        var pressureTitle     = Ui.loadResource( Rez.Strings.PressureTitle ).toUpper();
        var pressuremmHgTitle = Ui.loadResource( Rez.Strings.PressureMmHgTitle ).toUpper();
        var pressurehPaTitle  = Ui.loadResource( Rez.Strings.PressurehPaTitle ).toUpper();
        var userBMRTitle      = Ui.loadResource( Rez.Strings.UserBMRTitle ).toUpper();
        var activityFactorTitle  = Ui.loadResource( Rez.Strings.ActivityFactorTitle ).toUpper();
        var floorsClimbedTitle   = Ui.loadResource( Rez.Strings.FloorsClimbedTitle ).toUpper();
        var climbedTitle         = Ui.loadResource( Rez.Strings.ClimbedTitle ).toUpper();
        
        var elevationTitle       = Ui.loadResource( Rez.Strings.ElevationTitle ).toUpper();

        function setup(sysunits){
		    if (sysunits.distanceUnits == Sys.UNIT_STATUTE) {
		    	distanceTitle = Ui.loadResource( Rez.Strings.DistanceMilesTitle ).toUpper();
		    } 
	        else {
	        	distanceTitle = Ui.loadResource( Rez.Strings.DistanceTitle ).toUpper();
	        }
	       
	       	if (sysunits.elevationUnits == Sys.UNIT_STATUTE) {
		    	 altitudeTitle  = Ui.loadResource( Rez.Strings.AltitudeFeetTitle ).toUpper();
		    	 elevationTitle = Ui.loadResource( Rez.Strings.ElevationFeetTitle ).toUpper();
		    	 climbedTitle = Ui.loadResource( Rez.Strings.ClimbedFeetTitle ).toUpper();
		    } 
	        else {
	        	 altitudeTitle = Ui.loadResource( Rez.Strings.AltitudeTitle ).toUpper();
	        	 elevationTitle= Ui.loadResource( Rez.Strings.ElevationTitle ).toUpper();
	        	 climbedTitle  = Ui.loadResource( Rez.Strings.ClimbedTitle ).toUpper();
	        }	
	        
	        if (sysunits.temperatureUnits == Sys.UNIT_STATUTE) {
		    	 temperatureTitle = Ui.loadResource( Rez.Strings.TemperatureFahrTitle ).toUpper();
		    } 
	        else {
	        	 temperatureTitle = Ui.loadResource( Rez.Strings.TemperatureTitle ).toUpper();
	        }	        
        }	
}