package com.ourbrander.ui
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;

	public class DropButton extends Button
	{
		protected var btn:Sprite
		protected var label:TextField;
		public var list:List;
		
	 
		
		protected var _itemUI:String="DropButtonItem";
		
		public var onItemSelected:Function;
		
		
		public function DropButton(uiKey:String="DropButton",view:Sprite=null)
		{
			super(uiKey,view);
		}
		
		
		override protected function onAddedToStage(event:Event):void{
			super.onAddedToStage(event);
			view.addEventListener(MouseEvent.CLICK,onClick);
			view.addEventListener(MouseEvent.MOUSE_OVER,onMsOver);
			view.addEventListener(MouseEvent.MOUSE_OUT,onMsOut);
 
			 
				
			
		}
		
		override protected function onRemoveFromStage(event:Event):void{
			super.onRemoveFromStage(event);
			view.removeEventListener(MouseEvent.MOUSE_OVER,onMsOver);
			view.removeEventListener(MouseEvent.MOUSE_OUT,onMsOut);
			view.removeEventListener(MouseEvent.CLICK,onClick);
			
			view.stage.removeEventListener(MouseEvent.CLICK,onMsUp)
			view.stage.removeEventListener(Event.MOUSE_LEAVE,onStageOut)
		}
		
		
		override public function destroy():void{
			onItemSelected=null;
			btn=null;
			label=null;
			list.destroy();
			list=null;
			 

			super.destroy();
		}
		
		protected function onMsOut(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			onOut();
		}
		
		protected function onMsOver(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			onHover();
		}		
		
		
	
		protected function onMsUp(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
			
			
			if(view.hitTestPoint(event.stageX,event.stageY)==false && list.view.hitTestPoint(event.stageX,event.stageY)==false){
				view.stage.removeEventListener(MouseEvent.CLICK,onMsUp);
			    hide()
			}
			
			
			
		}
		
		protected function onStageOut(event:Event):void
		{
			// TODO Auto-generated method stub
			hide()
		}
		
		
		protected var p:Point=new Point();
		protected function onClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(list.view.parent==null){
				show()
				
			}else{
				hide()
			}
			
			
		}
		
		
	 
		
 
		
		protected function onSelected(item:ListItem):void{
		 
			label.htmlText=item.label
			hide();
			if(onItemSelected!=null) onItemSelected(this);
		}
		
		public function select(ord:int,ignoreEvent:Boolean=false):void{
			list.select(ord,ignoreEvent);
			label.htmlText=list.selectedItem.label
		}
		
		
		
		
		override public function setView(view:Sprite):void{
			super.setView(view);
			btn=view.getChildByName("btn") as Sprite;
			label=view["txt"];
			
			if(list==null){
				list=new List();
				list.minHeight=view.height;
				list.onSelected=onSelected;
				list.overLayerScroll=true;
			}
			
		  
			
			
		}
		
		override protected function resizeSelf():void{
			btn.x=int(width-btn.width-paddingRight);
			btn.y=paddingTop;
			
			
				
		 	bg.width=width;
			label.width=bg.width-btn.width;
		 
		}

		
		public function get selectedItem():ListItem{

			return list.selectedItem;
		}
		
		public function setItemUI(str:String="DropButtonItem"):void{
				_itemUI=str;
		}
		
		
		public function addItem(label:String,val:Object):void{
			var item:ListItem=new ListItem(_itemUI);
			 
			//var txt:TextField=item.view.getChildByName("txt") as TextField
			//txt.htmlText=label;
			item.setLabel(label);
			item.itemData=val;
			list.addItem(item);
		}
		
		public function show():void{
			if(list.view.parent==null){
				//caculate the position of list

				resizeChild()

				UIManager.normalLayout.addChild(list.view);
				
				view.stage.addEventListener(MouseEvent.CLICK,onMsUp)
				view.stage.addEventListener(Event.MOUSE_LEAVE,onStageOut)
				
				
			}
			
		}
		
		
		override protected function resizeChild():void{
			super.resizeChild();
			
		
			
			
			p.x=view.x;
			p.y=view.y+height;
			p=view.parent.localToGlobal(p);
			//list.maxHeight=int(currentItem.view.stage.stageHeight*0.8)
			var downHeight:int=UIManager.stage.stageHeight-p.y-view.height;
			var upHeight:int=p.y-view.height-view.height;
			if(upHeight<downHeight){
				
				if(list.content.height<downHeight){
					downHeight=list.content.height
				}
				
				list.resize(width,downHeight);
			}else{
				
				if(list.content.height<upHeight){
					upHeight=list.content.height
				}
				
				
				p.x=view.x;
				p.y=view.y-upHeight;
				p=view.parent.localToGlobal(p);
				
				list.resize(width,upHeight);
			}
			
			
			p=UIManager.normalLayout.globalToLocal(p);
			
			list.x=p.x;
			list.y=p.y;
		}
		
		
		
		
		
		public function hide():void{
			if(list.view.parent!=null){
				
				list.view.parent.removeChild(list.view);
				
			}
		}
		
		
		
		override public function onHover(e:MouseEvent=null):void{
			btn["hover"].visible=true
			if(btn["icon"]!=null){
				if(iconOverStyle!=null){
					TweenMax.to(btn["icon"],transDruation,iconOverStyle);
				}
			}
		}
		
		override public function onOut(e:MouseEvent=null):void{
			btn["hover"].visible=false
				
			if(btn["icon"]!=null){
				if(iconOverStyle!=null){
					TweenMax.to(btn["icon"],transDruation,iconOutStyle);
				}
			}
		}
	}
}