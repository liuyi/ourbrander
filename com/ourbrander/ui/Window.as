package com.ourbrander.ui
{
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowResize;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import notification.AlertLayerPanel;
	
	
	
	public class Window extends Panel
	{
		
		public var alertLayer:AlertLayerPanel;
		public function Window(uiKey:String="Window",view:Sprite=null)
		{
			scaleMode=StageScaleMode.EXACT_FIT;
			super(uiKey,view);
			UIManager.windowList[this.id]=this;
		}
		
		override public function setView(view:Sprite):void{
			super.setView(view);
			
			
			
			 
			if(alertLayer==null){
				alertLayer=new AlertLayerPanel();
				addChild(alertLayer,false);
				 
			}else{
				alertLayer.onThemeChange();
			}
			
			//view.addEventListener(MouseEvent.MOUSE_OVER,onMsOver)
			//view.addEventListener(MouseEvent.MOUSE_OUT,onMsOut)
			
		}
		
		override protected function onAddedToStage(event:Event):void{
			view.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove)
			if(border!=null){
				border.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
				
			}
			super.onAddedToStage(event);
		}
		
		override protected function onRemoveFromStage(event:Event):void{
			if(border!=null){
				//border.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
				
			}
			//view.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove)
			super.onRemoveFromStage(event);
			
		}
		override public function destroy():void{
			alertLayer=null;
			
			super.destroy();
		}
		protected function onMouseMove(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			UIManager.hideTip(event.target as DisplayObject);
		}
		
		protected function onMsOut(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function onMsOver(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		override protected function clearView():void{
			super.clearView();
			if(border!=null){
				border.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
				
			}
			
			
		}
		
		
		
		
		protected function onMouseUp(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			view.stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp)
			UIManager.onResize();
			
			view.stage.mouseChildren=true;
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			view.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp)
			view.stage.mouseChildren=false;
			
			var corner:String="";
			switch(event.target.name){
				case "left":
					corner = NativeWindowResize.LEFT;
					break;
				case "right":
					corner = NativeWindowResize.RIGHT;
					break;
				case "bottom":
					corner = NativeWindowResize.BOTTOM;
					break;
				case "top":
					corner = NativeWindowResize.TOP;
					break;
				
				case "corner":
					corner = NativeWindowResize.BOTTOM_RIGHT;
					break;
			}
			if(corner!="")
			NativeApplication.nativeApplication.activeWindow.startResize(corner);
			
		}
		
		
		
		override protected function resizeSelf():void{
			
			super.resizeSelf();
			var item:Sprite
			border.x=0;
			border.y=0
			
			if(border!=null){
				for(var i:int=0;i<border.numChildren;i++){
					item=border.getChildAt(i) as Sprite;
					if(item.name=="top"){
						item.width=width;
						
					}else if(item.name=="right"){
						item.x=width;
						item.height=height
					}else if(item.name=="bottom"){
						item.y=height;
						item.width=width
					}else if(item.name=="left"){
						item.height=height
						
					}else if(item.name=="corner"){
						item.x=width;
						item.y=height;
					}
				}
			}
			
			
			
			
		}
		
		override protected function resizeChild():void{
			var len:int=_children.length;
			var item:UIObject;
			var vbox:VBox;
			var h:Number=height;
			var w:Number=width;
			for(var i:int=0;i<len;i++){
				item=_children[i];
				if(item is VBox || item is HBox ){
					item.x=_paddingLeft;
					item.y=_paddingTop;
					item.resize(_innerWidth,_innerHeight);
				}else {
					if(item.scaleMode==StageScaleMode.EXACT_FIT){
						
						item.resize(width,height);
					}else{
						item.resize();
					}
					
				}
				
				
			}
			
			
		}
		
		
		
	}
}