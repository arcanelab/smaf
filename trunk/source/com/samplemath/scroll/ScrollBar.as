package com.samplemath.scroll {
	
	import com.samplemath.composition.*;
	import com.samplemath.interaction.AScroll;
	import com.samplemath.shape.Box;
	import com.samplemath.utility.Utility;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;

	

/**
*	Concrete scroll behavior for a traditional scrollbar. 
*	<p>ScrollBar is a scroll behavior strategy for the SMAF implementing a traditional scrollbar.
*	Contents of the <code>Composer</code> are scrolled upon dragging the scrollbar handle. Scroll
*	wheel support is also available.</p>
*	
*	@see com.samplemath.interaction.AScroll
*	@see com.samplemath.interaction.ScrollReference
*/
	public class ScrollBar extends AScroll {
	
		private var indicatorBoundaries:Array = [];
		private var indicatorSize:Number = 12;
		private var offset:Number = 0;
		private var persistent:Boolean = false;
		private var range:Number = 0;
		private var _scrollBarBackground:Composer;
		private var _scrollIndicator:Boolean = true;
		private var _scrollIndicatorBox:Composer;
		private var scrollSize:int = 0;
		private var thumbAttraction:Number = .4;
		private var thumbPixelSize:int;
		private var thumbPosition:Number = 0;
		private var thumbProportionalSize:Number = 0;
		private var _thumbSize:Number = 20;
		private var thumbSnapRange:Number = 2;
		private var wheelSpeed:Number = 4;

		private const APPLICATION:String = "application"; 
		private const HORIZONTAL:String = "horizontal"; 
		private const BACKGROUND_COMPOSITION:XML = <composer><box width="100%" height="100%" alpha=".36"/></composer>; 
		private const INDICATOR_COMPOSITION:XML = <composer><box width="100%" height="100%"/></composer>; 
		private static const TRESHOLD:Number = .00000001;		
		private const VERTICAL:String = "vertical";       
		
		
			
/**
*		Instantiates a ScrollBar, registers it with the <code>Composer</code>
*		it is associated with and applies scroll style values (such as scroll orientation or indicator color and size).
*
* 		@param composer The <code>Composer</code> associated with the scroll behavior. 
* 		@param scrollStyle The style ID of the scroll behavior applied. 
*
*/
		public function ScrollBar(composer:Composer, scrollStyle:String) {
			super(composer, scrollStyle);
			initialize();
		}
		
		

		
		private function adjustPosition(p_value:Number):void {
			if (orientation == HORIZONTAL) {
				thumbPosition = Math.min(Math.max((thumbPosition + p_value), 0), _composer._width - _thumbSize);
				_scrollIndicatorBox.x = Math.ceil(thumbPosition); 				
			} else {
				thumbPosition = Math.min(Math.max((thumbPosition + p_value), 0), _composer._height - _thumbSize); 				
				_scrollIndicatorBox.y = Math.ceil(thumbPosition); 				
			}
		}
		
		private function adjustThumb():void {
			if (orientation == HORIZONTAL) {
				_scrollIndicatorBox.width = thumbPixelSize;
			} else {
				_scrollIndicatorBox.height = thumbPixelSize;
			}
		}
		
		private function applyDistance(p_distance:Number):void {
			if (orientation == HORIZONTAL) {
				if (mouseIsToLeft()) {
					thumbPosition = Math.max((_composer.mouseX + p_distance), 0);
				} else {
					thumbPosition = Math.min(((_composer.mouseX - _thumbSize) + p_distance), _composer._width - _thumbSize);
				}
				_scrollIndicatorBox.x = Math.ceil(thumbPosition);
			} else {
				if (mouseIsAbove()) {
					thumbPosition = Math.max((_composer.mouseY + p_distance), 0);
				} else {
					thumbPosition = Math.min(((_composer.mouseY - _thumbSize) + p_distance), _composer._height - _thumbSize);
				}
				_scrollIndicatorBox.y = Math.ceil(thumbPosition);
			}
		}
		
		private function calculateDistance():Number {
			var distance:Number = 0;
			if (orientation == HORIZONTAL) {
				if (mouseIsToLeft()) {
					distance = thumbPosition - Math.max(_composer.mouseX, 0);
				} else {
					distance = (thumbPosition + thumbPixelSize) - Math.min(_composer.mouseX, _composer._width);
				}
			} else {
				if (mouseIsAbove()) {
					distance = thumbPosition - Math.max(_composer.mouseY, 0);
				} else {
					distance = (thumbPosition + thumbPixelSize) - Math.min(_composer.mouseY, _composer._height);
				}
			}
			return distance;
		}
		
/**
*		@inheritDoc
*/
		override public function destroy():void {
			super.destroy();
			if (_composer.hasEventListener(MouseEvent.ROLL_OVER)) {
				_composer.removeEventListener(MouseEvent.ROLL_OVER, handleRollOver);
				_composer.removeEventListener(MouseEvent.ROLL_OUT, handleRollOut);
				_scrollBarBackground.removeEventListener(MouseEvent.MOUSE_DOWN, handleBackgroundMouseDown);
				_scrollBarBackground.removeEventListener(MouseEvent.MOUSE_OVER, handleBackgroundMouseOver);
				_scrollBarBackground.removeEventListener(MouseEvent.MOUSE_OUT, handleBackgroundMouseOut);
				_scrollIndicatorBox.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
				_scrollIndicatorBox.removeEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
				_scrollIndicatorBox.removeEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
			}
			delete this;
		}
		
		private function handleAttractThumb(p_event:Event):void {
			if (Math.abs(calculateDistance()) < thumbSnapRange) {
				applyDistance(0);
				stopAttractingThumb();
			} else {
				applyDistance(calculateDistance() * thumbAttraction);
			}
			scroll();
		}
		
		private function handleBackgroundMouseDown(p_mouseEvent:MouseEvent):void {
			addEventListener(Event.ENTER_FRAME, handleAttractThumb);
			stage.addEventListener(MouseEvent.MOUSE_UP, handleBackgroundMouseUp, false, 0, true);
		}
		
		private function handleBackgroundMouseOut(p_mouseEvent:MouseEvent):void {
			if (Composition.getTemplate(StyleSheet.getScrollBarBackground(_scrollStyle)).copy())
			{
				_scrollBarBackground.empty();
				_scrollBarBackground.addItemAsData(Composition.getTemplate(StyleSheet.getScrollBarBackground(_scrollStyle)).copy());
			}   
		}
		
		private function handleBackgroundMouseOver(p_mouseEvent:MouseEvent):void {
			if (Composition.getTemplate(StyleSheet.getScrollBarBackgroundOver(_scrollStyle)).copy())
			{
				_scrollBarBackground.empty();
				_scrollBarBackground.addItemAsData(Composition.getTemplate(StyleSheet.getScrollBarBackgroundOver(_scrollStyle)).copy());
			}   
		}
		
		private function handleBackgroundMouseUp(p_mouseEvent:MouseEvent):void {
			stopAttractingThumb();
		}
		
		private function handleMouseDown(p_mouseEvent:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove, false, 0, true);
			
			if (orientation == HORIZONTAL) {
				offset = thumbPosition - _composer.mouseX;
				range = _composer._width - _thumbSize;
			} else {
				offset = thumbPosition - _composer.mouseY;
				range = _composer._height - _thumbSize;
			}
		}
		
		private function handleMouseMove(p_mouseEvent : MouseEvent):void {
			if (orientation == HORIZONTAL) {
				thumbPosition = Math.min(Math.max(_composer.mouseX + offset, 0), range);
				_scrollIndicatorBox.x = Math.ceil(thumbPosition); 
			} else {
				thumbPosition = Math.min(Math.max(_composer.mouseY + offset, 0), range);
				_scrollIndicatorBox.y = Math.ceil(thumbPosition); 
			}
			scroll();
		}

		private function handleMouseOut(p_mouseEvent:MouseEvent):void {
			if (Composition.getTemplate(StyleSheet.getScrollIndicator(_scrollStyle)).copy())
			{                      
				_scrollIndicatorBox.empty();
				_scrollIndicatorBox.addItemAsData(Composition.getTemplate(StyleSheet.getScrollIndicator(_scrollStyle)).copy());
			}   
		}
		
		private function handleMouseOver(p_mouseEvent:MouseEvent):void {
			if (Composition.getTemplate(StyleSheet.getScrollIndicatorOver(_scrollStyle)).copy())
			{
				_scrollIndicatorBox.empty();
				_scrollIndicatorBox.addItemAsData(Composition.getTemplate(StyleSheet.getScrollIndicatorOver(_scrollStyle)).copy());
			}   
		}
		
		private function handleMouseUp(p_mouseEvent:MouseEvent):void {
			if (stage.hasEventListener(MouseEvent.MOUSE_UP)) {
				stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			}
			if (stage.hasEventListener(MouseEvent.MOUSE_MOVE)) {
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			}
		}
		
		private function handleMouseWheel(p_mouseEvent : MouseEvent):void {
			if (_scrollIndicatorBox.visible)
			{
				adjustPosition(- p_mouseEvent.delta * wheelSpeed);		
				scroll();
			}
		}

		private function handleRollOver(event:MouseEvent):void {
			startScroll();
		}
		
		private function handleRollOut(event:MouseEvent):void {
			if (!persistent) {
				stopScroll();
			}
		}
		
		private function initialize():void {
			indicatorSize = StyleSheet.getScrollSize(_scrollStyle);
			persistent = StyleSheet.getScrollPersistent(_scrollStyle);
			wheelSpeed = StyleSheet.getScrollWheelSpeed(_scrollStyle);
			_scrollBarBackground = new Composer();
			if (Composition.getTemplate(StyleSheet.getScrollBarBackground(_scrollStyle)))
			{
				_scrollBarBackground.itemData = Composition.getTemplate(StyleSheet.getScrollBarBackground(_scrollStyle)).copy();
			} else {
				_scrollBarBackground.itemData = BACKGROUND_COMPOSITION.copy();
			}
			_scrollBarBackground.interactive = true;
			_scrollBarBackground.itemData.@mouselistener = APPLICATION;
			addChild(AComposable(_scrollBarBackground));
			Composition.applyProperties(AComposable(_scrollBarBackground));		
			_scrollBarBackground.visible = persistent;

			_scrollIndicatorBox = new Composer();
			if (Composition.getTemplate(StyleSheet.getScrollIndicator(_scrollStyle)).copy())
			{
				_scrollIndicatorBox.itemData = Composition.getTemplate(StyleSheet.getScrollIndicator(_scrollStyle)).copy();
			} else {
				_scrollIndicatorBox.itemData = INDICATOR_COMPOSITION.copy();
			}   
			_scrollIndicatorBox.interactive = true;
			_scrollIndicatorBox.itemData.@mouselistener = APPLICATION;
			addChild(AComposable(_scrollIndicatorBox));
			Composition.applyProperties(AComposable(_scrollIndicatorBox));		
			_scrollIndicatorBox.visible = persistent;
			if (persistent)
			{
				startScroll();
			}
			
			_composer.addEventListener(MouseEvent.ROLL_OVER, handleRollOver);
			_composer.addEventListener(MouseEvent.ROLL_OUT, handleRollOut);
			

			_scrollBarBackground.addEventListener(MouseEvent.MOUSE_DOWN, handleBackgroundMouseDown, false, 0, true);
			_scrollBarBackground.addEventListener(MouseEvent.MOUSE_OVER, handleBackgroundMouseOver, false, 0, true);
			_scrollBarBackground.addEventListener(MouseEvent.MOUSE_OUT, handleBackgroundMouseOut, false, 0, true);
			_scrollIndicatorBox.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown, false, 0, true);
			_scrollIndicatorBox.addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver, false, 0, true);
			_scrollIndicatorBox.addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut, false, 0, true);
			_composer.addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel, false, 0, true);
			
		}
		
		private function mouseIsAbove():Boolean {
			return (_composer.mouseY < (thumbPosition + (_thumbSize / 2)));
		}
		private function mouseIsToLeft():Boolean {
			return (_composer.mouseX < (thumbPosition + (_thumbSize / 2)));
		}

		private function scroll():void {
			var scrollValue:Number = 0;
			if (orientation == HORIZONTAL) {
				scrollValue = thumbPosition / (_composer._width - _thumbSize);
			} else {
				scrollValue = thumbPosition / (_composer._height - _thumbSize);
			}
			_composer.scrollTo(scrollValue);
		}
		
