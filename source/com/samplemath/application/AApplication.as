package com.samplemath.application {

	import com.samplemath.configuration.Configuration;
	import com.samplemath.composition.Composer;
	import com.samplemath.composition.Registry;
	import com.samplemath.event.SMAFEvent;
	import com.samplemath.font.FontManager;
	import com.samplemath.interaction.KeyBind;
	import com.samplemath.load.AssetCache;
	import com.samplemath.render.Filter;
	import com.samplemath.user.User;
	import com.samplemath.utility.Utility;

	import com.samplemath.thirdparty.asual.swfaddress.SWFAddress;
	import com.samplemath.thirdparty.asual.swfaddress.SWFAddressEvent;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.*;
	import flash.system.Security;
	import flash.utils.Timer;




/**
*	Abstract template for the application document class. 
*
*	<p>AApplication is to provide a template application document class to extend for creating your own application document class.</p>
*/
 	public class AApplication extends MovieClip {
				
		protected var _chrome:Composer;
		protected var _flashvars:Object;
		protected var _shell:MovieClip;                                    
		
		public const ALL:String = "*";             
        public const APPLICATION:String = "application";             
		public const CHROME:String = "chrome";
		public const CONFIGURATION_NOT_AVAILABLE_ALERT:String = "configuration is not specified.";
		public const CONFIGURATION_PATH:String = "configurationPath";
		public const SHELL:String = "shell";
        public const STAGE:String = "stage";             
                     

   
/**
*		If you find yourself calling this constructor method in your code then
*		please read a book about object oriented programming first. 
*/
		public function AApplication() {  //abstract class, not to be instantiated
			super();
		}
		


		
/**
*		Template method for user session authentication. Override this method if you are using user and session
*		management outside of SMAF.
*/		
		protected function authenticateSession():void {
			User.authenticateSession(Configuration.data.serviceBaseURL.text() + Configuration.data.serviceURI.user.authenticate.text(), Configuration.data.sharedObjectDomain.text());
			addEventListener(SMAFEvent.SESSION_AUTHENTICATION, handleSessionAuthentication, false, 0, true);
		}         
		
/**
*		The composer responsible for rendering the application chrome.
*/		
		public function get chrome():Composer {
			return _chrome;
		}                  
		
/**
*		Object holding all flash variable key/value pairs.
*/		
		public function get flashvars():Object
		{
			return _flashvars;
		}
		
/**
*		Object holding all flash variable key/value pairs.
*/		
		public function set flashvars(value:Object):void
		{
			_flashvars = value;
		}
		
		public function handleConfigurationLoaded(event:SMAFEvent):void
		{ 
			if (_shell)
			{
				_shell.showInitializationProgress(.5);
			}
			renderChrome();
			authenticateSession();
		}
		
		private function handleSessionAuthentication(event:SMAFEvent):void
		{
			_shell.showInitializationProgress(1);
			start();
		}      

		private function handleStageResize(event:Event):void {
			_chrome.setDimensions(stage.stageWidth, stage.stageHeight);
		}

/**
*		@private
*/		
		public function initialize(_shell:MovieClip):void
		{
			this._shell = _shell;
			registerFramework();
			loadConfiguration();
		}                     

/**
*		Template method for loading user configuration. Override this if you are loading configuration
*		outside of SMAF.
*/
		protected function loadConfiguration():void {
			if (_shell) {
				_shell.showInitializationProgress(.25);
			}                                         
			if (_flashvars[CONFIGURATION_PATH])
			{
				Configuration.loadConfigurationData(_flashvars[CONFIGURATION_PATH]);
				addEventListener(SMAFEvent.CONFIGURATION_AVAILABLE, handleConfigurationLoaded, false, 0, true);
			} else {
				Utility.javascriptAlert(CONFIGURATION_NOT_AVAILABLE_ALERT);
			}
		}
		
/**
*		Template method for registering framework components. Override this method if you
*		need to register more components or framework events.
*/
		protected function registerFramework():void {
			if (_shell) {
				Registry.set(_shell, SHELL);
			}
			
			Registry.set(this, APPLICATION);

			stage.addEventListener(Event.RESIZE, handleStageResize, false, 0, true);
			AssetCache.stage = stage;
			FontManager.stage = stage;
			KeyBind.stage = stage;

			stage.addEventListener(Event.RESIZE, handleStageResize, false, 0, true);
			stage.stageFocusRect = false;
			Registry.set(stage, STAGE);

			Security.allowDomain(ALL);
		}
 
/**
*		Template method for rendering the application chrome. Override this method to
*		render your own application's user interface.
*/   	
		protected function renderChrome():void {
			_chrome = new Composer();
			_chrome.setDimensions(stage.stageWidth, stage.stageHeight);
			Registry.set(_chrome, CHROME);
			addChild(_chrome);  
		}           
		
/**
*		The flash root DisplayObjectContainer
*/
		override public function get root():DisplayObject {
			return stage.root;
		}

/**
*		The application preloader shell that loaded the application.
*/
		public function get shell():AShell {
			return _shell as AShell;
		}

/**
*		Template method for starting the application. Override
*		this method to implement start up flow.
*/		
		protected function start():void {
		}
	}
}