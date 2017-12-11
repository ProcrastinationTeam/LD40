package source;

//import flixel.FlxSprite;
import haxe.Json;
import source.Utils.Score;
import haxe.Http;

class Leaderboard //extends FlxSprite
{
	private static inline var BASE_URL 				: String = "localhost:8000";
	private static inline var GET_LEADERBOARD		: String = "/leaderboard";
	private static inline var PUT_LEADERBOARD		: String = "/leaderboard";

	public function new() 
	{
		
	}
	
	public static function sendToLeaderboard(nickname:String, timeSurvived:Float):Void
	{
		var data:Score = {name: nickname, time: timeSurvived, date: Date.now()};
		var jsonData:String = Json.stringify(data);
		
		var request = new Http(BASE_URL + GET_LEADERBOARD);
		request.setPostData(jsonData);
		
		request.onData = function(data:String):Void
		{
			// TODO: feedback OK
			//trace(data);
		};
		
		request.onError = function(msg:String):Void
		{
			// TODO: feedback NOT OK
			//trace(msg);
		};
		
		request.request(true);
	}
	
	public static function getLeaderboard():Void
	{
		var request = new Http(BASE_URL);
		
		request.onData = function(data:String):Void
		{
			var scores:Array<Score> = Json.parse(data);

			for (score in scores)
			{
				trace('${score.name} : ${FlxStringUtil.formatTime(score.time, true)}');
			}
		};
		
		request.onError = function(msg:String):Void
		{
			// TODO: feedback NOT OK
			trace(msg);
		};
		
		request.request(false);
	}
}