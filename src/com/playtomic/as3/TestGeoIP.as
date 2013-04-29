package com.playtomic.as3
{
	public class TestGeoIP extends Test
	{
		public static function lookup(done:Function):void {
			GeoIP.lookup(function(geo:Object, r:Response):void {
				var section:String = "TestGeoIP.lookup";
				assertTrue(section, "Request succeeded", r.success);
				assertEquals(section, "No errorcode", r.errorcode, 0);
				assertTrue(section, "Has country name", geo.hasOwnProperty("name"));
				assertTrue(section, "Has country code", geo.hasOwnProperty("code"));
				done();
			});
		}
	}
}