package ui;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUIButton;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxAxes;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.util.FlxTimer;
import openfl.Lib;
import openfl.net.URLRequest;
import state.MenuState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

using flixel.util.FlxStringUtil;

class InfoScreen extends FlxSpriteGroup
{
	public static inline var OFFSET 			: Int = 0;

	public var _width 							: Int = FlxG.width;
	public var _height							: Int = FlxG.height;

	public var _backgroundSprite 				: FlxSprite;

	public var _moneyMountain					: FlxSprite;
	public var _coinSprite							: FlxSprite;
	
	public var _coinFallingSound				: FlxSound;

	private var _levelOfMoney 					: Int = 0;

	private var _currentMoney					: Float = Tweaking.PLAYER_START_MONEY;

	private var _currentMoneyTextText			: FlxText;
	private var _currentMoneyText				: FlxText;
	private var _maxMoneyText					: FlxText;

	private var _mapButtonToAction				: Map<FlxUIButton, Action>;
	private var _mapButtonToSprite				: Map<FlxUIButton, FlxSprite>;

	private var _buttons						: FlxSpriteGroup;
	private var _spritess						: FlxSpriteGroup;
	private var _coins							: FlxSpriteGroup;

	private var _totalElapsedTime				: Float;

	private var _totalElapsedTimeText			: FlxText;
	private var _gameOver 						: Bool;

	private var _gameStarted					: Bool;
	
	private var _cantBuySound					: FlxSound;

	public function new()
	{
		super();
		
		this.x = OFFSET;
		
		_backgroundSprite = new FlxSprite(0, 0);		
		_backgroundSprite.loadGraphic("assets/images/backgroundRoom.png", true, 640, 480, true);
		
		_moneyMountain = new FlxSprite(37, 230);
		//_moneyMountain = new FlxSprite(0, 0);
		_moneyMountain.loadGraphic("assets/images/Gold.png", true, 640, 480, true);
		
		//a la bourrin les anims
		_moneyMountain.animation.add("Step0", [0], 30, true, false, false);
		_moneyMountain.animation.add("Step1", [1], 30, true, false, false);
		_moneyMountain.animation.add("Step2", [2], 30, true, false, false);
		_moneyMountain.animation.add("Step3", [3], 30, true, false, false);
		_moneyMountain.animation.add("Step4", [4], 30, true, false, false);
		_moneyMountain.animation.add("Step5", [5], 30, true, false, false);
		_moneyMountain.animation.add("Step6", [6], 30, true, false, false);
		_moneyMountain.animation.add("Step7", [7], 30, true, false, false);
		_moneyMountain.animation.add("Step8", [8], 30, true, false, false);
		_moneyMountain.animation.add("Step9", [9], 30, true, false, false);
		
		_moneyMountain.animation.play("Step1");
		
		//_moneyMountain
		
		_moneyMountain.height = 20;
		_moneyMountain.width = 566;
		_moneyMountain.centerOffsets();
		//_moneyMountain.offset.set(5,0 );
		//_moneyMountain.offset.set(40, 0);
		
		
		_coins = new FlxSpriteGroup();
		
		_coinFallingSound = new FlxSound();
		_coinFallingSound = FlxG.sound.load(AssetPaths.midCoin__ogg);
		
		
		
		
		//FlxSpriteUtil.drawRect(_backgroundSprite, _moneyMountain.x - 2, 47, Std.int(_width / 1.5) + 4, Std.int(_height / 1.5) + 4, FlxColor.TRANSPARENT, {thickness : 4, color : FlxColor.WHITE});
	
		
		_currentMoneyTextText = new FlxText(50, 5, 0, "Current : ", 20);
		_currentMoneyText = new FlxText(_currentMoneyTextText.x + _currentMoneyTextText.fieldWidth, 5, 0,  floatToCurrency(_currentMoney, false), 20);
		
		_maxMoneyText = new FlxText(350, 5, 0, "MAX : " + floatToCurrency(Tweaking.PLAYER_GAME_OVER_MONEY, false), 20);
		
		_totalElapsedTimeText = new FlxText(550, 5, 0, "", 18);
		
		// Ajout de tout à la fin sinon avec le x = 10000, ça merde le placement
		add(_backgroundSprite);
		add(_moneyMountain);
		add(_coins);
		add(_currentMoneyTextText);
		add(_currentMoneyText);
		add(_maxMoneyText);
		add(_totalElapsedTimeText);
		
		_mapButtonToAction = new Map<FlxUIButton, Action>();
		_mapButtonToSprite= new Map<FlxUIButton, FlxSprite>();
		_buttons = new FlxSpriteGroup();
		_spritess = new FlxSpriteGroup();
		_totalElapsedTime = 0;
		_gameOver = false;
		
		_cantBuySound = FlxG.sound.load(AssetPaths.pnj_tabasse__wav);
		
		_gameStarted = false;
		playStartingAnimation();
	}
	
