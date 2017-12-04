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
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxShakeEffect;

using flixel.util.FlxStringUtil;

class InfoScreen extends FlxSpriteGroup
{
	public static inline var OFFSET 			: Int = 0;

	public var _width 							: Int = FlxG.width;
	public var _height							: Int = FlxG.height;

	public var _backgroundSprite 				: FlxSprite;

	public var _moneyMountain					: FlxSprite;
	public var _coinSprite						: FlxSprite;
	
	public var _coinFallingSound				: FlxSound;

	private var _levelOfMoney 					: Int = 0;

	private var _currentMoney					: Float = Tweaking.PLAYER_START_MONEY;

	private var _currentMoneyText				: FlxText;
	private var _maxMoneyText					: FlxText;

	private var _mapButtonToAction				: Map<FlxUIButton, Action>;
	private var _mapButtonToSpriteItem			: Map<FlxUIButton, FlxSprite>;
	private var _mapButtonToSpriteCart			: Map<FlxUIButton, FlxSprite>;

	private var _buttons						: FlxSpriteGroup;
	private var _spritesItem					: FlxSpriteGroup;
	private var _spritesCart					: FlxSpriteGroup;
	private var _coins							: FlxSpriteGroup;

	private var _totalElapsedTime				: Float;

	private var _totalElapsedTimeText			: FlxText;
	private var _gameOver 						: Bool;

	private var _gameStarted					: Bool;
	
	private var _cantBuySound					: FlxSound;
	private var _song							: FlxSound;
	
	private var _musicStart						:Bool = false;
	
	private var _numberOfMoneyRefreshPerSecond	: Float = 30;
	private var _timeSinceLastMoneyRefresh		: Float = 0;
	
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
		

		_song = new FlxSound();
		_song = FlxG.sound.load(AssetPaths.mainS__wav);
		
		//FlxSpriteUtil.drawRect(_backgroundSprite, _moneyMountain.x - 2, 47, Std.int(_width / 1.5) + 4, Std.int(_height / 1.5) + 4, FlxColor.TRANSPARENT, {thickness : 4, color : FlxColor.WHITE});
	
		_maxMoneyText = new FlxText(0, 5, 300, " / " + floatToCurrency(Tweaking.PLAYER_GAME_OVER_MONEY, false), 20);
		_maxMoneyText.screenCenter(FlxAxes.X);
		_maxMoneyText.autoSize = false;
		_maxMoneyText.alignment = FlxTextAlign.LEFT;
		_maxMoneyText.x += _maxMoneyText.fieldWidth / 2 - 20;
		_maxMoneyText.borderStyle = FlxTextBorderStyle.SHADOW;
		_maxMoneyText.borderSize = 2;
		//_maxMoneyText.font = "Perfect DOS VGA 437";
		
		//_currentMoneyTextText = new FlxText(50, 5, 0, "MNEY LMIT : ", 20);
		_currentMoneyText = new FlxText(_maxMoneyText.x - 250, 5, 250,  floatToCurrency(_currentMoney, false), 20);
		_currentMoneyText.alignment = FlxTextAlign.RIGHT;
		_currentMoneyText.autoSize = false;
		_currentMoneyText.borderStyle = FlxTextBorderStyle.SHADOW;
		_currentMoneyText.borderSize = 2;
		//_currentMoneyText.font = "Perfect DOS VGA 437";
		
		_totalElapsedTimeText = new FlxText(0, 40, 300, FlxStringUtil.formatTime(0, true), 32);
		_totalElapsedTimeText.screenCenter(FlxAxes.X);
		_totalElapsedTimeText.autoSize = false;
		_totalElapsedTimeText.alignment = FlxTextAlign.CENTER;
		_totalElapsedTimeText.borderStyle = FlxTextBorderStyle.SHADOW;
		_totalElapsedTimeText.borderSize = 3;

		
		// Ajout de tout à la fin sinon avec le x = 10000, ça merde le placement
		add(_backgroundSprite);
		add(_moneyMountain);
		add(_coins);
		//add(_currentMoneyTextText);
		add(_currentMoneyText);
		add(_maxMoneyText);
		add(_totalElapsedTimeText);
		
		_mapButtonToAction = new Map<FlxUIButton, Action>();
		_mapButtonToSpriteItem = new Map<FlxUIButton, FlxSprite>();
		_mapButtonToSpriteCart = new Map<FlxUIButton, FlxSprite>();
		_buttons = new FlxSpriteGroup();
		_spritesItem = new FlxSpriteGroup();
		_spritesCart = new FlxSpriteGroup();
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
		sprite3.borderStyle = FlxTextBorderStyle.SHADOW;
		sprite3.borderSize = 3;
		add(sprite3);
		
