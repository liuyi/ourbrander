package com.ourbrander.xmlObject{
	/*奥博瑞德www.ourbraner.com QQ：14238910 Q群：技术不是唯一（1934054）
	类：XML序列化类(xmlFrame)
	继承：com.ourbrander.xmlObject.xmlObj
	说明：将任何XML文档进行序列化，并可根据任何节点的名字的值进行排序（可同时选择多个节点的值联合排序），
	生成排序好的新XML文档。
	属性：继承于xmlObj的xml:XML
	方法：
	构造函数 public function xmlFrame()
	
	排序：public function sortOn(...keywords)
	xmlFrame.sortOn([sortKeyword1,Array.DESCENDING],[sortKeyword2,Array.NUMERIC]，...,[sortKeyword_n,Array.NUMERIC])
	其中,sortKeyword1,sortKeyword2代表的是排序的关键字，以排在前面的为主要。
	Array.DESCENDING等为排序的标准。
	继承自xmlObj的方法
	装载XML：xmlFrame.loadXML(path:String)(其他方法请参看xmlObj类)
	事件：继承自xmlObj
	*/
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.EventDispatcher;
	import com.ourbrander.xmlObject.xmlObj;
	public class xmlFrame extends xmlObj {
		protected var _list:Array;//XML的数据分开存到这里
		private var _currentNum:Number;
		private var keywords:Array;

		public function xmlFrame() {
			super();
			//list 数组包括两个内容：_xml表示原XML中当前XML节点存放的内容。

			_list=new Array  ;
			this.addEventListener(Event.COMPLETE,structure);
		}
		//end function
		override public function dispose() {
			super.dispose();
			this.removeEventListener(Event.COMPLETE, structure);
			if(keywords!=null){
				while (keywords.length > 0) {
					keywords[0] = null;
					keywords.shift()
				}
				 
				keywords = null
			}
			 while (_list.length > 0) {
				_list[0] = null;
				_list.shift()
			} 
			_list=null
			
		}
		//将XML结构化为数组
		private function structure(e=null) {

			var rootNodeLength=_xml.child("*").length();

			for (var i=1; i <= rootNodeLength; i++) {
				var node=new XML(_xml.child(i - 1));
				var sortwords:Object=new Object();
				_list.push({_xml:node});

			}
			rootNodeLength=null;
		}
		//end function
		//获取XML转化为数组后的指定节点的XML内容
		private function getList(num) {
			//废除使用
			if (num>=_list.length) {

				return undefined;
			} else {
				return _list[num]._xml;
			}
		}//end function
        
		/*
		XML排序的主要方法,使用方法如：
		listxml.sortOn([sortKeyword1,Array.DESCENDING],[sortKeyword2,Array.NUMERIC]，...,[sortKeyword_n,Array.NUMERIC])
		其中,sortKeyword1,sortKeyword2代表的是排序的关键字，以排在前面的为主要。
		Array.DESCENDING等为排序的标准。
		*/
		//对排序过后的XML文件进行重构生成新的XML文件
		private function rebuilt() {
			delete _xml.*;
			//trace("delete..."+_list.length);
			for (var i=0; i<_list.length; i++) {

				_xml.appendChild(_list[i]._xml);

			}
		}
		public function sortOn(...keywords) {
			this.keywords=keywords;
			for (var i in _list) {
				this._currentNum=i;
				var tmpxml:XML=_list[i]._xml;
				searchChild(tmpxml);

			}
			sortby();
			rebuilt();
		}//end funtion
		//搜索整个XML数组，匹配排序关键字并添加临时排序关键字属性以及值
		private function searchChild(node:XML) {
			var tmpchildNum=node.child("*").length();
			if (node.hasComplexContent()) {

				for (var n=0; n < tmpchildNum; n++) {

					var tmpnode:XML=new XML(node.child(n));
					if (!tmpnode.hasComplexContent()) {

						setAttributes(tmpnode);
					} else {


						searchChild(tmpnode);//完整的节点

					}
					tmpnode=null;
				}//
				//end for
			} else {


				setAttributes(node);

			}//end if

		}//end function
		//为XML的结构数组添加搜索用到的临时排序属性和值
		private function setAttributes(node:XML) {
			for (var k in keywords) {

				if (node.name()==keywords[k][0]) {
					//给list加上相应的用来排序的属性node.name()和值node
					_list[this._currentNum][node.name()]=node;
				}//end if
			}//end for


		}//end function
		//最后完成搜索
		private function sortby() {

			var tmpWords=new Array();
			var tmpRuler=new Array();
			for (var i in keywords) {
				tmpWords.push(keywords[i][0].toString());
				if (keywords[i][1]!=undefined) {
					tmpRuler.push(keywords[i][1].toString());
				} else {
					tmpRuler.push(Array.NUMERIC);
				}
			}//end for
			_list.sortOn(tmpWords,tmpRuler);
			//for(var i=0;i<list.length;i++){

			//}
			//删除临时排序的属性和值
			for (var k in _list) {
				for (var del in _list[k]) {
					//trace(list[k]._xml+"\n---------------------\n");
					if (del.toString()!="_xml") {
						delete _list[k][del];
					}
				}//end for

			}//end for

		}//end function


	}//end class
}//end package