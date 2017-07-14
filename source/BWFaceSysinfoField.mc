using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

enum {
	BW_SysBatteryNone    = 100,
	BW_SysBattery        = 101,
	BW_SysBatteryPhone   = 102,
	BW_SysPhone          = 103
}

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
	
		var picon = false; //properties.getProperty("SystemStatus", BW_SysBattery);
		var bicon = false; //properties.getProperty("ShowBatteryIcon", false);
		
		switch(properties.getProperty("SystemStatus", BW_SysBattery)) {
			case BW_SysBatteryNone: 
				break;
			case BW_SysBattery:
				bicon = true;
				break;
			case BW_SysBatteryPhone:
				bicon = true;
				picon = true;
				break;
			case BW_SysPhone:
				picon = true;
				break;
		}
	
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
        
        if (bicon) {
        	dc.drawRectangle(x+w, y+h/3.0, 2, h/2.0-1);
       		dc.drawRoundedRectangle(x, y, w, h, 2);
        	dc.fillRoundedRectangle(x, y, w*battery/100, h, 2);
        }
        
        var xp = bicon ? x+w+framePadding : locX;
        var yp = y-fsize[1]/2+h/2-2;      
        
        if (picon){
        	xp = bicon ? xp+properties.btIconSize : xp - properties.btIconSize*3+properties.btIconSize/2;
        	var color = Sys.getDeviceSettings().phoneConnected ? properties.btIconColor: Gfx.COLOR_DK_GRAY;
	        BWFace.phoneIcon(dc,
                         xp+properties.btIconSize, y+h/2, 
                         properties.btIconSize, properties.btIconPenWidth, 
                         color);
        }
        else if (bicon) {
       		dc.drawText(xp, yp, properties.fonts.infoTitleFont, fbattery , Gfx.TEXT_JUSTIFY_LEFT);
       	}
        
        //dc.drawText(x+w+framePadding, y-fsize[1]/2+h/2-2, properties.fonts.infoTitleFont, fbattery , Gfx.TEXT_JUSTIFY_LEFT);
	}	
}