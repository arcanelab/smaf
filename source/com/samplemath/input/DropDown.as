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
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

/**
*	Concrete UI element for capturing the user's single choice input.
*	<p><code>DropDown</code> wraps <code>ListBox</code> and uses a <code>Button</code> to show and hide it.</p>
*	                                                          
*	@see http://samplemath.com/smaf/doc/wikka.php?wakka=UsingDropDown
*	@see com.samplemath.composition.StyleSheet
*/
	public class DropDown extends AInteractive {
		
		private var button:Button;
		private var listBox:ListBox;
		private var open:Boolean = false;
		
		private var _itemHeight:int = 2;
		private var _itemWidth:int = 2;
		private var dropDownID:String;

		private const BUTTON:String = "button";               
		private const CDATA_PREFIX:String = "<![CDATA[";
		private const CDATA_SUFFIX:String = "]]>";
		private const DROPDOWN:String = "dropdown";               
		private const EMPTY_STRING:String = "";               
		private const LISTBOX:String = "listbox";               
		private const ON:String = "On";               
		private const OFF:String = "Off";               

		

/**
*		Instantiates DropDown.
*/
		public function DropDown() {	
			_itemData = <dropdown/>;
			super();
		}
		
		

		
/**
*		Adds an option to the <code>DropDown</code>. The item will appear at the end of the list.
*		
*		@param label The string label of the <code>DropDown</code> option to add. 
*		@param data Arbitary data value (typically unique string id) of the<code>DropDown</code> option to add. 
*/
		public function addItem(label:String, data:Object):void {
			listBox.addItem(label, data);
		}

/**
*		Adds a number of options to the dropdown.
*		
*		@param itemsToAdd The array of <code>Object</code>s that describe the number of options to be added to the <code>DropDown</code>.
*		Each <code>Object</code> must have a <code>label</code> and <code>data</code> property to be successfully added as an option of the <code>DropDown</code>.
*/
		public function addItems(itemsToAdd:Array):void { 
			if (listBox)
			{
				listBox.addItems(itemsToAdd);
			}
		}        

		private function adjustDropDown():void {
			if (button) {
				button.width = _itemWidth;
				button.height = _itemHeight;
			}
			if (listBox) {
				var trayHeight:int = _itemHeight;
				if (_itemData.@trayheight.length() && open)
				{
					trayHeight = Number(_itemData.@trayheight.toString());
				}            
				listBox.setDimensions(_itemWidth, trayHeight);
			}
		}
		                     
/**
*		[SMXML] The default skin template used for each <code>DropDown</code> button.
*/
		public function get buttonskin():String {
			var value:String = EMPTY_STRING;
			if (_itemData) {
				if (_itemData.@buttonskin.length()) {
					value = _itemData.@buttonskin.toString();
				}
			}
			return value;
		}

/**
*		[SMXML] The default skin template used for each <code>DropDown</code> button.
*/
		public function set buttonskin(value:String):void {
			if (_itemData) {
				_itemData.@buttonskin = value;
				renderDropDown();
			}
		}

/**
*		[SMXML] The skin template used for each <code>DropDown</code> button's rollover state.
*/
		public function get buttonskinover():String {
			var value:String = EMPTY_STRING;
			if (_itemData) {
				if (_itemData.@buttonskinover.length()) {
					value = _itemData.@buttonskinover.toString();
				}
			}
			return value;
		}

/**
*		[SMXML] The skin template used for each <code>DropDown</code> button's rollover state.
*/
		public function set buttonskinover(value:String):void {
			if (_itemData) {
				_itemData.@buttonskinover = value;
				renderDropDown();
			}
		}

/**
*		[SMXML] The skin template used for each <code>DropDown</code> button's selected state.
*/
		public function get buttonskindown():String {
			var value:String = EMPTY_STRING;
			if (_itemData) {
				if (_itemData.@buttonskindown.length()) {
					value = _itemData.@buttonskindown.toString();
				}
			}
			return value;
		}

/**
*		[SMXML] The skin template used for each <code>DropDown</code> button's selected state.
*/
		public function set buttonskindown(value:String):void {
			if (_itemData) {
				_itemData.@buttonskindown = value;
				renderDropDown();
			}
		}

		private function handleChange(event:Event):void {
			open = false;
			adjustDropDown();                     
			if (listBox.selection.length)
			{
			 	listBox.scrollToItem(listBox.selection[0].toString());
			}
			button.deselect();
		}

		private function handleDropDown(event:MouseEvent):void {
			open = true; 
			adjustDropDown();
			button.select();
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
			adjustDropDown();
		}

/**
*		[SMXML] The default skin template used for each <code>DropDown</code> option.
*/
		public function get itemskin():String {
			var value:String = EMPTY_STRING;
			if (_itemData) {
				if (_itemData.@itemskin.length()) {
					value = _itemData.@itemskin.toString();
				}
			}
			return value;
		}

/**
*		[SMXML] The default skin template used for each <code>DropDown</code> option.
*/
		public function set itemskin(value:String):void {
			if (_itemData) {
				_itemData.@itemskin = value;
				renderDropDown();
			}
		}

/**
*		[SMXML] The skin template used for each <code>DropDown</code> option's rollover state.
*/
		public function get itemskinover():String {
			var value:String = EMPTY_STRING;
			if (_itemData) {
				if (_itemData.@itemskinover.length()) {
					value = _itemData.@itemskinover.toString();
				}
			}
			return value;
		}

/**
*		[SMXML] The skin template used for each <code>DropDown</code> option's rollover state.
*/
		public function set itemskinover(value:String):void {
			if (_itemData) {
				_itemData.@itemskinover = value;
				renderDropDown();
			}
		}

/**
*		[SMXML] The skin template used for each <code>DropDown</code> option's selected state.
*/
		public function get itemskinselected():String {
			var value:String = EMPTY_STRING;
			if (_itemData) {
				if (_itemData.@itemskinselected.length()) {
					value = _itemData.@itemskinselected.toString();
				}
			}
			return value;
		}

/**
*		[SMXML] The skin template used for each <code>DropDown</code> option's selected state.
*/
		public function set itemskinselected(value:String):void {
			if (_itemData) {
				_itemData.@itemskinselected = value;
				renderDropDown();
			}
		}

/**
*		[SMXML] The skin template used for the <code>DropDown</code>.
*/
		public function get listboxskin():String {
			var value:String = EMPTY_STRING;
			if (_itemData) {
				if (_itemData.@listboxskin.length()) {
					value = _itemData.@listboxskin.toString();
				}
			}
			return value;
		}

/**
*		[SMXML] The skin template used for the <code>DropDown</code>.
*/
		public function set listboxskin(value:String):void {
			if (_itemData) {
				_itemData.@listboxskin = value;
				renderDropDown();
			}
		}

/**
*		@inheritDoc
*/
		override protected function render():void {
			super.render();
			renderDropDown();           
			waitToRenderDropDownItems(null);
		}
		
		private function renderDropDown():void {
			if (_itemData.@id.length()) {
				dropDownID = _itemData.@id.toString();
			} else {
				dropDownID = DROPDOWN + Math.random().toString();
				Registry.set(this, dropDownID);
			}

			if (!listBox)
			{
				listBox = new ListBox();
				addChild(listBox);
			}                   
			var listboxComposition:XML = <listbox/>;
			if (_itemData.@scroll.length()) {
				listboxComposition.@scroll = _itemData.@scroll.toString();
			}
			if (_itemData.@listboxskin.length()) {
				listboxComposition.@skin = _itemData.@listboxskin.toString();
			}
			if (_itemData.@itemskin.length()) {
				listboxComposition.@itemskin = _itemData.@itemskin.toString();
			}
			if (_itemData.@itemskinover.length()) {
				listboxComposition.@itemskinover = _itemData.@itemskinover.toString();
			}
			if (_itemData.@itemskinselected.length()) {
				listboxComposition.@itemskinselected = _itemData.@itemskinselected.toString();
			}
			listboxComposition.@id = dropDownID + LISTBOX;
			listboxComposition.@interactive = 1;
			listboxComposition.@width = _itemData.@width.length() ? _itemData.@width.toString() : _itemWidth;
			var trayHeight:int = _itemHeight;
			if (_itemData.@trayheight.length())
			{
				trayHeight = Number(_itemData.@trayheight.toString());
			}            
			listboxComposition.@height = trayHeight;
			listBox.itemData = listboxComposition;   
			listBox.addEventListener(Event.CHANGE, handleChange);

			if (!button)
			{
				button = new Button();
				addChild(button);
			}                   
			var buttonComposition:XML = <button/>;
			if (_itemData.@buttonskin.length()) {
				buttonComposition.@skin = _itemData.@buttonskin.toString();
			}
			if (_itemData.@buttonskinover.length()) {
				buttonComposition.@skinover = _itemData.@buttonskinover.toString();
			}
			if (_itemData.@buttonskindown.length()) {
				buttonComposition.@skinselected = _itemData.@buttonskindown.toString();
			}
			buttonComposition.@id = dropDownID + BUTTON;
			buttonComposition.@interactive = 1;
			button.itemData = buttonComposition;
			button.setDimensions(_itemWidth, _itemHeight);
			button.addEventListener(MouseEvent.MOUSE_DOWN, handleDropDown);
		}   
		
		private function renderDropDownItems():void
		{
			if (_itemData.options.length())
			{
				if (_itemData.options.option.length())
				{                                     
					for each(var option:XML in _itemData.options.option)
					{
						addItem(option.text(), option.@id.toString());
					}  
					updateList();
				}
			}
		}                                                       

/**
*		[SMXML] The scroll style used for the <code>DropDown</code>.
*/
		public function get scroll():String {
			var value:String = EMPTY_STRING;
			if (_itemData) {
				if (_itemData.@scroll.length()) {
					value = _itemData.@scroll.toString();
				}
			}
			return value;
		}

/**
*		[SMXML] The scroll style used for the <code>DropDown</code>.
*/
		public function set scroll(value:String):void {
			if (_itemData) {
				_itemData.@scroll = value;
				renderDropDown();
			}
		}

/**
*		An array of selected options as <code>Object</code>s.
*/
		public function get selection():Array {
			var _selection:Array = [];
			if (listBox) 
			{
				_selection = listBox.selection;
			}
			return _selection;
		}

/**
*		@private
*/
		override public function _setDimensions(widthToSet:Number, heightToSet:Number):void {
			_itemWidth = widthToSet;
			_itemHeight = heightToSet;
			adjustDropDown();
		}
		
		private function updateList():void {    
			listBox.updateList();
		}

/**
*		@private
*/
		private function waitToRenderDropDownItems(event:Event):void
		{
			if (hasEventListener(Event.ENTER_FRAME))
			{
				if (Registry.get(dropDownID))
				{
					removeEventListener(Event.ENTER_FRAME, waitToRenderDropDownItems);
					renderDropDownItems();
				}
			} else {
				addEventListener(Event.ENTER_FRAME, waitToRenderDropDownItems);
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
			adjustDropDown();
		}
	}
}