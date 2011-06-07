package com.samplemath.scroll {
	
	import com.samplemath.composition.*;
	import com.samplemath.interaction.AScroll;
	import com.samplemath.shape.Box;
	import com.samplemath.utility.Utility;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	

/**
*	Concrete scroll behavior for barless scrolling. 
*	<p>Momentum is a scroll behavior strategy for the SMAF implementing scrolling interaction
*	without using a scrollbar. The contents of the <code>Composer</code> are scrolled upon certain mouse movement
*	relative to the <code>Composer</code>'s layout. There is no clicking involved in scrolling making Momentum
*	a more advanced and faster UI alternative to traditional scrollbars.</p>
*	
*	@see com.samplemath.interaction.AScroll
*	@see com.samplemath.interaction.ScrollReference
*/
	public class Momentum extends AScroll {
	
		private var appliedVector:Number = 0;
		private var _clickPause:Boolean = false;
		private var indicatorBoundaries:Array = [];
		private var indicatorSize:Number = 12;
		private var maxMouse:int = 0;
		private var mouseAlignVelocity:Number = 1;
		private var mouseCenter:Number = 0;
		private var mouseIsDown:Boolean = false;
		private var mouseOrigin:Number = Infinity;
		private var _mouseOriginIndicator:Composer;
		private var mouseVelocity:Number = 0;
		private var previousScrollPosition:Number;
		private var _scrollIndicator:Boolean = true;
		private var _scrollIndicatorBox:Composer;
		private var scrollMargin:int = 64;
		private var scrollRatio:Number = .02;
		private var scrollSize:int = 0;
		private var scrollVelocityMax:Number = 16;

		private const HORIZONTAL:String = "horizontal";       
		private const INDICATOR_COMPOSITION:XML = <composer><box width="100%" height="100%" alpha=".36"/></composer>; 
		private const ORIGIN_INDICATOR_COMPOSITION:XML = <composer><box width="100%" height="100%"/></composer>; 
		private const VERTICAL:String = "vertical";       
		private static const TRESHOLD:Number = .00000001;		
		
		

			
/**
*		Instantiates a Momentum scroll behavior, registers it with the <code>Composer</code>
*		it is associated with and applies scroll style values (such as scroll orientation or indicator color and size).
*
* 		@param composer The <code>Composer</code> associated with the scroll behavior. 
* 		@param scrollStyle The style ID of the scroll behavior applied. 
*
*/
		public function Momentum(composer:Composer, scrollStyle:String) {
			super(composer, scrollStyle);
			initialize();
		}
		
		

		
/**
*		@inheritDoc
*/
		override public function destroy():void {
			super.destroy();
			if (_composer.hasEventListener(MouseEvent.ROLL_OVER)) {
				_composer.removeEventListener(MouseEvent.ROLL_OVER, handleRollOver);
			}
			if (_composer.hasEventListener(MouseEvent.ROLL_OUT)) {
				_composer.removeEventListener(MouseEvent.ROLL_OUT, handleRollOut);
			}
			if (_composer.hasEventListener(MouseEvent.MOUSE_DOWN)) {
				_composer.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			}
			if (_composer.hasEventListener(MouseEvent.MOUSE_UP)) {
				_composer.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			}
			delete this;
		}
		
		private function handleMouseDown(event:MouseEvent):void {
			mouseIsDown = true;
		}
		
		private function handleMouseUp(event:MouseEvent):void {
			mouseIsDown = false;
		}
		
		private function handleRollOver(event:MouseEvent):void {
			startScroll();
		}
		
		private function handleRollOut(event:MouseEvent):void {
			stopScroll();
		}
		
		private function handleScroll(event:Event):void {
			if (!mouseIsDown) {
				var scrollVector:Number = 0;
				var mousePosition:Number = 0;
				//!!! store orientation to optimize
				if (orientation == HORIZONTAL) {
					mousePosition = mouseX;
				}
				if (orientation == VERTICAL) {
					mousePosition = mouseY;
				}
				scrollVector = (mousePosition - mouseOrigin) * scrollRatio;
				if (Math.abs(scrollVector) > 1) {
					var newScrollVector:Number = Math.pow(scrollVector, 2);
					if (scrollVector < 0) {
						scrollVector = - newScrollVector;
					} else {
						scrollVector = newScrollVector;
					}
				}
				scrollVector = Math.max(Math.min(scrollVector, scrollVelocityMax), - scrollVelocityMax);

				var predictedPosition:Number = _scrollPosition + (scrollVector / scrollSize);

				if (((predictedPosition < 0) && (scrollVector < 0)) || ((predictedPosition > 1) && (scrollVector > 0))) {
					var predictedAppliedPosition:Number = _scrollPosition + (appliedVector / scrollSize);
					var positionLimit:int = 0;
					if (scrollVector > 0) {
						positionLimit = 1;
					}
					var distanceRemaining:Number = Math.abs(predictedAppliedPosition - positionLimit) * scrollSize;
					if (appliedVector > 0) {
						appliedVector -= distanceRemaining * .64;
					} else {
						appliedVector += distanceRemaining * .64;
					}
				} else {
					appliedVector = scrollVector;
				}
				if (scrollSize != 0)
				{
					_scrollPosition += (appliedVector / scrollSize);
				}
				if ((_scrollPosition < (previousScrollPosition + Momentum.TRESHOLD)) && (_scrollPosition > (previousScrollPosition - Momentum.TRESHOLD)) && (Math.abs(appliedVector / scrollSize) < Momentum.TRESHOLD)) {
					_mouseOriginIndicator.visible = false;
					_composer.addEventListener(MouseEvent.MOUSE_MOVE, handleRestartScroll);
				} else {
					_composer.scrollTo(_scrollPosition);
					previousScrollPosition = _scrollPosition;
				}


				if (maxMouse) {
					indicatorBoundaries = [];
					indicatorBoundaries.push(mousePosition);
					indicatorBoundaries.push(mouseOrigin);
					indicatorBoundaries.sort(Array.NUMERIC);

					if (orientation == HORIZONTAL) {
						_mouseOriginIndicator.x = indicatorBoundaries[0];
						_mouseOriginIndicator.width = indicatorBoundaries[1] - indicatorBoundaries[0];
					}
					if (orientation == VERTICAL) {
						_mouseOriginIndicator.y = indicatorBoundaries[0];
						_mouseOriginIndicator.height = indicatorBoundaries[1] - indicatorBoundaries[0];
					}                               

					if (mouseOrigin != mouseCenter) {
						if ((Math.abs(mouseCenter - mousePosition) > Math.abs(mouseCenter - mouseOrigin)) || (Math.abs(mousePosition - mouseOrigin) > Math.abs(mouseCenter - mouseOrigin))) {
							if ((mouseCenter - mouseOrigin) > 0) {
								mouseOrigin += mouseAlignVelocity;
							} else {
								mouseOrigin -= mouseAlignVelocity;
							}
							if (Math.abs(mouseCenter - mouseOrigin) <= mouseAlignVelocity) {
								mouseOrigin = mouseCenter;
							}

						}
					}
				}
			}
		}	
		
		private function handleRestartScroll(event:MouseEvent):void {
			_mouseOriginIndicator.visible = _scrollIndicator;
			_composer.removeEventListener(MouseEvent.MOUSE_MOVE, handleRestartScroll);
		}
		
		private function initialize():void {
			scrollRatio = StyleSheet.getScrollRatio(_scrollStyle);
			scrollMargin = StyleSheet.getScrollMargin(_scrollStyle);
			indicatorSize = StyleSheet.getScrollSize(_scrollStyle);
			scrollVelocityMax = StyleSheet.getScrollVelocityMax(_scrollStyle);
			mouseAlignVelocity = StyleSheet.getScrollMouseAlignVelocity(_scrollStyle);
			_scrollIndicator = StyleSheet.getScrollIndicatorShown(_scrollStyle);
			_clickPause = StyleSheet.getScrollClickPause(_scrollStyle);
			_mouseOriginIndicator = new Composer();
			if (Composition.getTemplate(StyleSheet.getScrollOriginIndicator(_scrollStyle)))
			{
				_mouseOriginIndicator.itemData = Composition.getTemplate(StyleSheet.getScrollOriginIndicator(_scrollStyle)).copy();
			} else {
				_mouseOriginIndicator.itemData = ORIGIN_INDICATOR_COMPOSITION.copy();                                                                     
			}   
//			_mouseOriginIndicator.fill = StyleSheet.getScrollOriginIndicator(_scrollStyle);
			addChild(AComposable(_mouseOriginIndicator));
			Composition.applyProperties(AComposable(_mouseOriginIndicator));		
			_mouseOriginIndicator.visible = false;

			_scrollIndicatorBox = new Composer();
			if (Composition.getTemplate(StyleSheet.getScrollIndicator(_scrollStyle)))
			{
				_scrollIndicatorBox.itemData = Composition.getTemplate(StyleSheet.getScrollIndicator(_scrollStyle)).copy();
			} else {
				_scrollIndicatorBox.itemData = INDICATOR_COMPOSITION.copy();
			}   
//			_scrollIndicatorBox.fill = StyleSheet.getScrollIndicator(_scrollStyle);
			addChild(AComposable(_scrollIndicatorBox));
			Composition.applyProperties(AComposable(_scrollIndicatorBox));		
			_composer.addEventListener(MouseEvent.ROLL_OVER, handleRollOver);
			_composer.addEventListener(MouseEvent.ROLL_OUT, handleRollOut);
			if (_clickPause) {
				_composer.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
				_composer.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			}
			_scrollIndicatorBox.visible = false;
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
		import flash.external.ExternalInterface;

/**
*		@inheritDoc
*/                           
		override public function startScroll():void {   
			super.startScroll();
			if (((_composer.contentArea.width > _composer._width) && ((orientation == HORIZONTAL))) || ((_composer.contentArea.height > _composer._height) && ((orientation == VERTICAL)))) {
				if (orientation == HORIZONTAL) {
					mouseOrigin = mouseX;
					maxMouse = int(_composer._width);
					scrollSize = _composer.contentArea.width - _composer._width;
				}
				if (orientation == VERTICAL) {
					mouseOrigin = mouseY;
					maxMouse = int(_composer._height);
					scrollSize = _composer.contentArea.height - _composer._height;
				}                              
				mouseCenter = maxMouse / 2; 
				_mouseOriginIndicator.visible = _scrollIndicator;
				_scrollIndicatorBox.visible = _scrollIndicator;

				mouseOrigin = Math.min(Math.max(mouseOrigin, scrollMargin), (maxMouse - scrollMargin));        

				if (orientation == HORIZONTAL) {
					_mouseOriginIndicator.width = 2;
					_mouseOriginIndicator.height = indicatorSize;
					_mouseOriginIndicator.x = int(mouseOrigin - (_mouseOriginIndicator.width / 2));
					_mouseOriginIndicator.y = int(_composer._height - indicatorSize);

					_scrollIndicatorBox.width = (_composer._width / _composer.contentArea.width) * _composer._width;
					_scrollIndicatorBox.height = indicatorSize;
					_scrollIndicatorBox.y = int(_composer._height - indicatorSize);
				}
				if (orientation == VERTICAL) {
					_mouseOriginIndicator.height = 2;
					_mouseOriginIndicator.width = indicatorSize;
					_mouseOriginIndicator.x = int(_composer._width - indicatorSize);
					_mouseOriginIndicator.y = int(mouseOrigin - (_mouseOriginIndicator.height / 2));

					_scrollIndicatorBox.height = (_composer._height / _composer.contentArea.height) * _composer._height;
					_scrollIndicatorBox.width = indicatorSize;
					_scrollIndicatorBox.x = int(_composer._width - indicatorSize);
				}                               

				root.addEventListener(Event.ENTER_FRAME, handleScroll);
			}
		}

/**
*		@inheritDoc
*/
		override public function stopScroll():void {
			super.stopScroll();
			if (root.hasEventListener(Event.ENTER_FRAME)) {
				root.removeEventListener(Event.ENTER_FRAME, handleScroll);
			}                  
			if (_mouseOriginIndicator) {
				_mouseOriginIndicator.visible = false;
			}
			if (_scrollIndicatorBox) {
				_scrollIndicatorBox.visible = false;
			}
		}
	}
}