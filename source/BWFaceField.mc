using Toybox.WatchUi as Ui;

class BWFaceField extends Ui.Drawable {
	
	var topY    = 0;
	var bottomY = 0;
	var properties;	
	var dictionary;
	        
    function initialize(_dictionary, newProperties){
    	properties = newProperties;
    	dictionary = _dictionary;
		Drawable.initialize(_dictionary);
    }
}
