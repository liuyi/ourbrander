package com.ourbrander.component.containerBox
{
	import com.ourbrander.Event.superEvent;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import gs.TweenLite

	
	/**
	 * ...
	 * @author liuyi
	 * update:2011-1-24 removePage()
	 */
	public class container extends MovieClip
	{	
		private var _currentPage:String
		private var _pageHistory:Array = []
		private var _newPage:DisplayObject
		private var _speed:Number = 0.8
		private var _recordId:uint = 0
		
		private var _posx:Number=2000
		private var _posy:Number=0
		
		public function container() 
		{
		
			
			
		}
		
		 
		public function get currentPage():DisplayObject {
			var k = new String(_pageHistory[_pageHistory.length-1])
			
			return  this.getChildByName(k)
		}
		public function  getPageHistory():Array {
	        //clon and create a new array
			var btarray:ByteArray=new ByteArray()
			btarray.writeObject(_pageHistory)
			btarray.position = 0;
			var d:Array = new Array(btarray.readObject())
			return d
		}
		
		public function addNewPage(target:DisplayObject,style:String="slide") {
		//@style:"slide","fadeIn"
		 
			_newPage = target
			//
			if(style=="slide"){
				slideShow()
			}else {
				transition()
			}
		}
		public function removePage(speed:Number = 0.3,fun:Function=null) {
			if(speed<=0){
				displayed()
			}else {
				TweenLite.to(currentPage, speed, { autoAlpha:0, onComplete:displayed } );
			}
			
			function displayed() {
				while(this.numChildren>0){
				   this.removeChildAt(0);
				}
				_currentPage = ""
				if (fun != null) {
					fun();
				}
			}
		}
		public function set speed(num:Number) {
			_speed = num;
		}
		
		public function get speed():Number {
			return _speed
		}
		private function addPageRecord(target) {
			_pageHistory.push(target.name)
		}
		private function transition() {
			if(this.currentPage!=null){
				TweenLite.to(this.currentPage, _speed, { alpha:0, onComplete:tweenEnd, onCompleteParams:[this.currentPage,true] } )
			}else {
				showCurrentPage()
			}
		}
		
		private function tweenEnd(target,bol:Boolean=false) {
			 
			try{removeChild(target)}catch(e){}
			target = null
			if(bol==true){
				showCurrentPage()
			}
			
		}
		private function showCurrentPage() {
			if (_newPage == null) {
				return 
			}
			_newPage.visible = false
			_newPage.alpha = 0
			addChild(_newPage)
			addPageRecord(_newPage) 
			_newPage = null
			this.currentPage.visible = true
			TweenLite.to(this.currentPage, _speed, { alpha:1 , onComplete:displayed, onCompleteParams:[this.currentPage] } )
		}
		
		private function slideShow() {
			if(this.currentPage!=null){
				TweenLite.to(this.currentPage, _speed, { x:-2000, onComplete:tweenEnd, onCompleteParams:[this.currentPage]} )
			} 
			_newPage.x = _posx
			 _newPage.y = _posy
			addChild(_newPage)
			addPageRecord(_newPage) 
			_newPage = null
			this.currentPage.visible = true
			TweenLite.to(this.currentPage, _speed, { x:0 , onComplete:displayed, onCompleteParams:[this.currentPage] } )
			
		}
		
		
		
		private function displayed(target) {
		 
			var event:containerEvent = new containerEvent(containerEvent.CONTAINER_DISPLAYED,{currentTarget:target}, true)
			dispatchEvent(event)
		}
		
	}

}