package com.ourbrander.ui
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class TabHeader extends UIObject
	{
		public var items:Vector.<ListItem>;
		public var selectedItem:ListItem;
		public var flexByChildren:Boolean=false;
		/**
		 * @ value h or v
		 */
		public var direction:String="h";
		public var itemGap:int=0;
		public var onChange:Function;
		public function TabHeader(uiKey:String="TabHeader",view:Sprite=null)
		{
			super(uiKey,view);
			fixHeight=true;
		}
		
		
		override public function resize(width:Number=0, height:Number=0):void{
			if(flexByChildren==false) {
				super.resize(width,height);
			}else{
				resizeFlexChild();
				caculateAutoFlexLayout();
				resizeSelf();
			}
		}
		
		override public function disable():void{
			super.disable();
			view.mouseChildren=false;
		}
		
		override public function enable():void{
			super.enable();
			view.mouseChildren=true;
		}
		
		
		  protected function caculateAutoFlexLayout():void{
			
		
				if(_children.length==0) return ;
				var lastItem:UIObject=_children[_children.length-1];
				width=lastItem.x+lastItem.width+_paddingLeft+_paddingRight;
				_innerHeight=height-_paddingTop-paddingBottom;
		
		
		
			
		}
		
		 protected  function resizeFlexChild():void{
			 var len:int=_children.length;
			 
			 var preItem:UIObject;
			 var item:UIObject
			 for(var i:int=0;i<len;i++){
				 item=_children[i]
				 item.resize(0,height);
				 item.y=0;
				 if(i==0){
					 item.x=int(0+paddingLeft);

				 }else{
					 item.x=int(preItem.x+preItem.width+itemGap)
				 }
				 preItem=_children[i];
			 }
		}
		override protected function resizeChild():void{
			
			if(direction=="v"){
				resizeVerticalChild();
				return
			}
	
			var len:int=_children.length;
			var avWidth:Number=width/len;
			var preItem:UIObject;
			var item:UIObject
			for(var i:int=0;i<len;i++){
				item=_children[i]
				item.resize(avWidth,height);
				item.y=0;
				if(i==0){
					item.x=int(0+paddingLeft);
					
					
				}else{
					item.x=int(preItem.x+preItem.width+itemGap)
				}
				preItem=_children[i];
			}
		}
		
		protected function resizeVerticalChild():void{
			var len:int=_children.length;
		 
			var avHeight:Number=height/len
			var preItem:UIObject;
			var item:UIObject
			for(var i:int=0;i<len;i++){
				item=_children[i]
				item.resize(width,avHeight);
				item.x=0;
				if(i==0){
					item.y=int(0+paddingTop);
					
					
				}else{
					item.y=int(preItem.y+preItem.height+itemGap)
				}
				preItem=_children[i];
			}
		}
		
		override protected function onAddedToStage(event:Event):void{
			super.onAddedToStage(event);
			view.addEventListener(MouseEvent.CLICK,onItemClick);
			view.addEventListener(MouseEvent.MOUSE_OUT,onItemOut);
			view.addEventListener(MouseEvent.MOUSE_OVER,onItemOver);
		}
		
		override protected function onRemoveFromStage(event:Event):void{
			view.removeEventListener(MouseEvent.CLICK,onItemClick);
			view.removeEventListener(MouseEvent.MOUSE_OUT,onItemOut);
			view.removeEventListener(MouseEvent.MOUSE_OVER,onItemOver);
			super.onRemoveFromStage(event);
		}
		
		
		protected function onItemOver(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var len:int=_children.length;
			var item:ListItem
			for(var i:int=0;i<len;i++){
				item=_children[i]  as ListItem;
				if(item!=null &&item.view==event.target){
					//trace("onItemOver>>>>>>>>>"+item.view.name)
					item.onHover(event);
					return;
				}
			}
		}
		
		protected function onItemOut(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var len:int=_children.length;
			var item:ListItem
			for(var i:int=0;i<len;i++){
				item=_children[i] as ListItem;
				if(item!=null &&item.view==event.target){
					//trace("onItemOut>>>>>>>>>"+item.view.name)
					item.onOut(event);
					return;
				}
			}
		}		
		
		
		
		
		
		
		protected function onItemClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var len:int=_children.length;
			var item:ListItem
			for(var i:int=0;i<len;i++){
				item=_children[i] as ListItem;
				//if(item.view.hitTestPoint(event.stageX,event.stageY)){
				if(item!=null && item.view==event.target){
					
					if(selectedItem!=item){
						//trace("onItemClick>>>>>>>>>"+item.view.name)
						
						if(selectedItem!=null) selectedItem.onDeSelect(event);
						item.onSelect(false,event);
						selectedItem=item;
						
						if(onChange!=null){
							onChange(item)
						}
					}
					return;
				}
			}
		}//end function
		
		public function select(ord:uint,ignoreEvent:Boolean=false):void{
			if(ord>_children.length) return;
			
/*			if(selectedItem==_children[ord]){
				selectedItem.onDeSelect();
			}else if(selectedItem!=null){
				selectedItem.onDeSelect();
			}*/
			
			 if(selectedItem!=null &&  selectedItem!=_children[ord]){
				selectedItem.onDeSelect();
			}
			
			
			selectedItem=_children[ord]
			selectedItem.onSelect(ignoreEvent)
			if(ignoreEvent==false){
				if(onChange!=null){
					onChange(selectedItem)
				}
			}
			
		}
		public function reset():void{
			if(selectedItem!=null ){
				selectedItem.onDeSelect();
			}
		}
		
		
	}
}