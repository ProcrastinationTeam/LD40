package;

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
	
	public static var _array 					: Array<Dynamic> = [
		{
			description : "Vendre sa mère", 	// Texte du bouton					
			money : 10, 						// Argent que ça donne / enlève (quand c'est négatif, ça enlève, c'est bien)
			duration : 10,						// Durée d'existence du bouton
			frequency : 30,						// Nombre moyen par minute
			url: false,							// Ouvrir page itch.io lol
			sound: AssetPaths.mom__wav
		}, 
		{
			description : "Acheter un hôpital", 					
			money : -20000,
			duration : 3,
			frequency : 20,
			url: false,
			sound: AssetPaths.hey_you__wav
		},
		{
			description : "Acheter un Picasso", 					
			money : -200000,
			duration : 2,
			frequency : 15,
			url: false,
			sound: AssetPaths.aaaah__wav
		},
		{
			description : "Acheter des bonbons", 					
			money : -4.95,
			duration : 5,
			frequency : 60,
			url: false,
			sound: AssetPaths.pnj_tabasse__wav
		},
		{
			description : "Acheter le jeu", 					
			money : -100000,
			duration : 5,
			frequency : 1,
			url: false,
			sound: AssetPaths.youwin__wav
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
	}
}