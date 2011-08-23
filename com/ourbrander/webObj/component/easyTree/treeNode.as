package com.ourbrander.webObj.component.easyTree 
{
	import com.ourbrander.Event.superEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author liuyi,you can find more help from my blog:www.ourbrander.com liuyi
	 */
	public class treeNode extends MovieClip
	{
		private var _index:int = 0
		private var treenodeBox:treeNodeBox
		public function treeNode($index=null) 
		{   
			
			_index = $index
			addEventListener(Event.ADDED_TO_STAGE,addEvent)
			 
		}
		private function addEvent(e:Event) {
			treenodeBox=this.parent as treeNodeBox
			addEventListener(MouseEvent.MOUSE_DOWN, clicked)
			addEventListener(MouseEvent.MOUSE_UP,msup)
		}
		
		private function clicked(e:Event) {
		//	treenodeBox.startDrag()
			var _parent:treeNodeBox = this.parent as treeNodeBox
			var _parentcellBox:treecellBox=this.parent.parent as treecellBox
			 
			var event = new superEvent(treeEvent.TREEEVENT_NODE_CLICKED,{currentTarget:this,targetNodeBox:_parent,parentCellBox:_parentcellBox},true)
			dispatchEvent(event)
		}
		
		private function msup(e:Event) {
			//treenodeBox.stopDrag()
		}
	}
	
}