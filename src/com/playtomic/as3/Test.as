package com.playtomic.as3
{
	public class Test {
		
		private static var successes:String = "";
		private static var failures:String = "";
		private static var results:String = "";
		
		public static function assertEquals(section:String, name:String, expected:*, received:*):Boolean {
			if (expected == received) {
				record(true, section, name, expected, received);
				return true;
			}
			
			record(false, section, name, expected, received);
			return false;
		}
		
		public static function assertTrue(section:String, name:String, value:*):Boolean {
			return assertEquals(section, name, value, true);
		}
		
		public static function assertFalse(section:String, name:String, value:*):Boolean {
			return assertEquals(section, name, value, false);
		}
		
		private static function record(success:Boolean, section:String, message:String, expected:*, received:*):void 
		{
			var fontstart:String = "<font color='" + (success ? "#999999" : "#FF0000") + "'>";
			var fontend:String = "</font>\n";
			
			if (!success) {
				fontstart += "<b>";
				fontend = "</b>" + fontend;
			}
			
			var message:String = fontstart + "[" + section + "] " + message;
			
			if (success) {
				message += fontend;
				successes = message + successes;
			} else {
				message += " (" + expected + " vs " + received + ")" + fontend;
				failures = message + failures;
			}
			
			results = message + results;
		}
		
		public static function render():String {
			
			var str:String = new String();
			str +=   "<font color='#CCCCCC'>--------------------------------      errors      --------------------------------</font>\n";
			str += failures;
			str += "\n<font color='#CCCCCC'>--------------------------------     full log     --------------------------------</font>\n";
			str += results;
			return str;
		}
	}
}