package com.ourbrander.tween 
{
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author liu yi
	 */
	public class Tween 
	{
		
		
		public function Tween() 
		{
			
		}
		
		private static var  tweenList:Array = [];
		private static var  tweening:Boolean;
		private static var timer:Timer
		
		//if speed is more  than 1, the animation would be faster to slowly, if less than 1 it should be slowly to faster
		public static function to(target:Object, time:Number, obj:Object,speed:Number=1,callback:Function=null):void {
			if (speed <= 0) speed = 0.01;
			var objs:Object = { target:target, time:time * 100, obj:obj , speed:speed ,callback:callback} 
			//if(obj["blur"]!=null) objs["blur"]=null
			tweenList.push( objs);
			
			
			if (timer == null) {
				timer = new Timer(10);
				timer.addEventListener(TimerEvent.TIMER, tweenUpdating);
				timer.start();
			}
		} 
		
		 
		
		private static function tweenUpdating(e:TimerEvent):void {
			var target:Object;
			var obj:Object
			var time:Number
			var leftLen:uint;
			var speed:Number = 1;
			var nextNum:Number
			if (tweenList == null || tweenList.length == 0) {
				timer.removeEventListener(TimerEvent.TIMER, tweenUpdating);
				timer = null;
			}
			
			for (var i:int = 0; i < tweenList.length;i++ ) {
				
				target = tweenList[i].target;
				obj= tweenList[i].obj;
				time = tweenList[i].time;
				leftLen = 0;
				speed = tweenList[i].speed;
				
				
				for (var k:* in obj) {
					 
					if ( target.hasOwnProperty(k) ) {
						nextNum = ( (obj[k] - target[k]) / time) * speed+target[k] ;
					
						if ((nextNum < obj[k] + 0.01 &&  nextNum> obj[k] - 0.01) || (nextNum<0 && nextNum< obj[k]) ||nextNum== Infinity) {
							target[k] = obj[k];
							delete obj[k];
						}else{
							target[k] = nextNum;
							leftLen++;
						}
					}else {
						//apply blur filter
						if (k == "blur" ) {
							 
							if (target["filters"]['length']==0) { 
								tweenList[i]["blur"] = new BlurFilter(0, 0);
								
							
							}else if(tweenList[i]["blur"]==null ) {
								//find orignal blur filter.
								for (var b:* in target["filters"] ) {
									if ( target["filters"][b] is BlurFilter) tweenList[i]["blur"] = target["filters"][b];
								}
									
							}
							
							//obj[k] :{blurX,blurY} ,filters:BlurFilter 
							var blurVal:Number
							var nextVal:Number
							for (var f:* in obj[k]) {
								 blurVal = obj[k][f];
								 //tweenList[i]["blur"][f]= obj[k][f]
								 nextNum = ( (blurVal- tweenList[i]["blur"][f]) / time) * speed+tweenList[i]["blur"][f] ;
								
								if ((nextNum < blurVal+ 0.01 &&  nextNum> blurVal- 0.01) || (nextNum<0 && nextNum< blurVal) ||nextNum== Infinity) {
									tweenList[i]["blur"][f] = blurVal;
									
									delete obj[k][f];
								}else{
									tweenList[i]["blur"][f]= nextNum;
									leftLen++;
									
								}
								
							}
							target["filters"] = [tweenList[i]["blur"]]
							//trace(tweenList[i]["blur"].blurX)
						}//end blur filter
					}//end if
			
					
				}//end for
				tweenList[i].time--
				if (leftLen == 0) {
					
					if (tweenList[i]["callback"] != null && tweenList[i]["callback"]  is Function)tweenList[i]["callback"] ();
					tweenList[i] = null;
					tweenList.splice(i, 1);
				}
				
			}//end for
		}
		
		
	}

}