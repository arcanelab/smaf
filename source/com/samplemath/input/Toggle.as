package com.samplemath.input {
	
	import com.samplemath.font.FontManager;

	import com.samplemath.composition.AComposable;
	import com.samplemath.composition.Composer;
	import com.samplemath.composition.Composition;
	import com.samplemath.composition.Registry;
	import com.samplemath.interaction.AInteractive;
	import com.samplemath.shape.Box;
	import com.samplemath.text.TextBlock;
	import com.samplemath.utility.Utility;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	

/**
*	Concrete UI element for capturing user true/false choice.
*	<p><code>Toggle</code> uses <code>Composer</code> templates to describe up and over states for both on and off state.</p>
*	                                                          
*	@see http://samplemath.com/smaf/doc/wikka.php?wakka=UsingToggle
*	@see com.samplemath.composition.StyleSheet
*/
	public class Toggle extends AInteractive {
		
		private var buttonOn:Button;
		private var buttonOff:Button;
		private var on:Boolean = false;
		
		private var _label:String = _label;
		private var _itemHeight:int = 2;
		private var _itemWidth:int = 2;
		private var toggleID:String;

		private const CDATA_PREFIX:String = "<![CDATA[";
		private const CDATA_SUFFIX:String = "]]>";
		private const EMPTY_STRING:String = "";               
		private const ON:String = "On";               
		private const OFF:String = "Off";               
		private const TOGGLE:String = "toggle";               

		

/**
*		Instantiates Toggle.
*/
		public function Toggle() {	
			_itemData = <toggle/>;
			super();
		}
		
		

		
		private function adjustToggle():void {
			if (buttonOn) {
				buttonOn.width = _itemWidth;
				buttonOn.height = _itemHeight;
			}
			if (buttonOff) {
				buttonOff.width = _itemWidth;
				buttonOff.height = _itemHeight;
			}
		}
		                     
		private function handleToggle(event:MouseEvent):void {
			if (on)
			{
				on = false;
			} else {
				on = true;
			}     
			buttonOn.visible = on;
			buttonOff.visible = !on;
		}
		
/**
*		@private
*/
		override public function get _height():Number {
			return _itemHeight;
		}

/**
*		@private
*/				
		override public function set _height(value:Number):void {	
			_itemHeight = value;
			adjustToggle();
		}

/**
*		@inheritDoc
*/
		override protected function render():void {
			super.render();
			renderToggle();
		}
		
		private function renderToggle():void {
			if (_itemData.@id.length()) {
				toggleID = _itemData.@id.toString();
			} else {
				toggleID = TOGGLE + Math.random().toString();
				Registry.set(this, toggleID);
			}
			if (_itemData.text())
			{
				_label = _itemData.text();
			}
			if (!buttonOff)
			{
				buttonOff = new Button();
				addChild(buttonOff);
			}                   
			var offComposition:XML = <button/>;
			if (_itemData.@skinoff.length()) {
				offComposition.@skin = _itemData.@skinoff.toString();
			}
			if (_itemData.@skinoffover.length()) {
				offComposition.@skinover = _itemData.@skinoffover.toString();
			}
			offComposition.@id = toggleID + OFF;
			offComposition.@interactive = 1;
			offComposition.setChildren(new XML(CDATA_PREFIX + _itemData.text() + CDATA_SUFFIX));
			buttonOff.itemData = offComposition;
			buttonOff.setDimensions(_itemWidth, _itemHeight);
			buttonOff.addEventListener(MouseEvent.MOUSE_DOWN, handleToggle, false, 0, true);

			if (!buttonOn)
			{
				buttonOn = new Button();
				addChild(buttonOn);
			}                   
			var onComposition:XML = <button/>;
			if (_itemData.@skinon.length()) {
				onComposition.@skin = _itemData.@skinon.toString();
			}
			if (_itemData.@skinonover.length()) {
				onComposition.@skinover = _itemData.@skinonover.toString();
			}
			onComposition.@id = toggleID + ON;
			onComposition.@interactive = 1;
			onComposition.setChildren(new XML(CDATA_PREFIX + _itemData.text() + CDATA_SUFFIX));
			buttonOn.itemData = onComposition;
			buttonOn.setDimensions(_itemWidth, _itemHeight);
			buttonOn.visible = false;
			buttonOn.addEventListener(MouseEvent.MOUSE_DOWN, handleToggle, false, 0, true);
		}   
		
/**
*		@private
*/
		override public function _setDimensions(widthToSet:Number, heightToSet:Number):void {
			_itemWidth = widthToSet;
			_itemHeight = heightToSet;
			adjustToggle();
		}
		
/**
*		[SMXML] The default skin template used for the <code>Toggle</code>'s default on state.
*/
		public function get skinon():String {
			var value:String = EMPTY_STRING;
			if (_itemData) {
				if (_itemData.@skinon.length()) {
					value = _itemData.@skinon.toString();
				}
			}
			return value;
		}

/**
*		[SMXML] The default skin template used for the <code>Toggle</code>'s default on state.
*/
		public function set skinon(value:String):void {
			if (_itemData) {
				_itemData.@skinon = value;
				renderToggle();
			}
		}

/**
*		[SMXML] The default skin template used for the <code>Toggle</code>'s over on state.
*/
		public function get skinonover():String {
			var value:String = EMPTY_STRING;
			if (_itemData) {
				if (_itemData.@skinonover.length()) {
					value = _itemData.@skinonover.toString();
				}
			}
			return value;
		}

/**
*		[SMXML] The default skin template used for the <code>Toggle</code>'s over on state.
*/
		public function set skinonover(value:String):void {
			if (_itemData) {
				_itemData.@skinonover = value;
				renderToggle();
			}
		}

/**
*		[SMXML] The default skin template used for the <code>Toggle</code>'s default off state.
*/
		public function get skinoff():String {
			var value:String = EMPTY_STRING;
			if (_itemData) {
				if (_itemData.@skinoff.length()) {
					value = _itemData.@skinoff.toString();
				}
			}
			return value;
		}

/**
*		[SMXML] The default skin template used for the <code>Toggle</code>'s default off state.
*/
		public function set skinoff(value:String):void {
			if (_itemData) {
				_itemData.@skinoff = value;
				renderToggle();
			}
		}

/**
*		[SMXML] The default skin template used for the <code>Toggle</code>'s over off state.
*/
		public function get skinoffover():String {
			var value:String = EMPTY_STRING;
			if (_itemData) {
				if (_itemData.@skinoffover.length()) {
					value = _itemData.@skinoffover.toString();
				}
			}
			return value;
		}

/**
*		[SMXML] The default skin template used for the <code>Toggle</code>'s over off state.
*/
		public function set skinoffover(value:String):void {
			if (_itemData) {
				_itemData.@skinoffover = value;
				renderToggle();
			}
		}

/**
*		The <code>Toggle</code>'s label.
*/
		public function get text():String {
			return _label;
		}

/**
*		The <code>Toggle</code>'s label.
*/
		public function set text(value:String):void {  
			_label = value;
			_itemData.setChildren(new XML(CDATA_PREFIX + value + CDATA_SUFFIX))
			renderToggle();
		}

/**
*		The <code>Toggle</code>'s label.
*/
		public function get value():Boolean {
			return on;
		}

/**
*		The <code>Toggle</code>'s label.
*/
		public function set value(value:Boolean):void {  
			on = value;
			_itemData.@value = value;
			renderToggle();
		}

/**
*		@private
*/
		override public function get _width():Number {
			return _itemWidth;
		}
				
/**
*		@private
*/
		override public function set _width(value:Number):void {			
			_itemWidth = value;
			adjustToggle();
		}
	}
}