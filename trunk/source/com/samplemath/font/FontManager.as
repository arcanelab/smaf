package com.samplemath.font {

	import com.samplemath.composition.Registry;
	import com.samplemath.configuration.Configuration;
	import com.samplemath.event.SMAFEvent;
	import com.samplemath.load.Data;
	import com.samplemath.load.ServiceProxy;

	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	                                                                 
	import com.samplemath.thirdparty.ru.etcs.utils.FontLoader;	
	



/**
*	Static utility class supporting runtime loading and registering fonts as well as using system fonts.
*/
 	public class FontManager {
		
		private static var fontListToLoad:XML = <fonts/>;
		private static var fontsAvailable:XML = <fonts/>;
		private static var fontData:Array = [];
		private static var fontsLoaded:XML = <fonts/>;
		private static var _fontListURL:String;
		private static var _fontID:String;
		private static var _fontName:String;
		private static var _fontURL:String;              
		private static var _parameters:String;              
		private static var _stage:Stage;              
		private static var _waitForFontsCounter:int;
			
		private static const CDATA_PREFIX:String = "<![CDATA[";
		private static const CDATA_SUFFIX:String = "]]>";
		private static const COMMA:String = ",";
		private static const EMPTY_STRING:String = "";               
		private static const FONT_NODE:XML = <font/>;

/**
*		Default font name.
*/
		public static const DEFAULT_FONT:String = "_sans";
/**
*		The default font is not embedded.
*/
		public static const DEFAULT_FONT_EMBEDDED:Boolean = false;



/**
*		Static utility class, not meant to be instantiated.
*/
		public function FontManager() {
		}



		
/**
*		Checks whether a font is available to load by fontID.
*
*		@param fontID The unique font ID.
*
*		@return Whether the font is available as Boolean.
*/
		public static function fontIsAvailable(fontID:String):Boolean {
			var response:Boolean = false;      
			if (fontsAvailable.font.(@id.toString() == fontID).length()) {
				response = true;
			}                   
			return response;
		}
		
/**
*		Checks whether a font is loaded by fontID.
*
*		@param fontID The unique font ID.
*
*		@return Whether the font is available as Boolean.
*/
		public static function fontIsLoaded(fontID:String):Boolean {
			var response:Boolean = false;      
			if (fontsLoaded.font.(@id.toString() == fontID).length()) {
				response = true;
			}                   
			return response;
		}

/**
*		Checks whether a font has been requested  and may be in the process of loading, by fontID.
*
*		@param fontID The unique font ID.
*
*		@return Whether the font has already been requested as Boolean.
*/
		public static function fontIsRequested(fontID:String):Boolean {
			var response:Boolean = false;      
			if (fontsLoaded.font.(@id.toString() == fontID).length()) {
				response = true;
			}                   
			if (fontsAvailable.font.(@id.toString() == fontID).length()) {
				response = true;
			}                   
			return response;
		}

/**
*		The list of fonts available to load in XML.
*/
		public static function get fontListAvailable():XML {
			return fontsAvailable;
		}
		
/**
*		The list of fonts loaded and available for rendering text in XML.
*/
		public static function get fontListLoaded():XML {
			return fontsLoaded;
		}
		
		private static function handleFontListLoaded(event:Event):void {
			var data:XML = new XML(event.target.data);
			for each(var fontData:XML in data.font) {
				registerFontAvailable(fontData.@id.toString(), fontData.text(), fontData.@url.toString());
			}                               
			_stage.dispatchEvent(new SMAFEvent(SMAFEvent.FONT_LIST_AVAILABLE));
		}

		private static function handleFontListRequestedLoaded(event:Event):void {
			fontListToLoad = new XML(event.target.data);            
			loadNextFontInList();
		}
            
		private static function handleFontLoadedFromList(event:Event):void {         
			if (fontListToLoad.font.length())
			{
				registerFont(fontData[event.currentTarget].@id.toString(), fontData[event.currentTarget].font[0].text(), fontData[event.currentTarget].font[0].@url.toString());
				fontData[event.currentTarget] = null;
			}
			loadNextFontInList();
		}

		private static function handleFontPackLoaded(event:Event):void {
		}

		private static function handleLoadError(event:IOErrorEvent):void {
		}

		private static function loadFontList():void {
			var requestData:URLVariables = new URLVariables(); 
			requestData.parameters = _parameters;
			var fontListData:Data = new Data(_fontListURL, requestData);
			fontListData.loader.addEventListener(Event.COMPLETE, FontManager.handleFontListLoaded, false, 0, true);
		}
		
		private static function loadFontListRequested():void {
			var requestData:URLVariables = new URLVariables(); 
			requestData.parameters = _parameters;
			var fontListData:Data = new Data(_fontListURL, requestData);
			fontListData.loader.addEventListener(Event.COMPLETE, FontManager.handleFontListRequestedLoaded, false, 0, true);
		}
		
		private static function loadNextFontInList():void {
			if (fontListToLoad.font.length()) {
				var thisFontPack:FontLoader = new FontLoader(); 
				thisFontPack.addEventListener(Event.COMPLETE, handleFontLoadedFromList, false, 0, true);
				thisFontPack.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError, false, 0, true);
				thisFontPack.load(new URLRequest(ServiceProxy.baseURL + fontListToLoad.font[0].@url.toString()));
				registerFontAvailable(fontListToLoad.font[0].@id.toString(), fontListToLoad.font[0].text(), fontListToLoad.font[0].@url.toString());
				if (!fontData)
				{
					fontData = [];
				}
				fontData[thisFontPack] = fontListToLoad.font[0];
				delete fontListToLoad.font[0];
			} else {
				_waitForFontsCounter = 5;
				_stage.addEventListener(Event.ENTER_FRAME, handleWaitForFonts, false, 0, true);
			}
		}
		
		private static function handleWaitForFonts(event:Event):void {
			if (!_waitForFontsCounter) {
				if (_stage)
				{
					if (_stage.hasEventListener(Event.ENTER_FRAME)) {
						_stage.removeEventListener(Event.ENTER_FRAME, handleWaitForFonts);
					}   
					_stage.dispatchEvent(new SMAFEvent(SMAFEvent.FONT_AVAILABLE));
				}
			} else {
				_waitForFontsCounter--;
			}
		}
		
		private static function loadFontPackage():void {
			var thisFontPack:FontLoader = new FontLoader();
			thisFontPack.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError, false, 0, true);
			thisFontPack.addEventListener(Event.COMPLETE, handleFontPackLoaded, false, 0, true);
			thisFontPack.load(new URLRequest(ServiceProxy.baseURL + _fontURL));
		}
		
		private static function registerFont(fontID:String, fontName:String, fontURL:String):void {		
			var fontData:XML = FONT_NODE.copy();
			fontData.@id = fontID;
			fontData.@url = fontURL;
			fontData.appendChild(new XML(CDATA_PREFIX + fontName + CDATA_SUFFIX));
			fontsLoaded.appendChild(fontData);
		}
		
		private static function registerFontAvailable(fontID:String, fontName:String, fontURL:String):void {		
			var fontData:XML = FONT_NODE.copy();
			fontData.@id = fontID;
			fontData.@url = fontURL;
			fontData.appendChild(new XML(CDATA_PREFIX + fontName + CDATA_SUFFIX));
			fontsAvailable.appendChild(fontData);
		}
		
