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

using flixel.util.FlxSpriteUtil;

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
	
	private var _maxMoney						: Float = 200000;
	private var _money							: Float = 100000;
	
	private var _maxMoneyText					: FlxText;
	private var _moneyText						: FlxText;
	
	private var i 								: Int = 0;
	
	private var _map							: Map<FlxUIButton, Action>;
	
	private var _random							: FlxRandom;
	
	private var _buttons						: FlxGroup;
	
	private var _totalElapsedTime					: Float;

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
		
		_maxMoneyText = new FlxText(20, 20, 0, "MAX : " + _maxMoney, 20);	
		
		_moneyText = new FlxText(20, 120, 0, "CURRENT : " + _money, 20);
		
		// Ajout de tout à la fin sinon avec le x = 10000, ça merde le placement
		add(_backgroundSprite);
		
		//add(_moneyMountain);

		add(_maxMoneyText);
		add(_moneyText);
		
		_map = new Map<FlxUIButton, Action>();
		
		_random = new FlxRandom();
		
		_buttons = new FlxGroup();
		
		_totalElapsedTime = 0;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		_totalElapsedTime += elapsed;

		_money += Std.random(150);

		i++;
		if (i % 3 == 0) 
		{
			_moneyText.text = "CURRENT : " + fixedFloat(_money);
		}
		
		if (FlxG.keys.justPressed.A) 
		{
			//createGoodButton();
		}
		
		if (_random.float() > 0.98) 
		{
			//createGoodButton();
		}
		
		for (dyn in Action._array) 
		{
			// Pour passer du nombre d'occurences par minute au pourcentage (sur 100%) que ça représente par elapsed
			var chance:Float = (dyn.frequency / 60) * elapsed * 100;
			if (FlxG.random.bool(chance))
			{
				createGoodButton(new Action(dyn));
			}
		}
	}
	
	private function OnButtonClicked(button:FlxUIButton):Void
	{
		var action:Action = _map.get(button);
		
		_money += action._money;    
		button.destroy();
		
		// TODO: effet kisscool
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
		button.y = Std.random(Std.int(_height - button.height));
		
		temp.destroy();
		
		// DEBUG
		//button.color = value < 0 ? FlxColor.RED : FlxColor.GREEN;
		
		// On map l'action (les infos) du bouton au bouton pour pouvoir le récupérer après
		_map.set(button, action);
	  
		// On ajoute l'action de cliquer au FlxMouseEventManager (qui permet de récupérer le bouton cliqué)
		FlxMouseEventManager.add(button, OnButtonClicked);
		
		// On ajoute le bouton à un groupe de boutons (pour avoir une idée du nombre de boutons à l'écran surtout)
		_buttons.add(button);
		
		// On ajoute le bouton à la scène
		add(button);
		
		// Timer avant la mort du bouton
		new FlxTimer().start(action._duration, function(timer:FlxTimer):Void {
			_buttons.remove(button, true);
			button.destroy();
			
			// TODO: effet kisscool
		}, 1);
	}
	
	// Fonction pompée sur internet pour pouvoir arrondir un chiffre avec le nombre de chiffres après la virgule qu'on veut
	public static function fixedFloat(v:Float, ?precision:Int = 2):Float
	{
		return Math.round( v * Math.pow(10, precision) ) / Math.pow(10, precision);
	}
}