using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

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
		fontTitle     = dictionary[:fontTitle] == null ? 1 : dictionary[:fontTitle];
		fontFraction  = dictionary[:fontFraction] == null ? 1 : dictionary[:fontFraction];
		title         = dictionary[:title] == null ? 1 : dictionary[:title];
		justification = dictionary[:justification] == null ? 1 : dictionary[:justification];
		frameColor = dictionary[:frameColor] == null ? 0x4F4F4F : dictionary[:frameColor];
		color = dictionary[:color] == null ? Gfx.COLOR_WHITE : dictionary[:color];
		framePadding = dictionary[:framePadding] == null ? 2 : dictionary[:framePadding];
		frameRadius = dictionary[:frameRadius] == null ? 3 : dictionary[:frameRadius];
		bgColor = dictionary[:bgColor] == null ? Gfx.COLOR_BLACK : dictionary[:bgColor];

		var draft;
		if (scale>=10){
			prec = 2;
			draft = delim + "00";
		}
		else {
			draft = delim + "000";
		}
		
		updateSizes("0000","0",draft);
		draft1000Size = dc.getTextDimensions("0000", font);
		titleSize     = dc.getTextDimensions(title, fontTitle);
		h = significantSize[1]+titleSize[1];
	}
	
	function updateSizes(value,signif,draft) {
		significantSize = dc.getTextDimensions(signif, font);
		fractionSize = dc.getTextDimensions(draft, fontFraction);
	}
	
	protected var vstr;
	protected var _x;
	protected var _xf;
	protected var sectRect;
	
	function draw(value, isDynamic, isPartial){
		
		var size = [0,0];
		var dosplit = true; 
				
		vstr = dosplit ? BWFace.decFields(value,delim,scale,prec) : [value.format("%d"),""];		
		
		if (isDynamic && value<999 && scale <=1) {
			size = draft1000Size;
			vstr = [value.format("%d"),""];
			dosplit = false;
		}
		else {
			vstr = BWFace.decFields(value,delim,scale,prec);
			updateSizes(value,vstr[0],vstr[1]);
			size[0] = significantSize[0] + fractionSize[0];
			size[1] = significantSize[1];
		}
		
		_x = x;
		_xf = x;
		
		var _xt = x;
		var _xr = frameX;
		if (dosplit) {
			if (justification == Gfx.TEXT_JUSTIFY_CENTER){
				_x -= significantSize[0]/2;
				_xf+= fractionSize[0]/2;
			}
			else if (justification == Gfx.TEXT_JUSTIFY_LEFT){
				_xf+= significantSize[0];
			}
			else {
				_x -= fractionSize[0];
			}
		}

		if (justification == Gfx.TEXT_JUSTIFY_CENTER){
			//_xr -= w/2;
		}
		else if (justification == Gfx.TEXT_JUSTIFY_LEFT){
			_xf +=framePadding;
			_x  +=framePadding;
			_xt +=framePadding;				
		}
		else {
			_xf+=-framePadding+w;
			_x +=-framePadding+w;
			_xt+=-framePadding+w;
		}
		
		dc.setColor(color, Gfx.COLOR_TRANSPARENT);
		
		sectRect = [_x, y, significantSize[0]+fractionSize[0], h-titleSize[1]];
		partialDraw(vstr[0],vstr[1]);
		dc.drawText(_xt, y+significantSize[1], fontTitle, title, justification);	
		
		dc.setColor(frameColor, Gfx.COLOR_TRANSPARENT);
		dc.setPenWidth(1);
		dc.drawRoundedRectangle(_xr, y, w, h+2*framePadding, frameRadius);	
	}
	
	var oldValue = null;
	function partialDraw(value,fract){
			if (oldValue!=null){ 
				dc.setColor(bgColor, bgColor);
				dc.drawText(_x,  y, font, oldValue, justification);
			}
			oldValue = value;
			//dc.fillRectangle(sectRect[0],sectRect[1],sectRect[2],sectRect[3]);
			dc.setColor(color, Gfx.COLOR_TRANSPARENT);
			dc.drawText(_x,  y, font, value, justification);
			if (fract !=null ){
				dc.drawText(_xf, y, fontFraction,      fract, justification);
			}
	}
}
