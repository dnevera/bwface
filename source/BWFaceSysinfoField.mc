using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

enum {
	BW_SysBatteryNone    = 100,
	BW_SysBattery        = 101,
	BW_SysBatteryPhone   = 102,
	BW_SysPhone          = 103,
	BW_SysBatteryPhoneNotifications = 104,
	BW_SysPhoneNotifications = 105,
	BW_SysNotifications = 106
}

class BWFaceSysinfoField extends BWFaceField {
 
 	var batterySize = [18,9]; 
 	var messageSize = [12,7];

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

        var wm = messageSize[0];
        var w = batterySize[0];
        var h = batterySize[1];
        var hm = messageSize[1];
        var x = locX-w/2-fsize[0]/2;
        var y = locY;

		var picon = false; 
		var bicon = false;
		var micon = false;

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
            case BW_SysBatteryPhoneNotifications:
				bicon = true;
				picon = true;
				micon = Sys.getDeviceSettings().notificationCount>0;
				break;
            case BW_SysPhoneNotifications:
				picon = true;
				micon = Sys.getDeviceSettings().notificationCount>0;
				x = locX-properties.btIconSize;
				break;
            case BW_SysNotifications:
				micon = Sys.getDeviceSettings().notificationCount>0;
				x = locX;
				break;
		}
        
        dc.setColor(properties.labelColor, Gfx.COLOR_TRANSPARENT);

        if (micon) {
            BWFace.messagesIcon(dc,x-wm/2, y, wm, hm);
            x += wm/2+4;
            x = picon ? x + properties.btIconSize/2 : x;
        }

        if (battery>50){
        	dc.setColor(properties.labelColor, Gfx.COLOR_TRANSPARENT);
        }
        else if (battery>20){
        	dc.setColor(properties.batteryWarnColor, Gfx.COLOR_TRANSPARENT);
        }
        else {
        	dc.setColor(properties.batteryLowColor, Gfx.COLOR_TRANSPARENT);
        }

        x = picon ? x + properties.btIconSize/2 : x;
        
        if (bicon) {
        	dc.drawRectangle(x+w, y+h/3.0, 2, h/2.0-1);
       		dc.drawRoundedRectangle(x, y, w, h, 2);
        	dc.fillRoundedRectangle(x, y, w*battery/100, h, 2);
        }

        var xp = bicon ? x+w+framePadding : locX;
        var yp = y-fsize[1]/2+h/2-2;

        if (picon){
        	xp = bicon ? xp  : locX-properties.btIconSize - framePadding;
        	xp = micon && !bicon ? xp + wm : xp;
        	var color = Sys.getDeviceSettings().phoneConnected ? properties.btIconColor: 0x303030;
	        BWFace.phoneIcon(dc,
                         xp+properties.btIconSize, y+h/2, 
                         properties.btIconSize, properties.btIconPenWidth, 
                         color,
                         Sys.getDeviceSettings().phoneConnected);
        }
        else if (bicon) {
       		dc.drawText(xp, yp, properties.fonts.infoTitleFont, fbattery , Gfx.TEXT_JUSTIFY_LEFT);
       	}        
	}	
}