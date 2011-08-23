package com.ourbrander.webObj.component.scrollBar{
	/*
	奥博瑞德滚动条1(AS3)
	update:2009-10-13  
	QQ:14238910  Q群：技术不是唯一:1934054 网站地址:http://www.ourbrander.com 
	使用方法：
	构造函数：textScrollbar(target:*)
	设置皮肤：setInterface(target:MovieClip) target包括upBtn（按钮）、downBtn（按钮）、bg（电影剪辑）、dragMc（电影剪辑）。
	
	 
	
	设置滚动条滑动按钮高度是否锁定 public function set _lockBarHeight(value:Boolean)
	
	设置滚动条的高度 public function set _height(value:Number)
	获取滚动条的高度 public function get _height()
	
	设置上下按钮按下时滑动按钮移动的距离 public function set barspeed()
	获取上下按钮按下时滑动按钮移动的距离 public function get barspeed()
	
	
	事件:
	public static scrollBar.LOCKED   改变滑动条状态为锁定高度时发出
	public static scrollBar.UNLOCK  改变滑动条状态为不锁定高度时发出
	public static scrollBar.SETINTERFACE  改变了滚动条样式时发出
	public static scrollBar.BGCLICKED 滚动条背景被点击时发出
	public static scrollBar.BARSCROLLING 滚动条滑动按钮开始被拖拽时发出（鼠标滚动滑动文本框不发送此事件）
	public static scrollBar.BARSCROLLSTOPED 滚动条滑动按钮停止拖拽时发出（鼠标滚动滑动文本框不发送此事件）
	public static scrollBar.SETBARSPEED 上下按钮按下时滑动按钮移动的速度改变的时候发出此事件
	注意：要对被滚动的容器状态进行监控，只需要侦听被滚动的容器发出的事件即可，这里就不多余添加了。
	
	*/
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.ui.Mouse;
	import flash.events.EventDispatcher;
	import gs.*
	public class ctScrollbar extends MovieClip {
		//视图设定
		private var _Skin:MovieClip;
		private var _targetContainer:*;
		private var _upBtn:DisplayObject;
		private var _downBtn:DisplayObject;
		private var _bg:MovieClip;
		private var _dragMc:MovieClip;
        private var _msk:*
		//变量设定
		private var _dx:Number;//滚动条相对文本框的X坐标距离
		private var _dy:Number;//滚动条相对文本框的X坐标距离
		private var HEIGHT:*//滚动条的高度
		private var _lockBarHeight:Boolean;
		private var _dheight:Number
		private var _dwidth:Number
		private var _direction:String//垂直或水平方向的滚动条
		private var _barSpeed:Number;//上下按钮按下时滑动按钮移动的距离
		private var _showArrowBtn:Boolean=true
		//滚动条滑动按钮高度锁定状态，默认为false
		public static const SETINTERFACE="setInterface"
        public static const LOCKED="locked";
		public static const UNLOCK="unlock";
		public static const BGCLICKED="bgclicked"
		public static const BARSCROLLING="barscrolling"
		public static const BARSCROLLSTOPED="barscrollstop"
		public static const SETBARSPEED = "setbarspeed"
		public static const CHANGE_ARROWBTN_VIEW="change_arrowbtn_view"

		public function ctScrollbar(target:*,tmpDirection:String=null) {//构造函数
			_targetContainer=target;
			_direction=(tmpDirection!=null)?tmpDirection:"V"
			DataInit();
			addEvent()
		}
		public function setInterface(target:MovieClip) {//更换滚动条的皮肤
			if (_Skin==null) {

			} else {
				this.removeChild(_Skin);
				dispatchEvent(new Event(SETINTERFACE));
			}
			
			_Skin=target;
			_upBtn=_Skin.upBtn;
			_downBtn=_Skin.downBtn;
			_bg=_Skin.bg;
			_dragMc=_Skin.dragMc;
			initSkin();
			
			_downBtn.addEventListener(MouseEvent.MOUSE_DOWN,function(){_downBtn.addEventListener(Event.ENTER_FRAME,rollDown);});
			_downBtn.addEventListener(MouseEvent.MOUSE_UP,function (){_downBtn.removeEventListener(Event.ENTER_FRAME,rollDown)});
			
			_upBtn.addEventListener(MouseEvent.MOUSE_DOWN,function(){_upBtn.addEventListener(Event.ENTER_FRAME,rollUp);});
			_upBtn.addEventListener(MouseEvent.MOUSE_UP,function (){_upBtn.removeEventListener(Event.ENTER_FRAME,rollUp)});
			_dragMc.buttonMode=true;
			_dragMc.addEventListener(MouseEvent.MOUSE_DOWN,dragScroll);
			_dragMc.addEventListener(MouseEvent.MOUSE_UP,stopdragScroll);
			_targetContainer.addEventListener(MouseEvent.MOUSE_WHEEL,wheeling)
			//_targetContainer.addEventListener(Event.SCROLL,rolling);
			
           // _targetContainer.addEventListener(Event.CHANGE,rolling);
			_bg.addEventListener(MouseEvent.CLICK,bgclick);
			
			setdragMc();
			checkContainer()
			addChild(_Skin);
			
			

		}
		public function set showArrowBtn(val:Boolean) {
			_showArrowBtn = val
			var event = new Event(CHANGE_ARROWBTN_VIEW, true)
			dispatchEvent(event)
		}
		public function get showArrowBtn():Boolean {
			return _showArrowBtn
		}
		private function DataInit() {
			_msk=_targetContainer.mask
			_lockBarHeight=false;
			_barSpeed=5
			if(_direction=="V"){
				this.rotation=0
			}else{
				this.rotation=-90
			}
			
		}
		private function addEvent() {
			//addEventListener(CHANGE_ARROWBTN_VIEW,initSkin)
		}
		
		 
		private function initSkin(e=null) {
			if (showArrowBtn == false) {
				_upBtn.visible=_downBtn.visible=false
				_upBtn.x=0;
				_upBtn.y = 0;
				_downBtn.x = 0;
				_downBtn.y=0
				//if (_upBtn.getRect(this).y<0) {
				//	_upBtn.y=- _upBtn.getRect(_Skin).y;
				//}
				var tmpLen=(_direction=="V")?_msk.height:_msk.width//判断是水平滚动条还是垂直滚动条
				var tmp_h=(HEIGHT!=undefined)?HEIGHT:tmpLen;
				//var h=Math.round(tmp_h-_upBtn.height-_downBtn.height);
				_bg.x=0;
				_bg.height=tmp_h
				_bg.y=0
				
				//_downBtn.y=_bg.y+_bg.height;
			}else {
				
				_upBtn.x=0;
				_upBtn.y = 0;
				
				if (_upBtn.getRect(this).y<0) {
					_upBtn.y=- _upBtn.getRect(_Skin).y;
				}
				
				var tmpLen = (_direction == "V")?_msk.height:_msk.width//判断是水平滚动条还是垂直滚动条
				
				var tmp_h = (HEIGHT != undefined)?HEIGHT:tmpLen;
					
				var h=Math.round(tmp_h-_upBtn.height-_downBtn.height);
				_bg.x = 0;
			
				_bg.height=h
				_bg.y=0
				_downBtn.x=0;
				_downBtn.y=_bg.y+_bg.height;
			
			}
			
			_dragMc.x=Math.round((_bg.width-_dragMc.width)*0.5)
			
		}
		
        private function wheeling(e){//滚动鼠标滚轮时
			var d=-e.delta
			moveDrag(d)
			
		};
		private function moveDrag(d:Number){//移动滑动按钮
		var tmpY=_dragMc.y+d
		if(tmpY<_bg.y){
					tmpY=_bg.y
				}
		if (tmpY + _dragMc.height > _bg.y + _bg.height) {
			
				tmpY=_bg.y-_dragMc.height+_bg.height
				
			}
			_dragMc.y=tmpY
			setdragMc()
		}
		public function set _height(_value:Number) {//设置滚动条的高度
			HEIGHT = _value;//为了避免拖动滑动按钮的时候出现BUG，startDrag对于不是整数的Rectangle不准确，似乎会自动用Math.floor()转换值整数
			if (showArrowBtn == false) {
				_bg.height = Math.round(HEIGHT);
			}else{
			_bg.height = Math.round(HEIGHT - _upBtn.height - _downBtn.height);
			
			_downBtn.y = _bg.y + _bg.height;
			}
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
			moveDrag(_barSpeed*-1)
		}
		private function rollDown(e) {
			
			moveDrag(_barSpeed*1)
			
		}
		
		public function set barspeed(_value:Number){//设置上下按钮按下时滚动条移动的距离
		_barSpeed=_value
		dispatchEvent(new Event(SETBARSPEED));
		}
		
		public function get barspeed(){
			var tmpbarSpeed=_barSpeed
			return tmpbarSpeed
		}
		
		public  function checkContainer() {
		 
			//检查容器内的元件的状态和属性，单独使用此滚动条的时候用的，在接下来的组件Container组件里将不使用此方法
		var tmpMax=(_direction=="V")?_targetContainer.mask.height:_targetContainer.mask.width
		var tmpLen=(_direction=="V")?_targetContainer.height:_targetContainer.width
			if(tmpMax-tmpLen>=0){
				//遮罩比装载的元件大，不需要滚动条
				this.visible=false
			}else{
				this.visible=true
			}
				
				
		}
		private function dragScroll(e) {
			
			var rec:Rectangle=new Rectangle(_bg.x,_bg.y,0,_bg.height-e.target.height);
			e.target.startDrag(false,rec);
			this.addEventListener(Event.ENTER_FRAME,rolling);
			stage.addEventListener(MouseEvent.MOUSE_UP,stopdragScroll);
			dispatchEvent(new Event(BARSCROLLING));
			
			
		}
		private function stopdragScroll(e=null) {
			_dragMc.stopDrag();
			if(Math.abs(_dragMc.y-(_bg.y+_bg.height)+_dragMc.height)<1){
				_dragMc.y=_bg.y+_bg.height-_dragMc.height
				setdragMc();
			}
			this.removeEventListener(Event.ENTER_FRAME,rolling);
			stage.removeEventListener(MouseEvent.MOUSE_UP,stopdragScroll);
			
            dispatchEvent(new Event(BARSCROLLSTOPED));
		}
		private function rolling(e=null) {
		
			/*if(Math.abs(_dragMc.y-(_bg.y+_bg.height)+_dragMc.height)<1){
				_dragMc.y=_bg.y+_bg.height-_dragMc.height
				
			}*/
			setdragMc();
		}
		
		private function setdragMc(e=null) {
			//_targetContainer
			
			if (_lockBarHeight==false) {//如果滚动条的按钮高度没有被锁定
			var tmpHeight=Math.round((_msk.height/_targetContainer.height)*_bg.height)
			_dragMc.height=(tmpHeight>5)?tmpHeight:5
			}else{
			}
			//trace(_dragMc.y+"/"+(_bg.y+_bg.height-_dragMc.height))
			srollContainer()
			
			
		}//end function
		
        private function srollContainer() {//滚动容器
			var p:Number
			if (showArrowBtn==false) {
			 p=(_dragMc.y)/(_bg.height-_dragMc.height)
			}else {
			 p=(_dragMc.y-_upBtn.height)/(_bg.height-_dragMc.height)
			}
			 
			if(_direction=="V"){
			    //_targetContainer.y = _msk.y - p * (_targetContainer.height - _msk.height)
				var ty= _msk.y - p * (_targetContainer.height - _msk.height)
				TweenLite.to(_targetContainer,0.2,{y:ty})
			
			}else{
				//_targetContainer.x=_msk.x-p*(_targetContainer.width-_msk.width)
				var tx = _msk.x - p * (_targetContainer.width - _msk.width)
				TweenLite.to(_targetContainer,0.2,{y:tx})
			}
			
			
		}
		private function bgclick(e=null) {//滚动条背景点击文本框快速定位
			if (this.mouseY<=_dragMc.y) {
				_dragMc.y=this.mouseY;
				//trace(this.mouseY+"/"+e.localY);
			} else {
				_dragMc.y=(this.mouseY-_dragMc.y-_dragMc.height)+_dragMc.y;
			}
			setdragMc()
			
            dispatchEvent(new Event(BGCLICKED));

		}
	}
}