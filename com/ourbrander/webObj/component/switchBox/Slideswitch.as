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
	
	public class Slideswitch extends switchStyle
	{
		private var _horizon:Boolean = true 
		private var _stateNum = 0
		private var _outPosition=0
	   
		public function Slideswitch() 
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
			
			   if (horizon == true) {
				   _outPosition = (_preObj.width+1)*k
				   _nextObj.x=_rectangle.width*(-k)
				   
				}else {
					 
				    _outPosition = (_preObj.height+1)*k
					_nextObj.y = _rectangle.height * ( -k)
					_nextObj.x = 0
					_preObj.x=0
				}
		     
			 
		}
		private function motionOut(e = null) {
			var $target = e.currentTarget
			 var d = 0
			 var position="x"
			if (horizon == true) {
				d=$target.x
				
			}else {
				
				 position = "y"
				 d=$target.y
				
			}
			d+=(_outPosition-d)*_speed
			if (Math.abs(d) < 1) {
				if (d < 0) {
					d=-1
				}else {
					d=1
				}
			} 
			 
			$target[position] = d
			
			if (d <= _outPosition+1 && d>= _outPosition-1 ) {
				 
				$target.removeEventListener(Event.ENTER_FRAME, motionOut)
				$target[position]=d
				motionEnd()
				
			}

			 
		}

		private function motionIn(e = null) {
			var $target = e.currentTarget
			 var d = 0
			 
			 var position="x"
			if (horizon == true) {
				d=$target.x
			}else {
				 position = "y"
				 d=$target.y
				 
			}
			d+=(0-d)*_speed
			if (Math.abs(d) < 1) {
				if (d < 0) {
					d=-1
				}else {
					d=1
				}
			} 
			 
			$target[position] = d
		 
			if (d <= 1&& d>= -1 ) {
				 
				$target.removeEventListener(Event.ENTER_FRAME, motionIn)
				$target[position]=d
				motionEnd()
				
			}
			
		}
		
		private function motionEnd() {
			_stateNum++
			
			if (_stateNum == 2) {
				_stateNum = 0
				dispatchEvent(new Event(switchStyle.SWICTH_COMPELETE))
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