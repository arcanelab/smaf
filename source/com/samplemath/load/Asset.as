package com.samplemath.load {

	import com.samplemath.composition.AComposable;
	import com.samplemath.composition.Composer;
	import com.samplemath.composition.Registry;
	import com.samplemath.interaction.AInteractive;

	import flash.display.Bitmap;    
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
                  

	                            
/**
*	Concrete UI element for loading image assets to render on screen.
*	<p><code>Asset</code> essentially wraps an AS3 <code>Loader</code> class with additional
*	functionality supporting integration with SMAF. Asset is capable of loading GIF, JPG and PNG image files
*	as well as SWF movies. Advanced developers may use <code>Asset</code> to load code modules in SMXML markup.
*	It's also planned to support loading font definitions dynamically from SMXML.</p>
*	                                                          
*	@see http://samplemath.com/smaf/doc/wikka.php?wakka=UsingAsset
*	@see com.samplemath.composition.AComposable
*	@see com.samplemath.load.AssetCache
*	@see com.samplemath.composition.StyleSheet
*/
	public class Asset extends AInteractive {
	
		private var assetLoaded:DisplayObject;
		private var assetLoader:DisplayObject;
		private var assetLoading:Loader;
		private var _itemHeight:Number = 0;
		private var _itemWidth:Number = 0;
		private var loadFromCache:Boolean = false;
		private var _waitToSwitch:Boolean = false;
		
		/**
		*		Static constant value for asset scaling.
		*/
				public static const CROP:String = "crop";
		/**
		*		Static constant value for asset scaling.
		*/
				public static const FIT:String = "fit";
		/**
		*		Static constant value for asset scaling.
		*/
				public static const STRETCH:String = "stretch";

	    private const CONTENT:String = "content";
		private const TRUE:String = "true";
		
		
			
/**
*		Instantiates Asset.
*/
		public function Asset() {
			_itemData = <asset/>;
			super();
		}
		
		
		
		private function adjustAsset():void {
			if (assetLoader) {                
				if (_itemData.@scale.length()) {
					adjustScale();
				} else {
					if (_itemWidth && _itemHeight) {
						assetLoader.width = _itemWidth;
						assetLoader.height = _itemHeight;
					}
				}              
/*				if (assetLoader.content is Bitmap) {
					Bitmap(assetLoader.content).smoothing = smoothing;
				}*/
			}
		}
	
		private function adjustScale():void {                      
			if (assetLoader) {    
				var thisContent:DisplayObject = assetLoader;
				if (assetLoader is Loader)
				{
					thisContent = (assetLoader as Loader).content;
				}
				if (thisContent) {
					var targetRectangle:Rectangle = new Rectangle(0, 0, _width, _height);
					switch (_itemData.@scale.toString()) {
						case Asset.CROP:
							if (((thisContent.width / thisContent.height) * targetRectangle.height) < targetRectangle.width) {
								assetLoader.height = int(thisContent.height / (thisContent.width / targetRectangle.width)); 
								if (assetLoader.height) {
									assetLoader.width = targetRectangle.width;
								}
							} else {
								assetLoader.width = int(thisContent.width / (thisContent.height / targetRectangle.height));
								if (assetLoader.width) {
									assetLoader.height = targetRectangle.height;
								}
							}
							break;
						case Asset.FIT:
							if (((thisContent.width / thisContent.height) * targetRectangle.height) > targetRectangle.width) {
								assetLoader.height = int(thisContent.height / (thisContent.width / targetRectangle.width)); 
								if (assetLoader.height) {
									assetLoader.width = targetRectangle.width;
								}
							} else {
								assetLoader.width = int(thisContent.width / (thisContent.height / targetRectangle.height));
								if (assetLoader.width) {
									assetLoader.height = targetRectangle.height;
								}
							}
							break;
						case Asset.STRETCH:
							assetLoader.width = targetRectangle.width;
							assetLoader.height = targetRectangle.height;
							break;
						default:
							assetLoader.width = targetRectangle.width;
							assetLoader.height = targetRectangle.height;
							break;
					}
					assetLoader.x = int((targetRectangle.width - assetLoader.width) / 2);
					assetLoader.y = int((targetRectangle.height - assetLoader.height) / 2);
					scrollRect = new Rectangle(0, 0, _itemWidth, _itemHeight)
				}
			}
		}

/**
*		The <code>content</code> property of the <code>Loader</code> instance wrapped inside.
*/
		public function get content():DisplayObject {
			var response:DisplayObject = null;
			if (assetLoader) {
				if (assetLoader.hasOwnProperty(CONTENT)) {
					if (assetLoader is Loader)
					{
						response = (assetLoader as Loader).content;
					}
				}				
			}
			return response;
		}

/**
*		@inheritDoc
*/
		override public function destroy():void {
			if (assetLoading) {
				try {
					assetLoading.close();
				} catch (error:Error) {}
				if (assetLoading.contentLoaderInfo) {
					if (assetLoading.contentLoaderInfo.hasEventListener(Event.INIT)) {
						assetLoading.contentLoaderInfo.removeEventListener(Event.INIT, handleAssetLoaded);
					}
					if (assetLoading.contentLoaderInfo.hasEventListener(IOErrorEvent.IO_ERROR)) {
						assetLoading.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handleAssetLoadError);
					}
					if (assetLoading.contentLoaderInfo.hasEventListener(ProgressEvent.PROGRESS)) {
						assetLoading.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, handleAssetLoading);
					}
				}
				assetLoading = null;
				assetLoader = null;
			}
			if (hasEventListener(Event.ENTER_FRAME)) {
				removeEventListener(Event.ENTER_FRAME, handleCompleteEvent);
			}
			super.destroy();
		}

		private function handleAssetLoaded(event:Event):void {
			if (_itemData.@classname.length()) {
				ExternalInterface.call("alert", "handleAssetLoaded " + event.target.toString());
			}
			assetLoaded = event.target.loader as Loader;
			
			if (assetLoaded) {
				if (_itemData.@smoothing.length()) {
					if (Number(_itemData.@smoothing.toString())) {
						var checkPolicyFile:Boolean = false;
						if (_itemData.@checkpolicyfile.length())
						{
							if (Number(_itemData.@checkpolicyfile.toString()))
							{
								checkPolicyFile = true;
							}
						}
						if (checkPolicyFile == false)
						{
							if ((assetLoaded as Loader).content is Bitmap) {
								Bitmap((assetLoaded as Loader).content).smoothing = true;
							}
							if ((assetLoaded as Loader).content is DisplayObjectContainer) {
								if (DisplayObjectContainer((assetLoaded as Loader).content).numChildren) {
									if (DisplayObjectContainer((assetLoaded as Loader).content).getChildAt(0) is Bitmap) {
										Bitmap(DisplayObjectContainer((assetLoaded as Loader).content).getChildAt(0)).smoothing = true;
									}
								}
							}
						}
					}
				}

				if (!loadFromCache) {
					var permanent:Boolean = _itemData.@cachepermanent.length() ? (Number(_itemData.@cachepermanent.toString()) || (_itemData.@cachepermanent.toString() == TRUE)) : false;
					if ((assetLoaded as Loader)) {
						if ((assetLoaded as Loader).contentLoaderInfo) {
							AssetCache.cache((assetLoaded as Loader).contentLoaderInfo.url as String, (assetLoaded as Loader).contentLoaderInfo.bytes as ByteArray, permanent);
						}
					}
				}
			}

			if (!_waitToSwitch) {
				switchAssets();
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}

		private function handleAssetLoadError(event:IOErrorEvent):void {
			ExternalInterface.call("alert", "handleAssetLoadError " + event.text);
			
		}

		private function handleAssetLoading(event:ProgressEvent):void {
			if (_itemData.@progressListener.length()) {
				var totalBytes:Number = (totalBytes <= 0) ? 120000 : event.bytesTotal;
				var progress:Number = Math.min(1, (event.bytesLoaded / totalBytes));

				if (Registry.get(_itemData.@progressListener.toString())) {
					if (Registry.get(_itemData.@progressListener.toString()).hasOwnProperty(_itemData.@progressAction.toString())) {
						var id:String = "";
						if (_itemData.@id.length()) {
							id = _itemData.@id.toString();
						}
						Registry.get(_itemData.@progressListener.toString())[_itemData.@progressAction.toString()](progress, id);
					}
				}
			}	
		}		

		private function handleCompleteEvent(event:Event):void {
			if (hasEventListener(Event.ENTER_FRAME)) {
				removeEventListener(Event.ENTER_FRAME, handleCompleteEvent);
			}                     
			handleComplete();
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
			adjustAsset();
		}

/**
*		Loads an image asset from the specified URL. Only use this if you need to have
*		control over the ApplicationDomain to load the asset in. Otherwise use the <code>url</code> property/attribute.
*
*		@param url The URL of the file to load
*		@param loadInDomain An optional <code>ApplicationDomain</code> to load the file in. This may be useful when loading code modules from SMXML.
*/
		public function loadAsset(url:String, loadInDomain:ApplicationDomain = null):void {
			if (url != "") {         
				var bypassBaseURL:Boolean = false;
				if (_itemData.@bypassBaseURL.length())
				{
					if (Number(_itemData.@bypassBaseURL.toString()) || Boolean(_itemData.@bypassBaseURL.toString()))
					{                                                         
						bypassBaseURL = true;
					}
				}
				if (bypassBaseURL == false)
				{
					url = ServiceProxy.baseURL + url;
				}
				if (assetLoading) {
					try {
						assetLoading.close();
					} catch (error:Error) {}
					if (assetLoading.contentLoaderInfo) {
						if (assetLoading.contentLoaderInfo.hasEventListener(Event.INIT)) {
							assetLoading.contentLoaderInfo.removeEventListener(Event.INIT, handleAssetLoaded);
						}
						if (assetLoading.contentLoaderInfo.hasEventListener(IOErrorEvent.IO_ERROR)) {
							assetLoading.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handleAssetLoadError);
						}
						if (assetLoading.contentLoaderInfo.hasEventListener(ProgressEvent.PROGRESS)) {
							assetLoading.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, handleAssetLoading);
						}
					}
					assetLoading = null;
				}
				assetLoading = new Loader();
				assetLoading.cacheAsBitmap = cacheAsBitmap;
				assetLoading.contentLoaderInfo.addEventListener(Event.INIT, handleAssetLoaded, false, 0, true);
				assetLoading.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleAssetLoadError, false, 0, true);
				if (_itemData.@progressListener.length()) {
					assetLoading.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, handleAssetLoading, false, 0, true);
				}                                                   
				var checkPolicyFile:Boolean = false;
				if (_itemData.@checkpolicyfile.length())
				{
					if (Number(_itemData.@checkpolicyfile.toString()))
					{
						checkPolicyFile = true;
					}
				}
				var loaderContext:LoaderContext = new LoaderContext(checkPolicyFile);
				if (loadInDomain) {
					loaderContext = new LoaderContext(true, loadInDomain, SecurityDomain.currentDomain);
				}

				if (AssetCache.isCached(url)) {
					loadFromCache = true;                                   
					loaderContext.checkPolicyFile = false;
					assetLoading.loadBytes(AssetCache.getAssetData(url), loaderContext);
				} else {
					loadFromCache = false;
					assetLoading.load(new URLRequest(url), loaderContext);
				}
			} else {
				dispatchEvent(new Event(Event.COMPLETE));
				if (!_waitToSwitch) {
					switchAssets();
				}
			}
		}

