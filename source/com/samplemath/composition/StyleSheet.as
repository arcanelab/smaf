package com.samplemath.composition {

	import com.samplemath.font.FontManager;
	import flash.text.TextFormatAlign;


/**
*	Static utility class supporting styling UI elements in SMXML markup. 
*
*	@see http://samplemath.com/smaf/doc/wikka.php?wakka=DeclaringAndApplying
*/	
	public class StyleSheet {
	
/**
*		@private
*/
		public static var defaultFillStyle:XML = <fill style="defaultFill" type="solid">
			<color alpha="1">0x000000</color>
		</fill>;    

/**
*		@private
*/
		public static var defaultFilterStyle:XML = <filters style="defaultFilter">
			<filter type="dropshadow">
				<color>0xff0000</color>
			</filter>
		</filters>;       

/**
*		@private
*/
		public static var defaultScrollStyle:XML = <scroll style="defaultScroll" type="momentum" orientation="vertical">
			<size>12</size>
			<scrollmargin>16</scrollmargin>
			<scrollratio>.05</scrollratio>
			<scrollindicator>true</scrollindicator>
			<clickpause>false</clickpause>
			<mousealignvelocity>2</mousealignvelocity>
			<scrollvelocitymax>16</scrollvelocitymax>
		</scroll>;

/**
*		@private
*/
		public static var defaultStrokeStyle:XML = <stroke style="defaultStroke" size="8">
			<color alpha="1">0x888888</color>
		</stroke>;

/**
*		@private
*/
		public static var defaultInputTextformatStyle:XML = <textformat style="defaultInputTextformat">
			<align>left</align>
			<autosize>0</autosize>
			<color>0x000000</color>
			<embedfonts>0</embedfonts>
			<font>_sans</font>
			<leading>0</leading>
			<letterspacing>0</letterspacing>
			<selectable>1</selectable>
			<selectedcolor>0xffffff</selectedcolor>
			<selectioncolor>0xff0000</selectioncolor>
			<size>12</size>
			<wordwrap>0</wordwrap>
		</textformat>;

/**
*		@private
*/
		public static var defaultTextformatStyle:XML = <textformat style="defaultTextFormat">
			<align>left</align>
			<autosize>1</autosize>
			<color>0x000000</color>
			<embedfonts>0</embedfonts>
			<font>_sans</font>
			<leading>0</leading>
			<letterspacing>0</letterspacing>
			<selectable>0</selectable>
			<selectedcolor>0xffffff</selectedcolor>
			<selectioncolor>0xff0000</selectioncolor>
			<size>12</size>
			<wordwrap>0</wordwrap>
		</textformat>;

		private static var styleSheet:Array = [];                  
		
		private static const ALPHA:String = "alpha";
		private static const COLOR:String = "color";
		private static const COMMA:String = ",";
		private static const DEFAULT_TEXT_FORMAT:String = "defaultInputTextformat";
		private static const EMPTY_STRING:String = "";
		private static const HEX_PREFIX:String = "0x";                        
		private static const MOMENTUM:String = "momentum";
		private static const ONE:String = "1";
		private static const PERCENT:String = "%";
		private static const RATIO:String = "ratio";
		private static const RGB_PREFIX:String = "rgb(";                        
		private static const SPACE:String = " ";                        
		private static const RGB_SUFFIX:String = ")";
		private static const TRUE:String = "true";
		private static const VERTICAL:String = "vertical";       

/**
*		Static utility and style dictionary, not meant to be instantiated.
*/
		public function StyleSheet() {
		}
		
		
		      
		
/**
*		@private
*/
		public static function checkForRGB(colorValue:String):String {
			colorValue = colorValue.split(SPACE).join(EMPTY_STRING);
			if (colorValue.substr(0, RGB_PREFIX.length) == RGB_PREFIX)
			{
				colorValue = colorValue.split(RGB_PREFIX).join(EMPTY_STRING);
				colorValue = colorValue.split(RGB_SUFFIX).join(EMPTY_STRING);
				var rgbValues:Array = colorValue.split(COMMA);
				colorValue = HEX_PREFIX + Number(rgbValues[0]).toString(16) + Number(rgbValues[1]).toString(16) + Number(rgbValues[2]).toString(16);
			}
			return colorValue;
		}          

/**
*		@private
*/
		public static function get(styleID:String):XML {
			var reference:XML = null;
			if (styleSheet[styleID]) {
				reference = styleSheet[styleID];
			}
			return reference;
		}          

/**
*		@private
*/
		public static function getFillAlpha(styleID:String):Number {
			var fillStyle:XML = getFillStyle(styleID);
			return fillStyle.color.@alpha.length() ? Number(fillStyle.color.@alpha.toString()) : 1;
		}

/**
*		@private
*/
		public static function getFillColor(styleID:String):Number {
			var fillStyle:XML = getFillStyle(styleID);
			return Number(checkForRGB(fillStyle.color.text()));
		}
		
/**
*		@private
*/
		public static function getFillStyle(styleID:String):XML {
			return get(styleID) ? get(styleID) : defaultFillStyle;
		}                                        
		
/**
*		@private
*/
		public static function getFilterStyle(styleID:String):XML {
			return get(styleID) ? get(styleID) : defaultFilterStyle;
		}                                        

/**
*		@private
*/
		public static function getGradientFillAlphas(styleID:String):Array {
			var fillStyle:XML = getFillStyle(styleID);
			return getGradientProperties(fillStyle, ALPHA);
		}  

/**
*		@private
*/
		public static function getGradientFillAngle(styleID:String):Number {
			var fillStyle:XML = getFillStyle(styleID);
			return fillStyle.@angle.length() ? Number(fillStyle.@angle.toString()) : 0;
		}                    

/**
*		@private
*/
		public static function getGradientFillColors(styleID:String):Array {
			var fillStyle:XML = getFillStyle(styleID);
			return getGradientProperties(fillStyle, COLOR);
		}                              

/**
*		@private
*/
		public static function getGradientFillFocalPointRatio(styleID:String):Number {
			var fillStyle:XML = getFillStyle(styleID);
			return fillStyle.@focalpointratio.length() ? Number(fillStyle.@focalpointratio.toString()) : 0;
		}                    

/**
*		@private
*/
		public static function getGradientFillRatios(styleID:String):Array {
			var fillStyle:XML = getFillStyle(styleID);
			return getGradientProperties(fillStyle, RATIO);
		}

/**
*		@private
*/
		public static function getGradientProperties(gradientNode:XML, propertyName:String):Array {
			var properties:Array = [];
			for each(var colorNode:XML in gradientNode.color) {               
				var propertyValue:Number = 0;
				if (propertyName == COLOR) {
					propertyValue = Number(colorNode.text());
				} else {
					var propertyValueString:String = EMPTY_STRING;
					propertyValueString = colorNode.attribute(propertyName).length() ? colorNode.attribute(propertyName).toString() : ONE;
					propertyValue = Number(propertyValueString);
					if (propertyName == RATIO) {
						if (propertyValueString.substr(-1, 1) == PERCENT)
						{
							propertyValue = (Number(propertyValueString.split(PERCENT)[0]) / 100) * 255;
						}
					}
				}
				properties.push(propertyValue);
			}
			return properties;
		}

/**
*		@private
*/
		public static function getScrollBarBackground(styleID:String):String {
			var scrollStyle:XML = getScrollStyle(styleID);
			return scrollStyle.scrollbarbackground.length() ? scrollStyle.scrollbarbackground.text() : EMPTY_STRING;
		}

/**
*		@private
*/
		public static function getScrollBarBackgroundOver(styleID:String):String {
			var scrollStyle:XML = getScrollStyle(styleID);
			return scrollStyle.scrollbarbackgroundover.length() ? scrollStyle.scrollbarbackgroundover.text() : EMPTY_STRING;
		}

/**
*		@private
*/
		public static function getScrollClickPause(styleID:String):Boolean {
			var scrollStyle:XML = getScrollStyle(styleID);
			return scrollStyle.clickpause.length() ? ((scrollStyle.clickpause.text() == TRUE) || Number(scrollStyle.clickpause.text())) : false;
		}

/**
*		@private
*/
		public static function getScrollIndicatorShown(styleID:String):Boolean {
			var scrollStyle:XML = getScrollStyle(styleID);
			return scrollStyle.scrollindicatorshown.length() ? ((scrollStyle.scrollindicatorshown.text() == TRUE) || Number(scrollStyle.scrollindicatorshown.text())) : true;
		}

/**
*		@private
*/
		public static function getScrollIndicator(styleID:String):String {
			var scrollStyle:XML = getScrollStyle(styleID);
			return scrollStyle.scrollindicator.length() ? scrollStyle.scrollindicator.text() : EMPTY_STRING;
		}

/**
*		@private
*/
		public static function getScrollIndicatorOver(styleID:String):String {
			var scrollStyle:XML = getScrollStyle(styleID);
			return scrollStyle.scrollindicatorover.length() ? scrollStyle.scrollindicatorover.text() : EMPTY_STRING;
		}

/**
*		@private
*/
		public static function getScrollMargin(styleID:String):Number {
			var scrollStyle:XML = getScrollStyle(styleID);
			return scrollStyle.scrollmargin.length() ? Number(scrollStyle.scrollmargin.text()) : 0;
		}

/**
*		@private
*/
		public static function getScrollMouseAlignVelocity(styleID:String):Number {
			var scrollStyle:XML = getScrollStyle(styleID);
			return scrollStyle.mousealignvelocity.length() ? Number(scrollStyle.mousealignvelocity.text()) : 0;
		}

/**
*		@private
*/
		public static function getScrollOrientation(styleID:String):String {
			var scrollStyle:XML = getScrollStyle(styleID);
			return scrollStyle.@orientation.length() ? scrollStyle.@orientation.toString() : VERTICAL;
		}

/**
*		@private
*/
		public static function getScrollOriginIndicator(styleID:String):String {
			var scrollStyle:XML = getScrollStyle(styleID);
			return scrollStyle.scrolloriginindicator.length() ? scrollStyle.scrolloriginindicator.text() : EMPTY_STRING;
		}                          
		
/**
*		@private
*/
		public static function getScrollPersistent(styleID:String):Boolean {
			var scrollStyle:XML = getScrollStyle(styleID);
			return scrollStyle.persistent.length() ? ((scrollStyle.persistent.text() == TRUE) || Number(scrollStyle.persistent.text())) : false;
		}

/**
*		@private
*/
		public static function getScrollRatio(styleID:String):Number {
			var scrollStyle:XML = getScrollStyle(styleID);
			return scrollStyle.scrollratio.length() ? Number(scrollStyle.scrollratio.text()) : .05;
		}

/**
*		@private
*/
		public static function getScrollSize(styleID:String):Number {
			var scrollStyle:XML = getScrollStyle(styleID);
			return scrollStyle.size.length() ? Number(scrollStyle.size.text()) : 12;
		}
		
/**
*		@private
*/
		public static function getScrollStyle(styleID:String):XML {
			return get(styleID) ? get(styleID) : defaultScrollStyle;
		}                                        

/**
*		@private
*/
		public static function getScrollType(styleID:String):String {
			var scrollStyle:XML = getScrollStyle(styleID);
			return scrollStyle.@type.length() ? scrollStyle.@type.toString() : MOMENTUM;
		}

/**
*		@private
*/
		public static function getScrollVelocityMax(styleID:String):Number {
			var scrollStyle:XML = getScrollStyle(styleID);
			return scrollStyle.scrollvelocitymax.length() ? Number(scrollStyle.scrollvelocitymax.text()) : 16;
		}

/**
*		@private
*/
		public static function getScrollWheelSpeed(styleID:String):Number {
			var scrollStyle:XML = getScrollStyle(styleID);
			return scrollStyle.wheelspeed.length() ? Number(scrollStyle.wheelspeed.text()) : .4;
		}

/**
*		@private
*/
		public static function getStrokeAlpha(styleID:String):Number {
			var strokeStyle:XML = getStrokeStyle(styleID);
			return strokeStyle.color.@alpha.length() ? Number(strokeStyle.color.@alpha.toString()) : 1;
		}
		
/**
*		@private
*/
		public static function getStrokeColor(styleID:String):Number {
			var strokeStyle:XML = getStrokeStyle(styleID);
			return strokeStyle.color.length() ? Number(checkForRGB(strokeStyle.color.text())) : 0x888888;
		}

/**
*		@private
*/
		public static function getStrokeSize(styleID:String):Number {
			var strokeStyle:XML = getStrokeStyle(styleID);
			return strokeStyle.@size.length() ? Number(strokeStyle.@size.toString()) : 8;
		}
		
/**
*		@private
*/
		public static function getStrokeStyle(styleID:String):XML {
			return get(styleID) ? get(styleID) : defaultStrokeStyle;
		}
		


/**
*		@private
*/
		public static function getTextformatAlign(styleID:String):String {
			var textFormatStyle:XML = getTextformatStyle(styleID);
			return textFormatStyle.align.length() ? textFormatStyle.align.text() : TextFormatAlign.LEFT;
		}
                             
/**
*		@private
*/
		public static function getTextformatAutosize(styleID:String):Boolean {
			var textFormatStyle:XML = getTextformatStyle(styleID);
			return textFormatStyle.autosize.length() ? ((textFormatStyle.autosize.text() == TRUE) || Number(textFormatStyle.autosize.text())) : true;
		}

/**
*		@private
*/
		public static function getTextformatColor(styleID:String):Number {
			var textFormatStyle:XML = getTextformatStyle(styleID);
			return textFormatStyle.color.length() ? Number(checkForRGB(textFormatStyle.color.text())) : 0x000000;
		}                    
		
/**
*		@private
*/
		public static function getTextformatEmbedfonts(styleID:String):Boolean {
			var textFormatStyle:XML = getTextformatStyle(styleID);
			return textFormatStyle.embedfonts.length() ? ((textFormatStyle.embedfonts.text() == TRUE) || Number(textFormatStyle.embedfonts.text())) : false;
		}

/**
*		@private
*/
		public static function getTextformatFont(styleID:String):String {
			var textFormatStyle:XML = getTextformatStyle(styleID);
			return textFormatStyle.font.length() ? textFormatStyle.font.text() : FontManager.DEFAULT_FONT;
		}

/**
*		@private
*/
		public static function getTextformatFontURL(styleID:String):String {
			var textFormatStyle:XML = getTextformatStyle(styleID);
			return textFormatStyle.font.@url.length() ? textFormatStyle.font.@url.toString() : EMPTY_STRING;
		}

/**
*		@private
*/
		public static function getTextformatLeading(styleID:String):Number {
			var textFormatStyle:XML = getTextformatStyle(styleID);
			return textFormatStyle.leading.length() ? Number(textFormatStyle.leading.text()) : 0;
		}

/**
*		@private
*/
		public static function getTextformatLetterspacing(styleID:String):Number {
			var textFormatStyle:XML = getTextformatStyle(styleID);
			return textFormatStyle.letterspacing.length() ? Number(textFormatStyle.letterspacing.text()) : 0;
		}

/**
*		@private
*/
		public static function getTextformatSelectable(styleID:String):Boolean {
			var textFormatStyle:XML = getTextformatStyle(styleID);
			return textFormatStyle.selectable.length() ? ((textFormatStyle.selectable.text() == TRUE) || Number(textFormatStyle.selectable.text())) : false;
		}
		
/**
*		@private
*/
		public static function getTextformatSelectedcolor(styleID:String):Number {
			var textFormatStyle:XML = getTextformatStyle(styleID);
			return textFormatStyle.selectedcolor.length() ? Number(checkForRGB(textFormatStyle.selectedcolor.text())) : 0xffffff;
		}

/**
*		@private
*/
		public static function getTextformatSelectioncolor(styleID:String):Number {
			var textFormatStyle:XML = getTextformatStyle(styleID);
			return textFormatStyle.selectioncolor.length() ? Number(checkForRGB(textFormatStyle.selectioncolor.text())) : 0xff0000;
		}

/**
*		@private
*/
		public static function getTextformatSize(styleID:String):Number {
			var textFormatStyle:XML = getTextformatStyle(styleID);
			return textFormatStyle.size.length() ? Number(textFormatStyle.size.text()) : 12;
		}

/**
*		@private
*/
		public static function getTextformatStyle(styleID:String):XML {
			return get(styleID) ? get(styleID) : ((styleID == DEFAULT_TEXT_FORMAT) ? defaultInputTextformatStyle : defaultTextformatStyle);
		}                     
		
/**
*		@private
*/
		public static function getTextformatWordwrap(styleID:String):Boolean {
			var textFormatStyle:XML = getTextformatStyle(styleID);
			return textFormatStyle.wordwrap.length() ? ((textFormatStyle.wordwrap.text() == TRUE) || Number(textFormatStyle.wordwrap.text())) : false;
		}

		
		
/**
*		@private
*/
		public static function processStyleNode(styleNode:XML):void {
			for each(var style:XML in styleNode.children()) {
				set(style, style.@style.toString());
			}
		}             

/**
*		@private
*/
		public static function remove(styleID:String):void {
			styleSheet[styleID] = null;
		}

/**
*		@private
*/
		public static function set(style:XML, styleID:String):void {
			styleSheet[styleID] = style;
		}
	}
}