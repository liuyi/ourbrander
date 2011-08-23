package com.ourbrander.component.containerBox
{
	import com.ourbrander.Event.superEvent;
	
	/**
	 * ...
	 * @author liuyi
	 */
	public class containerEvent extends superEvent 
	{   
		public static const CONTAINER_DISPLAYED="container_displayed"
		public function containerEvent(type:String,obj:Object=null,bubbles:Boolean=false,cancelable:Boolean=false):void
		{
			super(type,obj,bubbles,cancelable)
		}
		
	}

}