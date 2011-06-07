package com.samplemath.configuration {

	import com.samplemath.composition.Registry;
	import com.samplemath.event.SMAFEvent;
	import com.samplemath.load.Data;

	import flash.events.Event;



/**
*	Static utility class for maintaing global access to application configuration values. 
*	This class is not meant to be instantiated.
*/
 	public class Configuration {
		


		private static const APPLICATION:String = "application";               
		private static const CONFIGURATION:String = "configuration";               
		private static const EMPTY_STRING:String = "";               
		private static const REQUIRE_NODE:XML = <require/>;

/**
*		Application configuration data. 
*/
	    public static var data:XML = <configuration/>;
	
/**
*		Framework version this documentation covered. 
*		
*		@default v2.0.16
*/
		public static const FRAMEWORK_VERSION:String = "v2.0.16";

/**
*		Application version. 
*		
*		@default ""
*/
		public static var version:String = "";



/**
*		Static utility class, not meant to be instantiated.
*/
		public function Configuration() {
		}
		


/**
*		@private
*/
		public static function handleIncludeLoaded(event:Event):void {
			data.appendChild(new XML(event.target.data));            
			loadIncludes();
		}                  

/**
*		@private
*/
		public static function handleConfigurationLoaded(event:Event):void {
			data = new XML(event.target.data);            
			loadIncludes();
		}                  

/**
*		@private
*/
		public static function handleSiteConfigurationReady(parameter:String):void {
			Registry.get(APPLICATION).dispatchEvent(new SMAFEvent(SMAFEvent.CONFIGURATION_AVAILABLE));
		}

/**
*		Loads an XML include in the configuration data.
*
* 		@param URL The URL of the XML include. 
* 		@param The unique identifier for the object to call the method on when the include has loaded in the configuration data. 
* 		@param The name of the method to call. 
*
*/
		public static function requestInclude(URL:String):void {
			var requireData:XML = REQUIRE_NODE;
			requireData.@url = URL;
			data.appendChild(requireData);
			loadIncludes();
		}

/**
*		@private
*/
		public static function loadConfigurationData(path:String):void {     
			Registry.set(Configuration, CONFIGURATION);
			var configurationData:Data = new Data(path);
			configurationData.loader.addEventListener(Event.COMPLETE, Configuration.handleConfigurationLoaded);
		}   
		
		private static function loadInclude(includeData:XML):void {  
			var includeToLoadData:Data = new Data(includeData.@url.toString());
			includeToLoadData.loader.addEventListener(Event.COMPLETE, Configuration.handleIncludeLoaded);
		}
		
		private static function loadIncludes():void {
			if (data..require.length()) {
				loadInclude(data..require[0]);
				delete data..require[0];
			} else {
				handleSiteConfigurationReady(null);
			}
		}
	}
}