package com.ourbrander.sound 
{
 
	import com.ourbrander.sound.soundEvent
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound
	import flash.media.SoundChannel
	import flash.media.SoundTransform;
	import flash.utils.getDefinitionByName
	import flash.media.SoundMixer
	import com.greensock.TweenLite
	
	/**
	 * ...
		 * @author liuyi,if you want find more help doucment or anything else,you can visit my blog:www.ourbrander.com or send me email:contact@ourbrander.com
	liuyi
	update function setVolume date:2010/07/09
	 */
	dynamic public class soundManager extends EventDispatcher
	{
		private var _allowPlay:Boolean = true
		private var _soundArr:Array = new Array()
		private var _mute:Boolean
		private static var _soundManager:soundManager
		private var _videoSound:Boolean=false
		public function soundManager() :void
		{
			//trace("init soundManager")
			if (soundManager._soundManager != null) {
				return 
			}
			_soundManager = this;
			_mute = false;
		}
		
		public static function getInstance():soundManager {
			
			if(_soundManager==null){
				return new soundManager();
			}else {
				return _soundManager;
			}
		}
	
		public function init() {
			
		}
		public function playSound($id:String="", $positon:Number = -1, $loop:int = 0, $sndTransform = null,igoreState:Boolean=true) {
			var default_sndTransform:SoundTransform;
			if ($sndTransform == null) {
					if (_mute==false) {
						default_sndTransform=new SoundTransform(0.75)
					}else {
						default_sndTransform=new SoundTransform(0)
					}
					
				}else {
						default_sndTransform=$sndTransform
					if (_mute==true) {
						default_sndTransform.volume=0
					}
				
			}
				
			if ($id!="") {
				var sound_cell:soundCell = getSoundById($id)
				if (sound_cell == null ) {
						return 
				}
				if (sound_cell.isPlaying == false) {
						sound_cell.play($positon, $loop, default_sndTransform, igoreState)
				}else if(sound_cell.isPlaying == true ) {
					if(igoreState==false){
						trace("sound manager playSound:sound is playing ,can not start it,because igoreState is false.")
					}else {
						sound_cell.play($positon, $loop, default_sndTransform, igoreState)
					}
				}
			}else {
				 for each(var cell in _soundArr) {
					 cell.play($positon,$loop,default_sndTransform,igoreState)
					 
				 }
			}
		}
		
		public function stopSound($id:String = "") {
		 
			if($id!=""){
				  var sound_cell:soundCell = getSoundById($id)
				 if (sound_cell == null ) {
					 
					 return 
				 }
				 
				 sound_cell.stop()
			}else {
				 for each(var cell in _soundArr) {
					 cell.stop()
					 
				 }
			}
		}
		
		public function puaseSound($id:String = "") {
			 
			if($id!=""){
				var sound_cell:soundCell = getSoundById($id)
					 if (sound_cell == null ) {
						  
							 return 
					 }
					 
					sound_cell.puase()
			}else {
					 for each(var cell in _soundArr) {
					 cell.puase()
					}
			}
		}
		
		public function closeSound($id:String = "") {
			if ($id != "") {
				
				var sound_cell:soundCell = getSoundById($id)
					 if (sound_cell == null ) {
							 return 
					 }
					sound_cell.close()
			}else {
				 for each(var cell in _soundArr) {
					 cell.close()
					}
			}
		}
		 
		public function removeSound($id:String = "") {
			 if ($id != "") {
				 var sound_cell:soundCell = getSoundById($id)
					 if (sound_cell == null ) {
							 return 
					 }
					sound_cell.destory()
			 }else {
				 for each(var cell in _soundArr) {
					 cell.destory()
					}
			 }
		}
		
		public function setVolume(value:Number, $id:String = "",fade:Number=0.6) {
			if (mute==true || videoSound==true) {
				value=0
			}
		    if($id!=""){
				var sound_cell:soundCell = getSoundById($id)
				 if (sound_cell == null ) {
					 return 
				 }
				 //sound_cell.volume = value
				 TweenLite.to(sound_cell,fade,{volume:value})
			}else {
				 for each(var cell in _soundArr) {
					// cell.volume=value
					 TweenLite.to(cell, fade, { volume:value } )
			
				 }
				 
			}
			
		}
		
		//@come soon!
		public function offsetVolume(value:Number) {
			
		}
		
		public function set  mute(b:Boolean) {
		 	trace("set mute",b)
			 
			_mute = b;
		}
		public function get mute():Boolean {
			//	trace("get mute",_mute)
			return _mute;
		}
		
		public function set videoSound(b:Boolean):void {
			_videoSound = b
			dispatchEvent(new soundEvent(soundEvent.VIDEO_PLAYING))
		}
		
		public function get videoSound():Boolean {
			return _videoSound
		}
		
	 
		public function getSoundById($id:String):soundCell {
			var _cell:soundCell = null
		 
			 for (var i = 0; i < _soundArr.length; i++ ) {
				 var cell:soundCell = _soundArr[i] as soundCell
			 
					if (cell.id == $id) {
						_cell = cell
					 
						return _cell
					}
			 }
		 
			 return _cell
		 
		}
		
		public function addSoundByClass($id:String,classname:String) {
		//	trace("classname:" + classname + "   id:" + $id)
			var soundClass:Class = getDefinitionByName(classname)  as  Class
			var sound:Sound=new soundClass()
		    var sound_cell:soundCell = new soundCell($id)
			sound_cell.sound = sound
			_soundArr.push(sound_cell)
			
			
		}
		
		public function addSoundByPath($id:String,link:String) {
			var sound:Sound=new Sound()
		    var sound_cell:soundCell = new soundCell($id, link, sound)
			_soundArr.push(sound_cell)
		}
		
		public function addSoundByObj($id,target:Sound):void {
			  var sound_cell:soundCell = new soundCell($id, "", target);
			  _soundArr.push(sound_cell)
		}
		
		public function addSoundByStream($id:String,sd:Sound,sc:SoundChannel=null) {
			
		}
		
		private function setSoundChanel($id:String) {
			
		}
		
		
		
	}
	
}