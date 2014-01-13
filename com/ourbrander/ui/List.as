package com.ourbrander.ui
{
	
	
	import com.ourbrander.events.EasyEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class List extends Panel
	{
		protected var slider:ScrollBar;
		protected var msk:Sprite;
		protected var listBox:Panel
		public var items:Vector.<ListItem>;
		public var selectedItem:ListItem;
		public var selctedItems:Vector.<ListItem>=new Vector.<ListItem>();
		public var multiSelect:Boolean=false;
		public var toggleEnable:Boolean=false;
		private var _isSelectedAll:Boolean=false;
		
		/**
		 * @desc Set overLayerScroll to true, would make scorllbar on the top of list.
		 */
		public var overLayerScroll:Boolean=false;
		protected var prePosY:Number
		
		//protected var timer:Timer
		
		/*
		*@desc on select a item, would call this callback function.(and the item will dispatch a event) 
		*/
		public var onSelected:Function;
		
		public var totalCount:int=0;
		public var onBottom:Function;
		public var maxPullCount:int=10;
		public function List(uiKey:String="List",view:Sprite=null)
		{
			super(uiKey,view);
			
		}
		
		protected function init():void{
			
			
			items=new Vector.<ListItem>();
			slider=new ScrollBar();
			slider.position=UIObject.POSITION_TYPE_ABSOLUTE;
			slider.alignH=UIObject.ALIGN_RIGHT;
			slider.onScroll=onScroll;
			slider.onScrollComplete=onScrollComplete;
			slider.onUpdate=onScrolling;
			msk=new Sprite();
			msk.graphics.beginFill(0xff0000);
			msk.graphics.drawRect(0,0,100,100);
			msk.graphics.endFill();
			
			listBox=new VBox();
			
			addChild(listBox);
			
			
			
			
		}
		
		
		
		override public function destroy():void{
			
			
			onSelected=null;
			removeAllItem(true);
			selctedItems.length=0;
			selctedItems=null;
			selectedItem=null;
			items=null;
			
			super.destroy();
		}
		override protected function onAddedToStage(event:Event):void{
			super.onAddedToStage(event);
			
			view.addEventListener(MouseEvent.MOUSE_OVER,onItemOver);
			view.addEventListener(MouseEvent.MOUSE_OUT,onItemOut);
			view.addEventListener(MouseEvent.CLICK,onItemClick);
		 
			
		}
		
		override protected function onRemoveFromStage(event:Event):void{
			
			view.removeEventListener(Event.ENTER_FRAME,onScrolling);
			
			view.removeEventListener(MouseEvent.MOUSE_OVER,onItemOver);
			view.removeEventListener(MouseEvent.MOUSE_OUT,onItemOut);
			view.removeEventListener(MouseEvent.CLICK,onItemClick);
		 
			
			
			super.onRemoveFromStage(event);
			
		}
		
 
		
		protected function onItemClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
			
			
			var len:int=items.length;
			var item:ListItem
			
			for(var i:int=0;i<len;i++){
				item=items[i];
				//if(item.view.hitTestPoint(event.stageX,event.stageY)){
				//	if(item.view==event.target){
				if(isItem(item.view,event.target as  DisplayObject)){
					if(multiSelect){
						var pos:int=selctedItems.indexOf(item)
						if(pos<0){
							
							if(item.onSelect(false,event)){
								selctedItems.push(item);
								onAddSelectedItem(item);
								if(onSelected!=null){
									onSelected(item)
								}
							}else{
								
								
							}
							
						}else{
							
							if(	item.onSelect(true,event)==false){
								if(item.selected==false){
									selctedItems.splice(pos,1);
									onDeSelectItem(item);
								}
							}else{
								
							}
							
							
						}
						
					}else{
						
						
						var selectedItemTmp:ListItem;
						//clear selected item, if the selectedItem is clicked and toggleEnable is true.
						if(selectedItem!=null && (selectedItem!=item || toggleEnable)){
							if(selectedItem.onDeSelect(event)){
								onDeSelectItem(selectedItem);
								selectedItemTmp=selectedItem
								selectedItem=null;
							}
							
						}
						
						
						if(toggleEnable && item == selectedItemTmp){
							selectedItemTmp=null;
						}else 	if(	item.onSelect(selectedItem==item,event)){
							selectedItem=item
							onAddSelectedItem(item);
							
							if(onSelected!=null){
								onSelected(item)
							}
						}
						
					}
					
					
					
					return;
				}
			}
			
		}
		internal function onAddSelectedItem(item:ListItem):void{
			//trace("selected item:"+item);
			var event:Event=new EasyEvent(EasyEvent.DATA_SELECT,{all:false,items:[item]});
			dispatchEvent(event);
		}
		internal function onDeSelectItem(item:ListItem):void{
			_isSelectedAll=false;
			//trace("deselect item:"+item)
			var event:Event=new EasyEvent(EasyEvent.DATA_DESELECT,{all:false,items:[item]});
			dispatchEvent(event);
		}
		
		internal function isItem(target:DisplayObject,checkItem:DisplayObject):Boolean{
			var p:DisplayObjectContainer;
			
			while(checkItem!=null ){
				if(checkItem==target){
					return true
				}else{
					checkItem=checkItem.parent
				}
			}
			
			return false
		}
		
		protected function onItemOut(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
		 
			isMsOver=false;
			checkSlider();
			
			var len:int=items.length;
			var item:ListItem
			for(var i:int=0;i<len;i++){
				item=items[i];
				//if(item.view==event.target){
				if(isItem(item.view,event.target as  DisplayObject)){
					
					item.onOut(event);
					return;
				}
			}
			
		}
		
		protected function onItemOver(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
			 isMsOver=true;
			 checkSlider();
			
			var len:int=items.length;
			var item:ListItem
			for(var i:int=0;i<len;i++){
				item=items[i];
				//if(item.view==event.target){
				if(isItem(item.view,event.target as  DisplayObject)){
					//trace("onItemOver>>>>>>>>>"+item.view.name)
					item.onHover(event);
					return;
				}
			}
		}
		
		
		
		override public function setView(view:Sprite):void{
			super.setView(view);
			if(listBox==null){
				init();
			}
			
			try{
				view.name="LIST VIEW"
			}catch(e:Error){}
			view.addChild(slider.view)
			view.addChild(msk);
			content.mask=msk;
			msk.mouseChildren=false;
			msk.mouseEnabled=false;
			
			view.mouseEnabled=false;
			bg.mouseEnabled=false;
			bg.mouseChildren=false;
			
			//content.mouseChildren=false
			//content.mouseEnabled=true;
			
			slider.setTarget(content);
			
			checkSlider();
			
		}
		
		protected var  isMsOver:Boolean=false;
		protected function checkSlider():void{
			
			if(isMsOver ==false&& overLayerScroll==true && slider.isScrolling==false){
				slider.view.visible=false;
			}else{
				if(content.height<=content.mask.height){
					slider.view.visible=false;
				}else{
					slider.view.visible=true;
				}
			}
			
			
		}
		
		override public function resize(width:Number=0, height:Number=0):void{
			super.resize(width,height);
			msk.x=paddingLeft
			
			msk.height=_innerHeight;
			
			slider._height=_innerHeight;
			
			listBox.x=paddingLeft;
			if(overLayerScroll){
				msk.width=_innerWidth;
				slider.view.x=this.width-paddingRight-slider.width;
				listBox.resize(_innerWidth,_innerHeight);
			}else{
				msk.width=_innerWidth-slider.width;
				slider.view.x=this.width-paddingRight-slider.view.width;
				listBox.resize(_innerWidth-slider.width,_innerHeight);
			}
			
			
			slider.manualUpdate();
			
			
			
			checkSlider();
			
		}
		
		
		
		public function addItem(item:ListItem):void{
			/*	if(item.uiKey=="MusicListItem"){
			item.view.visible=false;
			}*/
			
			listBox.addChild(item);
			
			items.push(item);
			itemsLen=items.length;
			
			checkSlider();
		}
		
		public function removeItem(item:ListItem,destroy:Boolean=false):void{
			
			var pos:int=selctedItems.indexOf(item)
			if(pos>=0){
				selctedItems.splice(pos,1);
			}
			
			if(selectedItem==item)  selectedItem=null;
			
			var len:int=items.length;
			listBox.removeChild(item);
			checkSlider();
			if(destroy==true){
				item.destroy();
			}
			
			
			for(var i:int=0;i<len;i++){
				
				if(items[i]==item){
					itemsLen--;
					items.splice(i,1);
					
					var event:Event=new EasyEvent(Event.REMOVED,{items:[i],all:false});
					dispatchEvent(event);
					
					return;
				}
			}
			
			
			
			
			
		}
		
		public function removeAllItem(destroyItem:Boolean=false):Vector.<ListItem>{
			listBox.removeAllChildren(destroyItem);
			selectedItem=null;
			selctedItems.length=0;
			slider.rest();
			checkSlider();
			if(destroyItem==false){
				var removedItems:Vector.<ListItem>=items.concat();
				
				items.length=0;
				itemsLen=0;
				
				var event:Event=new EasyEvent(Event.REMOVED,{all:true});
				dispatchEvent(event);
				return removedItems;
				
			}else{
				
				
				items.length=0;
				itemsLen=0;
				
				event=new EasyEvent(Event.REMOVED,{all:true});
				dispatchEvent(event);
				return null;
			}
		}
		
		public function selectAll():void{
			var len:int=items.length;
			var item:ListItem;
			selctedItems.length=0;
			for(var i:int=0;i<len;i++){
				item=items[i];
				
				if(item.selected==false ){
					if	(item.onSelect(false,null)){
						selctedItems.push(item);
					}
				}else{
					selctedItems.push(item);
				}
				
			}
			
			_isSelectedAll=true
			var event:Event=new EasyEvent(EasyEvent.DATA_SELECT,{all:true});
			dispatchEvent(event);
		}
		
		public function deSelectAll():void{
			
			var item:ListItem;
			var len:int=selctedItems.length
			for(var i:int=0;i<selctedItems.length;i++){
				item=selctedItems[i];
				
				
				if(	item.onDeSelect(null)){
					selctedItems.splice(i,1)
					i--;
				}
				
			}
			
			_isSelectedAll=false;
			
			if(selectedItem!=null){
				selectedItem.onDeSelect();
				selectedItem=null;
			}
			
			if(len>0){
				var event:Event=new EasyEvent(EasyEvent.DATA_DESELECT,{all:true});
				dispatchEvent(event);
			}
			
			
		}
		
		public function getItemByData(obj:Object):ListItem{
			var len:int=items.length;
			var item:ListItem;
			for(var i:int=0;i<len;i++){
				item=items[i];
				if(obj==item.itemData){
					return item;
				}
			}
			return null;
		}
		
		
		protected function onChildSelfChange(item:ListItem):void{
			
			if(multiSelect){
				var pos:int=selctedItems.indexOf(item);
				if(item.selected && pos<0){
					selctedItems.push(item);
				}else if(item.selected==false && selctedItems.indexOf(item)>=0){
					selctedItems.splice(pos,1)
				}
			}else{
				if(item.selected  && item!=selectedItem){
					if(selectedItem!=null){
						selectedItem.onDeSelect();
					}
					selectedItem=item;
				}else if(item.selected==false && item==selectedItem){
					selectedItem.onDeSelect();
					selectedItem=null;
				}
			}
			
		}
		
		/**
		 * @desc  Select a item of list
		 */
		public function select(ord:int,ignoreEvent:Boolean=false):void{
			
			if(multiSelect==false){
				if(selectedItem!=null){
					
					selectedItem.onDeSelect();
				}
				if(items.length==0) return;
				var target:ListItem=items[ord];
				
				if(	target.onSelect(ignoreEvent)){
					selectedItem=target;
					if(onSelected!=null && ignoreEvent==false){
						onSelected(selectedItem)
					}
				}
				
			}else{
			
				if(items.length==0) return;
				 target=items[ord];
				 if(target.selected==true) return
				if(	target.onSelect(ignoreEvent)){
					selctedItems.push(target);
					if(onSelected!=null && ignoreEvent==false){
						onSelected(target)
					}
				}
			}
			
		}
		
		public function selectByItem(item:ListItem,ignoreEvent:Boolean=false):void{
			
			if(multiSelect==false){
				if(selectedItem!=null){
					
					selectedItem.onDeSelect();
				}
				if(	item.onSelect(ignoreEvent)){
					selectedItem=item;
					if(onSelected!=null && ignoreEvent==false){
						onSelected(selectedItem);
					}
				}
				
			}else{
				if(item.selected==true) return
				if(	item.onSelect(ignoreEvent)){
					 selctedItems.push(item);
					if(onSelected!=null && ignoreEvent==false){
						onSelected(selectedItem);
					}
				}
			}
			//selectedItem=item;
			//selectedItem.onSelect();
		}
		
		protected function onScrollComplete():void
		{
			// TODO Auto Generated method stub
			//view.removeEventListener(Event.ENTER_FRAME,onScrolling)
			//content.mouseChildren=true;                                        
			//trace("onScrollComplete:"+slider.percent)
			checkSlider()
			if(slider.percent==1 && onBottom!=null){
				onBottom();
			}
			
		}
		
		protected function onScroll():void
		{
			// TODO Auto Generated method stub
			/*if(timer.running==false){
			timer.start();
			
			}
			
			content.mouseChildren=false;
			content.mouseEnabled=false;*/
			//trace("aaaaaaaaaaaaaaaaaaaa")
			//content.mouseChildren=false;                                        
			
			
		}		
		
		internal var  itemsLen:int=0;
		internal var tempMc:Sprite
		internal var offsetScroll:Number=0
		protected function onScrolling():void
		{
			if(content.y==prePosY){
				content.mouseChildren=true;   
			}
			// TODO Auto-generated method stub
			
			//	offsetScroll=content.y-prePosY;
			
			for(var i:int =0;i<itemsLen;i++){
				tempMc=items[i].view;
				
				if(tempMc.y+content.y+tempMc.height<0 ){
					tempMc.visible=false
				}else if(tempMc.y+content.y>height){
					tempMc.visible=false
					return
				}else{
					tempMc.visible=true;
				}
			}
			
			//	prePosY=content.y;
			
		}		
		
		public function get isSelectedAll():Boolean
		{
			return _isSelectedAll;
		}
		
		
	}
}