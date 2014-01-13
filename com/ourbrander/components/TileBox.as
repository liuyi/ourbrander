package com.ourbrander.components 
{
	import com.ourbrander.components.scrollBar.ScrollBar;
	import com.ourbrander.utils.Utils;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author liu yi
	 */
	public class TileBox extends Sprite 
	{
		private var _list:Vector.<TileItem>;
		private var _container:Sprite;
		private var _scrollbar:ScrollBar;
		private var _mask:Sprite;
		private var _padding:Number = 5;
		private var _scrollBarSkin:String = "";
		private var _scrollSkinNames:Array;
		private var _bg:Sprite;
		private var _autoDestory:Boolean;
		public function TileBox(w:Number = 100, h:Number = 100 ) 
		{
			_list = new Vector.<TileItem>();
			
			_container = new Sprite();
			addChild(_container);
			_bg = new Sprite();
			_bg.graphics.beginFill(0, 0);
			_bg.graphics.drawRect(0, 0, 100, 100);
			_bg.graphics.endFill();
			_container.addChild(_bg);
			
			_mask = new Sprite();
			_mask.graphics.beginFill(0);
			_mask.graphics.drawRect(0, 0, 100, 100);
			_mask.graphics.endFill();
			
			addChild(_mask);
			
			_container.mask = _mask;
			
			displayArea(w,h);
		}
		
		public function addTile(target:DisplayObject,data:Object=null):void {
			
			if (target == null) return;
			
			var item:TileItem = new TileItem(target, data);
			if (_list.length == 0) {
				_container.addChild(item);
				_list.push(item);
				return;
			}
			
			
			var prevItem:TileItem = _list[_list.length - 1];
			
			
			var posX:Number = prevItem.x+prevItem.width   + _padding;
			if (posX +item.width> _mask.width) {
				item.x = 0;
				item.y =int( _padding + prevItem.height+prevItem.y);
			}else {
				item.x = int(posX);
				item.y = int(prevItem.y);
			}
			
			_list.push(item);
			_container.addChild(item);
			
			update();
		}
		
		public function removeAll():void{
			while(_container.numChildren>0) _container.removeChildAt(0);
			while(_list.length>0){
				_list[0]=null;
				_list.shift();
			}
			update();
			
		}
		
		public function destory():void{
			if(_scrollbar!=null) {
				_scrollbar.destroy();
				_scrollbar=null;
			}
		}
		
		
		protected function update():void {
			if (_container.height > _mask.height ) {
				if (_scrollbar == null && _scrollBarSkin!="") {
					_scrollbar = new ScrollBar(_container);
					_scrollbar.setInterface(Utils.getObj(_scrollBarSkin) as Sprite,_scrollSkinNames);
					_scrollbar.x = _container.x + _mask.width;
					_scrollbar.y = _mask.y;
					_scrollbar.autoDestory=_autoDestory;
					addChild(_scrollbar);
					
				}
			}else if(_scrollbar!=null) {
				_scrollbar.visible = false;
			}
			if(_scrollbar!=null)
				_scrollbar.rest();
			_bg.width = _container.width;
			_bg.height = _container.height;
		}
		
		
		
		public function displayArea(w:Number,h:Number):void 
		{
			if (_mask != null) {
				_mask.width = w
				_mask.height = h
			}
			
			
		}
		public function set padding(num:Number):void{
			_padding=num;
		}
		
		public function get padding():Number{
			return _padding;
		}
		
		public function get scrollBarSkin():String 
		{
			return _scrollBarSkin;
		}
		
		public function setScrollBarSkin(value:String,names:Array=null,$autoDestory:Boolean=true):void 
		{
			_scrollBarSkin = value;
			_scrollSkinNames=names
			_autoDestory=$autoDestory
		}
		
		
		
	}
	
}