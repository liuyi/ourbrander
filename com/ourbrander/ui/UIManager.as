package com.ourbrander.ui
{
	import flash.display.DisplayObject;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class UIManager
	{
		public  static var stage:Stage;
		public static var layers:Array;
		public static var normalLayout:Sprite
		public static var uiObjs:Dictionary=new Dictionary();
		public static var windowList:Dictionary=new Dictionary();
		
		protected static var  tipWindow:NativeWindow
		protected static var  tip:Tip;
		protected static var  tipTarget:DisplayObject
		
		public function UIManager()
		{
			
		}
		public static function init(stage:Stage,normalLayout:Sprite):void{
			UIManager.stage=stage;
			UIManager.layers=layers;
			UIManager.normalLayout=normalLayout;
			normalLayout.width=stage.stageWidth;
			normalLayout.height=stage.stageHeight;
			normalLayout.scaleX=1;
			normalLayout.scaleY=1;
			stage.addEventListener(Event.RESIZE,onResize)
			
			stage.addChild(normalLayout)
		}
		
		public static function onResize(event:Event=null):void
		{
			var len:int=normalLayout.numChildren;
			var item:Window;
			for(var i:int in windowList){
				item=windowList[i] as Window;
				item.resize(stage.stageWidth,stage.stageHeight);
			}

		}
		
		public static function addWindow(uiObj:UIObject,layer:Sprite):void{
			uiObjs[uiObj.id]=uiObj;
			layer.addChild(uiObj.view);
			uiObj.resize(stage.stageWidth,stage.stageHeight);
		}
		
		public static function onThemeUpdate():void{
			var len:int=normalLayout.numChildren;
			var item:Window;
			for(var i:int in windowList){
				item=windowList[i] as Window;
				item.onThemeChange();
			}
		}
		
		public static function showTip(target:DisplayObject,desc:String):void{
			
			if(target.parent==null){
				return;
			}
			if(tip==null) {
				tip=new Tip();
		 
				var opts:NativeWindowInitOptions=new NativeWindowInitOptions();
				opts.owner=stage.nativeWindow;
				opts.systemChrome=NativeWindowSystemChrome.NONE;
				opts.transparent=true;
				
				opts.type=NativeWindowType.LIGHTWEIGHT;
				tipWindow=new NativeWindow(opts);
				
				tipWindow.stage.scaleMode=StageScaleMode.NO_SCALE;
				tipWindow.stage.align=StageAlign.TOP_LEFT;
				
				tipWindow.stage.addChild(tip.view);
				tipWindow.stage.addEventListener(Event.MOUSE_LEAVE,onMsLeave)
			}
			tip.text=desc;
			var p:Point=new Point(target.x,target.y);
			p=target.parent.localToGlobal(p)
				
			tipWindow.width=tip.view.width;
			tipWindow.height=tip.view.height;
			tipWindow.x=int(p.x+stage.nativeWindow.x+target.width)
			tipWindow.y=int(p.y+stage.nativeWindow.y-target.height*0.5);

			tipWindow.visible=true
			tipTarget=target;
		}
		
		protected static function onMsLeave(event:Event):void
		{
			// TODO Auto-generated method stub
		
			hideTip();
		}
		
		public static function hideTip(target:DisplayObject=null):void{
			if(tipWindow==null || tipTarget==target) return;
			tipWindow.visible=false
			tipTarget=null;
		}
		
		
		
		
	}
}