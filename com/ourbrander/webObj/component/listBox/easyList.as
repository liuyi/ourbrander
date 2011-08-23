package com.ourbrander.webObj.component.listBox 
{
	import com.ourbrander.webObj.component.scrollBar.ctScrollbar;
	import com.ourbrander.webObj.component.scrollBar.textScrollbar;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author liuyi
	 */
	public class easyList extends Sprite
	{
		protected var _hslide:ctScrollbar
		protected var _vslide:textScrollbar
		protected var _container:InteractiveObject
		protected var _mask:DisplayObject
		protected var _bg:DisplayObject
		
		protected var _data:Array //store cells queue
		protected var HorizontalScroll:String="auto"
		protected var VerticalScroll:String = "auto"
		protected var _autoAdapting:Boolean=true
		
		
		public function easyList() 
		{
			init()
		}
		protected function init() {
			for (var i = 0 ; i < this.numChildren; i++) {
				var _mc = this.getChildAt(i)
				_mc.visible=false
			}
		}
		protected function setInterface(target:*) {
			updateSkin()
		}
		protected function updateSkin() {
			
		}
		public function setScrollStlye() {
			
		}
		public function set autoAdapting(boolean:Boolean) {
			_autoAdapting=boolean
		}
		public function get autoAdapting():Boolean {
			return _autoAdapting
		}
		public function addCell(cell:*) {
			
		}
		public function addCellBefore(id:uint) {
			
		}
		public function addCellAfter(id:uint) {
			
		}
		public function removeCell(id:uint) {
			
		}
		
	}

}