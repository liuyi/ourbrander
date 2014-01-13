package com.ourbrander.ui
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	
	public class ListItem extends Button
	{
		public var key:String="";
		public var itemData:Object;
		 
		
	
		 
		/**
		 * @desc  If set hasMouseChildren to true, then will check which child displayobject user clicked.
		 */
		public var hasMouseChildren:Boolean=false;
		public function ListItem(uiKey:String="ListItem",view:Sprite=null)
		{
			scaleMode=StageScaleMode.EXACT_FIT
			super(uiKey,view);
			fixHeight=true;
		}
		
		override public function destroy():void{
			for(var i:* in itemData){
				delete itemData[i];
			}
			itemData=null;
			
			super.destroy();
		}
		
	
		override public function  setView(view:Sprite):void{
			super.setView(view);
			
	
		}
		
		override public function onSelect(ignoreEvent:Boolean=false,event:MouseEvent=null):Boolean{
			_selected=true
				
			selectTransition();
			return true;
		}
		
		
		override public function onDeSelect(event:MouseEvent=null):Boolean{
			_selected=false
				deSelectTransition();
			return true;
		}

		public function get selected():Boolean
		{
			
			return _selected;
		}
		
		 public function onListOut(event:MouseEvent=null,outList:Boolean=false):void{
				onOut(event);
		}
		
		 
		public function isMouseOut(event:MouseEvent):Boolean{
			if(event==null ) return true;
			//trace("evt:",event.stageX,event.stageY);
			//trace("ms:",view.stage.mouseX,view.stage.mouseY);
			
			if(event.relatedObject==null || event.relatedObject.parent !=view  && (event.relatedObject.parent.parent!=null  && event.relatedObject.parent.parent!=view )   ) return true;
			var localPoint:Point=new Point(event.stageX,event.stageY);
			localPoint=view.globalToLocal(localPoint);
			//trace(localPoint,"this:"+this.width,this.height);
			if(localPoint.y>=this.height || localPoint.y<=0) return true;
			if(localPoint.x >=this.width || localPoint.x<=0) return true;
			
		
			return !view.hitTestPoint(event.stageX,event.stageY);
			//return !view.hitTestPoint(view.stage.mouseX ,event.stageY);
			
		}
		
		public function isMouseIn(event:MouseEvent):Boolean{
			if(event==null ) return true;
	 
			 
			return !view.hitTestPoint(event.stageX,event.stageY);
			//return !view.hitTestPoint(view.stage.mouseX ,event.stageY);
			
		}
		
		
		protected function selectTransition():void{
			
			if(txt){
				if(txtSelectFormat!=null){
					txt.setTextFormat(txtSelectFormat);
				}
				if(txtSelectStyle!=null){
					TweenMax.to(txt,transDruation,txtSelectStyle);
				}
			}
			
			
			
			
			if(selectedLabel){
				TweenMax.to(selectedLabel,transDruation,{autoAlpha:1});
				
			}
			
			if(hover){
				if(hoverSelectStyle!=null){
					TweenMax.to(hover,transDruation,hoverSelectStyle);
				}else{
					TweenMax.to(hover,transDruation,{autoAlpha:1});
				}
			}
			
			if(icon && iconSelectStyle){
				TweenMax.to(icon,transDruation,iconSelectStyle);
			}
		}
		
		protected function deSelectTransition():void{
			if(txt){
				if(txtOutStyle!=null){
					TweenMax.to(txt,transDruation,txtOutStyle);
				}
				
				
				if(txtOutFormat!=null){
					txt.setTextFormat(txtOutFormat);
				}
			}
			
			if(hover){
				if(hoverOutStyle!=null){
					TweenMax.to(hover,transDruation,hoverOutStyle);
				}else{
					TweenMax.to(hover,transDruation,{autoAlpha:0});
				}
			}
			
			if(selectedLabel){
				TweenMax.to(selectedLabel,transDruation,{autoAlpha:0});
			}
			
			if(icon && iconOutStyle){
				TweenMax.to(icon,transDruation,iconOutStyle);
			}
		}
		
	
		
	}
}