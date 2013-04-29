package
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import com.playtomic.as3.Tests;
	
	public class Main extends Sprite
	{
		public static var STAGE:Stage;
		
		public function Main() {
			addEventListener(Event.ADDED_TO_STAGE, initialize, false, 0, true);
		}
		
		private function initialize(e:Event):void {
			STAGE = stage;
			addChild(new Tests());
			return;
		}
	}
}