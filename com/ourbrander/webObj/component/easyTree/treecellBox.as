package com.ourbrander.webObj.component.easyTree 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author liuyi,you can find more help from my blog:www.ourbrander.com liuyi
	 */
	public class treecellBox extends MovieClip
	{   
		private var _canvas:MovieClip=new MovieClip()
		
		public function treecellBox() 
		{
			
		}
		private function createCanva() {
			
			
			_canvas.graphics.beginFill(0x000000, 0.5)
			_canvas.graphics.drawRect(0, 0, 100, 100)
			_canvas.graphics.endFill()
			addChild(_canvas)
			 
		}
		
	}
	
}