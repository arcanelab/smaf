package com.samplemath.input {
	import com.samplemath.utility.Utility;
	
	import com.samplemath.composition.AComposable;
	import com.samplemath.composition.Composer;
	import com.samplemath.composition.Composition;
	import com.samplemath.composition.Registry;
	import com.samplemath.composition.StyleSheet;
	import com.samplemath.font.FontManager;
	import com.samplemath.interaction.KeyBind;
	import com.samplemath.shape.Box;
	import com.samplemath.text.TextBlock;

	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;                                   
	
	


/**
*	Concrete UI element for capturing user text input.
*	<p><code>InputField</code> combines <code>Box</code> and <code>TextBlock</code> to render an input textfield
*	that is available to use in SMXML compostion.</p>
*	                                                          
*	@see http://samplemath.com/smaf/doc/wikka.php?wakka=UsingInputField
*	@see com.samplemath.composition.StyleSheet
*	@see com.samplemath.shape.Box
*	@see com.samplemath.text.TextBlock
*/
	public class InputField extends AComposable {
		
		private var _defaulttext:String = "";
		private var fieldBackground:Box;
		private var inputText:TextBlock;
		private var _maxChars:int;
		private var _password:Boolean = false;
		
		private var _itemHeight:int = 2;
		private var _itemWidth:int = 2;

		private static const CDATA_PREFIX:String = "<![CDATA[";
		private static const CDATA_SUFFIX:String = "]]>"; 
		private static const DEFAULT_INPUT_TEXT_FORMAT:String = "defaultInputTextformat";
		private static const EMPTY_STRING:String = "";               
		private static const SPACE:String = " ";                      
		private static const TRUE:String = "true";                      
		
		
		
/**
*		Instantiates InputField.
*/
		public function InputField() {	 
			_itemData = <inputfield/>;
			super();
		}
		
		
		
		
		private function adjustInputField():void {
			if (fieldBackground) {
				fieldBackground.width = _itemWidth;
				fieldBackground.height = _itemHeight;
			}
			if (inputText) {
				inputText.width = _itemWidth;
				inputText.height = _itemHeight;
			}
		}
		
/**
*		[SMXML] The default text to be shown in the inputfield in case it's empty, such as 'Type here'.
*/
		public function get defaulttext():String {
			var value:String = EMPTY_STRING;
			if (_itemData) {
				if (_itemData.@defaulttext.length()) {
					value = _itemData.@defaulttext.toString();
				}
			}
			return value;
		}

/**
*		[SMXML] The default text to be shown in the inputfield in case it's empty, such as 'Type here'.
*/
		public function set defaulttext(value:String):void {
			if (_itemData) {
				_itemData.@defaulttext = value;
				adjustInputField();
			}
		}

/**
*		[SMXML] Comma separated list of AS3 key values for keys not to be suspended
*		listening to when the <code>InputField</code> receives focus.
*/
		public function get exception():String {
			var value:String = EMPTY_STRING;
			if (_itemData) {
				if (_itemData.@exception.length()) {
					value = _itemData.@exception.toString();
				}
			}
			return value;
		}

/**
*		[SMXML] Comma separated list of AS3 key values for keys not to be suspended
*		listening to when the <code>InputField</code> receives focus.
*/
		public function set exception(value:String):void {
			if (_itemData) {
				_itemData.@exception = value;
				adjustInputField();
			}
		}

/**
*		[SMXML] The fill style for the default state of the input field.
*/
		public function get fill():String {
			var value:String = EMPTY_STRING;
			if (_itemData) {
				if (_itemData.@fill.length()) {
					value = _itemData.@fill.toString();
				}
			}
			return value;
		}

/**
*		[SMXML] The fill style for the default state of the input field.
*/
		public function set fill(value:String):void {
			if (_itemData) {
				_itemData.@fill = value;
				adjustInputField();
			}
		}

/**
*		[SMXML] The fill style for the focused state of the input field.
*/
		public function get fillfocused():String {
			var value:String = EMPTY_STRING;
			if (_itemData) {
				if (_itemData.@fillfocused.length()) {
					value = _itemData.@fillfocused.toString();
				}
			}
			return value;
		}

/**
*		[SMXML] The fill style for the focused state of the input field.
*/
		public function set fillfocused(value:String):void {
			if (_itemData) {
				_itemData.@fillfocused = value;
				adjustInputField();
			}
		}

		private function handleChange(event:Event):void {
			_itemData.setChildren(new XML(CDATA_PREFIX + inputText.text.split(CDATA_PREFIX).join(EMPTY_STRING).split(CDATA_SUFFIX).join(EMPTY_STRING) + CDATA_SUFFIX))
			dispatchEvent(event);
		}

		private function handleFocus(p_event:FocusEvent):void {
			var exception:String = _itemData.@exception.length() ? _itemData.@exception.toString() : EMPTY_STRING;
			KeyBind.suspend(exception);
			if ((p_event.target.text == EMPTY_STRING) || (p_event.target.text == _defaulttext)) {
//				Utility.javascriptAlert("handleFocus" + p_event.target.text + "handleFocus");
				p_event.target.text = SPACE;
				if (_password == true) {
					inputText.textField.displayAsPassword = false;
				}
				inputText.textField.setSelection(inputText.textField.text.length, inputText.textField.text.length);
			}
			if (fieldBackground) {
				if (_itemData.@fillfocused.length()) {
					fieldBackground.itemData.@fill = _itemData.@fillfocused.toString();
				}
				if (_itemData.@strokefocused.length()) {
					fieldBackground.itemData.@stroke = _itemData.@strokefocused.toString();
				}
				fieldBackground.adjustBox();
			}
			if (inputText) {
				if (_itemData.@textformatfocused.length()) {
					inputText.itemData.@textformat = _itemData.@textformatfocused.toString();
					inputText.adjustTextField();
				}
			}
		}
		
		private function handleFocusOut(p_event:FocusEvent):void {
			KeyBind.resume();
			if (_itemData) {
				if (fieldBackground) {
					if (_itemData.@fill.length()) {
						fieldBackground.itemData.@fill = _itemData.@fill.toString();
					}
					if (_itemData.@stroke.length()) {
						fieldBackground.itemData.@stroke = _itemData.@stroke.toString();
					}
					fieldBackground.adjustBox();
				}
				if (inputText) {
					if (_itemData.@textformat.length()) {
						inputText.itemData.@textformat = _itemData.@textformat.toString();
						inputText.adjustTextField();
					}
				}
			}
		}
		
		private function handleInput(p_event:TextEvent):void {
			if (p_event.target.text == SPACE) {
				p_event.target.text = EMPTY_STRING;
				if (_password == true) {
					inputText.textField.displayAsPassword = true;
				}
			}
		}
		
		private function handleInputKeyDown(p_event:KeyboardEvent):void {
			if (p_event.target.stage) {
				p_event.target.stage.focus = null;
				p_event.target.stage.focus = p_event.target;
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
			adjustInputField();
		}

/**
*		The <code>TextField</code> instance wrapped by <code>TextBlock</code> used as the input textfield.
*/
		public function get inputField():TextField {
			return inputText.textField;
		}
				
/**
*		[SMXML] Boolean property specifying whether the inputfield is for a password.
*
*		@default false
*/
		public function get password():Boolean {
			var value:Boolean = false;
			if (_itemData) {
				if (_itemData.@password.length()) {
					value = Number(_itemData.@password.toString()) || (_itemData.@password.toString() == TRUE);
				}
			}
			return value;
		}

/**
*		[SMXML] Boolean property specifying whether the inputfield is for a password.
*
*		@default false
*/
		public function set password(value:Boolean):void {
			if (_itemData) {
				_itemData.@password = value;
				adjustInputField();
			}
		}

/**
*		@inheritDoc
*/
		override protected function registerEvents():void {
			super.registerEvents();
			if (_itemData.@changelistener.length()) {
				if (Registry.get(_itemData.@changelistener.toString())) {
					if (Registry.get(_itemData.@changelistener.toString()).hasOwnProperty(_itemData.@changeaction.toString())) {
						addEventListener(Event.CHANGE, Registry.get(_itemData.@changelistener.toString())[_itemData.@changeaction.toString()] as Function, false, 0, true);
					}
				}
			}						
		}

/**
*		@inheritDoc
*/
		override protected function render():void {
			super.render();
			renderInputField();
			adjustInputField();
    	}
		
		private function renderInputField():void {
			if (_itemData.@password.length()) {
				_password =  Number(_itemData.@password.toString()) || (_itemData.@password.toString() == TRUE);
			}  
                           
			if (!fieldBackground)
			{
				fieldBackground = new Box();
				addChild(fieldBackground);
			}

			fieldBackground.setDimensions(_itemWidth, _itemHeight);
			if (_itemData.@fill.length())
			{
				fieldBackground.fill = _itemData.@fill.toString();
			}
			if (_itemData.@rounded.length())
			{
				fieldBackground.rounded = int(_itemData.@rounded.toString());
			}
			if (_itemData.@stroke.length())
			{
				fieldBackground.stroke = _itemData.@stroke.toString();
			}
		
			if (!inputText)
			{
				inputText = new TextBlock();
				addChild(inputText);
			}
			inputText.setDimensions(_itemWidth, _itemHeight);
			if (_itemData.@textformat.length())
			{
				inputText.textformat = _itemData.@textformat.toString();
			}
			if (_itemData.text())
			{
				inputText.text = _itemData.text();
			}
			if (_itemData.@defaulttext.length()) {
				_defaulttext = _itemData.@defaulttext.toString();
			}
			inputText.itemData = inputText.itemData;
			if (inputText.textField)
			{
				inputText.textField.type = TextFieldType.INPUT;
				inputText.textField.addEventListener(Event.CHANGE, handleChange, false, 0, true);
				inputText.textField.addEventListener(TextEvent.TEXT_INPUT, handleInput, false, 0, true);
				inputText.textField.addEventListener(FocusEvent.FOCUS_IN, handleFocus, false, 0, true);
				inputText.textField.addEventListener(FocusEvent.FOCUS_OUT, handleFocusOut, false, 0, true);
				inputText.textField.addEventListener(KeyboardEvent.KEY_DOWN, handleInputKeyDown, false, 0, true);
				inputText.textField.tabEnabled = true;
				if (_itemData.@tabindex.length()) {
					inputText.textField.tabIndex = int(_itemData.@tabindex.toString());
				}
			}
		}
		
/**
*		Resets the inputfield's value to an empty string.
*/
		public function reset():void {
			inputText.text = EMPTY_STRING;
		}

/**
*		[SMXML] The diameter of corner roundness in pixels.
*/
		public function get rounded():Number {
			var value:Number = 0;
			if (_itemData) {
				if (_itemData.@rounded.length()) {
					value = Number(_itemData.@rounded.toString());
				}
			}
			return value;
		}

/**
*		[SMXML] The diameter of corner roundness in pixels.
*/
		public function set rounded(value:Number):void {
			if (_itemData) {
				_itemData.@rounded = value;
				adjustInputField();
			}
		}

/**
*		@private
*/
		override public function _setDimensions(widthToSet:Number, heightToSet:Number):void {
			_itemWidth = widthToSet;
			_itemHeight = heightToSet;
			adjustInputField();
		}          
		
/**
*		Sets focus on the inputfield.
*/
		public function setFocus():void
		{
			if (stage)
			{
				stage.focus = inputText.textField;
			}
		}

/**
*		[SMXML] The stroke style for the default state of the input field.
*/
		public function get stroke():String {
			var value:String = EMPTY_STRING;
			if (_itemData) {
				if (_itemData.@stroke.length()) {
					value = _itemData.@stroke.toString();
				}
			}
			return value;
		}

/**
*		[SMXML] The stroke style for the default state of the input field.
*/
		public function set stroke(value:String):void {
			if (_itemData) {
				_itemData.@stroke = value;
				adjustInputField();
			}
		}

/**
*		[SMXML] The stroke style for the focused state of the input field.
*/
		public function get strokefocused():String {
			var value:String = EMPTY_STRING;
			if (_itemData) {
				if (_itemData.@strokefocused.length()) {
					value = _itemData.@strokefocused.toString();
				}
			}
			return value;
		}

/**
*		[SMXML] The stroke style for the focused state of the input field.
*/
		public function set strokefocused(value:String):void {
			if (_itemData) {
				_itemData.@strokefocused = value;
				adjustInputField();
			}
		}

/**
*		The text value of the inputfield.
*/
		public function get text():String {
			return _itemData.text();
		}

/**
*		The text value of the inputfield.
*/
		public function set text(value:String):void {
			_itemData.setChildren(new XML(CDATA_PREFIX + value.split(CDATA_PREFIX).join(EMPTY_STRING).split(CDATA_SUFFIX).join(EMPTY_STRING) + CDATA_SUFFIX));
			inputText.text = _itemData.text();
			dispatchEvent(new Event(Event.CHANGE));
		}

/**
*		[SMXML] The textformat style for the default state of the input field.
*/
		public function get textformat():String {
			var value:String = EMPTY_STRING;
			if (_itemData) {
				if (_itemData.@textformat.length()) {
					value = _itemData.@textformat.toString();
				}
			}
			return value;
		}

/**
*		[SMXML] The textformat style for the default state of the input field.
*/
		public function set textformat(value:String):void {
			if (_itemData) {
				_itemData.@textformat = value;
				adjustInputField();
			}
		}

/**
*		[SMXML] The textformat style for the focused state of the input field.
*/
		public function get textformatfocused():String {
			var value:String = EMPTY_STRING;
			if (_itemData) {
				if (_itemData.@textformatfocused.length()) {
					value = _itemData.@textformatfocused.toString();
				}
			}
			return value;
		}

/**
*		[SMXML] The textformat style for the focused state of the input field.
*/
		public function set textformatfocused(value:String):void {
			if (_itemData) {
				_itemData.@textformatfocused = value;
				adjustInputField();
			}
		}

/**
*		@private
*/
		override protected function unregisterEvents():void {
			super.unregisterEvents();
			if (_itemData.@changelistener.length()) {
				if (Registry.get(_itemData.@changelistener.toString())) {
					if (Registry.get(_itemData.@changelistener.toString()).hasOwnProperty(_itemData.@changeaction.toString())) {
						if (hasEventListener(Event.CHANGE))
						{
							removeEventListener(Event.CHANGE, Registry.get(_itemData.@changelistener.toString())[_itemData.@changeaction.toString()] as Function);
						}
					}
				}
			}						
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
			adjustInputField();
		}
	}
}