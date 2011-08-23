package com.ourbrander.data 
{
	import com.ourbrander.xmlObject.xmlFrame;
	import flash.events.EventDispatcher;
	import flash.text.StyleSheet;
	/**
	 * ...
	 * @author liuyi
	 */
	

	 /**
	  * updatea:2011/6/23  
	  * change LanPackage :XMLList to XML;
	  * added get function page, and added new tag in language:
	  * <language>
	  * 		<en>
	  * 			<page id='page name'>
	  * 					<page id='child page name'/>
	  * 			</page>
	  * 			<page  id='page name'></page>
	  * 		</en>
	  * 		<cn></cn>
	  * 	</language>
	  * 
	  * 
	  * update:2010-12-27
	  * fixed a small bug: when data is null ,get data occured a error.
	  * data xml basic format
	  * :<data>
	  *    <others/>
	  * 	<language>
	  * 		<en>
	  * 		</en>
	  * 		<cn></cn>
	  * 	</language>
	  *     <css>
	  * 			<en></en>
	  * 			<cn></cn>
	  * 	</css>
	  * </data>
	  */
	public class DataManager extends Object
	{
		private static var _dataManager:DataManager
		private var _cssList:Array;
		private var _xml:XML
		private var _lan:String;
		private var _page:PageData
	
		
		public function DataManager() :void
		{
			if (_dataManager != null) {
				return ;
			}
			_cssList = [];
		}
		
		public static function getInstance() :DataManager {
			if (_dataManager == null) {
				_dataManager = new DataManager(); ;
			}
			return _dataManager;
		}
		
		public function set data(d:XML) :void {
			
			_xml = d;
			language=_xml.language.@default
			setCss()
		}
		public function get data():XML {
			if (_xml == null) {
				return null
			}else{
				return new XML( _xml.toString());
			}
		}
		public function set language(str:String) :void {
			_lan = str;
		}
		public function get language():String {
			return _lan;
		}
		public function get css():StyleSheet {
			
			return _cssList[language]
		}
		
		public function get LanPackage():XML {
			
			return _xml.language[_lan][0];
		}
		
		public function get page():PageData {
			if (_page == null) {
				_page = new PageData(LanPackage);
			}
			return _page;
		}
		
		public function  dispose() :void {
			while (_cssList.length > 0) {
				_cssList[0] = null;
				_cssList.splice(0);
			}
			_cssList = null;
			_xml = null;
		}
		
		private function setCss()  :void{
			if (_xml.css == null) { return };
			var css_len:uint = _xml.css.child("*").length();
		
			for (var i = 0; i < css_len; i++ ) {
				
				var tcss:StyleSheet = new StyleSheet();
				tcss.parseCSS(_xml.css.child(i));
				_cssList[String(_xml.css.child(i).name())] = tcss
			
			}
			
			
			
		}
		
	}

}