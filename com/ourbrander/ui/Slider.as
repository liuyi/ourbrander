package com.ourbrander.ui
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class Slider extends UIObject
	{
		public var slug:MovieClip;
		public var activeBg:MovieClip;
		protected var dragRec:Rectangle=new Rectangle()
		protected var _progress:Number=0; //0-1
		protected var _maxValue:Number=1;
		protected var _minValue:Number=0;
		protected var _value:Number=0;
		protected var maxActiveWidth:Number=0;
		protected var _distance:Number=_maxValue-_minValue;
		protected var _isDraging:Boolean=false;
		
		protected var _sliderOffsetLeft:Number=0;
		protected var _sliderOffseRight:Number=0;
		protected var _sliderOffsetTop:Number=0;
		protected var _sliderOffsetBottom:Number=0;
		
		/**
		 * @params target slider:Slider
		 */
		public var onChange:Function;
		
		/**
		 * @desc on mouse up call this function
		 */
		public var onSelected:Function;
		public function Slider(uiKey:String="Slider",view:Sprite=null)
		{
			super(uiKey,view);
		}
		override public function setView(view:Sprite):void{
			super.setView(view);
			slug=view.getChildByName("slug") as MovieClip;
			activeBg=view.getChildByName("activeBg") as MovieClip;
			slug.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown)
			
			
			activeBg.width=bg.width;
			
			
			dragRec.y=slug.y;
			dragRec.height=0;
			
			dragRec.width=bg.width-slug.width;
			
			maxActiveWidth=bg.width;
			activeBg.width=slug.width;
			slug.buttonMode=true;
			
			setSliderOffset(_sliderOffsetLeft,_sliderOffsetTop,_sliderOffseRight,_sliderOffsetBottom)
			
		}
		
		override protected function resizeSelf():void{
			super.resizeSelf();
			
			
			maxActiveWidth=bg.width;
			setSliderOffset(_sliderOffsetLeft,_sliderOffsetTop,_sliderOffseRight,_sliderOffsetBottom)
		}
		
		
		public function setSliderOffset(l:Number=0,t:Number=0,r:Number=0,b:Number=0):void{
			_sliderOffsetLeft=l;
			_sliderOffseRight=r
			_sliderOffsetTop=t;
			_sliderOffsetBottom=b;
			dragRec.width=maxActiveWidth-slug.width+_sliderOffsetLeft+_sliderOffseRight;
			dragRec.x=activeBg.x-_sliderOffseRight;
			
			updatePos()
		}
		
		
		
		
		
		override protected function onAddedToStage(event:Event):void{
			
		}
		override protected function onRemoveFromStage(event:Event):void{
			slug.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown)
			view.stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp)
			slug.removeEventListener(Event.ENTER_FRAME,updateByDrag)
			slug=null;
			activeBg=null;
			super.onRemoveFromStage(event);
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(event.currentTarget == slug){
				if(_isDraging==true) return;
				_isDraging=true
				slug.addEventListener(Event.ENTER_FRAME,updateByDrag)
				slug.startDrag(false,dragRec);
				
				view.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp)
			}
		}
		protected function onMouseUp(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(view.stage!=null){
				view.stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp)
			}
			
			slug.stopDrag();
			updateByDrag();
			slug.removeEventListener(Event.ENTER_FRAME,updateByDrag)
			//_progress=(slug.x-activeBg.x+_sliderOffsetLeft)/dragRec.width;
			//	_value=_distance*_progress+minValue;
			_isDraging=false;
			if(onSelected!=null){
				onSelected(this);
			}
			dispatchEvent(new Event(Event.SELECT,false,false));
		}
		
		protected function updateByDrag(event:Event=null):void
		{
			// TODO Auto-generated method stub
			
			activeBg.width=slug.x-activeBg.x+slug.width-_sliderOffseRight;
			
			_progress=(slug.x-activeBg.x+_sliderOffsetLeft)/dragRec.width;
			_value=_distance*_progress+minValue;
			
			
			if(onChange!=null){
				onChange(this)
			}
		}
		
		protected function updatePos(ignoreEvent:Boolean=true):void{
			_progress=(_value-minValue)/(_distance);
			
			
			
			slug.x=activeBg.x+(dragRec.width)*_progress-_sliderOffsetLeft;
			
			activeBg.width=slug.x-activeBg.x+slug.width-_sliderOffseRight;
			
			
			//if(onChange!=null && ignoreEvent==false){
			if(onChange!=null ){
				onChange(this)
			}
			
			if(onSelected!=null && ignoreEvent==false){
				onSelected(this)
			}
		}
		
		public function setValue(val:Number,ignoreEvent:Boolean=true):void{
			if(val>_maxValue) val=_maxValue;
			if(val<_minValue) val =_minValue;
			if(_value==val) return;
			
			_value=val;
			
			updatePos(ignoreEvent);
		}
		
		public function set value(val:Number):void{
			if(val>_maxValue) val=_maxValue;
			if(val<_minValue) val =_minValue;
			if(_value==val) return;
			
			_value=val;
			
			updatePos();
		}
		
		public function get value():Number{
			return _value
		}
		
		public function get maxValue():Number
		{
			return _maxValue;
		}
		
		public function set maxValue(value:Number):void
		{
			
			_maxValue = value;
			_distance=_maxValue-_minValue
			updatePos()
		}
		
		public function get minValue():Number
		{
			return _minValue;
		}
		
		public function set minValue(value:Number):void
		{
			_minValue = value;
			_distance=_maxValue-_minValue
			updatePos()
		}
		
		public function setRange(min:Number=0,max:Number=100):void{
			_minValue=min;
			_maxValue=max;
			_distance=_maxValue-_minValue
			updatePos()
		}
		
		public function get isDraging():Boolean
		{
			return _isDraging;
		}
		
		
	}
}