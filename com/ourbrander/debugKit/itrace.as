package com.ourbrander.debugKit 
{

	
	/**
	 * ...
	 * @author liuyi,if you want find more help doucment or anything else,you can visit my blog:www.ourbrander.com or send me email:contact@ourbrander.com
	liuyi
	 */
	public function itrace(...obj):void {
		trace(obj)
		try{
			outputPanel.dtrace(obj)
		}catch (e) {
			trace("itrace error:"+e)
		} 
	}
	 
		 
}
	

