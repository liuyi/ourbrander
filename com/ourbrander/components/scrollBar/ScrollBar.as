package com.ourbrander.components.scrollBar{
	/*
	奥博瑞德滚动条1(AS3)
	     
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
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;

	public class ScrollBar extends MovieClip {
		//视图设定
		private var _Skin:Sprite;
		private var _targetContainer:*;
		private var _upBtn:InteractiveObject;
		private var _downBtn:InteractiveObject;
		private var _bg:InteractiveObject;
		private var _dragMc:Sprite;
        private var _msk:*
		//变量设定
		private var _dx:Number;//滚动条相对文本框的X坐标距离
		private var _dy:Number;//滚动条相对文本框的X坐标距离
		private var HEIGHT:Number=-1//滚动条的高度
		private var _lockBarHeight:Boolean;
		private var _dheight:Number
		private var _dwidth:Number
		private var _direction:String//垂直或水平方向的滚动条
		private var _barSpeed:Number;//上下按钮按下时滑动按钮移动的距离
		//滚动条滑动按钮高度锁定状态，默认为false
		public static const SETINTERFACE:String="setInterface"
        public static const LOCKED:String="locked";
		public static const UNLOCK:String="unlock";
		public static const BGCLICKED:String="bgclicked"
		public static const BARSCROLLING:String="barscrolling"
		public static const BARSCROLLSTOPED:String="barscrollstop"
		public static const SETBARSPEED:String="setbarspeed"
			
		public var autoDestory:Boolean=true;//如果这个值为真的话 那么当滚动条被移除舞台的时候就会自动销毁。否则就需要手动调用destroy();
		

		public function ScrollBar(target:*,tmpDirection:String=null) {//构造函数
			_targetContainer=target;
			_direction = (tmpDirection != null)?tmpDirection:"V";
			addEventListener(Event.ADDED_TO_STAGE,addedToStage)
			
			DataInit();
		}
		
		protected function addedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE,removedFromStage)
		}
		
		protected function removedFromStage(e:Event):void 
		{
			if(autoDestory) destroy();
			stage.removeEventListener(MouseEvent.MOUSE_UP,stopdragScroll);
		}
		
		public function destroy():void{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			_downBtn.removeEventListener(MouseEvent.MOUSE_DOWN,function():void{_downBtn.addEventListener(Event.ENTER_FRAME,rollDown);});
			_downBtn.removeEventListener(MouseEvent.MOUSE_UP,function ():void{_downBtn.removeEventListener(Event.ENTER_FRAME,rollDown)});
			
			_upBtn.removeEventListener(MouseEvent.MOUSE_DOWN,function():void{_upBtn.addEventListener(Event.ENTER_FRAME,rollUp);});
			_upBtn.removeEventListener(MouseEvent.MOUSE_UP,function ():void{_upBtn.removeEventListener(Event.ENTER_FRAME,rollUp)});
			
			_dragMc.removeEventListener(MouseEvent.MOUSE_DOWN,dragScroll);
			_dragMc.removeEventListener(MouseEvent.MOUSE_UP,stopdragScroll);
			_targetContainer.removeEventListener(MouseEvent.MOUSE_WHEEL,wheeling)
			
			_bg.removeEventListener(MouseEvent.CLICK, bgclick);
			
			this.removeEventListener(Event.ENTER_FRAME,rolling);
			
		}
		
		//如果没办法使用约定的皮肤名字，就从skinNames里传名字好了。这个问题是在把自己的代码与别人的联合时遇到的。
		public function setInterface(target:Sprite,skinNames:Array=null) :void{//更换滚动条的皮肤
			if (_Skin==null) {

			} else {
				this.removeChild(_Skin);
				dispatchEvent(new Event(SETINTERFACE));
			}
			if(skinNames==null) skinNames=["upBtn","downBtn","bg","dragMc"];
			
			_Skin=target;
			_upBtn=_Skin.getChildByName(skinNames[0]) as InteractiveObject;
			_downBtn=_Skin.getChildByName(skinNames[1]) as InteractiveObject;
			_bg=_Skin.getChildByName(skinNames[2]) as InteractiveObject;
			_dragMc=_Skin.getChildByName(skinNames[3]) as Sprite;
			initSkin();
			
			_downBtn.addEventListener(MouseEvent.MOUSE_DOWN,function():void{_downBtn.addEventListener(Event.ENTER_FRAME,rollDown);});
			_downBtn.addEventListener(MouseEvent.MOUSE_UP,function ():void{_downBtn.removeEventListener(Event.ENTER_FRAME,rollDown)});
			
			_upBtn.addEventListener(MouseEvent.MOUSE_DOWN,function():void{_upBtn.addEventListener(Event.ENTER_FRAME,rollUp);});
			_upBtn.addEventListener(MouseEvent.MOUSE_UP,function ():void{_upBtn.removeEventListener(Event.ENTER_FRAME,rollUp)});
			if(_dragMc.hasOwnProperty("buttonMode"))
				_dragMc["buttonMode"]=true;
			_dragMc.addEventListener(MouseEvent.MOUSE_DOWN,dragScroll);
			_dragMc.addEventListener(MouseEvent.MOUSE_UP,stopdragScroll);
			_targetContainer.addEventListener(MouseEvent.MOUSE_WHEEL,wheeling)
			//_targetContainer.addEventListener(Event.SCROLL,rolling);
			
           // _targetContainer.addEventListener(Event.CHANGE,rolling);
			_bg.addEventListener(MouseEvent.CLICK, bgclick);
			
			setdragMc();
			addChild(_Skin);
		}
		
		private function DataInit():void {
			_msk=_targetContainer.mask
			_lockBarHeight=false;
			_barSpeed=5
			if(_direction=="V") {
				this.rotation=0
			}else{
				this.rotation=-90
			}
		}
		private function initSkin():void {
			
			_upBtn.x=0;
			_upBtn.y = 0;
		 
			if (_upBtn.getRect(this).y<0) {
				_upBtn.y=- _upBtn.getRect(_Skin).y;
			}
		
			var tmpLen:Number=(_direction=="V")?_msk.height:_msk.width//判断是水平滚动条还是垂直滚动条
			var tmp_h:Number = (HEIGHT >=0)?HEIGHT:tmpLen;
			 
			var h:Number = Math.round(tmp_h - _upBtn.height - _downBtn.height);
		 
			_bg.x=0;
			_bg.height = h
				 
			_bg.y = _upBtn.height + 0;
			 
			_downBtn.x=0;
			_downBtn.y=_bg.y+_bg.height;
			 
			rest()
			 
		}
		
        private function wheeling(e:MouseEvent):void{//滚动鼠标滚轮时
			var d:Number=-e.delta
			moveDrag(d)
			
		};
		private function moveDrag(d:Number):void{//移动滑动按钮
		var tmpY:Number=_dragMc.y+d
		if(tmpY<_bg.y){
					tmpY=_bg.y
				}
		if(tmpY+_dragMc.height>_bg.y+_bg.height){
				tmpY=_bg.y-_dragMc.height+_bg.height
				
			}
			_dragMc.y=tmpY
			setdragMc()
		}
		public function set _height(_value:Number) :void{//设置滚动条的高度
			HEIGHT=_value;//为了避免拖动滑动按钮的时候出现BUG，startDrag对于不是整数的Rectangle不准确，似乎会自动用Math.floor()转换值整数
			_bg.height=Math.round(HEIGHT-_upBtn.height-_downBtn.height);
			_downBtn.y=_bg.y+_bg.height;
			 setdragMc()
		}
		public function get _height() :Number{
			var tmpheight:Number=HEIGHT;
			return tmpheight;
		}

		public function set lockBarHeight(_value:Boolean) :void{//滚动条滑动按钮高度锁定状态
			_lockBarHeight=_value;
			if (_lockBarHeight==true) {
				dispatchEvent(new Event(LOCKED));
			} else {
				dispatchEvent(new Event(UNLOCK));
			}

		}
		public function get lockBarHeight():Boolean {

			return _lockBarHeight;
		}
		
		public function updateToBottom():void{
			setdragMc();
			_dragMc.y = _downBtn.y-_dragMc.height;
			setdragMc();
			
		}

		private function rollUp(e:Event) :void{
			moveDrag(_barSpeed*-1)
		}
		private function rollDown(e:Event):void {
			
			moveDrag(_barSpeed*1)
			
		}
		
		public function set barspeed(_value:Number):void{//设置上下按钮按下时滚动条移动的距离
		_barSpeed=_value
		dispatchEvent(new Event(SETBARSPEED));
		}
		
		public function get barspeed():Number{
	
			return _barSpeed;
		}
		
		public function checkContainer():void{
			var tmpMax:Number=(_direction=="V")?_targetContainer.mask.height:_targetContainer.mask.width
			var tmpLen:Number=(_direction=="V")?_targetContainer.height:_targetContainer.width
			if(tmpMax-tmpLen>=0){
				//遮罩比装载的元件大，不需要滚动条
				this.visible=false
			}else{
				this.visible=true
			}
				//trace(tmpMax+"/"+tmpLen+"_targetContainer:"+_targetContainer.mask.width+"/_targetContainer:"+_targetContainer.width+"/"+this.visible+"/"+_targetContainer.x+"/"+_targetContainer.width)
		
		}
		private function dragScroll(e:Event):void {
			
			var rec:Rectangle=new Rectangle(_bg.x,_bg.y,0,_bg.height-e.target.height);
			e.target.startDrag(false,rec);
			this.addEventListener(Event.ENTER_FRAME,rolling);
			stage.addEventListener(MouseEvent.MOUSE_UP,stopdragScroll);
			dispatchEvent(new Event(BARSCROLLING));
			
			
		}
		private function stopdragScroll(e:Event=null):void {
			_dragMc.stopDrag();
			if(Math.abs(_dragMc.y-(_bg.y+_bg.height)+_dragMc.height)<1){
				_dragMc.y=_bg.y+_bg.height-_dragMc.height
				setdragMc();
			}
			this.removeEventListener(Event.ENTER_FRAME,rolling);
			stage.removeEventListener(MouseEvent.MOUSE_UP,stopdragScroll);
			
            dispatchEvent(new Event(BARSCROLLSTOPED));
		}
		private function rolling(e:Event=null) :void{
		//	trace(Math.abs(_dragMc.y-(_bg.y+_bg.height)+_dragMc.height))
			/*if(Math.abs(_dragMc.y-(_bg.y+_bg.height)+_dragMc.height)<1){
				_dragMc.y=_bg.y+_bg.height-_dragMc.height
				
			}*/
			setdragMc();
		}
		
		private function setdragMc(e:Event=null) :void{
			//_targetContainer
			
			if (_lockBarHeight==false) {//如果滚动条的按钮高度没有被锁定
				var tmpHeight :Number= Math.round((_msk.height / _targetContainer.height) * _bg.height)
				if (tmpHeight>_bg.height) {
					tmpHeight=_bg.height
				}
				_dragMc.height=(tmpHeight>5)?tmpHeight:5
			}else{
			}
			//trace(_dragMc.y+"/"+(_bg.y+_bg.height-_dragMc.height))
			srollContainer()
		 
			
		}//end function
		
		public function manualUpdate():void{
			setdragMc();
			 
		}
		public  function rest():void {
		 
			_dragMc.y = 0 + _upBtn.height
		 
			setdragMc()
			 
		}
        private function srollContainer():void{//滚动容器
			var p:Number=(_dragMc.y-_upBtn.height)/(_bg.height-_dragMc.height)
				if(_direction=="V"){
			    //_targetContainer.y = _msk.y - p * (_targetContainer.height - _msk.height)
				var ty:Number= _msk.y - p * (_targetContainer.height - _msk.height)
				TweenLite.to(_targetContainer,0.2,{y:ty})
			
			}else{
				//_targetContainer.x=_msk.x-p*(_targetContainer.width-_msk.width)
				var tx :Number= _msk.x - p * (_targetContainer.width - _msk.width)
				TweenLite.to(_targetContainer,0.2,{x:tx})
			}
			
			
			
		}
		private function bgclick(e:Event) :void{//滚动条背景点击文本框快速定位
			if (this.mouseY<=_dragMc.y) {
				_dragMc.y=this.mouseY;
			//	trace(this.mouseY+"/"+e.localY);
			} else {
				_dragMc.y=(this.mouseY-_dragMc.y-_dragMc.height)+_dragMc.y;
			}
			setdragMc()
			
            dispatchEvent(new Event(BGCLICKED));

		}
	}
}