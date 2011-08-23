package com.ourbrander.Event{
	/*
	 类名：超级事件 superEvent 
	 说明：发送事件时，可以自己任意发送更多自定义的参数。
	 构造函数:(type:String,obj:Object=null,bubbles:Boolean=false,cancelable:Boolean=false)
	 继承至:flash.events.Event
	 方法：
	 public function  get content():Object
	 public function set content(obj:Object):void
	 作者:yi
	 网站:http://www.ourbrander.com/#
	 
	*/
	import flash.events.Event;
	public class superEvent extends Event {
		import flash.events.Event;
		private  var _content:Object;
		public function superEvent(type:String,obj:Object=null,bubbles:Boolean=false,cancelable:Boolean=false):void {
			super(type,bubbles,cancelable);
			
			content=obj;
		}

		public function set content(obj:Object):void {
			_content=obj;
		}
		public function get content():Object {
			
			return _content;
		}
		override public function clone():Event {
			return new superEvent(type,content,bubbles,cancelable);
		}
		override public function toString():String {
			return formatToString("superEvent","type","content","bubbles","cancelable","eventPhase");
		}

	}
}