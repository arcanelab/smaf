package com.samplemath.motion {
	
	import com.samplemath.event.SMAFEvent;

	import flash.display.MovieClip;
	import flash.events.Event;  
	import flash.events.EventDispatcher;  
	import flash.utils.getDefinitionByName;
	
	
	
/**
*	The Motion class provides a framework for programming animations of all
*	sorts in a uniform manner within your application.
*
*	<p>You may specify one or more 'motion strategy' which will affect the curve of the
*	animation whether it's actual motion or setting other properties. Please note that this class is in a premature state,
*	motion strategies are to be explored in upcoming releases of SMAF.</p>
*/
	public class Motion extends EventDispatcher {
		

/**
*		Applies a sinus curve to the motion.
*/
		public static const SINUS:String = "sinus";
/**
*		Applies a square curve to the motion.
*/
		public static const SQUARE:String = "square";
/**
*		Applies a square root curve to the motion.
*/
		public static const SQUARE_ROOT:String = "squareRoot";

		private var _duration:int;
		private var engine:MovieClip;               
		private var motionDate:Date;
		private var motionStamp:int;
		private var _moving:Boolean = false;
		private var strategies:Array;

		
		
/**
*		Creates a Motion object with the specified duration and Motion strategy.
*
*		@param 
*/
		public function Motion(motionDuration:int = 640, motionStrategies:Array = null) {
			_duration = motionDuration;                                              
			if (motionStrategies) {
				strategies = motionStrategies;
			} else {
				strategies = [];
			}
		}
		
		private function sinus(value:Number):Number {
			return Math.sin((value * 90) * (Math.PI / 180));
		}

		private function square(value:Number):Number {
			return (1 - Math.sqrt(1 - value));
		}
		
		private function squareRoot(value:Number):Number {
			return Math.sqrt(value);
		}
		
		
		
		
		private function applyMotionCurve(value:Number):Number {
			for each(var motionStrategyMethodName:String in strategies) {
				value = this[motionStrategyMethodName](value);
			}
			return value;
		}

		private function end():void {                                
			stop();
			dispatchValue(1);
		}          
		
		private function dispatchValue(value:Number):void {
			dispatchEvent(new SMAFEvent(SMAFEvent.MOVE, applyMotionCurve(value) as Object));
		}

/**
*		The duration of the motion.
*/
		public function get duration():int
		{
			return _duration;
		}

		private function handleMotion(event:Event):void {
			motionDate = new Date();
			var timePassed:int = motionDate.time - motionStamp;
			if (timePassed < _duration) {
				dispatchValue(timePassed / _duration);
			} else {
				end();
			}
		}                      
		
/**
*		Specifies whether the motion is in effect as boolean.
*/
		public function get moving():Boolean
		{
			return _moving;
		}
		
/**
*		Starts the motion.
*/
		public function start():void {   
			if (!engine) {
				engine = new MovieClip();
			}
			_moving = true;   
			motionDate = new Date();
			motionStamp = motionDate.time;
			engine.addEventListener(Event.ENTER_FRAME, handleMotion, false, 0, true);
			dispatchValue(0);
		}   

/**
*		Stops the motion in effect.
*/
		public function stop():void { 
			_moving = false;
			if (engine.hasEventListener(Event.ENTER_FRAME)) {
				engine.removeEventListener(Event.ENTER_FRAME, handleMotion);
			}
		}
	}
}