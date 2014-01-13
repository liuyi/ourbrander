package com.ourbrander.debugKit 
{

	
	/**
	 * ...
	 * @author liuyi,if you want find more help doucment or anything else,you can visit my blog:www.ourbrander.com or send me email:contact@ourbrander.com
	liuyi
	 */
	public function itrace(...obj):void {
		if (!debug.enabled) return;
		trace(obj);
		outputPanel.dtrace(obj)
		
	}
	 
		 
}
	

