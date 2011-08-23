package com.ourbrander.effect.motion
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author:翼(liu yi) msn:ourbrander@live.cn ;QQ:14238910;email:contact@ourbrander.com ...
	 */
	public class frameMotion 
	{
		private var _mc:MovieClip//要进行帧运动的MovieClip
		private var _frameNum:uint//要去的那一帧
		private var _step:uint//运动的步长
		private var _direct:int//值为-1或1，表示运动的方向。
		public function frameMotion($mc:MovieClip=null,$num:uint=0,$step:uint=1) 
		{
			 init($mc,$num,$step)
		}
		private function init($mc:MovieClip=null,$num:uint=0,$step:uint=1) {
			mc = $mc
			frameNum=$num
			step=$step
		}
		//get&set==================================================
		public function set mc($mc:MovieClip) {
			_mc=$mc
		}
		public function get mc():MovieClip {
			return _mc
		}
		public function set step($step:uint) {
			_step=$step
		}
		public function get step() :uint{
			return _step
		}
		public function set frameNum($frameNum:uint) {
			_frameNum = $frameNum
			if (_frameNum>=mc.currentFrame) {
			    direct=1
			}else {
				direct=-1
			}
		}
		public function get frameNum() :uint{
			return _frameNum
		}
		private function set direct($d:int) {
			_direct=$d
		}
		private function get direct():int {
			return _direct
		}
		//========================================================
		
		public function startMotion() {
			try{
			mc.removeEventListener(Event.ENTER_FRAME, motion)
			}catch (e:Error) {
				
			}
			mc.addEventListener(Event.ENTER_FRAME,motion)
		}
		public function stopMotion() {
			//trace("stop:"+mc.name+"------"+mc.currentFrame+"/"+mc.totalFrames)
			mc.removeEventListener(Event.ENTER_FRAME,motion)
		}
		 
		private function motion(e=null) {
			var $num=mc.currentFrame+direct*step
			if ($num <= 0 || $num >= mc.totalFrames) {
				mc.gotoAndStop(frameNum)
				stopMotion()
				return false
			}
			
			mc.gotoAndStop($num)
		}
		
	}
	
}