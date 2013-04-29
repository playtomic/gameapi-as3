package com.playtomic.as3
{
	public class TestGameVars extends Test
	{
		public static function all(done:Function):void {
			GameVars.load(function loadall(gv:Object, r:Response):void {
				var section:String = "TestGameVars.all";
				assertTrue(section, "Request succeeded", r.success);
				assertEquals(section, "No errorcode", r.errorcode, 0);
				assertTrue(section, "Has known testvar1", gv.hasOwnProperty("testvar1"));
				assertTrue(section, "Has known testvar2", gv.hasOwnProperty("testvar2"));
				assertTrue(section, "Has known testvar3", gv.hasOwnProperty("testvar3"));
				assertEquals(section, "Has known testvar1 value", gv["testvar1"], "testvalue1");
				assertEquals(section, "Has known testvar2 value", gv["testvar2"], "testvalue2");
				assertEquals(section, "Has known testvar3 value", gv["testvar3"], "testvalue3 and the final gamevar");
				done();
			});
		}
			
		public static function single(done:Function):void {
			
			GameVars.loadSingle("testvar1", function(gv:Object, r:Response):void {
				var section:String = "TestGameVars.single";
				assertTrue(section, "Request succeeded", r.success);
				assertEquals(section, "No errorcode", r.errorcode, 0);
				assertTrue(section, "Has testvar1", gv.hasOwnProperty("testvar1"));
				assertEquals(section, "Has known testvar1 value", gv["testvar1"], "testvalue1");
				assertFalse(section, "Does not have testvar2", gv.hasOwnProperty("testvar2"));
				assertFalse(section, "Does not have testvar3", gv.hasOwnProperty("testvar3"));
				done();
			});
		}
	}
}