package com.ourbrander.utils
{
	import flash.system.Capabilities;

	public class Language
	{
		private static var xml:XML;
		public static var surpoorts:Array;
		public static var currentLanXML:XML;
		public static var currentLan:String;
 
		/*private static var _instance:Language;
		public static  function getInstance():Language{
			if(_instance==null){
				_instance=new Language();
			}
			return _instance;
		}*/
		public function Language()
		{
			
			
		 
			trace("Capabilities.languages:"+Capabilities.languages)
			trace("Capabilities.languages:"+Capabilities.language)
		}
		
		public static function setXML(data:XML):void{
			currentLan=Capabilities.languages[0].toLocaleLowerCase() ;
			xml=data;
			currentLanXML=getCurrentLanData();
		}
		
		protected static function getCurrentLanData():XML{
			if(currentLan.indexOf("-")>0){
				var lanArr:Array=currentLan.split("-");
			}else{
				 lanArr=[currentLan];
			}
			
			var len:int=xml.lan.length();
			var node:XML;
			var lanNode:XML;
 
			//trace("len:"+len)
			for(var i:int=0;i<len;i++){
				node=xml.lan[i];
				if(node.@name==lanArr[0]){
					lanNode=node;
					break;
				} 
			}
			
			if(lanNode==null){
				for( i=0;i<len;i++){
					node=xml.lan[i];
					if(node.@belong==lanArr[0]){
						lanNode=node;
						break;
					} 
				}
			}
			
			
			if(lanNode==null){
				for( i=0;i<len;i++){
					node=xml.lan[i];
					if(node.@belong==xml.@defaultLan){
						lanNode=node;
						break;
					} 
				}
			}
			return lanNode;
			
			
		}
		
	}
}