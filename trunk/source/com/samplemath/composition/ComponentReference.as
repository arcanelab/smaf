package com.samplemath.composition {

	//READ:
	//comment out classes your architecture is not using to optimize compiled binary size
	
	
	// graphic asset loader component
	import com.samplemath.load.Asset;
	Asset;

	// elements of the recursive composition framework
	import com.samplemath.composition.*;
	AComposable;
	Composer;

	// UI components
	import com.samplemath.input.*;
	Button;
	DropDown;
	InputField;
	ListBox;
	Toggle;

	// shapes to draw
	import com.samplemath.shape.Box;
	Box;

	// text renderer
	import com.samplemath.text.TextBlock;
	TextBlock;

	// video components
	import com.samplemath.video.*;
	VideoBox;   
	
	

	
	
/**
*	The ComponentReference class registers all UI element classes to be used in the UI composition. 
*	<p>The purpose of this class is to hard reference and therefore force-compile all UI elements classes
*	that might not be referenced in the application source code but may appear in an XML based markup composition.
*	Make sure you only reference classes that will be used in your application's UI composition in order to
*	optimize on compiled binary size. Classes not used can simply be commented out.</p>
*
*	@see flash.display.Sprite
*/
	public class ComponentReference {

/**
*		XML dictionary for maintaining full class names for composition markup with no namespace declaration.
*/
		public static var classNameReference:XML = <classNameReference>
			<className short="asset">com.samplemath.load.Asset</className>
			<className short="composer">com.samplemath.composition.Composer</className>
			<className short="button">com.samplemath.input.Button</className>
			<className short="dropdown">com.samplemath.input.DropDown</className>
			<className short="inputfield">com.samplemath.input.InputField</className>
			<className short="listbox">com.samplemath.input.ListBox</className>
			<className short="toggle">com.samplemath.input.Toggle</className>
			<className short="box">com.samplemath.shape.Box</className>
			<className short="textblock">com.samplemath.text.TextBlock</className>
			<className short="videobox">com.samplemath.video.VideoBox</className>
		</classNameReference>;         
 

   	
/**
*		This is a static reference class with no purpose to be instantiated.
*/
		public function ComponentReference() {	
		}
	}
}