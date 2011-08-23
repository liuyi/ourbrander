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
	import fl.transitions.Blinds;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
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
		public static const DISABLE = "disable"
		public static const CELL_RENDER = "cell_render"
		public static const LISTBG_RENDER="listbg_render"
		//data
		protected var _data:xmlFrame = new xmlFrame()
		protected var _label:String=""
		protected var _selectedObj:MovieClip = null
		protected var _showHight:Number =0
		protected var  _width:Number = 0
		protected var _disableString:String = ""//when this combobox have no data,this text will show in  _title
		protected var _spacingY:Number = 0
		protected var _bgWidthOffset:Number = 0
		protected var _listXOffset:Number=0
		protected var _listYOffset:Number = 0
		
		protected var _defineItem:int=-1
	
		//class
		protected var _scrollbarStyle:Class
		protected var _cellStyle:Class
		protected var _btnStyle:Class
		protected var _listbgStyle:Class
		
		//displayObj
		private var _skin:MovieClip=null
		private var _btn:*=null
		protected var _title:MovieClip=null
		protected var _list:MovieClip = null
		protected var _scrollbar:ctScrollbar
		protected var _listBox:MovieClip = null
		protected var _mask:MovieClip = null
		protected var _listbg:MovieClip = null
		
	
		//sate
		protected var _isshow:Boolean = false
		protected var _selectEnabled = true
		protected var _isoutside:Boolean = true
		protected var _isInited:Boolean=false
		//textFormat
		protected var _rollOverTextFormat:TextFormat = new TextFormat()
		protected var _rollOutTextFormat:TextFormat = new TextFormat()
		protected var _disableTextFormat:TextFormat = new TextFormat()
		protected var _titleRolloverTextFormat:TextFormat = new TextFormat()
		protected var _titleRolloutTextFormat:TextFormat = new TextFormat()
		protected var _embedFonts:Boolean = false
		
		 
		
		//other
		//private var _fm:FocusManager;


		
		 
		public function easycomBobox() 
		{
			init()
		}
		protected function init() {
			//_fm = new FocusManager(this)
			
            
			addEventListener(easycomBobox.DATA_CHANGE, updateCombobox)
			 
		}
		protected function showList(event = null) {
			// updateList()
			    _isoutside=false
				removeEventListener(MouseEvent.ROLL_OUT, checkOutside);
				addEventListener(MouseEvent.ROLL_OUT, checkOutside);
				removeEventListener(MouseEvent.ROLL_OVER, checkOutside);
				addEventListener(MouseEvent.ROLL_OVER, checkOutside);
			 
				stage.removeEventListener(MouseEvent.CLICK, checkMouseOutClick);
				stage.addEventListener(MouseEvent.CLICK, checkMouseOutClick);
		 
			 
			var globalPoint:Point = new Point(this.x, this.y)
			 
			
		
		  
			if (_mask.height + _title.height + this.localToGlobal(globalPoint).y > stage.stageHeight) {
				 
				_listBox.y = -_listbg.height + 1+_listYOffset
				 
			}else {
			 
				_listBox.y = _title.height - 1+_listYOffset
				 
			}
			 
			_listBox.visible = true
			 
		    
			isshow = true
			 
		}
		
		public function set showHight(val:Number ) {
			_showHight=val
		}
		public function get showHight() :Number{
			return _showHight
		}
		
		public function set spacingY(val:Number) {
			_spacingY=val
		}
		public function set bgWidthOffset(val:Number) {
			_bgWidthOffset=val
		}
		public function get bgWidthOffset():Number {
			var k=_bgWidthOffset
			return k
		}
		public function get spacingY() :Number {
			var k=_spacingY
			return k
		}
		public function set listXOffset(val:Number) {
			_listXOffset=val
		}
		public function get listXOffset() :Number{
			var k = _listXOffset
			return k
		}
		public function set listYOffset(val:Number) {
			_listYOffset=val
		}
		public function get listYOffset() :Number{
			var k = _listYOffset
			return k
		}
		//set textFormat Style
		public function set rollOverTextFormat(val:TextFormat) {
			_rollOverTextFormat=val
		}
		public function set rollOutTextFormat(val:TextFormat) {
			_rollOutTextFormat=val
		}
		public function set disableTextFormat(val:TextFormat) {
			_disableTextFormat=val
		}
		public function get rollOverTextFormat() :TextFormat {
			return _rollOverTextFormat
		}
		
		public function get rollOutTextFormat() :TextFormat {
			return _rollOutTextFormat
		}
		public function get disableTextFormat() :TextFormat {
			return _disableTextFormat
		}
		public function set titleRolloverTextFormat(val:TextFormat)  {
			_titleRolloverTextFormat=val
		}
		public function get titleRolloverTextFormat() :TextFormat {
			return _titleRolloverTextFormat
		}
		
		public function set titleRolloutTextFormat(val:TextFormat)  {
			_titleRolloutTextFormat=val
		}
		public function get titleRolloutTextFormat() :TextFormat {
			return _titleRolloutTextFormat
		}
		public function set embedFonts(val:Boolean) {
			_embedFonts=val
		}
		
		public function get embedFonts():Boolean {
			var k = _embedFonts
			return k
		}
		//set and get fonts style end
		public function set selectEnabled(val:Boolean) {
			_selectEnabled = val
			_title._txt.text = _disableString
			_title._txt.setTextFormat(disableTextFormat)
		}
		public function get selectEnabled():Boolean {
			return _selectEnabled 
		}
		public function set disableString(val:String) {
			_disableString = val
			if (_data.Length < 1&&_title!=null) {
				_title._txt.text = _disableString
				_title._txt.setTextFormat(disableTextFormat)
			}
		}
		public function get disableString():String {
			return _disableString
		}
		
		protected function hiddenList() {
			
			_listBox.visible = false
			isshow = false
			//if(_activecheck!=false){
			removeEventListener(MouseEvent.ROLL_OUT, checkOutside);
			//}else {
			this.addEventListener(Event.ADDED_TO_STAGE,addListener)
				
				
			//}
			 
		}
		
		
		protected function addListener(e:Event) {
			stage.removeEventListener(MouseEvent.CLICK, checkMouseOutClick);
		}
		protected function updateMask() {
		 
			if (_mask == null) {
				   
				_mask = new MovieClip()
				 
				 
				_mask.graphics.beginFill(0xffffff,0.5)
				_mask.graphics.drawRect(0, 0, _title.width, _showHight)
				_listBox.addChild(_mask)
				
			}
			_mask.height = showHight
			_mask.width = _title.width
			
			_list.mask = _mask
			
			
			updateScrollbar()
		}
		protected function updateListbg() {
			if (_listbg == null) {
				_listbg = new _listbgStyle()
				 _listBox.addChild(_listbg)
				 
			}
			_listbg.height = showHight
			_listbg.width = _title.width+bgWidthOffset
			if (_listBox.getChildIndex(_listbg)>_listBox.getChildIndex(_list)) {
				_listBox.swapChildren( _listbg,_list)
			}
			if (_listBox.getChildIndex(_scrollbar)<_listBox.getChildIndex(_list)) {
				_listBox.swapChildren(_scrollbar,_list)
			}
			
			var event = new superEvent(easycomBobox.LISTBG_RENDER, { listbg:_listbg }, true)
			 dispatchEvent(event)
		}
		protected function updateScrollbar() {
			if (_scrollbar==null) {
			_scrollbar = new ctScrollbar(_list)
			_scrollbar.showArrowBtn = false
			_scrollbar.lockBarHeight=true
			var scrollbar_skin=new _scrollbarStyle()
			_scrollbar.setInterface(scrollbar_skin)
			_listBox.addChild(_scrollbar)
			}
			_scrollbar.x = _list.width - _scrollbar.width
			_scrollbar.y = 0
			_scrollbar._height = _mask.height
			//trace(_scrollbar.parent==_listBox)
			if (_listBox.getChildIndex(_scrollbar)<_listBox.getChildIndex(_list)) {
				_listBox.swapChildren(_scrollbar,_list)
			}
		}
		protected function removeAll() {
			for ( var i = 0; i <= this.numChildren; i++ ) {
			  try{
				this.removeChildAt(0)
			  }catch (error) {
			  }
			}
			 _btn=null
			 _title=null
			 _list = null
			 _scrollbar=null
			_listBox = null
			_mask= null
			 _listbg = null
			 _selectedObj=null
		}
		protected function updateCombobox(event = null) {
		 
	  	 removeAll()
		  
		 _title = new _cellStyle ()
		 
		 _title.x = 0
		 _title.y = 0
		 _title.buttonMode=true
		 addChild(_title)
	
		 _btn = new _btnStyle()
		 _btn.buttonMode=true
		 _btn.x = _title.x + _title.width - _btn.width
		 _btn.y = _title.y
		 addChild(_btn)
		 
		 _btn.addEventListener(MouseEvent.CLICK, TitlebeClicked)
		 _btn.addEventListener(MouseEvent.ROLL_OVER, onRollover )
		 _btn.addEventListener(MouseEvent.ROLL_OUT,onRollout)
		 _title.addEventListener(MouseEvent.CLICK, TitlebeClicked)
		  _title.addEventListener(MouseEvent.ROLL_OVER, onRollover )
		 _title.addEventListener(MouseEvent.ROLL_OUT, onRollout )
		 _title.rollOver_mc.visible = false
		 _title._txt.setTextFormat(disableTextFormat)
		 if (showHight == 0) {
			 showHight=(_title.height+spacingY)*5
		 }
		 updateList()
		}
		protected function onRollover(e = null) {
			 if (_data.Length < 1||selectEnabled==false) { return false } 
			 
			_title.rollOver_mc.visible = true
			_btn.gotoAndStop(2)
		 
			 _title._txt.setTextFormat(titleRolloverTextFormat) 
		}
		protected function onRollout(e = null) {
			 if (_data.Length < 1||selectEnabled==false) { return false } 
			 _btn.gotoAndStop(1)
			_title.rollOver_mc.visible = false
			_title._txt.setTextFormat(titleRolloutTextFormat)
		}
		protected function updateList() {
			
			 if (length <= 0 ) {
			       _title._txt.embedFonts=embedFonts
				   _title._txt.text=disableString
				   _title._txt.setTextFormat(disableTextFormat)
				 
				   
				 if(_list!=null){
			       removeChild(_listBox)
				  }
			     return false
			}else {
				  selectEnabled=true
				
				 _listBox = new MovieClip()
				 _listBox.x = 0
				  //_listBox.y = _title.height-1
				 
				 _list = new MovieClip()
				 _list.x = 0
				 _list.y=0
				 hiddenList()
				
				 _listBox.addChild(_list)
				 addChild(_listBox)
				 if (getChildIndex(_listBox)>getChildIndex(_title)) {
					swapChildren( _listBox,_title)
				 }
				if (getChildIndex(_btn)<getChildIndex(_title)) {
					swapChildren( _title,_btn)
				 }
				//  trace(typeof(_data.xml))
				 // trace("xxxx " , (_data.xml.title))
				 for (var i = 0; i < length; i++) {
					var  cell = new _cellStyle()
					cell.name="cell"+i
					cell.x = 0
					cell.y =( cell.height+spacingY) * (i)//define the spacing
					cell.index = i
					cell.border.visible = false
					cell.bg_mc.alpha = 0
					cell.rollOver_mc.visible = false
					var data = new Object()
				    
					var attList:XMLList=_data.xml.child(i).@* ;
					for (var t:int = 0; t < attList.length(); t++) {
						//trace(attList[t].name()+"/"+attList[t])
						 data[attList[t].name().toString()] = attList[t]
					}
 
					for (var k = 0; k < _data.xml.child(i).child("*").length(); k++ ) {
						
						var label = _data.xml.child(i).child(k).name()
						var value = _data.xml.child(i).child(k)
						data[label] = value
						//trace(":title k="+k+"///"+ data[label])
						 
					}
					k=0
					//trace("_______________________________________________________")
					cell.data = data
						 
					with (cell) {
						//trace(_label)
						var cell_label:String=_label
						 	_txt.embedFonts=embedFonts
						 _txt.text = _data.xml.child(index)[cell_label]
						 
					
						 _txt.setTextFormat(rollOutTextFormat)
					}
					cell.addEventListener(MouseEvent.CLICK, cellClicked)
					cell.addEventListener(MouseEvent.ROLL_OVER, cellRollOver)
					cell.addEventListener(MouseEvent.ROLL_OUT,cellRollOut)
					_list.addChild(cell)
					 
				 }//end for
			 }//end if
			 
			 var event = new superEvent(easycomBobox.CELL_RENDER, { list:_list }, true)
			 dispatchEvent(event)
			 
			updataTitle()
			//check the list's height 
			updateMask()
			updateListbg()
		}
		
		protected function cellRollOver(e) {
			var target=e.currentTarget
			target.rollOver_mc.visible = true
			 var _txt:TextField = target._txt
			 _txt.setTextFormat(rollOverTextFormat)
		}
		protected function cellRollOut(e) {
			var target=e.currentTarget
			target.rollOver_mc.visible = false
			var _txt:TextField = target._txt
			_txt.setTextFormat(rollOutTextFormat)
		}
		public function get length() {
			 
			return _data.xml.child("*").length()
		}
		protected function clearSkinHelpSprite() {
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
			if (_skin != null) {
				try{
			    removeChild(_skin)
				}catch (e) {
					
				}
			}
			 
			_skin = $target
			clearSkinHelpSprite()
			initSkinStyle()
			updateCombobox()
		}
		protected function initSkinStyle() {
		 _btnStyle=_skin.btnStyle as Class
		 _cellStyle = _skin.cellClass as Class
		 _listbgStyle=_skin.listbgStyle as Class
		 _scrollbarStyle = _skin.scrollbarClass as Class
		 
		}
		
		protected function checkOutside(event):void {
		   if (event.type=="rollOver") {
			   
			 _isoutside = false
		   }
		   if (event.type=="rollOut") {
			   
			 _isoutside = true
		   }
           
        }
        protected function checkMouseOutClick(event:MouseEvent) {
		 
			if ( _isoutside==true) {
				hiddenList()
			}
		}
		protected function set isshow(boolean:Boolean) {
			_isshow=boolean
		}
		protected function get isshow(): Boolean{
			return _isshow
		}
		
		protected function TitlebeClicked(event = null) {
		  
			if (_data.Length<1 || selectEnabled==false) {
				return false
			}
			
			if (!isshow) {
				 
			    showList()
				 
			}else {
			 
				
			    hiddenList()
				 
			}
			
		 
		}//end function
		
		protected function cellClicked(event:MouseEvent = null) {
			updataSelectObj(event)
			hiddenList()
			updataTitle()
			
			
		}
		public function selected(num:uint) {
			 
			_selectedObj = _list.getChildAt(num) as MovieClip
		 
			hiddenList()
			updataTitle()
		}
		protected function updataSelectObj(event=null) {
			_selectedObj = event.currentTarget as MovieClip
			
			 
			dispatchEvent(new superEvent(easycomBobox.SELECTED_CHANGE,SelectedObj,true))
		}
		public function get SelectedObj():MovieClip {
			return _selectedObj
		}
		public function set SelectedObj(val:MovieClip) {
			_selectedObj=val
		}
		protected function updataTitle(event = null) {
			if (selectEnabled==false) {
				_title._txt.text = _disableString
				_title._txt.setTextFormat(disableTextFormat)
				return 
			}
			
			if (_isInited == false && _defineItem != -1) {
				_isInited = true
			 
				_selectedObj=_list.getChildAt(_defineItem) as MovieClip
			}
			if (_selectedObj == null) {
			 
				if (_data.Length>1) {
					var cell0 = _list.getChildByName("cell0") as _cellStyle;
					  _title._txt.embedFonts=embedFonts
					_title._txt.htmlText = cell0._txt.text
					_title._txt.setTextFormat(titleRolloutTextFormat)
					SelectedObj=cell0
				}else {
					_title._txt.text = _disableString
					_title._txt.setTextFormat(disableTextFormat)
				}
				
			}else {
				 
				_title._txt.text = _selectedObj._txt.text
				_title._txt.setTextFormat(titleRolloutTextFormat)
			}
		}
		
		public function set defineItem ($index:int) {
			_defineItem=$index
		}
		
		public function get defineItem():int {
			var k = _defineItem
			return k
		}
		
		 
		
	}
	
}