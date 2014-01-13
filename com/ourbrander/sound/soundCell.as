package com.ourbrander.sound 
{
 
	import com.ourbrander.debugKit.itrace;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	import flash.net.URLRequest
	import flash.system.Capabilities
	 
	
	/**
	 * ...
		 * @author liuyi,if you want find more help doucment or anything else,you can visit my blog:www.ourbrander.com or send me email:contact@ourbrander.com
	liuyi
	 */
	dynamic public class SoundCell extends EventDispatcher
	{   
		private var _hasSoundCard:Boolean=true
		protected var _id:String
		protected var _url:String
		protected var _sound:Sound
		protected var _chanel:SoundChannel
		protected var _pausePosition:Number=0
		protected var _playing:Boolean = false
		protected var _timer:Timer = new Timer(300, 0)
		protected var _defultVolume:Number = 0.75
		protected var _volume:Number  
		protected var _pauseVolume:Number=-1
		protected var _igoreState:Boolean = true
		protected var _type:String
		public static const TYPE_DEFALUT:String = "default";
		public static const TYPE_EFFECT:String = "effect";
		 
		
		public function SoundCell($id:String="",$url:String="",$sound:Sound=null,$chanel:SoundChannel=null,type:String="default") 
		{
			 
			init($id,$url,$sound,$chanel)
		}
		
		private function init ($id:String = "", $url:String = "", $sound:Sound = null, $chanel:SoundChannel = null,$type:String="default"):void  {
			 
			if (Capabilities.hasAudio==false) {
				_hasSoundCard=false
			}
			if ($id!="") {
				id = $id
			}
			
			if($url!=""){
				url = $url
				
			}
			if($sound!=null){
				sound = $sound
			}
			if($chanel!=null){
				chanel = $chanel
			}
			
		    _timer.addEventListener(TimerEvent.TIMER, timerHappend)
			
			type = $type;
			if(type==TYPE_DEFALUT)
				defultVolume = SoundManager.defaultVolume
			else if (type == TYPE_EFFECT) defultVolume = SoundManager.effectVolume
			_volume = defultVolume;
		}
		
		public function get type():String {
			return _type
		}
		
		public function set type(t:String):void {
			_type = t;
		}
		
		public function set id($id:String):void {
			this._id=$id
		}
		public function get id():String {
			return _id
		}
		
		private function set url($url:String) :void{
			if ($url!="") {
				this._url=$url
			}
		}
		
		private function get url():String {
			return this._url
		}
		
		public function set sound($sound:Sound) :void{
			 if (_hasSoundCard==false) {
				 return 
			 }
			
			_sound = $sound
			if (_url!=""||_url!=null) {
				loadSound()
			}
			
		}
		
		public function get sound():Sound {
			  
		 
			return _sound
		}
		
		public function get isPlaying():Boolean {
		
			return _playing
		}
		
		public function set defultVolume(vol:Number):void {
			if (vol<0) {
				_defultVolume=0
			}else if(vol>1){
				_defultVolume=1
			}else {
				_defultVolume=vol
			}
			
		}
		public function get defultVolume():Number {
			return 	_defultVolume
		}
		public function set chanel ($chanel:SoundChannel) :void{
	 
				
				if (_chanel != null) {
					_chanel.stop()
					if(_chanel.hasEventListener(Event.SOUND_COMPLETE)){
						_chanel.removeEventListener(Event.SOUND_COMPLETE, completed);
					}
					_chanel=null
				}
				
				_chanel = $chanel
				if(_chanel!=null)
				_chanel.addEventListener(Event.SOUND_COMPLETE, completed);
			 
		}
		
		public function get chanel():SoundChannel {
 
			return _chanel
		}
		
		public function set pausePosition(position:Number) :void{
			_pausePosition=position
		}
		
		public function get pausePosition():Number {
		
			return _pausePosition
		}
		public function set volume(v:Number):void {
			  
			if (v > 1) v=1
			if (v < 0)v=0
			
			_volume = v
			if (_chanel != null) {
				var s:SoundTransform=_chanel.soundTransform
				s.volume = v
				_chanel.soundTransform=s
			 
			}
		}
		
		public function get volume():Number {
			
			if(_chanel!=null){
				return  _chanel.soundTransform.volume
			}else {
				return _volume
			}
		}
		public function pause() :void{
			  
		 
			_playing = false;
			if (_chanel !=null) {
				 pausePosition = chanel.position;
				 _pauseVolume = _chanel.soundTransform.volume;
				  chanel.stop();
				 
			}
			 chanel=null
		}
		public function stop():void {
			 
			    _playing == false
				 if(_chanel!=null){
					 pausePosition =0
					 _pauseVolume=_chanel.soundTransform.volume
					 chanel.stop();
				 }
			 chanel=null
		}
		public function play($positon:Number=-1,$loop:int=0,$sndTransform:SoundTransform=null):void {
		   //  checkSoundState()
		   //  if(_chanel!=null)
			// itrace(_id+":   "+chanel.soundTransform.volume.toString(),"_playing"+_playing+"  chanel.position:"+chanel.position.toString())
			//	if (_playing && ($positon < 0)) return 
				if (_playing == false) {
					pausePosition=($positon<0)?pausePosition:$positon	
				}else if(_chanel!=null) {
					pausePosition = chanel.position
					pausePosition = ($positon < 0)?pausePosition:$positon;
				}
				
			_playing = true;
			 chanel = sound.play(pausePosition, $loop, $sndTransform);
	
			if (_pauseVolume<0) {
				if ($sndTransform == null)  volume=_defultVolume	
				 else volume=$sndTransform.volume
			}else {
				volume=_pauseVolume
			}
			  
		}
		public function checkSoundState() :void{
			 
			 return;
			var timer:Timer = new Timer(50, 1)
			 
			try {
				if (chanel!=null) {
					timer.addEventListener(TimerEvent.TIMER, checkSoundResult)
					timer.start()
					var soundPosition:Number = chanel.position
				}else {
					_playing=false
				}
			}catch (e:Error) {
				// trace("checkSoundState:"+e)
			}
			 
				 function checkSoundResult() :void{
					timer.stop()
					timer.removeEventListener(TimerEvent.TIMER, checkSoundResult)
					if (soundPosition!=chanel.position) _playing=false	
					else _playing=true					
				 
				}//end function
			
		
		}//end function
		
		public function close() :void{
			 if (_hasSoundCard==false)  return  
			if (_url != "") _sound.close()

		}
		
		
		public function destory():void {
			_sound = null
			_chanel = null
	
		}
		public function get bytesLoaded():Number {
			if (_sound != null) return _sound.bytesLoaded
			
			return 0;
		}
		
		public function get bytesTotal():Number {
			if (_sound != null) return _sound.bytesTotal
			return 0;
		}
		
		public function get position():Number {
			if (_chanel != null) return _chanel.position;
			return 0;
			
		}
		
		public function get duration():Number {
			if (_sound != null) return _sound.length
			
			return 0;
		}
		
		private function completed(e:Event):void {
			 _pausePosition = 0
			_playing = false;
			
			dispatchEvent(new Event(Event.SOUND_COMPLETE,true));
		
		}
		
		private function timerHappend(e:TimerEvent) :void{
			try{
				if(chanel.soundTransform.volume<=0||chanel.soundTransform.volume>=_defultVolume) _timer.stop()
			}catch (e:Error) {
				
			}
		}
		
		private function loadSound() :void{
			 if (_hasSoundCard==false)  return  
			if (_url!=null) {
				_sound.addEventListener(Event.COMPLETE,soundLoaded)
				_sound.addEventListener(IOErrorEvent.IO_ERROR, loadError)
			 
				_sound.load(new URLRequest(_url))
			}
		}
		
		private function soundLoaded(e:Event):void {
		 
			dispatchEvent(new Event(Event.COMPLETE,true));
		}
		private function loadError(e:IOErrorEvent) :void{
			trace("sound cell loadError:\n"+e+"\n url:"+_url)
		}
		
		 
		
	}
	
}