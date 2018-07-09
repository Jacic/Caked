
/**
 * ...
 * @author Jacob White
 */

import haxepunk.Scene;
import haxepunk.HXP;
#if (HaxePunk <= "2.6.1")
import haxepunk.utils.Input;
import haxepunk.utils.Key;
import haxepunk.graphics.Text;
#else
import haxepunk.input.Input;
import haxepunk.input.Key;
import haxepunk.graphics.text.Text;
#end
import haxepunk.graphics.Image;
import flash.text.TextFormatAlign;

enum GameMode
{
	Waves;
	Endless;
}

enum State
{
	Main;
	Starting;
}

class TitleScene extends Scene
{
	private var state:State;
	private var fadingDir:Int;
	private var gameMode:GameMode;
	private var startText:Text;
	private var modeText:Text;
	private var black:Image;
	
	override public function new()
	{
		super();

		state = Main;
		fadingDir = -1;
		gameMode = Waves;
		HXP.screen.color = 0x55ff88;
		
		var titleText = new Text("Cake'd");
		titleText.size = 100;
		titleText.color = 0x2299ff;
		titleText.x = (HXP.screen.width * 0.5) - (titleText.textWidth * 0.5);
		titleText.y = 30;
		addGraphic(titleText);
		
		startText = new Text("PRESS SPACE!");
		startText.size = 40;
		startText.color = 0xee2222;
		startText.x = (HXP.screen.width * 0.5) - (startText.textWidth * 0.5);
		startText.y = 200;
		addGraphic(startText);
		
		modeText = new Text("5 WAVES");
		modeText.size = 25;
		modeText.color = 0xee2222;
		modeText.x = (HXP.screen.width * 0.5) - (modeText.textWidth * 0.5);
		modeText.y = 280;
		addGraphic(modeText);
		
		var modeChangeText = new Text("Up/Down to change mode");
		modeChangeText.size = 20;
		modeChangeText.color = 0xee2222;
		modeChangeText.x = (HXP.screen.width * 0.5) - (modeChangeText.textWidth * 0.5);
		modeChangeText.y = 310;
		addGraphic(modeChangeText);

		var infoText = new Text("Birthdays are being attacked by evil\ntime-stealing creatures! Help Cake fight them off!\n\nArrows/AD to move, Space to shoot\nP to pause/unpause");
		infoText.size = 20;
		infoText.align = TextFormatAlign.CENTER;
		infoText.color = 0x2299ff;
		infoText.x = (HXP.screen.width * 0.5) - (infoText.textWidth * 0.5);
		infoText.y = 350;
		addGraphic(infoText);
		
		black = Image.createRect(640, 480, 0x000000, 0);
		addGraphic(black, 0, 0, 0);

		Input.define("start", [Key.SPACE]);
		Input.define("changeMode", [Key.UP, Key.DOWN]);
	}
	
	override public function update()
	{
		if(startText.alpha == 0)
		{
			fadingDir = 1;
		}
		else if(startText.alpha == 1)
		{
			fadingDir = -1;
		}
		
		startText.alpha += (fadingDir * HXP.elapsed);
		
		switch(state)
		{
			case Main:
				if(Input.pressed("changeMode"))
				{
					changeMode();
				}

				if(Input.pressed("start"))
				{
					state = Starting;
				}
			case Starting:
				if(black.alpha < 1)
				{
					black.alpha += 0.75 * HXP.elapsed;
				}
				else
				{
					HXP.scene.removeAll();
					HXP.scene = new PlayScene(gameMode);
				}
		}

		super.update();
	}

	private function changeMode()
	{
		if(gameMode == Waves)
		{
			gameMode = Endless;
			modeText.text = "ENDLESS WAVES";
			modeText.x = (HXP.screen.width * 0.5) - (modeText.textWidth * 0.5);
		}
		else
		{
			gameMode = Waves;
			modeText.text = "5 WAVES";
			modeText.x = (HXP.screen.width * 0.5) - (modeText.textWidth * 0.5);
		}
	}
}
