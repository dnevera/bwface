using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as System;

class BWFaceFonts {
	
	var settings =  System.getDeviceSettings();   

	var clockFont    = Gfx.FONT_SYSTEM_NUMBER_THAI_HOT;	
	var weekDayFont  = Gfx.FONT_SYSTEM_SMALL;
	
	var infoFont      = Gfx.FONT_SYSTEM_MEDIUM;
	var infoFontSmall = Gfx.FONT_SYSTEM_SMALL;
	var infoTitleFont = Gfx.FONT_SYSTEM_SMALL;
	var infoTitleFontTiny = Gfx.FONT_SYSTEM_TINY;
	var infoFractFont = Gfx.FONT_SYSTEM_SMALL;
	
	function initialize() {
			
	 if (settings.screenHeight<=180){ // Foreruner 735xt
        	clockFont    = Ui.loadResource(Rez.Fonts.clockFontTiny);
			weekDayFont  = Ui.loadResource(Rez.Fonts.calendarFontTiny);    
			
			infoFontSmall     = Ui.loadResource(Rez.Fonts.infoFontSmall);	
        	infoTitleFontTiny = Ui.loadResource(Rez.Fonts.infoTitleFontTiny);
        	
	        infoFont      = Ui.loadResource(Rez.Fonts.infoFontSmall);	
	        infoFractFont = Ui.loadResource(Rez.Fonts.infoFractFontSmall);
            infoTitleFont = Ui.loadResource(Rez.Fonts.infoTitleFontSmall);	        	        				    
		}
		else if (settings.screenHeight<=240){   
        	if  (settings.screenHeight<=218){  // 5S
        	  	
        	  	if (settings.screenWidth<=148){ // vivoactive
        	  		clockFont = Ui.loadResource(Rez.Fonts.clockFontTall);
        	  		infoTitleFont = Ui.loadResource(Rez.Fonts.infoTitleFontTiny);
	 			} 	
	 			else {
	 				clockFont = Ui.loadResource(Rez.Fonts.clockFontSmall);
	 				infoTitleFont = Ui.loadResource(Rez.Fonts.infoTitleFontSmall);
	        		weekDayFont   = Ui.loadResource(Rez.Fonts.calendarFontSmall);
	 			}
        	  		        	
	        	infoFont      = Ui.loadResource(Rez.Fonts.infoFontSmall);	
	        	infoFractFont = Ui.loadResource(Rez.Fonts.infoFractFontSmall);	        	
        	}
        	else {        	
	        	clockFont = Ui.loadResource(Rez.Fonts.clockFont);
	        		        	
	        	weekDayFont   = Ui.loadResource(Rez.Fonts.calendarFontLarge);	
	        	infoFont      = Ui.loadResource(Rez.Fonts.infoFont);
	        	infoFractFont = Ui.loadResource(Rez.Fonts.infoFractFont);	        		
	        	infoTitleFont = Ui.loadResource(Rez.Fonts.infoTitleFont);
        	}
        	
        	infoFontSmall     = Ui.loadResource(Rez.Fonts.infoFontSmall);	
        	infoTitleFontTiny = Ui.loadResource(Rez.Fonts.infoTitleFontTiny);
        }	                       
	}
}