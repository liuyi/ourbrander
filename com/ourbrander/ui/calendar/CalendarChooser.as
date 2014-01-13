package com.ourbrander.ui.calendar
{
	import com.greensock.TweenMax;
	import com.ourbrander.ui.Themes;
	import com.ourbrander.ui.UIObject;
	import com.ourbrander.utils.Utils;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class CalendarChooser extends UIObject
	{
		
		protected  var currentDate:Date;
		protected var today:Date;
		protected var minYear:int=1900;
		
	
		
		
		protected var weeksMc:Sprite
		protected var header:Sprite;
		
		protected var prevYearBtn:Sprite;
		protected var nextYearBtn:Sprite;
		protected var prevMonthBtn:Sprite;
		protected var nextMonthBtn:Sprite;
		protected var closeBtn:Sprite;
		
		protected var dateTxt:TextField;
		
		protected var weekLables:Array=["Mon.","Tues.","Wen.","Thur.","Fri.","Sat.","Sun"];
		protected var dateRuler:String="${y}-${m}-${d}";
		
		protected var months:Array=[31,28,31,30,31,30,31,31,30,31,30,31];
		
		public var  limitMinDate:Date
		public var limitMaxDate:Date
		public var onSelected:Function;
		public var onClose:Function;
		public var transDruation:Number=0;
		
		public function CalendarChooser(uiKey:String="Calendar")
		{
			super(uiKey);
			
		}
		
		protected function init():void{
			
			today=new Date();
			currentDate=new Date();
			
		}
		
		override protected function onRemoveFromStage(event:Event):void{
			header.removeEventListener(MouseEvent.CLICK,onHeaderClicked);
			content.removeEventListener(MouseEvent.CLICK,onDateClick);
			super.onRemoveFromStage(event);
			
		}
		
		override protected function onAddedToStage(event:Event):void{
			super.onAddedToStage(event);
			header.addEventListener(MouseEvent.CLICK,onHeaderClicked);
			content.addEventListener(MouseEvent.CLICK,onDateClick);
			content.addEventListener(MouseEvent.MOUSE_OVER,onDateOver);
			content.addEventListener(MouseEvent.MOUSE_OUT,onDateOut);
		}
		
		protected function onDateOut(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var target:MovieClip=event.target as MovieClip
				
				
			if(target==null || target.name!="dateItem"){
				return
			}
			if(target["date"]==currentDate.date) return
			TweenMax.to(target.hover,transDruation,{autoAlpha:0})
		}
		
		protected function onDateOver(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var target:MovieClip=event.target as MovieClip
			if(target==null || target.name!="dateItem"){
				return
			}
			
			if(target["date"]==currentDate.date) return
			TweenMax.to(target.hover,transDruation,{autoAlpha:1})
		}
		
		protected function onDateClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var target:MovieClip=event.target as MovieClip
			if(target==null || target.name!="dateItem"){
				return
			}
		//	if(target["date"]==currentDate.date ||target["date"]<0 ) return
			if(target["date"]<0 ) return
			selectDate(target["date"] as int);
			
			if(onSelected!=null){
				onSelected(currentDate);
			}
		}
		
		protected function selectDate(date:int):void{
			//dateTxt.text=currentDate.getFullYear()+"-"+(currentDate.getMonth()+1)+"-"+date
			setDate(-1,-1,date)
		}
		
		/**
		 * @desc month is start from 1
		 */
		protected function ZellerWeek(year:int,month:int,date:int):int
		{
			var m:int = month;
			var d:int = date;

			if (month<=2)
			{
				year--;
				m = month + 12;
			}

			var y:int = year % 100;
			var c:int = year / 100;
		 
			var w:int=Math.floor((y+y/4+c/4-2*c+Math.floor((13*(m+1)/5))+d-1)%7);
		 
			if (w<0)
			{
				w +=  7;
			}
		 
		 
			return w;
		}
		
		protected function caculateMonths(year:int,month:int,date:int):void{
			//caculate year
		
			currentDate.setFullYear(year,month,date)
			if((year%4==0 && year %100!=0) || (year %400==0)){
				months[1]=29;
			}else{
				months[1]=28;
			}
			
			
		}
		
		public function setLan(weeks:String="Mon.,Tues.,Wen.,Thur.,Fri.,Sat.,Sun",dateRuler:String="${y}-${m}-${d}"):void{
			
		}
		
		override public function setView(view:Sprite):void{
			super.setView(view);
			
			if(currentDate==null){
				init();
			}
			//caculateMonths(currentDate.getFullYear(),currentDate.month,currentDate.date);
			
			weeksMc=view.getChildByName("weeksMc") as Sprite;
			header=view.getChildByName("header") as Sprite;
			
			prevYearBtn=header.getChildByName("prevYearBtn") as Sprite;
			nextYearBtn=header.getChildByName("nextYearBtn") as Sprite;
			prevMonthBtn=header.getChildByName("prevMonthBtn") as Sprite;
			nextMonthBtn=header.getChildByName("nextMonthBtn") as Sprite;
			closeBtn=header.getChildByName("closeBtn") as Sprite;
			dateTxt=header.getChildByName("dateTxt") as TextField;
			dateTxt.mouseEnabled=false;
			
			closeBtn.buttonMode=prevYearBtn.buttonMode=nextYearBtn.buttonMode=prevMonthBtn.buttonMode=nextMonthBtn.buttonMode=true
			
			
			//create weeks item
			var item:MovieClip
			var weekUIkey:String=Themes.getUIName("CalendarWeekItem");
			var txt:TextField;
			for(var i:int=0;i<7;i++){
				item=Utils.getObj(weekUIkey) as MovieClip;
				weeksMc.addChild(item);
				item.x=(item.width)*i;
				txt=item.getChildByName("txt") as TextField;
				txt.text=weekLables[i];
				item.mouseChildren=false;
				item.mouseEnabled=false;
			}
			
			
			//create date item
			var dateUIKey:String=Themes.getUIName("CalendarDateItem");
			for( i=0;i<42;i++){
				item=Utils.getObj(dateUIKey) as MovieClip;
				content.addChild(item);
				item.x=(item.width)*(i%7);
				item.y=(item.height)*Math.floor(i/7);
				txt=item.getChildByName("txt") as TextField;
				txt.text=""
				item.mouseChildren=false;
				item.name="dateItem"
				item.buttonMode=true
			}
			
			
			
			setDate()
			//updateDisplay()
		}
		public function get date():Date{
			return currentDate;
		}
		protected function updateDisplay():void{
			var len:int=months[currentDate.getMonth()];
			var week:int=ZellerWeek(currentDate.getFullYear(),currentDate.getMonth()+1,1);
		
			if(week<=0) week=7;
			dateTxt.text=currentDate.getFullYear()+"-"+(currentDate.getMonth()+1)+"-"+currentDate.date
			
				week-=1
			var item:MovieClip;
			var txt:TextField
			for( var i:int=0;i<len;i++){
				
					item=content.getChildAt(i+week) as MovieClip;
					txt=	item.getChildByName("txt") as TextField;
					txt.text=String(i+1);
					item["date"]=(i+1);
					
					if(checkDate(-1,-1,i+1)==false){
						item.alpha=0.8;
						item.mouseEnabled=false;
					}else{
						item.mouseEnabled=true;
					}
					
					freshDateItem(item);

			}
			
			for(i=0;i<week;i++){
		
				item=content.getChildAt(i) as MovieClip;
				txt=	item.getChildByName("txt") as TextField;
				txt.text="";
				item["date"]=-1;
				freshDateItem(item);
				item.mouseEnabled=false
			}
			
			for(i=len+week;i<42;i++){
		
				item=content.getChildAt(i) as MovieClip;
				txt=	item.getChildByName("txt") as TextField;
				txt.text="";
				item["date"]=-1;
				freshDateItem(item);
				item.mouseEnabled=false
			}
			
			function freshDateItem(item:MovieClip):void{
				if(item["date"]==today.date && currentDate.getFullYear()==today.getFullYear() && currentDate.month==today.month){
					TweenMax.killTweensOf(item.today)
					TweenMax.to(item.today,transDruation,{autoAlpha:1})
				}else{
					item.today.visible=false;
					item.today.alpha=0;
				}
				
				if(item["date"]!=currentDate.date){
					TweenMax.to(item.hover,transDruation,{autoAlpha:0})
				}
				
				if(item["date"]==currentDate.date && currentDate.getFullYear()==today.getFullYear() && currentDate.month==today.month){
					TweenMax.to(item.selectLabel,transDruation,{autoAlpha:1})
				}else{
					TweenMax.to(item.selectLabel,transDruation,{autoAlpha:0})
				}
			}
			
		}
		
		protected function onHeaderClicked(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(event.target ==nextMonthBtn){
				nextMonth();
			}else if(event.target==prevMonthBtn){
				prevMonth();
			}else if(event.target==prevYearBtn){
				prevYear();
			}else if(event.target==nextYearBtn){
				nextYear();
			}else if(event.target ==closeBtn){
				if(onClose!=null){
					onClose();
				}
			}

		}
		public function nextMonth():void{
			if(currentDate.month>=11){
				//currentDate.month=0
				//currentDate.setFullYear(currentDate.getFullYear()+1)
				setDate(currentDate.getFullYear()+1,0)
			}else{
				//currentDate.month+=1;
				setDate(-1,currentDate.month+1)
			}

			//updateDisplay()
			
		}
		
		public function prevMonth():void{
			if(currentDate.month<=0){
			/*	currentDate.month=11
				currentDate.setFullYear(currentDate.getFullYear()-1)*/
				setDate(currentDate.getFullYear()-1,11)
			}else{
				//currentDate.month-=1;
				setDate(-1,currentDate.month-1)
			}
		//	updateDisplay()
		}
		
		public function nextYear():void{
			/*currentDate.setFullYear(currentDate.getFullYear()+1)
			updateDisplay()*/
			setDate(currentDate.getFullYear()+1)
		}
		
		public function prevYear():void{
			/*currentDate.setFullYear(currentDate.getFullYear()-1)
			updateDisplay()*/
			setDate(currentDate.getFullYear()-1)
		}
		
		
		public function setDate(year:int=-1,month:int=-1,date:int=-1):void{
			
			//if(year<0) year=(new Date().getFullYear()
			 
			if((year<0 || month<0 || date <0 )&& currentDate==null){
				currentDate=new Date();
				
			}
			
		
			if(year<0) year=currentDate.getFullYear();
			if(month<0) month=currentDate.month;
			if(date<0) date=currentDate.date;
			
			if(checkDate(year,month,date)==false){
				return;
			}
			
			
			
			if(currentDate==null || currentDate.getFullYear()!=year){
				caculateMonths(year,month,date);
			}
			
			currentDate.setFullYear(year,month,date);
			updateDisplay();
		}
		
		protected function checkDate(year:int=-1,month:int=-1,date:int=-1):Boolean{
			
			if(year<0) year=currentDate.getFullYear();
			if(month<0) month=currentDate.month;
			if(date<0) date=currentDate.date;
			
			
			var m:String=(month<10)?"0"+month:month+"";
			var d:String=(date<10)?"0"+date:date+"";
		   
		
		
		
			if(limitMinDate!=null){
				var lm:String=(limitMinDate.month<10)?"0"+limitMinDate.month:limitMinDate.month+"";
				var ld:String=(limitMinDate.date<10)?"0"+limitMinDate.date:limitMinDate.date+"";
				if(int(limitMinDate.getFullYear()+""+lm+""+ld)>=int(year+""+m+""+d)){
					return false;
				}
				
			}
			
			
			
			if(limitMaxDate!=null){
				lm=(limitMaxDate.month<10)?"0"+limitMaxDate.month:limitMaxDate.month+"";
				ld=(limitMaxDate.date<10)?"0"+limitMaxDate.date:limitMaxDate.date+"";
				if(int(limitMaxDate.getFullYear()+""+lm+""+ld)<=int(year+""+m+""+d)){
					return false;
				}
			}
			
			return true
		}
		
	}
}