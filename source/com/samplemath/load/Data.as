package com.samplemath.load {
	
	import com.samplemath.composition.Registry;

	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.external.ExternalInterface;

	import flash.net.URLLoader;
	

/**
*	Utility class for loading XML or other forms of data.
*	<p>This class may expire soon from SMAF. Please don't implement on it.</p>
*/	
	public class Data {
	
/**
*	@private
*/	
		public var authenticated:Boolean;

/**
*	@private
*/	
		public var bypassBaseURL:Boolean;

/**
*	@private
*/	
		public var dataToSend:Object;

/**
*	@private
*/	
		public var loadBinary:Boolean;

/**
*	@private
*/	
		public var loader:URLLoader;      

/**
*	@private
*/	
		public var path:String;
		
		
		
/**
*	@private
*/	
		public function Data(_path:String, _dataToSend:* = null, _authenticated:Boolean = false, _loadBinary:Boolean = false, _bypassBaseURL:Boolean = false) {	
			path = _path;
			dataToSend = _dataToSend;                                      
			authenticated = _authenticated;
			loadBinary = _loadBinary;   
			bypassBaseURL = _bypassBaseURL;

			ServiceProxy.load(this);
		}    
		
		public function load():void
		{
			ServiceProxy.load(this);
		}
	}
}