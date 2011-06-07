package com.samplemath.user {

	import com.samplemath.composition.Registry;
	import com.samplemath.event.SMAFEvent;
	import com.samplemath.load.Data;
	import com.samplemath.load.ServiceProxy;

	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.net.URLVariables;




/**
*	Static utility class supporting user and session management.
*	<p>NOT YET FINISHED! User management to be rescoped and refactored.</p>
*/
 	public class User  {
				
		private static var _agreed:Boolean = false;
		private static var _authenticated:Boolean = false;
		private static var _id:String;
		private static var _level:int = 0;
		private static var _pass:String;
		private static var _username:String;
		private static var sharedObject:SharedObject;

		private static const APPLICATION:String = "application";            
		private static const EMPTY_STRING:String = "";               
		private static const PASS:String = "pass";            



		public function User() {
		}
		


		
		public static function get agreed():Boolean {
			return _agreed;
		}
		
		public static function set agreed(value:Boolean):void {
			_agreed = value;
		}
		
		public static function get authenticated():Boolean {
			return _authenticated;
		}
		
		public static function authenticateSession(path:String, sharedObjectDomain:String):void {
			if (sharedObjectDomain) {
				sharedObject = SharedObject.getLocal(sharedObjectDomain, "/");
				if (sharedObject.data[PASS])
				{
					pass = sharedObject.data[PASS].toString();
				}
			}   
			if (Registry.get(APPLICATION).flashvars[PASS])
			{
				if (Registry.get(APPLICATION).flashvars[PASS] != EMPTY_STRING)
				{
					pass = Registry.get(APPLICATION).flashvars[PASS];
				}
			}    

			var requestData:URLVariables = new URLVariables(); 
			var sessionData:Data = new Data(path, requestData, true);
			sessionData.loader.addEventListener(Event.COMPLETE, User.handleSessionAuthentication);
		}
		
		public static function changePassword(changePasswordURL:String, oldPassword:String, newPassword:String):void {
			var requestData:URLVariables = new URLVariables(); 
			requestData.oldPassword = oldPassword;
			requestData.newPassword = newPassword;
			requestData.pass = _pass;
			var reminderData:Data = new Data(changePasswordURL, requestData);
			reminderData.loader.addEventListener(Event.COMPLETE, User.handlePasswordChanged);
		}

		public static function handleAccountVariableSet(event:Event):void {
			var dataLoaded:XML = new XML(event.target.data)
			Registry.get(APPLICATION).dispatchEvent(new SMAFEvent(SMAFEvent.ACCOUNT_VARIABLE_SET, dataLoaded as Object));
		}
		
		public static function handleLoginResponse(event:Event):void {
			var dataLoaded:XML = new XML(event.target.data)
			if (Number(dataLoaded.success.text())) {
				_id = dataLoaded.id.text();
				if (sharedObject) {
					sharedObject.data[PASS] = dataLoaded.pass.text().toString();
				}
				pass = dataLoaded.pass.text();
				_level = int(dataLoaded.level.text());
				_username = dataLoaded.username.text();
			}

			Registry.get(APPLICATION).dispatchEvent(new SMAFEvent(SMAFEvent.LOGIN, dataLoaded as Object));
		}

		public static function handleLogoutResponse(event:Event):void {
			var dataLoaded:XML = new XML(event.target.data)
			if (Number(dataLoaded.success.text())) {
				sharedObject.data[PASS] = EMPTY_STRING;
				pass = EMPTY_STRING;
			}

			Registry.get(APPLICATION).dispatchEvent(new SMAFEvent(SMAFEvent.LOGOUT, dataLoaded as Object));
		}     
		
		private static function handlePasswordChanged(event:Event):void
		{
			var dataLoaded:XML = new XML(event.target.data)
			Registry.get(APPLICATION).dispatchEvent(new SMAFEvent(SMAFEvent.PASSWORD_CHANGED, dataLoaded as Object));
		}        
		
		private static function handleRegisterResponse(event:Event):void {
			var dataLoaded:XML = new XML(event.target.data)
			Registry.get(APPLICATION).dispatchEvent(new SMAFEvent(SMAFEvent.REGISTER, dataLoaded as Object));
		}            
		
		private static function handleResendResponse(event:Event):void {
			var dataLoaded:XML = new XML(event.target.data)
			Registry.get(APPLICATION).dispatchEvent(new SMAFEvent(SMAFEvent.RESENT, dataLoaded as Object));
		}

		private static function handleResetPasswordResponse(event:Event):void {
			var dataLoaded:XML = new XML(event.target.data)
			Registry.get(APPLICATION).dispatchEvent(new SMAFEvent(SMAFEvent.PASSWORD_RESET, dataLoaded as Object));
		}

		public static function handleSessionAuthentication(event:Event):void {
			var dataLoaded:XML = new XML(event.target.data)
			_authenticated = false;
			if (Number(dataLoaded.success.text())) {
				_authenticated = true;
			}
			if (_authenticated) {
				if (dataLoaded.id.length()) {
					_id = dataLoaded.id.text();
				}
				if (dataLoaded.level.length()) {
					_level = dataLoaded.level.text();
				}
				if (dataLoaded.username.length()) {
					_username = dataLoaded.username.text();
				}
				pass = dataLoaded.p.text();
				if (sharedObject) {  
					if (sharedObject.data[PASS] != dataLoaded.p.text())
					{
						sharedObject.data[PASS] = _pass;
					}                               
				}
			}
			Registry.get(APPLICATION).dispatchEvent(new SMAFEvent(SMAFEvent.SESSION_AUTHENTICATION, _authenticated as Object));
		}           
   	
		private static function handleVerifyRegistrationResponse(event:Event):void {
			var dataLoaded:XML = new XML(event.target.data)
			Registry.get(APPLICATION).dispatchEvent(new SMAFEvent(SMAFEvent.VERIFY_REGISTRATION, dataLoaded as Object));
		}

		public static function get id():String {
			return _id;
		}             

		public static function get level():int {
			return _level;
		}                             
		
		public static function login(loginPath:String, username:String, password:String):void {
			var requestData:URLVariables = new URLVariables(); 
			requestData.username = username;
			requestData.password = password;
			var loginData:Data = new Data(loginPath, requestData);
			loginData.loader.addEventListener(Event.COMPLETE, User.handleLoginResponse);
		}

		public static function logout(logoutPath:String):void {
			var requestData:URLVariables = new URLVariables(); 
			requestData.pass = _pass;
			var logoutData:Data = new Data(logoutPath, requestData, true);
			logoutData.loader.addEventListener(Event.COMPLETE, User.handleLogoutResponse);
		}            		
		
		public static function get pass():String {
			return _pass;
		}
		
		public static function set pass(value:String):void {
			_pass = value;            
			ServiceProxy.pass = _pass;
		}

		public static function register(registgerURL:String, username:String, email:String, password:String):void {
			var requestData:URLVariables = new URLVariables(); 
			requestData.username = username;
			requestData.email = email;
			requestData.password = password;
			var reminderData:Data = new Data(registgerURL, requestData);
			reminderData.loader.addEventListener(Event.COMPLETE, User.handleRegisterResponse);
		}

		public static function resend(resendURL:String, username:String):void {
			var requestData:URLVariables = new URLVariables(); 
			requestData.username = username;
			var reminderData:Data = new Data(resendURL, requestData);
			reminderData.loader.addEventListener(Event.COMPLETE, User.handleResendResponse);
		}

		public static function resetPassword(resetPasswordURL:String, reminder:String):void {
			var requestData:URLVariables = new URLVariables(); 
			requestData.reminder = reminder;
			var reminderData:Data = new Data(resetPasswordURL, requestData);
			reminderData.loader.addEventListener(Event.COMPLETE, User.handleResetPasswordResponse);
		}

		public static function setAccountVariable(setAccountVariableURL:String, variable:String, value:String):void {
			var requestData:URLVariables = new URLVariables(); 
			requestData.variable = variable;
			requestData.value = value;
			requestData.pass = _pass;
			var reminderData:Data = new Data(setAccountVariableURL, requestData);
			reminderData.loader.addEventListener(Event.COMPLETE, User.handleAccountVariableSet);
		}

		public static function get username():String {
			return _username;
		}                             

		public static function verifyRegistration(verifyURL:String, username:String, email:String):void {
			var requestData:URLVariables = new URLVariables(); 
			requestData.username = username;
			requestData.email = email;
			var reminderData:Data = new Data(verifyURL, requestData);
			reminderData.loader.addEventListener(Event.COMPLETE, User.handleVerifyRegistrationResponse);
		}
	}
}