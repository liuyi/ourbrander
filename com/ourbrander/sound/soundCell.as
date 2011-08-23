package com.ourbrander.sound 
{
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
	dynamic public class soundCell extends EventDispatcher
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
		protected var _puaseVolume:Number
		protected var _igoreState:Boolean = true
		 
		
		public function soundCell($id:String="",$url:String="",$sound:Sound=null,$chanel:SoundChannel=null) 
		{
			 
			init($id,$url,$sound,$chanel)
		}
		
		private function init ($id:String = "", $url:String = "", $sound:Sound = null, $chanel:SoundChannel = null)  {
			 
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
			_volume = 0;
			 
			 
		}
		
		public function set id($id:String) {
			this._id=$id
		}
		public function get id():String {
			return _id
		}
		
		private function set url($url:String) {
			if ($url!="") {
				this._url=$url
			}
		}
		
		private function get url():String {
			return this._url
		}
		
		public function set sound($sound:Sound) {
			 if (_hasSoundCard==false) {
				 return false
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
		
		public function set defultVolume(vol:Number) {
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
		public function set chanel ($chanel:SoundChannel) {
	 
				
				if (_chanel != null) {
					_chanel.stop()
					if(_chanel.hasEventListener(Event.SOUND_COMPLETE)){
						_chanel.removeEventListener(Event.SOUND_COMPLETE, completed);
					}
					_chanel=null
				}
				
				_chanel = $chanel
				_chanel.addEventListener(Event.SOUND_COMPLETE, completed);
			 
		}
		
		public function get chanel():SoundChannel {
			
			var k = _chanel
			return k
		}
		
		public function set pausePosition(position:Number) {
			_pausePosition=position
		}
		
		public function get pausePosition():Number {
		
			return _pausePosition
		}
		public function set volume(v:Number) {
			  
			if (v > 1) {
				v=1
			}
			if (v < 0) {
				v=0
			}
			
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
		public function puase() {
			  
			 try {
				
				if (_playing == true) {
					_playing = false;
					 pausePosition = chanel.position;
					 _puaseVolume = _chanel.soundTransform.volume;
					 chanel.stop();
					 
				}
			 }catch (e) {
				 trace(_id+" sound cell puase error:"+e)
			 }
		}
		public function stop() {
			 
			 
			 try {
				 if(chanel!=null){
					if (_playing == true) {
						_playing = false
						 pausePosition =0
						 _puaseVolume=_chanel.soundTransform.volume
						 chanel.stop()
						  
					}else {
						 
						 pausePosition =0
						 _puaseVolume=_chanel.soundTransform.volume
						 chanel.stop()
					}
				 }
			 }catch (e) {
				 trace(_id+" sound cell stop error:"+e)
			 }
		}
		public function play($positon:Number=-1,$loop:int=0,$sndTransform:SoundTransform=null,igoreState:Boolean=true) {
		     checkSoundState()
			 try{
				if (_playing == false) {
				 	
					_playing = true;
					
					 pausePosition=($positon<0)?pausePosition:$positon
					 chanel = sound.play(pausePosition, $loop, $sndTransform)
					// volume = (isNaN(_puaseVolume))?_volume:_puaseVolume
					if (isNaN(_puaseVolume)) {
					 
						if ($sndTransform == null) {
							
						 
						
							volume = _defultVolume;
						}else {
								 
							volume=$sndTransform.volume
						}
					}else {
					 
						volume=_puaseVolume
					}
					
				}else if (igoreState == true) {
					 
					_playing = true
					
					pausePosition=($positon<0)?pausePosition:$positon
					chanel = sound.play(pausePosition, $loop, $sndTransform)
					if (isNaN(_puaseVolume)) {
					 
						if ($sndTransform == null) {
							
						 
						
							volume=_volume
						}else {
							 
							volume=$sndTransform.volume
						}
					}else {
							 
						volume=_puaseVolume
					}
					
					/*if($sndTransform==null){
						volume = (isNaN(_puaseVolume))?_volume:_puaseVolume
					}*/
				}else if(igoreState==false) { 
					//	trace("warn:"+_id+" are playing.you can't play it again!")
				}
			 }catch (e) {
				 trace("sound cell play error:" + e);
				 	_playing = false;
			 }
			  
		}
		public function checkSoundState() :void{
			 
			return ;
			var timer:Timer = new Timer(50, 1)
			 
			try {
				if (chanel!=null) {
					timer.addEventListener(TimerEvent.TIMER, checkSoundResult)
					timer.start()
					var soundPosition:Number = chanel.position
				}else {
					_playing=false
				}
			}catch (e) {
				// trace("checkSoundState:"+e)
			}
			 
				 function checkSoundResult() {
					  
					timer.stop()
					 
					timer.removeEventListener(TimerEvent.TIMER, checkSoundResult)
					 
					if (soundPosition!=chanel.position) {
							_playing=false
					}else {
							_playing=true
					}
				 
				}//end function
			
		
		}//end function
		
		public function close() {
			 if (_hasSoundCard==false) {
				 return false
			 }
			if (_url != "") {
				_sound.close()
				
			}
			
		}
		
		
		public function destory() {
			_sound = null
			_chanel = null
			 
			 
		}
		public function get bytesLoaded():Number {
			if (_sound != null) {
				return _sound.bytesLoaded
			}
			
			return 0;
		}
		
		public function get bytesTotal():Number {
			if (_sound != null) {
				return _sound.bytesTotal
			}
			return 0;
		}
		
		public function get position():Number {
			if (_chanel != null) {
				return _chanel.position;
			}
			return 0;
			
		}
		
		public function get duration():Number {
			if (_sound != null) {
				return _sound.length
			}
			
			return 0;
		}
		
		private function completed(e:Event) {
			 _pausePosition = 0
			_playing = false;
			
			dispatchEvent(new Event(Event.SOUND_COMPLETE,true));
		
		}
		
		private function timerHappend(e:TimerEvent) {
			try{
				if(chanel.soundTransform.volume<=0||chanel.soundTransform.volume>=_defultVolume){
					_timer.stop()
				}
			}catch (event) {
				
			}
		}
		
		private function loadSound() {
			 if (_hasSoundCard==false) {
				 return false
			 }
			if (_url!=null) {
				_sound.addEventListener(Event.COMPLETE,soundLoaded)
				_sound.addEventListener(IOErrorEvent.IO_ERROR, loadError)
			 
				_sound.load(new URLRequest(_url))
			}
		}
		
		private function soundLoaded(e:Event) {
			//trace("soundLoaded:")
			//chanel=_sound.play()
			dispatchEvent(new Event(Event.COMPLETE,true));
		}
		private function loadError(e:IOErrorEvent) {
			trace("sound cell loadError:\n"+e+"\n url:"+_url)
		}
		
		 
		
	}
	
}