package state;

import assetspath.MusicAssetsPath;
import assetspath.SoundAssetsPaths;
import flixel.FlxCamera;
import flixel.FlxState;
import ui.InfoScreen;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.system.FlxSound;
import Tweaking;

class PlayState extends FlxState
{
	private var _infoScreen				: InfoScreen;
	
	public var _totalElapsedTime		: Float 		= 0;
	public var _currentMoney			: Float 		= Tweaking.PLAYER_START_MONEY;
	
	public var _gameStarted				: Bool 			= false;
	public var _gameOver 				: Bool 			= false;
	
	public var _backgroundMusic			: FlxSound;
	public var _buySound				: FlxSound;
	public var _cantBuySound			: FlxSound;
	public var _sellSound				: FlxSound;
	
	override public function create():Void
	{
		super.create();
		
		_backgroundMusic = FlxG.sound.load(MusicAssetsPath.mainS__wav, 1, true);
		_buySound = FlxG.sound.load(SoundAssetsPaths.cool__wav);
		_cantBuySound = FlxG.sound.load(SoundAssetsPaths.nope__wav);
		_sellSound = FlxG.sound.load(SoundAssetsPaths.pnj_tabasse__wav);
		
		_infoScreen = new InfoScreen(this);
		add(_infoScreen);
		
		FlxG.camera.fade(FlxColor.BLACK, .1, true);
		
		#if mobile
		FlxG.mouse.visible = false;
		#end
		
		_backgroundMusic.play();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		#if debug 
		#if FLX_KEYBOARD
		if (FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.L)
		{
			_currentMoney = Tweaking.PLAYER_GAME_OVER_MONEY;
		}
		#end
		#end
		
		if (_gameStarted)
		{
			if (FlxG.random.bool(30))
			{
				_infoScreen.rainingCoin();
			}
				
			if (!_gameOver)
			{
				_totalElapsedTime += elapsed;
				
				// Pour faire accélérer au fur et à mesure
				var accelerationRate:Float = Math.exp(_totalElapsedTime / Tweaking.MONEY_ACCELERATION_RATE);
				
				var moneyEarned = Tweaking.MONEY_PER_SECOND * elapsed * accelerationRate;
				_currentMoney += moneyEarned;
				
				// On choisit ce qu'on va faire spawn
				for (dyn in Action._array)
				{
					var actionAccelerationRate:Float = Math.exp(_totalElapsedTime / dyn.acceleration);
					
					// Pour passer du nombre d'occurences par minute au pourcentage (sur 100%) que ça représente par elapsed
					var chance:Float = (dyn.frequency / 60) * elapsed * 100 * actionAccelerationRate;
					if (FlxG.random.bool(chance))
					{
						_infoScreen.createGoodButton(new Action(dyn));
					}
				}
				
				// MAJ diverses et overlap
				_infoScreen.updateInfoScreen();
				
				// MAJ du tas de pièces
				_infoScreen.updateBackgroundSprite();
				
				if (_currentMoney >= Tweaking.PLAYER_GAME_OVER_MONEY)
				{
					_gameOver = true;
					_infoScreen.playGameOverAnimation();
				}
			}
			else
			{
				// On le refait sinon ça enlève pas tout direct
				_infoScreen.cleanSpritesAfterGameOver();
			}
		}
	}
}