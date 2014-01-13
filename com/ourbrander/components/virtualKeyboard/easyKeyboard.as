package com.ourbrander.components.virtualKeyboard 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	import flash.text.TextField;
	import flash.text.TextFieldType
	import com.ourbrander.webObj.component.virtualKeyboard.cellData
	
	import com.ourbrander.webObj.component.virtualKeyboard.keyCell
	import flash.utils.setTimeout
	
	/**
	 * ...
	 * @author liuyi
	 */
	public class easyKeyboard extends Sprite
	{
		protected var  _skin:MovieClip = null
		protected var _map:KeyData = null
		protected var _keyArray:Array
		protected var _targetTxt:TextField
		protected var _careIndex:int=0
		protected var _shiftKey:Boolean = false
		protected var _capslock:Boolean = false
		 
		
		
		
		public function easyKeyboard($skin:MovieClip,$map:KeyData) 
		{   
			
			init($skin,$map)
		}
		
		protected function init($skin:MovieClip , $map:KeyData )  {
			_keyArray=[]
			 _map=$map
			 _skin=$skin
			 setSkin()
			 addEventListerHandler()
			 addEventListener(Event.ADDED_TO_STAGE, addtoStage)
			
		}
		
		protected function addEventListerHandler() {
			addEventListener(easyKeyboardEvent.PRESS_DOWN, pressDown)
			 
			
		}
		
		protected function addtoStage(e:Event) {
			
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage)
			stage.addEventListener(FocusEvent.FOCUS_IN, focus_In);
			
		}
		protected function removedFromStage(e:Event) {
			removeEventListener(easyKeyboardEvent.PRESS_DOWN, pressDown)
			stage.removeEventListener(FocusEvent.FOCUS_IN, focus_In);
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage)
			dispose()
			
			
		}
		protected function dispose() {
			
		
			while (_keyArray.length > 0) {
				_keyArray[0] = null
				_keyArray.shift()
			}
			_keyArray = null
			_map.clear()
			_map = null
			_skin = null
			
		}
		public function setSkin() {
		    if (_skin == null || _map==null) {
				return false
			}
			this.x = _skin.x
			this.y = _skin.y
			_skin.x = 0
			_skin.y = 0
			
			addChild(_skin)
			var array:Array = _map.getKeyData()
			 
			for each(var i in array) {
				var celldata = i as cellData
			 
				var cellskin_str:String = new String(celldata.getData().skin)
				var path_arry:Array = cellskin_str.split(".")
				
				
				var _cell_mc:MovieClip=_skin as MovieClip
				var _cell_container_mc:MovieClip=_skin as MovieClip
				 var plength=path_arry.length
				for (var  k = 0; k <plength ; k++) {
					
				 
					_cell_mc=_cell_mc[path_arry[k]] as MovieClip
					if (k==plength-2) {
						_cell_container_mc=_cell_mc 
					}
				}
				
				 //_cell_container_mc = _cell_mc.parent as MovieClip
				 
				 
				var _value1 = celldata.getData().value1
				var _value2 = celldata.getData().value2
				var _label = celldata.getData().label
				var _type = celldata.getData().type
				var _enable=celldata.getData().enable
				 
				 
				
				var keycell:keyCell = new keyCell(_cell_mc, _value1, _value2, _label,_enable, _type)
				  
				keycell.x = _cell_mc.x
				keycell.y = _cell_mc.y
				_cell_mc.x = 0
				_cell_mc.y = 0
				keycell.name = _cell_mc.name
				//_cell_mc.name="skin_mc"
				keycell.addChild(_cell_mc)
			 
				_cell_container_mc.addChild(keycell) 
				
				_keyArray.push(keycell)
			} 
			
			
		}
		
		
		protected function pressDown(e:Event) {
			 
			switch(e["content"].type) {
				case keyType.CHARACTOR:
				 
					inputChar(e)
				break;
				
				case keyType.BACK_SPACE:
			 
					deleteChar()
				break;
				
			}
		}
		protected function inputChar(e:Event) {
			if (_targetTxt != null) {
				var str:String=""
				if(_shiftKey==true || _capslock==true){
					str=(e["content"].value2) 
					if (_shiftKey==true) {
						_shiftKey=false
					}
					
				}else {
					//trace("input char:" + e["content"].value1 + "/"+_targetTxt.name)
					str=(e["content"].value1)
				}
				_careIndex = _targetTxt.text.length 
				//trace("inputChar: careindex="+_careIndex)
				setTimeout(getCurrentCareIndex,30,_targetTxt)
				setTimeout(addStr,40,_targetTxt,str)
			}
		}
		
		protected function addStr(target:TextField, str:String) {
			
			var str2:String = target.text.substring(0, _careIndex ) + str + target.text.substring(_careIndex)
			trace(str2)
			target.text = str2
			_careIndex=_careIndex+str.length
			target.setSelection(_careIndex,_careIndex)
		}
		
		

		protected function deleteChar() {
			 
			setTimeout(getCurrentCareIndex, 30, _targetTxt)
			setTimeout(deleteCharComplete,40)
			  
			 
			//_fm.setFocus(_targetTxt)
		}
		protected function deleteCharComplete() {
			try{
				 if (_targetTxt != null) {
					// trace(_targetTxt.name + "  careindex:" + _careIndex)
					 if(_targetTxt.selectionBeginIndex==_targetTxt.selectionEndIndex){
						var str:String= _targetTxt.text.substring(0,_careIndex-1).concat(_targetTxt.text.substring(_careIndex))
						_targetTxt.text = str
						_careIndex = (_careIndex - 1 >= 0)?_careIndex - 1:0
						_targetTxt.setSelection(_careIndex,_careIndex)
					 }else {
						 var a = _targetTxt.selectionBeginIndex
						 var b=_targetTxt.selectionEndIndex
						 str= _targetTxt.text.substring(0,_targetTxt.selectionBeginIndex).concat(_targetTxt.text.substring(_targetTxt.selectionEndIndex))
						_targetTxt.text = str
						_careIndex = a
						_targetTxt.setSelection(_careIndex,_careIndex)
						//trace(a+"/"+b+"  careindex:"+a)
					 }
				 }
			 }catch (e) {
				 
			 }
		}
		protected function focus_In(e:FocusEvent) {
			 
			if (e.target is TextField ) {
				var tmp_txt:TextField= e.target as TextField
				if(tmp_txt.type==TextFieldType.INPUT){
					_targetTxt = e.target as TextField
					_careIndex = _targetTxt.caretIndex
				    
					//trace(tmp_txt.parent.name + " focus in......._targetTxt.caretIndex:" + _targetTxt.caretIndex)
					setTimeout(getCurrentCareIndex,30,_targetTxt)
				}
			}
			
		}
		protected function getCurrentCareIndex(target:TextField) {
			//trace("getCurrentCareIndex>>>>>>:"+target.parent.name + " focus in......._targetTxt.caretIndex:" + target.caretIndex)
			_careIndex = target.caretIndex
		}
		protected function getKeyByName($name:String):keyCell {
			//var _mc:MovieClip= _skin.
		    for each(var i in _keyArray) {
				var kc:keyCell = i as keyCell
				 
				if (kc.name == $name) {
					 
					return kc
				}
			}
			 
			return null
		}
		
		
		
		 
		
		 
		
		
	}

}