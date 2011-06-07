package com.samplemath.thirdparty.ru.inspirit.net.events 
{
	import flash.events.Event;
	
	/**
	 * MultipartURLLoader Event for async data prepare tracking
	 * @author Eugene Zatepyakin
     * @private 
	 */
	public class MultipartURLLoaderEvent extends Event
	{
		public static const DATA_PREPARE_PROGRESS:String = 'dataPrepareProgress';
		public static const DATA_PREPARE_COMPLETE:String = 'dataPrepareComplete';
		
		public var bytesLoaded:uint = 0;
		public var bytesTotal:uint = 0;
		
		public function MultipartURLLoaderEvent(type:String, w:uint = 0, t:uint = 0) 
		{
			super(type);
			
			bytesTotal = t;
			bytesLoaded = w;
		}
		
	}
	
}