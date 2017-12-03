package ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.addons.ui.FlxUIButton;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxAxes;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;
import openfl.Lib;
import openfl.net.URLRequest;
import state.PlayState;
import state.GameOverState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

using flixel.util.FlxSpriteUtil;
using flixel.util.FlxStringUtil;

class InfoScreen extends FlxSpriteGroup
{
	public static inline var OFFSET 			: Int = 10000;
	
	public var _width 							: Int = FlxG.width;
	public var _height							: Int = FlxG.height;

	public var _backgroundSprite 				: FlxSprite;
	
	public var _moneyMountain					: FlxSprite;

	// BUTTONS
	private var _showHumanInfosButton			: FlxUIButton;
	private var _showNewsButton					: FlxUIButton;
	
	private var _levelOfMoney 					: Int = 0;
	
	private var _currentMoney					: Float = Tweaking.PLAYER_START_MONEY;
	
	private var _maxMoneyText					: FlxText;
	private var _currentMoneyText				: FlxText;
	
	private var i 								: Int = 0;
	
	private var _map							: Map<FlxUIButton, Action>;
	
	private var _buttons						: FlxSpriteGroup;
	
	private var _totalElapsedTime				: Float;
	
	private var _totalElapsedTimeText			: FlxText;
	private var _gameOver 						: Bool;

	public function new()
	{
		super();

		this.x = OFFSET;
		
		_backgroundSprite = new FlxSprite(0, 0);
		//_backgroundSprite.makeGraphic(_width, _height, FlxColor.fromRGB(200, 200, 200), false);
		_backgroundSprite.loadGraphic("assets/images/NiceRoom.png", true, 640, 480, true);
		
		_moneyMountain = new FlxSprite(0, Std.int(_height / 1.5));
		_moneyMountain.makeGraphic(Std.int(FlxG.width / 1.5), 50, FlxColor.YELLOW);
		_moneyMountain.screenCenter(FlxAxes.X);
		
		//FlxSpriteUtil.drawRect(_backgroundSprite, _moneyMountain.x - 2, 47, Std.int(_width / 1.5) + 4, Std.int(_height / 1.5) + 4, FlxColor.TRANSPARENT, {thickness : 4, color : FlxColor.WHITE});

		_moneyMountain.height = 50;
		
		_currentMoneyText = new FlxText(50, 5, 0, "CURRENT : " + _currentMoney, 20);
		
		_maxMoneyText = new FlxText(350, 5, 0, "MAX : " + FlxStringUtil.formatMoney(Tweaking.PLAYER_GAME_OVER_MONEY, false), 20);	
		
		_totalElapsedTimeText = new FlxText(550, 5, 0, "", 18);
		
		// Ajout de tout à la fin sinon avec le x = 10000, ça merde le placement
		add(_backgroundSprite);
		
		//add(_moneyMountain);

		add(_maxMoneyText);
		add(_currentMoneyText);
		add(_totalElapsedTimeText);
		
		_map = new Map<FlxUIButton, Action>();
		_buttons = new FlxSpriteGroup();
		_totalElapsedTime = 0;
		_gameOver = false;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (_gameOver)
		{
			// Sinon ça enlève pas tout direct
			for (button in _buttons)
			{
				//trace(button);
				_buttons.remove(button, true);
				FlxTween.tween(button, {y: button.y + 500}, Tweaking.BUTTON_DISPARITION_DURATION, {ease: FlxEase.backInOut, onComplete: function(tween:FlxTween):Void {
					button.destroy();
				}});
			}
		} 
		else 
		{
			_totalElapsedTime += elapsed;
			
			_totalElapsedTimeText.text = FlxStringUtil.formatTime(_totalElapsedTime, true);
			
			// Pour faire accélérer au fur et à mesure
			var accelerationRate:Float = Math.exp(_totalElapsedTime / 30);

			_currentMoney += FlxG.random.floatNormal(Tweaking.MONEY_PER_SECOND * elapsed, 1) * accelerationRate;

			//i++;
			//if (i % 3 == 0) 
			//{
				var fixedFloat = fixedFloat(_currentMoney);
				var string = FlxStringUtil.formatMoney(fixedFloat, false);
				_currentMoneyText.text = "CURRENT : $" + string;
			//}
			
			for (dyn in Action._array) 
			{
				// Pour passer du nombre d'occurences par minute au pourcentage (sur 100%) que ça représente par elapsed
				var chance:Float = (dyn.frequency / 60) * elapsed * 100 * accelerationRate;
				if (FlxG.random.bool(chance))
				{
					createGoodButton(new Action(dyn));
				}
			}
		}
		
		if (_currentMoney >= Tweaking.PLAYER_GAME_OVER_MONEY)
		{
			_currentMoney = 0; // Pour pas le refaire à chaque frame
			_gameOver = true;
			
			var scoreText:FlxText = new FlxText(0, 0, 0, "You survived \n\n\nGood job !", 30);
			scoreText.color = FlxColor.BLACK;
			scoreText.screenCenter();
			scoreText.screenCenter(FlxAxes.X);
			scoreText.alignment = FlxTextAlign.CENTER;
			
			
			var text:String = "Try again!";
			
			var temp = new FlxText(0, 0, 0, text, 20);
			var retryButton = new FlxUIButton(0, 0, text, function():Void {
				FlxG.switchState(new GameOverState());
			});

			retryButton.resize(temp.fieldWidth + 20, 40);
			retryButton.label.size = 20;
			retryButton.screenCenter(FlxAxes.X);
			retryButton.y = scoreText.y + scoreText.height + 20;
			
			add(retryButton);
			add(scoreText);
			
			_totalElapsedTimeText.alignment = FlxTextAlign.CENTER;
			
			new FlxTimer().start(Tweaking.BUTTON_DISPARITION_DURATION, function(timer:FlxTimer):Void {
				FlxTween.tween(_totalElapsedTimeText, {x: OFFSET + _width / 2 - 90, y: scoreText.y + 50, size: 40}, 1, {ease: FlxEase.elasticOut});
				FlxTween.color(_totalElapsedTimeText, 1, FlxColor.WHITE, FlxColor.BLACK, {ease: FlxEase.elasticOut});
			}, 1);
		}
	}
	
