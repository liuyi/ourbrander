package com.ourbrander.pages
{

	import flash.display.Sprite;
	import flash.events.Event;
	
	public class BasicPage   implements IPage
	{
		protected var _playInCallBack:Function;
		protected var _playOutCallBack:Function;
		protected var _hasTransIn:Boolean=false;
		protected var _hasTransOut:Boolean=false;
		protected var _autoDestroy:Boolean=true;
		protected var _view:Sprite;
		

		
		public function BasicPage(view:Sprite=null)
		{
			super();
			this.view=view;
			
		}
		
		protected function onAddedToStage(event:Event):void
		{
			// TODO Auto-generated method stub
			this._view.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			this._view.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			
			init();
		}
		
		protected function onRemoveFromStage(event:Event):void
		{
			// TODO Auto-generated method stub
			this._view.removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			
			if(_autoDestroy) destroy();
		}
		
		protected function init():void{
			initUI();
		}
		
		protected function initUI():void{
			
		}
		
	
		
		public function get hasTransOut():Boolean
		{
			return _hasTransOut;
		}
		
		public function get hasTransIn():Boolean
		{
			return _hasTransIn;
		}
		
		public function playIn(onComplete:Function):void{
			if(onComplete!=null) {onComplete();}
		}
		
		public function playOut(onComplete:Function):void{
			if(onComplete!=null) {onComplete();}
		}
		
		public function destroy():void{
			
		}

		public function get autoDestroy():Boolean
		{
			return _autoDestroy;
		}

		public function set autoDestroy(flag:Boolean):void
		{
			_autoDestroy = flag;
		}

		public function get view():Sprite
		{
			return _view;
		}

		public function set view(value:Sprite):void
		{
			_view = value;
			
			if(this._view.stage){
				init();
			}else{
				this._view.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			}
			
			
		}


	}
}