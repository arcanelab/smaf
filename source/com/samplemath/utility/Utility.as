package com.samplemath.utility
{

	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;

/**
*	The Utility class (as its name suggests) is a static utility class for supporting some commonly used
*	utility method implementations.
*/
 	public class Utility
	{
			
		private static const ALERT:String = "alert";

/**
*		This is a static utility class with no purpose to be instantiated.
*/
		public function Utility()
		{  
		}


		
		
/**
*		Opens a URL in the browser.
*
* 		<p>By default the provided URL will open in a blank browser window. As an optional second parameter
*		you may specify a target window such as "_self" to open the URL in.</p>
*
* 		@param url The URL to open.
* 		@param target An optional reference to a target window to open the URL in.
*
*/
		public static function openURL(url:String, target:String = "_blank"):void
		{
            navigateToURL(new URLRequest(url), target);
		}   
		
/**
*		Generates a javascript alert displaying the text provided.
*
* 		<p>Make sure the ExternalInterface is available to your Flash application in order
*		to successfully trigger the alert.</p>
*
* 		@param alertText The text to display in the alert.
*/
		public static function javascriptAlert(alertText:String):void
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.call(ALERT, alertText);
			}
		}              
	}
}