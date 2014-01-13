package com.ourbrander.ui
{
	import flash.display.Sprite;
	import flash.text.TextField;

	public class Tip extends UIObject
	{
		protected var txt:TextField;
		protected var desc:String;
		public var maxTxtWidth:Number=200;
		
		
		public function Tip(uiKey:String="Tip",view:Sprite=null)
		{
			super(uiKey,view);
			setPadding(5,5,5,5)
		}
		
		override public function setView(view:Sprite):void{
			super.setView(view);
			txt=view.getChildByName("txt") as TextField;
			
			txt.multiline=false;
			txt.wordWrap=false
			txt.autoSize="left";
			
		}
		
		public function set text(str:String):void{
			this.desc=str;
			
			txt.htmlText=this.desc;
			
			txt.autoSize
			resize();
				
			
		}
		
		override protected function resizeSelf():void{
			
			txt.width=int(txt.textWidth);
			txt.height=int(txt.textHeight);
		/*	if(txt.width>maxTxtWidth){
				txt.width=maxTxtWidth;
				//txt.multiline=true;
			}*/
			
			bg.width=int(txt.width+paddingLeft+paddingRight);
			bg.height=int(txt.height+paddingTop+paddingBottom);
			
			
			txt.x=int(paddingLeft);
			txt.y=int(paddingTop);
		}
	}
}