/**
*		Loads an image asset from the specified URL. Only use this if you need to have
*		control over the ApplicationDomain to load the asset in. Otherwise use the <code>url</code> property/attribute.
*
*		@param url The URL of the file to load
*		@param loadInDomain An optional <code>ApplicationDomain</code> to load the file in. This may be useful when loading code modules from SMXML.
*/
import flash.external.ExternalInterface;
		public function loadAssetFromClass(className:String, loadInDomain:ApplicationDomain = null):void {
			if (className != "") {         
				if (assetLoading) {
					try {
						assetLoading.close();
					} catch (error:Error) {}
					if (assetLoading.contentLoaderInfo) {
						if (assetLoading.contentLoaderInfo.hasEventListener(Event.INIT)) {
							assetLoading.contentLoaderInfo.removeEventListener(Event.INIT, handleAssetLoaded);
						}
						if (assetLoading.contentLoaderInfo.hasEventListener(IOErrorEvent.IO_ERROR)) {
							assetLoading.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handleAssetLoadError);
						}
						if (assetLoading.contentLoaderInfo.hasEventListener(ProgressEvent.PROGRESS)) {
							assetLoading.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, handleAssetLoading);
						}
					}
					assetLoading = null;
				}
				var imageFromClass:Class = undefined;
				try {
					imageFromClass = Class(getDefinitionByName(className));
				} catch (e:Error) {
				}                          
				if (imageFromClass)
				{
					var bitmapFromClass:Bitmap = new imageFromClass() as Bitmap;
					assetLoaded = bitmapFromClass;
					switchAssets();
				}
			} else {
				dispatchEvent(new Event(Event.COMPLETE));
				if (!_waitToSwitch) {
					switchAssets();
				}
			}
		}

