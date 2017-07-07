using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.UserProfile as User;
using Toybox.Time.Gregorian as Calendar;

class BWFaceDBmrMeter extends BWFaceField {
	
	var userBmr;
		       
	protected var dc;
	protected var drawTopTitles = true;
	
    function initialize(dictionary,newProperties){
		BWFaceField.initialize(dictionary,newProperties);
		dc = properties.dc;	
		userBmr = bmr();	
		
		 if (dc.getHeight()<=180){
        	drawTopTitles = false;
		}
	}
	
	function draw(calories)  {
	
		var cl = calories - userBmr;
		var isDeficit =  cl>=0;
		var prcnt = (cl/userBmr).abs();
				
		var color = isDeficit ? properties.deficitColor : properties.surplusColor ;
		
		cl = cl.abs();
				
		var fields = BWFace.decFields(cl," ",1,3);
		
		var value = fields[0];
		var fract = fields[1];
		
		var fractSize = dc.getTextDimensions(fract, properties.fonts.infoFractFont);
		var size      = dc.getTextDimensions(value, properties.fonts.infoFont);
		 
		var title = " "+properties.strings.caloriesTitle;
	
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
				
		if (properties.caloriesCircleTickOn12) {
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
		if (properties.caloriesCircleTickOn12){
		}
		else {
			dc.drawLine(circleX-tickW, txtY, dc.getWidth()-1, txtY);
		}

		dc.setColor(properties.labelColor,  Gfx.COLOR_TRANSPARENT);
		dc.drawText(txtX-properties.caloriesCircleWidth, caloriesLinePos,  properties.fonts.infoFont, value, Gfx.TEXT_JUSTIFY_LEFT);
		
		var fractPos = caloriesLinePos+size[1]-fractSize[1]-1;
		dc.drawText(txtX-properties.caloriesCircleWidth+size[0]-1, fractPos,  properties.fonts.infoFractFont, fract, Gfx.TEXT_JUSTIFY_LEFT);
		
		if (drawTopTitles) {
			var caloriesTitleLinePos = caloriesLinePos+2; 
			dc.drawText(txtX-properties.caloriesCircleWidth+size[0],  caloriesTitleLinePos, properties.fonts.infoTitleFontTiny, title, Gfx.TEXT_JUSTIFY_LEFT);
		}
				
		dc.setPenWidth(1);		
		//caloriesOffsetPos = dc.getWidth() - (txtX-caloriesCircleWidth-tickW+size[0]+fractSize[0]);
	}
	
	
	function bmr(){
		var profile = User.getProfile();		
		var bmrvalue;
		var today = Calendar.info(Time.now(), Time.FORMAT_LONG);
		var w   = profile.weight;
		var h   = profile.height;
		var g   = profile.gender; 
		var birthYear = profile.birthYear;
		if (birthYear<100) {
		    // simulator
			birthYear = 1900+birthYear;
		}
		var age = today.year - birthYear;
				
		if (g == User.GENDER_FEMALE) {		
			bmrvalue = 655.0 + (9.6*w/1000.0) + (1.8*h) - (4.7*age);
		}
		else {
			bmrvalue = 66 + (13.7*w/1000.0) + (5.0*h) - (6.8*age);
		}		
		return bmrvalue;
	}
}