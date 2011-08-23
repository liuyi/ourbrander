package com.ourbrander.webObj.component.easyTree 
{
	import com.ourbrander.Event.superEvent;
	import com.ourbrander.xmlObject.xmlFrame;
	import flash.display.MovieClip;
	import flash.events.Event
	import flash.utils.getDefinitionByName
	
	/**
	 * ...
	 * @author liuyi,you can find more help from my blog:www.ourbrander.com liuyi
	 */
	public class tree extends MovieClip
	{
		private var _source:xmlFrame = new xmlFrame()
		private var _length:uint = 0
		private var _treeStyle:treeStyle
		private var _treeNodeStyle:String
		private var _treeCellStyle:String
		private var _mouseEnable:Boolean = true
		private var _showTOPLevel:Boolean = false
		private var _multiDisplay:Boolean = false
		private var _toplevelNodeBox:treeNodeBox
		
		private var _isInit:Boolean=false
		
		//panle
		private var _container:MovieClip=new MovieClip()
	    
		
		public function tree() 
		{
			addEvent()
			init()
		}
		private function init() {
			addChild(_container)
		}
		private function addEvent() {
			_source.addEventListener(Event.COMPLETE,xmlloaded)
		}
		public function set source($source:Object) {
			 
		 if (typeof($source ) == "string") {
			
				_source.loadXML(String($source))
			}else if (typeof($source )=="xml" ) {
				_source.xml=XML($source)
			}
	}
		public function get source() {
			var s=_source.xml
			return s
		}
		public function setStyle($treeNodeStyle:String,$treeCellStyle:String) {
			treeNodeStyle = $treeNodeStyle
			treeCellStyle=$treeCellStyle
		}
		public function set treeNodeStyle($treeNodeStyle) {
			_treeNodeStyle=$treeNodeStyle
		}
		
		public function get treeNodeStyle() {
			return _treeNodeStyle
		}
		public function set treeCellStyle($treeCellStyle) {
			_treeCellStyle=$treeCellStyle
		}
		public function get treeCellStyle() {
			return _treeCellStyle
		}
		public function set multiDisplay(val:Boolean) {
			_multiDisplay=val
		}
		public function get multiDisplay():Boolean {
			return _multiDisplay
		}
		public function renderTree(e:Event) {
			
		}
		private function updateTree() {
			//trace("updateTree")
			 
			var xmllist = _source.xml
			
			 getchild(xmllist, _container,-1)
		}
		
		 
		private function getchild(xml,container,index) {
			 
			if (xml.@single == "true") {
			 
				createChild(xml,container,index)
			}else{
			   
				var xmllength = xml.child("*").length()
				var chilcContainer
				 
				//trace("container:"+container)
				chilcContainer = createNode(xml, container,index)
			 
				
				for (var i = 0; i < xmllength; i++ ) {
					var $xml = xml.child(i)
				    getchild($xml,chilcContainer,i)
				}
			}
		}
		private function createChild(xml,container,index) {
			
			var treecell:treeCell = new treeCell(index)
			var treecell_displayPanel_cls:Class = getDefinitionByName(_treeCellStyle) as Class
			var treecell_displayPanel = new treecell_displayPanel_cls()
			treecell.addChild(treecell_displayPanel)
			treecell.y=treecell.height*index
			container.addChild(treecell)
			//trace("treecell.height:"+treecell.height+"  createChild container:"+container+" xml:"+xml+"  \nindex:"+index+" /treecell.y:"+treecell.y)
		}
		private function createNode(xml,container,index):treecellBox {
			var treenodexbox:treeNodeBox = new treeNodeBox(this,xml,index, treeNodeStyle)
			treenodexbox.name="Node_"+xml.@title+"_"+index
			treenodexbox.y =  Math.round(treenodexbox.treeNodeDisplayPanel.height * index)
			container.addChild(treenodexbox)
			var treecellbox = treenodexbox.treecellbox
			if (_isInit == false) {
				 
				_isInit = true
				_toplevelNodeBox=treenodexbox
				if (_showTOPLevel==true) {
					showToplevel()
				}else {
					hideToplevel()
				}
				
			}else {
				 
			}
			return treecellbox
		}
		private function updateData() {
			_length=_source.Length
		}
		public function hideToplevel() {
			 
			_showTOPLevel=false
			_toplevelNodeBox.thetreeNode.visible = false
			_toplevelNodeBox.treecellbox.y = 0
			if (_toplevelNodeBox.childDisplay==false) {
				_toplevelNodeBox.openchild()
			}
		}
		public function showToplevel() {
			_showTOPLevel=true
		 
			_toplevelNodeBox.thetreeNode.visible = true
			_toplevelNodeBox.treecellbox.y = Math.round(_toplevelNodeBox.thetreeNode.height)	
			
		}
		public function  toggleTOPLevel() {
			if (_showTOPLevel==true) {
				hideToplevel()
			}else {
				showToplevel() 
			}
		}
		private function xmlloaded(e:Event) {
			//trace("xmlloaded")
			updateData()
			updateTree()
		}
		
	}
	
}