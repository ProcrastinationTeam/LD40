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
			description : "Vendre sa mère", 					// Texte du bouton					
			money : 1000, 										// Argent que ça donne / enlève (quand c'est négatif, ça enlève, c'est bien)
			duration : 10,										// Durée d'existence du bouton
			frequency : 30,										// Nombre moyen par minute
			url: false,											// Ouvrir page itch.io lol
			sound: AssetPaths.mom__wav,							// Son à jouer
			sprite: AssetPaths.SkyRocket__png		// Sprite à afficher
		}, 
		{
			description : "Acheter un hôpital", 					
			money : -5000,
			duration : 3,
			frequency : 20,
			url: false,
			sound: AssetPaths.hey_you__wav,
			sprite: AssetPaths.SkyRocket__png
				//AssetPaths.duo210_230_250_280_icon__png
		},
		{
			description : "Acheter un Picasso", 					
			money : -20000,
			duration : 2,
			frequency : 15,
			url: false,
			sound: AssetPaths.aaaah__wav,
			sprite: AssetPaths.tableau__png
		},
		{
			description : "Acheter un", 					
			money : -2500, 		//-4.95
			duration : 5,
			frequency : 60,
			url: false,
			sound: AssetPaths.pnj_tabasse__wav,
			sprite: AssetPaths.Tank__png
		},
		{
			description : "Acheter le jeu", 					
			money : -10000,
			duration : 5,
			frequency : 1,
			url: false,
			sound: AssetPaths.youwin__wav,
			sprite: AssetPaths.Yacht__png
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