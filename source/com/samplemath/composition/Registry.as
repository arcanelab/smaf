package com.samplemath.composition {



/**
*	Static dictionary class registering UI elements by unique ID. 
*	<p>The <code>Registry</code> class is a solution for referencing any UI element globally in your application.
*	You may register your UI element by providing it with a unique identifier either in SMXML or ActionScript.
*	Then you may always obtain reference to it from any object's scope using this unique <code>String</code> ID.</p>
*	
*	<p>You may use the <code>Registry</code> class to register any <code>Object</code> under a unique <code>String</code> ID.</p>
*	
*	@see com.samplemath.composition.AComposable
*/
	public class Registry {
	
		public static var application:Object;
		private static var registry:Array = [];

/**
*		Static dictionary, not meant to be instantiated.
*/
		public function Registry() {
		}
		
		
		
		
/**
*		Get reference to the UI element or <code>Object</code> by its unique ID.
*
* 		@param objectID the unique id of UI element or <code>Object</code> referenced. 
*
*		@return reference to the UI element or <code>Object</code> by its unique ID.  
*/
		public static function get(objectID:String):Object {
			var reference:Object = null;
			if (registry[objectID]) {
				reference = registry[objectID];
			}
			return reference;
		}
		
/**
*		Remove reference to the UI element or <code>Object</code> by its unique ID.
*		This is typically for when disposing of objects so they become available for garbage collection.
*
* 		@param objectID the unique id of UI element or <code>Object</code> referenced. 
*/
		public static function remove(objectID:String):void {
			registry[objectID] = null;
		}

/**
*		Add reference to the UI element or <code>Object</code> by its unique ID.
*
* 		@param object the UI element or <code>Object</code> to be referenced. 
* 		@param objectID the unique id of UI element or <code>Object</code> to be referenced. 
*/
		public static function set(object:Object, objectID:String):void {
			registry[objectID] = object;
		}
	}
}