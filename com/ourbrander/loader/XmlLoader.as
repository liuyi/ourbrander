package com.ourbrander.loader{
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	public class XmlLoader extends EventDispatcher {
		/*
		作者:翼
		网站[奥博瑞德]:www.ourbrander.com
		方法:
		loadXML(path:String) ：获取外部指定路径XML文件数据
		get xml(sourceXml:XML)：指定XML
		get xml():返回xml格式数据
		
		get Length() :返回XML的节点长度
		事件:
		ProgressEvent.PROGRESS：正在下载时的事件信息，具体请查看AS3 类库中的属性
		Event.COMPLETE 下载完成,具体请查看AS3 类库中的属性
		IOErrorEvent.IO_ERROR 下载错误事件
		*/
		protected var _xml:XML=new XML;
		private var getVar:URLLoader=new URLLoader;
		private var loaded:Function;
		private var loadProgress:Function;
		private var _state:String;//xmlObj的状态，初始化："init",正在下载:"loading",下载完毕："compelete"
		function XmlLoader() {
			_xml.ignoreWhitespace=true;
			State="init"
		}
		public function loadXML(path:String):void {
		
			var sendVar:URLRequest=new URLRequest(path);
			getVar.addEventListener(Event.COMPLETE,loadComplete);
			getVar.addEventListener(ProgressEvent.PROGRESS ,Progress);
			getVar.addEventListener(IOErrorEvent.IO_ERROR ,loadError);
			getVar.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatus);

			getVar.load(sendVar);
			sendVar=null;
		}
		
		public function dispose():void {
			removeEvent();
			_xml = null
			loaded = null
			loadProgress=null
			
		}
		//设置和获取xmlObj的xml
		public function get xml() :XML{
			return _xml.copy();
		}
		
		
		private function removeEvent() :void
		{
			getVar.removeEventListener(Event.COMPLETE,loadComplete);
			getVar.removeEventListener(ProgressEvent.PROGRESS ,Progress);
			getVar.removeEventListener(IOErrorEvent.IO_ERROR ,loadError);
			getVar.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus);
			try{
			getVar.close()
			}catch (e:Error) { }
			
			getVar = null
			
		}
		//获取xmlObj的状态属性
		
		private function set State(str:String):void{
			_state=str
		}
		public function get xmlState():String{
			return _state
		}
		private function Progress(event:ProgressEvent):void {
			 State = "loading";
			
			dispatchEvent(event)
		}
		private function loadComplete(event:Event) :void{
			_xml = new XML(getVar.data);
			removeEvent();
			dispatchEvent(event);
		

		}
		private function loadError(event:IOErrorEvent) :void{
			removeEvent();
			dispatchEvent(event);

		}
		private function httpStatus(event:HTTPStatusEvent) :void {
			//trace(event.status)
			dispatchEvent(event);

		}
		
	}
}