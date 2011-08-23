package com.ourbrander.loader{
	/**
	 * every loaded file will be stored this object,easyLoader.getFileByName() and easyLoader.getFileByAlias() can return a LoadItem object 
	 * @author  liuyi
	 */

	dynamic public class LoadItem{
		private var _fileName:String;
		private var _alias:String;
		private var _content:*;
		private var _autoRemove:Boolean;
		private var _info:String;
		private var _method:String;
		private var _path:String;
		private var _type:String;
		private var _id:uint;
		private var _data:Object;
		private var _bytesLoaded:Number;//size of loaded content
		private var _bytestTotal:Number;//size of content
		private var _status:String;//the status of this item's content.if loaded or load FAULT and just ready. four vaule:loading,loaded,FAULT,ready. 
		private var _loader
		
		/**
		 * Create a new LoadItem Object.Generally,user don't need create LoadItem object for easyLoader.it will create LoadItem Object from config file or the function "addFile()"
		 * @param	$content The loaded object associated with this LoadItem object.
		 * @param	$filename The name of the LoadItem object.
		 * @param	$id The index of the LoadItem object in loading quene.
		 * @param	$path The load path of content. 
		 * @param	$alias The alias of LoadItem object.
		 * @param	$type The filetype of LoadItem object.
		 * @param	$info The extra infomation of LoadItem object.
		 * @param	$autoRemove Whether automatically remove this file from memory 
		 * @param	$method How to load the content of LoadItem object
		 * @see EasyLoader#addFile()
		 */
		public function LoadItem($content:*=null,$filename:String="",$id:uint=0,$path:String="",$alias:String="",$type:String="",$info:String="",$autoRemove:Boolean=false,$method:String="text") {
			_content=$content;
			_fileName=$filename;
			_id=$id;
			_path=$path;
			_alias=$alias;
			_type=$type;
			_info=$info;
			_autoRemove=$autoRemove;
			_method=$method;

		}
		/** @private */
		internal function setFileName(str:String):void {
			_fileName=str;
		}
		/** @private */
		internal function setAlias(str:String):void {
			_alias=str;
		}
		/** @private */
		internal function setContent(target:*):void {
			_content=target;
		}
		/** @private */
		internal function setAutoRemove(bol:Boolean):void {
			_autoRemove=bol;
		}
		/** @private */
		internal function setInfo(str:String):void {
			_info=str;
		}
		/** @private */
		internal function setMethod(str:String):void {
			_method=str;
		}
		/** @private */
		internal function setPath(str:String):void {
			_path=str;
		}
		/** @private */
		internal function setType(str:String):void {
			_type=str;
		}
		/** @private */
		internal function setId(i:uint):void {
			_id=i;
		}
		/** @private */
		internal function setStatus(str:String):void {
			_status=str;
		}
		/** @private */
		internal function setBytesLoaded(num:Number):void {
			_bytesLoaded=num;
		}
		/** @private */
		internal function setBytesTotal(num:Number):void {
			_bytestTotal=num;
		}

        /** The filename of LoadItem object */
		public function get fileName():String {
			return _fileName;
		}
		/** The alias of LoadItem object */
		public function get alias():String {
			return _alias;
		}
		/** The loaded object  associated with this LoadItem object */
		public function get content():* {
			return _content;
		}
		/** TWhether automatically remove this file from memory*/
		public function get autoRemove():Boolean {
			return _autoRemove;
		}
		/** The extra infomation of LoadItem object */
		public function get info():String {
			return _info;
		}
		
		/** The method of  loading the content of LoadItem object */
		public function get method():String {
			return _method;
		}
		/** The load path of the loaded object  associated with this LoadItem object */
		public function get path():String {
			return _path;
		}
		/** The  filename extension of the loaded object*/
		public function get  type():String {
			return _type;
		}
		/** The index  of this LoadItem object in loading quene.*/
		public function get id():uint {
			return _id;
		}
        /** The extra data  of this LoadItem object.*/
		public function set data(obj:Object):void {
			_data=obj;
		}
		/** The extra data  of this LoadItem object.*/
		public function get data():Object {
			return _data;
		}

		/** The number of bytes that are loaded for the loading object of this LoadItem object.*/
		public function get bytesLoaded():Number {
			return _bytesLoaded;
		}
		/** The number of bytes in this LoadItem object.*/
		public function get bytesTotal():Number {
			return _bytestTotal;
		}
		/** The status of this LoadItem object.*/
		public function get status():String {
			return _status;
		}


		/** Dispose  this LoadItem object.*/
		public function dispose():void {
			_content = null;
			_data=null
		}

	}

}