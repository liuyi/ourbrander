package com.ourbrander.ui
{
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Button extends UIObject
	{
		public var icon:MovieClip
		public var txt:TextField;
		public var hover:Sprite;
		public var selectedLabel:Sprite;
		protected var _selected:Boolean=false;
		public var textAlign:String="left";
		protected var  _iconPos:String="left";
		public var iconPadding:Number=5;
		
	 
		public var txtOverFormat:TextFormat;
		public var txtOutFormat:TextFormat;
		public var txtSelectFormat:TextFormat;
 
		
		
		public var txtOverStyle:Object;
		public var txtOutStyle:Object;
		public var txtSelectStyle:Object;
		
		public var hoverOverStyle:Object;
		public var hoverOutStyle:Object;
		public var hoverSelectStyle:Object;
		
		
		public var iconOverStyle:Object;
		public var iconOutStyle:Object;
		public var iconSelectStyle:Object;
		public var transDruation:Number=0;
		public function Button(uiKey:String="Button",view:Sprite=null)
		{
			super(uiKey,view);
		}
		
		override public function destroy():void{
			txtOverFormat=null;
			txtOutFormat=null;
			txtOutFormat=null;
			
			
			
			txtOverStyle=null;
			txtOutStyle=null;
			txtSelectStyle=null;
			
			hoverOverStyle=null;
			hoverOutStyle=null;
			hoverSelectStyle=null;
			
			
			iconOverStyle=null;
			iconOutStyle=null;
			iconSelectStyle=null;
			
			icon=null;
			txt=null;
			hover=null;
			selectedLabel=null;
			super.destroy();
		}
		
		override public function setView(view:Sprite):void{
			super.setView(view);
			icon=view.getChildByName("icon") as MovieClip;
			txt=view.getChildByName("txt") as TextField;
			hover=view.getChildByName("hover") as Sprite;
			selectedLabel=view.getChildByName("selectLabel") as Sprite;
			
			view.mouseChildren=false;
			view.buttonMode=true;
			view.mouseEnabled=true
			
			if(txt!=null){
				txt.autoSize="left";
				txt.mouseEnabled=false;
			}
			if(hover!=null){
				hover.visible=false
				//hover.mouseEnabled=false;
				//hover.mouseChildren=false;
			}
			
			
		}
		
		public function setLabel(label:String=""):void{
			txt.htmlText=label;
			//resizeSelf();
		}
		
		public function get label():String{
			return txt.text;
		}
		
		/**
		 * @return boolean, if reurn false, it means can not select this item.
		 */
		public function onSelect(ignoreEvent:Boolean=false,event:MouseEvent=null):Boolean{
			return true;
		}
		
		
		public function onDeSelect(event:MouseEvent=null):Boolean{
		
			return true;
		}
		
		
		public function onHover(event:MouseEvent=null):void{
			if(_selected) return;
			
			if(txt){
				
				
				if(txtOverStyle!=null){
					TweenMax.to(txt,transDruation,txtOverStyle);
				}
				
				if(txtOverFormat!=null){
					txt.setTextFormat(txtOverFormat);
				}
				
			}
			
			
			
			if(hover ){
				if(hoverOverStyle!=null){
					TweenMax.to(hover,transDruation,hoverOverStyle);
				}else{
					TweenMax.to(hover,transDruation,{autoAlpha:1});
				}
			}
			
			if(icon && iconOverStyle){
				TweenMax.to(icon,transDruation,iconOverStyle);
			}
			
		}
		
		public function onOut(event:MouseEvent=null):void{
			if(_selected) return;
			
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
			
			if(icon && iconOutStyle){
				TweenMax.to(icon,transDruation,iconOutStyle);
			}
		}
		
		/*
		override protected function resizeSelf():void{
			bg.width=width;
			txt.width=txt.textWidth;
			txt.height=txt.textHeight;
			if(icon!=null){
				if(_iconPos=="left"){
					icon.x=paddingLeft;
					icon.y=paddingTop+(height-icon.height-paddingTop-paddingBottom)*0.5;
					
					if(txt!=null){
						txt.x=int(iconPadding+icon.x+icon.width);
						txt.y=int(paddingTop+(height-txt.height-paddingTop-paddingBottom)*0.5);
					}
					
				}else if(_iconPos=="right"){
					icon.x=width-paddingRight-icon.width;
					icon.y=paddingTop+(height-icon.height-paddingTop-paddingBottom)*0.5;
					
					if(txt!=null){
						txt.x=int(icon.x-icon.width-iconPadding-txt.width);
						txt.y=int(paddingTop+(height-txt.height-paddingTop-paddingBottom)*0.5);
					}
				}else if(_iconPos=="top"){
					icon.x=paddingLeft+(width-icon.width-paddingLeft-paddingRight)*0.5;
					icon.y=paddingTop;
					if(txt!=null){
						txt.x=int(paddingLeft+(width-txt.width-paddingLeft-paddingRight)*0.5);
						txt.y=int(icon.y+icon.height+iconPadding);
					}
					
				}else if(_iconPos=="bottom"){
					
					icon.x=paddingLeft+(width-icon.width-paddingLeft-paddingRight)*0.5;
					icon.y=height-paddingBottom-icon.height;
					if(txt!=null){
						txt.x=int(paddingLeft+(width-txt.width-paddingLeft-paddingRight)*0.5);
						txt.y=int(icon.y-icon.height-iconPadding-txt.height);
					}
				}
				
				icon.x=int(icon.x);
				icon.y=int(icon.y);
			}else if(txt!=null){
				
				
				txt.y=int(paddingTop+(height-txt.height-paddingTop-paddingBottom)*0.5);
				txt.x=int(paddingLeft);
			}
			
			
			
			
		}
		*/
		override protected function resizeSelf():void{
			
			super.resizeSelf()
			 
			if(hover){
				hover.width=bg.width;
				hover.height=bg.height
			}
			
			if(selectedLabel){
				selectedLabel.width=bg.width;
				selectedLabel.height=bg.height
			}
			
			
			
		}
		
		
		
	}
}