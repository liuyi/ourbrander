package com.ourbrander.utils 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.geom.Matrix;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getDefinitionByName;
	import flash.xml.XMLNode;

	/**
	 * ...
	 * @author liuyi
	 * update 2011/6/30
	 * fixed some bugs
	 * update 2011/2/18 setText API changed!!!,added setTextByObj();
	 */
	public class Utils extends Object
	{
		public static var EMBED_FONTS:Boolean = true;
		public static var CSS:StyleSheet

		public function Utils() 
		{
			
		}
		public static function setText(target:TextField, str:String, htmlText:Boolean = true, autoSize:String = "default",x:Number=0,y:Number=0,embed:Object = null, css:Object = null, skewX:Number = 0,mousewheel:Boolean = false, antiAliasType:String = "advanced",condenseWhite:Boolean=false,sharpness:Number=10,thickness:Number=10) :void{
		 	if(embed!=null){
				target.embedFonts = embed
			}else {
				target.embedFonts = Utils.EMBED_FONTS
			};
			
			target.x += x,
			target.y += y;
			
			if(target.embedFonts==true){
			target.antiAliasType  = "advanced";
			target.sharpness = sharpness;
			target.thickness = thickness;
			}
				
				
			if(autoSize=="default" || autoSize==""){}else{target.autoSize = autoSize}
			
		    target.condenseWhite = condenseWhite;
			
			 if (css != null) {
				 if (css is  StyleSheet) {
						target.styleSheet = css as StyleSheet;
				 }
			
			}else{
				if(CSS!=null){
					target.styleSheet = CSS;
					
					/**
					 * parse extend css style
					 */
					
				}
			} 
				
			if (mousewheel == false) {
				target.mouseWheelEnabled=false
			}else {
				target.mouseWheelEnabled=true
			}
		
		    if(htmlText==true){
				target.htmlText = str;
			}else {
				target.text = str;
				
			}
		
			
		
			//if (skewX != 0) {
				//target.x+=skewX*0.5
			//	skew(target,skewX)
			//}
			
			//function skew(target:DisplayObject,num:Number):void{
			//var mtr:Matrix=target.transform.matrix
			
		//	MatrixTransformer.setSkewX(mtr,20)
			//target.transform.matrix=mtr
			
			//}
			
			
		}//end function
		
		
		public static function setTextByObj(target:TextField, content:Object, extra:Object = null) :void {
			var obj:Object = { }
			
			if (content is XMLList ||content is XML) {
				var text:String = content.toString();
				content = content.@ * ;
				for (var i:* in content) {
					obj[String(content[i].name())] = content[i];
				}
				obj.text = text;
			}else if(content is String) {
				obj.text=content
			}else{
				obj = content;
			}
		
			if (obj.text == null) {
				obj.text = content.text;
			}
			if (extra != null) { for (i in extra) { obj[i] = extra[i] }}
			
			if(obj.replace!=null){
			
				for (var p:String in obj.replace){
				 
					obj.text=obj.text.replace(new RegExp("\\${"+p+"}","g"),obj.replace[p]);
				}
			}
			
			if(obj.x!=null){target.x += Number(obj.x);}
			if (obj.y != null) { target.y += Number(obj.y); }
			if (obj.style != null) { obj.text = '<span class="' + obj.style + '">' + obj.text + '</span>'; }
		
			if (obj.embed != null) {
				if (String(obj.embed).toLowerCase()=="false") {
					obj.embed = false;
				}else {
					obj.embed = true;
				}
				
				target.embedFonts = obj.embed
			}else {
				target.embedFonts = Utils.EMBED_FONTS
			};
		 
			if(target.embedFonts!=false && String(obj.antiAliasType).toLowerCase()!="normal"){
				target.antiAliasType  = "advanced";
				if(obj.sharpness!=null){target.sharpness = Number(obj.sharpness);}
				if(obj.thickness!=null){target.thickness = Number(obj.thickness);}
			}
				
				
			
		
			
			if (String(obj.condenseWhite).toLowerCase()=="true") {
				obj.condenseWhite = true;
			}else {
				obj.condenseWhite = false;
			}
				
			target.condenseWhite = obj.condenseWhite;
		
			if (String(obj.useCss).toLowerCase() != "false" ) {
				if (obj.css != null) {
					 if (obj.css is  StyleSheet) {target.styleSheet = obj.css as StyleSheet; }
				} 
				else {
					if(CSS!=null){target.styleSheet = CSS;}
				} 
			
			}else{
				var textFormat:TextFormat = new TextFormat();
				 
				if(obj.size!=null) textFormat.size = uint(obj.size);
				if(obj.color!=null) textFormat.color = obj.color;
				if(obj.font!=null) textFormat.font = obj.font;
				if (obj.leading != null) textFormat.leading = Number(obj.leading);
				if(obj.bold!=null) textFormat.bold = obj.bold;
				if(obj.align!=null) textFormat.align = obj.align;
				if(obj.italic!=null) textFormat.italic = obj.italic;
				if(obj.letterSpacing !=null) textFormat.letterSpacing  = obj.letterSpacing ;
				target.defaultTextFormat = textFormat;
			}
				
			if (String(obj.mousewheel).toLowerCase() == "true") {
				obj.mousewheel=true
				target.mouseWheelEnabled=true
			}else {
				obj.mousewheel=false
				target.mouseWheelEnabled=false
			}
			//if(obj.text==null || obj.text==undefined){obj.text=""}
		    if(obj.htmlText!=false && String(obj.useCss).toLowerCase() != "false" ){
				target.htmlText = obj.text;
			}else {
				target.text = obj.text;
			}
		
			
			if(obj.autoSize!="default" && obj.autoSize!=null){target.autoSize = String(obj.autoSize)}
			 
		}
		
		public static function changeNodeToObj(node:XMLList):Object {
			
			var obj:Object = { };
			var xmllist:XMLList = node.@ * ;
			for (var i:* in xmllist) {
				obj[xmllist[i].name()] = xmllist[i];
			}
			obj.text = node.toString();
			return Object;
		}
		/**
		 * remove all the space before or at the end of string. like php.
		 * @param	str:String 
		 * @return String
		 */
	 public static function  trim($string:String):String {
		if ($string == null) return "";
		return $string.replace(/^\s+|\s+$/g, "");
	}
	
	
	public static function getObj(name:String):Object {
		if (getDefinitionByName(name) == null) return null;
		var cls:Class = getDefinitionByName(name) as Class;
		var obj:Object = new cls() as Object;
		return obj;
	}	
		
	/**
	 * Display number like this,888,888,888,888
	 * @param	n
	 * @return
	 */
	public static function formatNumber(n:Number):String
	{
			var s:String = "";
			var num:String = String(n);
			 
			while( num.length>0)
			{
				
				s = num.substr(-3)+","+s;
				num=num.replace(num.substr(-3),"")
			}
			s = s.substr(0,s.length-1);
			return s;
	}
	
	/**
	 * display like this:hh:mm:ss
	 * @param	t
	 * @return
	 */
	public static function formatTime(t:Number):String {
			
			var s:int = int(t% 60);
			var str:String =(s<10)?"0"+s:String(s);
		
			var h:int=Math.floor(t / 3600)
			var m1:Number =Math.floor(t / 60);
			if(m1>=60) m1= m1%60;
			var m:String=(m1<10)?"0"+m1:m1+"";
			
			return h+":"+m+":"+str;
		
	}
		

	/*获取字符串的半角长度
	* */
	public static function getCharLen(str:String):int{
		var len:int=0;
		var key:int;
		for(var i:int=0;i<str.length;i++){
			
			if(str.charCodeAt(i)>0x4e00) len+=2;//中文开始：0x400-0x9FA5
			else len++
		}
		
		
		return len;
	}
	
	/*Get a file name from a url*/
	public static function getFileName( str:String,ignoreSuffix:Boolean=false):String {
		var $name:String =str.substring(str.lastIndexOf('/')+1);
		var paramPos:int = $name.indexOf("?");
		if (paramPos >= 0) {
			$name = $name.substring(0, paramPos);
		}
		
		if(ignoreSuffix==false ) return $name;
		
		paramPos=$name.lastIndexOf(".");
		$name=$name.substring(0,paramPos);
		return $name
	}
	
	/**
	 * @desc register class before clone it:registerClassAlias
	 */
	public static function cloneObj(sourceObj:Object):Object{
		var bt:ByteArray = new ByteArray();
		bt.writeObject(sourceObj);
		bt.position = 0;
		
		var obj:Object=bt.readObject();
		return obj;
	}
	/**
	 * @desc convert string like  String "902b3c"  to bytes [90,2b,3c]
	 */
	public static  function convertStrToBytes(str:String):ByteArray{
		var bytes:ByteArray=new ByteArray();
		
		var len:int=str.length;
		var byteStr:String
		for(var i:int=0;i<len;i+=2){
			//byteStr="0x"+str.substr(i,2);
			var pint:int=parseInt(str.substr(i,2),16)
			bytes.writeByte(pint);
			
		}
		bytes.endian=Endian.LITTLE_ENDIAN
		bytes.position=0
		return  bytes;
		
		
	}
	
	/**
	 * @desc convert string like bytes [90,2b,3c] to  String "902b3c" 
	 */
	public static  function convertByteToString(bytes:ByteArray,endian:String="littleEndian",splite:String=""):String{
		var result:String="";
		var array:Array=[]
		var i:int;
		var len:int=0;
		bytes.endian=endian;
		bytes.position=0;
		while(bytes.bytesAvailable>0){
			var str:String=bytes.readUnsignedByte().toString(16);
			if(str.length==1){
				str="0"+str;
			}
			array[len++]=str;
			
		}
		result=array.join(splite);
		return result;
	}
	
	
	
	public static function setChildMouseChild(target:DisplayObjectContainer,val:Boolean):void{
		var len:int=target.numChildren;
		var mc:DisplayObjectContainer;
		for(var i:int=0;i<len;i++){
			mc=target.getChildAt(i) as DisplayObjectContainer;
			if(mc!=null){
				mc.mouseChildren=val;
			}
		}
	}
	
	
	public static function isItem(parentTarget:DisplayObject,child:DisplayObject):Boolean{
		var p:DisplayObjectContainer;
		if(child==null || parentTarget==null) return false;
		while(child!=null ){
			if(child==parentTarget){
				return true
			}else{
				child=child.parent
			}
		}
		
		return false
	}
	
	 
		
	}

}