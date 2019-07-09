
/**
 * ...
 * @author Jacob White
 */

import haxepunk.Scene;
import haxepunk.HXP;
import haxepunk.graphics.Image;
#if (HaxePunk <= "2.6.1")
import haxepunk.graphics.Text;
import haxepunk.utils.Input;
import haxepunk.utils.Key;
#else
import haxepunk.graphics.text.Text;
import haxepunk.input.Input;
import haxepunk.input.Key;
#end
import haxepunk.utils.Data;
import haxepunk.graphics.shader.SceneShader;
 
class EndScene extends Scene
{
	private var black:Image;
	private var modeText:Text;
	private var scoreText:Text;
	private var highscoreText:Text;
	private var endText:Text;
	private var spaceText:Text;
	private var timer:Float;
	private var highscore:Int;
	
	override public function new(won:Bool, gameMode:TitleScene.GameMode)
	{
		super();

		var scanlineShader = SceneShader.fromAsset("shaders/scanline.frag");
		scanlineShader.setUniform("scale", 1.0);
		shaders = [scanlineShader];
		
		black = Image.createRect(640, 480, 0x000000, 1);
		addGraphic(black, 0, 0, 0);

		timer = 0;

		//load the highscore
		Data.load("CakedData");
		if(gameMode == TitleScene.GameMode.Waves)
		{
			highscore = Data.readInt("highscore", 0);
		}
		else
		{
			highscore = Data.readInt("highscoreEndless", 0);
		}

		//update the highscore if necessary
		if(Globals.score > highscore)
		{
			if(gameMode == TitleScene.GameMode.Waves)
			{
				Data.write("highscore", Globals.score);
			}
			else
			{
				Data.write("highscoreEndless", Globals.score);
			}
			Data.save("CakedData"); //actually write the data
			highscore = Globals.score;
		}
		
		if(gameMode == TitleScene.GameMode.Endless)
		{
			endText = new Text("CAKE FOUGHT BRAVELY,\nBUT IN THE END WAS BEATEN BACK BY\nTHE EVIL CREATURES.");
		}
		else
		{
			if(won)
			{
				endText = new Text("THE DAY WAS SAVED AND\nEVERYONE WAS HAPPY.\nCAKE THREW A PARTY TO CELEBRATE.");
			}
			else
			{
				endText = new Text("THE EVIL CREATURES WON,\nAND BIRTHDAYS CONTINUED TO BE\nSTOLEN TO GIVE THEM POWER.\nNOBODY WAS HAPPY.");
			}
		}
		endText.color = 0xee2200;
		endText.size = 30;
		endText.align = "center";
		endText.x = (HXP.screen.width * 0.5) - (endText.textWidth * 0.5);
		endText.y = 60;
		endText.alpha = 0;
		addGraphic(endText);
		
		modeText = new Text((gameMode == TitleScene.GameMode.Waves ? "MODE: 5 WAVES" : "MODE: ENDLESS WAVES"));
		modeText.color = 0xee2200;
		modeText.size = 30;
		modeText.x = (HXP.screen.width * 0.5) - (modeText.textWidth * 0.5);
		modeText.y = 250;
		modeText.alpha = 0;
		addGraphic(modeText);
		
		scoreText = new Text("SCORE: " + Globals.score);
		scoreText.color = 0xccbb00;
		scoreText.size = 30;
		scoreText.x = (HXP.screen.width * 0.5) - (scoreText.textWidth * 0.5);
		scoreText.y = 300;
		scoreText.alpha = 0;
		addGraphic(scoreText);
		
		highscoreText = new Text("HIGHSCORE: " + highscore);
		highscoreText.color = 0xffbb00;
		highscoreText.size = 30;
		highscoreText.x = (HXP.screen.width * 0.5) - (highscoreText.textWidth * 0.5);
		highscoreText.y = 330;
		highscoreText.alpha = 0;
		addGraphic(highscoreText);
		
		spaceText = new Text("PRESS SPACE");
		spaceText.color = 0x66cc00;
		spaceText.size = 24;
		spaceText.x = (HXP.screen.width * 0.5) - (spaceText.textWidth * 0.5);
		spaceText.y = 410;
		spaceText.alpha = 0;
		addGraphic(spaceText);

		Input.define("next", [Key.SPACE]);
	}
	
	override public function update()
	{
		if(black.alpha > 0 && timer == 0)
		{
			black.alpha -= HXP.elapsed;
		}
		else
		{
			timer += HXP.elapsed;
			if(timer >= 0.5)
			{
				if(endText.alpha < 1)
				{
					endText.alpha += 2 * HXP.elapsed;
				}
				else if(timer >= 3)
				{
					if(modeText.alpha < 1)
					{
						modeText.alpha += 2 * HXP.elapsed;
					}
					else if(timer >= 4)
					{
						if(scoreText.alpha < 1)
						{
							scoreText.alpha += 2 * HXP.elapsed;
						}
						else if(timer >= 5)
						{
							if(highscoreText.alpha < 1)
							{
								highscoreText.alpha += 2 * HXP.elapsed;
							}
							else if(timer >= 6)
							{
								if(spaceText.alpha < 1)
								{
									spaceText.alpha += 2 * HXP.elapsed;
								}
								else if(Input.pressed("next"))
								{
									if(black.alpha > 0)
									{
										black.alpha -= HXP.elapsed;
									}
									else
									{
										HXP.scene.removeAll();
										HXP.scene = new TitleScene();
									}
								}
							}
						}
					}
				}
			}
		}

		super.update();
	}
}
