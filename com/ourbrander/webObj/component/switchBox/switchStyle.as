package com.ourbrander.webObj.component.switchBox 
{
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.events.Event
	
	/**
	 * ...
	 * @author liuyi url:www.ourbrander.com email:contact@ourbrander.com
	...
	 */
	public class switchStyle extends EventDispatcher  
	{   
		protected var _styleName :String
		protected var _preObj:*
		protected var _nextObj:*
		protected var _speed:Number
		protected var _rectangle:Rectangle
		//event
		 public static const SWICTH_COMPELETE = "swicth_compelete"
		
		public function switchStyle() 
		{
			 
		}
	
		public function switchTo($preObj, $nextObj, $rectangle, $speed =null) {
		 _preObj = $preObj
		 _nextObj = $nextObj
		 _speed = ($speed==null)?_speed:$speed
         _rectangle = $rectangle
		 addEventListener(Event.ENTER_FRAME,startSwitch)
		}
		
		private function startSwitch() {
			 
		}
		public function get styleName() {
			return _styleName
		}
		
		public function get speed():Number {
			return _speed
		}
		public function set speed(val:Number) {
			
			_speed = val
			//trace("set speed"+_speed)
		}
	}
	
}