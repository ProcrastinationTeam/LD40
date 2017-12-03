package state;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxAxes;

class GameOverState extends FlxState 
{
	private var _title					: FlxText;
	private var _alphaModifier 			: Float;
	private var _startDisplay 			: FlxText;
	private var _credit 				: FlxText;
	private var _moreCredit 			: FlxText;
	
	override public function create():Void
	{
		bgColor = 0xFF000000;
		
		_title = new FlxText(0, 0, 0, "Not Human Harvest", 64, true);
		_title.screenCenter();
		_title.y -= 100;
		add(_title);
		
		_startDisplay = new FlxText(0, 0, 0, "Click or press SPACE to start", 18, true);
		_startDisplay.screenCenter();
		add(_startDisplay);

		_credit = new FlxText(0, 0, 0, "A stupid game by Lucas Tixier & Guillaume Ambrois", 12, true);
		_credit.screenCenter(FlxAxes.X);
		_credit.y = FlxG.height - 150;
		add(_credit);

		_moreCredit = new FlxText(0, 0, 0, "                           Twitter : \n@LucasTixier - @Eponopono", 12, true);
		_moreCredit.screenCenter(FlxAxes.X);
		_moreCredit.y = _credit.y + 50;
		add(_moreCredit);

		FlxG.mouse.visible = true;
		
		_alphaModifier = 0;
		
		FlxG.camera.fade(FlxColor.BLACK, .2, true);

		super.create();
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		blink();

		if (FlxG.mouse.justPressed || FlxG.keys.justPressed.SPACE)
		{
			FlxG.camera.fade(FlxColor.BLACK, .1, false, function() {
				FlxG.switchState(new PlayState());
			});
		}
	}
	
	/**
	 * Fonction fait blinker le titre en modifiant son alpha
	 */
	public function blink()
	{
		var currentAlpha : Float;

		if (_startDisplay.alpha == 1)
		{
			_alphaModifier = -0.02;
		}

		if (_startDisplay.alpha == 0)
		{
			_alphaModifier = 0.02;
		}

		currentAlpha = _startDisplay.alpha;
		_startDisplay.alpha = currentAlpha + _alphaModifier;
	}
}