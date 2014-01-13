package com.ourbrander.sound 
{
 
	import com.ourbrander.sound.SoundEvent
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
	dynamic public class SoundManager extends EventDispatcher
	{
		private var _allowPlay:Boolean = true
		private var _sounds:Vector.<SoundCell> 
		private var _mute:Boolean
		private static var _soundManager:SoundManager
		private var _videoSound:Boolean = false
		public static var effectVolume:Number = 1;
		public static var defaultVolume:Number=0.7
		public function SoundManager() :void
		{
			//trace("init soundManager")
			if (SoundManager._soundManager != null) return 
			_soundManager = this;
			_mute = false;
			_sounds = new Vector.<SoundCell>();
		}
		
		public static function getInstance():SoundManager {
			
			if(_soundManager==null) new SoundManager();
		
			return _soundManager;
			
		}
	
		 
		public function playSound($id:String="", $positon:Number = -1, $loop:int = 0, $sndTransform:SoundTransform = null) :void{
			var default_sndTransform:SoundTransform;
			if ($sndTransform == null) {
				if (_mute) default_sndTransform = new SoundTransform(0);
			}else {
				default_sndTransform=$sndTransform
				if (_mute) default_sndTransform.volume=0
			}
				
			if ($id!="") {
				var cell:SoundCell = getSoundById($id)
				if (cell == null ) throw new Error("playSound: can not find this sound:"+$id); 
				    cell.play($positon, $loop, default_sndTransform)
				
			}else {
				 for each( cell in _sounds) 
					 cell.play($positon,$loop,default_sndTransform)
				 
			}
		}
		
		public function stopEffect(fade:Number=0.6):void {
			 for each( var cell:SoundCell  in _sounds) {
				 if(cell.type==SoundCell.TYPE_EFFECT)
					 TweenLite.to(cell, fade, { volume:0, onComplete:onComplete, onCompleteParams:[cell] } );
			 }
			function onComplete(target:SoundCell):void {
				target.stop();
			}
		}
		
		public function stopSound($id:String = "",fade:Number=0.6):void {
		 
			if($id!=""){
				var cell:SoundCell = getSoundById($id);
				if (cell == null ) throw new Error("stopSound: can not find this sound:" + $id); 
				if (fade == 0) cell.stop();
				else 
				TweenLite.to(cell, fade, { volume:0,onComplete:onComplete,onCompleteParams:[cell] } );
			
			}else {
				 for each( cell in _sounds) {
					 if (fade == 0) cell.stop()
					 else
					     TweenLite.to(cell, fade, { volume:0, onComplete:onComplete, onCompleteParams:[cell] } );
				 }
			}
			
			function onComplete(target:SoundCell):void {
				target.stop();
			}
			 
		}
		
		
		
		public function pauseSound($id:String = "",fade:Number=0.6):void {
			 
			if($id!=""){
				var cell:SoundCell = getSoundById($id);
				if (cell == null ) throw new Error("pauseSound: can not find this sound:"+$id); 
				TweenLite.to(cell, fade, { volume:0,onComplete:onComplete,onCompleteParams:[cell] } );
			}else {
				for each( cell  in _sounds)  TweenLite.to(cell, fade, { volume:0,onComplete:onComplete,onCompleteParams:[cell] } );
			}
			
			function onComplete(target:SoundCell):void {
				target.pause();
			}
		}
		
		public function closeSound($id:String = "",fade:Number=0.6):void {
			if ($id != "") {
				
				var cell:SoundCell = getSoundById($id);
					if (cell == null ) throw new Error("closeSound: can not find this sound:"+$id); 
				TweenLite.to(cell, fade, { volume:0,onComplete:onComplete,onCompleteParams:[cell] } );
			}else {
				 for each( cell  in _sounds) TweenLite.to(cell, fade, { volume:0,onComplete:onComplete,onCompleteParams:[cell] } );
					
			}
			
			function onComplete(target:SoundCell):void {
				target.close();
			}
		}
		 
		public function removeSound($id:String = ""):void {
			 if ($id != "") {
				 var cell:SoundCell = getSoundById($id)
					 if (cell == null )  return 
					cell.destory()
			 }else {
				 for each( cell in _sounds)  cell.destory()
			 }
		}
		
		public function setVolume(value:Number, $id:String = "",fade:Number=0.6):void {
			if (mute==true || videoSound==true) 	value=0
		    if($id!=""){
				var cell:SoundCell = getSoundById($id)
				 if (cell == null )  return 
				 TweenLite.to(cell,fade,{volume:value})
			}else {
				 for each( cell  in _sounds)  TweenLite.to(cell, fade, { volume:value } )
				 
			}
			
		}
		
		//@come soon!
		public function offsetVolume(value:Number) :void{
			
		}
		
		public function set  mute(b:Boolean):void {
			_mute = b;
		}
		public function get mute():Boolean {
			return _mute;
		}
		
		public function set videoSound(b:Boolean):void {
			_videoSound = b
			dispatchEvent(new SoundEvent(SoundEvent.VIDEO_PLAYING))
		}
		
		public function get videoSound():Boolean {
			return _videoSound
		}
		
		public function isPlaying($id:String):Boolean {
			var cell:SoundCell = getSoundById($id);
			if (cell == null || !cell.isPlaying) return false
			else if (cell.isPlaying) return true
			return false;
		}
		
	 
		public function getSoundById($id:String):SoundCell {
			
		  var cell:SoundCell
			 for (var i :uint= 0; i < _sounds.length; i++ ) {
				cell = _sounds[i] as SoundCell
			 
				if (cell.id == $id) return cell
			 }
		 
			 return cell
		 
		}
		
		public function get sounds():Vector.<SoundCell> {
			return _sounds
		}
		
	 
		
		public function addSoundByClass($id:String,classname:String,type:String="default") :void{
		//	trace("classname:" + classname + "   id:" + $id)
			var soundClass:Class = getDefinitionByName(classname)  as  Class
			var sound:Sound=new soundClass()
		    var sound_cell:SoundCell = new SoundCell($id,"",null,null,type)
			sound_cell.sound = sound
			_sounds.push(sound_cell)
			
			
		}
		
		public function addSoundByPath($id:String,link:String,type:String="default") :void{
			var sound:Sound=new Sound()
		    var sound_cell:SoundCell = new SoundCell($id, link, sound,null,type)
			_sounds.push(sound_cell)
		}
		
		public function addSoundByObj($id:String,target:Sound,type:String="default"):void {
			  var sound_cell:SoundCell = new SoundCell($id, "", target,null,type);
			  _sounds.push(sound_cell)
		}
		
	 
		
		 
		
		
		
	}
	
}