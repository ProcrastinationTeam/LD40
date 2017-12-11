package source;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import haxe.Json;
import source.Utils.Score;
import haxe.Http;
import flixel.FlxG;
import flixel.util.FlxStringUtil;
import flixel.addons.ui.FlxUIButton;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import haxe.ds.ArraySort;
import flixel.addons.ui.FlxInputText;
import flixel.util.FlxColor;

class Leaderboard extends FlxSpriteGroup
{
	private static inline var BASE_URL 				: String = "localhost:8000";
	private static inline var GET_LEADERBOARD		: String = "/leaderboard";
	private static inline var PUT_LEADERBOARD		: String = "/leaderboard";
	
	private var _timeSurvived						: Float;
	
	private var _nicknameTextField					: FlxInputText;
	
	private var _backgroundSprite 					: FlxSprite;

	public function new(timeSurvived:Float)
	{
		super(0, 0);
		
		_backgroundSprite = new FlxSprite(50, 75);
		_backgroundSprite.makeGraphic(Std.int(FlxG.width) - 50 - 50, Std.int(FlxG.height) - 75 - 125, FlxColor.fromRGB(120, 120, 120, 120));
		
		add(_backgroundSprite);
		
		_timeSurvived = timeSurvived;
		
		_nicknameTextField = new FlxInputText(65, FlxG.height - 175, 320, "", 26);
		_nicknameTextField.maxLength = 16;
		_nicknameTextField.callback = function(str:String, str2:String):Void
		{
			trace(str);
			trace(str2);
		};
		add(_nicknameTextField);
		
		var nicknameExplicationText = new FlxText(_nicknameTextField.x, _nicknameTextField.y - 45, 0, "Nickname:", 30);
		nicknameExplicationText.borderStyle = FlxTextBorderStyle.SHADOW;
		nicknameExplicationText.borderSize = 3;
		add(nicknameExplicationText);
		
		//
		var text = "Send time";
		var size = 20;
		
		var temp = new FlxText(0, 20, 0, text, size);
		
		var sendToLeaderboardButton = new FlxUIButton(_nicknameTextField.x + _nicknameTextField.width + 35, _nicknameTextField.y - 3, text, function():Void
		{
			sendToLeaderboard("bite", _timeSurvived);
		});
		
		sendToLeaderboardButton.label.size = size;
		sendToLeaderboardButton.resize(temp.fieldWidth + 20, 40);
		
		add(sendToLeaderboardButton);
		

		
		getLeaderboard();
	}
	
	public function sendToLeaderboard(nickname:String, timeSurvived:Float):Void
	{
		var data:Score = {name: nickname, time: timeSurvived, date: Date.now().getTime()};
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
	
	public function getLeaderboard():Void
	{
		var request = new Http(BASE_URL);
		
		request.onData = function(data:String):Void
		{
			var scores:Array<Score> = Json.parse(data);

			trace("unsorted");
			for (score in scores)
			{
				trace('${score.name} : ${FlxStringUtil.formatTime(score.time, true)}');
			}
			
			ArraySort.sort(scores, function(scoreA:Score, scoreB:Score): Int {
				// For same time (unlikely), sort by date of score
				if (scoreA.time == scoreB.time)
				{
					return scoreA.date < scoreB.date ? -1 : 1;
				} 
				else 
				{
					// Otherwise, longest time wins
					return scoreA.time > scoreB.time ? -1 : 1;
				}
			});
			
			trace("sorted");
			var i = 0;
			for (score in scores)
			{
				var message = '[${i + 1}] ${score.name} : ${FlxStringUtil.formatTime(score.time, true)}';
				trace(message);
				
				if (i < 5) 
				{
					var positionClassement = new FlxText(_backgroundSprite.x + 15, _backgroundSprite.y + 10 + 30 * i, 0, '${i + 1}', 24);
					positionClassement.color = FlxColor.WHITE;
					positionClassement.alignment = FlxTextAlign.LEFT;
					positionClassement.borderStyle = FlxTextBorderStyle.SHADOW;
					positionClassement.borderSize = 3;
					positionClassement.fieldWidth = 40; 
					add(positionClassement);
					
					var nickname = new FlxText(positionClassement.x + positionClassement.fieldWidth + 10, positionClassement.y, 0, '${score.name}', 24);
					nickname.color = FlxColor.WHITE;
					nickname.alignment = FlxTextAlign.LEFT;
					nickname.borderStyle = FlxTextBorderStyle.SHADOW;
					nickname.borderSize = 3;
					nickname.fieldWidth = 325;
					add(nickname);
					
					var time = new FlxText(nickname.x + nickname.fieldWidth + 10, positionClassement.y, 0, '${FlxStringUtil.formatTime(score.time, true)}', 24);
					time.color = FlxColor.WHITE;
					time.alignment = FlxTextAlign.RIGHT;
					time.borderStyle = FlxTextBorderStyle.SHADOW;
					time.borderSize = 3;
					time.fieldWidth = 125;
					add(time);
				}
				
				i++;
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