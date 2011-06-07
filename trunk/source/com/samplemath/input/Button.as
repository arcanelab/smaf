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
*	Concrete UI element for capturing user mouse interaction.
*	<p><code>Button</code> uses <code>Composer</code> templates to describe up, over and selected states.</p>
*	                                                          
*	@see http://samplemath.com/smaf/doc/wikka.php?wakka=UsingButton
*	@see com.samplemath.composition.StyleSheet
*/
	public class Button extends AInteractive {
		
		private var buttonUp:Composer;
		private var buttonOver:Composer;
		private var invisibleButton:Box;
		private var buttonSelected:Composer;
		
		private var _label:String = _label;
		private var _itemHeight:int = 2;
		private var _itemWidth:int = 2;

		private const CDATA_PREFIX:String = "<![CDATA[";
		private const CDATA_SUFFIX:String = "]]>";
		private const EMPTY_STRING:String = "";               
		private const LABEL:String = "label";               

		

/**
*		Instantiates Button.
*/
		public function Button() {	
			_itemData = <button/>;
			super();
		}
		
		

		
		private function adjustButton():void {
			if (buttonUp) {
				buttonUp.width = _itemWidth;
				buttonUp.height = _itemHeight;
			}
			if (buttonOver) {
				buttonOver.width = _itemWidth;
				buttonOver.height = _itemHeight;
			}
			if (buttonSelected) {
				buttonSelected.width = _itemWidth;
				buttonSelected.height = _itemHeight;
			}
			if (invisibleButton) {
				invisibleButton.width = _itemWidth;
				invisibleButton.height = _itemHeight;
			}
		}
		
/**
*		Switches the <code>Button</code> from selected back to regular state.
*/
		public function deselect():void {
			enable();
			buttonSelected.visible = false;
			buttonUp.visible = true;
		}

/**
*		@inheritDoc
*/
		override public function disable():void {
			super.disable();
			if (invisibleButton) {
				invisibleButton.visible = false;
			}
		}
		
		private function drawInvisibleButton():void {
			if (!invisibleButton)
			{
				invisibleButton = new Box();
				addChild(invisibleButton);
			}
			invisibleButton.setDimensions(_itemWidth, _itemHeight);
			invisibleButton.alpha = 0;
			if (_itemData.@rounded.length()) {
				invisibleButton.rounded = int(_itemData.@rounded.toString());
			}
		}

/**
*		@inheritDoc
*/
		override public function enable():void {
			super.enable();
			if (invisibleButton) {
				invisibleButton.visible = true;
			}
		}
		
		private function handleMouseOver(event:MouseEvent):void {
			if (!_disabled) {
				buttonUp.visible = false;
				buttonOver.visible = true;
			}
		}
		
		private function handleMouseOut(event:MouseEvent):void {
			if (!_disabled) {
				buttonUp.visible = true;
				buttonOver.visible = false;
			}
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
			adjustButton();
		}

/**
*		@inheritDoc
*/
		override protected function registerEvents():void {
			super.registerEvents();
			addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
		}

/**
*		@inheritDoc
*/
		override protected function render():void {
			super.render();
			renderButton();
		}
		
		private function renderButton():void {
			renderButtonStates();
			drawInvisibleButton();
		}   
		                     
		private function renderButtonStates():void
		{                   
			if (_itemData.text())
			{
				_label = _itemData.text();
			}
			if (!buttonUp)
			{
				buttonUp = new Composer();
				addChild(buttonUp);
			}                   
			var upComposition:XML = <composer/>;
			if (_itemData.@skin.length()) {
				upComposition.@template = _itemData.@skin.toString();
				Composition.addPattern(upComposition, LABEL, _label);
			}
			buttonUp.itemData = upComposition;
			buttonUp.setDimensions(_itemWidth, _itemHeight);

			if (!buttonOver)
			{
				buttonOver = new Composer();
				addChild(buttonOver);
			}                   
			var overComposition:XML = <composer/>;
			if (_itemData.@skinover.length()) {
				overComposition.@template = _itemData.@skinover.toString();
				Composition.addPattern(overComposition, LABEL, _label);
			}
			buttonOver.itemData = overComposition;
			buttonOver.setDimensions(_itemWidth, _itemHeight);
			buttonOver.visible = false;

			if (!buttonSelected)
			{
				buttonSelected = new Composer();
				addChild(buttonSelected);
			}                   
			var selectedComposition:XML = <composer/>;
			if (_itemData.@skinselected.length()) {
				selectedComposition.@template = _itemData.@skinselected.toString();
				Composition.addPattern(selectedComposition, LABEL, _label);
			}
			buttonSelected.itemData = selectedComposition;
			buttonSelected.setDimensions(_itemWidth, _itemHeight);
			buttonSelected.visible = false;
		}
		
/**
*		Switches the <code>Button</code> to selected state.
*/
		public function select():void {
			disable();
			buttonUp.visible = false;
			buttonSelected.visible = true;
		}
		
/**
*		@private
*/
		override public function _setDimensions(widthToSet:Number, heightToSet:Number):void {
			_itemWidth = widthToSet;
			_itemHeight = heightToSet;
			adjustButton();
		}
		
/**
*		[SMXML] The default skin template ID used for the <code>Button</code>'s default state.
*/
		public function get skin():String {
			var value:String = EMPTY_STRING;
			if (_itemData) {
				if (_itemData.@skin.length()) {
					value = _itemData.@skin.toString();
				}
			}
			return value;
		}

/**
*		[SMXML] The default skin template ID used for the <code>Button</code>'s default state.
*/
		public function set skin(value:String):void {
			if (_itemData) {
				_itemData.@skin = value;
				renderButton();
			}
		}

/**
*		[SMXML] The default skin template ID used for the <code>Button</code>'s over state.
*/
		public function get skinover():String {
			var value:String = EMPTY_STRING;
			if (_itemData) {
				if (_itemData.@skinover.length()) {
					value = _itemData.@skinover.toString();
				}
			}
			return value;
		}

/**
*		[SMXML] The default skin template ID used for the <code>Button</code>'s over state.
*/
		public function set skinover(value:String):void {
			if (_itemData) {
				_itemData.@skinover = value;
				renderButton();
			}
		}

/**
*		[SMXML] The default skin template ID used for the <code>Button</code>'s selected state.
*/
		public function get skinselected():String {
			var value:String = EMPTY_STRING;
			if (_itemData) {
				if (_itemData.@skinselected.length()) {
					value = _itemData.@skinselected.toString();
				}
			}
			return value;
		}

/**
*		[SMXML] The default skin template ID used for the <code>Button</code>'s selected state.
*/
		public function set skinselected(value:String):void {
			if (_itemData) {
				_itemData.@skinselected = value;
				renderButton();
			}
		}

/**
*		The <code>Button</code>'s label.
*/
		public function get text():String {
			return _label;
		}

/**
*		The <code>Button</code>'s label.
*/
		public function set text(value:String):void {  
			_label = value;
			_itemData.setChildren(new XML(CDATA_PREFIX + value + CDATA_SUFFIX))
			renderButton();
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
			adjustButton();
		}
	}
}