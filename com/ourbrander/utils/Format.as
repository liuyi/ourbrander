package com.ourbrander.utils 
{
	/**
	 * ...
	 * @author liuyi
	 */
	public class Format
	{
		
		public function Format() 
		{
			
		}
		
		
		public static function IsEmail(str:String):Boolean {
            var pattern:RegExp = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
            var result:Object = pattern.exec(str);
			
            if(result == null)  return false;
			else
            return true;
        }
	}

}