package com.ourbrander.sound 
{
	import flash.events.Event;
	
	/**
	 * ...
		 * @author liuyi,if you want find more help doucment or anything else,you can visit my blog:www.ourbrander.com or send me email:contact@ourbrander.com
	liuyi
	 */
	public class SoundEvent extends Event 
	{
		public static const STOP_ALL_SOUND :String= "stop_all_sound"
		public static const RECOVER_ALL_SOUND:String="recover_all_sound"
		public static const VIDEO_PLAYING:String="video_playing"
	
		public var _content:Object;
		
		public function SoundEvent(type:String,obj:Object=null,bubbles:Boolean=false,cancelable:Boolean=false):void {
			super(type,bubbles,cancelable);
			
			data=obj;
		}

		public function set data(obj:Object):void {
			_content=obj;
		}
		public function get data():Object {
			
			return _content;
		}
		override public function clone():Event {
			return new SoundEvent(type,data,bubbles,cancelable);
		}
		override public function toString():String {
			return formatToString("soundEvent","type","content","bubbles","cancelable","eventPhase");
		}
		
	}
	
}