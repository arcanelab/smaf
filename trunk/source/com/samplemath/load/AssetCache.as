package com.samplemath.load {



	import com.samplemath.composition.Registry;

	import flash.display.Stage;
	import flash.events.Event;
	import flash.system.System;
	import flash.utils.ByteArray;



/**
*	Static utility class supporting caching assets loaded in the memory
*	for optimizing performance of your application.
*	<p><code>AssetCache</code> caches each asset loaded by its URL. In case the same file is to be loaded again, the
*	request won't even make it to the browser to retrieve the file from browser cache, it's already available
*	in the memory. Assets can be cached temporarily (by default, for content), permanently (typically for UI assets) or not at all.
*	This may be specified in SMXML.</p>
*	<p>AssetCache configuration is planned to come from the applicatin configuration but yet to be implemented.</p>
*/
	public class AssetCache {
	
		private static var cacheArray:Array = [];
		private static var cacheIndexArray:Array = [];
		private static var maximumMemoryUse:int = 96000000;
/**
* 		@private
*/
		public static var stage:Stage;              

/**
*		This is a static utility class with no purpose to be instantiated.
*/
		public function AssetCache() {
		}
		
		
		
/**
*		Caches the asset loaded.
*		
*		@param	url The URL of the asset as <code>String</code>.
*		@param	data The asset data as <code>ByteArray</code>.
*		@param	permanent Specifies whether the asset is to be cached permanently or not.
*/
		public static function cache(url:String, data:ByteArray, permanent:Boolean = false):void {
			if (!isCached(url)) {
/*				Util.addDebugLine("----- cachin --- " + url + ", " + data.length);*/
				cacheArray[url] = data;
				if (!permanent) {
					cacheIndexArray.push(url);
				} else {
/*					Util.addDebugLine("----- cached PEMANENT! --- ");*/
				}
				var cacheSize:int = 0;
				for each(var cachedAsset:String in cacheIndexArray) {
					var cachedAssetData:ByteArray = cacheArray[cachedAsset];
					cacheSize += cachedAssetData.length;
				}
/*				Util.addDebugLine("----- total memory --- " + cacheSize + " / " + cacheIndexArray.length + " items");*/
				handleControlCacheSize(null);
			}
		}

/**
*		Checks whether the asset is cached.
*		
*		@param	url The URL of the asset as <code>String</code>.
*		
*		@return	Whether the asset is cached as <code>Boolean</code>.
*/
		public static function isCached(url:String):Boolean {
			var response:Boolean = false;
			if (cacheArray[url]) {
				response = true;
			}
			return response;
		}

/**
*		Retrieves the asset's data based on its URL.
*		
*		@param	url The URL of the asset as <code>String</code>.
*		
*		@return	The asset data as <code>ByteArray</code>.
*/
		public static function getAssetData(url:String):ByteArray {
			var response:ByteArray = null;
			if (isCached(url)) {
				response = cacheArray[url];
/*				Util.addDebugLine("----- load from cache --- " + url + ", " + response.length);*/
			}
			return response;
		}

/**
* 		@private
*/
		public static function handleControlCacheSize(event:Event):void {
			var cacheSize:int = 0;
			for each(var cachedAsset:String in cacheIndexArray) {
				var cachedAssetData:ByteArray = cacheArray[cachedAsset];
				cacheSize += cachedAssetData.length;
			}
			if (cacheSize  > maximumMemoryUse) {
				var assetToUncache:String = cacheIndexArray.shift();
				cacheArray[assetToUncache] = null;
				System.gc();
				if (stage) {
					stage.addEventListener(Event.ENTER_FRAME, handleControlCacheSize)
				}
			} else {
				if (stage) {
					if (stage.hasEventListener(Event.ENTER_FRAME)) {
						stage.removeEventListener(Event.ENTER_FRAME, handleControlCacheSize)
					}
				}
			}
		}
	}
}