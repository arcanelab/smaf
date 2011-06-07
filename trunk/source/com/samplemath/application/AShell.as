package com.samplemath.application {

	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	
	

	
/**
*	Abstract template class for the application preloader shell. 
*	<p>AShell is to provide a template class to extend for creating your own application shell. The responsibility of the application shell is to preload the main application and indicate loading progress visually.</p>
*/
	public class AShell extends MovieClip {
		
		private var applicationLoader:Loader;
/**
*		The proportional progress of loading the application, ranging from 0 to 1.
*
*		@default 0
*/
		public var progress:Number = 0;
		
		private const ALL_DOMAINS:String = "*";
		private const APPLICATION_PATH:String = "applicationpath";
		            
		
			
/**
*		If you find yourself calling this constructor method in your code then
*		please read a book about object oriented programming first. 
*/
		public function AShell() {
			Security.allowDomain(ALL_DOMAINS);
			loadApplication();
		}

		

		
		private function handleApplicationLoaded(event:Event):void {
			if (applicationLoader.content is MovieClip)
			{
				(applicationLoader.content as MovieClip).flashvars = Object(root.loaderInfo.parameters);
				(applicationLoader.content as MovieClip).initialize(this as MovieClip);
			}
		}

/**
*		Extend this method to indicate progress of loading the application. Use the bytesLoaded
*		and bytesTotal properties of ProgressEvent to calculate proportional progress.
*/
		protected function handleApplicationLoading(event:ProgressEvent):void {
		}		
		
/**
*		Extend this method to indicate an IOError during loading the application.
*/
		protected function handleLoadError(event:IOErrorEvent):void {
		}
		
		private function loadApplication():void {
			applicationLoader = new Loader();
			addChild(applicationLoader);
			applicationLoader.contentLoaderInfo.addEventListener(Event.INIT, handleApplicationLoaded);
			applicationLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, handleApplicationLoading);
 			applicationLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError);
   			
			var context:LoaderContext = new LoaderContext();
			context.applicationDomain = ApplicationDomain.currentDomain;                       
			if (root.loaderInfo.parameters[APPLICATION_PATH]) {
				applicationLoader.load(new URLRequest(root.loaderInfo.parameters[APPLICATION_PATH]), context);
			}
		}    

/**
*		Extend this method to indicate progress of configuration and other initial data loading
*		for the application. Use the value ranging from 0 to 1 indicating the progress of
*		application initialization.
*
*		@param value a Number ranging from 0 to 1 indicating the progress of initial application data loading.
*/
		public function showInitializationProgress(value:Number):void {
		}		
	}
}