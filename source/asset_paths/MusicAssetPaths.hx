package asset_paths;

// http://forum.haxeflixel.com/topic/668/duplicate-class-field-declaration/7
@:build(flixel.system.FlxAssets.buildFileReferences("assets/music", true, ["ogg", "wav"]))
class MusicAssetPaths {}