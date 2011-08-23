package com.ourbrander.webObj.component.easyTree 
{
	import bin.demo.treeDemo;
	import com.ourbrander.Event.superEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getDefinitionByName
	import gs.*
	/**
	 * ...
	 * @author liuyi,you can find more help from my blog:www.ourbrander.com liuyi
	 */
	dynamic  public class treeNodeBox extends MovieClip
	{
		private var _index:int = 0
		private var _treeNode:treeNode
		private var _treeCellBox:treecellBox
		private var _treeNodeStyle:String
		private var _treeNodeDisplayPanel:MovieClip
		private var _canvas:MovieClip=new MovieClip()
		
		private var _childDisplay:Boolean = false
		private var _speed = 0.1
		
		private var _xml
		private var _ty:Number = 0
		private var _mainTree:tree
		
		
		//private var _mainContainer:tree
		public function treeNodeBox(mainTree,xml,$index=null,treeNodeStyle=null) 
		{   
			init(mainTree,xml,$index,treeNodeStyle)
		}
		private function init(mainTree,xml,$index, treeNodeStyle) {
			addEventListener(Event.ADDED_TO_STAGE, addEvent)
			_xml=xml
			_index = $index
			_mainTree=mainTree
			_treeNodeStyle=treeNodeStyle
			_treeNode = new treeNode(_index)
			_treeCellBox = new treecellBox()
			
			createCanva()
			updatePanel()
			_treeCellBox.visible = false
		}
		private function addEvent(e:Event) {
			//_treeNode.addEventListener(treeEvent.TREEEVENT_NODE_CLICKED, nodeClickedHandler)
			addEventListener(treeEvent.TREEEVENT_NODE_CLICKED, adjustPositionHandler)
			//addEventListener(treeEvent.TREEEVENT_NODE_DISPLAY_CHANGED,adjustPositionHandler)
		}
		
		private function removeEvent() {
			removeEventListener(Event.ADDED_TO_STAGE, addEvent)
			_treeNode.removeEventListener(treeEvent.TREEEVENT_NODE_CLICKED, nodeClickedHandler)
			this.stage.removeEventListener(treeEvent.TREEEVENT_NODE_CLICKED,adjustPosition)
		}
		private function updatePanel() {
			_treeNode = new treeNode()
			 
		 	var treenode_style_cls:Class = getDefinitionByName(_treeNodeStyle) as Class
			
		    _treeNodeDisplayPanel = new treenode_style_cls()
			_treeNodeDisplayPanel.init(_xml)
		    _treeCellBox = new treecellBox()
			_treeCellBox.y = Math.round( _treeNodeDisplayPanel.height)
			
			_treeNode.addChild(_treeNodeDisplayPanel)
			//addChild(_treeCellBox)
			addChild(_treeNode)
			_canvas.width = _treeNodeDisplayPanel.width
			_canvas.height=_treeNodeDisplayPanel.height
			_canvas.oh=_treeNodeDisplayPanel.height
		    
		}
		public function set treeNodeStyle(str:String) {
			_treeNodeStyle = str
			renderSkin()
		}
		public function get treeNodeStyle():String {
		     return _treeNodeStyle
		}
		
		private function renderSkin() {
			//trace("renderSkin")
		}
		
		public function get thetreeNode():treeNode {
			return _treeNode
		}
		
		public function get treecellbox():treecellBox {
			return _treeCellBox
		}
		public function get treeNodeDisplayPanel() { 
			return _treeNodeDisplayPanel
		}
		
		public function set ty(val:Number) {
			_ty=val
		}
		public function get ty() {
			return _ty
		}
		private function createCanva() {
			
			
			_canvas.graphics.beginFill(0x000000, 0.0)
			_canvas.graphics.drawRect(0, 0, 100, 100)
			_canvas.graphics.endFill()
			addChild(_canvas)
			
		}
		private function showChild() {
			
			if (_childDisplay==false) {
				_childDisplay = true
				addChild(_treeCellBox)
				_treeCellBox.visible = true
				//_canvas.height=_treeNodeDisplayPanel.height+_treeCellBox.height
			}
		}
		private function hideChild() {
				
			if (_childDisplay==true) {
				_childDisplay = false
				_treeCellBox.visible = false
				//_canvas.height=_treeNodeDisplayPanel.height
				removeChild(_treeCellBox)
			}
		}
		public function get childDisplay() {
			var b = _childDisplay
			
			return b
		}
		private function toggleChildDisplay() {
			 
			if (_childDisplay==false) {
				showChild()
			}else {
				hideChild()
			}
		}
		
		private function nodeClickedHandler(e:Event) {
			toggleChildDisplay()
			var event = new superEvent(treeEvent.TREEEVENT_NODE_DISPLAY_CHANGED, e["content"], true)
            dispatchEvent(event)
		}
		
		public function openchild() {
			var _parentcellBox:treecellBox=this.parent as treecellBox
			var event = new superEvent(treeEvent.TREEEVENT_NODE_CLICKED,{currentTarget:this.thetreeNode,targetNodeBox:this,parentCellBox:_parentcellBox},true)
			dispatchEvent(event)
		}
		
		private function adjustPositionHandler(e:Event) {
			
			var targetNodeBox:treeNodeBox = e["content"].targetNodeBox as treeNodeBox
			var parentCellBox:treecellBox=e["content"].parentCellBox as treecellBox
			
			if (targetNodeBox == this) {
				toggleChildDisplay()
			}
			if (targetNodeBox!=this) {
				//trace(targetNodeBox + "/" + this.name)
				adjustPosition(targetNodeBox,parentCellBox)
			}
			
		
		}
		private function get canvas() {
			return _canvas
		}
		private function adjustPosition($targetNodeBox:treeNodeBox,$parentCellBox:treecellBox) {
			 
				 
				for (var i = 0; i < this.numChildren; i++ ) {
				   
					 if ((this.getChildAt(i) is treecellBox)==true) {
						 var _cellbox:treecellBox = this.getChildAt(i) as treecellBox
					 
						 for (var k = 0; k < _cellbox.numChildren; k++ ) {
							if((_cellbox.getChildAt(k) is treeNodeBox)==true){
								var $treeNodeBox:treeNodeBox = _cellbox.getChildAt(k) as treeNodeBox
								 if (_mainTree.multiDisplay == true) {
									 
								 }else {
									 if($treeNodeBox!=$targetNodeBox && $parentCellBox!=$treeNodeBox.treecellbox){
										 $treeNodeBox.hideChild()
									 }
								 }
							
							 if (k == 0) {
								 
								TweenLite.to($treeNodeBox, _speed, { y:0 } )
								 
							 
							}else {
								if((_cellbox.getChildAt(k-1) is treeNodeBox)==true){
									var pre_treeNode:treeNodeBox = _cellbox.getChildAt(k-1) as treeNodeBox
									 
									var h=0
									if (pre_treeNode.childDisplay == true) {
										h=pre_treeNode.treeNodeDisplayPanel.height+pre_treeNode.treecellbox.height
									}else {
										h=pre_treeNode.treeNodeDisplayPanel.height
									}
									$treeNodeBox.ty = Math.round(pre_treeNode.ty + h)
								 
									TweenLite.to($treeNodeBox, _speed, { y:$treeNodeBox.ty } )
								}else {
									//trace("none child already")
								}
							}  //end if
						 }//end for
					 }//end if
				}//end for
			 }
		}//end function
	}//end class
}//end package