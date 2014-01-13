package com.ourbrander.ui
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	
	public class Panel extends UIObject
	{
		
		protected var border:Sprite
		protected var hashList:Array=[];
		protected var _currentHash:String="";
		protected var _defaultHash:String="";
		protected var _hasSpecialTransition:Boolean=false;
		public  var transDruation:Number=0;
		public function Panel(uiKey:String="Panel",view:Sprite=null)
		{
			super(uiKey,view);
			
		}
		
		override public function setView(view:Sprite):void{
			super.setView(view);
			view.mouseEnabled=false;
			if(content!=null){
				content.mouseEnabled=false;
			}
			
			bg.mouseChildren=false;
			bg.mouseEnabled=false;
			
		
			border=view.getChildByName("border") as Sprite;
			
			if(content==null){
				content=new Sprite();
				view.addChild(content);

			}
			
			if(border!=null){
				view.addChild(border);
			}
			
		}

		
 
		override public function removeChild(uiObject:UIObject):void{
			var len:int=_children.length;
			var item:UIObject;
			for(var i:int=0;i<len;i++){
				item=_children[i];
				if(item==uiObject){
					_children.splice(i,1);
					content.removeChild(item.view);
					item.parent=null;
					return;
				}
			}
			
		}
		
		override protected function resizeChild():void{
			var len:int=_children.length;
			var item:UIObject
			
			
			for(var i:int=0;i<len;i++){
				item =_children[i];
				
					
				if(item.position==UIObject.POSITION_TYPE_ABSOLUTE){
				 
					
					if(item.alignH==UIObject.ALIGN_RIGHT){
						item.x=width-item.width;
						 
					}else{
						item.x=0;
						 
					}
					
					if(item.alignV==UIObject.ALIGN_BOTTOM){
						item.y=height-item.height
					}else{
						item.y=0
						
					}
				
					/*if(item.bottom!=0){
					item.view.y=height-item.view.height-item.bottom;
					}else{
					item.view.y=item.top
					}
					
					if(item.right!=0){
					item.view.x=width-item.view.width-item.right;
					}else{
					item.view.x=item.left
					}*/
					//item.y=height-item.view.height;
				//	item.x=width-item.view.width
				}else if(item.position==UIObject.POSITION_TYPE_CUSTOM){
					
				}
				
				 if(item.scaleMode==StageScaleMode.EXACT_FIT){
					 item.resize(_innerWidth,_innerHeight)
				 }else{
					 item.resize();
				 }
				
			}
		}
		
		public function setHash(hash:*,obj:Object=null):void{
			if(hash is String){
				hashList=hash.split("/")
			}else if(hash is Array){
				hashList=hash;
			}
			
			var chash:String=hashList.shift();
			if(chash==null || chash=="" ) chash=_defaultHash;
			onHashChange(chash,obj)
		}

		public function get currentHash():String
		{
			return _currentHash;
		}
		
		
		protected function onHashChange(hash:String,obj:Object=null):void{
		 
			_currentHash=hash;
		}
		
		public function reset():void{
			
		}
		public function playOut(onComplete:Function,onCompleteParams:Array=null):void{
			if(onComplete!=null){
				if(onCompleteParams!=null){
					onComplete(onCompleteParams)
				}else{
					onComplete()
				}
				
			}
		}
		
		public function playIn(onComplete:Function,onCompleteParams:Array=null):void{
			if(onComplete!=null){
				if(onCompleteParams!=null){
					onComplete(onCompleteParams)
				}else{
					onComplete()
				}
				
			}
		}

		public function beforePlayIn(params:Object=null):void{
			
		}
		public function get hasSpecialTransition():Boolean
		{
			return _hasSpecialTransition;
		}

		
	}
}