using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

class BWFaceClockField extends BWFaceField {
	       
	var dc;
    function initialize(dictionary,newProperties){
		BWFaceField.initialize(dictionary,newProperties);
		dc = properties.dc;		
    }

    function draw(today){
		
		var hours   = today.hour;
		var minutes = today.min;		
		var hformat = "";	
		var ampm    = null;		
        
        if (!Sys.getDeviceSettings().is24Hour) {
            if ( hours >= 12 ) {
            	ampm = "PM";
            }
            else {
            	ampm = "AM";
            }
            hours %= 12;
            if(hours==0){
        		hours=12;
        	}
        } else {
			hformat = "02";		
        }
        
        hours   = hours.format("%"+hformat+"d");
		minutes = minutes.format("%02d");		
		
		var hoursSize   = dc.getTextDimensions(hours, properties.fonts.clockFont);
		var minutesSize = dc.getTextDimensions(minutes, properties.fonts.clockFont);
		
		var x = locX;
		var y = locY;		
		
		var colonSize = [12,22,8,8,1];
		
		var yc= dc.getHeight()/2-colonSize[1]/2;
		
		dc.setColor(properties.colonColor, Gfx.COLOR_TRANSPARENT);
		dc.fillRectangle(x-colonSize[2]/2, yc,              colonSize[2], colonSize[3]);
		dc.fillRectangle(x-colonSize[2]/2, yc+colonSize[1], colonSize[2], colonSize[3]);
		
		dc.setColor(properties.hoursColor, Gfx.COLOR_TRANSPARENT);
		dc.drawText(x-colonSize[0]-hoursSize[0], y, properties.fonts.clockFont, hours, Gfx.TEXT_JUSTIFY_LEFT);
				
		dc.setColor(properties.minutesColor, Gfx.COLOR_TRANSPARENT);
		dc.drawText(x+colonSize[0]-colonSize[4], y, properties.fonts.clockFont, minutes, Gfx.TEXT_JUSTIFY_LEFT);

		if (ampm!=null){
			dc.setColor(properties.hoursColor, Gfx.COLOR_TRANSPARENT);
			var ampmsize = dc.getTextDimensions(ampm, properties.fonts.infoTitleFont);
			dc.drawText(properties.caloriesCircleWidth, dc.getHeight()/2, 
			            properties.fonts.infoTitleFont, ampm, Gfx.TEXT_JUSTIFY_LEFT);
		}      	
    }
}
