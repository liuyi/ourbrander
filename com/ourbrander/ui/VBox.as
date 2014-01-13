package com.ourbrander.ui
{
 
	import flash.display.Sprite;
	import flash.utils.getTimer;
	
	public class VBox extends Panel
	{
		
		
		public function VBox(uiKey:String="VBox",view:Sprite=null)
		{
			super(uiKey,view);
		}
		
		
		override public function setView(view:Sprite):void{
			super.setView(view);

		}
		

		
		override protected function resizeChild():void{
		
			var len:int=_children.length;
			var item:UIObject;
			
			var h:Number=height-paddingBottom-paddingTop-(len-1)*spaceV;
			var w:Number=width-paddingLeft-paddingRight;
			var x:Number=paddingLeft
			var y:Number=paddingTop
			
			var fixHeights:Number=0;
			var resizeList:Vector.<UIObject>=new Vector.<UIObject>()
			resizeList=_children.concat();
			
		 
			var t:Number=getTimer();
			for(var i:int=0;i<resizeList.length;i++){
				
				item=resizeList[i];
				if(item.fixHeight){
					fixHeights+=item.height;
					resizeList.splice(i,1);
				 
					item.resize(w,0);
				 
					i--;
				}
			}
			
			if(resizeList.length>0){
				resizeList.sort(sortByMinWidth)
				h=h-fixHeights;
				var avgH:Number=0
				var done:Boolean=false
				
				while(done==false){
					avgH=h/resizeList.length;
			
					for(i=0;i<resizeList.length;i++){
						item=resizeList[i];
						if(item.minHeight>0 && item.minHeight>avgH){
						 
							item.resize(w,item.minHeight);
							h=h-item.minHeight;
							resizeList.splice(i,1);
							if(resizeList.length>0){
								done=false;
							}else{
								done=true;
							}
							i--;
							break;
						}else{
		 
							item.resize(w,avgH);
							done=true
						}
					}
			 
				}
			}//end if
			
			
			function sortByMinWidth(a:UIObject,b:UIObject):int{
				if(a.minWidth>b.minWidth) return 1;
				else if(a.minHeight==b.minHeight){
					return 0
				}else{
					return -1
				}
			}
			
			for( i=0;i<_children.length;i++){
				item=_children[i];
				
				item.x=x;
				item.y=y;
	
				y=y+item.height+spaceV
				
				
			}
		}
		
		
	}
}