package com.samplemath.interaction {




	import com.samplemath.composition.Registry;
	
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.external.ExternalInterface;

/**
*	The KeyBind class is a static utility class for supporting keyboard interaction and defining 
*	keyboard event listeners in SMXML.
*	<p>The KeyBind class globally manages keyboard events, priorities of listeners based on context. Please
*	see the SMXML documentation on registering keyboard listeners from SMXML. KeyBind is subject to revision
*	and possible refactoring so please don't implement this class yet.</p>
*/
	public class KeyBind {
	
		private static var exceptions:Array = [];
		private static var keyboardListenerRegistered:Boolean = false;
		private static var registry:Array = [];      
		private static var _shiftDown:Boolean = false;
/**
*		@private
*/
		private static var _stage:Stage;              
		private static var suspended:Boolean = false;

		public static const COMMA:String = ",";              
		public static const EMPTY_STRING:String = "";              
		public static const K:String = "k";              
		public static const KEY:String = "Key";              

/**
*		This is a static utility class with no purpose to be instantiated.
*/
		public function KeyBind() {
		}
		
		
		
		
		private static function handleKeyDown(event:KeyboardEvent):void {  
			if (event.shiftKey) {
				_shiftDown = true;
			} else {
				_shiftDown = false;
			}
			if ((!suspended) || (exceptions.indexOf(event.keyCode.toString()) >= 0)) {
				if (registry[event.keyCode]) {                     
					var counter:int = 0;
					var itemID:String = EMPTY_STRING;
					while (counter < registry[event.keyCode].length) {
						if (Registry.get(registry[event.keyCode][counter])) {
							if (Registry.get(registry[event.keyCode][counter]).itemData.@keymodifier.length()) {
								if (event.hasOwnProperty(Registry.get(registry[event.keyCode][counter]).itemData.@keymodifier.toString() + KEY)) {
									if (event[Registry.get(registry[event.keyCode][counter]).itemData.@keymodifier.toString() + KEY]) {
										itemID = registry[event.keyCode][counter];
									}
								}
							} else {
								if ((!event.altKey) && (!event.ctrlKey) && (!event.shiftKey)) {
									itemID = registry[event.keyCode][counter];
								}
							}
							if (!Registry.get(registry[event.keyCode][counter]).itemData.@keycode.length()) {
								itemID = EMPTY_STRING;
							}
						}
						if (itemID != EMPTY_STRING) {    
							handleKeyEvent(itemID, KeyboardEvent.KEY_DOWN);
							break;
						}
						counter++;
					}
				}
			}    
		}        
		
		private static function handleKeyEvent(itemID:String, eventType:String):void
		{               
			if (Registry.get(itemID))
			{
				if (Registry.get(itemID) is EventDispatcher)
				{
					Registry.get(itemID).dispatchEvent(new KeyboardEvent(eventType, false));
				}
			}
		}
		
		private static function handleKeyUp(event:KeyboardEvent):void {                   
			if (event.shiftKey) {
				_shiftDown = true;
			} else {
				_shiftDown = false;
			}
			if ((!suspended) || (exceptions.indexOf(event.keyCode.toString()) >= 0)) {
				if (registry[event.keyCode]) {                     
					var counter:int = 0;
					var itemID:String = EMPTY_STRING;
					while (counter < registry[event.keyCode].length) {
						if (Registry.get(registry[event.keyCode][counter])) {
							if (Registry.get(registry[event.keyCode][counter]).itemData.@keymodifier.length()) {
								if (event.hasOwnProperty(Registry.get(registry[event.keyCode][counter]).itemData.@keymodifier.toString() + KEY)) {
									if (event[Registry.get(registry[event.keyCode][counter]).itemData.@keymodifier.toString() + KEY]) {
										itemID = registry[event.keyCode][counter];
									}
								}
							} else {
								if ((!event.altKey) && (!event.ctrlKey) && (!event.shiftKey)) {
									itemID = registry[event.keyCode][counter];
								}
							}
							if (!Registry.get(registry[event.keyCode][counter]).itemData.@keycodeup.length()) {
								itemID = EMPTY_STRING;
							}
						}
						if (itemID != EMPTY_STRING) {
							handleKeyEvent(itemID, KeyboardEvent.KEY_UP);
							break;
						}
						counter++;
					}
				}
			}    
		}
		
/**
*		Registers a listener on a UI element for a certain key.
*
* 		<p>When multiple UI components listent to the same key, event is dispatched on the UI element that registered
*		listener for the key last. Upon disposing of this UI element and its key listener, priority falls back onto the
*		UI element that registered listener for the key second to last, and so on.</p>
*
* 		@param keycode the AS3 keycode of the key to register
* 		@param itemID the unique ID of the UI element that the keyboard listener is registered on
*
*/
		public static function register(keycode:String, itemID:String):void {
			if (!keyboardListenerRegistered) {                  
				registerKeyboardEventListener();
			}
			if (registry[keycode]) {
				registry[keycode].unshift(itemID);
			} else {
				registry[keycode] = [itemID];
			}
			if (Registry.get(itemID)) {
				_stage.focus = Registry.get(itemID) as InteractiveObject;
			}
		}
		
		private static function registerKeyboardEventListener():void {
			keyboardListenerRegistered = true;
			if (_stage)
			{
				_stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown, false, 0, true);
				_stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp, false, 0, true);
			}
		}
		
/**
*		Resumes listening to key events after suspending KeyBind.
*/
		public static function resume():void {
			exceptions = [];
			suspended = false;
		}
		
/**
*		Removes a listener from a UI element for a certain key.
*
* 		@param keycode the AS3 keycode of the key registered
* 		@param itemID the unique ID of the UI element that the keyboard listener is registered on
*
*/
		public static function remove(keycode:String, itemID:String):void {
			if (registry[keycode]) {
				var stackPosition:int = registry[keycode].indexOf(itemID);
				if (stackPosition >= 0) {
					registry[keycode].splice(stackPosition, 1);
					if (!registry[keycode].length) {
						var registryPosition:int = registry.indexOf(registry[keycode]);
						registry.splice(registryPosition, 1);
					}
				}
			}
		}
		
/**
*		parameter specifying whether the shift button is currently being pressed by the user.
*                                                               
*		@default false
*/
		public static function get shiftDown():Boolean {
			return _shiftDown;
		}   
		
/**
*		The KeyBind static class's reference of the stage.
*/
		public static function get stage():Stage {
			return _stage;
		}   

/**
*		The KeyBind static class's reference of the stage.
*/
		public static function set stage(stageRefence:Stage):void {
			_stage = stageRefence;
			if (!keyboardListenerRegistered) {                  
				registerKeyboardEventListener();
			}
		}   
		

/**
*		Suspends listening to key events to give access to all keys. This can be useful when
*		handling user text input making sure pressing certain keys won't trigger unintended
*		event handlers.
*                                                               
*		@param exception keys not to stop listening to. listed as comma(,) delimited AS3 keycodes in a <code>String</code>
*/
		public static function suspend(exception:String = EMPTY_STRING):void {
			exceptions = [];
			if (exception.split(COMMA).length) {
				exceptions = exception.split(COMMA);
			}
			suspended = true;
		}
	}
}