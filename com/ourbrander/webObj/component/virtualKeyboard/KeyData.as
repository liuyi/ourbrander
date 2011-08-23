package com.ourbrander.webObj.component.virtualKeyboard 
{
	 
	import com.ourbrander.webObj.component.virtualKeyboard.cellData
	import flash.utils.ByteArray
	import com.ourbrander.debugKit.itrace
	/**
	 * ...
	 * @author liuyi
	 */
	public class KeyData
	{
		 
		private var _data:Array
		public function KeyData() 
		{
			_data=new Array()
		}
		
		public function addKey(label:String, value1:String, value2:String = "", skin:String = "", enable:Boolean = true, type:String = "charactor") {
			 
			var _cellData:cellData = new cellData(label, value1, value2, skin, enable, type)
			
			 
			_data.push(_cellData)
				 
		}
		public function getKeyData() {
			 
		//	var byteArray:ByteArray = new ByteArray()
			//byteArray.writeObject(_data)
			//byteArray.position=0
			//var _array:Array = new Array(byteArray.readObject())
			 	
			return  _data
		}
		
		public function getLength():uint {
			return _data.length
		}
		public function clear() {
			if(_data!=null){
				while (_data.length > 0) {
					_data[0] = null
					_data.shift()
				}
				_data=null
			}
			
		}
		
		
	}

}