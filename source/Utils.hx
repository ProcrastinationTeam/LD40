package source;

import flixel.addons.plugin.screengrab.FlxScreenGrab;
import flash.utils.ByteArray;
import flixel.util.FlxStringUtil;
import flixel.addons.util.PNGEncoder;

typedef Scores =
{
	var scores:Array<Score>;
}

typedef Score =
{
	var name:String;
	var time:Float;
	var date:Float;
}

class Utils
{
	public function grabScreen():Void
	{
		FlxScreenGrab.grab(null, true);

		var png:ByteArray = PNGEncoder.encode(FlxScreenGrab.screenshot.bitmapData);

		//var filename = 'D:/test' + button.x + '_' + button.y +'.png';
		//File.saveBytes(filename, png);
	}

	public static function floatToCurrency(float:Float, isTransaction:Bool):String
	{
		return (float < 0 ? "-" : (isTransaction ? "+" : "")) + "$" + FlxStringUtil.formatMoney(Math.abs(float), false);
	}

	// Fonction pompée sur internet pour pouvoir arrondir un chiffre avec le nombre de chiffres après la virgule qu'on veut
	public static function fixedFloat(v:Float, ?precision:Int = 2):Float
	{
		return Math.round( v * Math.pow(10, precision) ) / Math.pow(10, precision);
	}
}