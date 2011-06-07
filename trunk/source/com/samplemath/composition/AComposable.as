package com.samplemath.composition {
	
	import flash.display.Sprite;
	import flash.events.Event;


	
/**
*	The abstract class for all UI elements that can be used with the composition framework. 
*	<p>AComposable implements most common properties and methods of a composable UI element. It is designed to be extended by concrete UI element implementations inheriting all shared functionality from this abstract class.</p>
*	
*	@see flash.display.Sprite
*/
	public class AComposable extends Sprite {
	
		/**
		*	@private  
		*/
		protected var _composer:Composer;
		/**
		*	@private  
		*/
		protected var _itemData:XML;
		
		
		
			
/**
*		If you find yourself calling this constructor method in your code then
*		please read a book about object oriented programming first. 
*/
		public function AComposable() {	
		}
		
		
		
		
/**
*		@private  
*/
		public function set _alpha(value:Number):void {
			super.alpha = value;
		}

/**
*		[SMXML] The alpha value for the UI element. Based on AS3 the value should range from 0 (fully transparent) to 1 (fully opaque).
*
*		@default 1
*/
		override public function get alpha():Number {
			return _itemData.@alpha.length() ? Number(_itemData.@alpha.toString()) : 1;
		}
		
/**
*		[SMXML] The alpha value for the UI element. Based on AS3 the value should range from 0 (fully transparent) to 1 (fully opaque).
*
*		@default 1
*/
		override public function set alpha(value:Number):void {
			if (_itemData)
			{
				_itemData.@alpha = value;
			}
			Composition.applyAlpha(this as AComposable);
		}
		
/**
*		@private  
*/
		protected function applyProperties():void {
			Composition.applyProperties(this);							
		}
		
/**
*		[SMXML] The position of the UI element from the bottom border of the parent Composer in pixels.
*/
		public function get bottom():Number {
			var value:Number = 0;
			if (_itemData) {
				if (_itemData.@bottom.length()) {
					value = Number(_itemData.@bottom.toString());
				}
			}
			return _itemData.@bottom.length() ? value : undefined;
		}

/**
*		[SMXML] The position of the UI element from the bottom border of the parent Composer in pixels.
*/
		public function set bottom(value:Number):void {
			if (_itemData) {
				_itemData.@bottom = value;
				Composition.applyX(this as AComposable);
			}
		}

/**
*	The parent <code>Composer</code> instance containing the UI element. 
*
*	@default null  
*/
		public function get composer():Composer {
			return _composer;
		}
		
/**
*		The parent <code>Composer</code> instance containing the particular UI element. 
*
* 	  	@default null  
*/
		public function set composer(value:Composer):void {
			_composer = value;
		}
		
/**
*		Use this method to dispose of the UI element. 
*
* 		<p>It will remove it from the display list as well as unset all variable
*		references and unregister all listeners related. Make the UI element completely
*		available for garbage collection by calling this method.</p>
*/
		public function destroy():void {                       
			if (this is Composer)
			{
				(this as Composer).empty();
			}
			unregisterEvents();
			if (parent) {
				if (parent.contains(this)) {
					parent.removeChild(this);
				}
			}
			if (_composer) {
				_composer = null;
			}
			if (_itemData) {
				if (_itemData.@id.length()) {
					Registry.remove(_itemData.@id.toString());
				}
				_itemData = null;
			}
			delete this;
		}          
		
/**
*		@private  
*/
		protected function handleComplete():void {  
			dispatchEvent(new Event(Event.COMPLETE));
			if (_composer) {
				_composer.handleChildComponentReady();
			}
		}

/**
*		@private  
*/
		public function get _height():Number {
			return super.height;
		}
		
/**
*		@private  
*/
		public function set _height(value:Number):void {
			super.height = value;
		}

/**
*		[SMXML] The height of the UI element in pixels.
*/
		override public function get height():Number {
			var value:Number = super.height;
			if (_itemData) {
				if (_itemData.@height.length()) {
					value = Number(_itemData.@height.toString());
				}
			}
			return value;
		}

/**
*		[SMXML] The height of the UI element in pixels.
*/
		override public function set height(value:Number):void {
			if (_itemData) {
				_itemData.@height = value;
				Composition.applyDimensions(this as AComposable);
			}
		}
		
/**
*		[SMXML] The unique identifier of the UI element.
*/
		public function get id():String {
			var value:String = "";
			if (_itemData) {
				if (_itemData.@id.length()) {
					value = _itemData.@id.toString();
				}
			}
			return _itemData.@id.length() ? value : undefined;
		}

/**
*		[SMXML] The unique identifier of the UI element.
*/
		public function set id(value:String):void {
			if (_itemData) {
				_itemData.@interactive = value;
				Composition.applyInteractive(this as AComposable);
			}
		}

/**
*		[SMXML] Boolean property specifying whether the UI element is available to mouse and other types of interaction.
*
*		@default false
*/
		public function get interactive():Boolean {
			var value:Boolean = false;
			if (_itemData) {
				if (_itemData.@interactive.length()) {
					value = Number(_itemData.@interactive.toString()) || (_itemData.@interactive.toString() == "true");
				}
			}
			return value;
		}

/**
*		[SMXML] Boolean property specifying whether the UI element is available to mouse and other types of interaction.
*
*		@default false
*/
		public function set interactive(value:Boolean):void {
			if (_itemData) {
				_itemData.@id = value;
				Composition.applyInteractive(this as AComposable);
			}
		}

/**
*
*		Use this property if you wish to update the SMXML markup without updating the component's layout. 
*
*/
		public function set __itemData(data:XML):void {  
			if (data) {
				_itemData = data;
			}
		}

/**
*		SMXML markup of the UI element. Setting the itemData property makes the UI element re-render itself on stage according to the (new)
*		XML markup provided.
*
*		@default null  
*/
		public function get itemData():XML {
			return _itemData;
		}

/**
*		SMXML markup of the UI element. Setting the itemData property makes the UI element re-render itself on stage according to the (new)
*		XML markup provided.
*
*		@default null  
*/
		public function set itemData(data:XML):void {  
			unregisterEvents();
			if (data) {
				_itemData = data;
			}
			Composition.applyTemplate(AComposable(this));		
			render();
			Composition.applyProperties(AComposable(this));		
			Composition.applyFilters(AComposable(this));		
			handleComplete();
		}
		
/**
*		[SMXML] The position of the UI element from the left border of the parent Composer in pixels.
*/
		public function get left():Number {
			var value:Number = 0;
			if (_itemData) {
				if (_itemData.@left.length()) {
					value = Number(_itemData.@left.toString());
				}
			}
			return _itemData.@left.length() ? value : undefined;
		}

/**
*		[SMXML] The position of the UI element from the left border of the parent Composer in pixels.
*/
		public function set left(value:Number):void {
			if (_itemData) {
				_itemData.@left = value;
				Composition.applyX(this as AComposable);
			}
		}

/**
*		Registers all events for the UI element. 
*
* 		<p>Extend this method to register additional events for your UI element to be used with SMAF.</p>
*/
		protected function registerEvents():void {
			if (_itemData.@completelistener.length()) {
				if (Registry.get(_itemData.@completelistener)) {
					if (Registry.get(_itemData.@completelistener).hasOwnProperty(_itemData.@completeaction)) {
						addEventListener(Event.COMPLETE, Registry.get(_itemData.@completelistener)[_itemData.@completeaction] as Function);
					}
				}
			}			
		}

/**
*		The <code>render()</code> method is called every time the <code>itemData</code> property of the UI element is updated. 
*
* 		<p>This method renders the UI element according to the markup contained in <code>itemData</code>.</p>
*/
		protected function render():void {
			this.mouseEnabled = false;
			this.buttonMode = false;  
			cacheAsBitmap = false;
			if (_itemData.@cacheasbitmap.length()) {
				if (Number(_itemData.@cacheasbitmap.toString()) || (_itemData.@cacheasbitmap.toString() == "true")) {
					cacheAsBitmap = true;
				}
			}
			registerEvents();
		}

/**
*		[SMXML] The position of the UI element from the right border of the parent Composer in pixels.
*/
		public function get right():Number {
			var value:Number = 0;
			if (_itemData) {
				if (_itemData.@right.length()) {
					value = Number(_itemData.@right.toString());
				}
			}
			return _itemData.@right.length() ? value : undefined;
		}

/**
*		[SMXML] The position of the UI element from the right border of the parent Composer in pixels.
*/
		public function set right(value:Number):void {
			if (_itemData) {
				_itemData.@right = value;
				Composition.applyX(this as AComposable);
			}
		}

/**
*		@private  
*/
		public function get _rotation():Number {
			return super.rotation;
		}

/**
*		@private  
*/
		public function set _rotation(value:Number):void {
			super.rotation = value;
		}

/**
*		[SMXML] The rotation of the UI element in angles.
*/
		override public function get rotation():Number {
			var value:Number = super.rotation;
			if (_itemData) {
				if (_itemData.@rotation.length()) {
					value = Number(_itemData.@rotation.toString());
				}
			}
			return value;
		}

/**
*		[SMXML] The rotation of the UI element in angles.
*/
		override public function set rotation(value:Number):void {
			_itemData.@rotation = value;
			Composition.applyRotation(this as AComposable);
		}
		
/**
*		@private  
*/
		public function _setDimensions(dimensionWidth:Number, dimensionHeight:Number):void {
			super.width = dimensionWidth;
			super.height = dimensionHeight;
		}

/**
*		Use this method to set both width and height of a UI element at the same time.
* 
*
* 		<p>This method is the equivalent of setting the <code>width</code> and <code>height</code>
* 		properties of a UI element except that it allows them to be set at the same time
*		making the UI element re-render itself only once and not twice. Use this method over setting the 
* 		<code>width</code> and <code>height</code> of a UI element at the same time to optimize
*		on performance of your code.</p>
*
* 		@param dimensionWidth The width of the UI element in pixels. 
* 		@param dimensionHeight The height of the UI element in pixels.
*
*/
		public function setDimensions(dimensionWidth:Number, dimensionHeight:Number):void {
			_itemData.@width = dimensionWidth;
			_itemData.@height = dimensionHeight;
			Composition.applyDimensions(this as AComposable);
		}
		
/**
*		[SMXML] The template SMXML composition to be rendered.
*/
		public function set template(value:String):void {
			if (_itemData) {
				_itemData.@template = value;
				itemData = _itemData;
			}
		}

/**
*		[SMXML] The position of the UI element from the top border of the parent Composer in pixels.
*/
		public function get top():Number {
			var value:Number = 0;
			if (_itemData) {
				if (_itemData.@top.length()) {
					value = Number(_itemData.@top.toString());
				}
			}
			return _itemData.@top.length() ? value : undefined;
		}

/**
*		[SMXML] The position of the UI element from the top border of the parent Composer in pixels.
*/
		public function set top(value:Number):void {
			if (_itemData) {
				_itemData.@top = value;
				Composition.applyX(this as AComposable);
			}
		}

/**
*		@private  
*/
		public function get _visible():Boolean {
			return super.visible;
		}

/**
*		@private  
*/
		public function set _visible(value:Boolean):void {
			super.visible = value;
		}

/**
*		[SMXML] Boolean specifying whether the UI element is rendered on screen.
* 
*		@default true
*/
		override public function get visible():Boolean {
			var value:Boolean = super.visible;
			if (_itemData) {
				if (_itemData.@visible.length()) {
					value = Number(_itemData.@visible.toString()) || (_itemData.@visible.toString() == "true");
				}
			}
			return value;
		}

/**
*		[SMXML] Boolean specifying whether the UI element is rendered on screen.
* 
*		@default true
*/
		override public function set visible(value:Boolean):void {
			if (_itemData)
			{
				if (value) {
					_itemData.@visible = 1;
				} else {
					_itemData.@visible = 0;
				}
			}
			Composition.applyVisible(this as AComposable);
		}
		
/**
*		@private
*/
		public function get _width():Number {
			return super.width;
		}
		
/**
*		@private
*/
		public function set _width(value:Number):void {
			super.width = value;
		}

/**
*		[SMXML] The width of the UI element in pixels.
*/
		override public function get width():Number {
			var value:Number = super.width; 
			if (_itemData) {
				if (_itemData.@width.length()) {
					value = Number(_itemData.@width.toString());
				}
			}
			return value;
		}

/**
*		[SMXML] The width of the UI element in pixels.
*/
		override public function set width(value:Number):void {
			if (_itemData) {
				_itemData.@width = value;
				Composition.applyDimensions(this as AComposable);
			}
		}
		
/**
*		@private
*/
		public function get _x():Number {
			return super.x;
		}

/**
*		@private
*/
		public function set _x(value:Number):void {
			super.x = value;
		}

/**
*		[SMXML] The x position of the UI element in pixels.
*/
		override public function get x():Number {
			var value:Number = super.x;
			if (_itemData) {
				if (_itemData.@x.length()) {
					value = Number(_itemData.@x.toString());
				}
			}
			return value;
		}

/**
*		[SMXML] The x position of the UI element in pixels.
*/
		override public function set x(value:Number):void {
			if (_itemData) {
				_itemData.@x = value;
				Composition.applyX(this as AComposable);
			}
		}
		
/**
*		@private
*/
		public function get _y():Number {
			return super.y;
		}

/**
*		@private
*/
		public function set _y(value:Number):void {
			super.y = value;
		}

/**
*		[SMXML] The y position of the UI element in pixels.
*/
		override public function get y():Number {
			var value:Number = super.y;
			if (_itemData) {
				if (_itemData.@y.length()) {
					value = Number(_itemData.@y.toString());
				}        
			}
			return value;
		}

/**
*		[SMXML] The y position of the UI element in pixels.
*/
		override public function set y(value:Number):void {
			if (_itemData) {
				_itemData.@y = value;
				Composition.applyY(this as AComposable);
			}
		}

/**
*		Unregisters all events for the UI element. 
*
* 		<p>Extend this method to unregister additional events for your UI element to be used with SMAF.</p>
*/
		protected function unregisterEvents():void
		{       
			if (_itemData)
			{
				if (_itemData.@completelistener.length())
				{
					if (Registry.get(_itemData.@completelistener))
					{
						if (Registry.get(_itemData.@completelistener).hasOwnProperty(_itemData.@completeaction))
						{
							if (hasEventListener(Event.COMPLETE))
							{
								removeEventListener(Event.COMPLETE, Registry.get(_itemData.@completelistener)[_itemData.@completeaction] as Function);
							}
						}
					}
				}			
			}
		}
	}
}