	private function playStartingAnimation():Void
	{
		var sprite3 = new FlxText();
		sprite3.screenCenter();
		sprite3.alignment = FlxTextAlign.CENTER;
		sprite3.y = -1000;
		sprite3.x -= 30;
		sprite3.text = "3...";
		sprite3.size = 40;
		add(sprite3);
		
		var sprite2 = new FlxText();
		sprite2.screenCenter();
		sprite2.alignment = FlxTextAlign.CENTER;
		sprite2.y = -1000;
		sprite2.x -= 30;
		sprite2.text = "2...";
		sprite2.size = 40;
		add(sprite2);
		
		var sprite1 = new FlxText();
		sprite1.screenCenter();
		sprite1.alignment = FlxTextAlign.CENTER;
		sprite1.y = -1000;
		sprite1.x -= 30;
		sprite1.text = "1...";
		sprite1.size = 40;
		add(sprite1);
		
		var spriteBuy = new FlxText();
		spriteBuy.screenCenter();
		spriteBuy.alignment = FlxTextAlign.CENTER;
		spriteBuy.y = -1000;
		spriteBuy.x -= 70;
		spriteBuy.text = "BUY!";
		spriteBuy.size = 60;
		add(spriteBuy);
		
		FlxTween.tween(sprite3, {y: -50 + FlxG.height / 2}, 0.5, {ease: FlxEase.backInOut, startDelay: 0, onComplete: function(tween:FlxTween):Void {}});
		FlxTween.tween(sprite3, {y: 1000}, 0.5, {ease: FlxEase.backInOut, startDelay: 0.5, onComplete: function(tween:FlxTween):Void {
			sprite3.destroy();
		}});
		
		FlxTween.tween(sprite2, {y: -50 + FlxG.height / 2}, 0.5, {ease: FlxEase.backInOut, startDelay: 0.5, onComplete: function(tween:FlxTween):Void {}});
		FlxTween.tween(sprite2, {y: 1000}, 0.5, {ease: FlxEase.backInOut, startDelay: 1, onComplete: function(tween:FlxTween):Void {
			sprite2.destroy();
		}});
		
		FlxTween.tween(sprite1, {y: -50 + FlxG.height / 2}, 0.5, {ease: FlxEase.backInOut, startDelay: 1, onComplete: function(tween:FlxTween):Void {}});
		FlxTween.tween(sprite1, {y: 1000}, 0.5, {ease: FlxEase.backInOut, startDelay: 1.5, onComplete: function(tween:FlxTween):Void {
			sprite1.destroy();
		}});
		
		FlxTween.tween(spriteBuy, {y: -50 + FlxG.height / 2}, 0.5, {ease: FlxEase.backInOut, startDelay: 1.5, onComplete: function(tween:FlxTween):Void {}});
		FlxTween.tween(spriteBuy, {y: 1000}, 0.5, {ease: FlxEase.backInOut, startDelay: 2, onComplete: function(tween:FlxTween):Void {
			spriteBuy.destroy();
			_gameStarted = true;
		}});
	}
	
