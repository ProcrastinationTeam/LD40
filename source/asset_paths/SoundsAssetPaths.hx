package asset_paths;

// http://forum.haxeflixel.com/topic/668/duplicate-class-field-declaration/7
@:build(flixel.system.FlxAssets.buildFileReferences("assets/sounds", true, ["ogg", "wav"]))
class SoundsAssetPaths {}