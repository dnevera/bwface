using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System;

class BWFaceNumber {
	
	var dc;
	var x;
	var frameX;
	var y;
	var w;
	var h;
	var scale; // 1 || 10
	var delim = "";
	var font;
	var fontTitle;
	var fontFraction;
	var title;

	protected var prec = 3;
	
	protected var titleSize;
	protected var draft1000Size;
	protected var significantSize;
	protected var fractionSize;
	protected var justification;
	protected var frameColor;
	protected var color;
	protected var bgColor;
	protected var framePadding;
	protected var frameRadius;
	protected var format = "%d";
	
	protected var realFont;
	
	function initialize(_dc,rect,dictionary){
	    
		dc = _dc;
		x = rect[0];
		y = rect[1];
		w = rect[2];
		h = rect[3];
		frameX = rect[4];

		scale = dictionary[:scale] == null ? 1 : dictionary[:scale];
		delim = dictionary[:delim] == null ? 1 : dictionary[:delim];
		font  = dictionary[:font] == null ? 1 : dictionary[:font];		
		format = dictionary[:format] == null ? 1 : dictionary[:format];
		
		fontTitle     = dictionary[:fontTitle] == null ? 1 : dictionary[:fontTitle];
		fontFraction  = dictionary[:fontFraction] == null ? 1 : dictionary[:fontFraction];
		title         = dictionary[:title] == null ? 1 : dictionary[:title];
		justification = dictionary[:justification] == null ? 1 : dictionary[:justification];
		frameColor = dictionary[:frameColor] == null ? 0x4F4F4F : dictionary[:frameColor];
		color = dictionary[:color] == null ? Gfx.COLOR_WHITE : dictionary[:color];
		framePadding = dictionary[:framePadding] == null ? 2 : dictionary[:framePadding];
		frameRadius = dictionary[:frameRadius] == null ? 3 : dictionary[:frameRadius];
		bgColor = dictionary[:bgColor] == null ? Gfx.COLOR_BLACK : dictionary[:bgColor];

		realFont = font;

		var draft;
		if (scale>=10){
			prec = 2;
			draft = delim + "00";
		}
		else {
			draft = delim + "000";
		}
		
		updateSizes("0",draft);
		draft1000Size = dc.getTextDimensions("0000", realFont);
		titleSize     = dc.getTextDimensions(title, fontTitle);
		h = significantSize[1]+titleSize[1];
	}
	
	function updateSizes(signif,draft) {
	
		if (signif.length()>=3){
			realFont = fontFraction;			 
		}
		else {
			realFont = font;
		}
	
		significantSize = dc.getTextDimensions(signif, realFont);
		if (draft!=null){
			fractionSize = dc.getTextDimensions(draft, fontFraction);
		}
		else {
			fractionSize[0]=0;
		}
	}
	
	protected var vstr;
	protected var _x;
	protected var _xf;
	protected var sectRect;
	
	function draw(valueIn, isDynamic, isPartial){
				
		var size = [0,0];
		var dosplit = true; 
		var value = valueIn;
		var isNumber = !(value instanceof Toybox.Lang.String);
		
		vstr = BWFace.decFields(value,delim,scale,prec);
		
		if (isDynamic && isNumber && scale <=1 && value<999) {
			size = draft1000Size;
			if (isNumber){
				vstr = [value.format(format),""];
			}
			dosplit = false;
		}
		else {			
			updateSizes(vstr[0],vstr[1]);
			size[0] = significantSize[0] + fractionSize[0];
			size[1] = significantSize[1];
		}
	
		if (dosplit){
			dosplit = vstr[1].length()>0;
		}
	
		_x = x;
		_xf = x;
		
		var _xt = x;
		var _xr = frameX;
		var _clippingx = x;
		
		if (dosplit) {
			if (justification == Gfx.TEXT_JUSTIFY_CENTER){
				_x -= significantSize[0]/2-1;
				_xf+= fractionSize[0]/2+1;
			}
			else if (justification == Gfx.TEXT_JUSTIFY_LEFT){
				_xf+= significantSize[0];
			}
			else {
				_x -= fractionSize[0];
			}
		}

		if (justification == Gfx.TEXT_JUSTIFY_CENTER){
			_clippingx -= w/2;
			var d = vstr[0].length();
			if (d>=3){
				_x+=significantSize[0]/d/2;
				_xf+=significantSize[0]/d/2;
			}
		}
		else if (justification == Gfx.TEXT_JUSTIFY_LEFT){
			_xf +=framePadding+1;
			_x  +=framePadding+1;
			_xt +=framePadding+1;				
		}
		else {
			_xf+=-framePadding+w;
			_x +=-framePadding+w;
			_xt+=-framePadding+w;
		}
		
		dc.setColor(color, Gfx.COLOR_TRANSPARENT);
		
		sectRect = [_clippingx, y, w, h];
		if (isPartial && isNumber) {
			partialDraw(valueIn.format("%02.0f"), null, false);
		}
		else {
			partialDraw(vstr[0],vstr[1],false);
		}
		dc.drawText(_xt, y+h-titleSize[1], fontTitle, title, justification);	
		
		dc.setColor(frameColor, Gfx.COLOR_TRANSPARENT);
		dc.setPenWidth(1);
		dc.drawRoundedRectangle(_xr, y, w, h+framePadding+2, frameRadius);	
	}
			
	var oldValue = null;
	function partialDraw(value,fract,clipping){	

			if (clipping){
				dc.setClip(sectRect[0], sectRect[1], sectRect[2], sectRect[3]);
			}
		
			if (oldValue!=null){ 
				dc.setColor(bgColor, bgColor);
				dc.drawText(_x,  y+1, realFont, oldValue, justification);
			}
			oldValue = value;
			dc.setColor(color, Gfx.COLOR_TRANSPARENT);
			var offset = 0;
			if (value.length()>=3){
				offset = 2;
			}
			dc.drawText(_x,  y+offset, realFont, value, justification);
			if (fract !=null ){
				dc.drawText(_xf, y+2, fontFraction,      fract, justification);
			}
	}
}
