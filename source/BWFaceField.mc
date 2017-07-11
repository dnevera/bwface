using Toybox.WatchUi as Ui;

class BWFaceField extends Ui.Drawable {
	
	var topY    = 0;
	var bottomY = 0;
	var properties;	
	//var settings;// =  System.getDeviceSettings();
	var dictionary;
	        
    function initialize(_dictionary, newProperties){
    	properties = newProperties;
    	//settings = properties.settings; 
    	dictionary = _dictionary;
		Drawable.initialize(_dictionary);
    }
}
