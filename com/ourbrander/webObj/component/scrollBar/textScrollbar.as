package com.ourbrander.webObj.component.scrollBar{
	/*
	奥博瑞德文本滚动条1.1(AS3)
	    URL:http://www.ourbrander.com/#swfNum=3&cid=21&infoid=243&page=1
	QQ:14238910  Q群：技术不是唯一:1934054
	使用方法：
	构造函数：textScrollbar(target:TextField)
	设置皮肤：setInterface(target:MovieClip) target包括upBtn（按钮）、downBtn（按钮）、bg（电影剪辑）、dragMc（电影剪辑）。
	
	设置离目标文本框的右边距离 public function set dx(value:Number)
	设置离目标文本框的顶部距离 public function set dy(value:Number)
	
	设置滚动条滑动按钮高度是否锁定 public function set _lockBarHeight(value:Boolean)
	
	设置滚动条的高度 public function set _height(value:Number)
	获取滚动条的高度 public function get _height()
	
	事件:
	public static scrollBar.LOCKED   改变滑动条状态为锁定高度时发出
	public static scrollBar.UNLOCK  改变滑动条状态为不锁定高度时发出
	public static scrollBar.SETINTERFACE  改变了滚动条样式时发出
	public static scrollBar.BGCLICKED 滚动条背景被点击时发出
	public static scrollBar.BARSCROLLING 滚动条滑动按钮开始被拖拽时发出（鼠标滚动滑动文本框不发送此事件）
	public static scrollBar.BARSCROLLSTOPED 滚动条滑动按钮停止拖拽时发出（鼠标滚动滑动文本框不发送此事件）
	
	注意：要对文本框的状态进行监控，只需要侦听目标文本框发出的事件即可，这里就不多余添加了。
	*/
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.events.Event;
	    import flash.events.TextEvent
	import flash.ui.Mouse;
	import flash.events.EventDispatcher;
	public class textScrollbar extends MovieClip {
		//视图设定
		private var _Skin:MovieClip;
		private var _targetTextField:TextField;
		private var _upBtn:MovieClip;
		private var _downBtn:MovieClip;
		private var _bg:MovieClip;
		private var _dragMc:MovieClip;

		//变量设定
		private var _dx:Number;//滚动条相对文本框的X坐标距离
		private var _dy:Number;//滚动条相对文本框的X坐标距离
		private var HEIGHT:*//滚动条的高度
		private var _lockBarHeight:Boolean;
		//滚动条滑动按钮高度锁定状态，默认为false
		public static const SETINTERFACE="setInterface"
        public static const LOCKED="locked";
		public static const UNLOCK="unlock";
		public static const BGCLICKED="bgclicked"
		public static const BARSCROLLING="barscrolling"
		public static const BARSCROLLSTOPED="barscrollstop"
		

		public function textScrollbar(target:TextField) {//构造函数
			_targetTextField=target;
			
			DataInit();
		}
		public function setInterface(target:MovieClip) {//更换滚动条的皮肤
			if (_Skin==null) {

			} else {
				this.removeChild(_Skin);
				dispatchEvent(new Event(SETINTERFACE));
			}
			_Skin=target;
			_upBtn=_Skin.getChildByName("upBtn") as MovieClip;
			_downBtn=_Skin.getChildByName("downBtn") as MovieClip;
			_bg=_Skin.getChildByName("bg") as MovieClip
			_dragMc=_Skin..getChildByName("dragMc") as MovieClip
			initSkin();
			
			_downBtn.addEventListener(MouseEvent.MOUSE_DOWN,function(){_downBtn.addEventListener(Event.ENTER_FRAME,rollDown);});
			_downBtn.addEventListener(MouseEvent.MOUSE_UP,function (){_downBtn.removeEventListener(Event.ENTER_FRAME,rollDown)});
			
			_upBtn.addEventListener(MouseEvent.MOUSE_DOWN,function(){_upBtn.addEventListener(Event.ENTER_FRAME,rollUp);});
			_upBtn.addEventListener(MouseEvent.MOUSE_UP,function (){_upBtn.removeEventListener(Event.ENTER_FRAME,rollUp)});
			
			_dragMc.buttonMode=true;
			_dragMc.addEventListener(MouseEvent.MOUSE_DOWN,dragScroll);
			_dragMc.addEventListener(MouseEvent.MOUSE_UP,stopdragScroll);
			_targetTextField.addEventListener(Event.SCROLL,rolling);
			
            _targetTextField.addEventListener(Event.CHANGE,rolling);
			_bg.addEventListener(MouseEvent.CLICK,bgclick);
			
			
			setdragMc();
			addChild(_Skin);

		}
		
		private function DataInit() {
			_dx=0;
			_dy=0;
			
			_lockBarHeight=false;
		}
		private function initSkin() {
			 
			_upBtn.x=0;
			_upBtn.y = 0;
				
			if (_upBtn.getRect(this).y<0) {
				_upBtn.y=- _upBtn.getRect(_Skin).y;
			}
		    _dragMc.x=0
			var tmp_h=(HEIGHT!=undefined)?HEIGHT:_targetTextField.height;
			var h=tmp_h-_upBtn.height-_downBtn.height;
			_bg.x=0;
			_bg.height=h;
			_bg.y=_upBtn.height+0;
			_downBtn.x=0;
			_downBtn.y=_bg.y+_bg.height;
			this.dx=0;
			this.dy=0
			
		}
		public function set dx(value:Number) {//设置滚动条的X坐标偏移量
			_dx=value;
			this.x=_targetTextField.x+_targetTextField.width+_dx;
		}
		public function set dy(value:Number) {//设置滚动条的Y坐标偏移量
			_dy=value;
			this.y=_targetTextField.y+_dy;
		}

		public function set _height(_value:Number) {//设置滚动条的高度
			HEIGHT=_value;
			_bg.height=HEIGHT-_upBtn.height-_downBtn.height;
			_downBtn.y=_bg.y+_bg.height;
			 setdragMc()
		}
		public function get _height() {
			var tmpheight=HEIGHT;
			return tmpheight;
		}

		public function set lockBarHeight(_value:Boolean) {//滚动条滑动按钮高度锁定状态
			_lockBarHeight=_value;
			if (_lockBarHeight==true) {
				dispatchEvent(new Event(LOCKED));
			} else {
				dispatchEvent(new Event(UNLOCK));
			}

		}
		public function get lockBarHeight() {
			var tmp_lockBarHeight=_lockBarHeight;
			return tmp_lockBarHeight;
		}

		private function rollUp(e) {
			
			if (_targetTextField.scrollV==1) {
				_dragMc.y=(_bg.y);
			} else {
				_targetTextField.scrollV--;
			}

		}
		private function rollDown(e) {
			
			if (_targetTextField.scrollV==_targetTextField.maxScrollV) {
				_dragMc.y=(_bg.y+_bg.height-_dragMc.height);
			} else {

				_targetTextField.scrollV++;
			}
		}
		private function dragScroll(e) {
			var rec:Rectangle=new Rectangle(_bg.x,_bg.y,0,_bg.height-e.target.height);
			e.target.startDrag(false,rec);
			this.addEventListener(Event.ENTER_FRAME,scrollText);
			stage.addEventListener(MouseEvent.MOUSE_UP,stopdragScroll);
			dispatchEvent(new Event(BARSCROLLING));
			
			
		}
		private function stopdragScroll(e=null) {
			_dragMc.stopDrag();
			this.removeEventListener(Event.ENTER_FRAME,scrollText);
			stage.removeEventListener(MouseEvent.MOUSE_UP,stopdragScroll);
			_targetTextField.addEventListener(Event.SCROLL,rolling);
            dispatchEvent(new Event(BARSCROLLSTOPED));
		}
		private function rolling(e=null) {
			setdragMc();
		}
		private function scrollText(e=null) {

			_targetTextField.removeEventListener(Event.SCROLL,rolling);
			_targetTextField.scrollV=Math.ceil(((_dragMc.y-_bg.y)/(_bg.height-_dragMc.height))*(_targetTextField.maxScrollV))
			
			
		}
		private function setdragMc() {
			
			
			_bg.addEventListener(MouseEvent.CLICK,bgclick);
			var tmplines=_targetTextField.numLines-_targetTextField.maxScrollV+1;
			var p=(tmplines)/_targetTextField.numLines;
			var tmpHeight=Math.round((p)*_bg.height);

			if (_targetTextField.maxScrollV > 1) {//如果文本框的内容多于可显示行数
				this.visible=true
				_dragMc.visible=true;
				_upBtn.enabled=true;
				_downBtn.enabled=true;
               _bg.visible=true
				if (_lockBarHeight==false) {//如果滚动条的按钮高度没有被锁定
					_dragMc.y=_bg.y+((_targetTextField.scrollV-1)/(_targetTextField.maxScrollV-1))*(_bg.height-tmpHeight);
					if (tmpHeight<=5) {
						_dragMc.height=5;
					} else {
						_dragMc.height=tmpHeight;
						
					}
				} else {//如果滚动条的按钮高度被锁定
				    if(_dragMc.height>_bg.height){
						
						_dragMc.height=(tmpHeight>5)?tmpHeight:5
					}
					_dragMc.y=_bg.y+((_targetTextField.scrollV-1)/(_targetTextField.maxScrollV-1))*(_bg.height-_dragMc.height);
				}//end if
			} else {
				this.visible=false
				/*_dragMc.visible=false;
				_upBtn.enabled=false;
				_downBtn.enabled=false;
				_bg.removeEventListener(MouseEvent.CLICK, bgclick);
				_bg.visible=false*/

			}//end if

		}//end runction

		private function bgclick(e) {//滚动条背景点击文本框快速定位
		
			if (this.mouseY<=_dragMc.y) {
				_dragMc.y=this.mouseY;
				 
			} else {
				_dragMc.y=(this.mouseY-_dragMc.y-_dragMc.height)+_dragMc.y;
			}
			scrollText();
			stopdragScroll();
            dispatchEvent(new Event(BGCLICKED));

		}
	}
}