/**
*		@inheritDoc
*/
		override public function set scrollPosition(value:Number):void {
			super.scrollPosition = value;
			if (_scrollIndicatorBox) {
				if (orientation == HORIZONTAL) {
					_scrollIndicatorBox.x = (_composer._width - _scrollIndicatorBox.width) * value;
				}
				if (orientation == VERTICAL) {
					_scrollIndicatorBox.y = (_composer._height - _scrollIndicatorBox.height) * value;
				}                               
			}
		}
		
/**
*		@inheritDoc
*/
		override public function startScroll():void {   
			super.startScroll();
			if (((_composer.contentArea.width > _composer._width) && (orientation == HORIZONTAL)) || ((_composer.contentArea.height > _composer._height) && (orientation == VERTICAL))) {
//				Utility.javascriptAlert(_composer.contentArea.height + " / " + _composer._height + " , " + orientation);
				if (orientation == HORIZONTAL) {
					_scrollBarBackground.width = _composer._width;
					_scrollBarBackground.height = indicatorSize;
					_scrollBarBackground.y = int(_composer._height - indicatorSize);

					_scrollIndicatorBox.width = (_composer._width / _composer.contentArea.width) * _composer._width;
					_scrollIndicatorBox.height = indicatorSize;
					_scrollIndicatorBox.y = int(_composer._height - indicatorSize);
					handleSize = _scrollIndicatorBox.width / _scrollBarBackground.width;
				} else {
					_scrollBarBackground.height = _composer._height;
					_scrollBarBackground.width = indicatorSize;
					_scrollBarBackground.x = int(_composer._width - indicatorSize);

					_scrollIndicatorBox.height = (_composer._height / _composer.contentArea.height) * _composer._height;
					_scrollIndicatorBox.width = indicatorSize;
					_scrollIndicatorBox.x = int(_composer._width - indicatorSize);
					handleSize = _scrollIndicatorBox.height / _scrollBarBackground.height;
				}                               
				_scrollBarBackground.visible = true;
				_scrollIndicatorBox.visible = true;
			} else {  
				stopScroll();
			}
		}

		private function stopAttractingThumb():void {
			if (hasEventListener(Event.ENTER_FRAME)) {
				removeEventListener(Event.ENTER_FRAME, handleAttractThumb);
			}
			if (stage.hasEventListener(MouseEvent.MOUSE_UP)) {
				stage.removeEventListener(MouseEvent.MOUSE_UP, handleBackgroundMouseUp);
			}
		}
		
/**
*		@inheritDoc
*/
		override public function stopScroll():void {
			super.stopScroll();
			_scrollBarBackground.visible = false;
   			_scrollIndicatorBox.visible = false;
		}

/**
*		The proportional size of the scrollbar handle, a value ranging from 0 to 1.
*
* 	  	@default 20  
*/
		public function get handleSize() : Number {
			return thumbProportionalSize;
		}

/**
*		The proportional size of the scrollbar handle, a value ranging from 0 to 1.
*
* 	  	@default 20  
*/
		public function set handleSize(value:Number) : void {
			thumbProportionalSize = value;
			if (orientation == HORIZONTAL) {
				_thumbSize = _composer._width * value;
			} else {
				_thumbSize = _composer._height * value;
			}
			
			thumbPixelSize = int(_thumbSize);
			adjustThumb();
		}
	}
}