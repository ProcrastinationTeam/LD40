package state;

import flixel.FlxCamera;
import flixel.FlxState;
import ui.InfoScreen;
import flixel.FlxG;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	public var infoScreen		: InfoScreen;
	
	override public function create():Void
	{
		super.create();

		///////////////////////////////////
		infoScreen = new InfoScreen();
		add(infoScreen);
		
		// Caméra pour le HUD (on sait pas trop comment, mais ça marche)
		//var infoScreenCam = new FlxCamera(FlxG.width - infoScreen._width, FlxG.height - infoScreen._height, infoScreen._width, infoScreen._height, 1);
		//infoScreenCam.zoom = 1;
		//infoScreenCam.bgColor = FlxColor.PINK;
		//infoScreenCam.follow(infoScreen._backgroundSprite, NO_DEAD_ZONE);
		//FlxG.cameras.add(infoScreenCam);
		///////////////////////////////////
		
		FlxG.camera.fade(FlxColor.BLACK, .1, true);
		//infoScreenCam.fade(FlxColor.BLACK, .1, true);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}