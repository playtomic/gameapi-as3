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
		
		public static function friendsscores(done:Function):void {
			
			var section:String = "TestLeaderboards.friendsscores";
			var playerids:Array = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
			var points:int = 0;
			
			function nextPlayerId():void
			{			
				points += 1000;
				var playerid:String = playerids.shift();
				
				var score:Object=  {
					name: "playerid" + playerid,
					playerid: playerid,
					table: "friends" + rnd,
					points: points,
					highest: true,
					fields: {
						rnd: rnd
					}
				};
				
				Leaderboards.save(score, function(r:Response):void {
					if(playerids.length > 0)
					{
						nextPlayerId();
					} 
					else 
					{
						var list:Object = {
							table: "friends" + rnd,
							perpage: 3,
							friendslist: ["1", "2", "3"]
						};
						
						Leaderboards.list(list, function(scores:Array, numscores:int, r:Response):void {
							scores = scores || [];
							numscores = numscores || -1;
							
							assertTrue(section, "Request succeeded", r.success);
							assertEquals(section, "No errorcode", r.errorcode, 0);
							assertTrue(section, "Received 3 scores", scores.length == 3);
							assertTrue(section, "Received numscores 3", numscores == 3);
							assertTrue(section, "Player id #1", scores[0].playerid == "3");
							assertTrue(section, "Player id #2", scores[1].playerid == "2");
							assertTrue(section, "Player id #3", scores[2].playerid == "1");
							
							done();
						});
					}
				});
			}
			
			nextPlayerId();
		}
		
		public static function ownscores(done:Function):void {
			
			var section:String = "TestLeaderboards.ownscores";
			var points:int = 0;
			var saved:int = 0;
			
			function nextPlayerId():void
			{			
				points += 1000;
				saved++;
				
				var score:Object=  {
					name: "test account",
					playerid: "test@testuri.com",
					table: "personal" + rnd,
					points: points,
					highest: true,
					allowduplicates: true,
					fields: {
						rnd: rnd
					}
				};
				
				Leaderboards.save(score, function(r:Response):void {
					if(saved < 9)
					{
						nextPlayerId();
					} 
					else 
					{
						var finalscore:Object=  {
							name: "test account",
							playerid: "test@testuri.com",
							table: "personal" + rnd,
							points: 3000,
							highest: true,
							allowduplicates: true,
							fields: {
								rnd: rnd
							},
							perpage: 5
						};
						
						Leaderboards.saveAndList(finalscore, function(scores:Array, numscores:int, r:Response):void {
							scores = scores || [];
							numscores = numscores || -1;
							
							assertTrue(section, "Request succeeded", r.success);
							assertEquals(section, "No errorcode", r.errorcode, 0);
							assertTrue(section, "Received 5 scores", scores.length == 5);
							assertTrue(section, "Received numscores 10", numscores == 10);
							assertTrue(section, "Score 1 ranked 6", scores[0].rank == 6);
							assertTrue(section, "Score 2 ranked 7", scores[1].rank == 7);
							assertTrue(section, "Score 3 ranked 8", scores[2].rank == 8);
							assertTrue(section, "Score 4 ranked 9", scores[3].rank == 9);
							assertTrue(section, "Score 5 ranked 10", scores[4].rank == 10);
							assertTrue(section, "Score 1 points", scores[0].points == 4000);
							assertTrue(section, "Score 2 points", scores[1].points == 3000);
							assertTrue(section, "Score 3 points", scores[2].points == 3000);
							assertTrue(section, "Score 4 points", scores[3].points == 2000);
							assertTrue(section, "Score 5 points", scores[4].points == 1000);
							done();
						});
					}
				});
			}
			
			nextPlayerId();
		}
	}
}