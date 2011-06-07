package com.samplemath.interaction {

	//READ:
	//comment out classes your architecture is not using to optimize compiled binary size
	
	
	import com.samplemath.scroll.Momentum;
	Momentum;

	import com.samplemath.scroll.ScrollBar;
	ScrollBar;

	
/**
*	The ScrollReference class registers all scroll behavior classes to be used in the UI composition.. 
*	<p>The purpose of this class is to hard reference and therefore force-compile all scroll behavior classes
*	that might not be referenced in the application source code but may appear in an XML based markup composition.
*	Make sure you only reference classes that will be used in your application's UI composition in order to
*	optimize on compiled binary size. Classes not used can simply be commented out.</p>
*/
	public class ScrollReference {
		
/**
*		The default scroll behavior to be used / fall back to.
*
*		@default "momentum"
*/
		public static const DEFAULT_SCROLL_BEHAVIOR:String = "momentum";
		private static var classNameReference:XML = <classNameReference>
			<className short="momentum">com.samplemath.scroll.Momentum</className>
			<className short="scrollbar">com.samplemath.scroll.ScrollBar</className>
		</classNameReference>;         


/**
*		This is a static reference class with no purpose to be instantiated.
*/
		public function ScrollReference() {	
		}            
		
/**
* 		@private
*/
		public static function convertClassNameToFullClassName(className:String):String {
			for each (var classNameNode:XML in ScrollReference.classNameReference.className)
			{
				if (classNameNode.@short.toString() == className)
				{
					className = classNameNode.text();
				}
			}
			return className;
		}
	}
}