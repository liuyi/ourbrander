package com.ourbrander.components 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author liu yi
	 */
	public class TileItem extends Sprite 
	{
		public var data:Object;
		private var _target:DisplayObject
		public function TileItem(object:DisplayObject,data:Object=null) 
		{
			target = object;
			this.data = data;
		}
		
		public function get target():DisplayObject 
		{
			return _target;
		}
		
		public function set target(object:DisplayObject):void 
		{
			_target = object;
			
			if (_target != null) {
				_target.x = 0; 
				_target.y = 0;
				addChild(_target);
			}
		}
		
	}

}