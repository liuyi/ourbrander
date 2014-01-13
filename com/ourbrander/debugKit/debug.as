package com.ourbrander.debugKit 
{
 
	import com.ourbrander.events.EasyEvent;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;

	/**
	 * ...
		 * @author liuyi,if you want find more help doucment or anything else,you can visit my blog:www.ourbrander.com or send me email:contact@ourbrander.com
	liuyi
	 */
	public class debug extends EventDispatcher
	{
		private static var _enabled:Boolean=true
		private static var _container:DisplayObject 
		private static var _outputPanel:outputPanel 
		private  static var _inited:Boolean=false
		
		public function debug() 
		{
			
		}
		public static function set enabled(b:Boolean):void {
			_enabled = b
			var event :EasyEvent= new EasyEvent(debugEvent.DEBUG_STATE_CHANGED, { enabled:enabled }, true)
			var dp:EventDispatcher=new EventDispatcher()
			dp.dispatchEvent(event)
		}
		public static function get enabled():Boolean {
		 
			return _enabled
		}
		public static function set container(target:DisplayObject):void {
			_container=target
		}
		public static function get container():DisplayObject {
		 
			return _container
		}
		 
		public static function init(target:DisplayObject):void {
			if (debug._inited == true) {
				return 
			}
			debug._inited =true
			container = target
			_outputPanel = new outputPanel ()
			container.stage.addChild(_outputPanel)
			
		}
		
	}
	
}