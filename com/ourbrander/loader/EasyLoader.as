 
package com.ourbrander.loader{


 
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	/**
	 * update:2010/7/1:videoload()  added:client.onMetaData =function (d:object):void{}
	 * update:2011/6/28 itemLoad();
	 *  update:2012/2/15 _index=-1;
	 * itemLoad changed, add if no file type , can use method instead of filetype. such as  get a image from facebook:
	 * link:http://graph.facebook.com/{id}/picture?type=square
	 * _loader.addFile(link, "thumb","",false,"image");//can set the method to "image".
	 * 
	 update:2011/6/7  start();
	 * This class can be used to load sound,video,txt,xml,image,swf,dae etc. and you guys can add custom file type for easyLoader.
	 * @version 1.22
	 * @author liuyi 
	 * @example 
	 * update:20100825
	 * <listing version="3.0">
	 * date :2010/5/24
	 * update:2010/7/13  fixed splice() ,the  incorrect spelling. 
	 * you can find more infomation from :http://www.ourbrander.com/easyloader
	 * What is easyLoader?
	 * This work is use load all the assets of  website or game,it is an good assets manager.
	 * People can use it to load sound,video,txt,xml,image,swf,dae and so on.
	 * 
	 * Why we need it?
	 * -easy of use
	 *  Every method have a good naming,you can use it likes speak to an friend.Only need several lines to complete the work.
	 * 
	 * -never be lost items
	 *   load items one by one.
	 * 
	 * -excellent memory manage
	 *  Using it continually more than 24 hours,memory do not increase without limit.item can be destoried,easyLoader Object(include all assets) too.
	 * 
	 * -flexible
	 * User can add custom file type to loading.
	 * 
	 * -dynamic add items for easyLoader
	 *  EasyLoader can add and load new assets anytime and anywhere,although all the items were loaded.
	 * 
	 * -Updates
	 *  will updates according to user's requirements.
	 * 
	 * 
	 * How to use?
	 * 
	 * Realy only need several lines:
	 * 
	 * step1:
	 * new a easyLoader Object
	 * line1: var _assetsManager = new EasyLoader();
	 * 
	 * step2:
	 * add some necessary event Listener
	 * line2: _assetsManager.addEventListener(EasyLoaderEvent.COMPLETED,assetsLoaded)
	 * 
	 * step3:add the assetsLoaded function
	 * line2:private function assetsLoaded(e:EasyLoaderEvent) {
	 * line3:     //put some code to here like init()
	 * line4:}
	   
	 * step4:load assets according to config xml
	 * line5:_assetsManager.loadConfig("assets.xml")
	   
	 * ok,this is all!
	   
	 
	 * </listing>
	 */
	
	public class EasyLoader extends EventDispatcher {
		//config xml source data
		private var _xml:XML;
		//config xml urlLoader
		private var _urlLoader:URLLoader;
		//config xml size
		private var _bytesTotal:Number;
		//config xml loaded
		private var _bytesLoaded:Number;
		//all the loaded files list,will be  the list of all  load files 
		private var _loadList:Vector.<LoadItem>;
		//when item loading unsuccess,push it to _faultList
		private var _faultList:Array
		//when config xml loaded,if auto load files;
		private var _autoLoad:Boolean;
		//loader status
		private var _loaderStatus:String;
		//if ignore load error to download next file.
		private var _ignoreError:Boolean;
		//index of current file according to  xml childs number
		private var _index:int;
		//types of  files,let preloader know how to download them.user can add custom file type with function addType()
		private var _typeList:Array;
		
		private var _filesBytesLoaded:Number;
		private var _filesBytesTotal:Number;
		
		public var rootPath:String;
		
		private var _id:String;
		
		public static var isLocal:Boolean = true;
		public var autoGetSize:Boolean = true
		public var onGetSize:Function
		
		/* can regist an easyloader instance to Easyloader classes, so other class can get it by id or alias.
		 * */
		protected static var _instanceList:Vector.<EasyLoader>;
        
		
		/** The status const of easyLoader. When the config file is initializing, its status is LOADING_INITING*/
		public static const LOADING_INITING:String = "loading_initing";
		
		/** The status const of easyLoader. When the config file initialized, but haven't start loading progress, its status is FREE*/
		public static const FREE:String = "free";
		
		/** The status const of easyLoader. When the loadItem loading errors occured, its status is LOADING_ERROR*/
		public static const LOADING_ERROR:String = "loading_error";
		
		/** The status const of easyLoader. When all the loadItems loading finished, its status is LOADING_COMPLETED*/
		public static const LOADING_COMPLETED:String = "loading_completed";
		
		/** The status const of easyLoader. When the loadItems are loading, its status is LOADING_PROGRESS*/
		public static const LOADING_PROGRESS:String = "loading_progress";
		
		/** The status const of easyLoader. When the loading progress be paused, its status is LOADING_PAUSE*/
		public static const LOADING_PAUSE:String = "loading_pause";
		
		/** The status const of easyLoader. When the config file initialized, its status is LOADING_CONFIG_INITED*/
		public static const LOADING_CONFIG_INITED:String = "loading_config_inited";
		
		
		
		
		/** The method const of loadItem. When the loadItem initialized, its status is ITEM_STATUS_READY*/
		public static const LOADING_METHOD_VARIABLES:String = "variables";
		
		/** The method const of loadItem. When the loadItem initialized, its status is ITEM_STATUS_READY*/
		public static const LOADING_METHOD_XML:String = "xml";
		
		/** The method const of loadItem. When the loadItem initialized, its status is ITEM_STATUS_READY*/
		public static const LOADING_METHOD_BYTES:String = "bytes";
		
		/** The method const of loadItem. When the loadItem initialized, its status is ITEM_STATUS_READY*/
		public static const LOADING_METHOD_TEXT:String = "text";
		
		
		
		/** The status const of loadItem. When the loadItem initialized, the loadItem's status is ITEM_STATUS_READY*/
		public static const ITEM_STATUS_READY:String = "item_status_ready";
		/** The status const of loadItem. When the loadItem loading fault, the loadItem's status is ITEM_STATUS_FAULT*/
		public static const ITEM_STATUS_FAULT:String = "item_status_fault";
		/** The status const of loadItem. When the loadItem loading finished, the loadItem's status is ITEM_STATUS_COMPLETED*/
		public static const ITEM_STATUS_COMPLETED:String = "item_status_completed";
		/** The status const of loadItem. When the loadItem is in loading progress, the loadItem's status is ITEM_STATUS_PROGRESS*/
		public static const ITEM_STATUS_PROGRESS:String = "item_status_progress";
		/** Version of the classes*/
		public static const VERSION:String="1.22";
		 
		/**
		 * Create a new EasyLoader Object
		 * 
		 * @example This is a sample about how to use this class:
		 * <listing version="3.0">
		 *package classes{
		 *	  import flash.display.Bitmap;
			  import flash.display.MovieClip;
			  import com.ourbrander.loader.EasyLoader;
			  import com.ourbrander.loader.EasyLoaderEvent;
			  import flash.events.Event;
			  import flash.events.MouseEvent;
			  import flash.media.Sound;
			  import flash.media.SoundChannel;
			  import flash.media.Video;
			  import flash.net.NetStream;

			  public class easyLoader_example2 extends MovieClip {
			  private var _assetsManager:EasyLoader;
			  public function easyLoader_example2() {
			  init();
			  }
			  private function init() {
		  		 start_btn.addEventListener(MouseEvent.MOUSE_DOWN,startLoad);
				 add_btn.addEventListener(MouseEvent.MOUSE_DOWN,addAssets);
				 initAssets();
			  }
			  private function initAssets() {
				  _assetsManager=new EasyLoader  ;
				  _assetsManager.addEventListener(EasyLoaderEvent.COMPLETED,assetsLoaded);
				  _assetsManager.addEventListener(EasyLoaderEvent.LOADING_ERROR,assetsLoadError);
				  _assetsManager.addEventListener(EasyLoaderEvent.PROGRESS,assetsLoadProgress);
				  _assetsManager.addEventListener(EasyLoaderEvent.CONFIG_INIT_ERROR,configLoadError);
				  _assetsManager.loadConfig(&quot;assets2.xml&quot;);
				  //_assetsManager.autoLoad=false;
				 _assetsManager.addType(&quot;text&quot;,&quot;.txt2&quot;);//add a custom file type.
				  _assetsManager.addType(&quot;text&quot;,&quot;.tdb&quot;);//add a custom file type.
				  _assetsManager.addFile(&quot;assets/images/d8.png&quot;,&quot;myImg&quot;);
			  }
			  private function configLoadError(e) {
				  trace(&quot;&gt;&gt;configLoadError&quot;);
			  }
			  private function startLoad(e:MouseEvent) {
				 trace(&quot;startLoad:&quot;);
				  _assetsManager.start();
			  }
			  private function assetsLoaded(e:EasyLoaderEvent) {
				  trace(&quot;assetsLoaded:\n&quot;,_assetsManager.index+&quot;/&quot;+_assetsManager.length);
			   
			  }
			  private function assetsLoadError(e:EasyLoaderEvent) {
				  trace(&quot;assetsLoadError:\n&quot;,e);
			   
				 trace(_assetsManager.ignoreError);
			  }
			  private function assetsLoadProgress(e:EasyLoaderEvent) {
				 var cell=_assetsManager.getFileByIndex(_assetsManager.index);
			  
			  }
			  private function addAssets(e:MouseEvent) {
				  //get files from easyLoader 
				  var bitmap:Bitmap=_assetsManager.getFileByAlias(&quot;myImg&quot;).content;
				  bitmap.y=info_txt.y+info_txt.height;
				  addChild(bitmap);
				  var myswf=_assetsManager.getFileByAlias(&quot;myswf&quot;).content;
				  myswf.y=bitmap.y+bitmap.height+10;
				  addChild(myswf);
				  var xml:XML=_assetsManager.getFileByAlias(&quot;adobe_rss&quot;).content;
				  var txt:String=_assetsManager.getFileByAlias(&quot;artical&quot;).content;
				  var _user:Object=_assetsManager.getFileByAlias(&quot;userInfo&quot;).content;
				  trace(&quot;_user:&quot;+_user[&quot;name&quot;]);
				  var video:Video=new Video  ;
				  var _netstream:NetStream=_assetsManager.getFileByAlias(&quot;ckfree&quot;).content;
				  video.attachNetStream(_netstream);
				  video.y=myswf.y+myswf.height;
				  _netstream.resume();
				  addChild(video);
				  trace(_assetsManager.getFileByAlias(&quot;ckfree&quot;).content);
				  var mp3:Sound=_assetsManager.getFileByAlias(&quot;mymp3&quot;).content;
				  var chanel:SoundChannel=mp3.play(0,9999999);
				 //the same way to adding dae files to stage,if we have a 3d world!Guys,We’re counting on you this time!
				  

			&nbsp;
			  }
			 }
			}
			 
		 * </listing>
		 */
		public function EasyLoader() :void {
			
			initType();
			reset();
		
		}
		
		/*can get easyloader intance by id*/
		public static function getInstance(id:String):EasyLoader {
			if (_instanceList == null || _instanceList.length == 0) return null;
			
			var len:uint = _instanceList.length;
			for (var i:uint = 0; i < len; i++ ) {
			
				if (_instanceList[i].id == id) return _instanceList[i];
			}
			
			return null;
		}
		
		
		
		public function get id():String {
			return _id;
		}
		
		public function set id(str:String):void {
			if (EasyLoader.getInstance(str) != null) {
				trace("Pease use other name for this easyloader instance. The name " + str + "has be used for ohter instance.");
				throw new Error("Pease use other name for this easyloader instance. The name " + str + "has be used for ohter instance.");
				
			}else{
			_id = str;
			}
		}
		
		public static function register(obj:EasyLoader):void {
			if (_instanceList == null) _instanceList = new Vector.<EasyLoader>();
			_instanceList.push(obj);
		}
		public static function deRegister(id:String):void {
			if (_instanceList == null || _instanceList.length == 0) return ;
			
			var len:uint = _instanceList.length;
			for (var i:uint = 0; i < len;i++ ) {
				if (_instanceList[i].id == id) {
					_instanceList[i] = null;
					_instanceList.splice(i, 1);
				}
			}
		}

		/** It can be use to initialize  easyLoader Object
		 * @param obj:
		 * It can be assigned to a String or XML.If the value is a String,easyLoader will load a config xml file with this path;If the value is a XML object,easyLoader will init with this XML object. 
		 * @param $autoLoad:
		 * @default true
		 * true or false,if this value equal true.when easyLoader initialized config data,it will auto preload assets according to config data. 
		 * @param $ignoreError:
		 * @default true true or false,suggest set to true.once this params set to false,when easyLoader meet a error,it will puase download assets.
		 * */
		public function init(obj:Object=null,$autoLoad:Boolean=true,$ignoreError:Boolean=true):void {


			_autoLoad=$autoLoad;
			_ignoreError=$ignoreError;
			if (obj == null)  return 
			
			if (obj is String) {
				loadCofingXML(obj as String);
				
			} else if (obj is XML) {
				_xml=obj as XML;
				configLoaded();
				 
				
			} else if (obj is XMLList) {
				if (obj[0].hasChildNodes) {_xml = obj[0] as XML}
				else{
					_xml = new XML(<assets></assets>);
					_xml.appendChild(obj as XMLList)
				}
				 
				configLoaded();
				
				
			} else {
				throw new Error("incorrect config file type");
				
			}
			 
		}

		/** The number of bytes in the config file   */
		public function get bytesTotal():Number {
			return _bytesTotal;
		}
		/** The number of bytes that are loaded for the config file   */
		public function get bytesLoaded():Number {
			return _bytesLoaded;
		}

        /** Whether automatically loading assets */
		public function set autoLoad(bol:Boolean):void {
			_autoLoad=bol;
		}
		 /** Whether automatically loading assets */
		public function get autoLoad():Boolean {
			return _autoLoad;
		}

        /** the index of assets list*/
		public function get index():uint {
			return _index;
		}
        /** Whether ignore the errors occured in loading progress*/
		public function set ignoreError(bol:Boolean):void {
			_ignoreError=bol;
		}
		/** Whether ignore the errors occured in loading progress*/
		public function get ignoreError():Boolean {
			return _ignoreError;
		}
        /** The lenght of assets list*/
		public function get length():uint {
			return _loadList.length;
		}
        /** The status of easyloader object*/
		public function get loadStatus():String {
			return _loaderStatus;
		}
		
        /**
         * add custom filename extension to easyLoader Object,so as to loading all kinds of assets.
         * @param	$type there are 5 classic file type that can be loaded by swf:text,video,sound,image,bytes
         * @param	$name  the name of filename extension.
         * @return   If success return true or else return false
		 * @example such as:
		 * <listing version="3.0">
		 * _assetsManager.addType("text",".txt2");//add a custom filename extension.
			_assetsManager.addType("text",".tdb");//add a custom filename extension.
		 * </listing>
         */
		public function addType($type:String,$name:String):Boolean {
			if ($name.charAt(0)!='.') {
				return false;
			} else {
				for (var i:Object in _typeList) {
					if (_typeList[i]['name']==$type) {

						_typeList[i]['list']+=$name;
						return true;
					}
				}
				return false;
			}
		}
		/**
		 * load assets according to the config file.the config file is a xml.
		 * @example such as:
		 * <listing version="3.0">

			&lt;?xml version=&quot;1.0&quot; encoding=&quot;utf-8&quot; ?&gt; 
				&lt;data&gt; 
				&lt;item alias=&quot;mymp3&quot;&gt;&lt;![CDATA[assets/sound/ssadness_and_sorrow.mp3]]&gt;&lt;/item&gt; 
				&lt;item alias=&quot;myswf&quot;&gt;&lt;![CDATA[assets/swf/imswf.swf]]&gt;&lt;/item&gt; 
				&lt;item alias=&quot;artical&quot; method=&quot;text&quot;&gt;&lt;![CDATA[assets/txt/aritcal.txt2]]&gt;&lt;/item&gt; 
				&lt;item alias=&quot;userInfo&quot; method=&quot;variables&quot;&gt;&lt;![CDATA[assets/txt/value.tdb]]&gt;&lt;/item&gt; 
				&lt;item alias=&quot;ckfree&quot; info=&quot;this is a video about clothes&quot;&gt;&lt;![CDATA[assets/video/ckfree.f4v]]&gt;&lt;/item&gt; 
				&lt;item alias=&quot;adobe_rss&quot;&gt;&lt;![CDATA[assets/xml/adobe_rss.xml]]&gt;&lt;/item&gt; 
				&lt;item alias=&quot;tower&quot; autoRemove=&quot;false&quot;&gt;&lt;![CDATA[assets/dae/models/model.dae]]&gt;&lt;/item&gt; 
			&lt;/data&gt; 


			</listing>
		  
		 * @param	str  The path of config file.
		 */
		public function loadConfig(str:String):void {
			loadCofingXML(str);
		}
		
		/**
		 * Pauses the loading progress
		 */
		public function pause():void {
			_loaderStatus=LOADING_PAUSE;
			var event:EasyLoaderEvent=new EasyLoaderEvent(EasyLoaderEvent.PAUSE);
			dispatchEvent(event);
		}
		/**
		 * Resume the loading progress 
		 */
		public function unPause():void {
			if (_loaderStatus==LOADING_PAUSE) {
				_loaderStatus=LOADING_PROGRESS;
				itemLoad();
			}
		}
        /**
         * Start loading progress
         */
		public function start():void {
	
			if (_loaderStatus!=LOADING_PROGRESS) {
				_loaderStatus=LOADING_PROGRESS;
					 
				initLoadItems();
				itemLoad();
					
				
					 	
					 
				
			}
		}
		
		

		private function initLoadItems() :void{

            if(_xml!=null){
				var len:uint=_xml.child("*").length();
				for (var i:uint=0; i<len; i++) {
					//var fpath:String = (useRootPath == true)?rootPath + _xml.child(i).toString():_xml.child(i).toString();
					var fpath:String = rootPath + _xml.child(i).toString();
					
					var fname:String=getName(fpath);
					var ftype:String=getType(fpath);
					var falias:String=String(_xml.child(i).@alias);
					var finfo:String=String(_xml.child(i).@info);
					var fautoRemove:Boolean=_xml.child(i).@autoRemove=="true"?true:false;
					var fmethod:String =String( _xml.child(i).@method);
				 
				 
					var item:LoadItem=new LoadItem(null,fname,i,fpath,falias,ftype,finfo,fautoRemove,fmethod);
					item.setBytesLoaded(0);
					item.setBytesTotal(0);
					_loadList.push(item);
				}//end for
				
				if(!autoGetSize)
					_filesBytesTotal = (_xml.@total == null  || _xml.@total == "")?0:Number(_xml.@total);
				else
					 caculateSize();

				_xml = null
			}
			
		
		}
        
		/**
		 * add a file to assets queue
		 * @param	path the path of file
		 * @param	alias the alias of file
		 * @param	info  extra information of the file
		 * @param	autoRemove Whether automatically remove this file from memory
		 * @param	method the method that easyloader used to loading the file
		 */
		public function addFile(path:String,alias:String="",info:String="",autoRemove:Boolean=false,method:String="text",useRootPath:Boolean=true):void {

			var fname:String=getName(path);
			var ftype:String = getType(path);
			if (useRootPath == true) {
				path = rootPath + path;
			}
			var Item:LoadItem=new LoadItem(null,fname,_loadList.length,path,alias,ftype,info,autoRemove,method);
			_loadList.push(Item);
		}

		/**
		 * remove a file from easyLoader Object according to alias, when it hasn't finished loading.
		 * @param	alias the alias of the target file.
		 * @return true or false
		 */
		public function removeFileByAlias(alias:String):Boolean {
			var len:uint=_loadList.length;
			for (var i:int=0; i<len; i++) {
				if (_loadList[i].alias==alias) {
					if (_loadList[i].status == ITEM_STATUS_READY) {
						_loadList[i].dispose()
					    _loadList[i]=null
						return true;
					}

					break;
				}
			}
			return false;
		}
		/**
		 * remove a file from easyLoader Object according to filename, when it hasn't finished loading.
		 * @param name the filename of the target file.
		 * @return true or false
		 */
		public function removeFileByName(name:String):Boolean {
			var len:uint=_loadList.length;
			for (var i:int=0; i<len; i++) {
				if (_loadList[i].fileName==name) {
					if (_loadList[i].status == ITEM_STATUS_READY) {
						_loadList[i].dispose()
					    _loadList[i]=null
						return true;
					}

					break;
				}
			}
			return false;
		}
        
		/**
		 * Dispose the instance of easyLoader.It can save more memory.if a easyLoader Object do not need again, dispose it.
		 */
		public function dispose():void {
			EasyLoader.deRegister(this.id);
			var $loadlistLenth:uint=_loadList.length;
			pause();
			for (var i:int=0; i<$loadlistLenth; i++) {

				_loadList[i].dispose();
				_loadList[i]=null;
			}
			try {
				_urlLoader.close();
			} catch (e:Error) {

			}

			_urlLoader.addEventListener(Event.COMPLETE,configLoaded);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR,configErrorHandler);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,configErrorHandler);
			_urlLoader.addEventListener(ProgressEvent.PROGRESS,configLoading);
			_xml=null;
			_loadList=null;
			while (_typeList.length>0) {
				_typeList[0]=null;
				_typeList.splice(0,1);
			}



		}
        
		/**
		 * Dispose a file according to its filename. If a file do not need again,it can be dispose,so as to save more memory.
		 * @param	name the filename of the target file.
		 * @return  true or false
		 */
		public function disposeFileByName(name:String):Boolean {
			var length:int=_loadList.length;
			for (var i:int=0; i<length; i++) {

				if (_loadList[i]["fileName"]==name) {

					_loadList[i].dispose();
					_loadList[i]=null;
					return true;
					break;
				}
			}
			return false;
		}
		
		/**
		 * Dispose a file according to its alias. If a file do not need again,it can be dispose,so as to save more memory.
		 * @param	alias the alias of the target file.
		 * @return  true or false
		 */
		public function disposeFileByAlias(alias:String):Boolean {
			var length:int=_loadList.length;
			for (var i:int=0; i<length; i++) {
				if (_loadList[i]["alias"]==alias) {

					_loadList[i].dispose();
					_loadList[i]=null;
					return true;
					break;
				}
			}
			return false;
		}
        
		/**
		 * Dispose a file according to its alias. If a file do not need again,it can be dispose,so as to save more memory.
		 * @param  number the index of the target file in assets quene.
		 * @return  true or false
		 */
		public function disposeFileByIndex(number:uint):Boolean {
			_loadList[number].dispose();
			_loadList[number]=null;
			return true; 
		}
		
		/**
		 * Get a file from assets accoring to filename
		 * @param	name filename of the target file
		 * @return  a LoadItem Object 
		 * 
		 * @see filename
		 */
		public function getFileByName(name:String):LoadItem {
			var length:int=_loadList.length;
			for (var i:int=0; i<length; i++) {

				if (_loadList[i]["fileName"]==name) {

					return _loadList[i];
					break;
				}
			}
			return null  ;
		}
		
		/**
		 * Get a file from assets accoring to alias
		 * @param	alias alias of the target file
		 * @return  a LoadItem Object 
		 * 
		 * @see alias
		 */
		public function getFileByAlias(alias:String):LoadItem {
			var length:int=_loadList.length;
			for (var i:int=0; i<length; i++) {

				if (_loadList[i]["alias"]==alias) {

					return _loadList[i];
					break;
				}
			}
			return null  ;
		}
        
		/**
		 * Get a file from assets accoring to index
		 * @param	number index of the target file in assets quene
		 * @return  a LoadItem Object 
		 * @see LoadItem index
		 */
		public function getFileByIndex(number:uint):LoadItem {
			return _loadList[number];
		}
		/**
		 * return the total bytes of all  files.it come from config xml.
		 * @example
		 * <listing version="3.0">
		 * <data total='8888'>
		 * 	<item>example.jpg</item>
		 * 	<item>example.swf</item>
		 * 	<item>example.mp3</item>
		 * </data>
		 * </listing>
		 */
		public function get filesBytesTotal():Number {
		 
			return  _filesBytesTotal;
		}
		
		/**
		 * return the loaded  bytes of all files.
		 */
		public function get filesBytesLoaded():Number {
			if (_loadList == null || _loadList.length <= 0) return 0 
	 
			if( _loadList[index].status==EasyLoader.ITEM_STATUS_PROGRESS){
				return _filesBytesLoaded + _loadList[index].bytesLoaded;
			}else if( _loadList[index].status==EasyLoader.ITEM_STATUS_COMPLETED) {
				return _filesBytesLoaded ;
			}else {
				return _filesBytesLoaded ;
			}
			 
			
		}
		
		

		//maybe no one need this function,so i drop it.if some body want it indeed,please connect me.
		//这个功能不打算完成了，因为我发现可能没人需要它；但是如果有朋友需要，我会将它在下一版本中完成。可以随时联系我。
		/*public function reTryErrorAssets() {
		
		}*/
		/*****************public function  end***********************************/
        
		private function loadCofingXML(path:String):void {
			_loaderStatus=LOADING_INITING;
			if (_urlLoader==null) {
				_urlLoader=new URLLoader  ;
			} else {
				try {
					_urlLoader.close();
				} catch (e:Error) {
				}
			}
			_urlLoader.addEventListener(Event.COMPLETE,configLoaded);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR,configErrorHandler);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,configErrorHandler);
			_urlLoader.addEventListener(ProgressEvent.PROGRESS,configLoading);
			_urlLoader.load(new URLRequest(path));
		}
		private function reset():void {
			_xml=new XML  ;
			_xml.ignoreWhitespace=true;
			if (_urlLoader==null) {
				_urlLoader=new URLLoader  ;
			} else {
				try {
					_urlLoader.close();
				} catch (e:Error) {

				}
			}
			_bytesLoaded=0;
			_bytesTotal=int.MAX_VALUE;
			_loadList = new Vector.<LoadItem>();
			rootPath = "";
			_autoLoad=true;
			_ignoreError=true;
			_loaderStatus = FREE;
			_filesBytesLoaded = 0;
			_filesBytesTotal = int.MAX_VALUE;
			_index = -1;
			
		}


		private function configLoading(e:ProgressEvent):void {
			_bytesTotal=e.bytesTotal;
			_bytesLoaded=e.bytesLoaded;
			dispatchEvent(e);
		}
		private function configLoaded(e:Event=null):void {
		
	
			if (e!=null) {
				_xml=new XML(_urlLoader.data);
			}
		 
			_filesBytesLoaded = 0;
			_filesBytesTotal = int.MAX_VALUE;
			_index ++;
			
			
			_urlLoader.removeEventListener(Event.COMPLETE,configLoaded);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,configErrorHandler);
			_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,configErrorHandler);
			_urlLoader.removeEventListener(ProgressEvent.PROGRESS, configLoading);
		
			_loaderStatus=LOADING_CONFIG_INITED;
			var event:EasyLoaderEvent=new EasyLoaderEvent(EasyLoaderEvent.CONFIG_INITED,true);
			dispatchEvent(event);
			if (_autoLoad==true) {
				start();
			}
		}
		private function configErrorHandler(e:Event):void {
			_loaderStatus=LOADING_ERROR;
			_urlLoader.removeEventListener(Event.COMPLETE,configLoaded);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,configErrorHandler);
			_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,configErrorHandler);
			_urlLoader.removeEventListener(ProgressEvent.PROGRESS,configLoading);
			dispatchEvent(new EasyLoaderEvent(EasyLoaderEvent.CONFIG_INIT_ERROR,true));
		}
		private function initType():void {
			_typeList=[];
			_typeList.push({name:"text",list:".xml.txt.css.dae"});
			_typeList.push({name:"video",list:".flv.mov.mp4.f4v"});
			_typeList.push({name:"sound",list:".mp3.wav"});
			_typeList.push({name:"image",list:".jpg.gif.png.swf"});
			_typeList.push({name:"bytes",list:".pat.dat"});
		}

		private function itemLoad():void {
			_loaderStatus=LOADING_PROGRESS;
			if(_index<0) _index=0;
			var typeName:String=_loadList[_index].type;
			_loadList[_index].setStatus(ITEM_STATUS_READY);
			 
			var type:String;
			for (var i:Object in _typeList) {

				if (_typeList[i]['list'].indexOf(typeName)>=0) {
					type=_typeList[i]['name'];
					break;
				}
			}
			if (_loadList[_index].method==LOADING_METHOD_BYTES) {
				textLoad(URLLoaderDataFormat.BINARY,typeName);
			} else {
				
				if (type=="image") {
					imageLoad(typeName);
				} else if (type == "sound") {
					
					soundLoad(typeName);
				} else if (type=="video") {
					videoLoad(typeName);
				} else if (type=="text") {
					if (_loadList[_index].method==LOADING_METHOD_VARIABLES) {
						textLoad(URLLoaderDataFormat.VARIABLES,typeName);
					} else {
						textLoad(URLLoaderDataFormat.TEXT,typeName);
					}
				} else if (type=="bytes") {
					textLoad(URLLoaderDataFormat.BINARY,typeName);
				}else {
					loadByMethod(_loadList[_index].method);
				}
				
			

			}
			
			
			
			function loadByMethod(t:String):void {
			
				if (t=="image") {
					imageLoad(".jpg");
				} else if (t == "sound") {
					soundLoad(".mp3");
				} else if (t=="video") {
					videoLoad(".f4v");
				} else if (t=="text") {
					textLoad(URLLoaderDataFormat.TEXT,".txt");
				} else if (t=="bytes") {
					textLoad(URLLoaderDataFormat.BINARY,".bat");
				}else if(t=="variables") {
					textLoad(URLLoaderDataFormat.VARIABLES,".txt");
				}
			}
			
			type=null;
		}
		private function getType(str:String):String {
			var $type:String = str
			var paramPos:int = str.indexOf("?");
			if (paramPos >= 0) {
				$type = $type.substring(0, paramPos);
				$type = $type.substring(0, paramPos);
			}
			
			$type=$type.substring($type.lastIndexOf('.'));
			return $type
		
		}
		private function getName(str:String):String {
			var $name:String =str.substring(str.lastIndexOf('/')+1);
			var paramPos:int = $name.indexOf("?");
			if (paramPos >= 0) {
				$name = $name.substring(0, paramPos);
			}
			
			return $name
		}
		private function itemLoaded():void {
		
			_filesBytesLoaded = _filesBytesLoaded + _loadList[_index].bytesTotal;
		 
			var event:EasyLoaderEvent=new EasyLoaderEvent(EasyLoaderEvent.ITEM_COMPLETED,{id:_index,target:_loadList[_index]});
			dispatchEvent(event);
		
			if (_index<_loadList.length-1) {
				_index++;
				
				itemLoad();
			} else {
			
				allLoaded();
			}

		}
		private function itemLoadError(e:Event=null):void {
			
			_loaderStatus=LOADING_ERROR;
			var event:EasyLoaderEvent=new EasyLoaderEvent(EasyLoaderEvent.LOADING_ERROR);
			event.data={index:_index,file:_loadList[_index],info:e};
			dispatchEvent(event);
				 
			if (_ignoreError==true &&_index<_loadList.length-1) {
			
				_index++;
				itemLoad();
			} else {
				pause();
			}
		}


		private function imageLoad(typeName:String):void {
			var loader:Loader=new Loader  ;
			loader.contentLoaderInfo.addEventListener(Event.INIT,imageLoaded);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,imageLoadError);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,imageLoading);
			addEventListener(EasyLoaderEvent.PAUSE, imagePuaseHandler);
			
			
			if (EasyLoader.isLocal==true)
			{
				loader.load(new URLRequest(_loadList[_index].path),new LoaderContext(true,ApplicationDomain.currentDomain));
			}else {
				loader.load(new URLRequest(_loadList[_index].path),new LoaderContext(true,ApplicationDomain.currentDomain,SecurityDomain.currentDomain));
				
			}
			_loadList[_index].setStatus(ITEM_STATUS_PROGRESS);
			function imageLoaded(e:Event):void {
				_loadList[_index].setContent(loader.content);
				_loadList[_index].setStatus(ITEM_STATUS_COMPLETED);
				imageRemove(_loadList[_index].autoRemove);
				
				itemLoaded();
			}

			function imageLoadError(e:IOErrorEvent):void {
				_loadList[_index].setStatus(ITEM_STATUS_FAULT);
				imageRemove(true);
				 
				itemLoadError(e);
			}

			function imageLoading(e:ProgressEvent):void {
				_loadList[_index].setBytesLoaded(e.bytesLoaded);
				_loadList[_index].setBytesTotal(e.bytesTotal);
				
				var event:EasyLoaderEvent=new EasyLoaderEvent(EasyLoaderEvent.PROGRESS);
				dispatchEvent(event);
			}
			function imageRemove(bol:Boolean):void {
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,imageLoaded);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,imageLoadError);
				loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,imageLoading);
				removeEventListener(EasyLoaderEvent.PAUSE,imagePuaseHandler);
				if (bol) {
					try {
						loader.close();
					} catch (e:Error) {

					}

					loader.unload();
					loader=null;
				}
			}

			function imagePuaseHandler():void {
				imageRemove(true);
			}
		}


		private function textLoad(dataFormat:String,typeName:String):void {
			var textLoader:URLLoader=new URLLoader  ;
			textLoader.dataFormat=dataFormat;
			 
			textLoader.addEventListener(Event.COMPLETE,textLoaded);
			textLoader.addEventListener(ProgressEvent.PROGRESS,textLoading);
			textLoader.addEventListener(IOErrorEvent.IO_ERROR,textLoadError);
			addEventListener(EasyLoaderEvent.PAUSE,textPuaseHandler);
			textLoader.load(new URLRequest(_loadList[_index].path));

			_loadList[_index].setStatus(ITEM_STATUS_PROGRESS);
			function textLoaded(e:Event):void {

				var $content:Object;
				
			
				if (typeName==".xml"||_loadList[_index].method==LOADING_METHOD_XML) {
					$content=new XML(e.target.data);
					$content.ignoreWhitespace=true;

				} else if (_loadList[_index].method=="variables") {
				 
					$content=new URLVariables(e.target.data);
				} else {
				 
					$content=e.target.data;
				}

				_loadList[_index].setStatus(ITEM_STATUS_COMPLETED);
				_loadList[_index].setContent($content);
				textRemove(_loadList[_index].autoRemove);

				itemLoaded();
			}
			function textLoading(e:ProgressEvent):void {

				_loadList[_index].setBytesLoaded(e.bytesLoaded);
				_loadList[_index].setBytesTotal(e.bytesTotal);
				var event:EasyLoaderEvent=new EasyLoaderEvent(EasyLoaderEvent.PROGRESS);
				dispatchEvent(event);
			}

			function textLoadError(e:IOErrorEvent):void {

				_loadList[_index].setStatus(ITEM_STATUS_FAULT);
				textRemove(true);
				itemLoadError(e);
			}

			function textRemove(bol:Boolean=false):void {
				textLoader.removeEventListener(Event.COMPLETE,textLoaded);
				textLoader.removeEventListener(ProgressEvent.PROGRESS,textLoading);
				removeEventListener(EasyLoaderEvent.PAUSE,textPuaseHandler);
				if (bol) {
					try {
						textLoader.close();
					} catch (e:Error) {

					}
					textLoader=null;
				}
			}

			function textPuaseHandler():void {
				textRemove(true);
			}
		}

		private function videoLoad(typeName:String):void {

			var netConn:NetConnection=new NetConnection  ;
			netConn.connect(null);
			var netStream:NetStream=new NetStream(netConn);
			netStream.addEventListener(NetStatusEvent.NET_STATUS,videoLoadStatus);
			addEventListener(EasyLoaderEvent.PAUSE,videoPuaseHandler);
			var client:Object = { } ;
			client.onMetaData = function(obj:Object):void {
				if (_loadList[_index].data == null) {
					_loadList[_index].data={}
				}
				_loadList[_index].data.width = obj.width;
				_loadList[_index].data.height = obj.height;
				_loadList[_index].data.duration = obj.duration;
				
			}
			netStream.client=client;
			var path:String=_loadList[_index].path;
			netStream.play(path);
			netStream.pause();
			_loadList[_index].setStatus(ITEM_STATUS_PROGRESS);
			var timer:Timer=new Timer(50,int.MAX_VALUE);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER,timerHandler);
			function videoLoaded():void {
				
				_loadList[_index].setContent(netStream);
				_loadList[_index].setStatus(ITEM_STATUS_COMPLETED);
				videoRemove(_loadList[_index].autoRemove);
				itemLoaded();
				
			}
			function timerHandler(e:TimerEvent):void {
				_loadList[_index].setBytesLoaded(netStream.bytesLoaded);
				_loadList[_index].setBytesTotal(netStream.bytesTotal);
				var event:EasyLoaderEvent=new EasyLoaderEvent(EasyLoaderEvent.PROGRESS);
				dispatchEvent(event);
				if (netStream.bytesLoaded==netStream.bytesTotal&&netStream.bytesTotal!=0) {
					videoLoaded();
				}
			}
			function videoLoadStatus(e:NetStatusEvent):void {

				if (e.info.code=="NetStream.Publish.BadName"||e.info.code=="NetStream.Play.StreamNotFound"||e.info.code=="NetStream.Play.Failed"||e.info.code=="NetStream.Play.NoSupportedTrackFound"||e.info.code=="NetStream.Play.FileStructureInvalid") {
					videoLoadError(e);
				}
			}

			function videoLoadError(e:Event):void {

				_loadList[_index].setStatus(ITEM_STATUS_FAULT);
				videoRemove(true);
				itemLoadError(e);
			}

			function videoPuaseHandler(e:Event):void {
				videoRemove(true);
			}

			function videoRemove(bol:Boolean=false):void {
				try {
					timer.stop();
					timer.removeEventListener(TimerEvent.TIMER,timerHandler);
					netStream.removeEventListener(NetStatusEvent.NET_STATUS,videoLoadStatus);
					if (bol) {
						try {
							netStream.close();
							netConn.close();
						} catch (e:Error) {

						}
						netStream=null;
						netConn=null;
					}
				} catch (e:Error) {

				}
			}
		}
		private function soundLoad(typeName:String):void {
			
			var sound:Sound=new Sound  ;
			sound.addEventListener(Event.COMPLETE,soundLoaded);
			sound.addEventListener(ProgressEvent.PROGRESS,soundLoading);
			sound.addEventListener(IOErrorEvent.IO_ERROR,soundLoadError);
			addEventListener(EasyLoaderEvent.PAUSE,soundPuaseHandler);
			sound.load(new URLRequest(_loadList[_index].path));
			_loadList[_index].setStatus(ITEM_STATUS_PROGRESS);
			function soundLoaded(e:Event):void {
				_loadList[_index].setStatus(ITEM_STATUS_COMPLETED);
				_loadList[_index].setContent(sound);
				soundRemove(_loadList[_index].autoRemove);
				itemLoaded();
			}

			function soundLoading(e:ProgressEvent):void {
				_loadList[_index].setBytesLoaded(e.bytesLoaded);
				_loadList[_index].setBytesTotal(e.bytesTotal);
				var event:EasyLoaderEvent=new EasyLoaderEvent(EasyLoaderEvent.PROGRESS);
				dispatchEvent(event);
			}
			function soundLoadError(e:IOErrorEvent):void {
				_loadList[_index].setStatus(ITEM_STATUS_FAULT);
				soundRemove(true);
				itemLoadError(e);
			}

			function soundRemove(bol:Boolean=false):void {
				sound.removeEventListener(Event.COMPLETE,soundLoaded);
				sound.removeEventListener(ProgressEvent.PROGRESS,soundLoading);
				sound.removeEventListener(IOErrorEvent.IO_ERROR,soundLoadError);
				removeEventListener(EasyLoaderEvent.PAUSE,soundPuaseHandler);
				if (bol) {
					try {
						sound.close();
					} catch (e:Error) {
					}
					sound=null;
				}
			}

			function soundPuaseHandler(e:Event):void {
				soundRemove(true);
			}
		}

		private function allLoaded():void {
		
			_loaderStatus=LOADING_COMPLETED;
			var event:EasyLoaderEvent=new EasyLoaderEvent(EasyLoaderEvent.COMPLETED);
			dispatchEvent(event);
			_loaderStatus = FREE;
			
			
		}
		
		// load twice and sent loaded event. maybe need change to other ways.
		private function caculateSize():void {
			var t:Number = getTimer();
			
				var loader:URLStream = new URLStream();
				 
				loader.addEventListener(ProgressEvent.PROGRESS,on_progress)
				var request:URLRequest = new URLRequest();
			
				var k:uint = _index;
				var size:Number = 0;
				 next();
			
				function on_progress(e:ProgressEvent):void {
					size += e.bytesTotal;
				
					loader.close();
					k++
					if (k >= _loadList.length) {
						_filesBytesTotal = size;
						
						loader.removeEventListener(ProgressEvent.PROGRESS, on_progress);
						loader = null;
						request = null;
						itemLoad();
						
						if (onGetSize != null) onGetSize();
				
					}
					else
						next();
				}
				
				function next() :void {
					
						
						
						request.url = _loadList[k].path;
					
						loader.load(request);
					
				}
				
				
		}
		
		
	}

}