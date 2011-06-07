package com.samplemath.load {



	import com.samplemath.composition.Registry;

	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLVariables;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.system.System;
	import flash.utils.ByteArray;



/**
*	Static utility class supporting loading XML and other forms of data.
*/
	public class ServiceProxy {
	
		private static var _pass:String;

/**
*		@private
*/                       
		public static var baseURL:String = "";
		public static var stage:Stage;           
		
		private static const ALERT:String = "alert";   
		private static const EMPTY_STRING:String = "";   
		private static const RND:String = "?rnd=";   
		private static const SECURITY_ERROR:String = "A SecurityError has occurred.";   
                                                                 

/**
*		This is a static utility class with no purpose to be instantiated.
*/
		public function ServiceProxy() {
		}
		
		
		
/**
*		Loads data using the Data object. May be refactored soon. Please don't implement on this.
*
*		@param data The Data object to be loaded.
*/
		public static function load(data:Data):void {
			data.loader = new URLLoader();
			if (data.loadBinary) {
				data.loader.dataFormat = URLLoaderDataFormat.BINARY;
			} else {
				data.loader.dataFormat = URLLoaderDataFormat.TEXT;
			}
			data.loader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
		    data.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			var request:URLRequest = new URLRequest((data.bypassBaseURL ? EMPTY_STRING : baseURL) + data.path + RND + int(Math.random() * 99999999999));
			if (data.dataToSend) {
				if (ServiceProxy.pass != "" && data.authenticated) {
					if (ServiceProxy.pass)
					{
						data.dataToSend.pass = ServiceProxy.pass;
					}
				}
				request.data = data.dataToSend;
				request.method = URLRequestMethod.POST;
			}
	      	try {
				data.loader.load(request);			
			}
			catch (error:SecurityError) {
				ExternalInterface.call(ALERT, SECURITY_ERROR);
			}
		}

		private static function handleIOError(event:IOErrorEvent):void {
/*			ExternalInterface.call("alert", event.toString());*/
		}

		private static function handleSecurityError(event:SecurityErrorEvent):void {
/*			ExternalInterface.call("alert", event.toString());*/
		}

/**
*		The 256 bit session pass used in SMAF.
*
*		@default null
*/
		public static function get pass():String {
			return _pass;
		}
		
/**
*		The 256 bit session pass used in SMAF.
*
*		@default null
*/
		public static function set pass(value:String):void {
			_pass = value;            
		}
	}
}