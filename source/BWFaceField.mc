using Toybox.WatchUi as Ui;

class BWFaceField extends Ui.Drawable {
	
	var properties;	
        
    function initialize(dictionary, newProperties){
    	properties = newProperties.weak();
		Drawable.initialize(dictionary);
    }
}
