package com.samplemath.shape {
	
	import com.samplemath.composition.Registry;
	import com.samplemath.composition.StyleSheet;
	import com.samplemath.interaction.AInteractive;

	import flash.display.GradientType;
	import flash.display.Graphics;            
	import flash.display.InterpolationMethod;            
	import flash.display.SpreadMethod;            
	import flash.display.Sprite;           
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	

/**
*	Concrete UI element for rendering a rectangle or related shape.
*	<p><code>Box</code> can be used to draw rectangles, text backgrounds or
*	even speech bubble backgrounds using any stroke, fill or filter style defined in SMXML.
*	Read about defining and applying styles in SMXML to learn more about drawing <code>Box</code>es.</p>
*	                                         
*	@see http://samplemath.com/smaf/doc/wikka.php?wakka=UsingBox
*
*	@see com.samplemath.composition.AComposable
*	@see com.samplemath.composition.StyleSheet
*/
	public class Box extends AInteractive {
		
		private var boxBackground:Sprite;
		private var boxFrame:Sprite;
		private var invisibleButton:Sprite;
		
		private var _itemHeight:Number = 2;
		private var _itemWidth:Number = 2;

/**
*		Static constant value for bubble side and orientation.
*/
		public static const BOTTOM:String = "bottom";
/**
*		Static constant value for bubble side and orientation.
*/
		public static const CENTER:String = "center";
/**
*		Static constant value for bubble side and orientation.
*/
		public static const LEFT:String = "left";
/**
*		Static constant value for bubble side and orientation.
*/
		public static const RIGHT:String = "right";
/**
*		Static constant value for bubble side and orientation.
*/
		public static const TOP:String = "top";     
		
		private const EMPTY_STRING:String = "";
		private const SOLID:String = "solid";

	
		
			
/**
*		Instantiates Box.
*/
		public function Box() {	 
			_itemData = <box/>;
			super();
		}
		

		
		                                      
/**
*		@private
*/
		public function adjustBox():void {   
			drawBox();
		}             
		
/**
*		[SMXML] The size of bubble stem in pixels.
*/
		public function get bubble():Number {
			var value:Number = 0;
			if (_itemData) {
				if (_itemData.@bubble.length()) {
					value = Number(_itemData.@bubble.toString());
				}
			}
			return value;
		}

/**
*		[SMXML] The size of bubble stem in pixels.
*/
		public function set bubble(value:Number):void {
			if (_itemData) {
				_itemData.@bubble = value;
				adjustBox();
			}
		}

/**
*		[SMXML] The alignment of bubble stem on side of the box.
*/
		public function get bubbleorientation():String {
			var value:String = Box.CENTER;
			if (_itemData) {
				if (_itemData.@bubbleorientation.length()) {
					value = _itemData.@bubbleorientation.toString();
				}
			}
			return value;
		}

/**
*		[SMXML] The alignment of bubble stem on side of the box.
*/
		public function set bubbleorientation(value:String):void {
			if (_itemData) {
				_itemData.@bubbleorientation = value;
				adjustBox();
			}
		}

/**
*		[SMXML] The side to draw bubble stem on.
*/
		public function get bubbleside():String {
			var value:String = Box.CENTER;
			if (_itemData) {
				if (_itemData.@bubbleside.length()) {
					value = _itemData.@bubbleside.toString();
				}
			}
			return value;
		}

/**
*		[SMXML] The side to draw bubble stem on.
*/
		public function set bubbleside(value:String):void {
			if (_itemData) {
				_itemData.@bubbleside = value;
				adjustBox();
			}
		}

/**
*		@inheritDoc
*/
		override public function disable():void {
			super.disable();
			if (boxBackground) {
				boxBackground.mouseEnabled = false;
				boxBackground.buttonMode = false;
			}
		}
		
		private function drawBox():void {
			var bubbleSize:int = 0;
			if (_itemData.@bubble.length()) {
				if (int(_itemData.@bubble.toString())) {
					bubbleSize = int(_itemData.@bubble.toString());
				}
			}
			var rounded:int = 0;
			if (_itemData.@rounded.length()) {
				rounded = int(_itemData.@rounded.toString());
			}
			if (boxBackground) {
				boxBackground.graphics.clear();
			} else {
				boxBackground = new Sprite();
				addChild(boxBackground);	
			}                                                       
			var fillStyle:String = (_itemData.@fill.length()) ? _itemData.@fill.toString() : EMPTY_STRING;
			switch(StyleSheet.getFillStyle(fillStyle).@type.toString()) {
				case SOLID: 
					boxBackground.graphics.beginFill(StyleSheet.getFillColor(fillStyle), StyleSheet.getFillAlpha(fillStyle));
					break;
				case GradientType.LINEAR:                                                        
					var linearMatrix:Matrix = new Matrix();
			     	linearMatrix.createGradientBox(_itemWidth, _itemHeight, StyleSheet.getGradientFillAngle(fillStyle) * (Math.PI / 180));
					boxBackground.graphics.beginGradientFill(GradientType.LINEAR, StyleSheet.getGradientFillColors(fillStyle), StyleSheet.getGradientFillAlphas(fillStyle), StyleSheet.getGradientFillRatios(fillStyle), linearMatrix, SpreadMethod.PAD, InterpolationMethod.RGB, StyleSheet.getGradientFillFocalPointRatio(fillStyle));
					break;
				case GradientType.RADIAL:                                                        
					var radialMatrix:Matrix = new Matrix();
			     	radialMatrix.createGradientBox(_itemWidth * 2, _itemHeight * 2, 0, - _itemWidth / 2, - _itemHeight / 2);
					boxBackground.graphics.beginGradientFill(GradientType.RADIAL, StyleSheet.getGradientFillColors(fillStyle), StyleSheet.getGradientFillAlphas(fillStyle), StyleSheet.getGradientFillRatios(fillStyle), radialMatrix, SpreadMethod.PAD, InterpolationMethod.RGB, StyleSheet.getGradientFillFocalPointRatio(fillStyle));
					break;
			}
			if (bubbleSize) {
				drawBubble(boxBackground.graphics, bubbleSize);
			} else {
				if (rounded) {
					boxBackground.graphics.drawRoundRect(0, 0, _itemWidth, _itemHeight, rounded, rounded);
				} else {
					boxBackground.graphics.drawRect(0, 0, _itemWidth, _itemHeight);
				}
			}
			boxBackground.graphics.endFill();
			if (_itemData.@stroke.length()) {
				drawStroke(_itemData.@stroke.toString(), rounded, bubbleSize);
			}
		}
		
		private function drawBubble(targetGraphics:Graphics, bubbleSize:int = 12):void {
			var rounded:int = _itemData.@rounded.length() ? int(Number(_itemData.@rounded.toString()) / 2) : 0;
			var side:String = _itemData.@bubbleside.length() ? _itemData.@bubbleside.toString() : LEFT;
			var orientation:String = _itemData.@bubbleorientation.length() ? _itemData.@bubbleorientation.toString() : TOP;
			targetGraphics.moveTo(rounded, 0);
			if (side == TOP) {
				if (orientation == LEFT) {
					targetGraphics.lineTo((rounded + int(bubbleSize * .2)), 0);
					targetGraphics.lineTo((rounded + int(bubbleSize * .7)), - int(bubbleSize * .5));
					targetGraphics.lineTo((rounded + int(bubbleSize * 1.2)), 0);
					targetGraphics.lineTo(_itemWidth - rounded, 0);
				} else if (orientation == Box.CENTER) {
					targetGraphics.lineTo(int((_itemWidth / 2) - (bubbleSize * .5)), 0);
					targetGraphics.lineTo(int((_itemWidth / 2)), - int(bubbleSize * .5));
					targetGraphics.lineTo(int((_itemWidth / 2) + (bubbleSize * .5)), 0);
					targetGraphics.lineTo(_itemWidth - rounded, 0);
				} else {
					targetGraphics.lineTo(_itemWidth - (rounded + int(bubbleSize * 1.2)), 0);
					targetGraphics.lineTo(_itemWidth - (rounded + int(bubbleSize * .7)), - int(bubbleSize * .5));
					targetGraphics.lineTo(_itemWidth - (rounded + int(bubbleSize * .2)), 0);
					targetGraphics.lineTo(_itemWidth - rounded, 0);
				}
			} else {
				targetGraphics.lineTo(_itemWidth - rounded, 0);
			}
			targetGraphics.curveTo(_itemWidth, 0, _itemWidth, rounded);
			if (side == RIGHT) {
				if (orientation == TOP) {
					targetGraphics.lineTo(_itemWidth, rounded + int(bubbleSize * .2));
					targetGraphics.lineTo(_itemWidth + int(bubbleSize * .5), rounded + int(bubbleSize * .7));
					targetGraphics.lineTo(_itemWidth, rounded + int(bubbleSize * 1.2));
					targetGraphics.lineTo(_itemWidth, _itemHeight - rounded);
				} else if (orientation == Box.CENTER) {
					targetGraphics.lineTo(_itemWidth, int((_itemHeight / 2) - (bubbleSize * .5)));
					targetGraphics.lineTo(_itemWidth + int(bubbleSize * .5), int(_itemHeight / 2));
					targetGraphics.lineTo(_itemWidth, int((_itemHeight / 2) + (bubbleSize * .5)));
					targetGraphics.lineTo(_itemWidth, _itemHeight - rounded);
				} else {
					targetGraphics.lineTo(_itemWidth, _itemHeight - (rounded + int(bubbleSize * 1.2)));
					targetGraphics.lineTo(_itemWidth + int(bubbleSize * .5), _itemHeight - (rounded + int(bubbleSize * .7)));
					targetGraphics.lineTo(_itemWidth, _itemHeight - (rounded + int(bubbleSize * .2)));
					targetGraphics.lineTo(_itemWidth, _itemHeight - rounded);
				}
			} else {
				targetGraphics.lineTo(_itemWidth, _itemHeight - rounded);
			}
			targetGraphics.curveTo(_itemWidth, _itemHeight, _itemWidth - rounded, _itemHeight);
			if (side == BOTTOM) {
				if (orientation == LEFT) {
					targetGraphics.lineTo(rounded + int(bubbleSize * 1.2), _itemHeight);
					targetGraphics.lineTo(rounded + int(bubbleSize * .7), _itemHeight + int(bubbleSize * .5));
					targetGraphics.lineTo(rounded + int(bubbleSize * .2), _itemHeight);
					targetGraphics.lineTo(rounded, _itemHeight);
				} else if (orientation == Box.CENTER) {
					targetGraphics.lineTo(int((_itemWidth / 2) + (bubbleSize * .5)), _itemHeight);
					targetGraphics.lineTo(int((_itemWidth / 2)), _itemHeight + int(bubbleSize * .5));
					targetGraphics.lineTo(int((_itemWidth / 2) - (bubbleSize * .5)), _itemHeight);
					targetGraphics.lineTo(rounded, _itemHeight);
				} else {
					targetGraphics.lineTo(_itemWidth - (rounded + int(bubbleSize * .2)), _itemHeight);
					targetGraphics.lineTo(_itemWidth - (rounded + int(bubbleSize * .7)), _itemHeight + int(bubbleSize * .5));
					targetGraphics.lineTo(_itemWidth - (rounded + int(bubbleSize * 1.2)), _itemHeight);
					targetGraphics.lineTo(rounded, _itemHeight);
				}
			} else {
				targetGraphics.lineTo(rounded, _itemHeight);
			}
			targetGraphics.curveTo(0, _itemHeight, 0, _itemHeight - rounded);
			if (side == LEFT) {
				if (orientation == TOP) {
					targetGraphics.lineTo(0, rounded + int(bubbleSize * 1.2));
					targetGraphics.lineTo(-int(bubbleSize * .5), rounded + int(bubbleSize * .7));
					targetGraphics.lineTo(0, rounded + int(bubbleSize * .2));
					targetGraphics.lineTo(0, rounded);
				} else if (orientation == Box.CENTER) {
					targetGraphics.lineTo(0, int((_itemHeight / 2) + (bubbleSize * .5)));
					targetGraphics.lineTo(-int(bubbleSize * .5), int(_itemHeight / 2));
					targetGraphics.lineTo(0, int((_itemHeight / 2) - (bubbleSize * .5)));
					targetGraphics.lineTo(0, rounded);
				} else {
					targetGraphics.lineTo(0, _itemHeight - (rounded + int(bubbleSize * .2)));
					targetGraphics.lineTo(-int(bubbleSize * .5), _itemHeight - (rounded + int(bubbleSize * .7)));
					targetGraphics.lineTo(0, _itemHeight - (rounded + int(bubbleSize * 1.2)));
					targetGraphics.lineTo(0, rounded);
				}
			} else {
				targetGraphics.lineTo(0, rounded);
			}
			targetGraphics.curveTo(0, 0, rounded, 0);
		}
		
		private function drawStroke(strokeStyle:String, rounded:int, bubbleSize:int = 0):void {
			if (boxFrame) {
				boxFrame.graphics.clear();
			} else {
				boxFrame = new Sprite();
				addChild(boxFrame);	
			}
			boxFrame.graphics.lineStyle(StyleSheet.getStrokeSize(strokeStyle), StyleSheet.getStrokeColor(strokeStyle), StyleSheet.getStrokeAlpha(strokeStyle), true, "none", null, "bevel");
			if (bubbleSize) {
				drawBubble(boxFrame.graphics, bubbleSize);
			} else {
				if (rounded) {
					boxFrame.graphics.drawRoundRect(0, 0, _itemWidth, _itemHeight, rounded, rounded);
				} else {
					boxFrame.graphics.drawRect(0, 0, _itemWidth, _itemHeight);
				}
			}
		}
		
/**
*		@inheritDoc
*/
		override public function enable():void {
			super.enable();
			if (boxBackground) {
				boxBackground.mouseEnabled = true;
				boxBackground.buttonMode = true;
				boxBackground.tabEnabled = false;
			}
		}

/**
*		[SMXML] The fill style used for the box.
*/
		public function get fill():String {
			var value:String = EMPTY_STRING;
			if (_itemData) {
				if (_itemData.@fill.length()) {
					value = _itemData.@fill.toString();
				}
			}
			return value != EMPTY_STRING ? value : undefined;
		}

/**
*		[SMXML] The fill style used for the box.
*/
		public function set fill(value:String):void {
			if (_itemData) {
				_itemData.@fill = value;
				adjustBox();
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
			adjustBox();
		}

		private function redrawStroke():void {
			var bubbleSize:int = _itemData.@bubble.length() ? int(_itemData.@bubble.toString()) : 0;
			var rounded:int = _itemData.@rounded.length() ? int(_itemData.@rounded.toString()) : 0;
			if (_itemData.@stroke.length()) {
				drawStroke(_itemData.@stroke.toString(), rounded, bubbleSize);
			}
		}               
		
/**
*		Overide this method if you need to extend <code>Box</code>.
*/
		override protected function render():void {                                
			super.render();
			drawBox();
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
				adjustBox();
			}
		}

/**
*		[SMXML] The stroke style used for the box.
*/
		public function get stroke():String {
			var value:String = EMPTY_STRING;
			if (_itemData) {
				if (_itemData.@stroke.length()) {
					value = _itemData.@stroke.toString();
				}
			}
			return value != EMPTY_STRING ? value : undefined;
		}

/**
*		[SMXML] The stroke style used for the box.
*/
		public function set stroke(value:String):void {
			if (_itemData) {
				_itemData.@stroke = value;
				adjustBox();
			}
		}

/**
*		@private
*/
		override public function _setDimensions(widthToSet:Number, heightToSet:Number):void {
			_itemWidth = widthToSet;
			_itemHeight = heightToSet;
			adjustBox();
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
			adjustBox();
		}
	}
}