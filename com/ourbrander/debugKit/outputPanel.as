package com.ourbrander.debugKit 
{

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.events.KeyboardEvent
	import com.ourbrander.webObj.component.scrollBar.textScrollbar
	
	
	/**
	 * ...
	 * @author liuyi,if you want find more help doucment or anything,you can vist my website:www.ourbrander.com or send me email:contact@ourbrander.com
	liuyi
	 */
	public class outputPanel extends Sprite
	{
		private static var  _obj:outputPanel = null
		private  var _txt:TextField = new TextField
		private var  _bg:Sprite = new Sprite()
		private  var _beshow:Boolean = false
		private var _width:Number = 200
		private var _height:Number = 300
		private var offsetX:Number = 10
		private var offsetY:Number = 20
		private static var _str:String = ""
		private var _textScrollbar:textScrollbar
		
		private var _clear_mc:MovieClip
		 
		
		public function outputPanel() 
		{
			 if (outputPanel._obj != null) {
				 throw new Error("outputPanel is a single class")
			 }else{
				init()
			 }
		}
		
	    private  function init() {
		 
			 this.visible=false
			outputPanel.obj = this
			addEventListener(Event.ADDED_TO_STAGE,addtoStage)
			 initDisplayPanle()
		}
		
		private function addtoStage(e:Event) {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyboardEventHandler)
			_bg.addEventListener(MouseEvent.MOUSE_DOWN, bgPressDown)
			_bg.addEventListener(MouseEvent.MOUSE_UP, bgRelease)
			_clear_mc.addEventListener(MouseEvent.MOUSE_DOWN,clear)
		}
		private function removefromStage(e:Event) {
			removeEventListener(Event.ADDED_TO_STAGE,addtoStage)
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, KeyboardEventHandler)
			_bg.removeEventListener(MouseEvent.MOUSE_DOWN, bgPressDown)
			_bg.removeEventListener(MouseEvent.MOUSE_UP,bgRelease)
		}
		/*public static function init() {
			var m = new outputPanel()
			
		}*/
		private function initDisplayPanle() {
			_bg.graphics.beginFill(0x000000,0.6)
			_bg.graphics.drawRect(0, 0, _width, _height)
		   _bg.width = _width
		   _bg.height = _height
		   initScrollbar()
		    updateDisplayPanle()
			_txt.border = true
			_txt.textColor = 0xffffff
			_txt.multiline = true
			_txt.wordWrap=true
			addChild(_bg)
			addChild(_txt)
			_clear_mc = new MovieClip()
			_clear_mc.graphics.beginFill(0x006633, 0.6)
			_clear_mc.graphics.drawRect(0, 0,50, 20)
			var _clear_txt:TextField = new TextField()
			_clear_txt.width = 50
			_clear_txt.height = 25
			_clear_txt.selectable = false
			
			_clear_txt.textColor = 0x0099cc
			_clear_txt.text = "CLEAR"
			_clear_mc.addChild(_clear_txt)
			_clear_mc.x =_bg.width-offsetX-50
			 
			this.addChild(_clear_mc)
		}
		 
		private function updateDisplayPanle() {
			var w=_bg.width - offsetX*2
		   var h=_bg.height - offsetY*2
		   _txt.width =( w>0)?w:0
		   _txt.height = ( h>0)?h:0
		   _txt.x = offsetX
		   _txt.y=offsetY
		}
		private function initScrollbar() {
			var dragMc:MovieClip = new MovieClip()
			dragMc.name = "dragMc"
			
			var bg:MovieClip = new MovieClip()
			bg.name = "bg"
			var upBtn:MovieClip = new MovieClip()
			upBtn.name = "upBtn"
			var downBtn:MovieClip = new MovieClip()
			downBtn.name = "downBtn"
			var skin:MovieClip = new MovieClip()
			
			dragMc.graphics.beginFill(0x000000,0.3)
			dragMc.graphics.drawRect(0, 0, 20,  20)
			
			bg.graphics.beginFill(0x000000,0.4)
			bg.graphics.drawRect(0, 0,  20,  20)
			
			upBtn.graphics.beginFill(0x000000,0.5)
			upBtn.graphics.drawRect(0, 0,  20,  20)
			
			downBtn.graphics.beginFill(0x000000,0.5)
			downBtn.graphics.drawRect(0, 0,  20,  20)
			
			skin.addChild(bg)
			skin.addChild(dragMc)
		
			skin.addChild(upBtn)
			skin.addChild(downBtn)
			
			_textScrollbar=new textScrollbar(_txt)
			_textScrollbar.setInterface(skin)
			_textScrollbar.x = _bg.width
			_textScrollbar.y = _bg.y
			_textScrollbar._height=_bg.height
		   addChild(_textScrollbar)
		}
		 
		public  function show() {
			if (outputPanel._obj == null) {
				init()
			}
		 
			updateDisplayPanle()
			
			this.visible = true
			_beshow=true
		}
		public  function hide() {
		 
			 this.visible=false
			_beshow=false
		}
		
		
		private function KeyboardEventHandler(e:KeyboardEvent) {
			var key:uint=e.keyCode
			var ctrl:Boolean=e.ctrlKey
			var shift:Boolean = e.shiftKey
			//com.ourbrander.debug.itrace(key)
			//77="m" 67="c"
		//	_txt.appendText(ctrl+"/"+shift+"/"+key+"\n")
			if (ctrl == true && shift == true &&  key == 77) {
			
				toggleState()
			}
			if (ctrl == true && shift == true && key == 67) {
			
				outputPanel.clear()
			}
			
		}
		
		private function toggleState() {
			if (_beshow==true) {
				hide()
			}else {
				show()
			}
		}
	
		
		public function addText($str:String="") {
			_txt.appendText($str)
		}
		public function setText($str:String) {
			_txt.text=$str
		}
		
		
		private function bgPressDown(e:MouseEvent) {
			this.startDrag()
		}
		private function bgRelease(e:MouseEvent) {
			this.stopDrag()
		}
	   private  static function set  obj(o:outputPanel) {
			_obj=o
		}
		private static function get obj():outputPanel {
			var k = _obj 
			return k
		}
		public static function dtrace(... object) {
			 
			 var s:String=""
			for (var i in object) {
		 
				
					 if (object[i] is String) {
						 s+=object[i]
					 }else {
						 s += object[i].toString()
					 
					 }

			}
			 
		 
			_obj.addText(s+"\n") 
		}
		
		public static function clear(e=null) {
			_str=""
			_obj.setText("")
		}
		
	}//end class
}