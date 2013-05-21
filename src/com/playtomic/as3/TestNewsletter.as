package com.playtomic.as3
{
	public class TestNewsletter extends Test
	{
		public static function subscribe(done:Function):void {
			
			var obj:Object = { 
				email: "invalid @email.com"
			};
			
			// invalid
			Newsletter.subscribe(obj, function(r:Response):void {
				var section:String = "TestNewsletter.lookup";
				assertFalse(section + "#1", "Request failed", r.success);
				assertEquals(section + "#1", "Mailchimp API error", r.errorcode, 602);
				
				// valid 
				obj.email = "valid@testuri.com";
				obj.fields = { 
					STRINGFIELD: "this is a field"
				};
				
				Newsletter.subscribe(obj, function(r2:Response):void {
					assertTrue(section + "#2", "Request succeeded", r2.success);
					assertEquals(section + "#2", "No errorcode", r2.errorcode, 0);
					done();
				});
			});
		}
	}
}