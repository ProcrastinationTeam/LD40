package client;

import client.Tweaking;
import client.assetspath.SoundAssetsPaths;
import client.assetspath.ImageAssetsPath;
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
	public var _isBuy					: Bool;
	
	public static var _array 					: Array<Dynamic> = [
		{
			description : "SELL", 								// Skyrocket (Texte du bouton)
			money : 2 * client.Tweaking.MONEY_MULTIPLIER, 				// Argent que ça donne / enlève (quand c'est négatif, ça enlève, c'est bien)
			duration : 7,										// Durée d'existence du bouton
			frequency : 30,										// Nombre moyen par minute
			url: false,											// Ouvrir page itch.io lol
			sound: SoundAssetsPaths.nope__wav,					// Son à jouer
			sprite: ImageAssetsPath.SkyRocket__png,				// Sprite à afficher
			acceleration: 50									// Acceleration
		}, 
		//{
			//description : "BUY", 								// 				
			//money : 50 * Tweaking.MONEY_MULTIPLIER,
			//duration : 3,
			//frequency : 20,
			//url: false,
			//sound: SoundAssetPaths.cool__wav,
			//sprite: AssetPaths.SkyRocket__png,
			//acceleration: 50
		//},
		{
			description : "BUY", 								// Tableau			
			money : 5 * client.Tweaking.MONEY_MULTIPLIER,
			duration : 2,
			frequency : 15,
			url: false,
			sound: SoundAssetsPaths.cool__wav,
			sprite: ImageAssetsPath.tableau__png,
			acceleration: 40
		},
		{
			description : "BUY", 								// Tank				
			money : 10 * client.Tweaking.MONEY_MULTIPLIER,
			duration : 5,
			frequency : 10,
			url: false,
			sound: SoundAssetsPaths.cool__wav,
			sprite: ImageAssetsPath.Tank__png,		
			acceleration: 30
		},
		{
			description : "BUY", 								// Yacht
			money : 2 * client.Tweaking.MONEY_MULTIPLIER,
			duration : 5,
			frequency : 30,
			url: false,
			sound: SoundAssetsPaths.cool__wav,
			sprite: ImageAssetsPath.Yacht__png,
			acceleration: 50
		},
		{
			description : "BUY", 								// LE JEU LOL			
			money : 1 * client.Tweaking.MONEY_MULTIPLIER,
			duration : 5,
			frequency : 30,
			url: true,
			sound: SoundAssetsPaths.cool__wav,
			sprite: ImageAssetsPath.moi__png,
			acceleration: 50
		},
		{
			description : "BUY", 								// MisterBelly				
			money : 15 * client.Tweaking.MONEY_MULTIPLIER,
			duration : 3,
			frequency : 15,
			url: false,
			sound: SoundAssetsPaths.aaaah__wav,
			sprite: ImageAssetsPath.misterBelly__png,
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
		_isBuy = FlxG.random.bool(client.Tweaking.BUY_PERCENT);
	}
}