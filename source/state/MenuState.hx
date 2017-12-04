package state;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxSliceSprite;
import flixel.addons.ui.FlxUIState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxAxes;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;

class MenuState extends FlxUIState
{
	private var _volumeSprite			: FlxSprite;
	private var _backgroundSprite 		: FlxSprite;
	
	override public function create():Void
	{
		bgColor = 0xFF000000;
		
		_backgroundSprite = new FlxSprite(0, 0);
		_backgroundSprite.loadGraphic(AssetPaths.artwork__png, true, 640, 480, true);
		_backgroundSprite.animation.add("YOLO", [11, 10,9, 8, 7, 6, 5, 4, 3,2,1], 9, true, false, false);
		
		add(_backgroundSprite);
		var title = new FlxText(0, 0, 0, "Filthy-rich and Fastuous", 40, true);
		title.color = 0xFF630000;
		title.screenCenter();
		title.y -= 100;
		add(title);
		
		var credit = new FlxText(0, 0, 0, "Another stupid game by Lucas Tixier & Guillaume Ambrois", 12, true);
		credit.screenCenter(FlxAxes.X);
		credit.color = 0xFF630000;
		credit.y = title.y + 70;
		add(credit);
		
		var startText = new FlxText(0, 0, 0, "Click or press SPACE to start", 18, true);
		startText.color = 0xFF630000;
		startText.screenCenter();
		add(startText);
		
		FlxTween.tween(startText, {alpha: 0}, 0.7, {type: FlxTween.PINGPONG, ease: FlxEase.linear});
		
		var soundText = new FlxText(0, 0, 0, "You can adjust the volume at any time by pressing the UP or DOWN keys", 10);
		soundText.screenCenter(FlxAxes.X);
		soundText.color = 0xFF630000;
		soundText.y = FlxG.height - 150;
		add(soundText);
		
		var moreCreditAgain = new FlxText(0, 0, 0, "@LucasTixier - @Eponopono", 12, true);
		moreCreditAgain.screenCenter(FlxAxes.X);
		moreCreditAgain.color = 0xFF630000;
		moreCreditAgain.y = FlxG.height - 80;
		add(moreCreditAgain);
		
		var moreCredit = new FlxText(0, 0, 0, "Twitter :", 12, true);
		moreCredit.screenCenter(FlxAxes.X);
		moreCredit.color = 0xFF630000;
		moreCredit.y = moreCreditAgain.y - 20;
		add(moreCredit);
	
		FlxG.mouse.visible = true;
		
		FlxG.camera.fade(FlxColor.BLACK, .2, true);

		super.create();
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		_backgroundSprite.animation.play("YOLO");
		if (FlxG.mouse.justPressed || FlxG.keys.justPressed.SPACE)
		{
			FlxG.camera.fade(FlxColor.BLACK, .1, false, function() {
				FlxG.switchState(new PlayState());
			});
		}
	}
	
	//private function updateVolume():Void
	//{
		//if (_volumeSprite != null) {
			//_volumeSprite.destroy();
		//}
		//
		//_volumeSprite = new FlxSprite(0, 40);
		//_volumeSprite.makeGraphic(200, 40, FlxColor.YELLOW);
		//_volumeSprite.screenCenter(FlxAxes.X);
		//add(_volumeSprite);
		//for (i in 0...10) {
			//if (FlxG.sound.volume * 10 >= i)
			//{
				//FlxSpriteUtil.drawRect(_volumeSprite, i*20, 0, 19, 40, FlxColor.BLUE, {thickness: 1, color: FlxColor.BLACK});
			//}
			//else 
			//{
				//FlxSpriteUtil.drawRect(_volumeSprite, i*20, 0, 19, 40, FlxColor.TRANSPARENT, {thickness: 1, color: FlxColor.BLACK});
			//}
		//}
		//
		//new FlxTimer().start(2, function(timer:FlxTimer):Void {
			//_volumeSprite.destroy();
		//});
	//}
}