package com.samplemath.utility {

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;		




/**
*	The BitmapUtility class is a static utility class for supporting some commonly used
*	bitmap related functionality.
*/
	public class BitmapUtility {

       private static const BOTTOM:String = "bottom";
       private static const CENTER:String = "center";
       private static const LEFT:String = "left";
       private static const RIGHT:String = "right";
       private static const TOP:String = "top";

		
/**
*		Crop a display object to a Bitmap of desired dimensions.
*
* 		<p>You can provide any DisplayObject as a source object. This utility
*		method first takes a screenshot of the DisplayObject provided,
*		then scales this image to desired dimensions. In case the image
*		does not fit the proportions of the desired dimensions, some cropping
*		may occur.</p>
*
* 		<p>This method can be applied in many ways, such as taking screengrabs of
*		video streams or genrating user avatars.</p>
*
* 		@param sourceObject The display object to use as source.
* 		@param width The desired width of the bitmap.
* 		@param height The desired height of the bitmap.
* 		@param horizontalAlign The desired alignment horizontally in case cropping occurs.
* 		@param height verticalAlign The desired alignment vertically in case cropping occurs.
*
* 		@return The resized image as BitmapData.
*
*/
		public static function cropFitBitmap(sourceObject:DisplayObject, width:int, height:int, horizontalAlign:String = CENTER, verticalAlign:String = CENTER):BitmapData {
			var sourceWidth:int = 0;
			var sourceHeight:int= 0;
			var scale:Number = 0;
			if (((width / height) * sourceObject.height) > sourceObject.width) {
				scale = width / sourceObject.width;
				sourceWidth = sourceObject.width;
				sourceHeight = int(height / scale); 
			} else {
				scale = height / sourceObject.height;
				sourceWidth = int(width / scale);
				sourceHeight = sourceObject.height; 
			}
			
			var offSetX:int = -int(((sourceObject.width - sourceWidth) / 2) * scale);
			var offSetY:int = -int(((sourceObject.height - sourceHeight) / 2) * scale);
			
			if (horizontalAlign == LEFT) {
				offSetX = 0;
			}
			if (horizontalAlign == RIGHT) {
				offSetX = -int((sourceObject.width - sourceWidth) * scale);
			}
			if (verticalAlign == TOP) {
				offSetY = 0;
			}
			if (verticalAlign == BOTTOM) {
				offSetY = -int((sourceObject.height - sourceHeight) * scale);
			}
			
			var thisBitmapData:BitmapData = new BitmapData(width, height, true, 0x000000);
			thisBitmapData.draw(IBitmapDrawable(sourceObject), new Matrix(scale, 0, 0, scale, offSetX, offSetY), new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0), null, new Rectangle(0, 0, width, height), true);
			return thisBitmapData;
		}

/**
*		Takes a screenshot of a given DisplayObject and returns it as BitmapData.
*
* 		<p>You can provide any DisplayObject as a source object. This utility
*		method takes a screenshot of the DisplayObject provided and returns
*		the image as BitmapData.</p>
*
* 		@param sourceObject The display object to use as source.
* 		@param padding Optional integer parameter to specify padding around the source DisplayObject.
*
* 		@return The screenshot as BitmapData.
*/
		public static function screenshotBitmap(sourceObject:DisplayObject, padding:int = 0):BitmapData {
			var thisBitmapData:BitmapData = new BitmapData(sourceObject.width + padding, sourceObject.height + padding, true, 0xffffff);
			thisBitmapData.draw(IBitmapDrawable(sourceObject), null, null, null, new Rectangle(0, 0, sourceObject.width + 2 * padding, sourceObject.height + 2 * padding), true);
			return thisBitmapData;
		}
	}
}