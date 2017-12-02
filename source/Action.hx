package;

class Action 
{
	public var _description 			: String;
	public var _money					: Float;
	public var _duration				: Float;
	public var _frequency				: Float;
	
	public static var _array 					: Array<Dynamic> = [
		{
			description : "Vendre sa mère", 	// Texte du bouton					
			money : 100000, 					// Argent que ça donne / enlève (quand c'est négatif, ça enlève, c'est bien)
			duration : 10,						// Durée d'existence du bouton
			frequency : 30						// Nombre moyen par minute
		}, 
		{
			description : "Acheter un hôpital", 					
			money : -20000,
			duration : 3,
			frequency : 20
		},
		{
			description : "Acheter un Picasso", 					
			money : -200000,
			duration : 2,
			frequency : 15
		},
		{
			description : "Acheter des bonbons", 					
			money : -4.95,
			duration : 5,
			frequency : 60
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
	}
}