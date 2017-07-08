using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.ActivityMonitor as Monitor;

class BWFaceActivityField extends BWFaceField {
	
	var currentCalories;
		       
	protected var dc;
	protected var stepDraft = "99999";
	protected var stepDraft10 = "99";
	protected var stepDraftFract = "999";
	protected var framePadding;
	protected var frameRadius;
	protected var stepTitleSize;
	protected var sSize;
	protected var s10Size;
	protected var sFractSize;
	
    function initialize(dictionary,newProperties){
		BWFaceField.initialize(dictionary,newProperties);
		dc = properties.dc;		
		framePadding = dictionary[:framePadding];
		frameRadius = dictionary[:frameRadius]; 
		stepTitleSize = dc.getTextDimensions(properties.strings.stepsTitle, properties.fonts.infoTitleFont);
		
		sSize = dc.getTextDimensions(stepDraft, properties.fonts.infoFont);
		s10Size = dc.getTextDimensions(stepDraft10, properties.fonts.infoFont);
		sFractSize = dc.getTextDimensions(stepDraftFract, properties.fonts.infoFractFont);
		
		topY = locY;
		bottomY = locY+stepTitleSize[1]+sSize[1]+framePadding*2; 				
    }

    function draw(){
		
		var monitor = Monitor.getInfo(); 
		
		currentCalories = monitor.calories;
		var calories = BWFace.decFields(currentCalories," ",1,3);
		var distance = BWFace.decFields(monitor.distance.toDouble()/100.0/properties.statuteFactor,",",10,2);
		var steps ;
		var stepx10=0;
		var stepxFract=0;
		
		if (settings.screenShape == System.SCREEN_SHAPE_RECTANGLE){
			sSize[0]  = dc.getWidth()/3;
		}
		else {
			sSize[0]  = dc.getWidth()/3.5;
		}
		
		if (monitor.steps!=null) {
			if (monitor.steps<10000){
				steps = [monitor.steps.format("%02d"),""];
			}
			else { 
				steps = BWFace.decFields(monitor.steps," ",1,3);
				stepx10 = -s10Size[0]/2+1;
				stepxFract = s10Size[0]/2+properties.fractionNumberPadding;
				sSize[0]=s10Size[0]+sFractSize[0];
			}
		}
		else {
			steps = "--";
		}
						
		
		var dSize = dc.getTextDimensions(distance[0], properties.fonts.infoFont);
		var cSize = dc.getTextDimensions(calories[0], properties.fonts.infoFont);
				
		var distx     = locX - sSize[0]/2-framePadding;
		var caloriesx = locX + sSize[0]/2+framePadding+1;
		var stepx = locX + 1;
		var stepy = locY;
		var stepw = sSize[0]+framePadding;
		var stepTitlew = stepTitleSize[0]+framePadding;
		var steph = sSize[1]+framePadding + stepTitleSize[1]; 
		
		stepw = stepw>stepTitlew ? stepw : stepTitlew;
		
		dc.setColor(properties.labelColor, Gfx.COLOR_TRANSPARENT);
		
		var size = dc.getTextDimensions(distance[1], properties.fonts.infoFractFont);
		
		dc.drawText(distx-framePadding-size[0], locY, properties.fonts.infoFont, distance[0], Gfx.TEXT_JUSTIFY_RIGHT);
		dc.drawText(distx-framePadding, locY, properties.fonts.infoFractFont, distance[1], Gfx.TEXT_JUSTIFY_RIGHT);
		dc.drawText(distx-framePadding, locY+dSize[1], properties.fonts.infoTitleFont, properties.strings.distanceTitle, Gfx.TEXT_JUSTIFY_RIGHT);
		
		dc.drawText(stepx+stepx10, locY, properties.fonts.infoFont, steps[0], Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(stepx+stepxFract, locY, properties.fonts.infoFractFont, steps[1], Gfx.TEXT_JUSTIFY_CENTER);
		
		dc.drawText(stepx, locY+dSize[1], properties.fonts.infoTitleFont, properties.strings.stepsTitle, Gfx.TEXT_JUSTIFY_CENTER);
				
		dc.drawText(caloriesx+framePadding, locY, properties.fonts.infoFont, calories[0], Gfx.TEXT_JUSTIFY_LEFT);
		dc.drawText(caloriesx+framePadding+cSize[0]+properties.fractionNumberPadding, locY, properties.fonts.infoFractFont, calories[1], Gfx.TEXT_JUSTIFY_LEFT);
		dc.drawText(caloriesx+framePadding, locY+dSize[1], properties.fonts.infoTitleFont, properties.strings.caloriesTitle, Gfx.TEXT_JUSTIFY_LEFT);
		
		dc.setColor(properties.framesColor, Gfx.COLOR_TRANSPARENT);
		
		var frameH = steph+1;
		dc.drawRoundedRectangle(stepx-(stepw+framePadding)/2, stepy, stepw+framePadding/2, frameH, frameRadius);
				
		var dh = dc.getWidth()/2-(stepw+framePadding)/2;
		dc.drawRoundedRectangle(-2, stepy, dh+2,         frameH, frameRadius);		

		var cx = stepx-(stepw+framePadding)/2 + stepw+framePadding/2+1;
		dc.drawRoundedRectangle(cx, stepy, dc.getWidth(), frameH, frameRadius);					
	}
}