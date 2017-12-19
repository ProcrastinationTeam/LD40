package source;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUIButton;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.Http;
import haxe.Json;
import haxe.ds.ArraySort;
import source.Utils.Score;
import flixel.tweens.FlxEase;
import flixel.util.FlxStringUtil;
import flixel.util.FlxAxes;

class Leaderboard extends FlxSpriteGroup
{
	private static inline var BASE_URL 				: String 			= "localhost:8000";
	private static inline var GET_LEADERBOARD		: String 			= "/leaderboard";
	private static inline var PUT_LEADERBOARD		: String 			= "/leaderboard";
	
	private var _nicknameExplicationText 			: FlxText;
	private var _nicknameTextField					: FlxInputText;
	private var _sendToLeaderboardButton			: FlxUIButton;
	
	private var _backgroundSprite 					: FlxSprite;
	
	private var _scoreSent							: Bool 				= false;
	
	private var _scoreLines							: FlxSpriteGroup 	= new FlxSpriteGroup();

	public function new(timeSurvived:Float)
	{
		super(0, 0);
		
		_backgroundSprite = new FlxSprite(50, 75);
		_backgroundSprite.makeGraphic(Std.int(FlxG.width) - 50 - 50, Std.int(FlxG.height) - 75 - 125, FlxColor.fromRGB(120, 120, 120, 120));
		
		add(_backgroundSprite);
		
		_nicknameTextField = new FlxInputText(65, FlxG.height - 175, 320, "", 26);
		_nicknameTextField.maxLength = 16;
		_nicknameTextField.callback = function(currentText:String, action:String):Void
		{
			//trace(currentText);
			//trace(action); // "input" / "backspace"	/ "delete"
		};
		add(_nicknameTextField);
		
		_nicknameExplicationText = new FlxText(_nicknameTextField.x, _nicknameTextField.y - 45, 0, "Nickname:", 30);
		_nicknameExplicationText.borderStyle = FlxTextBorderStyle.SHADOW;
		_nicknameExplicationText.borderSize = 3;
		add(_nicknameExplicationText);
		
		//
		var text = "Send time";
		var size = 20;
		
		var temp = new FlxText(0, 20, 0, text, size);
		
		_sendToLeaderboardButton = new FlxUIButton(_nicknameTextField.x + _nicknameTextField.width + 35, _nicknameTextField.y - 3, text, function():Void
		{
			sendToLeaderboard(_nicknameTextField.text, timeSurvived);
		});
		
		_sendToLeaderboardButton.label.size = size;
		_sendToLeaderboardButton.resize(temp.fieldWidth + 20, 40);
		
		add(_sendToLeaderboardButton);
		
		add(_scoreLines);
		
		getLeaderboard();
	}
	
	public function sendToLeaderboard(nickname:String, timeSurvived:Float):Void
	{
		nickname = StringTools.trim(nickname);
		nickname = StringTools.replace(nickname, ";", "");
		
		if (nickname.length > 0) 
		{
			var data:Score = {name: nickname, time: timeSurvived, date: Date.now().getTime()};
			var jsonData:String = Json.stringify(data);
			
			var request = new Http(BASE_URL + GET_LEADERBOARD);
			request.setPostData(jsonData);
			
			request.onData = function(data:String):Void
			{
				// TODO: feedback OK
				//trace(data);
				_scoreSent = true;
				
				_nicknameExplicationText.destroy();
				_nicknameTextField.destroy();
				_sendToLeaderboardButton.destroy();
				
				var scoreSentText = new FlxText(0, FlxG.height - 225, 0, "Score sent!", 40);
				scoreSentText.color = FlxColor.GREEN;
				scoreSentText.borderStyle = FlxTextBorderStyle.SHADOW;
				scoreSentText.borderSize = 2;
				scoreSentText.color = FlxColor.fromRGB(0, 250, 0);
				scoreSentText.screenCenter(FlxAxes.X);
				add(scoreSentText);
				
				getLeaderboard();
			};
			
			request.onError = function(msg:String):Void
			{
				// TODO: feedback NOT OK
				//trace(msg);
			};
			
			request.request(true);
		}
		else 
		{
			var tween = FlxTween.tween(_nicknameTextField, {x: _nicknameTextField.x + 10}, 0.03, {type: FlxTween.PINGPONG, ease: FlxEase.circInOut});
			
			new FlxTimer().start(0.4, function(timer:FlxTimer):Void {
				tween.cancel();
			});
		}
	}
	
	public function getLeaderboard():Void
	{
		_scoreLines.forEach(function(sprite:FlxSprite):Void {
			_scoreLines.remove(sprite);
			sprite.destroy();
		});
		
		var request = new Http(BASE_URL);
		
		request.onData = function(data:String):Void
		{
			var scores:Array<Score> = Json.parse(data);
			
			trace("unsorted");
			for (score in scores)
			{
				trace(score);
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
					_scoreLines.add(positionClassement);
					
					var nickname = new FlxText(positionClassement.x + positionClassement.fieldWidth + 10, positionClassement.y, 0, '${score.name}', 24);
					nickname.color = FlxColor.WHITE;
					nickname.alignment = FlxTextAlign.LEFT;
					nickname.borderStyle = FlxTextBorderStyle.SHADOW;
					nickname.borderSize = 3;
					nickname.fieldWidth = 325;
					_scoreLines.add(nickname);
					
					var time = new FlxText(nickname.x + nickname.fieldWidth + 10, positionClassement.y, 0, '${FlxStringUtil.formatTime(score.time, true)}', 24);
					time.color = FlxColor.WHITE;
					time.alignment = FlxTextAlign.RIGHT;
					time.borderStyle = FlxTextBorderStyle.SHADOW;
					time.borderSize = 3;
					time.fieldWidth = 125;
					_scoreLines.add(time);
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