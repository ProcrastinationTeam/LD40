package client;

import flixel.FlxGame;
import openfl.display.Sprite;
import client.state.MenuState;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.addons.plugin.screengrab.FlxScreenGrab;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, MenuState));
		FlxG.sound.volume = 0.0;
		
		#if (web || desktop)
		FlxG.sound.volumeUpKeys = [FlxKey.PLUS, UP];
		FlxG.sound.volumeDownKeys = [FlxKey.MINUS, DOWN];
		
		FlxScreenGrab.defineHotKeys([FlxKey.K], true);
		#end
		
		#if mobile
		FlxG.mouse.visible = false;
		#end
	}
}
