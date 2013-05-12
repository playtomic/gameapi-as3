package com.playtomic.as3 
{
	public class TestLeaderboards extends Test
	{
		public static var rnd:int;
		
		public static function firstscore(done:Function):void {
			
			var section:String = "TestLeaderboards.newscore";
			
			var score:Object = {
				table: "scores" + rnd,
				name: "person1",
				points: 10000,
				highest: true,
				fields: { 
					rnd: rnd
				}
			}
			
			Leaderboards.save(score, function(r:Response):void {
				
				assertTrue(section + "#1", "Request succeeded", r.success);
				assertEquals(section + "#1", "No errorcode", r.errorcode, 0);
				
				// dupicate score gets rejected
				score.points = 9000;
				
				Leaderboards.save(score, function(r:Response):void {
					
					assertTrue(section + "#2", "Request succeeded", r.success);
					assertEquals(section + "#2", "Rejected duplicate score", r.errorcode, 209);
					
					// better score gets accepted
					score.points = 11000;
					
					Leaderboards.save(score, function(r:Response):void {
						
						assertTrue(section + "#3", "Request succeeded", r.success);
						assertEquals(section + "#3", "No errorcode", r.errorcode, 0);
					
						// score gets allowed
						score.points = 9000;
						score.allowduplicates = true;
						
						Leaderboards.save(score, function(r:Response):void {
							assertTrue(section + "#4", "Request succeeded", r.success);
							assertEquals(section + "#4", "No errorcode", r.errorcode, 0);
							done();
						});
					});
				});
			});
		}
			
		public static function secondscore(done:Function):void {
			
			var section:String = "TestLeaderboards.newscore2";
			
			var score:Object=  {
				name: "person2",
				table: "scores" + rnd,
				points: 20000,
				allowduplicates: true,
				highest: true,
				fields: {
					rnd: rnd
				}
			};
			
			Leaderboards.save(score, function(r:Response):void {
				assertTrue(section, "Request succeeded", r.success);
				assertEquals(section, "No errorcode", r.errorcode, 0);
				done();
			});
		}
		
		public static function highscores(done:Function):void {
			
			var section:String = "TestLeaderboards.highscores";
			
			var list:Object = {
				table: "scores" + rnd,
				highest: true,
				filters: {
					rnd: rnd
				}
			};
			
			Leaderboards.list(list, function(scores:Array, numscores:int, r:Response):void {
				scores = scores || [];
				numscores = numscores || -1;
				
				assertTrue(section, "Request succeeded", r.success);
				assertEquals(section, "No errorcode", r.errorcode, 0);
				assertTrue(section, "Received scores", scores.length > 0);
				assertTrue(section, "Received numscores", numscores > 0);
				if(scores.length > 1) {
					assertTrue(section, "First score is greater than second", scores[0].points > scores[1].points);
				} else {
					assertTrue(section, "First score is greater than second forced failure", false);
				}
				done();
			});
		}
			
		public static function lowscores(done:Function):void {
			
			var section:String = "TestLeaderboards.lowscores";
			
			var list:Object = {
				table: "scores" + rnd,
				lowest: true,
				perpage: 2,
				filters: {
					rnd: rnd
				}
			};
			
			Leaderboards.list(list, function(scores:Array, numscores:int, r:Response):void {
				scores = scores || [];
				numscores = numscores || -1;
				
				assertTrue(section, "Request succeeded", r.success);
				assertEquals(section, "No errorcode", r.errorcode, 0);
				assertTrue(section, "Received scores", scores.length == 2);
				assertTrue(section, "Received numscores", numscores > 0);
				
				if(scores.length > 1) {
					assertTrue(section, "First score is less than second", scores[0].points < scores[1].points);
				} else {
					assertTrue(section, "First score is less than second forced failure", false);
				}
				done();
			});
		}
			
		public static function allscores(done:Function):void {
			
			var section:String = "TestLeaderboards.allscores";
			
			var list:Object = {
				table: "scores"  +rnd,
				perpage: 2,
				mode: "newest"
			};
			
			Leaderboards.list(list, function(scores:Array, numscores:int, r:Response):void {
				scores = scores || [];
				numscores = numscores || -1;
				
				assertTrue(section, "Request succeeded", r.success);
				assertEquals(section, "No errorcode", r.errorcode, 0);
				assertTrue(section, "Received scores", scores.length > 0);
				assertTrue(section, "Received numscores", numscores > 0);
				
				if(scores.length > 1) {
					assertTrue(section, "First score is newer or equal to second", scores[0].date >= scores[1].date);
				} else {
					assertTrue(section, "First score is newer or equal to second forced failure", false);
				}

				done();
			});
		}
	}
}