	private function playGameOverAnimation():Void 
	{
		var scoreText:FlxText = new FlxText(0, 0, 0, "You survived", 30);
		scoreText.color = FlxColor.BLACK;
		scoreText.screenCenter();
		scoreText.y -= 100;
		scoreText.alignment = FlxTextAlign.CENTER;
		scoreText.x += 1000;
		
		var goodJobText:FlxText = new FlxText(0, 0, 0, "Good job!", 30);
		goodJobText.color = FlxColor.BLACK;
		goodJobText.screenCenter();
		goodJobText.y = scoreText.y + 110;
		goodJobText.alignment = FlxTextAlign.CENTER;
		goodJobText.x -= 1000;
		
		var text:String = "Try again!";
		
		var temp = new FlxText(0, 0, 0, text, 20);
		var retryButton = new FlxUIButton(0, 0, text, function():Void
		{
			FlxG.switchState(new MenuState());
		});
		
		retryButton.resize(temp.fieldWidth + 20, 40);
		retryButton.label.size = 20;
		retryButton.screenCenter(FlxAxes.X);
		retryButton.y = goodJobText.y + goodJobText.height + 20 + 50;
		retryButton.alpha = 0;
		
		add(scoreText);
		add(goodJobText);
		add(retryButton);
		
		_totalElapsedTimeText.alignment = FlxTextAlign.CENTER;
		
		new FlxTimer().start(Tweaking.BUTTON_DISPARITION_DURATION + 1, function(timer:FlxTimer):Void
		{
			FlxTween.tween(scoreText, {x: scoreText.x - 1000}, 1, {ease: FlxEase.elasticOut});
			
			FlxTween.tween(_totalElapsedTimeText, {x: OFFSET + _width / 2 - 90, y: scoreText.y + 50, size: 40}, 1, {ease: FlxEase.elasticOut, startDelay: 1});
			FlxTween.color(_totalElapsedTimeText, 1, FlxColor.WHITE, FlxColor.BLACK, {ease: FlxEase.elasticOut, startDelay: 1});
			
			FlxTween.tween(_currentMoneyTextText, {alpha: 0}, 1.5, {ease: FlxEase.quadInOut, startDelay: 1});
			FlxTween.tween(_currentMoneyText, {alpha: 0}, 1.5, {ease: FlxEase.quadInOut, startDelay: 1});
			FlxTween.tween(_maxMoneyText, {alpha: 0}, 1.5, {ease: FlxEase.quadInOut, startDelay: 1});
			
			FlxTween.tween(goodJobText, {x: goodJobText.x + 1000}, 1, {ease: FlxEase.elasticOut, startDelay: 2});
			
			FlxTween.tween(retryButton, {alpha: 1, y: retryButton.y - 50}, 1.5, {ease: FlxEase.quadInOut, startDelay: 2.5});
		}, 1);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (_gameStarted)
		{
			//Start du son
			_coinFallingSound.play();
			
			var randomize = FlxG.random.int(0, 10);
			if (randomize < 3)
			{
				rainingCoin();
			}
			
			FlxG.overlap(_coins, _moneyMountain, CoinBlow);
			
			

			if (_gameOver)
			{
				// On le refait sinon ça enlève pas tout direct
				for (button in _buttons)
				{
					_buttons.remove(button, true);
					FlxTween.tween(button, {y: button.y + 500}, Tweaking.BUTTON_DISPARITION_DURATION, {ease: FlxEase.backInOut, startDelay: 1, onComplete: function(tween:FlxTween):Void {
							button.destroy();
						}
					});
				}
				
				for (sprite in _spritess)
				{
					_spritess.remove(sprite, true);
					FlxTween.tween(sprite, {y: sprite.y + 500}, Tweaking.BUTTON_DISPARITION_DURATION, {ease: FlxEase.backInOut, startDelay: 1, onComplete: function(tween:FlxTween):Void {
							sprite.destroy();
						}
					});
				}
			}
			else
			{
				_totalElapsedTime += elapsed;
				
				_totalElapsedTimeText.text = FlxStringUtil.formatTime(_totalElapsedTime, true);
				
				// Pour faire accélérer au fur et à mesure
				var accelerationRate:Float = Math.exp(_totalElapsedTime / 30);
				
				_currentMoney += FlxG.random.floatNormal(Tweaking.MONEY_PER_SECOND * elapsed, 1) * accelerationRate;
				
				_currentMoneyText.text = floatToCurrency(_currentMoney, false);
				
				for (dyn in Action._array)
				{
					// Pour passer du nombre d'occurences par minute au pourcentage (sur 100%) que ça représente par elapsed
					var chance:Float = (dyn.frequency / 60) * elapsed * 100 * (dyn.money > 0 ? accelerationRate : 1);
					if (FlxG.random.bool(chance))
					{
						createGoodButton(new Action(dyn));
					}
				}
				
				// MAJ du tas de pièces
				updateBackgroundSprite();
				
				if (_currentMoney >= Tweaking.PLAYER_GAME_OVER_MONEY)
				{
					_gameOver = true;
					playGameOverAnimation();
				}
			}
		}
	}

	private function CoinBlow(coin:FlxObject, goldMountain:FlxObject):Void
	{
		trace("OVERLAP");
		coin.kill();
	}
	
