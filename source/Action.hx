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
			sound: AssetPaths.mom__wav,							// Son à jouer
			sprite: AssetPaths.SkyRocket__png		// Sprite à afficher
		}, 
		{
			description : "BUY", 								// Skyrocket				
			money : -50 * Tweaking.MONEY_MULTIPLIER,
			duration : 3,
			frequency : 20,
			url: false,
			sound: AssetPaths.hey_you__wav,
			sprite: AssetPaths.SkyRocket__png
		},
		{
			description : "BUY", 								// Tank			
			money : -20 * Tweaking.MONEY_MULTIPLIER,
			duration : 2,
			frequency : 15,
			url: false,
			sound: AssetPaths.aaaah__wav,
			sprite: AssetPaths.tableau__png
		},
		{
			description : "BUY", 								// Laptop				
			money : -2.5 * Tweaking.MONEY_MULTIPLIER,
			duration : 5,
			frequency : 30,
			url: false,
			sound: AssetPaths.pnj_tabasse__wav,
			sprite: AssetPaths.Tank__png
		},
		{
			description : "BUY", 								// Yacht
			money : -5 * Tweaking.MONEY_MULTIPLIER,
			duration : 5,
			frequency : 10,
			url: false,
			sound: AssetPaths.youwin__wav,
			sprite: AssetPaths.Yacht__png
		},
		{
			description : "BUY", 								// LE JEU LOL			
			money : -100 * Tweaking.MONEY_MULTIPLIER,
			duration : 5,
			frequency : 1,
			url: false,
			sound: AssetPaths.youwin__wav,
			sprite: AssetPaths.moi__png
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