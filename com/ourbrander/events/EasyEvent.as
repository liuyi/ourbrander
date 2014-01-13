package com.ourbrander.events
{
	 
	
	import flash.events.Event;
	
	public class EasyEvent extends Event
	{
		public static const DATA_SELECT:String="data_select";
		public static const DATA_DESELECT:String="data_deselect";
		private var _params:Object;
		public function EasyEvent(type:String, params:Object=null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_params=params
		}

		public function get params():Object
		{
			return _params;
		}

		public function set params(value:Object):void
		{
			_params = value;
		}

		
		override public function clone():Event {
			return new EasyEvent(type,_params,bubbles,cancelable);
		}
		override public function toString():String {
			return formatToString("EasyEvent","type","params","bubbles","cancelable","eventPhase");
		}
	}
}