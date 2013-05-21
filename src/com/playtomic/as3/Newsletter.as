package com.playtomic.as3
{
	public class Newsletter
	{
		private static const SECTION:String = "newsletter";
		private static const SUBSCRIBE:String = "subscribe";
		
		/**
		 * Subscribes a user to your newsletter
		 * @param options	The options:  { email: , fields: { } }
		 * @param callback	Your callback function(response:Response)
		 */
		public static function subscribe(options:Object, callback:Function):void {
			ServiceRequest.load(SECTION, SUBSCRIBE, subscribeComplete, callback, options);	
		}
		
		/**
		 * Processes the response received from the server, returns the response to the user's callback
		 * @param	callback	The user's callback function
		 * @param	postdata	The data that was posted
		 * @param	data		The XML returned from the server
		 * @param	response	The response from the server
		 */
		private static function subscribeComplete(callback:Function, data:Object = null, response:Response = null):void {
			if(callback == null)
				return;
			
			callback(response);
		}
	}
}