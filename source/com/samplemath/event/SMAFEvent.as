package com.samplemath.event {                          
	
	import flash.events.Event;		

/**
*	Class for handling events within SMAF. 
*/
	public class SMAFEvent extends Event {
		
/**
*		Dispatches when the a variable for the user's account is updated. 
*/
		public static const ACCOUNT_VARIABLE_SET:String = "accountVariableSet";
/**
*		Dispatches when the application configuration becomes available. 
*/
		public static const CONFIGURATION_AVAILABLE:String = "configurationAvailable";
/**
*		Dispatches when a font becomes available to render. 
*/
		public static const FONT_AVAILABLE:String = "fontAvailable";
/**
*		Dispatches when the list of fonts available to load dynamically becomes available.
*/
		public static const FONT_LIST_AVAILABLE:String = "fontListAvailable";
/**
*		Dispatches when the user's login attempt to the application has been evaluated. 
*/
		public static const LOGIN:String = "login"; 
/**
*		Dispatches when the user has logged out of the application. 
*/
		public static const LOGOUT:String = "logout"; 
/**
*		Dispatches during a Motion class animation. 
*/
		public static const MOVE:String = "move"; 
/**
*		Dispatches when the user has manually changed the password. 
*/
		public static const PASSWORD_CHANGED:String = "passwordChanged"; 
/**
*		Dispatches when the user has reset the password. 
*/
		public static const PASSWORD_RESET:String = "passwordReset"; 
/**
*		Dispatches when a user has signed up for an account. 
*/                                                                              
		public static const REGISTER:String = "register"; 
/**
*		Dispatches when a user's account activation email has been resent. 
*/                                                                              
		public static const RESENT:String = "resent"; 
/**
*		Dispatches when the user's session has been checked for authentication. 
*/                                                                              
		public static const SESSION_AUTHENTICATION:String = "sessionAuthentication"; 
/**
*		Dispatches when the user's session has been checked for authentication. 
*/
		public static const VERIFY_REGISTRATION:String = "verifyRegistration"; 
		

		private var _data:Object;



/**
*		Creates a SMAFEvent instance. 
*
*		@param type The event type.
*		@param data An optional object for passing data through the event.
*		@param bubbles Specifies whether the event bubbles.
*		@param bubbles Specifies whether the event is cancellable.
*/
		public function SMAFEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			_data = data;
			super(type, bubbles, cancelable);
		}
		



/**
*		@private 
*/
		public override function clone():Event {
			return this;
		}
		
/**
*		Optional data passed through the event. 
*/
		public function get data():Object {
			return _data;
		}
	}
}
