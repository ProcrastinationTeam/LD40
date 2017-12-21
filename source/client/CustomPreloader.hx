package client;
 
import flixel.system.FlxBasePreloader;
 
// https://gamepopper.co.uk/2014/08/26/haxeflixel-making-a-custom-preloader/
class CustomPreloader extends FlxBasePreloader
{
    public function new(MinDisplayTime:Float=0, ?AllowedURLs:Array<String>)
    {
        super(MinDisplayTime, AllowedURLs);
    }
}