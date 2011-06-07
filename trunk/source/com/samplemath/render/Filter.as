package com.samplemath.render {
	
	import com.samplemath.composition.StyleSheet;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GradientGlowFilter;
	import flash.geom.ColorTransform;



/**
*	Static utility class supporting rendering filter styles defined in SMXML. 
*	<p>Please read about styles in SMXML to learn more on how to apply filter styles on UI elements.</p>
*
*	@see com.samplemath.composition.Composition
*	@see com.samplemath.composition.StyleSheet
*/
	public class Filter {    
		
        private static const BLUR:String = "blur";
        private static const DROPSHADOW:String = "dropshadow";
        private static const FILTERS:String = "filters";
        private static const GLOW:String = "glow";
        private static const GRADIENTGLOW:String = "gradientglow";
		   

/**
*		This is a static utility class with no purpose to be instantiated.
*/
		public function Filter() {
		}
		
		
/**
*		@private
*/
		public static function addBlur(filteredDisplayObject:DisplayObject, blurX:Number = 5, blurY:Number = 5, quality:Number = 3):void {
			var blur:BlurFilter = new BlurFilter(blurX, blurY, quality);
			if (filteredDisplayObject) {
				var filtersArray:Array = filteredDisplayObject.filters;
				filtersArray.push(blur);
				if (filteredDisplayObject.hasOwnProperty(FILTERS)) {
					filteredDisplayObject.filters = filtersArray;				
				}
			}
		}

/**
*		@private
*/
		public static function addColorMatrix(filteredDisplayObject:DisplayObject, color:Number, alpha:Number):void {
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = color;
			var matrix:Array = new Array();
            matrix = matrix.concat([colorTransform.redMultiplier, 0, 0, 0, colorTransform.redOffset]); // red
            matrix = matrix.concat([0, colorTransform.greenMultiplier, 0, 0, colorTransform.greenOffset]); // green
            matrix = matrix.concat([0, 0, colorTransform.blueMultiplier, 0, colorTransform.blueOffset]); // blue
            matrix = matrix.concat([0, 0, 0, alpha, 0]); // alpha

		   
			var colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			if (filteredDisplayObject) {
				var filtersArray:Array = filteredDisplayObject.filters;
				filtersArray.push(colorMatrixFilter);
				if (filteredDisplayObject.hasOwnProperty(FILTERS)) {
					filteredDisplayObject.filters = filtersArray;				
				}
			}
		}

/**
*		@private
*/
		public static function addDropShadow(filteredDisplayObject:DisplayObject, distance:Number = 4, angle:Number = 45, color:Number = 0xff0000,  alpha:Number = 1, blurX:Number = 5, blurY:Number = 5, strength:Number = 2, inner:Boolean = false, knockout:Boolean = false):void {
			var dropShadow:DropShadowFilter = new DropShadowFilter(distance, angle, color, alpha, blurX, blurY, strength, 3, inner, false, knockout);
			var filtersArray:Array = filteredDisplayObject.filters;
			filtersArray.push(dropShadow);
			if (filteredDisplayObject) {
				if (filteredDisplayObject.hasOwnProperty(FILTERS)) {
					filteredDisplayObject.filters = filtersArray;				
				}
			}
		}

/**
*		@private
*/
		public static function addGlow(filteredDisplayObject:DisplayObject, color:Number = 0xff0000,  strength:Number = 2, knockout:Boolean = false, blurX:Number = 7, blurY:Number = 4, distance:Number = 0):void {
			var glow:GradientGlowFilter = new GradientGlowFilter(distance, 45, [color, color, color], [0, .5, 1], [0, 192, 255], blurX, blurX, strength, 3, "outer", knockout);
			var filtersArray:Array = filteredDisplayObject.filters;
			filtersArray.push(glow);
			if (filteredDisplayObject) {
				if (filteredDisplayObject.hasOwnProperty(FILTERS)) {
					filteredDisplayObject.filters = filtersArray;				
				}
			}
		}

/**
*		@private
*/
		public static function addGradientGlow(filteredDisplayObject:DisplayObject, colors:Array, alphas:Array, ratios:Array, strength:Number = 2, knockout:Boolean = false, blurX:Number = 7, blurY:Number = 4, distance:Number = 0):void {
			var glow:GradientGlowFilter = new GradientGlowFilter(distance, 45, colors, alphas, ratios, blurX, blurX, strength, 3, "outer", knockout);
			var filtersArray:Array = filteredDisplayObject.filters;
			filtersArray.push(glow);
			if (filteredDisplayObject) {
				if (filteredDisplayObject.hasOwnProperty(FILTERS)) {
					filteredDisplayObject.filters = filtersArray;				
				}
			}
		}

/**
*		@private
*/
		public static function applyFilter(filteredDisplayObject:DisplayObject, filterData:XML):void {
			switch (filterData.@type.toString()) {
				case BLUR:
					var blurBlurX:Number = filterData.blurx.length() ? Number(filterData.blurx.text()) : 5;
					var blurBlurY:Number = filterData.blury.length() ? Number(filterData.blury.text()) : 5;
					var quality:Number = filterData.quality.length() ? Number(filterData.quality.text()) : 3;
					addBlur(filteredDisplayObject, blurBlurX, blurBlurY, quality);
					break;
				case DROPSHADOW:
					var distance:Number = filterData.distance.length() ? Number(filterData.distance.text()) : 4;
					var angle:Number = filterData.angle.length() ? Number(filterData.angle.text()) : 45;
					var color:Number = filterData.color.length() ? Number(filterData.color.text()) : 0xff0000;
					var alpha:Number = filterData.color.@alpha.length() ? Number(filterData.color.@alpha.toString()) : 1;
					var blurX:Number = filterData.blurx.length() ? Number(filterData.blurx.text()) : 5;
					var blurY:Number = filterData.blury.length() ? Number(filterData.blury.text()) : 5;
					var strength:Number = filterData.strength.length() ? Number(filterData.strength.text()) : 2;
					addDropShadow(filteredDisplayObject, distance, angle, color, alpha, blurX, blurY, strength);
					break;
				case GLOW:
					var glowDistance:Number = filterData.distance.length() ? Number(filterData.distance.text()) : 4;
					var glowColor:Number = filterData.color.length() ? Number(filterData.color.text()) : 0xff0000;
					var glowBlurX:Number = filterData.blurx.length() ? Number(filterData.blurx.text()) : 5;
					var glowBlurY:Number = filterData.blury.length() ? Number(filterData.blury.text()) : 5;
					var glowKnockout:Boolean = filterData.knockout.length() ? (Number(filterData.knockout.text()) || filterData.knockout.text() == "true") : false;
					var glowStrength:Number = filterData.strength.length() ? Number(filterData.strength.text()) : 2;
					addGlow(filteredDisplayObject, glowColor, glowStrength, glowKnockout, glowBlurX, glowBlurY, glowDistance);
					break;   
				case GRADIENTGLOW:
					var gradientGlowDistance:Number = filterData.distance.length() ? Number(filterData.distance.text()) : 4;
					var gradientGlowColor:Number = filterData.color.length() ? Number(filterData.color.text()) : 0xff0000;
					var gradientGlowBlurX:Number = filterData.blurx.length() ? Number(filterData.blurx.text()) : 5;
					var gradientGlowBlurY:Number = filterData.blury.length() ? Number(filterData.blury.text()) : 5;
					var gradientGlowKnockout:Boolean = filterData.knockout.length() ? (Number(filterData.knockout.text()) || filterData.knockout.text() == "true") : false;
					var gradientGlowStrength:Number = filterData.strength.length() ? Number(filterData.strength.text()) : 2;
					addGradientGlow(filteredDisplayObject, StyleSheet.getGradientProperties(filterData, "color"), StyleSheet.getGradientProperties(filterData, "alpha"), StyleSheet.getGradientProperties(filterData, "ratio"), gradientGlowStrength, gradientGlowKnockout, gradientGlowBlurX, gradientGlowBlurY, gradientGlowDistance);
					break;               
					
			}
		}

/**
*		@private
*/
		public static function applyFilters(filteredDisplayObject:DisplayObject, filterData:XML):void {
			for each(var filterData:XML in filterData.elements()) {
				applyFilter(filteredDisplayObject, filterData);
			}
		}

/**
*		@private
*/
		public static function killFilters(filteredDisplayObject:DisplayObject):void {
			var filtersArray:Array = new Array();
			if (filteredDisplayObject) {
				if (filteredDisplayObject.hasOwnProperty(FILTERS)) {
					filteredDisplayObject.filters = filtersArray;				
				}
			}
		}

/**
*		@private
*/
		public static function setBlur(filteredDisplayObject:DisplayObject, blurX:Number = 5, blurY:Number = 5, quality:Number = 3):void {
			var blur:BlurFilter = new BlurFilter(blurX, blurY, quality);
			var filtersArray:Array = [];
			filtersArray.push(blur);
			if (filteredDisplayObject) {
				if (filteredDisplayObject.hasOwnProperty(FILTERS)) {
					filteredDisplayObject.filters = filtersArray;				
				}
			}
		}

/**
*		@private
*/
		public static function setColorMatrix(filteredDisplayObject:DisplayObject, color:Number, alpha:Number):void {
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = color;
			var matrix:Array = new Array();
            matrix = matrix.concat([colorTransform.redMultiplier, 0, 0, 0, colorTransform.redOffset]); // red
            matrix = matrix.concat([0, colorTransform.greenMultiplier, 0, 0, colorTransform.greenOffset]); // green
            matrix = matrix.concat([0, 0, colorTransform.blueMultiplier, 0, colorTransform.blueOffset]); // blue
            matrix = matrix.concat([0, 0, 0, alpha, 0]); // alpha

		   
			var colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			var filtersArray:Array = [];
			filtersArray.push(colorMatrixFilter);
			if (filteredDisplayObject) {
				if (filteredDisplayObject.hasOwnProperty(FILTERS)) {
					filteredDisplayObject.filters = filtersArray;				
				}
			}
		}

/**
*		@private
*/
		public static function setDropShadow(filteredDisplayObject:DisplayObject, distance:Number = 4, angle:Number = 45, color:Number = 0xff0000,  alpha:Number = 1, blurX:Number = 5, blurY:Number = 5, strength:Number = 2, inner:Boolean = false, knockout:Boolean = false):void {
			var dropShadow:DropShadowFilter = new DropShadowFilter(distance, angle, color, alpha, blurX, blurY, strength, 3, inner, false, knockout);
			var filtersArray:Array = [];
			filtersArray.push(dropShadow);
			if (filteredDisplayObject) {
				if (filteredDisplayObject.hasOwnProperty(FILTERS)) {
					filteredDisplayObject.filters = filtersArray;				
				}
			}
		}

/**
*		@private
*/
		public static function setGlow(filteredDisplayObject:DisplayObject, color:Number = 0xff0000,  strength:Number = 2, knockout:Boolean = false, blurX:Number = 7, blurY:Number = 4, distance:Number = 0):void {
			var glow:GradientGlowFilter = new GradientGlowFilter(distance, 45, [color, color, color], [0, .5, 1], [0, 192, 255], blurX, blurX, strength, 3, "outer", knockout);
			var filtersArray:Array = [];
			filtersArray.push(glow);
			if (filteredDisplayObject) {
				if (filteredDisplayObject.hasOwnProperty(FILTERS)) {
					filteredDisplayObject.filters = filtersArray;				
				}
			}
		}
	}
}