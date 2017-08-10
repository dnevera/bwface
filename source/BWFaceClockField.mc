using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

class BWFaceClockField extends BWFaceField {
	       
	protected var dc;
	protected var font;
	var hoursSize;
	var minutesSize;
	var is24Hour;
	
    function initialize(dictionary,newProperties){
		BWFaceField.initialize(dictionary,newProperties);
		dc = properties.dc;
		font = properties.fonts.clockFont;	
		topY = locY;	
		hoursSize   = dc.getTextDimensions("00", font);
		minutesSize = dc.getTextDimensions("00", font);	
		bottomY = locY + hoursSize[1]; 
		is24Hour = Sys.getDeviceSettings().is24Hour;  						
    }

    function draw(today){
		
		var hours   = today.hour;
		var minutes = today.min;		
		var hformat = "";	
		var space   = "";	
		var ampm    = null;		

        if (!is24Hour) {
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
        	if (hours<10) {        	
				hoursSize   = dc.getTextDimensions("0", font);
			}
			else {
				hoursSize   = dc.getTextDimensions("00", font);
			}
        } else {
			hformat = "02";		
        }
        
        hours   = hours.format("%"+hformat+"d");
		minutes = minutes.format("%02d");		
				
		var x = locX;
		var y = locY;		
		
		var colonSize = [12,22,8,8,1];
		
		var yc = locY+hoursSize[1]/2-colonSize[2];
		var xc = x-colonSize[2]/2;
		var ycc = yc;
		
		if (!is24Hour && dc.getWidth()<=148) {
			ycc = locY+hoursSize[1]/2 - colonSize[2] + colonSize[3]/2;
		}
		
		dc.setColor(properties.colonColor, Gfx.COLOR_TRANSPARENT);
		dc.fillRectangle(xc, ycc,              colonSize[2], colonSize[3]);
		dc.fillRectangle(xc, ycc+colonSize[1], colonSize[2], colonSize[3]);
		
		dc.setColor(properties.hoursColor, Gfx.COLOR_TRANSPARENT);
		dc.drawText(x-colonSize[0]-hoursSize[0], y, font, hours, Gfx.TEXT_JUSTIFY_LEFT);
				
		dc.setColor(properties.minutesColor, Gfx.COLOR_TRANSPARENT);
		dc.drawText(x+colonSize[0]-colonSize[4], y, font, minutes, Gfx.TEXT_JUSTIFY_LEFT);

		if (ampm!=null){
			dc.setColor(properties.hoursColor, Gfx.COLOR_TRANSPARENT);
			var ampmsize = dc.getTextDimensions(ampm, properties.fonts.infoTitleFont);
			var xa, ya;
			if (dc.getWidth()<=148) { // vivoactive
				xa = xc-colonSize[2]/2;
				ya = yc-colonSize[3]-ampmsize[1]/2;
			}
			else {
				xa = properties.caloriesCircleWidth+ampmsize[0]/2;
				ya = locY+hoursSize[1]/2;
			}
			dc.drawText(xa, ya, properties.fonts.infoTitleFont, ampm, Gfx.TEXT_JUSTIFY_LEFT);
		}  		
    }
}
