package com.samplemath.interaction {
	
	import com.samplemath.composition.Composer;
	import com.samplemath.composition.StyleSheet;
	import flash.display.Sprite;

	

/**
*	The abstract class for all scroll behaviors. 
*	<p>AScroll implements template methods for successfully implementing a scroll interaction behavior that works with the framework.
*	Please extend AScroll if you wish to implement a new scroll behavior strategy. Also remember to register your scroll behavior
*	in the ScrollReference class so it gets compiled into your application.</p>
*	
*	@see com.samplemath.composition.Composer
*	@see com.samplemath.interaction.ScrollReference
*	@see com.samplemath.scroll
*/
	public class AScroll extends Sprite {
	
/**
*		@private  
*/
		protected var _composer:Composer;

/**
*		@private  
*/
		protected var orientation:String;

/**
*		@private  
*/
		protected var _scrolling:Boolean = false;               

/**
*		@private  
*/
		protected var _scrollPosition:Number = 0;               

/**
*		@private  
*/
		protected var _scrollStyle:String;
		
		
		
			
/**
*		If you find yourself calling this constructor method in your code then
*		please read a book about object oriented programming first. 
*
* 		@param composer The <code>Composer</code> associated with the scroll behavior. 
* 		@param scrollStyle The style ID of the scroll behavior applied. 
*
*/
		public function AScroll(composer:Composer, scrollStyle:String) {	
			_composer = composer;     
			_scrollStyle = scrollStyle;
			orientation = StyleSheet.getScrollOrientation(_scrollStyle);
		}
		
		
		
		
/**
*		Prepares the disposed scrolled behavior object for garbage collection.
*/
		public function destroy():void {
			if (parent) {
				if (parent.contains(this)) {
					parent.removeChild(this);
				}
			}
		}      
		
/**
*		Specifies whether the scroll behavior is currently in effect.
*
* 	  	@default 0  
*/
		public function get scrolling():Boolean {
			return _scrolling;
		}

/**
*		The scroll position of the <code>Composer</code> the scroll behavior instance is associated with.
*		Depending on orientation of the scroll style 0 means all the way on top or left while 1 means
* 		scrolled all the way to the bottom or right. 
*
* 	  	@default 0  
*/
		public function get scrollPosition():Number {
			return _scrollPosition;
		}
		
/**
*		The scroll position of the <code>Composer</code> the scroll behavior instance is associated with.
*		Depending on orientation of the scroll style 0 means all the way on top or left while 1 means
* 		scrolled all the way to the bottom or right. 
*
* 	  	@default 0  
*/
		public function set scrollPosition(value:Number):void {
			_scrollPosition = value;
		}

/**
*		Initializes the scroll behavior or re-enables it after being disabled.
*/
		public function startScroll():void {   
			_scrolling = true;
		}
			
/**
*		Suspends the scroll behavior until it's re-enabled, pauses all scrolling in effect.
*/
		public function stopScroll():void {
			_scrolling = false;
		}
	}
}