using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

class BWFaceSysinfoField extends BWFaceField {
 
 	var batterySize = [18,9]; 
 
 	protected var dc;
 	protected var framePadding;
 
 	function initialize(dictionary,newProperties){
		BWFaceField.initialize(dictionary,newProperties);
		dc = properties.dc;		
		framePadding = dictionary[:framePadding];		
	}
	
	function draw() {
	
		var systemStats = Sys.getSystemStats();
		var battery  = systemStats.battery;
        var fbattery =  battery.format("%d") + "%";
		
		var fsize = dc.getTextDimensions(fbattery, properties.fonts.infoTitleFont);
		
		var w = batterySize[0];
		var h = batterySize[1];
        var x = locX-w/2-fsize[0]/2;
		var y = locY;
        
        if (battery>50){
        	dc.setColor(properties.labelColor, Gfx.COLOR_TRANSPARENT);
        }
        else if (battery>20){
        	dc.setColor(properties.batteryWarnColor, Gfx.COLOR_TRANSPARENT);
        }
        else {
        	dc.setColor(properties.batteryLowColor, Gfx.COLOR_TRANSPARENT);
        }
        
        dc.drawRectangle(x+w, y+h/3.0, 2, h/2.0-1);
        dc.drawRoundedRectangle(x, y, w, h, 2);
        dc.fillRoundedRectangle(x, y, w*battery/100, h, 2);
        
        dc.drawText(x+w+framePadding, y-fsize[1]/2+h/2-2, properties.fonts.infoTitleFont, fbattery , Gfx.TEXT_JUSTIFY_LEFT);
	}	
}