/**
*		The <code>Loader</code> instance wrapped inside.
*/
		public function get loader():Loader {
			return assetLoader ? assetLoader as Loader : null;
		}
		
/**
*		Overide this method if you need to extend <code>Asset</code>.
*/
		override protected function render():void {
			super.render();
			var loadInDomain:ApplicationDomain = _itemData.@loadInCurrentDomain.length() ? ApplicationDomain.currentDomain : null;
			if (_itemData.@classname.length()) {
				loadAssetFromClass(_itemData.@classname.toString(), loadInDomain);
			} else {
				if (_itemData.@url.length()) {
					loadAsset(_itemData.@url.toString(), loadInDomain);
				}
			}
		}
		
/**
*		[SMXML] The scale mode in use for the asset.
*/
		public function get scale():String {
			var value:String = Asset.STRETCH;
			if (_itemData) {
				if (_itemData.@scale.length()) {
					value = _itemData.@scale.toString();
				}
			}
			return (_itemData.@scale.length()) ? value : undefined;
		}

/**
*		[SMXML] The scale mode in use for the asset.
*/
		public function set scale(value:String):void {
			if (_itemData) {
				_itemData.@scale = value;
				adjustScale();
			}
		}

/**
*		@private
*/
		override public function _setDimensions(widthToSet:Number, heightToSet:Number):void {
			_itemWidth = widthToSet;
			_itemHeight = heightToSet;
			adjustAsset();
		}                