	private function OnButtonClicked(button:FlxUIButton):Void
	{
		var action:Action = _mapButtonToAction.get(button);
		var sprite:FlxSprite = _mapButtonToSprite.get(button);
		
		// Si on peut pas acheter, on remue le bouton et on joue un son
		if (_currentMoney + action._money < 0) 
		{
			_cantBuySound.play();
			
			var tweenButton = FlxTween.tween(button, {x: button.x + 10}, 0.03, {type: FlxTween.PINGPONG, ease: FlxEase.circInOut});
			var tweenSprite = FlxTween.tween(sprite, {x: sprite.x + 10}, 0.03, {type: FlxTween.PINGPONG, ease: FlxEase.circInOut});
			
			new FlxTimer().start(0.4, function(timer:FlxTimer):Void {
				tweenButton.cancel();
				tweenSprite.cancel();
			});
		}
		else 
		{
			if (action._money > 0)
			{
				FlxG.cameras.shake(0.03, 0.2);
			}
			
			action._sound.play();
			
			FlxMouseEventManager.remove(button);
			
			// Si c'est "acheter notre jeu", gros lol
			if (action._url)
			{
				// TODO: changer l'url
				openfl.Lib.getURL(new URLRequest("https://elryogrande.itch.io/big-mommy-is-watching-over-you"));
			}
			
			var moneyModifText = new FlxText(0, 0, 0, floatToCurrency(action._money, true), 22);
			moneyModifText.color = action._money > 0 ? FlxColor.fromRGB(0, 255, 0) : FlxColor.fromRGB(255, 0, 0);
			moneyModifText.alignment = FlxTextAlign.CENTER;
			moneyModifText.x = -OFFSET + button.x + button.label.fieldWidth / 2 - moneyModifText.fieldWidth / 2;
			moneyModifText.y = button.y;
			
			add(moneyModifText);
			
			FlxTween.tween(moneyModifText, {x: _currentMoneyText.x + _currentMoneyText.fieldWidth - moneyModifText.fieldWidth, y: _currentMoneyText.y + 10}, 0.3, {startDelay: 0.3, ease: FlxEase.backInOut, onComplete: function(tween:FlxTween):Void {
				moneyModifText.destroy();
			}});
			
			FlxTween.tween(_currentMoneyText, {size: 30}, 0.1, {startDelay: 0.5, onComplete: function(tween:FlxTween):Void {
				FlxTween.tween(_currentMoneyText, {size: 20}, 0.1, {});
				_currentMoney += action._money;
			}});
			
			button.destroy();
			sprite.destroy();
		}
	}
	
	private function rainingCoin():Void
	{
		var randomPos = FlxG.random.int(125, 500);
		var _MycoinSprite = new FlxSprite(randomPos,-10);		
		_MycoinSprite.loadGraphic("assets/images/soloCoin.png", true, 16, 16, true);
		_MycoinSprite.animation.add("Falling", [0, 1, 2, 3, 4, 5, 6], 30, true, false, false);
		_MycoinSprite.animation.play("Falling");
		_MycoinSprite.acceleration.y = 100;
		_coins.add(_MycoinSprite);
	}
	
