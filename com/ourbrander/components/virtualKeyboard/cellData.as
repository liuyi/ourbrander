package com.ourbrander.components.virtualKeyboard 
{
	/**
	 * ...
	 * @author liuyi
	 */
	public class cellData extends Object
	{
		private var _label:String
		private var _value1:String
		private var _value2:String
		private var _skin:String
		private var _enable:Boolean
		private var _type:String
	 
		public function cellData(label:String, value1:String,value2:String="",skin:String="",enable:Boolean=true,type:String="charactor")
		{
			initData(label, value1,value2,skin,enable,type)
		}
		
		public function initData(label:String, value1:String,value2:String="", skin:String = "",enable:Boolean=true,type:String="charactor"){
			_label = label
			_value1 = value1
			_value2 = value2
			_skin = skin
			_enable=enable
			_type = type
		     
		}
		
		public function getData():Object{
			var o:Object = {label:_label, value1:_value1, value2:_value2,skin:_skin,type:_type,enable:_enable }
			return o
		}
	}

}