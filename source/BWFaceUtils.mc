using Toybox.Lang;
using Toybox.System;
using Toybox.Graphics as Gfx;

module BWFace {

	var partialUpdatesAllowed = ( Toybox.WatchUi.WatchFace has :onPartialUpdate );	

	function decimals(n,scale){
		var t0=(n.toFloat())/1000.0;
		var t1=(n.toFloat())/1000.0;
		var fract = ((((t1 - n.toLong()/1000)*1000).toFloat())/scale.toFloat()).toLong();
		return [t0.toLong(),fract];
	}
	
	function decFields(value,delim,scale,prec){
		if (value==null) {
			return ["--",""];
		} 
		if (value instanceof Lang.String){
			var index = value.find(":");
			if (index==null){
			    index = value.find(".");
			    if (index==null){
				    return [value,""];
				}
				index = 1;
			}
			var v0 = value.substring(0, index);
			var v1 = value.substring(index, value.length());
			return [v0,v1];
		}				
		var dec  = decimals(value.toNumber(),scale);	
		return [dec[0].toString(),delim+dec[1].format("%0"+prec+"d")];
	}
	
	function messagesIcon(dc, x, y, w, h){
	    var m = [[x,y], [x+w,y], [x+w,y+h], [x+w*2/3-1,y+h], [x+w*1/3-1,y+h+h/2], [x+w*1/3-1,y+h], [x,y+h]];
		dc.fillPolygon(m);
	}

	function phoneIcon(dc, _x, y, size, width, color, isConnected){
		var x = _x + size;

		dc.setPenWidth(width);
		
		dc.setColor(color, Gfx.COLOR_TRANSPARENT);
	
		if (isConnected){
			dc.drawLine(x-size/2-2, y-size/2-1, x+size/2, y+size/2);
			dc.drawLine(x-size/2-2, y+size/2+1, x+size/2, y-size/2);
			dc.drawLine(x-1, y+size, x-1, y-size);
			dc.drawLine(x-1, y+size, x+size/2, y+size/2-1);
			dc.drawLine(x-1, y-size, x+size/2, y-size/2+1);
		}
		else {
			dc.drawLine(x-size/2-1, y-size/2, x+size/2, y+size/2+1);
			dc.drawLine(x-size/2-1, y+size/2, x+size/2, y-size/2-1);
		}
	}
}