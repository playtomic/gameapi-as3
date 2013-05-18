package com.playtomic.as3 {
	
	public final class Achievements {
		
		private static const SECTION:String = "achievements";
		private static const LIST:String = "list";
		private static const STREAM:String = "stream";
		private static const SAVE:String = "save";
		
		/**
		 * Lists all achievements
		 * @param	options		The list options
		 * @param	callback	Your function to receive the response: function(achievements, response)
		 */
		public static function list(options:Object, callback:Function):void {
			ServiceRequest.load(SECTION, LIST, listComplete, callback, options);
		}
		
		/**
		 * Shows a chronological stream of achievements 
		 * @param	options		The stream options
		 * @param	callback	Your function to receive the response: function(achievements, response)
		 */ 
		public static function stream(options:Object, callback:Function):void {
			ServiceRequest.load(SECTION, STREAM, streamComplete, callback, options);
		}
		
		/**
		 * Award an achievement to a player
		 * @param	achievement	The achievement
		 * @param	callback	Your function to receive the response: function(response)
		 */
		public static function save(achievement:Object, callback:Function):void {
			ServiceRequest.load(SECTION, SAVE, saveComplete, callback, achievement);
		}
		
		/**
		 * Processes the response received from the server, returns the data and response to the user's callback
		 * @param	callback	The user's callback function
		 * @param	postdata	The data that was posted
		 * @param	data		The object returned from the server
		 * @param	response	The response from the server
		 */
		private static function saveComplete(callback:Function, data:Object, response:Response):void {
			if(callback == null)
				return;
			
			callback(response);
		}
		
		private static function listComplete(callback:Function, data:Object, response:Response):void {
			if(callback == null) {
				return;
			}
			
			if(!response.success) {
				callback([], response);
				return;
			}
			
			callback(data.achievements, response);
		}
		
		private static function streamComplete(callback:Function, data:Object, response:Response):void {
			if(callback == null)
				return;
			
			if(!response.success) {
				callback([], response);
				return;
			}
			
			callback(data.achievements, data.numachievements, response);
		}
	}
}