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

		infoScreen = new InfoScreen();
		add(infoScreen);
		
		FlxG.camera.fade(FlxColor.BLACK, .1, true);
		
		#if mobile
		FlxG.mouse.visible = false;
		#end
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}