		var sprite2 = new FlxText();
		sprite2.screenCenter();
		sprite2.alignment = FlxTextAlign.CENTER;
		sprite2.y = -1000;
		sprite2.x -= 30;
		sprite2.text = "2...";
		sprite2.size = 40;
		sprite2.borderStyle = FlxTextBorderStyle.SHADOW;
		sprite2.borderSize = 3;
		add(sprite2);
		
		var sprite1 = new FlxText();
		sprite1.screenCenter();
		sprite1.alignment = FlxTextAlign.CENTER;
		sprite1.y = -1000;
		sprite1.x -= 30;
		sprite1.text = "1...";
		sprite1.size = 40;
		sprite1.borderStyle = FlxTextBorderStyle.SHADOW;
		sprite1.borderSize = 3;
		add(sprite1);
		
		var spriteBuy = new FlxText();
		spriteBuy.screenCenter();
		spriteBuy.alignment = FlxTextAlign.CENTER;
		spriteBuy.y = -1000;
		spriteBuy.x -= 70;
		spriteBuy.text = "BUY!";
		spriteBuy.size = 60;
		spriteBuy.borderStyle = FlxTextBorderStyle.SHADOW;
		spriteBuy.borderSize = 4;
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
		scoreText.color = FlxColor.WHITE;
		scoreText.screenCenter();
		scoreText.y -= 100;
		scoreText.alignment = FlxTextAlign.CENTER;
		scoreText.x += 1000;
		scoreText.borderStyle = FlxTextBorderStyle.SHADOW;
		scoreText.borderSize = 2;
		
		var goodJobText:FlxText = new FlxText(0, 0, 0, "Good job!", 30);
		goodJobText.color = FlxColor.WHITE;
		goodJobText.screenCenter();
		goodJobText.y = scoreText.y + 110;
		goodJobText.alignment = FlxTextAlign.CENTER;
		goodJobText.x -= 1000;
		goodJobText.borderStyle = FlxTextBorderStyle.SHADOW;
		goodJobText.borderSize = 2;
		
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
			new FlxTimer().start(1, function(timer:FlxTimer):Void {
				_totalElapsedTimeText.borderStyle = FlxTextBorderStyle.OUTLINE_FAST;
			});
			
			FlxTween.tween(_totalElapsedTimeText, {x: OFFSET + _width / 2 - _totalElapsedTimeText.width / 2, y: scoreText.y + 50, size: 40}, 1, {ease: FlxEase.elasticOut, startDelay: 1});
			FlxTween.color(_totalElapsedTimeText, 1, FlxColor.WHITE, FlxColor.WHITE, {ease: FlxEase.elasticOut, startDelay: 1});
			
			FlxTween.tween(_currentMoneyText, {alpha: 0}, 1.5, {ease: FlxEase.quadInOut, startDelay: 1});
			FlxTween.tween(_maxMoneyText, {alpha: 0}, 1.5, {ease: FlxEase.quadInOut, startDelay: 1});
			
			FlxTween.tween(goodJobText, {x: goodJobText.x + 1000}, 1, {ease: FlxEase.elasticOut, startDelay: 2});
			
