package com.ourbrander.ui
{
	import com.ourbrander.utils.Utils;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.Dictionary;
	
	public class UIObject extends EventDispatcher 
	{
		public static const POSITION_TYPE_CUSTOM:int=1;
		public static const POSITION_TYPE_ABSOLUTE:int=2;
		public static const ALIGN_LEFT:int=1;
		public static const ALIGN_RIGHT:int=2;
		public static const ALIGN_TOP:int=3;
		public static const ALIGN_BOTTOM:int=4;
		private static var index:int=0;
		protected var _view:Sprite;
		protected var _children:Vector.<UIObject>=new Vector.<UIObject>();
		protected var _parent:UIObject;
		public var alignH:int=ALIGN_LEFT;
		public var alignV:int=ALIGN_TOP;
		public var scaleMode:String=StageScaleMode.NO_SCALE;
		protected var _paddingLeft:int=0;
		protected var _paddingRight:int=0;
		protected var _paddingTop:int=0;
		protected var _paddingBottom:int=0;
		
		protected var _marginLeft:int=0;
		protected var _marginTop:int=0;
		protected var _marginRight:int=0;
		protected var _marginBottom:int=0;
		
		protected var _innerWidth:int=0;
		protected var _innerHeight:int=0;
		
		public var spaceH:Number=0;
		public var spaceV:Number=0;
		
		protected var _width:Number=0;
		protected var _height:Number=0;
		
		protected var _uiKey:String="";
		//protected var _noTheme:Boolean=false;
		
		public var fixHeight:Boolean=false;
		public var fixWidth:Boolean=false;
		
		/**
		 * @desc default value 0 is mean no limit
		 */
		public var minWidth:Number=0;
		/**
		 * @desc  default value 0 is mean no limit
		 */
		public var minHeight:Number=0;
		
		/**
		 * @desc  default value 0 is mean no limit
		 */
		public var maxHeight:Number=0;
		/**
		 * @desc  default value 0 is mean no limit
		 */
		public var maxWidth:Number=0;
		
		public var position:int=UIObject.POSITION_TYPE_CUSTOM;
		public var left:Number=0;
		public var top:Number=0;
		public var right:Number=0;
		public var bottom:Number=0;
		
		public var content:Sprite
		public var bg:Sprite
		protected var _id:int=0;
		protected var _x:Number=0;
		protected var _y:Number=0;
		protected var _extendHeight:Number=0;
		protected var _extendWidth:Number=0;
		
		public var enableResize:Boolean=true;
		
		protected var tipList:Dictionary=new Dictionary();
		
		protected var _isDisable:Boolean=false;
		
		public var attrs:Object
		public var config:Object//set this data from xml
		public function UIObject(uiKey:String="",view:Sprite=null)
		{
			
			_id=++index;
			this._uiKey=uiKey;
			if(view!=null){
				setView(view);
			}else  if( _uiKey!=""){
				var uiNode:Object=Themes.getUINode(_uiKey);
				config=uiNode.config;
				var view2:Sprite=Utils.getObj(uiNode.name) as Sprite;
				setView(view2);
			}
		}
		
		/**
		 * @desc destroy all elements of the object, do this after remove view from stage.
		 */
		public function destroy():void{
			try{
				if(_parent!=null){
					_parent.removeChild(this);
					_parent=null;
				}
			}catch(e:Error){
				
			}
			
			for(var i:int=0;i<_children.length;i++){
				_children[i].destroy();
				
			}
			
			if(_children!=null){
				_children.length=0;
				_children=null;
			}
			
			if(tipList!=null){
				for (var k:DisplayObject in tipList){
					delete tipList[k];
				}
				
				tipList=null;
				
			}
			
			
			content=null;
			bg=null;
			if(_view!=null){
				_view.contextMenu=null;
				
				if(_view.parent!=null){
					try{
						_view.parent.removeChild(_view);
					}catch(e:Error){}
				}
				_view=null;
			}
			
			
			
			
		}
		
		public function resize(width:Number=0,height:Number=0):void{
			if(enableResize==false) return;
			width+=_extendWidth;
			height+=_extendHeight
			
			
			if(fixWidth==false){
				
				if( width>=0 && width>this.minWidth){
					this.width=width;
				}else if(minWidth>0){
					this.width=minWidth;
				}else{
					//this.width=this.view.width;
					//	trace(" don't set width=======================")
				}
				
				if(maxWidth>0 && maxWidth<this.width){
					this.width=maxWidth;
				}
				
			}
			
			if(fixHeight==false){
				//this.height=(height<minHeight && height>0)?minHeight:height;
				if( height>=0 && height>this.minWidth){
					this.height=height;
				}else if(minHeight>0){
					this.height=minHeight;
				}else{
					//this.width=this.view.width;
				}
				
				if(maxHeight>0 && maxHeight<this.height){
					this.height=maxHeight;
					
				}
				
				
			}
			
			caculateLayout();
			
			resizeSelf();
			resizeChild();
			
		}
		
		protected function resizeSelf():void{
			if(bg!=null){
				bg.width=width;
				bg.height=height;
			}
		}
		
		protected function resizeChild():void{
			
			
		}
		
		
		
		protected function caculateLayout():void{
			_innerWidth=width-_paddingLeft-_paddingRight;
			_innerHeight=height-_paddingTop-paddingBottom;
		}
		
		
		
		public function setView(view:Sprite):void{
			
			if(this.view!=null){
				var viewParent:Sprite=this.view.parent as Sprite;;
			}else{
				viewParent=null;
			}
			
			clearView();
			this._view=view;
			try{
				this._view.name=uiKey;
			}catch(e:Error){}
			
			
			view.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage)
			//view.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage)
			content=view.getChildByName("content") as Sprite;
			bg=view.getChildByName("bg") as Sprite;
			
			
			
			
			if(this.width==0){
				
				if(view.scaleX!=1){
					if(bg!=null){
						this.width=bg.width*view.scaleX;
					}else{
						this.width=view.width;
					}
					view.scaleX=1;
					
				}else{
					
					if(bg!=null){
						this.width=bg.width;
					}else{
						this.width=view.width;
					}
				}
				
				
			}
			if(this.height==0){
				
				if(view.scaleY!=1){
					
					if(bg!=null){
						this.height=bg.height*view.scaleY;
					}else{
						this.height=view.height;
					}
					view.scaleY=1;
					
				}else{
					if(bg!=null){
						this.height=bg.height;
					}else{
						this.height=view.height;
					}
					
				}
				
				
			}
			
			
			if(_parent!=null){
				
				if(_parent.content!=null){
					_parent.content.addChild(view);
				}else{
					_parent.view.addChild(view);
				}
				
			}else if(viewParent!=null){
				viewParent.addChild(view);
				
			}
			
			if(_isDisable){
				disable();
			}else {
				enable();
			}
		}
		
		protected function onRemoveFromStage(event:Event):void
		{
			// TODO Auto-generated method stub
			
			for(var item:DisplayObject in tipList){
				tipList[item]=null;
				delete tipList[item];
			}
			
			//view.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage)
			view.removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage)
		}
		
		protected function onAddedToStage(event:Event):void
		{
			view.addEventListener(MouseEvent.MOUSE_OVER,onTipOver);
			view.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			
			
			
			
		}
		
		protected function addTip(target:DisplayObject,desc:String):void{
			tipList[target]=desc;
		}
		
		protected function removeTip(target:DisplayObject):void{
			tipList[target]=null;
			delete tipList[target];
		}
		
		
		
		protected function onTipOver(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			event.preventDefault()
			for(var item:DisplayObject in tipList){
				if(item==event.target){
					UIManager.showTip(item,tipList[item]);
				}
				
			}
		}
		
		public function get view():Sprite{
			return _view;
		}
		
		public function onThemeChange():void{
			
			var obj:Object=Themes.getUINode(_uiKey);
			//	var viewName:String=Themes.getUIName(_uiKey);
			if(obj==null || obj.name==""){
				trace("can not find ui:"+_uiKey)
				return;
			}
			
			config=obj.config;
			var view2:Sprite=Utils.getObj(obj.name) as Sprite;
			setView(view2);
			
			var len:int=_children.length;
			var item:UIObject;
			for(var i:int=0;i<len;i++){
				item=_children[i];
				item.onThemeChange();
			}
		}
		
		
		
		
		protected function clearView():void{
			if(_view==null) return;
			
			view.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage)
			if(view.parent!=null){
				
				view.parent.removeChild(view);
				content=null;
			}
			
			
		}
		
		
		public function disable():void{
			_isDisable=true;
			if(view!=null) {
				view.alpha=0.5;
				view.mouseEnabled=false;
				//view.mouseChildren=false;
				
			}
		}
		
		public function enable():void{
			_isDisable=false;
			if(view!=null) {
				view.alpha=1;
				view.mouseEnabled=true;
				//view.mouseChildren=children;
			}
		}
		public function isDisable():Boolean{
			return _isDisable;
		}
		
		public function get parent():UIObject
		{
			return _parent;
		}
		
		public  function set parent(uiObject:UIObject):void{
			if(_parent!=null && _parent!=uiObject ){
				parent.removeChild(uiObject);
			}
			this._parent=uiObject;
			
		}
		
		/**
		 * @params addViewToParent, somtimes we don't want add view to parent, set it to false.
		 */
		public function addChild(uiObject:UIObject,addViewToParent:Boolean=true):void{
			
			
			
			if(uiObject.parent!=this){
				if(_children==null) {
					_children=new Vector.<UIObject>();
				}
				
				if(uiObject.parent!=null){
					uiObject.parent.removeChild(uiObject);
				}
				_children.push(uiObject);
			}
			uiObject.parent=this;
			if(addViewToParent==false) return;
			if(content!=null){
				content.addChild(uiObject.view);
			}else{
				_view.addChild(uiObject.view);
			}
			
			
			
			
		}
		
		
		
		public function addChildAt(uiObject:UIObject,index:int=0,addViewToParent:Boolean=true):void{
			if(uiObject.parent!=this){
				_children.push(uiObject);
			}
			if(addViewToParent==false) return;
			if(content!=null){
				content.addChildAt(uiObject.view,index);
			}else{
				_view.addChildAt(uiObject.view,index);
			}
			
			uiObject.parent=this;
			//resize();
		}
		
		public function addViewTo(target:DisplayObjectContainer,index:int=-1):void{
			
			if(index<0){
				target.addChild(this.view);
				
			}else{
				target.addChildAt(this.view,index);
			}
		}
		
		public function removeChild(uiObject:UIObject):void{
			var len:int=_children.length;
			var item:UIObject;
			for(var i:int=0;i<len;i++){
				item=_children[i];
				if(item==uiObject){
					_children.splice(i,1);
					if(content!=null){
						content.removeChild(item.view);
					}else{
						_view.removeChild(item.view);
					}
					
					item.parent=null;
					return;
				}
			}
		}
		
		public function removeAllChildren(destroy:Boolean=false):void{
			var item:UIObject;
			while(_children.length>0){
				item=_children.shift();
				item.parent=null;
				
				if(content!=null){
					content.removeChild(item.view);
				}else{
					_view.removeChild(item.view);
				}
				
				if(destroy)
					item.destroy();
			}
		}
		
		
		
		public function setPadding(left:int,top:int,right:int,bottom:int):void{
			
			if(left>=0){
				_paddingLeft=left;
			}
			if(top>=0){
				_paddingTop=top;
			}
			if(right>=0){
				_paddingRight=right;
			}
			if(bottom>=0){
				_paddingBottom=bottom;
			}
			
			
		}
		
		public function get paddingLeft():int
		{
			return _paddingLeft;
		}
		
		public function get paddingRight():int
		{
			return _paddingRight;
		}
		
		public function get paddingTop():int
		{
			return _paddingTop;
		}
		
		public function get paddingBottom():int
		{
			return _paddingBottom;
		}
		
		public function setMargin(left:int,top:int,right:int,bottom:int):void{
			
			if(left>=0){
				_marginLeft=left;
			}
			if(top>=0){
				_marginTop=top;
			}
			if(right>=0){
				_marginRight=right;
			}
			if(bottom>=0){
				_marginBottom=bottom;
			}
			
			
		}
		
		public function get marginLeft():int
		{
			return _marginLeft;
		}
		
		public function get marginTop():int
		{
			return _marginTop;
		}
		
		public function get marginRight():int
		{
			return _marginRight;
		}
		
		public function get marginBottom():int
		{
			return _marginBottom;
		}
		
		public function get width():Number
		{
			return _width;
		}
		
		public function set width(value:Number):void
		{
			_width = value;
		}
		
		public function get height():Number
		{
			return _height;
		}
		
		public function set height(value:Number):void
		{
			_height = value;
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function get uiKey():String
		{
			return _uiKey;
		}
		
		public function get x():Number
		{
			
			return _x;
		}
		
		public function set x(value:Number):void
		{
			if(view!=null){
				
				view.x=value+marginLeft-marginRight+left-right;
				
			}
			_x = value;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(value:Number):void
		{
			if(view!=null){
				view.y=value+marginTop-marginBottom+top-bottom;
			}
			_y = value;
			
			if(uiKey=="Slider"){
				trace("********Slider set y*********************"+_y)
			}
		}
		
		public function get extendHeight():Number
		{
			return _extendHeight;
		}
		
		public function set extendHeight(value:Number):void
		{
			_extendHeight = value;
		}
		
		public function get extendWidth():Number
		{
			return _extendWidth;
		}
		
		public function set extendWidth(value:Number):void
		{
			_extendWidth = value;
		}
		
		
		public function get numChidren():int{
			return _children.length;
		}
		
		public function get children():Vector.<UIObject>{
			return _children;
		}
		
		
	}
}