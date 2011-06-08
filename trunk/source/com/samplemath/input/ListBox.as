package com.samplemath.input {
	
	import com.samplemath.composition.AComposable;
	import com.samplemath.composition.Composer;
	import com.samplemath.composition.Composition;
	import com.samplemath.composition.Registry;
	import com.samplemath.font.FontManager;
	import com.samplemath.interaction.KeyBind;
	import com.samplemath.shape.Box;
	import com.samplemath.utility.Utility;

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
*	Concrete UI element for capturing the user's single or multi choice input.
*	<p><code>ListBox</code> uses <code>Composer</code> templates to render up, over or selected state of listbox options.</p>
*	                                                          
*	@see http://samplemath.com/smaf/doc/wikka.php?wakka=UsingListBox
*	@see com.samplemath.composition.StyleSheet
*/
	public class ListBox extends AComposable {

		private var listBoxComposer:Composer;
		private var listBoxID:String;
		private var _itemHeight:int = 2;
		private var _itemLabels:Array = [];
		private var _items:Array = [];
		private var _itemsIndex:Array = [];   
		private var _itemsRendered:Array = [];   
		private var itemsToRender:int = 0;
		private var _itemWidth:int = 2;          
		private var _selection:Array = [];      
		
		private const BUTTON:String = "Button";
		private const CDATA_PREFIX:String = "<![CDATA[";
		private const CDATA_SUFFIX:String = "]]>";
		private const COMPOSER:String = "Composer";
		private const DEFAULT_TEXT_FORMAT:String = "defaultTextformat";
		private const EMPTY_STRING:String = "";
		private const ID:String = "id"; 
		private const ITEM:String = "Item"; 
		private const ITEM_COMPOSITION:XML = <composer width="100%" completeaction="handleItemComplete">
			<box width="100%" height="100%"/>
			<textblock width="100%" height="100%"/>
			<box width="100%" height="100%" color="0xffffff" alpha="0" onmouseover="handleItemOver" onmouseout="handleItemOut" onmousedown="handleItemDown"/>
		</composer>;
		private const LABEL:String = "label";
		private const LISTBOX_COMPOSITION:XML = <composer>
			<box width="100%" height="100%"/>
			<composer width="100%" height="100%"/>
		</composer>;
		private const OVER:String = "Over";
		private const SCROLL:String = "scroll"; 
		private const SCROLLER:String = "Scroller";
		private const SELECTED:String = "Selected";
		private const TRUE:String = "true";
		private const UP:String = "Up";
		
		
		
			
/**
*		Instantiates ListBox.
*/
		public function ListBox() {	
			_itemData = <listbox/>;
			super();
		}
		
		

		                     
/**
*		Adds an option to the listbox. The item will appear at the end of the list.
*		
*		@param label The string label of the <code>ListBox</code> option to add. 
*		@param data Arbitary data value (typically unique string id) of the<code>ListBox</code> option to add. 
*/
		public function addItem(label:String, data:Object):void {
			addItemAt(label, data, _itemsIndex.length);
		}

/**
*		Adds an option to the listbox at a specific position.
*		
*		@param label The string label of the <code>ListBox</code> option to add. 
*		@param data Arbitary data value (typically unique string id) of the<code>ListBox</code> option to add. 
*		@param position Position the <code>ListBox</code> option to be added at within the list. 
*/
		public function addItemAt(label:String, data:Object, position:int):void {
			position = Math.min(position, _itemsIndex.length);
			position = Math.max(position, 0);
			var labelCount:int = 1;
			var originalLabel:String = label;
			while(_items[label]) {
				labelCount++; 
				label = originalLabel + labelCount.toString();
			}
			_items[label] = data;
			_itemLabels[data] = label;
			_itemsIndex = _itemsIndex.splice(0, position).concat([_items[label]].concat(_itemsIndex.splice(position, _itemsIndex.length - position)));      
		}         
		

/**
*		Adds a number of options to the listbox.
*		
*		@param itemsToAdd The array of <code>Object</code>s that describe the number of options to be added to the <code>ListBox</code>.
*		Each <code>Object</code> must have a <code>label</code> and <code>data</code> property to be successfully added as an option of the <code>ListBox</code>.
*/
		public function addItems(itemsToAdd:Array):void {
			_items = [];                                 
			_itemLabels = [];
			_itemsIndex = [];                            
			_itemsRendered = [];
			if (Registry.get(listBoxID + SCROLLER))
			{
				Registry.get(listBoxID + SCROLLER).empty();
			}
			itemsToRender = itemsToAdd.length + 1;
			handleItemComplete(null);
			for each (var itemToAdd:Object in itemsToAdd) {
				addItem(itemToAdd.label, itemToAdd.data);
			}                     
			updateList();
		}        
		
		private function addToSelection(itemLabel:String):void {
			if (_selection.indexOf(_items[itemLabel]) > -1) {
				_selection.splice(_selection.indexOf(_items[itemLabel]), 1);
				handleItemDeselect(itemLabel);
			} else {
				_selection.push(_items[itemLabel]);
				handleItemSelect(itemLabel);
			}
			dispatchEvent(new Event(Event.CHANGE, false));
		}
		
		private function adjustItem(itemToAdjust:Object, position:int):void {
			if (Registry.get(listBoxID + _itemLabels[itemToAdjust] + ITEM + COMPOSER)) {
				Registry.get(listBoxID + _itemLabels[itemToAdjust] + ITEM + COMPOSER).y = position * int(Composition.getTemplate(_itemData.@itemskin.toString()).@height.toString());
			}
		}                      
		
		private function adjustListBox():void {
			if (Registry.get(listBoxID + COMPOSER)) {
				Registry.get(listBoxID + COMPOSER).setDimensions(_itemWidth, _itemHeight);
			}
		}
		
		private function deselectItems():void {
			while (_selection.length > 0) {
				handleItemDeselect(_itemLabels[_selection.pop()]);
			}                         
		}
		
/**
*		Retrieves the <code>Object</code> representing a <code>ListBox</code> option at a specific position.
*		
*		@param position The position of the option in the list.
*		
*		@return An <code>Object</code> representing the <code>ListBox</code> option with properties <code>label</code> and <code>data</code>.
*/
		public function getItemAt(position:int):Object {
			return _itemsIndex[position];
		} 
	   
/**
*		Retrieves the position of a <code>ListBox</code> option within the list.
*		
*		@param item <code>Object</code> representing the <code>ListBox</code> option with properties <code>label</code> and <code>data</code>.
*		
*		@return The position of the option in the list.
*/
		public function getItemPosition(item:Object):uint {
			return _itemsIndex.indexOf(item);
		} 
	   
		private function handleItemComplete(event:Event):void {
			itemsToRender--;
			if (itemsToRender <= 0) {
				handleComplete();
			}
		}
		
/**
*		@private
*/
		public function handleItemOut(event:Event):void {
			var itemID:String = (event.currentTarget as AComposable).itemData.@id.toString().split(ITEM + BUTTON)[0];
			if (Registry.get(itemID + ITEM + BUTTON)) {
				if (Registry.get(itemID + ITEM + BUTTON).visible) {
					if (Registry.get(itemID + ITEM + OVER)) {
						Registry.get(itemID + ITEM + OVER).visible = false;
					}
					if (Registry.get(itemID + ITEM + UP)) {
						Registry.get(itemID + ITEM + UP).visible = true;
					}
				}
			}
		}

/**
*		@private
*/
		public function handleItemDown(event:Event):void {
			var itemID:String = (event.currentTarget as AComposable).itemData.@id.toString().split(ITEM + BUTTON)[0];
			var itemLabel:String = itemID.split(listBoxID)[1];
			if (multiselect && (_selection.length > 0) && KeyBind.shiftDown) {
				addToSelection(itemLabel);                         
			} else {            
				selectItemByLabel(itemLabel);
			}                   
		}
		    
/**
*		@private
*/
		public function handleItemOver(event:Event):void {
			var itemID:String = (event.currentTarget as AComposable).itemData.@id.toString().split(ITEM + BUTTON)[0];
			if (Registry.get(itemID + ITEM + BUTTON)) {
				if (Registry.get(itemID + ITEM + BUTTON).visible) {
					if (Registry.get(itemID + ITEM + OVER)) {
						Registry.get(itemID + ITEM + OVER).visible = true;
					}
					if (Registry.get(itemID + ITEM + UP)) {
						Registry.get(itemID + ITEM + UP).visible = false;
					}
				}
			}
		}  

		private function handleItemDeselect(itemLabel:String):void {
			var itemID:String = listBoxID + itemLabel;
			if (Registry.get(itemID + ITEM + UP)) {
				Registry.get(itemID + ITEM + UP).visible = true;
			}
			if (Registry.get(itemID + ITEM + OVER)) {
				Registry.get(itemID + ITEM + OVER).visible = false;
			}
			if (Registry.get(itemID + ITEM + SELECTED)) {
				Registry.get(itemID + ITEM + SELECTED).visible = false;
			}
			if (Registry.get(itemID + ITEM + BUTTON)) {
				Registry.get(itemID + ITEM + BUTTON).visible = true;
			}
		}
		
		private function handleItemSelect(itemLabel:String):void {
			var itemID:String = listBoxID + itemLabel;
			if (Registry.get(itemID + ITEM + UP)) {
				Registry.get(itemID + ITEM + UP).visible = false;
			}
			if (Registry.get(itemID + ITEM + OVER)) {
				Registry.get(itemID + ITEM + OVER).visible = false;
			}
			if (Registry.get(itemID + ITEM + SELECTED)) {
				Registry.get(itemID + ITEM + SELECTED).visible = true;
			}         
			if (!multiselect)
			{
				if (Registry.get(itemID + ITEM + BUTTON)) {
					Registry.get(itemID + ITEM + BUTTON).visible = false;
				}                       
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
			adjustListBox();
		}

/**
*		[SMXML] The default skin template used for each <code>ListBox</code> option.
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
*		[SMXML] The default skin template used for each <code>ListBox</code> option.
*/
		public function set itemskin(value:String):void {
			if (_itemData) {
				_itemData.@itemskin = value;
				renderListBox();
			}
		}

/**
*		[SMXML] The skin template used for each <code>ListBox</code> option's rollover state.
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
*		[SMXML] The skin template used for each <code>ListBox</code> option's rollover state.
*/
		public function set itemskinover(value:String):void {
			if (_itemData) {
				_itemData.@itemskinover = value;
				renderListBox();
			}
		}

/**
*		[SMXML] The skin template used for each <code>ListBox</code> option's selected state.
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
*		[SMXML] The skin template used for each <code>ListBox</code> option's selected state.
*/
		public function set itemskinselected(value:String):void {
			if (_itemData) {
				_itemData.@itemskinselected = value;
				renderListBox();
			}
		}

/**
*		The number of options available for the <code>ListBox</code>.
*/
		public function get length():int {
			return _itemsIndex.length;
		}                        
		
/**
*		[SMXML] Boolean property specifying whether multiple choices are accepted in the <code>ListBox</code>.
*
*		@default false
*/
		public function get multiselect():Boolean {
			var value:Boolean = false;
			if (_itemData) {
				if (_itemData.@multiselect.length()) {
					value = Number(_itemData.@multiselect.toString()) || (_itemData.@multiselect.toString() == TRUE);
				}
			}
			return value;
		}

/**
*		[SMXML] Boolean property specifying whether multiple choices are accepted in the <code>ListBox</code>.
*
*		@default false
*/
		public function set multiselect(value:Boolean):void {
			if (_itemData) {
				_itemData.@multiselect = value;
				adjustListBox();
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
*		Removes an option from the listbox.
*		
*		@param itemToRemove <code>Object</code> representing the <code>ListBox</code> option with properties <code>label</code> and <code>data</code>.
*/
		public function removeItem(itemToRemove:Object):void {
			_itemsIndex.splice(_itemsIndex.indexOf(itemToRemove), 1);
			_items[_itemLabels[itemToRemove]] = null;
			_itemLabels[itemToRemove] = null;
		}

/**
*		Removes all options from the listbox.
*/
		public function removeItems():void {
			while(_itemsIndex.length) {
				removeItem(_itemsIndex[0]);
			}         
			Registry.get(listBoxID + SCROLLER).empty();
		}
				
/**
*		@inheritDoc
*/
		override protected function render():void {
			super.render();
			renderListBox();
			waitToRenderListBoxItems(null);
			adjustListBox(); 
    	}
		        
		private function renderItem(label:String,  position:int, itemData:Object):XML {
			var thisItemID:String = listBoxID + label;     
			     
			var itemRendered:XML = <composer width="100%" height="100%"/>;
			if (_itemData.@itemskin.length()) {
				var itemRenderedUp:XML = <composer/>;
				itemRenderedUp.@template = _itemData.@itemskin.toString();
				Composition.addPattern(itemRenderedUp, LABEL, label);
				Composition.addPattern(itemRenderedUp, ID, thisItemID + ITEM  + UP);
				itemRendered.appendChild(itemRenderedUp);
			}                         
			if (_itemData.@itemskinover.length()) {
				var itemRenderedOver:XML = <composer/>;
				itemRenderedOver.@template = _itemData.@itemskinover.toString();
				itemRenderedOver.@visible = 0;
				Composition.addPattern(itemRenderedOver, LABEL, label);
				Composition.addPattern(itemRenderedOver, ID, thisItemID + ITEM  + OVER);
				itemRendered.appendChild(itemRenderedOver);
			}                         

			if (_itemData.@itemskinselected.length()) {
				var itemRenderedSelected:XML = <composer/>;
				itemRenderedSelected.@template = _itemData.@itemskinselected.toString();
				itemRenderedSelected.@visible = 0;
				Composition.addPattern(itemRenderedSelected, LABEL, label);
				Composition.addPattern(itemRenderedSelected, ID, thisItemID + ITEM  + SELECTED);
				itemRendered.appendChild(itemRenderedSelected);
			}                         

			var itemButtonRendered:XML = <box alpha="0" interactive="1" width="100%" height="100%" onmouseover="handleItemOver" onmouseout="handleItemOut" onmousedown = "handleItemDown"/>;
			itemButtonRendered.@id = thisItemID + ITEM + BUTTON;
			itemButtonRendered.@mouselistener = listBoxID;                                      
			itemRendered.appendChild(itemButtonRendered);
			itemRendered.@id = thisItemID + ITEM + COMPOSER;
			itemRendered.@y = position * int(Composition.getTemplate(_itemData.@itemskin.toString()).@height.toString());
			itemRendered.@height = int(Composition.getTemplate(_itemData.@itemskin.toString()).@height.toString());
			return itemRendered;
		}

		private function renderListBox():void {
			if (_itemData.@selection.length()) {
				selection = _itemData.@selection.toString().split(",");
			}                       
			if (_itemData.@id.length()) {
				listBoxID = _itemData.@id.toString();
			} else {
				listBoxID = SCROLLER + Math.random().toString();
				_itemData.@id = listBoxID;
			}

			if (!listBoxComposer)
			{
				listBoxComposer = new Composer();
				addChild(listBoxComposer);    
			}   
			var listBoxRendered:XML = <composer/>;
			if (_itemData.@skin.length()) {
				var listBoxLayoutRendered:XML = <composer/>;
				listBoxLayoutRendered.@template = _itemData.@skin.toString();
				Composition.addPattern(listBoxLayoutRendered, ID, listBoxID);
				Composition.addPattern(listBoxLayoutRendered, SCROLL, _itemData.@scroll.length() ? _itemData.@scroll.toString() : EMPTY_STRING);
				listBoxRendered.appendChild(listBoxLayoutRendered);
			}            
			listBoxRendered.@id = listBoxID + COMPOSER;      
			listBoxRendered.@width = _itemData.@width.length() ? _itemData.@width.toString() : _itemWidth;
			listBoxRendered.@height = _itemData.@height.length() ? _itemData.@height.toString() : _itemHeight;
			listBoxComposer.itemData = listBoxRendered;
		}  
		
		private function renderListBoxItems():void
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
*		[SMXML] The scroll style used for the <code>ListBox</code>.
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
*		[SMXML] The scroll style used for the <code>ListBox</code>.
*/
		public function set scroll(value:String):void {
			if (_itemData) {
				_itemData.@scroll = value;
				adjustListBox();
			}
		}

/**
*		Scrolls the <code>Composer</code> to position of Contained UI element represented by the itemID.
*
* 		<p>If there is a UI element contained by the <code>Composer</code> with the unique ID of <code>itemID</code> then
*	 	the <code>Composer</code> will scroll to the position where this element starts. Orientation of scroll is
*		specified by the <code>Composer</code>'s scroll style.</p>
*
* 		@param itemID Unique id of UI element to scroll to. 
*
*/
		public function scrollToItem(itemID:String):void {
			if (Registry.get(listBoxID + SCROLLER))
			{
				Registry.get(listBoxID + SCROLLER).stopScroll();
				Registry.get(listBoxID + SCROLLER).scrollToItem(listBoxID + _itemLabels[itemID] + ITEM + COMPOSER);
			}
		}

/**
*		Selects a single option in the <code>Listbox</code> by label.
*		
*		@param itemLabel Label of the <code>ListBox</code> option to select.
*/
		private function selectItemByLabel(itemLabel:String):void {
			deselectItems();
			_selection.push(_items[itemLabel]);
			handleItemSelect(itemLabel);
			dispatchEvent(new Event(Event.CHANGE, false));
		}    
		
/**
*		@private
*/
		override public function _setDimensions(widthToSet:Number, heightToSet:Number):void {
			_itemWidth = widthToSet;
			_itemHeight = heightToSet;
			adjustListBox();
		}
		
/**
*		An array of selected options as <code>Object</code>s.
*/
		public function get selection():Array {
			return _selection;
		}

/**
*		An array of selected options as <code>Object</code>s.
*/
		public function set selection(value:Array):void {
			if (_itemData) {
				_itemData.@selection = value.join(",");
			}
			deselectItems();
			for each(var itemToSelect:Object in value) {
				if (_itemLabels[itemToSelect]) {
					if (_selection.length < 1) {
						selectItemByLabel(_itemLabels[itemToSelect]);
					} else {      
						if (multiselect) {
							addToSelection(_itemLabels[itemToSelect]);
						}
					}
				}
			}  
			if ((_selection.length == 1) && (_selection[0] == null)) {
				_selection = [];
			}
		}

/**
*		[SMXML] The skin template used for the <code>ListBox</code>.
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
*		[SMXML] The skin template used for the <code>ListBox</code>.
*/
		public function set skin(value:String):void {
			if (_itemData) {
				_itemData.@skin = value;
				renderListBox();
			}
		}

/**
*		@inheritDoc
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
		public function updateList():void {    
			for(var i:int = 0; i < _itemsIndex.length; i++) {
				if (_itemsRendered.indexOf(_itemsIndex[i]) > -1) {
					adjustItem(_itemsIndex[i], i);
				} else {                                                       
					_itemsRendered.push(_itemsIndex[i]);
					if (Registry.get(listBoxID + SCROLLER))
					{
						Registry.get(listBoxID + SCROLLER).addItemAsData(renderItem(_itemLabels[_itemsIndex[i]], i, _itemsIndex[i]));
					}
				}
			}                  
			adjustListBox();
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
			adjustListBox();
		}     
		
		private function waitToRenderListBoxItems(event:Event):void
		{
			if (hasEventListener(Event.ENTER_FRAME))
			{
				if (Registry.get(listBoxID))
				{
					removeEventListener(Event.ENTER_FRAME, waitToRenderListBoxItems);
					renderListBoxItems();
				}
			} else {
				addEventListener(Event.ENTER_FRAME, waitToRenderListBoxItems, false, 0, true);
			}
		}
	}
}