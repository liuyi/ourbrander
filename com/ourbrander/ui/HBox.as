package com.ourbrander.ui
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.getTimer;
	
	public class HBox extends Panel
	{
		
		public function HBox(uiKey:String="HBox",view:Sprite=null)
		{
			super(uiKey,view);
			
		}
		override public function setView(view:Sprite):void{
			super.setView(view);
			
			//draw();
		}
		
		override protected function resizeChild():void{
			var len:int=_children.length;
			var item:UIObject;
			
			var h:Number=height-paddingBottom-paddingTop;
			var w:Number=width-paddingLeft-paddingRight-(len-1)*spaceH;
			var x:Number=paddingLeft
			var y:Number=paddingTop
			
			var fixWidths:Number=0;
			var resizeList:Vector.<UIObject>=new Vector.<UIObject>()
			resizeList=_children.concat();
			
			
			var t:Number=getTimer();
			for(var i:int=0;i<resizeList.length;i++){
				
				item=resizeList[i];
				if(item.fixWidth){
					fixWidths+=item.width;
					resizeList.splice(i,1);
					item.resize(0,h);
					i--;
				}
			}
			if(resizeList.length>0){
				resizeList.sort(sortByMinWidth)
				w=w-fixWidths;
				var avgW:Number=0
				var done:Boolean=false
				
				while(done==false){
					//trace("resize loop*************************")
					avgW=w/resizeList.length;
					for(i=0;i<resizeList.length;i++){
						item=resizeList[i];
						if(item.minWidth>0 && item.minWidth>avgW){
							item.resize(item.minWidth,h);
							w=w-item.minWidth;
							resizeList.splice(i,1);
							if(resizeList.length>0){
								done=false;
							}else{
								done=true;
							}
							
							i--;
							break;
						}else{
							item.resize(avgW,h);
						//	trace("????????????????????")
							done=true
							
						}
					}
					
					
				}
			}//end if
			
			function sortByMinWidth(a:UIObject,b:UIObject):int{
				if(a.minWidth>b.minWidth) return 1;
				else if(a.minWidth==b.minWidth){
					return 0
				}else{
					return -1
				}
			}
			
			for( i=0;i<_children.length;i++){
				item=_children[i];
				
				item.x=x;
				item.y=y;
				//item.resize(avgW,h);
				x=x+item.width+spaceH
				
				
			}
			/*var avgW:Number=(w-fixWidths)/avgCount;
			for(i=0;i<resizeList.length;i++){
			item=resizeList[i];
			if(item.minWidth>0 && item.fixWidth==false && item.minWidth<avgW){
			fixWidths+= item.minWidth;
			avgCount--;
			trace("ssss")
			}
			trace("min:"+item.minWidth,item.minWidth<avgW,item.uiKey)
			}
			avgW=(w-fixWidths)/avgCount;
			
			trace("avgW:"+avgW,"avgCount:"+avgCount)
			for( i=0;i<resizeList.length;i++){
			item=resizeList[i];
			
			item.view.x=x;
			item.view.y=y;
			item.resize(avgW,h);
			x=x+item.width+spaceH
			
			}*/
			
			//trace("timer:"+(getTimer()-t))
		}
		
		
	}
}