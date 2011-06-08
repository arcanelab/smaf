package com.samplemath.utility {

	import com.samplemath.composition.Composer;
	import com.samplemath.composition.Registry;
	import com.samplemath.font.FontManager;
	import com.samplemath.interaction.KeyBind;

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.events.Event;                          
	import flash.events.MouseEvent;                          
	
	import flash.external.ExternalInterface;




/**
*	Template document class for rendering SMXML.
*	<p>This document class can be compiled and/or extended as a micro-application rendering SMXML composition.
*	Ideal for rapidly developing widgets for HTML pages or larger Flash frameworks. As simple as it is the
*	reuse potential of this class is endless.</p>
*/
 	public class SMXML extends MovieClip {
				
		private var composer:Composer;
		private var _smxml:XML = <composer completelistener="smxml" completeaction="handleSMXMLShellComplete">
			<style>
				<fill style="buttonDefault" type="solid"> 
					<color>0x919191</color>
				</fill>
				<fill style="buttonOver" type="solid"> 
					<color>0xb7e288</color>
				</fill>          
				<fill style="codeBackground" type="solid"> 
					<color alpha=".36">0xffffff</color>
				</fill>          
				<textformat style="buttonText">
					<autosize>1</autosize>
					<color>0xc4c4c4</color>
					<embedfonts>0</embedfonts>
					<font>Helvetica Bold, Arial Bold</font>
					<size>14</size>
				</textformat>
				<textformat style="buttonTextOver">
					<autosize>1</autosize>
					<color>0xffffff</color>
					<embedfonts>0</embedfonts>
					<font>Helvetica Bold, Arial Bold</font>
					<size>14</size>
				</textformat>
				<textformat style="codeField">
					<autosize>0</autosize>
					<color>0x555555</color>
					<embedfonts>0</embedfonts>
					<font>Helvetica Bold, Arial Bold</font>
					<selectable>1</selectable>
					<selectedcolor>0x000000</selectedcolor>
					<selectioncolor>0xb7e288</selectioncolor>
					<size>13</size>
					<wordwrap>1</wordwrap>
				</textformat>
				<textformat style="codeFieldFocused">
					<autosize>0</autosize>
					<color>0x555555</color>
					<embedfonts>0</embedfonts>
					<font>Helvetica Bold, Arial Bold</font>
					<selectable>1</selectable>
					<selectedcolor>0xffffff</selectedcolor>
					<selectioncolor>0xb7e288</selectioncolor>
					<size>13</size>
					<wordwrap>1</wordwrap>
				</textformat>
			</style>
			<template>
				<composer template="buttonOff" width="100" height="16">
					<box width="100%" height="100%" fill="buttonDefault" rounded="8"/>
					<textblock width="100%" height="100%" textformat="buttonText"><![CDATA[SHOW CODE]]></textblock>
				</composer>
				<composer template="buttonOffOver" width="100" height="16">
					<box width="100%" height="100%" fill="buttonOver" rounded="8"/>
					<textblock width="100%" height="100%" textformat="buttonTextOver"><![CDATA[SHOW CODE]]></textblock>
				</composer>
				<composer template="buttonOn" width="100" height="16">
					<box width="100%" height="100%" fill="buttonDefault" rounded="8"/>
					<textblock width="100%" height="100%" textformat="buttonText"><![CDATA[HIDE CODE]]></textblock>
				</composer>
				<composer template="buttonOnOver" width="100" height="16">
					<box width="100%" height="100%" fill="buttonOver" rounded="8"/>
					<textblock width="100%" height="100%" textformat="buttonTextOver"><![CDATA[HIDE CODE]]></textblock>
				</composer>
			</template>
			<composer id="composition" width="100%" height="100%"/>
			<composer id="code" x="110" width="-110" height="100%" visible="0">
				<box width="100%" height="100%" fill="codeBackground"/>
				<inputfield id="codeField" width="100%" height="100%" fill="codeBackground" textformat="codeField" textformatfocused="codeFieldFocused" changelistener="smxml" changeaction="handleCodeChange" exception="27"/>
			</composer>;
			<toggle id="toggleCodeButton" x="5" y="5" width="100" height="16" skinon="buttonOn" skinonover="buttonOnOver" skinoff="buttonOff" skinoffover="buttonOffOver" mouselistener="smxml" onmousedown="handleToggleCode" keylistener="smxml" keycode="27" onkeydown="handleToggleCode"/>
		</composer>;          
		                                                 
		

		private const APPLICATION:String = "application";
		private const CODE:String = "code";
		private const CODE_FIELD:String = "codeField";
		private const COMPOSITION:String = "composition";
		private const EDIT_CODE:String = "EDIT CODE";
		private const HIDE_CODE:String = "HIDE CODE";
		private const _SMXML:String = "smxml";
		private const TOGGLE_CODE_BUTTON:String = "toggleCodeButton";
		private const URL:String = "url";
                     

   
/**
*		Constructor for the document class.
*/
		public function SMXML() {
			initialize();                           
		}
		    
		
		


/**
*		@private
*/
		public function handleCodeChange(event:Event):void
		{                       
			try {
				Registry.get(COMPOSITION).itemData = new XML(Registry.get(CODE_FIELD).text);
			} catch(error:Error) {
			}
		}
		
/**
*		@private
*/
		public function handleSMXMLShellComplete(event:Event):void
		{                                                     
			if (root.loaderInfo.parameters[_SMXML])
			{
				Registry.get(COMPOSITION).itemData = new XML(root.loaderInfo.parameters[_SMXML]);
				handleStageResize(null);
			}      
			if (root.loaderInfo.parameters[URL])
			{
				Registry.get(COMPOSITION).url = root.loaderInfo.parameters[URL];
				handleStageResize(null);
			}      
		}
		
/**
*		@private
*/
		public function handleToggleCode(event:Event):void
		{               
			if (Registry.get(TOGGLE_CODE_BUTTON))
			{
				if (Registry.get(TOGGLE_CODE_BUTTON).value)
				{
					showCode();
				} else {
					hideCode();
				}
			}
		}

		private function handleStageResize(event:Event):void {
			composer.setDimensions(stage.stageWidth, stage.stageHeight);
			composer.alignItem();
			composer.x = composer.y = 0;
		}
		
		private function hideCode():void
		{
			Registry.get(CODE).visible = false;
		}

		private function initialize():void {    
			FontManager.stage = stage;
			KeyBind.stage = stage;
			Registry.set(this, _SMXML);             
			Registry.set(this, APPLICATION);
			composer = new Composer();
			addChild(composer); 
			stage.align = StageAlign.TOP_LEFT;
			composer.itemData = _smxml;
			stage.addEventListener(Event.RESIZE, handleStageResize, false, 0, true);
			handleStageResize(null);
		}                 
		
		private function showCode():void
		{
			Registry.get(CODE).visible = true;  
			Registry.get(CODE_FIELD).text = Registry.get(COMPOSITION).itemData.toXMLString();
		}
	}
}