	private function OnButtonClicked(button:FlxUIButton):Void
	{
		var action:Action = _map.get(button);
		
		_currentMoney += action._money;  
		
		if (action._money > 0) 
		{
			FlxG.cameras.shake(0.03, 0.2);
		}
		
		FlxTween.tween(button, {y: -1000}, 0.5, {ease: FlxEase.backInOut, onComplete: function(tween:FlxTween):Void {
			_buttons.remove(button, true);
			button.destroy();
		}});
		
		action._sound.play();
		
		FlxMouseEventManager.remove(button);
		
		// Si c'est "acheter notre jeu", gros lol
		if (action._url)
		{
			openfl.Lib.getURL(new URLRequest("https://elryogrande.itch.io/big-mommy-is-watching-over-you"));
		}
	}
	
	public function createGoodButton(action:Action):Void
	{
		var button = new FlxUIButton(0, 0, "");
		
		var text:String = action._description;
		
		var temp = new FlxText(0, 0, 0, text, 14);

		button.resize(temp.fieldWidth + 20, 40);
		button.label.text = text;
		button.label.size = 14;
		button.x = Std.random(Std.int(_width - button.width));
		button.y = Std.random(Std.int(_height - button.height - 30)) + 30 + 1000; // Pour pas poluer là haut
		
		FlxTween.tween(button, {y: button.y - 1000}, 0.5, {ease: FlxEase.backInOut, onComplete: function(tween:FlxTween):Void {
			// On ajoute l'action de cliquer au FlxMouseEventManager (qui permet de récupérer le bouton cliqué)
			FlxMouseEventManager.add(button, OnButtonClicked);
		}});
		
		temp.destroy();
		
		// On map l'action (les infos) du bouton au bouton pour pouvoir le récupérer après
		_map.set(button, action);
	  
		// On ajoute le bouton à un groupe de boutons (pour avoir une idée du nombre de boutons à l'écran surtout)
		_buttons.add(button);
		
		// On ajoute le bouton à la scène
		add(button);
		
		// Timer avant la mort du bouton
		new FlxTimer().start(action._duration, function(timer:FlxTimer):Void {
			FlxTween.tween(button, {y: button.y + 1000}, 0.5, {ease: FlxEase.backInOut, onComplete: function(tween:FlxTween):Void {
				_buttons.remove(button, true);
				button.destroy();
			}});
		}, 1);
	}
	
	// Fonction pompée sur internet pour pouvoir arrondir un chiffre avec le nombre de chiffres après la virgule qu'on veut
	public static function fixedFloat(v:Float, ?precision:Int = 2):Float
	{
		return Math.round( v * Math.pow(10, precision) ) / Math.pow(10, precision);
	}
}