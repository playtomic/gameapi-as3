package com.playtomic.as3
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
    public class Tests extends Sprite
    {	
		private static const PublicKey:String = "testpublickey";
		private static const PrivateKey:String = "testprivatekey";
		
        public function Tests() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void {
			
			// API 
			Playtomic.initialize(PublicKey, PrivateKey, "http://127.0.0.1:3000/");
			
			// debugging
			x = 4;
			y = 4;
			
			var format:TextFormat = new TextFormat();
			format.font = "Arial";
			format.size = 10;   
			
			var t:TextField = new TextField();
			t.defaultTextFormat = format;
			t.width = 792;
			t.height = 592;
			t.multiline = true;
			t.type = "input";
			t.wordWrap = false;
			t.background = false;
			addChild(t);
			
			function createTests():Array {
				t.text = t.htmlText = "";
				TestPlayerLevels.rnd = TestLeaderboards.rnd = Math.round(Math.random() * 10000000);
				
				return [
					TestGameVars.all,
					TestGameVars.single,
					TestGeoIP.lookup,
					TestLeaderboards.firstscore,
					TestLeaderboards.secondscore,
					TestLeaderboards.highscores,
					TestLeaderboards.lowscores,
					TestLeaderboards.allscores,
					TestPlayerLevels.create,
					TestPlayerLevels.list,
					TestPlayerLevels.rate,
					TestPlayerLevels.load
				];
			}
			
			var tests:Array = createTests();
			
			function next():void {
				t.htmlText = Test.render();
				
				if (tests.length == 0) {
					return;
				}
				
				tests.shift()(next);
			}
			
			next();
        }
    }
}