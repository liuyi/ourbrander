package com.ourbrander.utils 
{
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import fl.motion.MatrixTransformer
	import flash.geom.Matrix
	import flash.display.DisplayObject
	import flash.text.TextFormat;
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

		public function utils() 
		{
			
		}
		public static function setText(target:TextField, str:String, htmlText:Boolean = true, autoSize:String = "default",x:Number=0,y:Number=0,embed:Object = null, css:Object = null, skewX:Number = 0,mousewheel:Boolean = false, antiAliasType:String = "advanced",condenseWhite:Boolean=false,sharpness:Number=10,thickness:Number=10) {
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
		
			
		
			if (skewX != 0) {
				target.x+=skewX*0.5
				skew(target,skewX)
			}
			
			function skew(target:DisplayObject,num:Number):void{
			var mtr:Matrix=target.transform.matrix
			
			MatrixTransformer.setSkewX(mtr,20)
			target.transform.matrix=mtr
			
			}
			
			
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
			}
			if (obj.text == null) {
				obj.text = content.text;
			}
			if (extra != null) { for (i in extra) { obj[i] = extra[i] }}
			
			
			if(obj.x!=null){target.x += Number(obj.x);}
			if(obj.y!=null){target.y += Number(obj.y);}
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
				
				
			if(obj.autoSize!="default" && obj.autoSize!=null){target.autoSize = String(obj.autoSize)}
			
			
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
		
			//target.height = target.textHeight;
			
			if (obj.skewX != null ) {
				obj.skewX=Number(obj.skewX)
				target.x+=obj.skewX*0.5
				skew(target,obj.skewX)
			}
			
			function skew(target:DisplayObject,num:Number):void{
			var mtr:Matrix=target.transform.matrix
			
			MatrixTransformer.setSkewX(mtr,20)
			target.transform.matrix=mtr
			
			}
		}
		
		public static function changeNodeToObj(node:XMLList):Object {
			
			var obj:Object = { };
			var xmllist:XMLList = node.@ * ;
			for (var i in xmllist) {
				obj[xmllist[i].name()] = xmllist[i];
			}
			obj.text = node.toString();
			return Object;
		}

		

		
	}

}