package com.samplemath.composition {
	
	import com.samplemath.configuration.Configuration;
	import com.samplemath.interaction.AScroll;
	import com.samplemath.interaction.AInteractive;
	import com.samplemath.interaction.ScrollReference;
	import com.samplemath.load.Data;
	import com.samplemath.load.ServiceProxy;
	import com.samplemath.render.Filter;
	import com.samplemath.shape.Box;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
//	force import classes to compose
	ComponentReference;
	Composer;

	
	

	
/**
*	The key element in recursive UI composition. 
*	<p>The root element of every composition is a Composer. It is an interactive display object container capable
*	of containing a number of UI elements according to the <code>itemData</code> markup. Containers can be
*	contained within Containers resulting in a powerful recursive composition model.</p>
*	
*	@see com.samplemath.composition.AComposable
*	@see com.samplemath.interaction.AInteractive
*/
	public class Composer extends AInteractive {
		
		private var childComponentsReady:int;
		private var components:Array = [];
		private var _contentArea:Sprite;
		private var _content:Sprite;
		private var defaultScrollPosition:Number = 0;
		private var isComplete:Boolean = true;
		private var _itemHeight:int = 0;
		private var _itemWidth:int = 0;   
		private var scrollBackgroundComposition:XML = <box  width="100%" height="100%" color="0xff0000" alpha="0" mouselistener="application"/>;
		private var scrollBackgroundFill:Box;
		private var scrollBehavior:AScroll;            
		
		private const CROP:String = "crop";                                    
		private const DOT:String = ".";
		private const DOUBLE_COLON:String = "::";
		private const EMPTY_STRING:String = "";               
		private const FIT:String = "fit";       
		private const HORIZONTAL:String = "horizontal";       
		private const REPLACE:String = "replace";
		private const STRETCH:String = "stretch";       
		private const STYLE:String = "style";       
		private const TEMPLATE:String = "template";       
		private const TRUE:String = "true";       
		private const VERTICAL:String = "vertical";       
		
			
		
		
			
/**
*		Instantiates the <code>Composer</code> class.
*/
		public function Composer() {	     
			_itemData = <composer/>;
			super();
		}
		
		
		
		
/**
*		Adds a UI element to the Composer using the element's markup representation.
*
* 		<p>Appends the UI element's markup to the Composer's compositon markup and
*		adds the UI element to the Composer's display list. All layout and behavior
*		information in the markup is applied to the UI element relative to its parent, the Composer.</p>
*
* 		@param itemData XML markup describing the UI element to add to the <code>Composer</code>. 
*
*/
		public function addItemAsData(itemData:XML):void {
			_itemData.appendChild(itemData);
			renderChildComponent(itemData);
			alignItem(); 
		}
		
		private function adjustContentScrollRect():void {
			if (_content) {                     
				var noMask:Boolean = false;
				if (_itemData.@nomask.length())
				{
					noMask = Number(_itemData.@nomask.toString()) || (_itemData.@nomask.toString() == TRUE);
				}
				if ((((_itemWidth > 0) && (_itemWidth < 8192)) && ((_itemHeight > 0) && (_itemHeight < 8192))) && (!noMask)) {
					var maskOffsetX:int = 0;
					var maskOffsetY:int = 0;
					if (_itemData.@maskOffsetX.length()) {
					   maskOffsetX = int(_itemData.@maskOffsetX.toString());
					}
					if (_itemData.@maskOffsetY.length()) {
					   maskOffsetY = int(_itemData.@maskOffsetY.toString());
					}
					_content.scrollRect = new Rectangle(maskOffsetX, maskOffsetY, _itemWidth, _itemHeight);
				} else {
					_content.scrollRect = null;
				}                                          
			}
		}
		
		private function adjustInteractivity():void {
			_content.mouseEnabled = false;
			_content.buttonMode = false;
			_contentArea.mouseEnabled = false;
			_contentArea.buttonMode = false;
			mouseEnabled = false;
			buttonMode = false;

			if (_itemData.@interactive.length()) {
				if (Number(_itemData.@interactive.toString())) {
					_content.mouseEnabled = true;
					_content.buttonMode = true;
					_contentArea.buttonMode = true;
					_contentArea.mouseEnabled = true;
					mouseEnabled = true;
					buttonMode = true;
				}
			}
		}

		private function adjustScale():void {
			if (_contentArea) {
				if (_contentArea.width && _contentArea.height) {
					adjustScrollBackgroundFill();
					var targetRectangle:Rectangle = new Rectangle(0, 0, _itemWidth, _itemHeight);
					if (_contentArea.numChildren) {
						if (_contentArea.getChildAt(0) is AComposable) {
							var childComposable:AComposable = _contentArea.getChildAt(0) as AComposable;
							if ((childComposable.width != _contentArea.width)) {
								targetRectangle.width = (_contentArea.width / childComposable.width) * targetRectangle.width;
							}
							if ((childComposable.height != _contentArea.height)) {
								targetRectangle.height = (_contentArea.height / childComposable.height) * targetRectangle.height;
							}
						}
					}
					switch (_itemData.@scale.toString()) {
						case CROP:      
							if (((_contentArea.width / _contentArea.height) * targetRectangle.height) < targetRectangle.width) {
								_content.height = int(_contentArea.height / (_contentArea.width / targetRectangle.width)); 
								_content.width = targetRectangle.width;
							} else {
								_content.width = int(_contentArea.width / (_contentArea.height / targetRectangle.height));
								_content.height = targetRectangle.height;
							}
							break;
						case FIT:
							if (((_contentArea.width / _contentArea.height) * targetRectangle.height) > targetRectangle.width) {
								if (_contentArea.height) {
									_content.height = int(_contentArea.height / (_contentArea.width / targetRectangle.width)); 
									_content.width = targetRectangle.width;
								}
							} else {
								if (_contentArea.width) {
									_content.width = int(_contentArea.width / (_contentArea.height / targetRectangle.height));
									_content.height = targetRectangle.height;
								}
							}
							break;
						case STRETCH:
							_content.width = targetRectangle.width;
							_content.height = targetRectangle.height;
							break;
						default:
							_content.width = targetRectangle.width;
							_content.height = targetRectangle.height;
							break;
					}
					_content.x = int((targetRectangle.width - _content.width) / 2);
					_content.y = int((targetRectangle.height - _content.height) / 2);
					_content.scrollRect = null;
				}
			}
		}     
		
		private function handleWaitForContentHeight(event:Event):void
		{
			if (_contentArea.height != 0)
			{
				stage.removeEventListener(Event.ENTER_FRAME, handleWaitForContentHeight);
				adjustScrollBehavior();
			}
		}
		
		private function adjustScroll():void {
			if (_itemData.@scroll.length()) {                         
				adjustScrollBackgroundFill();                                                                                                        
				if (_contentArea.height == 0)
				{        
					if (stage)
					{
						stage.addEventListener(Event.ENTER_FRAME, handleWaitForContentHeight, false, 0, true);
					}
				} else {
					adjustScrollBehavior();
				}
			}
		}
		
		private function adjustScrollBehavior():void
		{
			if (((_contentArea.width > _width) && ((StyleSheet.getScrollOrientation(_itemData.@scroll.toString()) == HORIZONTAL))) || ((_contentArea.height > _height) && ((StyleSheet.getScrollOrientation(_itemData.@scroll.toString()) == VERTICAL)))) {
				if (scrollBehavior) {
					if (scrollBehavior.scrolling)
					{
						scrollBehavior.startScroll();
					}
					scrollTo(scrollBehavior.scrollPosition);
				} else {          
					scrollTo(defaultScrollPosition);
				}
			} else {     
				stopScroll();
				scrollTo(defaultScrollPosition);
			}       
		}

		private function adjustScrollBackgroundFill():void {
			if (scrollBackgroundFill) {
				if (StyleSheet.getScrollOrientation(_itemData.@scroll.toString()) == HORIZONTAL) {
					scrollBackgroundFill.width = 0;
					scrollBackgroundFill.width = _contentArea.width;
					scrollBackgroundFill.height = _itemHeight;
				}
				if (StyleSheet.getScrollOrientation(_itemData.@scroll.toString()) == VERTICAL) {
					scrollBackgroundFill.width = _itemWidth;
					scrollBackgroundFill.height = 0;
					scrollBackgroundFill.height = _contentArea.height;
				}
			}
		}
		
/**
*		Readjusts the Composer's dimensions  and layout. 
*
* 		<p>Resizes the Composer according to its <code>itemData</code> relative to its parent Composer, if available.</p>
*/
		public function alignItem():void {
			adjustContentScrollRect();
			alignContentItems();      
			adjustScroll();
			if (_itemData.@scale.length()) {
				adjustScale();
			}
			callResizeListener();
		}
		
/**
*		Readjusts each UI element's dimensions and layout contained by the Composer. 
*/
		public function alignContentItems():void {
			for each (var item:Object in components) {
				if (item is AComposable) {
					Composition.applyProperties(AComposable(item));
				}
			}
			if (composer) {
/*				composer.alignItem();*/
			}
		}

		private function callResizeListener():void {
			if (_itemData.@resizeListener.length()) {
				if (Registry.get(_itemData.@resizeListener)) {
					if (Registry.get(_itemData.@resizeListener).hasOwnProperty(_itemData.@resizeAction)) {
						Registry.get(_itemData.@resizeListener)[_itemData.@resizeAction](_itemData.@resizeParameters);
					}
				}
			}				
		}
		
/**
*		@private
*/
		public function get content():Sprite {
			return _content;
		}
		
/**
*		The <code>Sprite</code> containing the UI elements in the <code>Composer</code> as DisplayObjects.
*/
		public function get contentArea():Sprite {
			return _contentArea;
		}
		
/**
*		@inheritDoc
*/
		override public function destroy():void {
			empty();
			if (scrollBehavior) {
				scrollBehavior.destroy();
			}
			if (_itemData) {
				while (_itemData.children().length()) {
					delete _itemData.children()[0];
				}   
			}
			super.destroy();
		}
				
		private function drawScrollBackgroundFill():void {
			if (!scrollBackgroundFill) {
				scrollBackgroundFill = new Box();
				scrollBackgroundFill.itemData = scrollBackgroundComposition;
				_contentArea.addChild(AComposable(scrollBackgroundFill));
				Composition.applyProperties(AComposable(scrollBackgroundFill));		
			}
		}

/**
*		Removes all UI elements from the Composer.
*/
		public function empty():void {
			while (components.length) {
				var nextComponent:AComposable = components.pop();
				nextComponent.destroy();
			}    
		}        
		
/**
*		@private
*/
		public function handleChildComponentReady():void {
			if (!isComplete) {
				childComponentsReady++;          
				if (childComponentsReady >= _itemData.elements().length()) {
					isComplete = true;
					adjustScroll(); 
					Composition.applyFilters(AComposable(this));		
					if (stage) {
						stage.addEventListener(Event.ENTER_FRAME, handleCompleteTimeout, false, 0, true);
					} else {
						handleComplete();
					}
				}
			}
		}

/**
*		@private
*/
		public function handleCompleteTimeout(event:Event):void {              
			if (stage) {
				if (stage.hasEventListener(Event.ENTER_FRAME)) {
					stage.removeEventListener(Event.ENTER_FRAME, handleCompleteTimeout);
				}
			}     
			handleComplete();
		}

/**
*		@private
*/
		public function handleContentDataLoaded(event:Event):void {
			var dataLoaded:XML = new XML(event.target.data);
			itemData = Composition.applyReplacePatterns(itemData, dataLoaded);
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
			alignItem();
		}

/**
*		@private
*/
		private function initializeScrollBehavior():void {
			if (!scrollBehavior) {
				if (_itemData.@defaultScrollPosition.length()) {
					defaultScrollPosition = Number(_itemData.@defaultScrollPosition.toString())
				}
				var scrollBehaviorName:String = StyleSheet.getScrollType(_itemData.@scroll.toString());
				ScrollReference.DEFAULT_SCROLL_BEHAVIOR;
				if (_itemData.@behavior.length()) {
					scrollBehaviorName = _itemData.@behavior.toString();
				}
				var ScrollBehaviorClass:Class = Class(getDefinitionByName(ScrollReference.convertClassNameToFullClassName(scrollBehaviorName)));
				scrollBehavior = new ScrollBehaviorClass(this, _itemData.@scroll.toString());
				addChild(scrollBehavior);
			}
		}   
		
/**
*		@inheritDoc
*/
		override public function set itemData(data:XML):void {  
			unregisterEvents();
			if (data) {
				_itemData = data;
			}
			Composition.applyTemplate(AComposable(this));		
			render();
			Composition.applyProperties(AComposable(this));		
		}
		        
		private function loadContentData():void {             
			if (_itemData.@url.toString()) {
				var url:String = _itemData.@url.toString();     
				var bypassBaseURL:Boolean = false;
				if (_itemData.@bypassBaseURL.length())
				{
					if (Number(_itemData.@bypassBaseURL.toString()) || Boolean(_itemData.@bypassBaseURL.toString()))
					{                                                         
						bypassBaseURL = true;
					}
				}                             
				
				_itemData.@urlLoaded = _itemData.@url.toString();
				delete _itemData.@url[0]; 
				var contentData:Data = new Data(url, null, false, false, bypassBaseURL);									
				contentData.loader.addEventListener(Event.COMPLETE, handleContentDataLoaded, false, 0, true);
			}
		}   
		
		private function renderChildComponent(childItemData:XML):void {
			try {                                                    
				var className:String = childItemData.name().toString().split(DOUBLE_COLON).join(DOT);
				var ComponentClass:Class = Class(getDefinitionByName(className));
			} catch (p_error:Error) {
				className = Composition.convertClassNameToFullClassName(childItemData.name().toString().split(DOUBLE_COLON).join(DOT));
				ComponentClass = Class(getDefinitionByName(className));
			}
			if (ComponentClass)
			{
				var thisComponent:AComposable = new ComponentClass();
				_contentArea.addChild(thisComponent);
				thisComponent.composer = this;
				thisComponent.itemData = childItemData;
				components.push(thisComponent);
			}
		}
		
		private function renderContent():void {
			Filter.killFilters(this as Sprite);
			childComponentsReady = -1;
			isComplete = false;       
                   
			for each (var contentItemData:XML in _itemData.elements()) {         
				var contentItemDataToRender:XML = contentItemData;
				if (contentItemData.localName().toLowerCase() == STYLE) {
					childComponentsReady++;
					StyleSheet.processStyleNode(contentItemData);
				} else {
					if (contentItemData.localName().toLowerCase() == TEMPLATE) {
						childComponentsReady++;
						Composition.processTemplateNode(contentItemData);
					} else {
						if (contentItemData.localName().toLowerCase() != REPLACE) {
							renderChildComponent(contentItemDataToRender);
						}
					}
				}
			}	 
			handleChildComponentReady();            
		}
		
		private function renderContentArea():void {
			if (!_content) {
				_content = new Sprite();
				addChild(_content);
				_contentArea = new Sprite();
				_content.addChild(_contentArea);
			} else {
				empty();
			}
		}
		
/**
*		@inheritDoc
*/
		override protected function render():void {
			super.render();
			if (_itemData.@url.length()) {
				loadContentData();
			} else {                       
				renderContentArea();
				if (_itemData.@scroll.length()) {
					drawScrollBackgroundFill();
				}
				renderContent();
				if (_itemData.@scroll.length()) {
					initializeScrollBehavior();
				}
				adjustInteractivity();
			}
		}
		
/**
*		Scrolls the <code>Composer</code> to position provided in the <code>value</code> parameter.
*
* 		<p>The contents of the Composer get scrolled in the direction specified by the <code>Composer</code>'s scroll style.
*		The <code>value</code> parameter can range from 0 to 1 meaning in case of vertical scrolling 0 being all the way on top
*		while 1 meaning scrolled all the way to the bottom of the Composer.</p>
*
* 		@param value A Number from 0 to 1 representing the scroll position. 
*
*/
		public function scrollTo(value:Number):void {
			if (_itemData) {
				if (StyleSheet.getScrollOrientation(_itemData.@scroll.toString()) == HORIZONTAL) {
					_content.scrollRect = new Rectangle(((_contentArea.width - _itemWidth) * value), 0, _itemWidth, _itemHeight);
				}
				if (StyleSheet.getScrollOrientation(_itemData.@scroll.toString()) == VERTICAL) {
					_content.scrollRect = new Rectangle(0, ((_contentArea.height - _itemHeight) * value), _itemWidth, _itemHeight);
				}
				if (scrollBehavior) {
					scrollBehavior.scrollPosition = value;
				}     
				if (_itemData.@scrollListener.length() && _itemData.@scrollAction.length()) {
					Registry.get(_itemData.@scrollListener.toString())[_itemData.@scrollAction.toString()](value);
				}
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
			var value:Number = 0;
			
			if (Registry.get(itemID)) {
				if (StyleSheet.getScrollOrientation(_itemData.@scroll.toString()) == HORIZONTAL) {
					value = Math.floor(Registry.get(itemID).x) / (_contentArea.width - _itemWidth);
					if (_contentArea.width > _itemWidth) {
						scrollTo(value);					
					}
				}
				if (StyleSheet.getScrollOrientation(_itemData.@scroll.toString()) == VERTICAL) {
					value = Math.floor(Registry.get(itemID).y) / (_contentArea.height - _itemHeight);
					if (_contentArea.height > _itemHeight) {
						scrollTo(value);					
					}
				}
			}
		}

/**
*		@private
*/		
		override public function _setDimensions(widthToSet:Number, heightToSet:Number):void {
			_itemWidth = widthToSet;
			_itemHeight = heightToSet;
			alignItem();
		}
		
/**
*		Stops scrolling of the <code>Composer</code> if it's currently in effect.
*/
		public function stopScroll():void {
			if (scrollBehavior) {
				scrollBehavior.stopScroll();
			}
		}
		
/**
*		[SMXML] The URL of the SMXML rendered.
*/
		public function get url():String {
			var value:String = EMPTY_STRING;
			if (_itemData) {
				if (_itemData.@url.length()) {
					value = _itemData.@url.toString();
				}
			}
			return (_itemData.@url.length()) ? value : undefined;
		}

/**
*		[SMXML] The URL of the SMXML rendered.
*/
		public function set url(value:String):void {
			if (_itemData) {
				_itemData.@url = value;
				itemData = _itemData;
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
			alignItem();
		}
	}
}