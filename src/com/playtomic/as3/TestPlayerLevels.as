package com.playtomic.as3 
{
	public class TestPlayerLevels extends Test
	{
		public static var rnd:int;
		
		public static function create(done:Function):void {
			
			var section:String = "TestPlayerLevels.create";
			
			var level:Object = {
				name: "create level" + rnd,
				playername: "ben" + rnd,
				playerid: "0",
				data: "this is the level data",
				fields: {
					rnd: rnd
				}
			}
			
			PlayerLevels.save(level, function(l:Object, r:Response):void {
				l = l || {};
				assertTrue(section + "#1", "Request succeeded", r.success);
				assertEquals(section + "#1", "No errorcode", r.errorcode, 0);
				assertTrue(section + "#1", "Returned level is not null", l != null);
				assertTrue(section + "#1", "Returned level has levelid", l.hasOwnProperty("levelid"));
				assertEquals(section + "#1", "Level names match", level.name, l.name); 
				
				// duplicate fails
				PlayerLevels.save(level, function(l:Object, r:Response):void {
					assertTrue(section + "#2", "Request succeeded", r.success);
					assertEquals(section + "#2", "Duplicate level errorcode", r.errorcode, 405);
					done();
				});
			});
		}
		
		public static function list(done:Function):void {
			
			var section:String = "TestPlayerLevels.list";
			
			var list:Object = { 
				page: 1,
				perpage: 10,
				data: false,
				filters: {
					rnd: rnd
				}
			}
			
			PlayerLevels.list(list, function(levels:Array, numlevels:int, r:Response):void {
				levels = levels || [];
				numlevels = numlevels || -1;
				assertTrue(section + "#1", "Request succeeded", r.success);
				assertEquals(section + "#1", "No errorcode", r.errorcode, 0);
				assertTrue(section + "#1", "Received levels", levels.length > 0);
				assertTrue(section + "#1", "Received numlevels", numlevels >= levels.length);

				if(levels.length > 0) {
					assertFalse(section + "#1", "First level has no data", levels[0].hasOwnProperty("data"));
				} else {
					assertTrue(section + "#1", "First level has no data forced failure", 0 > 1);
				}
				
				
				list.data = true;
				
				PlayerLevels.list(list, function(levels:Array, numlevels:int, r:Response):void {
					levels = levels || [];
					numlevels = numlevels || -1;
					
					assertTrue(section + "#2", "Request succeeded", r.success);
					assertEquals(section + "#2", "No errorcode", r.errorcode, 0);
					assertTrue(section + "#2", "Received levels", levels.length > 0);
					assertTrue(section + "#2", "Received numlevels", numlevels >= levels.length);
					
					if(levels.length > 0) {
						assertTrue(section + "#2", "First level has data", levels[0].hasOwnProperty("data"));
					} else {
						assertTrue(section + "#2", "First level has no data forced failure", 0 > 1);
					}
					
					done();
				});
			});
		}
		
		public static function rate(done:Function):void {
			
			var section:String = "TestPlayerLevels.rate";
			
			var level:Object = {
				name: "rate " + rnd,
				playername: "ben" + rnd,
				playerid: "0",
				data: "this is the level data",
				fields: {
					rnd: rnd
				}
			};
			
			PlayerLevels.save(level, function(l:Object, r:Response):void {
				l = l || {};
				assertTrue(section + "#1", "Request succeeded", r.success);
				assertEquals(section + "#1", "No errorcode", r.errorcode, 0);
				assertTrue(section + "#1", "Returned level is not null", l != null);
				assertTrue(section + "#1", "Returned level has levelid", l.hasOwnProperty("levelid"));
				
				// rate fails because of an invalid rating
				PlayerLevels.rate(l.levelid, 70, function(r:Response):void {
					assertFalse(section + "#2", "Request failed", r.success);
					assertEquals(section + "#2", "Invalid rating errorcode", r.errorcode, 401);

					// rate succeeds
					PlayerLevels.rate(l.levelid, 6, function(r:Response):void {
						assertTrue(section + "#3", "Request succeeded", r.success);
						assertEquals(section + "#3", "No errorcode", r.errorcode, 0);
						
						// rate fails because of already rated
						PlayerLevels.rate(l.levelid, 7, function(r:Response):void {
							assertFalse(section + "#4", "Request failed", r.success);
							assertEquals(section + "#4", "Already rated errorcode", r.errorcode, 402);
							done();
						});
					});
				});
			});
		}
		
		public static function load(done:Function):void {
			var section:String = "TestPlayerLevels.load";
			
			var level:Object=  {
				name: "sample loading level " + rnd,
				playername: "ben" + rnd,
				playerid: rnd.toString(),
				data: "this is the level data",
				fields: {
					rnd: rnd
				}
			}
			
			PlayerLevels.save(level, function(l:Object, r:Response):void {		
				l = l || {};
				assertTrue(section + "#1", "Request succeeded", r.success);
				assertEquals(section + "#1", "No errorcode", r.errorcode, 0);
				assertTrue(section + "#1", "Name is correct", l.hasOwnProperty("levelid"));
				assertEquals(section + "#1", "Name is correct", level.name, l.name);
				assertEquals(section + "#1", "Data is correct", level.data, l.data);
				
				// now load
				PlayerLevels.load(l.levelid, function(l:Object, r:Response):void {
					l = l || {};
					assertTrue(section + "#2", "Request succeeded", r.success);
					assertEquals(section + "#2", "No errorcode", r.errorcode, 0);
					assertEquals(section + "#2", "Name is correct", level.name, l.name);
					assertEquals(section + "#2", "Data is correct", level.data, l.data);
					done();
				});
			});
		}
	}
}