package com.playtomic.as3
{
	import flash.utils.setTimeout;
	
	public class TestAchievements extends Test
	{
		public static var rnd:int;
		
		public static function list(done:Function):void {
			
			var section:String = "TestAchievements.list";
			
			var achievements:Array = [
				{ fields: { rnd: rnd}, achievement: "Super Mega Achievement #1", achievementkey: "secretkey", playerid: "1", playername: "ben" }, 
				{ fields: { rnd: rnd}, achievement: "Super Mega Achievement #1", achievementkey: "secretkey", playerid: "2", playername: "michelle" }, 
				{ fields: { rnd: rnd}, achievement: "Super Mega Achievement #1", achievementkey: "secretkey", playerid: "3", playername: "peter" },
				{ fields: { rnd: rnd}, achievement: "Super Mega Achievement #2", achievementkey: "secretkey2", playerid: "3", playername: "peter" }, 
				{ fields: { rnd: rnd}, achievement: "Super Mega Achievement #2", achievementkey: "secretkey2", playerid: "2", playername: "michelle" }
			];
			
			function s():void {
				
				if(achievements.length > 0) {
					
					Achievements.save(achievements.shift(), function(r:Response):void {
						assertTrue(section, "Request succeeded (" + (5 - achievements.length) + ")", r.success);
						assertEquals(section, "No errorcode (" + (5 - achievements.length) + ")", r.errorcode, 0);
						setTimeout(s, 2000);
					});
					
					return;
				} 
				
				var options:Object = {
					filters: { rnd: rnd }
				};
				
				Achievements.list(options, function(achievements:Array, r:Response):void {
					assertTrue(section, "Request succeeded", r.success);
					assertEquals(section, "No errorcode", r.errorcode, 0);
					assertEquals(section, "Achievement 1 is correct", achievements[0].achievement, "Super Mega Achievement #1");
					assertEquals(section, "Achievement 2 is correct", achievements[1].achievement, "Super Mega Achievement #2");
					assertEquals(section, "Achievement 3 is correct", achievements[2].achievement, "Super Mega Achievement #3");
					done();
				});
			}
			
			s();
		}
		
		public static function listWithFriends(done:Function):void {

			var section:String = "TestAchievements.listWithFriends";
			
			var options:Object = {
				friendslist: ["1", "2", "3"],
				filters: { rnd: rnd }
			};
			
			Achievements.list(options, function(achievements:Array, r:Response):void {
				assertTrue(section, "Request succeeded", r.success);
				assertEquals(section, "No errorcode", r.errorcode, 0);
				assertEquals(section, "Achievement 1 is correct", achievements[0].achievement, "Super Mega Achievement #1");
				assertEquals(section, "Achievement 2 is correct", achievements[1].achievement, "Super Mega Achievement #2");
				assertEquals(section, "Achievement 3 is correct", achievements[2].achievement, "Super Mega Achievement #3");
				assertTrue(section, "Achievement 1 has friends", achievements[0].hasOwnProperty("friends"));
				assertTrue(section, "Achievement 2 has friends", achievements[1].hasOwnProperty("friends"));
				assertFalse(section, "Achievement 3 has no friends", achievements[2].hasOwnProperty("friends"));
				assertTrue(section, "Achievement 1 has 3 friends", achievements[0].friends.length == 3);
				assertTrue(section, "Achievement 1 friend 1", achievements[0].friends[0].playername == "ben");
				assertTrue(section, "Achievement 1 friend 2", achievements[0].friends[1].playername == "michelle");
				assertTrue(section, "Achievement 1 friend 3", achievements[0].friends[2].playername == "peter");
				assertTrue(section, "Achievement 2 has 2 friend", achievements[1].friends.length == 2);
				assertTrue(section, "Achievement 2 friend 1", achievements[1].friends[0].playername == "michelle");
				assertTrue(section, "Achievement 2 friend 2", achievements[1].friends[1].playername == "peter");
				done();
			});
		}
		
		public static function listWithPlayer(done:Function):void {
			
			var section:String = "TestAchievements.listWithPlayer";
			
			var options:Object = {
				playerid: "1",
				filters: { rnd: rnd }
			};
			
			Achievements.list(options, function(achievements:Array, r:Response):void {
				assertTrue(section, "Request succeeded", r.success);
				assertEquals(section, "No errorcode", r.errorcode, 0);
				assertEquals(section, "Achievement 1 is correct", achievements[0].achievement, "Super Mega Achievement #1");
				assertEquals(section, "Achievement 2 is correct", achievements[1].achievement, "Super Mega Achievement #2");
				assertEquals(section, "Achievement 3 is correct", achievements[2].achievement, "Super Mega Achievement #3");
				assertFalse(section, "Achievement 1 has no friends", achievements[0].hasOwnProperty("friends"));
				assertFalse(section, "Achievement 2 has no friends", achievements[1].hasOwnProperty("friends"));
				assertFalse(section, "Achievement 3 has no friends", achievements[2].hasOwnProperty("friends"));
				assertTrue(section, "Achievement 1 has does have player", achievements[0].hasOwnProperty("player"));
				assertFalse(section, "Achievement 2 has no player", achievements[1].hasOwnProperty("player"));
				assertFalse(section, "Achievement 3 has no player", achievements[2].hasOwnProperty("player"));
				assertTrue(section, "Achievement 1 player is ben", achievements[0].player.playername == "ben");
				done();
			});
		}
		
		public static function listWithPlayerAndFriends(done:Function):void {
			
			var section:String = "TestAchievements.listWithPlayerAndFriends";
			
			var options:Object = {
				playerid: "1", 
				friendslist: ["2", "3"],
				filters: { rnd: rnd }
			};
			
			Achievements.list(options, function(achievements:Array, r:Response):void {
				assertTrue(section, "Request succeeded", r.success);
				assertEquals(section, "No errorcode", r.errorcode, 0);
				assertEquals(section, "Achievement 1 is correct", achievements[0].achievement, "Super Mega Achievement #1");
				assertEquals(section, "Achievement 2 is correct", achievements[1].achievement, "Super Mega Achievement #2");
				assertEquals(section, "Achievement 3 is correct", achievements[2].achievement, "Super Mega Achievement #3");
				assertTrue(section, "Achievement 1 has player", achievements[0].hasOwnProperty("player"));			
				assertTrue(section, "Achievement 1 has friends", achievements[0].hasOwnProperty("friends"));
				assertTrue(section, "Achievement 2 has friends", achievements[1].hasOwnProperty("friends"));
				assertFalse(section, "Achievement 2 has no player", achievements[1].hasOwnProperty("player"));
				assertFalse(section, "Achievement 3 has no friends", achievements[2].hasOwnProperty("friends"));
				assertFalse(section, "Achievement 3 has no player", achievements[2].hasOwnProperty("player"));
				assertTrue(section, "Achievement 1 player", achievements[0].player.playername == "ben");
				assertTrue(section, "Achievement 1 has 2 friend", achievements[0].friends.length == 2);
				assertTrue(section, "Achievement 1 friend 1", achievements[0].friends[0].playername == "michelle");
				assertTrue(section, "Achievement 1 friend 2", achievements[0].friends[1].playername == "peter");
				assertTrue(section, "Achievement 2 has 2 friend", achievements[1].friends.length == 2);
				assertTrue(section, "Achievement 2 friend 1", achievements[1].friends[0].playername == "michelle");
				assertTrue(section, "Achievement 2 friend 2", achievements[1].friends[1].playername == "peter");
				done();
			});
		}
		
		public static function stream(done:Function):void {
			
			var section:String = "TestAchievements.stream";
			
			var options:Object = {
				filters: { rnd: rnd }
			};
			
			Achievements.stream(options, function(achievements:Array, numachievements:int, r:Response):void {
				assertTrue(section, "Request succeeded", r.success);
				assertEquals(section, "No errorcode", r.errorcode, 0);
				assertTrue(section, "5 achievements returned", achievements.length == 5);
				assertTrue(section, "5 achievements in total", numachievements == 5);
				assertTrue(section, "Achievement 1 person", achievements[0].playername == "michelle");
				assertTrue(section, "Achievement 1 achievement", achievements[0].awarded.achievement == "Super Mega Achievement #2");
				assertTrue(section, "Achievement 2 person", achievements[1].playername == "peter");
				assertTrue(section, "Achievement 2 achievement", achievements[1].awarded.achievement == "Super Mega Achievement #2");
				assertTrue(section, "Achievement 3 person", achievements[2].playername == "peter");
				assertTrue(section, "Achievement 3 achievement", achievements[2].awarded.achievement == "Super Mega Achievement #1");
				assertTrue(section, "Achievement 4 person", achievements[3].playername == "michelle");
				assertTrue(section, "Achievement 4 achievement", achievements[3].awarded.achievement == "Super Mega Achievement #1");					
				assertTrue(section, "Achievement 5 person", achievements[4].playername == "ben");
				assertTrue(section, "Achievement 5 achievement", achievements[4].awarded.achievement == "Super Mega Achievement #1");
				
				done();
			});
		}
		
		public static function streamWithFriends(done:Function):void {
			
			var section:String = "TestAchievements.streamWithFriends";
			
			var options:Object = {
				group: true,
				friendslist: ["2", "3"],
				filters: { rnd: rnd }
			};
			
			Achievements.stream(options, function(achievements:Array, numachievements:int, r:Response):void {
				assertTrue(section, "Request succeeded", r.success);
				assertEquals(section, "No errorcode", r.errorcode, 0);
				assertTrue(section, "2 achievements returned", achievements.length == 2);
				assertTrue(section, "2 achievements in total", numachievements == 2);
				assertTrue(section, "Achievement 1 awards", achievements[0].awards == 2);
				assertTrue(section, "Achievement 1 achievement", achievements[0].awarded.achievement == "Super Mega Achievement #2");
				assertTrue(section, "Achievement 1 person", achievements[0].playername == "michelle");
				assertTrue(section, "Achievement 2 awards", achievements[1].awards == 2);
				assertTrue(section, "Achievement 2 achievement", achievements[1].awarded.achievement == "Super Mega Achievement #2");
				assertTrue(section, "Achievement 2 person", achievements[1].playername == "peter");					
				done();
			});
		}
		
		public static function streamWithPlayerAndFriends(done:Function):void {
			
			var section:String = "TestAchievements.streamWithPlayerAndFriends";
			
			var options:Object = {
				group: true,
				playerid: "1",
				friendslist: ["2", "3"],
				filters: { rnd: rnd }
			};
			
			Achievements.stream(options, function(achievements:Array, numachievements:int, r:Response):void {
				assertTrue(section, "Request succeeded", r.success);
				assertEquals(section, "No errorcode", r.errorcode, 0);
				assertTrue(section, "3 achievements returned", achievements.length == 3);
				assertTrue(section, "3 achievements in total", numachievements == 3);
				assertTrue(section, "Achievement 1 person", achievements[0].playername == "michelle");
				assertTrue(section, "Achievement 1 awards", achievements[0].awards == 2);
				assertTrue(section, "Achievement 1 achievement", achievements[0].awarded.achievement == "Super Mega Achievement #2");
				assertTrue(section, "Achievement 2 person", achievements[1].playername == "peter");
				assertTrue(section, "Achievement 2 awards", achievements[1].awards == 2);
				assertTrue(section, "Achievement 2 achievement", achievements[1].awarded.achievement == "Super Mega Achievement #2");
				assertTrue(section, "Achievement 3 person", achievements[2].playername == "ben");
				assertTrue(section, "Achievement 3 awards", achievements[2].awards == 1);
				assertTrue(section, "Achievement 3 achievement", achievements[2].awarded.achievement == "Super Mega Achievement #1");
				done();
			});
		}
		
		public static function save(done:Function):void {
			
			var section:String = "TestAchievements.save";
			
			var achievement:Object = {
				achievement: "Super Mega Achievement #1",
				achievementkey: "secretkey",
				playerid: rnd.toString(),
				playername: "a random name " + rnd,
				fields: { rnd: rnd }
			};
			
			Achievements.save(achievement, function(r:Response):void {
				assertTrue(section + "#1", "Request succeeded", r.success);
				assertEquals(section + "#1", "No errorcode", r.errorcode, 0);
				
				// second save gets rejected
				Achievements.save(achievement, function(r2:Response):void {
					assertFalse(section + "#2", "Request failed", r2.success);
					assertEquals(section + "#2", "Already had achievement errorcode", r2.errorcode, 505);
					
					// third save overwrites the first
					achievement.overwrite = true;
					
					Achievements.save(achievement, function(r3:Response):void {
						assertTrue(section + "#3", "Request succeeded", r3.success);
						assertEquals(section + "#3", "Already had achievement errorcode", r3.errorcode, 506);
						
						// fourth saves with allow duplicates
						achievement.allowduplicates = true;
						delete achievement.overwrite;
						
						Achievements.save(achievement, function(r4:Response):void {
							assertTrue(section + "#4", "Request succeeded", r4.success);
							assertEquals(section + "#4", "Already had achievement errorcode", r4.errorcode, 506);
							done();
						});
					});
				});
			});
		}
	}
}