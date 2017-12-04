package;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.system.FlxSound;
import flixel.FlxG;

class Action 
{
	public var _description 			: String;
	public var _money					: Float;
	public var _duration				: Float;
	public var _frequency				: Float;
	public var _url						: Bool;
	public var _sound					: FlxSound;
	public var _sprite					: FlxGraphicAsset;
	
	public static var _array 					: Array<Dynamic> = [
		{
			description : "SELL", 								// Texte du bouton					
			money : 2 * Tweaking.MONEY_MULTIPLIER, 				// Argent que ça donne / enlève (quand c'est négatif, ça enlève, c'est bien)
			duration : 10,										// Durée d'existence du bouton
			frequency : 30,										// Nombre moyen par minute
			url: false,											// Ouvrir page itch.io lol

			sound: AssetPaths.nope__ogg,							// Son à jouer
			sprite: AssetPaths.SkyRocket__png,		// Sprite à afficher
				// Sprite à afficher
			acceleration: 50									// Acceleration
		}, 
		{
			description : "BUY", 								// Skyrocket				
			money : -50 * Tweaking.MONEY_MULTIPLIER,
			duration : 3,
			frequency : 20,
			url: false,

			sound: AssetPaths.cool__ogg,
			sprite: AssetPaths.SkyRocket__png,
			acceleration: 50

		},
		{
			description : "BUY", 								// Tank			
			money : -20 * Tweaking.MONEY_MULTIPLIER,
			duration : 2,
			frequency : 15,
			url: false,
			sound: AssetPaths.cool__ogg,
			sprite: AssetPaths.tableau__png,

			acceleration: 50

		},
		{
			description : "BUY", 								// Laptop				
			money : -2.5 * Tweaking.MONEY_MULTIPLIER,
			duration : 5,
			frequency : 30,
			url: false,

			sound: AssetPaths.cool__ogg,
			sprite: AssetPaths.Tank__png,		
			acceleration: 50

		},
		{
			description : "BUY", 								// Yacht
			money : -5 * Tweaking.MONEY_MULTIPLIER,
			duration : 5,
			frequency : 10,
			url: false,

			sound: AssetPaths.cool__ogg,
			sprite: AssetPaths.Yacht__png,
			acceleration: 50

		},
		{
			description : "BUY", 								// LE JEU LOL			
			money : -100 * Tweaking.MONEY_MULTIPLIER,
			duration : 5,
			frequency : 1,

			url: true,
			sound: AssetPaths.cool__ogg,
			sprite: AssetPaths.moi__png,
			acceleration: 50
		},
		{
			description : "BUY", 								// Skyrocket				
			money : -50 * Tweaking.MONEY_MULTIPLIER,
			duration : 3,
			frequency : 20,
			url: false,
			sound: AssetPaths.aaaah__wav,
			sprite: AssetPaths.misterBelly__png,
			acceleration : 50
		},
	];

	public function new(?dyn:Dynamic) 
	{
		var infos:Dynamic;
		
		if (dyn == null) 
		{
			infos = _array[Std.random(_array.length)];
		}
		else 
		{
			infos = dyn;
		}
		
		_description = infos.description;
		_money = infos.money;
		_duration = infos.duration;
		_frequency = infos.frequency;
		_url = infos.url;
		_sound = FlxG.sound.load(infos.sound);
		_sprite = infos.sprite;
	}
}