			FlxTween.tween(retryButton, {alpha: 1, y: retryButton.y - 50}, 1.5, {ease: FlxEase.quadInOut, startDelay: 2.5});
		}, 1);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!_musicStart)
		{
			_musicStart = true;
			_song.play();
		}
		
		if (_gameStarted)
		{
			if (!_gameOver)
			{
				//Start du son
				_coinFallingSound.play();
				
				var randomize = FlxG.random.int(0, 10);
				if (randomize < 3)
				{
					rainingCoin();
				}
				
				FlxG.overlap(_coins, _moneyMountain, CoinBlow);
			}
			

			if (_gameOver)
			{
				_song.stop();
				
				// On le refait sinon ça enlève pas tout direct
				for (button in _buttons)
				{
					_buttons.remove(button, true);
					FlxTween.tween(button, {y: button.y + 500}, Tweaking.BUTTON_DISPARITION_DURATION, {ease: FlxEase.backInOut, startDelay: 1, onComplete: function(tween:FlxTween):Void {
							button.destroy();
						}
					});
				}
				
				for (sprite in _spritesItem)
				{
					_spritesItem.remove(sprite, true);
					FlxTween.tween(sprite, {y: sprite.y + 500}, Tweaking.BUTTON_DISPARITION_DURATION, {ease: FlxEase.backInOut, startDelay: 1, onComplete: function(tween:FlxTween):Void {
							sprite.destroy();
						}
					});
				}
				
				for (sprite in _spritesCart)
				{
					_spritesItem.remove(sprite, true);
					FlxTween.tween(sprite, {y: sprite.y + 500}, Tweaking.BUTTON_DISPARITION_DURATION, {ease: FlxEase.backInOut, startDelay: 1, onComplete: function(tween:FlxTween):Void {
							sprite.destroy();
						}
					});
				}
			}
			else
			{
				_totalElapsedTime += elapsed;
				_timeSinceLastMoneyRefresh += elapsed;
				
				_totalElapsedTimeText.text = FlxStringUtil.formatTime(_totalElapsedTime, true);
				
				// Pour faire accélérer au fur et à mesure
				var accelerationRate:Float = Math.exp(_totalElapsedTime / 50);
				//trace(accelerationRate);
				
				var moneyEarned = Tweaking.MONEY_PER_SECOND * elapsed * accelerationRate;
				//trace(moneyEarned);
				_currentMoney += moneyEarned;
				
				if (_timeSinceLastMoneyRefresh > 1/_numberOfMoneyRefreshPerSecond) 
				{
					_currentMoneyText.text = floatToCurrency(_currentMoney, false);
					_timeSinceLastMoneyRefresh = 0;
				}
				
				for (dyn in Action._array)
				{
					var actionAccelerationRate:Float = Math.exp(_totalElapsedTime / dyn.acceleration);
					
					// Pour passer du nombre d'occurences par minute au pourcentage (sur 100%) que ça représente par elapsed
					var chance:Float = (dyn.frequency / 60) * elapsed * 100 * actionAccelerationRate;
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
		coin.kill();
	}
	
	private function OnButtonClicked(button:FlxUIButton):Void
	{
		var action:Action = _mapButtonToAction.get(button);
		var spriteItem:FlxSprite = _mapButtonToSpriteItem.get(button);
		var spriteCart:FlxSprite = _mapButtonToSpriteCart.get(button);
		
		// Si on peut pas acheter, on remue le bouton et on joue un son
		if (_currentMoney + action._money < 0) 
		{
			_cantBuySound.play();
			
			// TODO: essayer de remplacer par 
			//var effectSprite = new FlxEffectSprite(button);
			//add(effectSprite);
			//
			//var shake = new FlxShakeEffect(10, 0.4);
			//
			//shake.start();
			
			var tweenButton = FlxTween.tween(button, {x: button.x + 10}, 0.03, {type: FlxTween.PINGPONG, ease: FlxEase.circInOut});
			var tweenSprite = FlxTween.tween(spriteItem, {x: spriteItem.x + 10}, 0.03, {type: FlxTween.PINGPONG, ease: FlxEase.circInOut});
			
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
			_buttons.remove(button, true);
			
			// Si c'est "acheter notre jeu", gros lol
			if (action._url)
			{
				// TODO: changer l'url
				openfl.Lib.getURL(new URLRequest("https://itch.io/games/newest"));
			}
			
			var moneyModifText = new FlxText(0, 0, 0, floatToCurrency(action._money, true), 22);
			moneyModifText.color = action._money < 0 ? FlxColor.fromRGB(0, 255, 0) : FlxColor.fromRGB(255, 0, 0);
			moneyModifText.alignment = FlxTextAlign.CENTER;
			moneyModifText.x = -OFFSET + button.x + button.label.fieldWidth / 2 - moneyModifText.fieldWidth / 2;
			moneyModifText.y = button.y;
			moneyModifText.borderStyle = FlxTextBorderStyle.SHADOW;
			moneyModifText.borderSize = 2;
			
			add(moneyModifText);
			
			FlxTween.tween(moneyModifText, {x: _currentMoneyText.x + _currentMoneyText.fieldWidth - moneyModifText.fieldWidth, y: _currentMoneyText.y + 10}, 0.3, {startDelay: 0.3, ease: FlxEase.backInOut, onComplete: function(tween:FlxTween):Void {
				moneyModifText.destroy();
			}});
			
			FlxTween.tween(_currentMoneyText, {size: 30}, 0.1, {startDelay: 0.5, onComplete: function(tween:FlxTween):Void {
				FlxTween.tween(_currentMoneyText, {size: 20}, 0.1, {});
				_currentMoney += action._money;
			}});
			
			button.destroy();
			spriteItem.destroy();
		}
	}
	
	private function rainingCoin():Void
	{
		var randomPos = FlxG.random.int(125, 500);
		var _MycoinSprite = new FlxSprite(randomPos,-10);		
		_MycoinSprite.loadGraphic("assets/images/soloCoin.png", true, 16, 16, true);
		_MycoinSprite.animation.add("Falling", [0, 1, 2, 3, 4, 5, 6], 30, true, false, false);
		_MycoinSprite.animation.play("Falling");
		_MycoinSprite.acceleration.y = 100 + FlxG.random.int(0, 40) - 20;
		_coins.add(_MycoinSprite);
	}
	
	private function updateBackgroundSprite():Void 
	{
		if (_currentMoney < ((Tweaking.PLAYER_GAME_OVER_MONEY / 10) * 1) )
		{
			_moneyMountain.animation.play("Step0");
		}
		else if (_currentMoney < ((Tweaking.PLAYER_GAME_OVER_MONEY / 10) * 2))
		{
			_moneyMountain.animation.play("Step1");
		}
		else if (_currentMoney < ((Tweaking.PLAYER_GAME_OVER_MONEY / 10) * 3))
		{
			_moneyMountain.animation.play("Step2");
		}
		else if (_currentMoney < ((Tweaking.PLAYER_GAME_OVER_MONEY / 10) * 5))
		{
			_moneyMountain.animation.play("Step3");
		}
		else if (_currentMoney <= ((Tweaking.PLAYER_GAME_OVER_MONEY / 10) * 6))
		{
			_moneyMountain.animation.play("Step4");
		}
		else if (_currentMoney <= ((Tweaking.PLAYER_GAME_OVER_MONEY / 10) * 7))
		{
			_moneyMountain.animation.play("Step5");
		}
		else if (_currentMoney <= ((Tweaking.PLAYER_GAME_OVER_MONEY / 10) * 8))
		{
			_moneyMountain.animation.play("Step6");
		}
		else if (_currentMoney <= ((Tweaking.PLAYER_GAME_OVER_MONEY / 10) * 9))
		{
			_moneyMountain.animation.play("Step7");
		}
		else if (_currentMoney <= Tweaking.PLAYER_GAME_OVER_MONEY)
		{
			_moneyMountain.animation.play("Step8");
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
		
		var spriteItem = new FlxSprite(button.x + button.label.fieldWidth - 32 - 20, button.y + 3);
		spriteItem.loadGraphic(action._sprite, false, 32, 32);
		
		FlxTween.tween(spriteItem, {y: spriteItem.y - 1000}, 0.5, {ease: FlxEase.backInOut});	
		
		var spriteCart = new FlxSprite(button.x + 20, button.y + 3);
		spriteCart.loadGraphic(AssetPaths.Car222t2__png, false, 32, 32);
		
		FlxTween.tween(spriteCart, {y: spriteCart.y - 1000}, 0.5, {ease: FlxEase.backInOut});
		
		// On map l'action (les infos) du bouton au bouton pour pouvoir le récupérer après
		_mapButtonToAction.set(button, action);
		_mapButtonToSpriteItem.set(button, spriteItem);
		_mapButtonToSpriteCart.set(button, spriteCart);
		
		// On ajoute le bouton à un groupe de boutons (pour avoir une idée du nombre de boutons à l'écran surtout)
		_buttons.add(button);
		_spritesItem.add(spriteItem);
		_spritesCart.add(spriteCart);
		
		// On ajoute le bouton et le sprite à la scène
		add(button);
		add(spriteItem);
		//add(spriteCart);
		
		// Timer avant la mort du bouton
		new FlxTimer().start(action._duration, function(timer:FlxTimer):Void {
			FlxTween.tween(button, {y: button.y + 1000}, 0.5, {
				ease: FlxEase.backInOut, onComplete: function(tween:FlxTween):Void {
					_buttons.remove(button, true);
					button.destroy();
				}
			});
			FlxTween.tween(spriteItem, {y: spriteItem.y + 1000}, 0.5, {
				ease: FlxEase.backInOut, onComplete: function(tween:FlxTween):Void {
					_spritesItem.remove(spriteItem, true);
					spriteItem.destroy();
				}
			});
			FlxTween.tween(spriteCart, {y: spriteCart.y + 1000}, 0.5, {
				ease: FlxEase.backInOut, onComplete: function(tween:FlxTween):Void {
					_spritesCart.remove(spriteCart, true);
					spriteCart.destroy();
				}
			});
		}, 1);
	}
	
	public static function floatToCurrency(float:Float, isTransaction:Bool):String 
	{
		return (float < 0 ? "-" : (isTransaction ? "+" : "")) + "$" + FlxStringUtil.formatMoney(Math.abs(float), false);
	}
	
	// Fonction pompée sur internet pour pouvoir arrondir un chiffre avec le nombre de chiffres après la virgule qu'on veut
	public static function fixedFloat(v:Float, ?precision:Int = 2):Float
	{
		return Math.round( v * Math.pow(10, precision) ) / Math.pow(10, precision);
	}
}