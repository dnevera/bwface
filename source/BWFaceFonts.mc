using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as System;

class BWFaceFonts {
	
	var settings =  System.getDeviceSettings();   

	var clockFont    = Gfx.FONT_SYSTEM_NUMBER_THAI_HOT;	
	var calendarFont = Gfx.FONT_SYSTEM_LARGE;
	var weekDayFont  = Gfx.FONT_SYSTEM_MEDIUM;
	
	var infoFont      = Gfx.FONT_SYSTEM_MEDIUM;
	var infoFontSmall = Gfx.FONT_SYSTEM_SMALL;
	var infoTitleFont = Gfx.FONT_SYSTEM_SMALL;
	var infoTitleFontTiny = Gfx.FONT_SYSTEM_TINY;
	var infoFractFont = Gfx.FONT_SYSTEM_SMALL;
	
	function initialize() {
	
	 if (settings.screenHeight<=180){
        	clockFont    = Ui.loadResource(Rez.Fonts.clockFontTiny);
        	calendarFont = Gfx.FONT_SYSTEM_MEDIUM;
			weekDayFont  = Gfx.FONT_SYSTEM_MEDIUM;        	
		}
		else if (settings.screenHeight<=240){   
        	if  (settings.screenHeight<=218){  
        	  	
	        	clockFont = Ui.loadResource(Rez.Fonts.clockFontSmall);
	        	
        		calendarFont  = Ui.loadResource(Rez.Fonts.calendarFontSmall);
	        	infoFont      = Ui.loadResource(Rez.Fonts.infoFontSmall);	
	        	infoFractFont = Ui.loadResource(Rez.Fonts.infoFractFontSmall);
            	infoTitleFont = Ui.loadResource(Rez.Fonts.infoTitleFontSmall);	
        		calendarPadding  = -4;
        		activityPadding  = -6;   
        		clockPadding     = -3;     		
        	}
        	else {        	
	        	clockFont = Ui.loadResource(Rez.Fonts.clockFont);	        	
	        	calendarFont  = Ui.loadResource(Rez.Fonts.calendarFontLarge);	
	        	infoFont      = Ui.loadResource(Rez.Fonts.infoFont);
	        	infoFractFont = Ui.loadResource(Rez.Fonts.infoFractFont);	        		
	        	infoTitleFont = Ui.loadResource(Rez.Fonts.infoTitleFont);
        	}
        	
        	weekDayFont       = calendarFont; 
        	infoFontSmall     = Ui.loadResource(Rez.Fonts.infoFontSmall);	
        	infoTitleFontTiny = Ui.loadResource(Rez.Fonts.infoTitleFontTiny);
        }	                       
	}
}