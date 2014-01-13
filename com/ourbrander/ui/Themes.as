package com.ourbrander.ui
{
	import com.ourbrander.utils.Utils;

	public class Themes
	{
		private static var _currentTheme:Theme
		private static var _themeList:Vector.<Theme>=new Vector.<Theme>();
		public static var defaultThemeName:String=""
		
		public static function useTheme(name:String):void{
			var len:int=_themeList.length;
			for(var i:int=0;i<len;i++){
				if(_themeList[i].name==name){
					_currentTheme=_themeList[i];
					trace("_currentTheme:"+_currentTheme)
					break;
				}
			}//end for;

		}
		
		public static function getUIName(key:String):String{
			var uiNode:Object=_currentTheme[key];
			if(uiNode==null) return "";
			return uiNode.name
		}
		
		/**
		 * @return {name:String,config:Object}
		 */
		public static function getUINode(key:String):Object{
			var uiNode:Object=_currentTheme[key];
		
			return uiNode
		}
		
		public static function init(xml:XML):void{
		
			var tempDefaultThemeName:String=xml.@defaultTheme;
			var xmlNodes:XMLList=xml.theme;
			var len:int=xmlNodes.length();
			var theme:Theme;
			var node:XML;
			var uiNode:XML
			var obj:Object;
			for(var i:int=0;i<len;i++){
				theme=new Theme();
				node=xmlNodes[i];
				theme.name=Utils.trim(node.@name);
				
			 
				var nodeLen:int=node.child("*").length();
				for(var k:int=0;k<nodeLen;k++){
					uiNode=node.child(k)[0];
					
						if(uiNode.config!=null && uiNode.config!="" && uiNode.config!=undefined){
							try{
								//trace(uiNode.config)
								obj=JSON.parse(uiNode.config);
								//trace("node.config:"+obj)
							}catch(evt:Error){
								obj=null;
								trace("parse json error:"+evt)
							}
						}else{
							obj=null;
						}
					
					
					theme[uiNode.name()]={name:uiNode.@name,config:obj};
				}
				
				if(tempDefaultThemeName==null && i==0){
					defaultThemeName=theme.name;
				}else if(tempDefaultThemeName==theme.name){
					defaultThemeName=theme.name;
				}
				
				_themeList.push(theme);
			}
			
			if(defaultThemeName==""){
				defaultThemeName=_themeList[0].name;
			}
			
			useTheme(defaultThemeName);
			
			trace("UI mamanger inited")
		}

		public static function get currentTheme():Theme
		{
			return _currentTheme;
		}

		
		public function Themes()
		{
		}
	}
}