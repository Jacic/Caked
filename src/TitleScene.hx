
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
 
class TitleScene extends Scene
{
	private var state:String;
	private var fadingDir:Int;
	private var startText:Text;
	private var black:Image;
	
	override public function new()
	{
		super();

		state = "main";
		fadingDir = -1;
		HXP.screen.color = 0x55ff88;
		
		var titleText:Text = new Text("Cake'd");
		titleText.size = 100;
		titleText.color = 0x2299ff;
		titleText.x = (HXP.screen.width * 0.5) - (titleText.width * 0.5);
		titleText.y = 50;
		addGraphic(titleText);
		
		startText = new Text("PRESS SPACE!");
		startText.size = 40;
		startText.color = 0xee2222;
		startText.x = (HXP.screen.width * 0.5) - (startText.width * 0.5);
		startText.y = 280;
		addGraphic(startText);

		var infoText:Text = new Text("Birthdays are being attacked by evil\ntime-stealing creatures! Help Cake fight them off!\n\nArrows/AD to move, Space to shoot\nP to pause/unpause");
		infoText.size = 20;
		infoText.leading = 5;
		infoText.align = TextFormatAlign.CENTER;
		infoText.color = 0xee2222;
		infoText.x = (HXP.screen.width * 0.5) - (infoText.width * 0.5);
		infoText.y = 340;
		addGraphic(infoText);
		
		black = Image.createRect(640, 480, 0x000000, 0);
		addGraphic(black, 0, 0, 0);

		Input.define("start", [Key.SPACE]);
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
			case "main":
				if(Input.pressed("start"))
				{
					state = "starting";
				}
			case "starting":
				if(black.alpha < 1)
				{
					black.alpha += 0.75 * HXP.elapsed;
				}
				else
				{
					HXP.scene.removeAll();
					HXP.scene = new PlayScene();
				}
		}

		super.update();
	}
}
