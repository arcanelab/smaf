package com.samplemath.interaction {
	
	import com.samplemath.composition.AComposable;
	import com.samplemath.composition.Registry;
	import com.samplemath.interaction.KeyBind;
	import com.samplemath.utility.Utility;

	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;

	

	
/**
*	The abstract class for all interactive UI elements. 
*	<p>AInteractive implements most common methods and event handlers of an interactive UI element. It is designed to be extended by concrete UI element implementations inheriting all shared functionality from this abstract class.</p>
*	
*	@see com.samplemath.composition.AComposable
*/
	public class AInteractive extends AComposable {
		
/**
*		@private  
*/
		protected var _disabled:Boolean = false;

/**
*		@private  
*/
		protected var _doubleClickStamp:Number = 0;

/**
*		@private  
*/
		protected var _doubleClickTreshold:Number = 240;

		
/**
*		If you find yourself calling this constructor method in your code then
*		please read a book about object oriented programming first. 
*/
		public function AInteractive() {	
		}
		
		
		
/**
*		@inheritDoc  
*/
		override public function destroy():void {
			super.destroy();
		}

/**
*		Disables the interactive UI element. It will not react to any mouse or keyboard interaction.
*/
		public function disable():void {
			_disabled = true;
			buttonMode = false;
			mouseEnabled = false;
			useHandCursor = false;
		}
		
/**
*		Enables the interactive UI element. Makes it react to mouse or keyboard interaction.
*/
		public function enable():void {
			_disabled = false;
			buttonMode = true;
			mouseEnabled = true;
			useHandCursor = true;
			tabEnabled = false;
		}
		
/**
*		@private  
*/
		private function handleRemovedFromStage(event:Event):void {
			KeyBind.remove(_itemData.@keycode, _itemData.@id);               
		}
		

/**
*		@inheritDoc
*/
		override protected function registerEvents():void {
			super.registerEvents();
			if (_itemData){
				buttonMode = true;
				useHandCursor = true;
				tabEnabled = false;
				tabEnabled = false;

				if (_itemData.@mouselistener.length()) {
					if (Registry.get(_itemData.@mouselistener.toString())) {
						if (_itemData.@onmouseover.length()) {
							addEventListener(MouseEvent.MOUSE_OVER, Registry.get(_itemData.@mouselistener.toString())[_itemData.@onmouseover.toString()] as Function, false, 0, true);
						}
						if (_itemData.@onmouseout.length()) {
							addEventListener(MouseEvent.MOUSE_OUT, Registry.get(_itemData.@mouselistener.toString())[_itemData.@onmouseout.toString()] as Function, false, 0, true);
						}
						if (_itemData.@onmousedown.length()) {
							addEventListener(MouseEvent.MOUSE_DOWN, Registry.get(_itemData.@mouselistener.toString())[_itemData.@onmousedown.toString()] as Function, false, 0, true);
						}
						if (_itemData.@onmouseup.length()) {
							addEventListener(MouseEvent.MOUSE_UP, Registry.get(_itemData.@mouselistener.toString())[_itemData.@onmouseup.toString()] as Function, false, 0, true);
						}
						if (_itemData.@onrollover.length()) {
							addEventListener(MouseEvent.ROLL_OVER, Registry.get(_itemData.@mouselistener.toString())[_itemData.@onrollover.toString()] as Function, false, 0, true);
						}
						if (_itemData.@onrollout.length()) {
							addEventListener(MouseEvent.ROLL_OUT, Registry.get(_itemData.@mouselistener.toString())[_itemData.@onrollout.toString()] as Function, false, 0, true);
						}
						if (_itemData.@onclick.length()) {
							addEventListener(MouseEvent.CLICK, Registry.get(_itemData.@mouselistener.toString())[_itemData.@onclick.toString()] as Function, false, 0, true);
						}
						if (_itemData.@onmousemove.length()) {
							addEventListener(MouseEvent.MOUSE_MOVE, Registry.get(_itemData.@mouselistener.toString())[_itemData.@onmousemove.toString()] as Function, false, 0, true);
						}
					}
				}						
			}               
			if (_itemData.@keylistener.length()) {
				if (Registry.get(_itemData.@keylistener.toString())) {
					if (_itemData.@onkeydown.length()) {
						addEventListener(KeyboardEvent.KEY_DOWN, Registry.get(_itemData.@keylistener.toString())[_itemData.@onkeydown.toString()] as Function, false, 0, true);
					}
					if (_itemData.@onkeyup.length()) {
						addEventListener(KeyboardEvent.KEY_UP, Registry.get(_itemData.@keylistener.toString())[_itemData.@onkeydown.toString()] as Function, false, 0, true);
					}
				}
			}
			if (_itemData.@keycode.length()) {     
				KeyBind.resume();
				KeyBind.register(_itemData.@keycode.toString(), _itemData.@id.toString());
				addEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage, false, 0, true);         
			}
		}
		
/**
*		@inheritDoc  
*/
		override protected function render():void {
			super.render();
		}
 
		override protected function unregisterEvents():void {
			super.unregisterEvents();
			if (_itemData){
				if (_itemData.@mouselistener.length()) {
					if (Registry.get(_itemData.@mouselistener.toString())) {
						if (_itemData.@onmouseover.length()) {
							removeEventListener(MouseEvent.MOUSE_OVER, Registry.get(_itemData.@mouselistener.toString())[_itemData.@onmouseover.toString()] as Function);
						}
						if (_itemData.@onmouseout.length()) {
							removeEventListener(MouseEvent.MOUSE_OUT, Registry.get(_itemData.@mouselistener.toString())[_itemData.@onmouseout.toString()] as Function);
						}
						if (_itemData.@onmousedown.length()) {
							removeEventListener(MouseEvent.MOUSE_DOWN, Registry.get(_itemData.@mouselistener.toString())[_itemData.@onmousedown.toString()] as Function);
						}
						if (_itemData.@onmouseup.length()) {
							removeEventListener(MouseEvent.MOUSE_UP, Registry.get(_itemData.@mouselistener.toString())[_itemData.@onmouseup.toString()] as Function);
						}
						if (_itemData.@onrollover.length()) {
							removeEventListener(MouseEvent.ROLL_OVER, Registry.get(_itemData.@mouselistener.toString())[_itemData.@onrollover.toString()] as Function);
						}
						if (_itemData.@onrollout.length()) {
							removeEventListener(MouseEvent.ROLL_OUT, Registry.get(_itemData.@mouselistener.toString())[_itemData.@onrollout.toString()] as Function);
						}
						if (_itemData.@onclick.length()) {
							removeEventListener(MouseEvent.CLICK, Registry.get(_itemData.@mouselistener.toString())[_itemData.@onclick.toString()] as Function);
						}
						if (_itemData.@onmousemove.length()) {
							removeEventListener(MouseEvent.MOUSE_MOVE, Registry.get(_itemData.@mouselistener.toString())[_itemData.@onmousemove.toString()] as Function);
						}
					}
				}						

			}
			if (_itemData.@keylistener.length()) {
				if (Registry.get(_itemData.@keylistener.toString())) {
					if (_itemData.@onkeydown.length()) {
						removeEventListener(KeyboardEvent.KEY_DOWN, Registry.get(_itemData.@keylistener.toString())[_itemData.@onkeydown.toString()] as Function);
					}
					if (_itemData.@onkeyup.length()) {
						removeEventListener(KeyboardEvent.KEY_UP, Registry.get(_itemData.@keylistener.toString())[_itemData.@onkeydown.toString()] as Function);
					}
				}
			}
			if (_itemData.@keycode.length()) {     
				KeyBind.resume();
				KeyBind.remove(_itemData.@keycode.toString(), _itemData.@id.toString());
				if (hasEventListener(Event.REMOVED_FROM_STAGE))
				{
					removeEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);         
				}
			}
		}
   }
}