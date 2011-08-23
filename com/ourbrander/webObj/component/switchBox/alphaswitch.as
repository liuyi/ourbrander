package com.ourbrander.webObj.component.switchBox 
{
	
	/**
	 * ...
	 * @author liuyi url:www.ourbrander.com email:contact@ourbrander.com
	...
	 */
	import flash.events.Event
	import flash.events.MouseEvent
	import com.ourbrander.Event.superEvent
	import flash.events.EventDispatcher
	import com.ourbrander.webObj.component.switchBox.switchStyle
	
	public class alphaswitch extends switchStyle
	{
		private var _horizon:Boolean = true 
		private var _stateNum = 0
		private var _outPosition=1
	   
		public function alphaswitch() 
		{
			super()
			init()
		}
		public function init() {
			_styleName="SlideStyle"
		}
	
		override  public function switchTo($preObj,$nextObj,$rectangle,$speed =null) {
          super.switchTo($preObj, $nextObj, $rectangle, $speed)
		  motionInit()
		  $preObj.addEventListener(Event.ENTER_FRAME,motionOut)
		  $nextObj.addEventListener(Event.ENTER_FRAME,motionIn)
		  
		}
        private function motionInit() {
			var k=1

			if (_preObj.id < _nextObj.id) {
				k=-1
			}
			_nextObj.alpha = 0
			
			_nextObj.y = 0
			_nextObj.x = 0
			_preObj.x=0
			_preObj.y=0
		     
			 
		}
		private function motionIn(e = null) {
			//trace(_speed)
			var $target = e.currentTarget
			var  d = $target.alpha
			$target.visible = true
			 var b=(1-d)*_speed
			if (Math.abs(b) < 0.01) {
				if (b < 0) {
					b=-0.01
				}else {
					b=0.01
				}
			} 
			d+=b
			$target.alpha = d
			//trace("motionIn:"+d)
			if (d >= 0.99) {
				//trace("motionIn")
				$target.removeEventListener(Event.ENTER_FRAME, motionIn)
				$target.alpha = 1
				motionEnd()
				
			}

			 
		}

		private function motionOut(e = null) {
			var $target = e.currentTarget
			var  d=$target.alpha
		    var b=(0-d)*_speed
			if (Math.abs(b) < 0.01) {
				if (b < 0) {
					b=-0.01
				}else {
					b=0.01
				}
			} 
			d+=b
			$target.alpha = d
			//trace("motionOut:"+d+"/"+(0-d)*_speed)
			if (d <= 0.01) {
			//	trace("motionOut")
				$target.removeEventListener(Event.ENTER_FRAME, motionOut)
				$target.alpha = 0
				$target.visible=false
				motionEnd()
				
			}

			
		}
		
		private function motionEnd() {
			_stateNum++
			
			if (_stateNum == 2) {
				_stateNum = 0
				dispatchEvent(new Event(switchStyle.SWICTH_COMPELETE))
				_preObj.alpha = 0
				_nextObj.alpha=1
				_preObj = null
				_nextObj = null
			 
			}
		}
	   
		public function set horizon(val:Boolean) {
			
			_horizon = val
			 
		
		}
		public function get horizon():Boolean {
			return _horizon
		}
	}
	
}