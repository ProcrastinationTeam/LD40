package;

import flixel.FlxGame;
import openfl.display.Sprite;
import state.MenuState;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, MenuState));
		FlxG.sound.volume = 0.3;
		FlxG.sound.volumeUpKeys = [FlxKey.PLUS, UP];
		FlxG.sound.volumeDownKeys = [FlxKey.MINUS, DOWN];
	}
}
