package com.samplemath.font {
	
	import flash.text.Font;
	import flash.display.Sprite;


/**
*	Document class template for embedding fonts to use with SMAF with the flex sdk.
*	<p>Use this class template to embed your own fonts in a SWF file that can be dynamically loaded using SMXML.
*   When defining the <code>textformat</code> style, use the <code>url</code> attribute of the <code>font</code> node
*	to specify a URL to load the SWF file from containing the embedded font. The font will automatically become available to your SMXML composition</p>
*/
 	public class SMAFFont extends Sprite {

	    [Embed(source="FONT_URL", mimeType="application/x-font", fontName="FONT_NAME", fontWeight="normal", unicodeRange="U+0020-U+007E", embedAsCFF="false")]
/**
*		The font class reference.
*/
	    public static var FONT_NAME:Class;
		FONT_NAME;
	
/**
*		Mandatory constructor.
*/
		public function SMAFFont() {
		}
	}
}




