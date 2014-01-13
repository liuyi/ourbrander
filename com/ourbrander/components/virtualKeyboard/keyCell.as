package com.ourbrander.components.virtualKeyboard 
{
 
	import com.ourbrander.debugKit.itrace;
	import com.ourbrander.events.EasyEvent;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author liuyi
	 */
	public class keyCell extends MovieClip
	{
		private var _state:String = "state_orgin"
		public  const STATE_ORGIN:String = "state_orgin"
		public  const STATE_PRESS:String="state_press"
		public  const STATE_UP:String="state_up"
		public  const STATE_FORBIDDEN:String = "state_forbidden"
		
		protected var _value1:String = ""
		protected var _value2:String = ""
		protected var _label:String = ""
		protected var _type:String="charactor"
		
		protected var _skin:MovieClip
		
		
		public function keyCell($skin:MovieClip,val1:String,val2:String,lab:String,$enable:Boolean=true,$type:String="charactor") 
		{  
			
			 
			addEventListener(Event.ADDED_TO_STAGE, addtoStage)
			_skin=$skin
			enable = $enable
			_value1= val1
			_value2= val2
			_label = lab
			_type = $type
			this.mouseChildren=false
			initSkin()
			 
		}
		
		
		protected function addtoStage(e:Event) {
			
			addEventListener(MouseEvent.MOUSE_DOWN,clicked)
			addEventListener(MouseEvent.MOUSE_UP,mousesUp)
			addEventListener(MouseEvent.MOUSE_OUT,mousesUp)
		}
		
		protected function removedFromStage(e:Event) {
			removeEventListener(Event.ADDED_TO_STAGE, addtoStage)
			removeEventListener(MouseEvent.MOUSE_DOWN,clicked)
			removeEventListener(MouseEvent.MOUSE_UP,mousesUp)
			removeEventListener(MouseEvent.MOUSE_OUT, mousesUp)
			dispose()
			
		}
		public function dispose() {
			_skin=null
		}
		protected function initSkin() {
			
			try {
				
				//trace("keycell skin:"+_skin.name)
				var _txt = _skin.getChildByName("_txt")
				//trace("_txt:"+_txt)
				_txt.text = _label
				_skin.addFrameScript(1,addscript)
			}catch (event) {
				//trace("keyCell initSkin:"+event)
			}
		}
		protected function addscript() {
			var _txt2 = _skin.getChildByName("down_txt")
			_txt2.text = _label
			
		}
		public function set enable(bo:Boolean) {
			if (bo == false && state!=STATE_FORBIDDEN) {
				state=STATE_FORBIDDEN
			}else if (bo == true && state == STATE_FORBIDDEN) {
				 
				state=STATE_ORGIN
			}
		}
		
		public function get enable():Boolean {
			if (state!=STATE_FORBIDDEN) {
				return true
			}else{
				return false
			}
		}
		
		protected function set state(str:String) {
			var bo:Boolean=false
			if (str==STATE_ORGIN && _state==STATE_PRESS) {
				_state = STATE_ORGIN
				bo=true
			}else if(str==STATE_PRESS && _state==STATE_ORGIN){
				_state = STATE_PRESS
				bo=true
			}else if (str==STATE_FORBIDDEN) {
				_state = STATE_FORBIDDEN
				bo = true
				 
			}else if(str==STATE_ORGIN && _state==STATE_FORBIDDEN) {
				_state = STATE_ORGIN
				bo = true
			}
			
			if (bo == true) {
				switchStateEffect(str)
			}
		}
		
		protected function get state():String {
			var k=String(_state)
			return k
		}
		protected function switchStateEffect(str:String) {
			switch(str) {
				case STATE_FORBIDDEN:
					this._skin.gotoAndStop(1)
					this._skin.alpha=0.5
				break;
				case STATE_ORGIN:
					this._skin.gotoAndStop(1)
					this._skin.alpha=1
				break;
				case STATE_PRESS:
					this._skin.gotoAndStop(2)
					this._skin.alpha = 1
					_state = STATE_ORGIN
				break;	
				case STATE_UP:
					if (this._skin.currentFrame==2) {
						this._skin.gotoAndPlay(2)
					
					if (_state == STATE_FORBIDDEN) {
						this._skin.alpha = 0.5
					}else{
						this._skin.alpha = 1
					}
					}
				 
				break;	
			}
		}
		
		protected function clicked(e:MouseEvent) {
			 
			if (_state == STATE_FORBIDDEN) {
				return  false
			}
			
			var obj = { value1:_value1, value2:_value2, type:_type }
			 
		 
			var highestMc:MovieClip=this.parent.getChildAt(this.parent.numChildren-1) as MovieClip
		    this.parent.swapChildren(this,highestMc)
			state = STATE_PRESS
			var event=new EasyEvent(easyKeyboardEvent.PRESS_DOWN,obj,true)
			dispatchEvent(event)
			
		}
		
		protected function mousesUp(e:MouseEvent) {
			 switchStateEffect(STATE_UP)
			 
		}
		
		
		
		
	}

}