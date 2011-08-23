package com.ourbrander.data 
{
	/**
	 * ...
	 * @author liu yi
	 */
	public class PageData 
	{
		protected var _pages:Vector.<PageData>;
		protected var _data:XML;
		protected var _id:String
		/*
		 * data can be a xmllist or xml object.
		 * */
		public function PageData(data:Object) 
		{
			if (data is XMLList) {
				_data = data[0] as XML;
			}else if(data is XML){
				_data = data as XML;
			}else {
				throw new Error("PageData: data must be XML or XMLLIST instance! ")
			}
			init();
		}
		protected function init():void {
			if (_data == null) return;
			if (_data.@id!=null && _data.@id != undefined) {
				_id = _data.@id;
			}else {
				_id = "";
			}
			
			if (_data.page != null) {
				_pages = new Vector.<PageData>();
				var len:uint = _data.page.length();
				for (var i:uint = 0 ; i < len;i++ ) {
					_pages[i] =new PageData( _data.page[i]);
				}
				
			}
			
		}
		
		public function get id():String {
			return _id;
		}
		
		public function get xml():XML {
			return _data;
		}
		
		public function get pages():Vector.<PageData> {
			return _pages;
		}
		
		public function getChildById($id:String):PageData {
			var len:uint=_pages.length
			for (var i:uint = 0; i < _pages.length; i++) {
				if (_pages[i].id==$id) {
					return _pages[i];
				}
			}
			
			return null;
		}
		
	}

}