/**
*		[SMXML] Specifies whether smoothing is enabled when rendering (and possibly scaling) the asset.
*/
		public function get smoothing():Boolean {
			var value:Boolean = false;
			if (_itemData) {
				if (_itemData.@smoothing.length()) {
					value = Number(_itemData.@smoothing.toString()) || (_itemData.@smoothing.toString() == TRUE);
				}
			}
			return value;
		}

/**
*		[SMXML] Specifies whether smoothing is enabled when rendering (and possibly scaling) the asset.
*/
		public function set smoothing(value:Boolean):void {
			if (_itemData) {
				_itemData.@smoothing = value;
				adjustAsset();
			}
		}

		private function switchAssets():void {
			if (assetLoader) {
				removeChild(assetLoader);
			}
			if (assetLoaded != null) {
				assetLoader = assetLoaded;
				assetLoaded = null;
			} else {
				assetLoader = new Loader();
				assetLoader.cacheAsBitmap = cacheAsBitmap;
				(assetLoader as Loader).contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleAssetLoadError, false, 0, true);
			}
			addChild(assetLoader);	   
			 	                   
			if (assetLoader is InteractiveObject)
			{
				(assetLoader as InteractiveObject).mouseEnabled = mouseEnabled;
			}

			adjustAsset();

			if (_itemData.@completelistener.length()) {
				addEventListener(Event.ENTER_FRAME, handleCompleteEvent, false, 0, true);
			}	
		}
		
		private function set waitToSwitch(p_value:Boolean):void {
			_waitToSwitch = p_value;
		}
		

/**
*		[SMXML] The URL of the asset rendered.
*/
		public function get url():String {
			var value:String = "";
			if (_itemData) {
				if (_itemData.@url.length()) {
					value = _itemData.@url.toString();
				}
			}
			return value;
		}

/**
*		[SMXML] The URL of the asset rendered.
*/
		public function set url(value:String):void {
			if (_itemData) {
				_itemData.@url = value;
				itemData = _itemData;
			}
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
			adjustAsset();
		}
   }
}