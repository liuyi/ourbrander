package com.ourbrander.utils
{
	import flash.net.InterfaceAddress;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;

	public class AirUtils
	{
		public static function getClientIPAddress(version:String):InterfaceAddress
		{
			var ni:NetworkInfo = NetworkInfo.networkInfo;
			var interfaceVector:Vector.<NetworkInterface> = ni.findInterfaces();
			var currentNetwork:NetworkInterface;
			
			//	trace("interfaceVector:"+interfaceVector.length)
			for each (var networkInt:NetworkInterface in interfaceVector)
			{
				if (networkInt.active)
				{
					for each (var address:InterfaceAddress in networkInt.addresses)
					{	
						
						
						//	trace(">>>>>"+address.address,address.broadcast,address.ipVersion)
						if (address.ipVersion == version)
						{
							return address;
						}
					}
				}
			}
			return null;
		}
		
		public static function getHardAdress():String{
			var ni:NetworkInfo = NetworkInfo.networkInfo;
			var interfaceVector:Vector.<NetworkInterface> = ni.findInterfaces();
			for each (var networkInt:NetworkInterface in interfaceVector)
			{
				if (networkInt.active)
				{
					return networkInt.hardwareAddress
				}
			}
				return "";
		}
		
		/**
		 * {hardwareAddress:String,address:InterfaceAddress}
		 */
		public static function getAvailableNetInfo(version:String):Object{
			
			var ni:NetworkInfo = NetworkInfo.networkInfo;
			var interfaceVector:Vector.<NetworkInterface> = ni.findInterfaces();
			
			var activeInts:Array=[]
			for each (var networkInt:NetworkInterface in interfaceVector)
			{
				if (networkInt.active)
				{
					
					for each (var address:InterfaceAddress in networkInt.addresses)
					{	
						
						
						//	trace(">>>>>"+address.address,address.broadcast,address.ipVersion)
						if (address.ipVersion == version)
						{
							activeInts.push({networkInt:networkInt,address:address});
						}
					}
				}
			}
			
			if(activeInts.length==0) return null;
			if(activeInts.length==1) {
				
				return {hardwareAddress:activeInts[0].networkInt.hardwareAddress,address:activeInts[0].address}
				 
			}
			
			if(activeInts.length>1){
				for(var i:int=0;i<activeInts.length;i++){
					if(activeInts[i].address.address.indexOf("192.168")==0){
						return {hardwareAddress:activeInts[i].networkInt.hardwareAddress,address:activeInts[i].address}
					}
				}
				
				return  {hardwareAddress:activeInts[0].networkInt.hardwareAddress,address:activeInts[0].address}
			}
				/*{mac:activeInts[0].hardwareAddress,ip:
				}*/
			
			return null;
			
		}
		
		public function AirUtils()
		{
		}
	}
}