	private function updateBackgroundSprite():Void 
	{
		if (_currentMoney < ((Tweaking.PLAYER_GAME_OVER_MONEY / 10) * 1) )
		{
			_moneyMountain.animation.play("Step0");
		}
		else if (((Tweaking.PLAYER_GAME_OVER_MONEY / 10) * 1) < _currentMoney && _currentMoney < ((Tweaking.PLAYER_GAME_OVER_MONEY / 10) * 2))
		{
			_moneyMountain.animation.play("Step1");
		}
		else if (((Tweaking.PLAYER_GAME_OVER_MONEY / 10) * 2) < _currentMoney && _currentMoney < ((Tweaking.PLAYER_GAME_OVER_MONEY / 10) * 3))
		{
			_moneyMountain.animation.play("Step2");
		}
		else if (((Tweaking.PLAYER_GAME_OVER_MONEY / 10) * 3) < _currentMoney && _currentMoney < ((Tweaking.PLAYER_GAME_OVER_MONEY / 10) * 4))
		{
			_moneyMountain.animation.play("Step3");
		}
		else if (((Tweaking.PLAYER_GAME_OVER_MONEY / 10) * 4) < _currentMoney && _currentMoney < ((Tweaking.PLAYER_GAME_OVER_MONEY / 10) * 5))
		{
			_moneyMountain.animation.play("Step4");
		}
		else if (((Tweaking.PLAYER_GAME_OVER_MONEY / 10) * 5) < _currentMoney && _currentMoney <= ((Tweaking.PLAYER_GAME_OVER_MONEY / 10) * 6))
		{
			_moneyMountain.animation.play("Step5");
		}
		else if (((Tweaking.PLAYER_GAME_OVER_MONEY / 10) * 6) < _currentMoney && _currentMoney <= ((Tweaking.PLAYER_GAME_OVER_MONEY / 10) * 7))
		{
			_moneyMountain.animation.play("Step6");
		}
		else if (((Tweaking.PLAYER_GAME_OVER_MONEY / 10) * 7) < _currentMoney && _currentMoney <= ((Tweaking.PLAYER_GAME_OVER_MONEY / 10) * 8))
		{
			_moneyMountain.animation.play("Step7");
		}
		else if (((Tweaking.PLAYER_GAME_OVER_MONEY / 10) * 8) < _currentMoney && _currentMoney <= ((Tweaking.PLAYER_GAME_OVER_MONEY / 10) * 9))
		{
			_moneyMountain.animation.play("Step8");
		}
		else if (((Tweaking.PLAYER_GAME_OVER_MONEY / 10) * 9) < _currentMoney && _currentMoney <= Tweaking.PLAYER_GAME_OVER_MONEY)
		{
			_moneyMountain.animation.play("Step9");
		}
	}

	public function createGoodButton(action:Action):Void
	{
		var button = new FlxUIButton(0, 0, "");
		
		var text:String = "  " + action._description;
		
		var temp = new FlxText(0, 0, 0, text, 14);
		
		button.resize(temp.fieldWidth + 20 + 32, 40);
		button.label.text = text;
		button.label.size = 14;
		button.label.alignment = FlxTextAlign.LEFT;
		button.x = Std.random(Std.int(_width - button.width));
		button.y = Std.random(Std.int(_height - button.height - 30)) + 30 + 1000; // Pour pas poluer là haut
		
		FlxTween.tween(button, {y: button.y - 1000}, 0.5, {
			ease: FlxEase.backInOut, onComplete: function(tween:FlxTween):Void {
				// On ajoute l'action de cliquer au FlxMouseEventManager (qui permet de récupérer le bouton cliqué)
				FlxMouseEventManager.add(button, OnButtonClicked);
			}
		});
		
		temp.destroy();
		
		var sprite = new FlxSprite(button.x + button.label.fieldWidth - 32 - 16, button.y + 3);
		sprite.loadGraphic(action._sprite, false, 32, 32);
		
		FlxTween.tween(sprite, {y: sprite.y - 1000}, 0.5, {ease: FlxEase.backInOut});
		
		// On map l'action (les infos) du bouton au bouton pour pouvoir le récupérer après
		_mapButtonToAction.set(button, action);
		_mapButtonToSprite.set(button, sprite);
		
		// On ajoute le bouton à un groupe de boutons (pour avoir une idée du nombre de boutons à l'écran surtout)
		_buttons.add(button);
		_spritess.add(sprite);
		
		// On ajoute le bouton et le sprite à la scène
		add(button);
		add(sprite);
		
		// Timer avant la mort du bouton
		new FlxTimer().start(action._duration, function(timer:FlxTimer):Void {
			FlxTween.tween(button, {y: button.y + 1000}, 0.5, {
				ease: FlxEase.backInOut, onComplete: function(tween:FlxTween):Void {
					_buttons.remove(button, true);
					button.destroy();
				}
			});
			FlxTween.tween(sprite, {y: sprite.y + 1000}, 0.5, {
				ease: FlxEase.backInOut, onComplete: function(tween:FlxTween):Void {
					_spritess.remove(button, true);
					sprite.destroy();
				}
			});
		}, 1);
	}
	
	public static function floatToCurrency(float:Float, isTransaction:Bool):String 
	{
		return (float < 0 ? "-" : (isTransaction ? "+" : "")) + "$" + FlxStringUtil.formatMoney(fixedFloat(Math.abs(float)), false);
	}
	
	// Fonction pompée sur internet pour pouvoir arrondir un chiffre avec le nombre de chiffres après la virgule qu'on veut
	public static function fixedFloat(v:Float, ?precision:Int = 2):Float
	{
		return Math.round( v * Math.pow(10, precision) ) / Math.pow(10, precision);
	}
}