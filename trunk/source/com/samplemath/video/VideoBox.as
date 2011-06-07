package com.samplemath.video {
   
	import flash.media.Video;
	
	import com.samplemath.composition.AComposable;
	import com.samplemath.shape.Box;
	



/**
*	Concrete UI element for rendering video.
*	<p>The <code>VideoBox</code> class wraps an AS3 <code>Video</code> class
*	with supporting functionality to make it work with SMXML composition. It renders
*	an instance of <code>Video</code> on screen applying layout and other properties defined in SMXML.
*	The <code>VideoBox</code> class is just as low level as <code>Video</code> making it purposable
*	in many ways including, but not limited to video players and peer to peer video chat.</p>
*	
*	@see com.samplemath.composition.AComposable
*	@see com.samplemath.composition.StyleSheet
*/
	public class VideoBox extends AComposable {
		
		private var _video:Video;
		private var _videoBackground:Box;



/**
*		Instantiates VideoBox.
*/
		public function VideoBox() {
			_itemData = <videobox/>;
			super();
		}
		



/**
*		@inheritDoc
*/
		override public function destroy():void { 
			if (_video) {    
				if (contains(_video)) {
					  removeChild(_video);
				}
				_video = null;
			}
			super.destroy();
		}        
		
/**
*		@private
*/
		override public function set _height(value:Number):void {  
			if (_videoBackground) {
				_videoBackground.height = value;
			}                       
			if (_video) {
				_video.height = value;
			}
		}
		
/**
*		@inheritDoc
*/
		override protected function render():void {
 			if (!_video) {
				_video = new Video(); 
				_video.smoothing = true;
				addChild(_video);                           
				this.mouseEnabled = false;
				this.buttonMode = false;
/*				registerEventListeners();*/
			}
			
		}

/**
*		@private
*/
		override public function _setDimensions(widthToSet:Number, heightToSet:Number):void { 
			_width = widthToSet;
			_height = heightToSet;
		}
		
/**
*		@private
*/
		override public function set _width(value:Number):void {	
 			if (_videoBackground) {
				_videoBackground.width = value;
			}                       
			if (_video) {
				_video.width = value;
			}                       
   		}   

/**
*		The <code>Video</code> instance wrapped by <code>VideoBox</code>.
*/
		public function get video():Video {
			return _video;
		}
	}
}