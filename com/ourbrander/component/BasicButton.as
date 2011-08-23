package com.ourbrander.component 
{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author liuyi
	 * update:2011-1-19.
	 * added autoDestory,destory()
	 * update:2010-12-8.
	 * added _onMouseUp
	 */
	
	dynamic public class BasicButton extends MovieClip
	{
		protected var _onClick:Function;
		protected var _onRollOver:Function;
		protected var _onRollOut:Function;
		protected var _onMouseDown:Function;
		protected var _onMouseUp:Function
		protected var _content:Object
		protected var _autoDestory:Boolean
		
		
		
		public function BasicButton() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, addEvent);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removeEvent);
			this.buttonMode = true;
			this.mouseChildren = false;
			_autoDestory=true
			_content={}
		}
		
		public function set autoDestory(b:Boolean):void {
			_autoDestory=b
		}
		
		public function get autoDestory():Boolean {
			return _autoDestory;
		}
		
		
		public function set content(obj:Object) {
			_content=obj
		}
		public function get content():Object {
			return _content
		}
		public function set click(fun:Function) {
			_onClick = fun;
		}
		
		public function set mouseDown(fun:Function) {
	 
			_onMouseDown = fun;
		}
		
		public function set mouseUp(fun:Function) {
			_onMouseUp = fun;
		}
		
		public function set rollOver(fun:Function) {
			_onRollOver = fun;
		}
		public function set rollOut(fun:Function) {
			_onRollOut = fun;
		}
		
		public function get click():Function {
			return _onClick;
		}
		
		public function get mouseDown():Function {
			
			return _onMouseDown;
		}
		
		public function get mouseUp():Function {
			return _onMouseUp;
		}
		public function get rollOver():Function {
			return _onRollOver;
		}
		
		public function get rollOut():Function {
			return _onRollOut;
		}
		
		public function destory() :void{
			this.removeEventListener(Event.ADDED_TO_STAGE, addEvent);
			_onClick = null;
			 _onRollOver= null;
			 _onRollOut= null;
			 _onMouseDown = null;
			
		}
		
		protected function addEvent(e:Event):void {
			this.addEventListener(MouseEvent.CLICK, clickHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER, rollOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, rollOutHandler);
			
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
		}
		
		
		
		protected function removeEvent(e:Event) :void{
			
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removeEvent);
			
			this.removeEventListener(MouseEvent.CLICK, clickHandler);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			
			this.removeEventListener(MouseEvent.MOUSE_OVER, rollOverHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT, rollOutHandler);
			if(_autoDestory){
				destory();
			}
		}
		
		protected function clickHandler(e:MouseEvent):void {
			if (_onClick!=null) {
				_onClick()
			}
		}
		
		protected function rollOverHandler(e:MouseEvent) :void{
			if (_onRollOver!=null) {
				_onRollOver()
			}
		}
		
		protected function rollOutHandler(e:MouseEvent):void {
			if (_onRollOut!=null) {
				_onRollOut()
			}
		}
		
		protected function downHandler(e:MouseEvent) :void{
		
			if (_onMouseDown!=null) {
				_onMouseDown()
			}
		}
		
		protected function onMouseUpHandler(e:MouseEvent):void 
		{
			if (_onMouseUp!=null) {
				_onMouseUp()
			}
		}
		
		 
		
		
	}

}