package com.ourbrander.webObj.component.switchBox 
{
	import com.ourbrander.xmlObject.xmlFrame;
	import fl.transitions.Blinds;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.events.ProgressEvent
	import flash.geom.Rectangle;
	import com.ourbrander.webObj.component.switchBox.switchStyle;
	import flash.utils.Timer;
	import flash.events.MouseEvent
	import flash.net.navigateToURL;
    import flash.net.URLRequest;

	/**
	 * ...
	 * @author liuyi url:www.ourbrander.com email:contact@ourbrander.com
	...
	 */
	public class switchBox extends MovieClip
	{   
		//data
		private var _source:xmlFrame = new xmlFrame()
		//attributes
		private var _width:Number = 0
		private var _height:Number = 0
		private var _currentIndex:uint = 0
		private var _switchTime:uint = 3000
		private var _switchStyle:switchStyle
		private var _direction:Number=1
		private var _timer:Timer=new Timer(_switchTime,0)
		
		//event
		public static const STOP_SWITCH = "stop_switch"
		public static const PLAY_SWITCH = "play_switch"
		public static const SWITCH_COMPELETE="switch_compelete"
		public static const ALLIMAGES_LOADED="allImages_loaded"
		//state
		private var _isPlaying:Boolean = false
		private var _autoPlay:Boolean = true
		
		//loader
		//private var loader:Loader = new Loader()
		private var _loaderArray:Array = new Array()
		private var _contentArray:Array = new Array()
		private var _currentLoadIndex
		private var _target_mc:MovieClip
		private var _mask:MovieClip
		private var _container:MovieClip
		private var _LoadingStyle:Class
		private var _rectangle:Rectangle
		
		//tempValue
		private var _$index:uint = 0
		private var _$preIndex:uint = 0
		
		public var _firstLoad = true
		public var loadedbytes=0
		public var totalbytes=1

		public var allimagesLoaded:Boolean=false
		
		
		
		public function switchBox($source:xmlFrame = null,$target_mc=null,$switchTime:uint=2000,$autoPlay:Boolean=true,$currentIndex=0 ) 
		{
			addEventListener(Event.REMOVED_FROM_STAGE,removedFromStage)
			init($source, $target_mc, $switchTime, $autoPlay, $currentIndex)
			 
		}
		
		private function init($source:xmlFrame = null,$target_mc=null,$switchTime:uint=2000,$autoPlay:Boolean=true,$currentIndex=0 ) {
			source = $source
			switchTime = $switchTime
			autoPlay = $autoPlay
			currentIndex = $currentIndex
			_currentLoadIndex=currentIndex
			target_mc = $target_mc
			
			target_mc.addChild(this)
			
			createContainer() //init the main container
			createMask()//init the mask for contentBox
			
			createContentFrame()//init content Boxes
			
			loadContent()//start load the content
		}
		
		private function addtoStage(e:Event) {
			
		}
		private function removedFromStage(e:Event) {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			_source.dispose();
			_source = null
			_switchStyle = null
			_target_mc = null
			_mask = null
			_container = null
			_LoadingStyle = null
			
			try{
			_timer.removeEventListener(TimerEvent.TIMER, autoPlayHandel)
			}catch(e){}
			_timer.stop()
			_timer=null
			
			for (var i = 0; i < _loaderArray.length;i++ ) {
				_loaderArray[i].contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgress)
				_loaderArray[i].contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError)
				try{
				_loaderArray[i].close()
				}catch (e) { }
				try{
				_loaderArray[i].unload()
				}catch(e){}
				_loaderArray[i]=null
			}
			_loaderArray = null
			
			
		}
		public function set source(xmlframe:xmlFrame) {
			_source=xmlframe
		}
		public function get source():xmlFrame {
			return _source
		}
		public function set switchTime(vale:uint) {
			_switchTime = vale
			_timer.delay=_switchTime
		}
		public function get switchTime():uint {
			return _switchTime
		}
		public function set autoPlay(value:Boolean) {
			_autoPlay=value
		}
		public function get autoPlay():Boolean {
			return _autoPlay
		}
		public function get currentIndex() {
			return _currentIndex
		}
		public function set currentIndex($val:uint) {
			
			_currentIndex=$val
		}
		
		private function set isPlaying(value:Boolean) {
			_isPlaying=value
		}
		
		private function get isPlaying():Boolean {
			return _isPlaying
		}
		
		private function get Length() {
			return source.xml.child("*").length()
		}
		
		private function set target_mc($target:MovieClip) {
			_target_mc=$target
		}
		private function get target_mc():MovieClip {
			return _target_mc
		}
		
		public function switchTo() {
			
		}
		private function loadContent(event = null) {
			
			var $path = source.xml.child(_currentLoadIndex).content 
			var loader:Loader = new Loader()
			loader.name="loader"+_currentLoadIndex
			//trace("switch loader $path:"+$path)
			
			
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgress)
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioError)
			_loaderArray.push(loader)
			loader.load(new URLRequest($path))
			
		}
		private function ioError(e:IOErrorEvent) {
			trace("switchbox load error:"+e)
		}
		private function loadProgress(event = null ) {
		   if (_firstLoad==true) {
				loadedbytes = event.bytesLoaded 
				totalbytes=event.bytesTotal
			}
			var bytesloaded = event.bytesLoaded 
			var toalBytes = event.bytesTotal
			
			var p = Math.floor((bytesloaded / toalBytes) * 100)
			
			 
		    if(_LoadingStyle!=null){
				var loadingBar=_contentArray[_currentLoadIndex].getChildByName("loadingBar")
				if ( loadingBar == undefined) {
					
				   loadingBar = new _LoadingStyle()
				   loadingBar.name = "loadingBar"
				   loadingBar.id=_currentLoadIndex
				   loadingBar.x = (target_mc.width - loadingBar.width) * 0.5
				   loadingBar.y=(target_mc.height-loadingBar.height)*0.5
				   _contentArray[_currentLoadIndex].addChild(loadingBar)
				  
				}
				loadingBar = _contentArray[_currentLoadIndex].getChildByName("loadingBar")
				loadingBar.gotoAndStop(p)
				loadingBar._txt.text = _currentLoadIndex + " loading:" + p + "%"
				if (p >= 100) {
					_contentArray[_currentLoadIndex].removeChild(loadingBar)
					 
				}
			}
			
			if (p >= 100) {
				 
					loaded()
				}
				
		}
 
		private function loaded(event = null) {
			if (_firstLoad==true) {
				_firstLoad = false
				//trace("1st bg loaded")
			}
		//   trace("_loaderArray[_currentLoadIndex]:"+_loaderArray[_currentLoadIndex]+"/_currentLoadIndex:"+_currentLoadIndex+"/_loaderArray.lenght:"+_loaderArray.length)
			 _contentArray[_currentLoadIndex].addChild(_loaderArray[_currentLoadIndex])
			  //trace("_currentLoadIndex "+_currentLoadIndex+"  loaded........")
			 _currentLoadIndex++
			if (_currentLoadIndex<Length) {
				loadContent()
			}else {
				 
				//startAutoPlay()
				allimagesLoaded=true
				var event = new Event(ALLIMAGES_LOADED, true)
				dispatchEvent(event)
				 
			}
		}
		private function createMask() {
			_mask = new MovieClip()
			_mask.x = 0
			_mask.y = 0
			_mask.graphics.beginFill(0x000000)
			_mask.graphics.drawRect(0, 0, target_mc.width, target_mc.height)
			 addChild(_mask)
			_container.mask = _mask
			_rectangle=new Rectangle(0,0,target_mc.width, target_mc.height)
		}
		
		private function createContainer() {
			_container = new MovieClip()
		
			_container.x = 0
			_container.y = 0
			addChild(_container)
			
			
		}
		private function createContentFrame() {
			 
			for (var i = 0; i < Length;i++ ) {
				var content_mc = new MovieClip()
				content_mc.x = target_mc.width*i
				content_mc.y = 0
				content_mc.id = i
				content_mc.name="content_mc"+content_mc.id 
				if (currentIndex!=content_mc.id) {
					content_mc.visible=false
				}
				if (source.xml.child(content_mc.id).link != undefined) {
					content_mc.buttonMode = true; 
					 
					content_mc.addEventListener(MouseEvent.CLICK, function(e = null) { navigateToURL(new URLRequest(source.xml.child(content_mc.id).link), "_bank"); } )
					 
					
				}
				_container.addChild(content_mc)
				_contentArray.push(content_mc)
			}
		}
		
		public function setLoadingStyle($className:Class) {
			_LoadingStyle=$className
		}
		
		private function switchContent($index:uint) {
			if (isPlaying==false) {
			isPlaying=true
			 var $preContainer = _contentArray[currentIndex]
			 var $nextContainer = _contentArray[$index]
			 $nextContainer.visible = true
			 
			 _switchStyle.switchTo($preContainer, $nextContainer, _rectangle)
			 _switchStyle.addEventListener(switchStyle.SWICTH_COMPELETE, switchEnded)
			_$index = $index
			_$preIndex = currentIndex
			var target:*=_contentArray[$index].getChildAt(0).content 
			if (target is MovieClip) {
				trace(target._mc)
				target._mc.gotoAndPlay(2)
			}
			var event = new Event(PLAY_SWITCH, true)
			dispatchEvent(event)
			}
			 
		}
		
		private function switchEnded(e=null) {
			 currentIndex = _$index
			 isPlaying = false
			 var preMc = _contentArray[_$preIndex]
			 preMc.visible=false
		}
		public function toNext() {
			var $num=currentIndex+1
			if ($num>=Length) {
				return false
			}
			switchContent($num)
		}
		public function toPrev() {
			var $num:Number=currentIndex-1
			if ($num<0) {
				return false
			}
			switchContent($num)
		}
		public function set switch_Style(obj:*) {
			_switchStyle=obj
			
		}
		public function get switch_Style():String {
			return _switchStyle.styleName
			
		}
		public function startAutoPlay() {
			_timer.start()
			_timer.addEventListener(TimerEvent.TIMER,autoPlayHandel)
		}
		
		public function stopAutoPlay() {
			_timer.removeEventListener(TimerEvent.TIMER,autoPlayHandel)
			_timer.stop()
		}
		public function setDirection($val:Number) {
			if ($val!=1 && $val!=-1) {
			   //trace("warn:direction only can set to -1 or 1" + "   val:" + $val)
			  // trace($val==1)
			   return false
			}
			_direction=$val
		}
		public function getDirection() {
			return _direction
		}
		private function autoPlayHandel(event = null) {
			//trace("autoPlayHandel")
		
			var $index = currentIndex + getDirection()
			
			if ($index >= Length) {
				$index=0
			}
			
			if ($index < 0) {
				$index = Length-1
				
			}
			try{
				switchContent($index)
			}catch (e) {
				trace("switchContent e:"+e)
			}
		}
	}
	
}