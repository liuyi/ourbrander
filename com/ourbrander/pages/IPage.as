package com.ourbrander.pages
{
	public interface IPage
	{
		
		function playIn(onComplete:Function):void;
		function playOut(onComplete:Function):void;
		function destroy():void;
		function get hasTransIn():Boolean;
		function get hasTransOut():Boolean;
		
		function set autoDestroy(flag:Boolean):void;
		function get autoDestroy():Boolean;
		
		
	}
}