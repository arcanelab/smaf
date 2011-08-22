package com.samplemath.composition {

	


	import com.samplemath.configuration.Configuration;
	import com.samplemath.interaction.AInteractive;
	import com.samplemath.render.Filter;

	import flash.display.Sprite;
	import flash.geom.Rectangle;
	


/**
*	Static utility class supporting the UI composition framework. 
*	<p>The <code>Composition</code> class is a collection of static utility methods supporting
*	the SMXML composition framework. This class is not meant to be instantiated.</p>
*	
*	@see com.samplemath.composition.AComposable
*	@see com.samplemath.composition.Composer
*/
	public class Composition  {
		
		
		
			
		private static const CDATA_PREFIX:String = "<![CDATA[";
		private static const CDATA_SUFFIX:String = "]]>";
		private static const FILTER:String = "filter";
		private static const PATTERN_DELIMITER:String = "___";
		private static const PERCENT:String = "%";
		private static const TRUE:String = "true";

		private static var templates:Array = [];

/**
*		Library of static utility methods, not meant to be instantiated.
*/
		public function Composition() {	
		}
		
		

		
/**
* 		@private
*/
		public static function addPattern(itemData:XML, patternID:String, pattern:String):void {
			if (itemData)
			{
				if (!itemData.replace.length())
				{
					itemData.appendChild(<replace/>);
				}
			}                               
			var patternNode:XML = <pattern/>;
			patternNode.@id = patternID;
			patternNode.setChildren(new XML(CDATA_PREFIX + pattern + CDATA_SUFFIX));
			itemData.replace[0].appendChild(patternNode);
		}

/**
* 		@private
*/
		public static function applyAlpha(contentItem:AComposable):void {
			var contentItemData:XML = contentItem.itemData;
			if (contentItemData)
			{
				if (contentItemData.@alpha.length()) {
					contentItem._alpha = Number(contentItemData.@alpha.toString());
				}
			}
		}
		
/**
* 		@private
*/
		public static function applyDimensions(contentItem:AComposable):void {
			var contentItemData:XML = contentItem.itemData;
			if (contentItemData)
			{
				var composerRectangle:Rectangle = getComposerRectangle(contentItem);

				var itemRectangle:Rectangle = new Rectangle(0, 0, contentItem._width, contentItem._height);
				if (contentItemData.@width.length()) {
					itemRectangle.width = calculateDimension(contentItemData.@width.toString(), composerRectangle.width);
				}
				if (contentItemData.@height.length()) {
					itemRectangle.height = calculateDimension(contentItemData.@height.toString(), composerRectangle.height);
				}
				if ((itemRectangle.width != contentItem._width) || (itemRectangle.height != contentItem._height)) {
					contentItem._setDimensions(itemRectangle.width, itemRectangle.height);
				} 
			}
		}

/**
* 		@private
*/
		public static function applyFilters(contentItem:AComposable):void {
			var contentItemData:XML = contentItem.itemData;
			if (contentItemData.@filter.length()) {                                                
				if (StyleSheet.getFilterStyle(contentItemData.@filter.toString())) {
					var filterStyle:XML = StyleSheet.getFilterStyle(contentItemData.@filter.toString());
					if (filterStyle.localName().toLowerCase() == FILTER) {
						Filter.applyFilter(contentItem as Sprite, filterStyle);
					} else {
						Filter.applyFilters(contentItem as Sprite, filterStyle);
					}
				}
			}
		}

/**
* 		@private
*/
		public static function applyInteractive(contentItem:AComposable):void {
			if (contentItem)
			{
				var interactive:Boolean = false;
				var contentItemData:XML = contentItem.itemData;
				if (contentItemData)
				{
					if (contentItemData.@interactive.length()) {
						interactive = Number(contentItemData.@interactive.toString()) || (contentItemData.@interactive.toString() == TRUE);
					}
					if (contentItemData.@scroll.length() || contentItemData.@mouselistener.length()) {
						interactive = true;
					}
				}
				if (contentItem is AInteractive) {
					if (interactive) {
						(contentItem as AInteractive).enable();
					} else {
						(contentItem as AInteractive).disable();
					}
				} else {
					if (interactive) {
						contentItem.mouseEnabled = true;
						contentItem.buttonMode = true;
					} else {
						contentItem.mouseEnabled = false;
						contentItem.buttonMode = false;
					}
				}
			}
		}
		
/**
* 		@private
*/
		public static function applyProperties(contentItem:AComposable):void {
			var contentItemData:XML = contentItem.itemData;
			register(contentItem);
			applyInteractive(contentItem);
			applyVisible(contentItem);
			applyAlpha(contentItem);
			applyRotation(contentItem);
			applyDimensions(contentItem);
			applyScaleX(contentItem);
			applyScaleY(contentItem);
			applyX(contentItem);
			applyY(contentItem);
		}

/**
* 		@private
*/
		public static function applyRotation(contentItem:AComposable):void {
			var contentItemData:XML = contentItem.itemData;
			if (contentItemData)
			{
				if (contentItemData.@rotation.length()) {
					contentItem._rotation = Number(contentItemData.@rotation.toString());
				}
			}
		}
		
/**
* 		@private
*/
		public static function applyScaleX(contentItem:AComposable):void {
			var contentItemData:XML = contentItem.itemData;
			if (contentItemData)
			{
				if (contentItemData.@scaleX.length()) {
					contentItem.scaleX = Number(contentItemData.@scaleX.toString());
				}
			} 
		}

/**
* 		@private
*/
		public static function applyScaleY(contentItem:AComposable):void {
			var contentItemData:XML = contentItem.itemData;
			if (contentItemData)
			{
				if (contentItemData.@scaleY.length()) {
					contentItem.scaleY = Number(contentItemData.@scaleY.toString());
				}
			}
		}

/**
* 		@private
*/
		public static function applyTemplate(contentItem:AComposable):void {
			if (contentItem.itemData.@template.length()) {
				if (Composition.getTemplate(contentItem.itemData.@template.toString()))
				{
					var templateNode:XML = Composition.getTemplate(contentItem.itemData.@template.toString());
					if (contentItem.itemData.replace.length())
					{                          
						var templateNodeString:String = templateNode.toXMLString();
						for each(var pattern:XML in contentItem.itemData.replace.pattern)
						{                                     
							var value:String = pattern.text();
							if (pattern.hasComplexContent())
							{
								value = pattern.children().toXMLString();
							}
							templateNodeString = templateNodeString.split(PATTERN_DELIMITER + pattern.@id.toString() + PATTERN_DELIMITER).join(value);
						}           
						templateNode = new XML(templateNodeString);
						while (contentItem.itemData.replace.length())
						{
							delete contentItem.itemData.replace[0];
						}
					}
					delete templateNode.@template;
					if (templateNode.hasComplexContent())
					{
						contentItem.itemData.setChildren(templateNode.children());
					} else {
						if (templateNode.hasSimpleContent())
						{                                                                                                      
							if (!contentItem.itemData.text())                    
							{
								contentItem.itemData.setChildren(new XML(CDATA_PREFIX + templateNode.text() + CDATA_SUFFIX));
							}
						}
					}
					for each (var attribute:XML in templateNode.attributes() )
					{                                                        
						if (contentItem.itemData.attribute(attribute.localName()).length() < 1)
						{
							contentItem.itemData.attribute(attribute.localName())[0] = attribute;
						}
					}
				}
			}
		}

/**
* 		@private
*/
		public static function applyVisible(contentItem:AComposable):void {
			var contentItemData:XML = contentItem.itemData;
			if (contentItemData)
			{
				if (contentItemData.@visible.length()) {
					contentItem._visible = (Number(contentItemData.@visible.toString()) || (contentItemData.@visible.toString() == TRUE));
				}
			}
		}
		
/**
* 		@private
*/
		public static function applyX(contentItem:AComposable):void {
			var contentItemData:XML = contentItem.itemData;
			if (contentItemData)
			{
				var composerRectangle:Rectangle = getComposerRectangle(contentItem);
				if (contentItemData.@x.length()) {
					contentItem._x = calculatePosition(contentItemData.@x.toString(), composerRectangle.width);
				}
				if (contentItemData.@left.length()) {
					contentItem._x = calculatePosition(contentItemData.@left.toString(), composerRectangle.width);
				}
				if (contentItemData.@right.length()) {
					contentItem._x = composerRectangle.width - calculatePosition(contentItemData.@right.toString(), composerRectangle.width) - contentItem._width;
				}
			}
		}
		
/**
* 		@private
*/
		public static function applyY(contentItem:AComposable):void {
			var contentItemData:XML = contentItem.itemData;
			if (contentItemData)
			{
				var composerRectangle:Rectangle = getComposerRectangle(contentItem);
				if (contentItemData.@y.length()) {
					contentItem._y = calculatePosition(contentItemData.@y.toString(), composerRectangle.height);
				}
				if (contentItemData.@top.length()) {
					contentItem._y = calculatePosition(contentItemData.@top.toString(), composerRectangle.height);
				}
				if (contentItemData.@bottom.length()) {
					contentItem._y = composerRectangle.height - calculatePosition(contentItemData.@bottom.toString(), composerRectangle.height) - contentItem._height;
				}
			}
		}
		
/**
* 		@private
*/
		public static function calculateDimension(value:String, totalDistance:Number):Number {
			var result:Number = calculatePosition(value, totalDistance);
			if (result < 0)
			{
				result = totalDistance + result;
			}
			return result;
		}                         

/**
* 		@private
*/
		public static function calculatePosition(value:String, totalDistance:Number):Number {
			var result:Number = Number(value);
			if (value.substr(-1, 1) == PERCENT)
			{
				result = int((Number(value.split(PERCENT)[0]) / 100) * totalDistance);
			}
			return result;
		}                         

/**
* 		@private
*/
		public static function convertClassNameToFullClassName(className:String):String {
			for each (var classNameNode:XML in ComponentReference.classNameReference.className)
			{
				if (classNameNode.@short.toString() == className)
				{
					className = classNameNode.text();
				}
			}
			return className;
		}

/**
* 		@private
*/
		public static function getComposerRectangle(contentItem:AComposable):Rectangle {
			var composerRectangle:Rectangle = new Rectangle(0, 0, 64, 64);
			if (contentItem.composer) {
				if (contentItem.composer.contains(contentItem)) {
					composerRectangle.width = contentItem.composer._width;
					composerRectangle.height = contentItem.composer._height;
				}
			}
			return composerRectangle;
		}

/**
*		@private
*/
		public static function getTemplate(templateID:String):XML {
			var templateData:XML = null;
			if (templates[templateID]) {
				templateData = templates[templateID].copy();
				delete templateData.@template;
			}
			return templateData;
		}          

/**
* 		@private
*/
		public static function processTemplateNode(templateNode:XML):void {
			for each(var templateData:XML in templateNode.children()) {
				setTemplate(templateData, templateData.@template.toString());
			}
		}             

/**
* 		@private
*/
		public static function register(contentItem:AComposable):void {
			var contentItemData:XML = contentItem.itemData;
			if (contentItemData)
			{
				if (contentItemData.@id.length()) {
					Registry.set(contentItem, contentItemData.@id.toString());
				}
			}
		}   

/**
*		@private
*/
		public static function setTemplate(templateData:XML, templateID:String):void {
			templates[templateID] = templateData;
		}
	}
}