package com.ourbrander.debugKit 
{
	import com.ourbrander.Event.superEvent;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher
	
	/**
	 * ...
		 * @author liuyi,if you want find more help doucment or anything else,you can visit my blog:www.ourbrander.com or send me email:contact@ourbrander.com
	liuyi
	 */
	public class debug extends EventDispatcher
	{
		private static var _enabled:Boolean=true
		private static var _container:DisplayObject = null
		private static var _outputPanel:outputPanel = null
		private  static var _inited:Boolean=false
		
		public function debug() 
		{
			
		}
		public static function set enabled(b:Boolean) {
			_enabled = b
			var event = new superEvent(debugEvent.DEBUG_STATE_CHANGED, { enabled:enabled }, true)
			var dp:EventDispatcher=new EventDispatcher()
			dp.dispatchEvent(event)
		}
		public static function get enabled():Boolean {
			var  k:Boolean = _enabled
			return k
		}
		public static function set container(target:DisplayObject) {
			_container=target
		}
		public static function get container():DisplayObject {
			var k:DisplayObject= _container
			return k
		}
		 
		public static function init(target:DisplayObject) {
			if (debug._inited == true) {
				return false
			}
			debug._inited =true
			container = target
			_outputPanel = new outputPanel ()
			container.stage.addChild(_outputPanel)
			
		}
		
	}
	
}