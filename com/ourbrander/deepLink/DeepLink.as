package com.ourbrander.deepLink 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL
	import flash.net.URLRequest;

	
	/**update:2011/3/3 add autoDeactive, if autoDeactive=false,then it would not   dispatch Event.Deavtive.
	 * update: 2011-1-25; modied open()
	 * Deeplink update:2011-1-5,added three events:Event.ACTIVATE , DeepLink.DEACTIVATE and Event.OPEN,when user open a new page or leave the current page, DeepLink.DEACTIVATE will occured.
	 * Event.ACTIVATE will be occured when user come back this page,or open this page.Event.OPEN will be occured when user open a new page (html page).
	 * 
	 * DeepLink is very simple and easier use.It can make visit flash like html.update:2010-12-31, version:1.1
	 * window.open() added 2 params:title,params ,use:_deeplink.open(e.text,"title","width=200,height=200");
	 * check latest version on:<a href="http://www.ourbrander.com/p/deeplink" target="blank">http://www.ourbrander.com/p/deeplink</a>
		
	
	 * @version 1.6
	 * @author liuyi 
	 * @example 

	 * <listing version="3.0">
	 * html:
	 * 
	 * &lt;html &gt;
	 * &lt;script type="text/javascript" src="js/swfobject.js" &gt;&lt;/script &gt;
	 *	&lt;script type="text/javascript" src="js/ourbrander.deeplink.js" &gt;&lt;/script &gt;
	 *	&lt;script type="text/javascript" &gt;
	 *			var flashvars = {};
	 *			var params = {wmode:"window",scale:"noScale",salign:"top",menu:"false",allowFullScreen:"true"};
	 *			var attributes = {name:"main",id:"main"};
	 *			swfobject.embedSWF("example1.swf", "flash_content", "800", "600", "10.0.0", "expressInstall.swf", flashvars, params, attributes,initDeeplink);
	 *			function initDeeplink(d){
	 *				var s=new deeplink();
	 * 
	 * 				//init deeplink js object
	  *				s.init('main');
	 *			
	 *			}
	 *			 
	 *		&lt;/script &gt;
	 *	&lt;/head &gt;

	 *	&lt;body  &gt;
	 *	&lt;center &gt;
	 *	&lt;div id="flash_content" &gt;no flash content &lt;/div &gt;
	 *	&lt;/center &gt;
	 *	&lt;/body &gt;
	 *	&lt;/html &gt;

	 *	swf:
		
	 *  var _deepLink=DeepLink.getInstance();
	 * 
	 *  _deeplink.addEventListener(Event.CHANGE, onLinkChanged);
	 *  _deeplink.addEventListener(Event.INIT, onLinkChanged);//at the fist time,it will dispatch the Event: Event.INIT to differentiate the fist location and others.Maybe somebody want different code for the two behavior.
	 * 
	 * _deeplink.init();
	 *  private function onLinkChanged(e:Event=null) {
	 * 	//swtich page code ...
	 * 	var hash = (_deeplink.getHashAt(0) == "")?"home":_deeplink.getHashAt(0);
	 *  }
	 * 
	 *  home_btn.click=function(){
	 * 	_deeplink.navigateTo("/home/")
	 *  }
	 
	 you can download the whole  example souce code from http://www.ourbrander.com/p/deeplink
	 * </listing>
	 */
	 
	public class DeepLink extends EventDispatcher
	{
		/**@private */
        private static var _deepLink:DeepLink;
		public static var DEACTIVATE :String= "deeplink_deactivate" ;
		/**@private */
		private var _params:Array;
		/**@private */
		private var _history:Array;
		
		public  var autoDeactive:Boolean=false
		public var active:Boolean
		/**
		 * Don't get DeepLink Object from new DeepLink(),please use DeepLink.getInstance(),it will return a DeepLink Object.
		 * @param	target
		 */
		public function DeepLink(target:IEventDispatcher=null) :void
		{
			super(target)
		}
		
		/**
		 *  it will return  a deepLink Object.Start deep-link from this function.
		 * @return DeepLink Object;
		 */
		public static function getInstance():DeepLink {
			if (DeepLink._deepLink==null) {
				DeepLink._deepLink = new DeepLink()
				DeepLink._deepLink.create();
			}
			return DeepLink._deepLink;
		}
		
		/**
		 * Init deeplink object,so as to set flash's first location .It will dispatch the Event:Event.Init
		 * if need start load correct cotent at the frist. use init() to  initialize location.
		 */
		public function init():void {
			
			if (ExternalInterface.available) {
				var init_hash:String = ExternalInterface.call("deeplink", "init:true");
				deeplink_onLinkOpened(init_hash);
			}
		}
		/**@private
		 * 
		 */
		protected function create():void{
			
			if (!ExternalInterface.available) {
				trace("ExternalInterface don't support")
				return 
			}
			_history = [];
			autoDeactive = false;
			active = true;
			ExternalInterface.addCallback("deeplink_onLinkChanged", deeplink_onLinkChanged);
			ExternalInterface.addCallback("deeplink_onLinkOpened", deeplink_onLinkOpened);
			
		//	ExternalInterface.addCallback("deeplink_onBlur", onBlur);
			//ExternalInterface.addCallback("deeplink_onFocus", onFocus);
			//ExternalInterface.addCallback("deeplink_onFocus2", onFocus);
			
			
		}
		
		protected function onFocus():void
		{
			if(autoDeactive){
				//getFocus();
			}
		}
		
		protected function onBlur():void
		{
			if(autoDeactive){
				//lostFocus();
				trace("on blur!!")
			}
		}
		/**@private
		 * 
		 */
		protected function deeplink_onLinkOpened(value:String=""):void
		{
		 
			var str:String = String(value).toLowerCase();
			var array:Array;
			if (str.charAt(str.length - 1) == "/") {	str=str.substring(0,str.length-1)}
			if (str.length<2) {
				array = []
			}else {
				array =  str.substr(2).split("/");
			}
			_history[0] = array;
		 
			dispatchEvent(new Event(Event.INIT,true))
		}
		 
		/**@private
		 * 
		 */
		private   function deeplink_onLinkChanged(value:String=""):void {
			var str:String = String(value).toLowerCase();
			var array:Array;
			if (str.charAt(str.length - 1) == "/") {	str=str.substring(0,str.length-1)}
			if (str.length<2) {
				array = []
			}else {
				array =  str.substr(2).split("/");
			}
	    
			_history.push(array)
			dispatchEvent(new Event(Event.CHANGE,true))
		}
		
		/**
		 * get current page's all hash params
		 */
		public function get params():Array {
			if (_history == null) {
				return []
			}
			
			if (_history.length<=0) {
				return []
			}
			
			if (currentHash== null) {
				return []
			}
			
			if (currentHash.length<=0) {
				return []
			}
			
			
			
			
			var arry:Array = []
			var len:uint =currentHash.length;
			for (var i:int = 0; i <len ;i++ ) {
				arry[i] =currentHash[i];
			}
		 
			return arry;
		}
		
		/**
		 * 
		 * @param	level 0 is the first node.
		 * @return   a string 
		 * <listing version="3.0">
	 * 
	 *  the page's url is http://www.ourbrander.com/p/deeplink/example2.html#/gallery/pic2,
	 * 
	 * var _deeplink=DeepLink.getInstance();
	 * 
	 * trace(_deeplink.getHashAt(0))   //gallery
	 * trace(_deeplink.getHashAt(1))   //pic2
	 * 
	 
	 * </listing>
	 */
		public function  getHashAt(level:uint):String {
			if (_history == null) {
				return "";
				
			}
			if (_history.length<=0) {
				return "";
			}
			
			if (currentHash == null) {
				return ""
			}
			
			if (currentHash.length<=0) {
				return ""
			}
			
			
			
			if (level >  currentHash.length - 1) {
			
				return "";
			}else {
				return currentHash[level];
			}
		}
		/**@private
		 * 
		 */
		private function get currentHash() :Array {
			
			if (_history == null){
				return [];
			}
			
			if( _history[_history.length - 1]!=null){
				return _history[_history.length - 1];
			}else {
				return []
			}
		}
		
		/**
		 * it's very importent function.deeplink use this function rewrite hash,and dispatched Event.CHANGE
		 * @param	str A string of target hash 
		 * 
		 * @example
		 *   <listing version="3.0">
		 *  home_btn.click=function(){
		*	 	_deeplink.navigateTo("/home/")
		*  }	 
		 * </listing>
		 */
		public  function navigateTo(str:String ):void {
			
		 
			if (!ExternalInterface.available) {
				return 
			}
			
			ExternalInterface.call("deeplink","url:"+str);
		}
		
		
		/**
		 * will return a array of  history.
		*/
		public function get  history():Array {
			var array:Array = []
			for (var i:int = 0; i < _history.length;i++ ) {
				var ar:Array = [];
				for (var k:int = 0; k < _history[i].length;k++ ) {
					 ar[k] = _history[i][k];
				}
				array[i] = ar;
			}
			
			return array;
		}
		
		
		/**
		 * open a page in new window.
		 * @param	url   string of  link
		 * 
		 * @example
		 *  <listing version="3.0">
		 * 	//if don't want t   pop-up blocker prevent the new page,open it like this
		 * 	_btn.addEventListener(MouseEvent.CLICK,clicked)
		 * 	function clicked(e:MouseEvent){
		 * 		_deeplink.open("http://www.ourbrander.com")
		 * 	}
		 * </listing>
		 */
		public function open(url:String, title:String = "", params:String = "",window:String="_blank"):void {
		
			if (autoDeactive!=true && window!="_self") 
			{
				lostFocus();
			}
			if (!ExternalInterface.available || window!="_blank") {
				
				navigateToURL(new URLRequest(url),window)
			}else {
				var a = ExternalInterface.call("window.open('" + url + "','" + title + "','" + params + "')");
				//when swf play in stand player or not on web.
				if (String(a)=="null") {
					navigateToURL(new URLRequest(url),window)
				}
			}
			
			
		}
		
		/**
		 *  set document 's title 
		 * @param	title  A string that will be set to document's title
		 */
		
		public function setTitle(title:String):void {
				if (!ExternalInterface.available) {
					
				}else {
					ExternalInterface.call("deeplink","title:"+title);
				}
				
				dispatchEvent(new Event(Event.OPEN,true))
			
		}
		/**
		 * when autoDeactive=false, use this function to dispatch Deactive Event.
		 */
		public function lostFocus():void {
			//trace("----------------------->lostFocus")
				active=false
				dispatchEvent(new Event(DeepLink.DEACTIVATE, true));
		}
		/**
		 * when autoDeactive=false, use this function to dispatch Active Event.
		 */
		public  function getFocus():void {
		 
			active = true;
			dispatchEvent(new Event(Event.ACTIVATE, true));
		}
		
		
		
		
	}

}