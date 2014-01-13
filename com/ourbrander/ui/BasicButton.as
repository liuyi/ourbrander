package com.ourbrander.ui
{
	import flash.display.Sprite;
	
	public class BasicButton extends UIObject
	{
		
		public function BasicButton(uiKey:String="BasicButton",view:Sprite=null)
		{
			
			super(uiKey,view);
			enableResize=false;
		}
		
		override public function setView(view:Sprite):void{
			
			super.setView(view);
			view
		}
		
		override public function resize(width:Number=0, height:Number=0):void{
			if(enableResize==false){
				return
			}
			super.resize(width,height);
		}
		
		
		
		
	}
}