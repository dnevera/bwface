using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.UserProfile as User;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Math as Math;

class BWFaceDBmrMeter extends BWFaceField {
	
	//var userBmr;
	var tickPosX = 0;		       
	var tickPosY = 0;		       
		       
	protected var dc;
	protected var drawTopTitles = true;	
	
    function initialize(dictionary,newProperties){
		BWFaceField.initialize(dictionary,newProperties);
		dc = properties.dc;	
		//userBmr = properties.bmr();			
	}
	
	var cl;
	var isDeficit;
	var prcnt;
	var color;
	var fields;
	var value;
	var fract;
	var fractSize;
	var size;		 
	var title;
	
	var scale = 1;
	var isSemiRound;
	
	function prepare(calories,isSemiRound){
		var userBmr = properties.bmr();
		cl = calories - userBmr;
		isDeficit =  cl>=0;
		prcnt = (cl/userBmr).abs();
				
		color = isDeficit ? properties.deficitColor : properties.surplusColor ;
		
		cl = cl.abs();

		if (isDeficit){
			scale = Math.floor(prcnt+1);
	
			if (scale > 1) {
				var ncl = calories - userBmr*scale;
				prcnt = (ncl/userBmr).abs()/scale;
			}				
		}
					
		fields = BWFace.decFields(cl," ",1,3);
		
		value = fields[0];
		fract = fields[1];
		
		fractSize = dc.getTextDimensions(fract, properties.fonts.infoFractFont);
		size      = dc.getTextDimensions(value, properties.fonts.infoFont);
		 
		title = " "+properties.strings.caloriesTitle;		
	} 
	
	function drawInRectangle(calories) {
	
		var y = locY+1;
		var tickW = properties.caloriesCircleTickWidth;
		
		dc.setColor(color,  Gfx.COLOR_TRANSPARENT);
		dc.setPenWidth(properties.caloriesCircleWidth);
	
		var ex = dc.getWidth(); 
		var tickX = ex-tickW/2;	
		dc.drawLine(tickX, y-tickW/2, tickX+tickW/2, y);
		
		var x = ex - ex * prcnt; 

		dc.drawLine(x, y, tickX+tickW/2, y);
		
		dc.setPenWidth(1);	
		
		var txtX = ex-size[0]-fractSize[0]-tickW/2;
		var caloriesLinePos = y-size[1] - properties.caloriesCircleWidth;
	
		txtX -= properties.caloriesCircleWidth;
		dc.setColor(properties.labelColor,  Gfx.COLOR_TRANSPARENT);
		dc.drawText(txtX, caloriesLinePos,  properties.fonts.infoFont, value, Gfx.TEXT_JUSTIFY_LEFT);
				
		var fractPos = caloriesLinePos+size[1]-fractSize[1]-1;
		txtX += size[0]+properties.fractionNumberPadding;
		dc.drawText(txtX, fractPos,  properties.fonts.infoFractFont, fract, Gfx.TEXT_JUSTIFY_LEFT);
	
		if (drawTopTitles) {
			var caloriesTitleLinePos = caloriesLinePos+2; 
			dc.drawText(txtX+1,  caloriesTitleLinePos, properties.fonts.infoTitleFontTiny, title, Gfx.TEXT_JUSTIFY_LEFT);
			if (isDeficit && scale>1){
				var p = scale.format("%d");
				dc.drawText(dc.getWidth()/2, caloriesLinePos, properties.fonts.infoFont, p, Gfx.TEXT_JUSTIFY_LEFT);
			}			
		}
	
		tickPosX = properties.caloriesCircleWidth+tickW;
		tickPosY = caloriesLinePos;							
	}
	
	function drawInRound(calories, isSemiRound){	
		var x = dc.getWidth().toFloat()/2;
		var y = dc.getHeight().toFloat()/2;
		var r = x-properties.caloriesCircleWidth/2;
		
		var tickW = properties.caloriesCircleTickWidth;
		var txtY  = locY+size[1]/2; 
		
		var cat   = y - txtY;
		
		var sin   = cat.toFloat()/r.toFloat();
		var angle = Math.asin(sin);
		
		var circleX = Math.cos(angle)*r+x;
		var txtX = circleX-size[0]-fractSize[0]-tickW;
				
		var s = angle*180.0/Math.PI;
				
		if (!isSemiRound && properties.caloriesCircleTickOn12) {
			s = 90;
		} 
								
		dc.setColor(color,  Gfx.COLOR_TRANSPARENT);
		dc.setPenWidth(properties.caloriesCircleWidth*2);
							
		var start;
		var end;
		var dir;
		if (isDeficit) {
			start = s;
			end   = s-360*prcnt.abs();
			dir =  Gfx.ARC_CLOCKWISE;
		}
		else {
			start = 360-360*prcnt.abs()+s;
			end = 360 + s;
			dir =  Gfx.ARC_COUNTER_CLOCKWISE;
		}
				
		dc.drawArc(x, y, r+properties.caloriesCircleWidth/2, dir, start, end);

		// pseudo antialiasing
		dc.setPenWidth(1);

		dc.setColor(properties.bgColor,  properties.bgColor);
		dc.drawArc(x, y, r-properties.caloriesCircleWidth/2, dir, start, end);
							
		var caloriesLinePos = txtY-size[1]/2-2;
		
		dc.setColor(color,  Gfx.COLOR_TRANSPARENT);
		dc.setPenWidth(properties.caloriesCircleWidth-1);
		if (!properties.caloriesCircleTickOn12 || isSemiRound){
			dc.drawLine(circleX-tickW, txtY, dc.getWidth()-1, txtY);
		}

		txtX -=properties.caloriesCircleWidth;
		 
		dc.setColor(properties.labelColor,  Gfx.COLOR_TRANSPARENT);
		dc.drawText(txtX, caloriesLinePos,  properties.fonts.infoFont, value, Gfx.TEXT_JUSTIFY_LEFT);
		
		txtX += size[0];
		var fractPos = caloriesLinePos+size[1]-fractSize[1]-1;
		dc.drawText(txtX-1+properties.fractionNumberPadding, fractPos,  properties.fonts.infoFractFont, fract, Gfx.TEXT_JUSTIFY_LEFT);
		
		if (drawTopTitles) {
			var y = caloriesLinePos+2;
			txtX +=properties.fractionNumberPadding;  
			dc.drawText(txtX, y, properties.fonts.infoTitleFontTiny, title, Gfx.TEXT_JUSTIFY_LEFT);
			if (isDeficit && scale>1){
				var p = " "+scale.format("%d");
				dc.drawText(txtX+fractSize[0]+properties.caloriesCircleWidth, y, properties.fonts.infoTitleFontTiny, p, Gfx.TEXT_JUSTIFY_LEFT);
			}
		}
				
		dc.setPenWidth(1);		
		tickPosX = dc.getWidth() - (txtX-properties.caloriesCircleWidth-tickW+size[0]+fractSize[0]);
		tickPosY = caloriesLinePos;
	}
	
	function draw(calories)  {

		isSemiRound = Sys.getDeviceSettings().screenShape == System.SCREEN_SHAPE_SEMI_ROUND;
				
		prepare(calories,isSemiRound);
		
		if (Sys.getDeviceSettings().screenShape == System.SCREEN_SHAPE_RECTANGLE){
			drawInRectangle(calories);
		} 
		else {
			drawInRound(calories,isSemiRound);
		}
	}
}