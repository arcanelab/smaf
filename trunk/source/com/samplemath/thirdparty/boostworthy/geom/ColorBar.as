// *****************************************************************************************// ColorBar.as// // Copyright (c) 2007 Ryan Taylor | http://www.boostworthy.com// // Permission is hereby granted, free of charge, to any person// obtaining a copy of this software and associated documentation// files (the "Software"), to deal in the Software without// restriction, including without limitation the rights to use,// copy, modify, merge, publish, distribute, sublicense, and/or sell// copies of the Software, and to permit persons to whom the// Software is furnished to do so, subject to the following// conditions://// The above copyright notice and this permission notice shall be// included in all copies or substantial portions of the Software.//// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR// OTHER DEALINGS IN THE SOFTWARE.// *****************************************************************************************// // +          +          +          +          +          +          +          +          +// // *****************************************************************************************// PACKAGE /////////////////////////////////////////////////////////////////////////////////package com.samplemath.thirdparty.boostworthy.geom{	// IMPORTS /////////////////////////////////////////////////////////////////////////////		import flash.display.CapsStyle;	import flash.display.GradientType;	import flash.display.LineScaleMode;	import flash.display.Sprite;	import flash.geom.Matrix;		// CLASS ///////////////////////////////////////////////////////////////////////////////		/**	 * The 'ColorBar' class presents a simple implementation of a color bar with a 	 * specified width and height. A color bar spans the entire color spectrum from left 	 * to right.     * @private 	 */	public class ColorBar extends Sprite	{		// *********************************************************************************		// CLASS DECLERATIONS		// *********************************************************************************				// CONSTANTS ///////////////////////////////////////////////////////////////////////				/** Configures the default width of this object. */		private static const DEFAULT_WIDTH:Number  = 100;				/** Configures the default height of this object. */		private static const DEFAULT_HEIGHT:Number = 100;				// CLASS MEMBERS ///////////////////////////////////////////////////////////////////				// MEMBERS /////////////////////////////////////////////////////////////////////////				// *********************************************************************************		// EVENT HANDLERS		// *********************************************************************************				/**		 * Constructor.		 * 		 * @param	nWidth		The width of the color bar.		 * @param	nHeight		The height of the color bar.		 */		public function ColorBar(nWidth:Number = DEFAULT_WIDTH, nHeight:Number = DEFAULT_HEIGHT)		{			init(nWidth, nHeight);		}				// *********************************************************************************		// API		// *********************************************************************************				/**		 * Initializes the color bar.		 * 		 * @param	nWidth		The width of the color bar.		 * @param	nHeight		The height of the color bar.		 */		public function init(nWidth:Number = DEFAULT_WIDTH, nHeight:Number = DEFAULT_HEIGHT):void		{			var nColorPercent : Number;			var nRadians      : Number;			var nR            : Number;			var nG            : Number;			var nB            : Number;			var nColor        : Number;			var objMatrixW    : Matrix;			var objMatrixB    : Matrix;			var nHalfHeight   : Number;						// Clear the graphics container.			graphics.clear();						// Calculate half of the height.			nHalfHeight = nHeight * 0.5;						// Loop through all of the pixels from '0' to the specified width.			for(var i:int = 0; i < nWidth; i++)			{				// Calculate the color percentage based on the current pixel.				nColorPercent = i / nWidth;								// Calculate the radians of the angle to use for rotating color values.				nRadians = (-360 * nColorPercent) * (Math.PI / 180);								// Calculate the RGB channels based on the angle.				nR = Math.cos(nRadians)                   * 127 + 128 << 16;				nG = Math.cos(nRadians + 2 * Math.PI / 3) * 127 + 128 << 8;				nB = Math.cos(nRadians + 4 * Math.PI / 3) * 127 + 128;								// OR the individual color channels together.				nColor  = nR | nG | nB;								// Create new matrices for the white and black gradient lines.				objMatrixW = new Matrix();				objMatrixW.createGradientBox(1, nHalfHeight, Math.PI * 0.5, 0, 0);				objMatrixB = new Matrix();				objMatrixB.createGradientBox(1, nHalfHeight, Math.PI * 0.5, 0, nHalfHeight);								// Each color slice is made up of two lines - one for fading from white to the 				// color, and one for fading from the color to black.				graphics.lineStyle(1, 0, 1, false, LineScaleMode.NONE, CapsStyle.NONE);				graphics.lineGradientStyle(GradientType.LINEAR, [0xFFFFFF, nColor], [100, 100], [0, 255], objMatrixW);				graphics.moveTo(i, 0);				graphics.lineTo(i, nHalfHeight);				graphics.lineGradientStyle(GradientType.LINEAR, [nColor, 0], [100, 100], [0, 255], objMatrixB);				graphics.moveTo(i, nHalfHeight);				graphics.lineTo(i, nHeight);			}		}	}}