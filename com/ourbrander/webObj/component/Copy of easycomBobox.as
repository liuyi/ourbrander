package com.ourbrander.webObj.component 
{

 
	 
	
	/**
	 * ...
	 * @author liuyi url:www.ourbrander.com email:contact@ourbrander.com
	...
	 */
	import com.ourbrander.xmlObject.xmlFrame
	import com.ourbrander.xmlObject.xmlObj
	import com.ourbrander.webObj.component.scrollBar.ctScrollbar
	import flash.display.MovieClip;
	import flash.events.Event
	import flash.events.MouseEvent;
	import flash.geom.Point;
	//import flash.events.FocusEvent;
	//import fl.managers.FocusManager;
	import com.ourbrander.Event.superEvent
	import flash.utils.flash_proxy;
	import flash.text.TextField;
	
	//version 0.5
	public class easycomBobox extends MovieClip
	{   
		
		//evnet
		public static const SELECTED_CHANGE = "Selectedchange"
		public static const DATA_CHANGE = "dataChange"
		
		//data
		private var _data:xmlFrame = new xmlFrame()
		private var _label:String=""
		private var _selectedObj:MovieClip=null
		//class
		private var _scrollbarStyle:Class
		private var _cellStyle:Class
		private var _btnStyle:Class
		
		//displayObj
		private var _skin:MovieClip=null
		private var _btn:*=null
		private var _title:MovieClip=null
		private var _list:MovieClip = null
		
		//sate
		private var _isshow:Boolean=false
		
		//other
		//private var _fm:FocusManager;


		
		 
		public function easycomBobox() 
		{
			init()
		}
		private function init() {
			//_fm = new FocusManager(this)
			
            
			addEventListener(easycomBobox.DATA_CHANGE, updateCombobox)
			 
		}
		private function showList(event = null) {
			
			removeEventListener(Event.ENTER_FRAME, checkOutside);
			addEventListener(Event.ENTER_FRAME, checkOutside);
			var globalPoint:Point = new Point(this.x, this.y)
			 
			//trace("stage.stageHeight:" + stage.stageHeight + ">>>" + (_list.height + _title.height + this.localToGlobal(globalPoint).y))
			
			
			if (_list.height + _title.height + this.localToGlobal(globalPoint).y> stage.stageHeight) {
				_list.y=-_list.height
			}else {
				_list.y=_title.height
			}
			_list.visible = true
		 
			isshow=true
		}
		
		private function hiddenList() {
			_list.visible = false
			isshow=false
		}
		
		private function updateCombobox(event=null) {
		 _title = new _cellStyle ()
		 _title.x = 0
		 _title.y = 0
		 addChild(_title)
	
		 _btn=new _btnStyle()
		 _btn.x = _title.x + _title.width - _btn.width
		 _btn.y = _title.y
		 addChild(_btn)
		 _btn.addEventListener(MouseEvent.CLICK, TitlebeClicked)
		 _btn.addEventListener(MouseEvent.ROLL_OVER, function(e = null) { _title.onRollOver() } )
		 _btn.addEventListener(MouseEvent.ROLL_OUT,function(e=null){_title.onRollOut()})
		 _title.addEventListener(MouseEvent.CLICK, TitlebeClicked)
		  _title.addEventListener(MouseEvent.ROLL_OVER, function(e = null) { _btn.onRollOver() } )
		 _title.addEventListener(MouseEvent.ROLL_OUT,function(e=null){_btn.onRollOut()})
		 updateList()
		}
		private function updateList() {
			 
			 if (length <= 0 ) {
				 if(_list!=null){
			       removeChild(_list)
				 }
			     return false
			 }else {
				 _list = new MovieClip()
				 hiddenList()
				 _list.x = 0
				 _list.y=_title.height
				 addChild(_list)
				   
				  
				 
				 for (var i = 0; i < length; i++) {
					var  cell = new _cellStyle()
					cell.name="cell"+i
					cell.x = 0
					cell.y = cell.height * (i)
					cell.index = i
					with (cell) {
						//trace(_label)
						var cell_label:String=_label
						 //trace(_data.xml.child(index)[cell_label])
						 _txt.text = _data.xml.child(index)[cell_label]
						 
					}
					cell.addEventListener(MouseEvent.CLICK,cellClicked)
					_list.addChild(cell)
					 
				 }//end for
			 }//end if
			  
			if (_selectedObj != null) {
			    _title._txt.htmlText=_selectedObj._txt.htmlText
		    }else {
				var cell0 = _list.getChildByName("cell0") as _cellStyle;
			    _title._txt.htmlText=cell0._txt.text
		    }
		}
		public function get length() {
			//trace("_data.xml.child.length()"+_data.xml.child("*").length())
			return _data.xml.child("*").length()
		}
		private function clearSkinHelpSprite() {
			while (_skin.numChildren > 0) {
				_skin.removeChildAt(0)
				 
			}
		}
		public function setData($data:xmlFrame=null,$label="") {
			_data = $data
			_label = $label
			
			dispatchEvent(new superEvent(easycomBobox.DATA_CHANGE))
		}
		public function getData() {
		    return _data
		}
		public function removeData() {
			setData(null)
			dispatchEvent(new superEvent(easycomBobox.DATA_CHANGE))
		}
		 
		public function setInterface($target:*) {
			if (_skin!=null) {
			    removeChild(_skin)
			}
			 
			_skin = $target
			clearSkinHelpSprite()
			initSkinStyle()
			updateCombobox()
		}
		private function initSkinStyle() {
		 _btnStyle=_skin.btnStyle as Class
		 _cellStyle = _skin.cellClass as Class
		 _scrollbarStyle = _skin.scrollbarClass as Class
		 
		}
		
		private function checkOutside(event):void {
			 
           if (!this.hitTestPoint(root.mouseX, root.mouseY, true)) {
			   hiddenList()
		   }
        }
        
		private function set isshow(boolean:Boolean) {
			_isshow=boolean
		}
		private function get isshow(): Boolean{
			return _isshow
		}
		
		private function TitlebeClicked(event = null) {
			
			if (!isshow) {
				// trace(isshow)
				
			    showList()
			}else {
			 
				
			    hiddenList()
			}
			
			
		}//end function
		
		private function cellClicked(event:MouseEvent = null) {
			updataSelectObj(event)
			hiddenList()
			updataTitle()
			
			
		}
		private function updataSelectObj(event=null) {
			_selectedObj = event.currentTarget as MovieClip
			
			 
			dispatchEvent(new superEvent(easycomBobox.SELECTED_CHANGE,SelectedObj,true))
		}
		public function get SelectedObj():MovieClip {
			return _selectedObj
		}
		private function updataTitle(event=null) {
			_title._txt.text=_selectedObj._txt.text
		}
		
	}
	
}