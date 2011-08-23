package com.ourbrander.formatCheck 
{
	/**
	 * ...
	 * @author liuyi
	 */
	public class Email
	{
		
		public function Email() 
		{
			
		}
		
		
		public static function IsEmail(str:String):Boolean {
            var pattern:RegExp = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
            var result:Object = pattern.exec(str);
			
            if(result == null) {
                return false;
            }
			
            return true;
        }
	}

}