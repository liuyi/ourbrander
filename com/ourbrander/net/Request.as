package com.ourbrander.net 
{
	/**
	 * ...
	 * @author liuyi
	 */
	import flash.net.URLRequest
	import flash.net.URLLoader
	import flash.net.URLRequestMethod
	import flash.net.URLVariables
	import flash.events.IOErrorEvent
	import flash.events.Event
	import flash.utils.Timer
	import flash.events.HTTPStatusEvent
	import flash.events.TimerEvent
	public class Request
	{
		public static  var OUTTIME:Number = 5000;
		public function Request() 
		{
			
		}
		
		
		public static function sendRequest(requestUrl:String, val:URLVariables=null, callSuccess:Function=null, callError:Function = null,method:String="POST",format:String="text") {
			 
			var request:URLRequest = new URLRequest();
			var urlLoader:URLLoader = new URLLoader();
			request.url = requestUrl;
			request.method =method;
			request.data = val
			urlLoader.dataFormat = format;
			
			
		    urlLoader.addEventListener(Event.COMPLETE, loaded);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, loadError);
			//urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, http_hdl);
			var timer:Timer = new Timer(OUTTIME, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,outtime)
			timer.start()
			var errorCatched:Boolean=false
			 
				if(request.url!=""){
					urlLoader.load(request)
				 
				}else {
					callError("error http path");
					clearData()
					clearEvent();
				}
			 
			function loaded(e:Event) {
			 
				clearEvent();
				callSuccess(urlLoader.data)
				clearData();
			}
			
			function loadError(e:IOErrorEvent) {
			 
				clearEvent()
				if (callError != null) {
					callError(e);
				}
				clearData()
			}
			
			function http_hdl(e:HTTPStatusEvent) {
			 
				if (e.status >= 400) {
				 
				//	clearEvent();
					if (callError != null) {
					callError(e);
					}
					//clearData()
				}
			}
			
			function clearEvent() {
				urlLoader.removeEventListener(Event.COMPLETE, loaded);
			    urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
				urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, http_hdl)
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE,outtime)
			}
			function clearData() {
				request = null
				urlLoader = null
				timer.stop();
				timer=null
			}
			
			 function outtime(e:TimerEvent):void 
			{
				if (callError != null) {
						callError();
				}
				clearEvent();
				clearData()
			}
		}//end function		
		
	}

}