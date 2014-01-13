package com.ourbrander.ui
{
	import com.ourbrander.utils.Utils;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class CheckBox extends UIObject
	{
		public var tick:Sprite
		public var hover:Sprite
		private var _selected:Boolean
		private var _txt:TextField;
		public function CheckBox(uiKey:String="CheckBox",view:Sprite=null)
		{
			super(uiKey,view);
		}
		
		override public function destroy():void{
			hover=null;
			tick=null;
			super.destroy();
		}
		
		
		override public function setView(view:Sprite):void{
			super.setView(view);
			hover=view.getChildByName("hover") as Sprite;
			tick=view.getChildByName("tick") as Sprite;
			view.buttonMode=true;
			view.mouseChildren=false;
			if(_selected){
				select()
			}else{
				deSelect();
			}
			
			onOut();
		}
		
		public function select():void{
			
			tick.alpha=1;
			_selected=true
		}
		
		public function deSelect():void{
			
			tick.alpha=0;
			_selected=false
		}
		
		public function toggle():Boolean{
			if(_selected){
				deSelect()
			}else{
				select()
			}
			return _selected
		}
		
		public function onHover():void{
			if(_selected){
				tick.alpha=0.7;
			}else{
				tick.alpha=0.5;
			}
			hover.alpha=1
		}
		
		public function onOut():void{
			if(_selected){
				tick.alpha=1;
			}else{
				tick.alpha=0;
			}
			
			hover.alpha=0
		}
		
		public function reset():void{
			_selected=false;
			onOut();
		}
		
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		
		public function addLabel(txt:TextField,offsetX:Number=0,offsetY:Number=0):void{
			
			if(_txt!=null){
				_txt.parent.removeChild(_txt);
				_txt=null;
			}
			
		
			txt.width=txt.textWidth+5;
			txt.height=txt.textHeight;
	 
			if(txt.parent!=null){
				var pos:Point=new Point(txt.x,txt.y);
				pos=txt.parent.localToGlobal(pos);
				pos=view.globalToLocal(pos);
		 
				if(txt.autoSize!="right"){
					txt.x=pos.x+offsetX;
				
				}else {
					txt.x=offsetX-txt.width;
					
				}
				txt.y=pos.y+offsetY
			
			}else {
				if(txt.autoSize!="right"){
					txt.x=int(view.width+offsetX);
				}else{
					txt.x=int(view.width+offsetX-txt.width);
				}
				txt.y=int( (view.height-txt.height)*0.5+offsetY)
			 
			}
			
			view.addChild(txt);
			
			_txt=txt;
		}
		
		public function setLabel(str:Object):void{
			if(_txt==null) return;
				Utils.setTextByObj(_txt,str);
				_txt.width=_txt.textWidth;
				_txt.height=_txt.textHeight;
		}
		
		
		
	}
}