using Toybox.WatchUi as Ui;

class BWFaceField extends Ui.Drawable {
	
	var topX    = 0;
	var bottomX = 0;
	var properties;	
        
    function initialize(dictionary, newProperties){
    	properties = newProperties;
		Drawable.initialize(dictionary);
    }
}
