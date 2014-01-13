package com.ourbrander.data
{
	import flash.display.BitmapData;

	/**
	 * 所有的角色位图资源BITMAP都存放到这里，初始化角色的时候到这里拿资源。没有的话用默认图片代替
	 * */
	public class BitmapDataLib
	{
		private static var _instance:BitmapDataLib;
		private var _bitmapList:Vector.<BtmpdtItem>;//所有的资源都存在这个列表里.
		public function BitmapDataLib()
		{
			if(_instance!=null) throw new Error("RoleAssets is a singleton classes!");
			
			_bitmapList=new Vector.<BtmpdtItem>();
		}
		
		
		public static function get instance():BitmapDataLib{
			if(_instance==null) _instance=new BitmapDataLib();
			return _instance;
		}
		
		/**
		 * 通过唯一的资源名字获取数据
		 * */
		public function getItem(name:String):BtmpdtItem{
			for each(var item:BtmpdtItem in _bitmapList){
				if(item.name==name) return item
			}
			return null;
		}//end function
		
		
		/**
		 * 将资源从库中完全删除
		 * */
		public function removeItem(name:String):void{
			var i:int=0;
			for each(var item:BtmpdtItem in _bitmapList){
				if(item.name==name){
					item.bitmapData.dispose();
					item=null;
					_bitmapList.splice(i,1);
				}
				i++
			}
			
		}//end function
		
		
	}
}
import flash.display.BitmapData;

//如果一个资源已经开始初始化，但是没有具体的bitmapData,就不要再去生成这样一个ITEM，而是应该等待资源加载完毕。
class BtmpdtItem{
	public var name:String;
	public var bitmapData:BitmapData
}