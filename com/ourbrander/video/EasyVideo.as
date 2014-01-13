package com.ourbrander.video  
{
	import com.ourbrander.debugKit.itrace;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	
	/**
	 * ...
	 * @author liu yi 
	 * update:2011-5-25 added init width and init height
	 * update:2011-1-26 oninited(d:object) added a param
	 * update:2010-12-29
	 * 
	 */
	public class EasyVideo extends Sprite 
	{
		protected var _video:Video
		protected var _stream:NetStream
		protected var _connet:NetConnection
		protected var _soundTransform:SoundTransform
		protected var _server:String
		protected var _videoPath:String
		protected var _videoDuration :Number 
		protected var _playedTime:uint 
		//data
		protected var _isPlaying:Boolean 
		protected var _autoPlay:Boolean
		protected var _connetClient:Object
		protected var _nsClient:Object
		protected var _loadedPercent:Number
		protected var _videoWidth:Number;
		protected  var _videoHeight:Number;
		
		protected var _targetVolume:Number
		protected var _volumeSpeed:Number
		private var _preVolume:Number
		
		protected var _inited:Boolean
		protected var _cuePoints:Array;
		
		//function
		
		public var onLoadProgress:Function
		public var onPlayCompleted:Function
		public var onInited:Function
		public var onLoaded:Function
		public var closeSteam:Boolean = true
		public var onCuePoint:Function
		public var onError:Function;
		
		protected var _bg:Shape
		
		
		public function EasyVideo(w:uint = 640,h:uint=480 ) :void
		{
			super();
			init(w,h)
			addEventListener(Event.ADDED_TO_STAGE,addedToStage)
		}
		
		//===============================================================================================
		//===============================================================================================
		protected function addedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE,removedFromStage)
		}
		
		//===============================================================================================
		//===============================================================================================
		protected function removedFromStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			destory()
		}
		
		//===============================================================================================
		//===============================================================================================
		protected function init(w:uint = 640,h:uint=360) :void{
			_playedTime = 0;
			_isPlaying = false;
			_volumeSpeed = 0.4;
			_videoDuration = 0;
			
			_inited = false;
			_bg = new Shape();
			_bg.graphics.beginFill(0,1);
			_bg.graphics.drawRect(0, 0, w, h);
			_cuePoints = [];
			addChild(_bg);
		}
		
		//===============================================================================================
		//===============================================================================================
		protected function destory():void {
			
			this.removeEventListener(Event.ENTER_FRAME, smoothVolume)
			stopCheckProgress();
			
			if (_stream != null) {
				_stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				_stream.removeEventListener(NetStatusEvent.NET_STATUS, onNs_NetStatusHandler);
				_stream.pause();
				if(closeSteam)
				_stream.close();
				_stream = null
			}
			_nsClient = null
			
			if(_connet!=null){
			_connet.close()
			_connet.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatusHandler);
			_connet = null
			_connetClient = null
			}
	
			_soundTransform=null
			
		
		}
		
		
		
		
		public function set server(path:String):void {
			_server = path
		
			if (_connet == null) {
				_connet = new NetConnection()
			
			}
			_connet.close();
		    _connetClient={}
			_connet.client = _connetClient
			if (_server == "" || _server == null) {
				_connet.connect(null)
				initData()
			}else {
				
				_connet.addEventListener(NetStatusEvent.NET_STATUS, onNetStatusHandler);
				_connet.connect(_server)
			}
		}
		
		
		
		public function get server():String {
			return _server;
		}
		
		public function get stream():NetStream {
			return _stream;
		}
		
		
		
		public function get videoWidth():Number {
			return _videoWidth;
		}
		
		public function get videoHeight():Number {
			return _videoHeight
		}
		
		public function set videoWidth(w:Number):void {
			 _videoWidth = w;
			 _video.width = w;
		}
		
		public function set videoHeight(h:Number):void {
			 _videoHeight=h
			  _video.height =h
		}
		
		public function get videoPath():String {
			return _videoPath;
		}
		
		
		public function playVideo(path:String="",start:Number=0,autoPlay:Boolean=true,bufferTime:Number=2) :void
		{
			if (server == null) { server = "" };
			_inited=false
			_videoPath=path;
			_autoPlay=autoPlay
			_stream.bufferTime = bufferTime; 
			_stream.play(_videoPath, start);
			
			itrace("path:"+_videoPath)
			
			if (! _autoPlay) {
				_stream.pause();
				_isPlaying = false
			}else {
				_isPlaying = true
			}
			_loadedPercent=0;
			checkProgress();
		}
		/*not finished*/
		public function attachStream(str:NetStream):void {
		//	if (server == null) { server = "" };
			initData(str)
			_stream = str;
			_video.attachNetStream(_stream);
		}
		
		public function pause():void {
			if(_stream!=null){
			_stream.pause();
			_isPlaying = false
			}
		}
		
		public function togglePause():void {
			if(_isPlaying==false){
				resume()
			}else {
				pause()
			}
			
		}
		
		public function resume():void {
			if(_stream!=null){
			_stream.resume();
			_isPlaying = true;
			}
		}
		
		public function seek(offset:Number):Number {
			if(_stream!=null){
				_stream.seek(offset);
			 }
			return offset;
		}
		
		public function replay():void {
			if(_stream!=null){
			_stream.seek(0);
			resume();
			}
		}
		
		public function close() :void {
			if(_stream!=null){
			_stream.close();
			_isPlaying = false
			stopCheckProgress()
			}
		}
		//change to set volume from setVolume();
		public function set volume(num:Number) :void{
			if (_stream == null) { return }
			if ( num < 0 ) { num = 0 }
			if ( num > 100 ) { num = 100 }
			_targetVolume = num
			
			_preVolume=_soundTransform.volume = _stream.soundTransform.volume
			this.addEventListener(Event.ENTER_FRAME,smoothVolume)
		}
		
		public function get volume():Number {
			if (_stream == null) { return 0}
			return _stream.soundTransform.volume;
		}
		
		public function get  isPlaying():Boolean {
			return _isPlaying;
		}
		
		public function get loadPercent() :Number{
			return _loadedPercent;
		}
		
		public function get  totalTime():Number {
			return _videoDuration;
		}
		public function get currentTime():Number {
		
			if (_stream != null) {
				return _stream.time;
			}
			return 0;
		}
		
		
		protected function smoothVolume(e:Event):void {
			_soundTransform.volume += (_targetVolume-_soundTransform.volume) * _volumeSpeed;
			_stream.soundTransform = _soundTransform
			if (_targetVolume>= _preVolume && _soundTransform.volume >= _targetVolume) {
				this.addEventListener(Event.ENTER_FRAME,smoothVolume)
			}else if (_targetVolume<= _preVolume && _soundTransform.volume <= _targetVolume) {
				this.addEventListener(Event.ENTER_FRAME,smoothVolume)
			}
		}
		
		protected function onNetStatusHandler(e:NetStatusEvent):void
		{
		
			switch (e.info.code)
			{
				case "NetConnection.Connect.Success" :

					initData()
					break;
				case "NetConnection.Connect.Rejected" :
					sendError(e)
					break;
				case "NetConnection.Connect.InvalidApp" :
					sendError(e)
					break;
				case "NetConnection.Connect.Failed" :
					sendError(e)
					break;
				case "NetConnection.Connect.AppShutDown" :
					sendError(e)
					break;
				case "NetConnection.Connect.Closed" :
					
					break;
					
				case "NetConnection.Connect.Stop" :
						
					break;
			}
		}
		
		protected function sendError(e:NetStatusEvent):void {
			if(onError!=null){
				onError();
			}
			dispatchEvent(e);
		}
		
		protected function initData(steam:NetStream=null):void {
			trace("init data")
			if(steam==null)
			_stream = new NetStream(_connet)
			else _stream = steam;
			
			_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			_stream.addEventListener(NetStatusEvent.NET_STATUS, onNs_NetStatusHandler);

			_nsClient={}
			_nsClient.onMetaData = onMetaData
			_nsClient.onCuePoint = cuePointCallback;
			_stream.client=_nsClient
			_video = new Video();
			_video.attachNetStream(_stream);
			
			addChild(_video);
			
			_soundTransform = new SoundTransform();
			

		}
		protected function cuePointCallback(data:Object):void {
			if(onCuePoint!=null) onCuePoint(data)
		}
		protected function asyncErrorHandler(event:AsyncErrorEvent):void
		{
                trace("asyncErrorHandler:"+event)
		}
		public function onMetaData(obj:Object) :void {
			if (_inited) {
				return
			}
			_inited=true
			_videoWidth = obj.width;
			_videoHeight = obj.height;
			_videoDuration=obj.duration
			
			_video.width = _videoWidth;
			_video.height = _videoHeight;
			trace("onMetaData")
			 _bg.width = _videoWidth;
			 _bg.height = _videoHeight;
			if (onInited != null) {
				onInited(obj);
			}
			
		}
		
		
		
		protected function onNs_NetStatusHandler(e:NetStatusEvent):void
		{
			
			if(e.info.code=="NetStream.Play.Stop"){
				_isPlaying = false;
				
			 
				if (onPlayCompleted != null) {
					onPlayCompleted();
				}
			}
			
			if (e.info.code=="NetStream.Seek.InvalidTime") {
				
			}
			dispatchEvent(e.clone());
		}
	
		
		
		
		
		
		private  function checkProgress():void {
			this.addEventListener(Event.ENTER_FRAME,onProgress)
		}
		
		private function stopCheckProgress():void {
			this.removeEventListener(Event.ENTER_FRAME,onProgress)
		}
		
        private function onProgress (e:Event) : void {
			if ( _stream.bytesTotal > 4)     {
					_loadedPercent = _stream.bytesLoaded /  _stream.bytesTotal ;
					if (_loadedPercent >= 1) {
						stopCheckProgress();
						if (onLoaded != null) {
							onLoaded()
						}
						
					}
			}
			if (onLoadProgress != null) {
				onLoadProgress()
			}
        }

	}

}