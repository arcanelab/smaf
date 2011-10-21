package com.samplemath.text {

	
	import com.samplemath.font.FontManager;
	import com.samplemath.composition.AComposable;
	import com.samplemath.composition.Registry;
	import com.samplemath.composition.StyleSheet;
	import com.samplemath.event.SMAFEvent;
	import com.samplemath.thirdparty.br.hellokeita.utils.TextFieldColor;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	

	

/**
*	Concrete UI element for rendering text.
*	<p>The <code>TextBlock</code> class wraps an AS3 <code>TextField</code> class
*	with supporting functionality to make it work with SMXML composition. It renders
*	an instance of <code>TextField</code> on screen applying layout and text style defined in SMXML.</p>
*	
*	@see com.samplemath.composition.AComposable
*	@see com.samplemath.composition.StyleSheet
*/
	public class TextBlock extends AComposable {
		
	                      
		private var _color:Number;    
		private var _itemHeight:int = 100;
		private var _itemWidth:int = 102;
		private var _selectedColor:Number;
		private var _selectionColor:Number;
		private var _textField:TextField;
		private var textFieldColor:TextFieldColor;
		private var _textFormat:TextFormat;
		private var textformatStyle:String;
		private var textSizeLimit:int = 128;
		
		private const APPLICATION:String = "application";
		private const CDATA_PREFIX:String = "<![CDATA[";
		private const CDATA_SUFFIX:String = "]]>";
		private const EMPTY_STRING:String = "";
		private const LINE_BREAK:String = "\n";      
		private const TRUE:String = "true";
		
		
		
/**
*		Instantiates TextBlock.
*/
		public function TextBlock() {	
			_itemData = <textblock/>;
			super();
		}
		
		
		
/**
*		Appends a line to the text rendered.
*		
*		@param line A line of text to append to the <code>TextBlock</code>'s <code>text</code> property. 
*/
		public function addLine(line:String):void {
			_textField.appendText(line + LINE_BREAK);
			adjustTextField();
		}
		
/**
*		
*		@private
*/
		public function adjustTextField():void {
			if (_textFormat && _itemData) {
				textformatStyle = (_itemData.@textformat.length()) ? _itemData.@textformat.toString() : EMPTY_STRING;

				_textField.selectable = StyleSheet.getTextformatSelectable(textformatStyle);
				_textField.mouseEnabled = _textField.selectable;
				_textField.cacheAsBitmap = cacheAsBitmap;
				mouseEnabled = _textField.selectable;
				buttonMode = _textField.selectable;

				_textField.wordWrap = StyleSheet.getTextformatWordwrap(textformatStyle);				
				_textField.multiline = _textField.wordWrap;

				_textFormat.align = StyleSheet.getTextformatAlign(textformatStyle);
				switch (_textFormat.align) {
					case TextFormatAlign.LEFT:
						_textField.autoSize = TextFieldAutoSize.LEFT;
						break;
					case TextFormatAlign.CENTER:
						_textField.autoSize = TextFieldAutoSize.CENTER;
						break;
					case TextFormatAlign.JUSTIFY:
						_textField.autoSize = TextFieldAutoSize.CENTER;
						break;
					case TextFormatAlign.RIGHT:
						_textField.autoSize = TextFieldAutoSize.RIGHT;
						break;
				}

				if (!StyleSheet.getTextformatAutosize(textformatStyle))
				{
					_textField.autoSize = TextFieldAutoSize.NONE;
				}
				_color = StyleSheet.getTextformatColor(textformatStyle);
				_selectedColor = StyleSheet.getTextformatSelectedcolor(textformatStyle);
				_selectionColor = StyleSheet.getTextformatSelectioncolor(textformatStyle);
				_textFormat.color = StyleSheet.getTextformatColor(textformatStyle);

				_textFormat.leading = StyleSheet.getTextformatLeading(textformatStyle);
				_textFormat.letterSpacing = StyleSheet.getTextformatLetterspacing(textformatStyle);
				_textFormat.size = StyleSheet.getTextformatSize(textformatStyle);

				_textFormat.font = StyleSheet.getTextformatFont(textformatStyle);
				_textField.embedFonts = StyleSheet.getTextformatEmbedfonts(textformatStyle);
				
				if (_textField.embedFonts  && (StyleSheet.getTextformatFontURL(textformatStyle)))
				{
					if ((FontManager.fontIsLoaded(StyleSheet.getTextformatFont(textformatStyle)) != true))
					{
						if (Registry.get(APPLICATION))
						{
							Registry.get(APPLICATION).stage.addEventListener(SMAFEvent.FONT_AVAILABLE, handleFontAvailable, false, 0, true);
						}
					}
					if ((FontManager.fontIsRequested(StyleSheet.getTextformatFont(textformatStyle)) != true))
					{
						FontManager.requestFont(StyleSheet.getTextformatFont(textformatStyle), StyleSheet.getTextformatFont(textformatStyle), StyleSheet.getTextformatFontURL(textformatStyle));
					}                         
				}

				if (StyleSheet.getTextformatSize(textformatStyle) >= textSizeLimit) {
					var scaleAmount:Number = StyleSheet.getTextformatSize(textformatStyle) / textSizeLimit;
					_textFormat.size = textSizeLimit;
					_textField.width = int(_itemWidth / scaleAmount);
					_textField.height = int(_itemHeight / scaleAmount);
					scaleX = scaleY = scaleAmount;
				} else {
					_textFormat.size = StyleSheet.getTextformatSize(textformatStyle);
					_textField.width = _itemWidth;
					_textField.height = _itemHeight;
					scaleX = scaleY = 1;
				}
				if (!htmlFormatted)
				{
					_textField.setTextFormat(_textFormat);
					textFieldColor = new TextFieldColor(_textField, _color, _selectionColor, _selectedColor);
				}
			}                                         
		}    
		
		private function handleFontAvailable(event:SMAFEvent):void
		{                                                                   
			if (FontManager.stage.hasEventListener(SMAFEvent.FONT_AVAILABLE))
			{
				FontManager.stage.removeEventListener(SMAFEvent.FONT_AVAILABLE, handleFontAvailable);
			}
			adjustTextField();          
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
			adjustTextField();
		}


/**
*		[SMXML] The textformat style used for the <code>TextBlock</code>.
*/
		public function get htmlFormatted():Boolean {
			var value:Boolean = false;
			if (_itemData) {
				if (_itemData.@htmlformatted.length()) {
					value = (_itemData.@htmlformatted.toString() == TRUE) || Number(_itemData.@htmlformatted.toString());
				}
			}
			return value;
		}

/**
*		Use this property to set the TextField's <code>htmlText</code> property instead of <code>text</code>.
*/
		public function set htmlText(value:Object):void {  
			_textField.condenseWhite = false;
			_textField.htmlText = value.toString();
			adjustTextField();
		}
		
/**
*		Renders the <code>TextBlock</code> based on its SMXML style and layout definition.
*		
*		<p>Override this method if you need to extend <code>TextBlock</code></p>.
*		
*		@default 0 
*/
		override protected function render():void {
			super.render();
			renderTextField();
			adjustTextField();
		}
		                                          
		private function renderTextField():void {                             
			if (!_textField)
			{
				_textField = new TextField();
			}

			_textField.text = _itemData.text();			
			_textField.condenseWhite = false;
			_textField.antiAliasType = AntiAliasType.ADVANCED;

			_textFormat = new TextFormat();
			_textFormat.kerning = true;

			addChild(_textField);
		}
		
/**
*		@private
*/
		override public function _setDimensions(widthToSet:Number, heightToSet:Number):void {
			_itemWidth = widthToSet;
			_itemHeight = heightToSet;
			adjustTextField();
		}
		
/**
*		Sets focus on the textfield.
*/
		public function setFocus():void
		{
			if (stage)
			{
				stage.focus = _textField;
			}
		}

/**
*		The <code>TextField</code> instance wrapped by <code>TextBlock</code>.
*/
		public function get textField():TextField {
			return _textField;
		}
				
/**
*		Height of the <code>TextField</code> instance wrapped by <code>TextBlock</code>.
*/
		public function get textFieldHeight():int {
			var response:int = int(_textField.height);
			if (StyleSheet.getTextformatSize(textformatStyle) >= textSizeLimit) {
				response = int(_textField.height * scaleY);
			}
			return response;
		}
				
/**
*		Width of the <code>TextField</code> instance wrapped by <code>TextBlock</code>.
*/
		public function get textFieldWidth():int {
			var response:int = int(_textField.width);
			if (StyleSheet.getTextformatSize(textformatStyle) >= textSizeLimit) {
				response = int(_textField.width * scaleX);
			}
			return response;
		}
				
/**
*		The text rendered
*/
		public function get text():String {
			return _textField.text;
		}

/**
*		The text rendered
*/
		public function set text(value:String):void {  
			_itemData.setChildren(new XML(CDATA_PREFIX + value + CDATA_SUFFIX))
			if (_textField)
			{
				_textField.condenseWhite = false;
				_textField.text = value;
			}
			adjustTextField();
		}
		
/**
*		[SMXML] The textformat style used for the <code>TextBlock</code>.
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
*		[SMXML] The textformat style used for the <code>TextBlock</code>.
*/
		public function set textformat(value:String):void {
			if (_itemData) {
				_itemData.@textformat = value;
				adjustTextField();
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
			adjustTextField();
		}
	}
}