/**
*		Unloads font from memory by fontID.
*
*		@param fontID The unique font ID.
*/
		public static function removeFont(fontID:String):void {		
			if (fontsLoaded.font.(@id == fontID).length()) {
				delete fontsLoaded.font.(@id == fontID)[0];
			}
			if (fontsAvailable.font.(@id == fontID).length()) {
				delete fontListToLoad.font.(@id == fontID)[0];
			}
		}

/**
*		Request a list of fonts to be loaded dynamically that are available to your SMAF application. 
*
*		<p>When the font list is loaded, the fonts contained in the list get loaded one by one.</p>
*
*		@param fontListURL The url to request the font list XML from.
*/
		public static function requestAvailableFonts(fontListURL:String):void {
			_fontListURL = fontListURL;
			loadFontListRequested();
		}                  
		
/**
*		Request the list of fonts available to load dynamically to use with the SMAF application.
*
*		@param fontListURL The url to request the font list XML from.
*/
		public static function requestAvailableFontList(fontListURL:String):void {
			fontsAvailable = <fonts/>;
			_fontListURL = fontListURL;
			loadFontList();
		}                  
		
/**
*		Request a font to load dynamically to use with the SMAF application.
*
*		@param fontID The unique font ID.
*		@param fontName The font name that the font is referenced by.
*		@param fontURL The url from which to load the SWF file containing the font.
*/
		public static function requestFont(fontID:String, fontName:String, fontURL:String):void {
			if (fontIsRequested(fontID) != true) {
				_fontID = fontID;
				_fontName = fontName;
				_fontURL = fontURL;

				var fontData:XML = FONT_NODE.copy();
				fontData.@id = fontID;
				fontData.@url = fontURL;
				fontData.appendChild(new XML(CDATA_PREFIX + fontName + CDATA_SUFFIX));
				fontListToLoad.appendChild(fontData);
				loadNextFontInList();
			}
		}

/**
*		Share the stage with the FontManager class to successfully listen to font events.
*/
		public static function get stage():Stage {
			return _stage;
		}                 

/**
*		Share the stage with the FontManager class to successfully listen to font events.
*/
		public static function set stage(value:Stage):void {
			_stage = value;
		}                 
	}
}