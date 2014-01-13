package com.ourbrander.utils 
{
	import com.ourbrander.debugKit.itrace;
	/**
	 * ...
	 * @author liuyi  email:luckliuyi@163.com, blog:http://www.ourbrander.com; 
	 * 
	 * update:2010-12-8 修改了一个直线垂直无斜率时候的BUG
	 */
	
	public class MathTool
	{
		
		public function MathTool() 
		{
			
		}
		
		//获取两条直线或选段的相交点，如果没有相交则返回null，有相交的话则返回[x,y]的数组。参数line为2的话，则验证的是两条直线。
		//line=1,一条是直线一条是线段的,默认前面的x1,y1,x2,y2属于线段上的点。line=0都是线段
		public static function getLineIntersection (x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, x4:Number, y4:Number, line:uint=0):Array {
			var intersected:Boolean=false
			var k1:Number, b1:Number, k2:Number, b2:Number;
			 
			b1 = (y2 * x1 - y1 * x2) / (x1 - x2);
			k1 = (y1 - b1) / x1;
			
			b2 = (y4 * x3 - y3 * x4) / (x3 - x4);
			k2 = (y3 - b2) / x3;
			
			var ny:Number,nx:Number  
			
			//trace(k1,k2)
			if (k1==k2 || (k1*k1==Infinity && k2*k2==Infinity)) {
				//如果两个直线或线段的斜率相同，则是平行的。
			}else {
			    //计算直线或线段的交点
			
				if (k1*k1==Infinity) {
					nx = x1
					
					ny = k2 * nx + b2;
					
				}else if (k2*k2==Infinity)
				{
					nx = x3
					ny = k1 * nx + b1;
				}
				else{
					nx = (b2 - b1) / (k1 - k2);
					ny = k1 * nx + b1;
				}
				
				
			//	 trace(">>",nx,ny, k1,k2,b1,b2)
				
				if (line==2) {
					//如果是两条直线:
					intersected = true;
				}else if (line == 1) 
				{ 
					//是一条直线与一条线段相交:
					var tx1:Number, tx2:Number
					if (x1 < x2) {
						if (x1<=nx && x2>=nx) {
							intersected=true
						}
					}else {
						if (x1>=nx && x2<=nx) {
							intersected=true
						}
					}
				}
				else if (line == 0)
				{
					//都是线段
					
					var t:Number=0
					if (x1 < x2) {
						if (x1<=nx && x2>=nx) {
							t+=0.5
						}
					}else {
						if (x1>=nx && x2<=nx) {
							t+=0.5
						}
					}
					
					if (x3 < x4) {
						if (x3<=nx && x4>=nx) {
							t+=0.5
						}
					}else {
						if (x3>=nx && x4<=nx) {
							t+=0.5
						}
					}
					
					
					if (t>=1) {
						intersected=true
					}
				}//end if
				
			}//end if
			if (intersected==true) {
				return [nx, ny]
			}else {
				return null
			}
			
		}//end function
		
		
		
		//优化线的检测
		public static function lineIntersection (x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, x4:Number, y4:Number, line:uint=0):Array {
			
		//	var k1, b1, k2, b2:Number;
			var k1:Number, k2:Number,ny:Number,nx:Number;
			 
			//b1 = (y2 * x1 - y1 * x2) / (x1 - x2);
			//k1 = (y1 - b1) / x1;
			k1 = (y1 - (y2 * x1 - y1 * x2) / (x1 - x2)) / x1;
			
			//b2 = (y4 * x3 - y3 * x4) / (x3 - x4);
		//	k2 = (y3 - b2) / x3;
			k2 = (y3 -  (y4 * x3 - y3 * x4) / (x3 - x4)) / x3;
			
			//var ny,nx:Number  
			
			//trace(k1,k2)
			if (k1*k1== k2*k2) {
				//如果两个直线或线段的斜率相同，则是平行的。
					return null;
			}
		
			//计算直线或线段的交点
			if (k1*k1==Infinity) {
				nx = x1
				ny = k2 * nx +  (y4 * x3 - y3 * x4) / (x3 - x4);
				if (((y1 <= ny && y2 >= ny) || (y1 >= ny && y2 <= ny)) && ((x3<=nx && x4>=nx) || (x3>=nx && x4<=nx))) {
					return [nx, ny]
				}else {
					return null
				}
				
			}else if ( k2*k2==Infinity)
			{
				nx = x3
				ny = k1 * nx + (y2 * x1 - y1 * x2) / (x1 - x2);
				if (((y3 <= ny && y4 >= ny) || (y3 >= ny && y4 <= ny) )&& ((x1<=nx && x2>=nx) || (x1>=nx && x2<=nx)) ) {
					return [nx, ny]
				}else {
					return null
				}
			}
			else{
				nx = ((y4 * x3 - y3 * x4) / (x3 - x4) - (y2 * x1 - y1 * x2) / (x1 - x2)) / (k1 - k2);
				ny = k1 * nx + (y2 * x1 - y1 * x2) / (x1 - x2);
				
			}
			
			switch(line){
				case 2:
					//如果是两条直线:
					return [nx, ny]
				break;
			    case 1:
					//是一条直线与一条线段相交:	
					if ((x1<=nx && x2>=nx) || (x1>=nx && x2<=nx)) {
						return [nx, ny]
					}
				break;
				case 0:
					//都是线段
					if (((x1<=nx && x2>=nx) || (x1>=nx && x2<=nx)) &&( (x3<=nx && x4>=nx)|| (x3>=nx && x4<=nx))) {
						return [nx, ny]
					}
				break;
			}
			
		return null;
			
			
		}//end function
		
		
		//优化线的检测,都是线段的用这个方法会快很多。
		//优化线的检测
	 
		
		
		
		 
		
		//所有数据在十万级进行测试
		public static function segmentIntersection (x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, x4:Number, y4:Number):Array {
			
			var ny :Number;
			var nx:Number;
			var k1:Number=(y1-y2)/(x1-x2);
			var  k2:Number=(y3-y4)/(x3-x4);
			
			if  (x1==x2  && x3==x4) {
				return null
			}
			if (k1== k2) {
				//如果两个直线或线段的斜率相同，则是平行的。
				return null;
			}
			//计算直线或线段的交点
			if (x1==x2) {
			 	nx = x1
				ny = k2 * x1 +  (y4 * x3 - y3 * x4) / (x3 - x4);
				if (((y1 <= ny && y2 >= ny) || (y1 >= ny && y2 <= ny)) && ((x3<=nx && x4>=nx) || (x3>=nx && x4<=nx))) {
					return [nx,ny];
				}else {
					return null;
				}
				
			}else if ( x3==x4)
			{
				nx = x3
				ny = k1 * x3 + (y2 * x1 - y1 * x2) / (x1 - x2);
				if (((y3 <= ny && y4 >= ny) || (y3 >= ny && y4 <= ny) )&& ((x1<=nx && x2>=nx) || (x1>=nx && x2<=nx)) ) {
					return [nx,ny];
				}else {
					return null
				}
			}
			else{
				nx = ((y4 * x3 - y3 * x4) / (x3 - x4) - (y2 * x1 - y1 * x2) / (x1 - x2)) / (k1 - k2);
				ny = k1 * nx + (y2 * x1 - y1 * x2) / (x1 - x2);
				if (((x1<=nx && x2>=nx) || (x1>=nx && x2<=nx)) &&( (x3<=nx && x4>=nx)|| (x3>=nx && x4<=nx))) {
						return [nx,ny];
				}
			}
			
			
			
		return null;
			
			
		}//end function
		
		
		
		
		//线的检测优化完
		//检测某一点是否在多边形内。与多边形相交不算(点在多边形的边上的还没有处理)
		public static function isInsidePolygon(x1:Number, y1:Number, polygon:Array):Boolean {
			var polygon:Array = polygon
			var k1:Number = 1
			var b1 :Number=(y1-x1)
			var len:uint = polygon.length
			var point:Array=[]
			var x2:Number = 0
			var y2 :Number= b1
			
			var sidePointNum:uint = 0
			
			//计算该直线是否与多边形的每个边相交，并给出相交的点
		
			for (var i:int = 0; i < len; i++ ) {
				//判断目标点是不是顶点
				if (x1 == polygon[i][0] && y1 == polygon[i][1]) {
					
					return false
				}
				var g:uint = ((i + 1) == len)?0:i + 1
				
				var p:Array = MathKit.getLineIntersection(polygon[i][0], polygon[i][1], polygon[g][0], polygon[g][1], x1, y1, x2, y2, 1)
				//trace(p)
				if (p != null) {
					
					point.push(p)
					
				}
			}
			
			var len2 :int= point.length
			if (len2 <= 0) {
				
				return false;
			}else{
				for (var k:int = 0; k <len2; k++ ) {
					if (point[k][0] > x1) {
						if(isExist(point[k][0],point[k][1])==false){
							sidePointNum++
						}
					}
				}
				
				/*if (sidePointNum / 2 != Math.round(sidePointNum / 2)) {
					return true
				}else if (len2 > 1) {
					//trace("len2 > 1")
					return true
				}else {
					//trace("len2 :"+len2)
					return false
				}*/
				
				if (sidePointNum / 2 != Math.round(sidePointNum / 2)) {
					return true
				}else {
					//trace("len2 :"+len2)
					return false
				}
			}//end if
			
			//判断相交点是否是顶点和目标点
			function isExist($x1:Number,$y1:Number):Boolean {
				for (i = 0; i < len; i++ ) {
					//判断相交点是不是顶点
					if ($x1==polygon[i][0] && $y1==polygon[i][1]) {
						return true
					}
					
					//判断相交点是不是目标点
					if ($x1==x1 && $y1==y1) {
						return true
					}
				}
				return false
			}
		}//end function
		
		//验证两个多边形是否相交，并以数组的形式返回相交的点
		public static function getPolygonIntersection():Boolean {
			return false
		}
		
		//线段或直线是否与多边形相交，返回相交状态和相交点。line:0为线段与多边形，1为直线与多边形
		public static function getIntersectionBetweenLineAndPolygon(x1:Number, y1:Number, x2:Number, y2:Number, polygon:Array, line:uint = 0):Array {
			//返回一个数组，这个数组包括下面的 point,还要包括一组分析数据。在线段或直线与多边形交点的两边，交点的分布数量。
			var polygon:Array = polygon
			
			var len:uint = polygon.length
			var point:Array //[[x,y],[x,y],[x,y]]依次是交点、交点所在边的顶点A，顶点B
			//这个数组将会按照序列返回新生成的节点分布（将交点插入到节点序列中。）
			var pathNode:Array=[]
			//计算该直线是否与多边形的每个边相交，并给出相交的点
			
			for (var i:int = 0; i < len; i++ ) {
				//判断目标点是不是顶点
				
				if (x1 == polygon[i][0] && y1 == polygon[i][1]) {
					//trace("is peak")
					return [point,pathNode]
				}
				
				var g:uint = ((i + 1) == len)?0:i + 1
				
				//var p:Array = MathKit.getLineIntersection(polygon[i][0], polygon[i][1], polygon[g][0], polygon[g][1], x1, y1, x2, y2,0);
				var p:Array = MathKit.lineIntersection(polygon[i][0], polygon[i][1], polygon[g][0], polygon[g][1], x1, y1, x2, y2,0);
				//trace(p)
				pathNode.push([polygon[i][0], polygon[i][1], 0])//最后一个数字表示该点的状态:0为顶点，1为交点，2为最后的交点.
				
				if (p != null) {
				    //如果交点不是顶点或者目标点的话，就插入交点到节点序列里。
					if (  isExist(p[0], p[1]) == false) {
						
						if (point == null) {
							point = [];
						}
						//point.push([p, [polygon[i][0]], polygon[i][1]], [ polygon[g][0], polygon[g][1]]);
					 
						point.push([p[0],p[1]]);
						pathNode.push([p[0], p[1]])
					}else {
						//如果交点是顶点或目标点的话，则不插入该点，但是要标记是如果是最后的一个交点的话则要标记
						
					}
				}
				
			}//end for
			
			
			//判断相交点是否是顶点和目标点
			function isExist($x1:Number,$y1:Number):Boolean {
				for (var k:int = 0; k < len; k++ ) {
					//判断相交点是不是顶点
					if ($x1==polygon[k][0] && $y1==polygon[k][1]) {
						return true
					}
					
					//判断相交点是不是目标点
					if ($x1==x1 && $y1==y1) {
						return true
					}
				}
				return false
			}
			return [point,pathNode]//如果result[0]=null则没有相交点，result[1]是返回的插入了交点的多边形节点序列。
			
		}//end fuction
		
		
		//优化过的线条与多边形的碰撞检测。
		
		//线段或直线是否与多边形相交，返回相交状态和相交点。line:0为线段与多边形，1为直线与多边形
		//如果只需要知道是否碰撞了，设置getPoint=false可以大大加快速度。如果想要获得所有碰撞的点的数据设置getPoint=true,不过会慢一倍的时间.
		public static function Line2Polygon(x1:Number, y1:Number, x2:Number, y2:Number, polygon:Array, line:uint = 0,getPoint:Boolean=true):Array {
			//返回一个数组，这个数组包括下面的 point,还要包括一组分析数据。在线段或直线与多边形交点的两边，交点的分布数量。
			//var polygon:Array = polygon
			
			var len:uint = polygon.length
			var point:Array = []; //[[x,y],[x,y],[x,y]]依次是交点、交点所在边的顶点A，顶点B
			//这个数组将会按照序列返回新生成的节点分布（将交点插入到节点序列中。）
			//var pathNode:Array=[]
			//计算该直线是否与多边形的每个边相交，并给出相交的点
			var g:uint
			for (var i :uint = 0; i < len; i++ ) {
				g = i + 1;
				g = (g == len)?0:g;
				var p:Array = MathKit.lineIntersection( x1, y1, x2, y2,polygon[i][0], polygon[i][1], polygon[g][0], polygon[g][1],line);
				if (getPoint == false && p != null) {
					return [p];
				}
				if( p != null) {
					point.push(p)
				}

			}//end for

			return point
		}//end fuction
		
		//再次优化过的线与多边形检测,放在同一个数组里,和数组嵌套的速度没差别。
		public static function segment2Polygon(x1:Number, y1:Number, x2:Number, y2:Number, polygon:Array):Array {
			var len:uint = polygon.length
			var point:Array = []; //[[x,y],[x,y],[x,y]]依次是交点、交点所在边的顶点A，顶点B
			var index:uint=0
			//计算该线段是否与多边形的每个边相交，并给出相交的点
			var g:uint
			for (var i :uint = 0; i < len; i += 2 ) {
				g = i + 2;
			//	g = (g >= len )?0:g;//这样的语句不如拆散成下面的效率高
				if (g >= len) {g = 0;}
				var p:Array = MathKit.segmentIntersection( x1, y1, x2, y2, polygon[i], polygon[i + 1], polygon[g], polygon[g + 1]);
				//if (getPoint == false && p != null) {return [p];}
				if ( p != null) {
					point[index] = p;
					index++
					//point.push(p);//array的push方法不如自己用个索引数来添加数据效率高。
				}

			}//end for
			return point
		}//end fuction
		
		//这个是一旦检测到碰撞就返回碰撞结果。
		public static function segment2Polygon2(x1:Number, y1:Number, x2:Number, y2:Number, polygon:Array):Array {
			var len:uint = polygon.length
			var g:uint
			var p:Array;
			for (var i :uint = 0; i < len; i += 2 ) {
				g = i + 2;
				if (g >= len) {g = 0;}
					p = MathKit.segmentIntersection( x1, y1, x2, y2, polygon[i], polygon[i + 1], polygon[g], polygon[g + 1]);
					if ( p != null) {return p}
			}//end for
			
			return null
		}//end fuction
		
		//多边形和多边形的碰撞检测，只返回一个碰撞点。
		public static function polygon2Polygon(p1:Array, p2:Array):Array {
			var len:uint = p1.length;
			var g:uint
			var p:Array;
			var m:uint;
			var len2:uint=p2.length;
			for (var i:uint = 0; i < len; i += 2 ) {
				g = i + 2;
				if (g >= len) { g = 0; }
					for (var k :uint = 0;k < len2; k += 2 ) {
					m = i + 2;
					if (m>= len2) {m = 0;}
						p = MathKit.segmentIntersection( p1[i], p1[i+1], p1[g],p1[g+1], p2[k],p2[k+1],p2[m],p2[m+1]);
						if ( p != null) { return p }
					}//end for
				
			}
			return null;
		}
		
		
		
		
		
	}//end class

}