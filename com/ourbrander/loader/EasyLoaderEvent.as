package com.ourbrander.loader{
	import flash.events.Event;
	/**
	 * All the Event Type of easyLoader.
	 * @example
	 * <listing version="3.0">
	 * 	_assetsManager=new EasyLoader  ;
		_assetsManager.addEventListener(EasyLoaderEvent.COMPLETED,assetsLoaded);
		_assetsManager.addEventListener(EasyLoaderEvent.LOADING_ERROR,assetsLoadError);
		_assetsManager.addEventListener(EasyLoaderEvent.PROGRESS,assetsLoadProgress);
		_assetsManager.addEventListener(EasyLoaderEvent.CONFIG_INIT_ERROR,configLoadError);
	 * </listing>
	 * @author  liuyi 
	 */
	public class EasyLoaderEvent extends Event {
		
		/** When easyLoader Object in loading progress, the easyLoader object will dispatch this event.*/
		public static const PROGRESS:String = "easyLoaderEventProgress";
		/** When errors occured  in loading progress, the easyLoader object will dispatch this event.*/
		public static const LOADING_ERROR:String = "loadingError";
		/** When all the assets are loaded, the easyLoader object will dispatch this event.*/
		public static const COMPLETED:String = "completed";
		/** When  single item of loading list are loaded, the easyLoader object will dispatch this event.*/
		public static const ITEM_COMPLETED:String = "item_completed";
		/** When  the loading progress are paused, the easyLoader object will dispatch this event.*/
		public static const PAUSE:String = "pause";
		/** When  the loading progress are resumed, the easyLoader object will dispatch this event.*/
		public static const UNPAUSE:String = "unPause";
		/** When  the loading progress start, the easyLoader object will dispatch this event.*/
		public static const START:String = "start";
		/** When  dispose the easyLoader object, the easyLoader object will dispatch this event.*/
		public static const DISPOSE:String = "dispose";
		/** When the config file initialized, the easyLoader object will dispatch this event.*/
		public static const CONFIG_INITED:String = "configInited";
		/** When the config file initializing, error occured, the easyLoader object will dispatch this event.*/
		public static const CONFIG_INIT_ERROR:String = "configInitError";
		
		private var _data:Object;
		
		/**
		 * create a new EasyLoaderEvent
		 * @param	type There are 10 Event types.
		 * @param	data The object inculde some special value.
		 * @param	bubbles  Determines whether the Event object bubbles. Event listeners can access this information through the inherited bubbles  property.
		 * @param	cancelable Determines whether the Event object can be canceled. Event listeners can access this information through the inherited cancelable  property. 
		 */
		public function EasyLoaderEvent(type:String,data:Object=null,bubbles:Boolean=false,cancelable:Boolean=false) {
			super(type,bubbles,cancelable);
			this.data=data;
		}

		public function set data(obj:Object):void {
			_data=obj;
		}
		public function get data():Object {
			return _data;
		}

	}

}