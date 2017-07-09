
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
 
class PauseScene extends Scene
{
	private var fadingDir:Int;
	private var pauseText:Text;
	
	override public function new()
	{
		super();

		fadingDir = -1;
		HXP.screen.color = 0x000000;

		//set alpha of the scene for "overlay" effect
		#if (HaxePunk <= "2.6.1")
		alpha = 0.75;
		#else
		bgAlpha = 0.75;
		#end
		
		pauseText = new Text("PRESS SPACE!");
		pauseText.size = 40;
		pauseText.color = 0xee2222;
		pauseText.x = (HXP.screen.width * 0.5) - (pauseText.width * 0.5);
		pauseText.y = (HXP.screen.height * 0.5) - (pauseText.height * 0.5);
		addGraphic(pauseText);

		Input.define("resume", [Key.P]);
	}
	
	override public function update()
	{
		if(pauseText.alpha == 0)
		{
			fadingDir = 1;
		}
		else if(pauseText.alpha == 1)
		{
			fadingDir = -1;
		}
		
		pauseText.alpha += (fadingDir * HXP.elapsed);
		
		if(Input.pressed("resume"))
		{
			HXP.screen.color = 0x44ffee;
			HXP.scene.removeAll();
			HXP.engine.popScene();
		}

		super.update();
	}
}
