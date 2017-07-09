
/**
 * ...
 * @author Jacob White
 */

import haxepunk.Scene;
import haxepunk.Entity;
import haxepunk.HXP;
import haxepunk.Sfx;
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
 
class PlayScene extends Scene
{	
	private var black:Image;
	private var state:String;
	private var won:Bool;
	private var newEnemyX:Int;
	private var enemiesPerRow:Int;
	private var enemiesAdded:Int;
	private var timeToAddToScoreTimer:Float;
	private var timeLeftCountdownWaitTimer:Float;
	private var livesToAddToScoreTimer:Float;
	private var livesLeftCountdownWaitTimer:Float;

	private var row1Y:Int;
	private var row2Y:Int;

	private var timeText:Text;
	private var scoreText:Text;
	private var lifeText:Text;
	private var waveText:Text;
	private var timeToScoreSfx:Sfx;
	private var lifeToScoreSfx:Sfx;
	private var bgmSfx:Sfx;
	
	override public function new()
	{
		super();

		HXP.screen.color = 0x44ffee;
		
		Globals.playing = false;
		Globals.inControl = false;
		Globals.curWave = 1;
		Globals.enemiesInWave = 24;
		Globals.numInPos = 0;
		Globals.allInPos = false;
		Globals.time = 99;
		Globals.score = 0;
		Globals.player = new Player(Globals.maxLife);
		Globals.candles = [];
		Globals.enemiesArray = [];
		Globals.enemiesDefeatedSincePickup = 0;
		Globals.pickupDropChance = Globals.basePickupDropChance;

		add(Particles.twinkle);
		add(Particles.candletrail);
		add(Particles.deatheffects);

		state = "entering";
		won = false;
		newEnemyX = 30;
		enemiesPerRow = 12;
		enemiesAdded = 0;
		row1Y = 40;
		row2Y = 90;
		
		//bgmSnd = new Sfx("audio/bgm.mp3");
		timeToScoreSfx = new Sfx("audio/timeaddtoscore.wav");
		lifeToScoreSfx = new Sfx("audio/lifeaddtoscore.wav");
		
		add(Globals.player);
		for(i in 0...5)
		{
			var c:Candle = new Candle(i);
			Globals.candles.push(c);
			add(c);
		}
		
		timeText = new Text("99");
		timeText.color = 0xee4400;
		timeText.size = 38;
		timeText.x = 320 - (timeText.width * 0.5);
		timeText.y = 2;
		addGraphic(timeText, -10);
		
		waveText = new Text("WAVE 1");
		waveText.color = 0xccaa00;
		waveText.size = 70;
		waveText.x = 320 - (waveText.width * 0.5);
		waveText.y = 240 - (waveText.height * 0.5);
		waveText.alpha = 0;
		addGraphic(waveText, -10);
		
		var hud:Image = Image.createRect(640, 43, 0x333333, 1);
		addGraphic(hud, -10, 0, 437);
		
		scoreText = new Text("SCORE:");
		scoreText.color = 0xccbb00;
		scoreText.size = 35;
		scoreText.x = 50;
		scoreText.y = 443;
		addGraphic(scoreText, -10);
		
		lifeText = new Text("LIFE:");
		lifeText.color = 0xdd1111;
		lifeText.size = 35;
		lifeText.x = 460;
		lifeText.y = 443;
		addGraphic(lifeText, -10);
		
		black = Image.createRect(640, 480, 0x000000, 1);
		addGraphic(black, -20, 0, 0);

		Input.define("pause", [Key.P]);
	}
	
	override public function update()
	{
		switch(state)
		{
			case "entering":
				if(black.alpha > 0)
				{
					black.alpha -= HXP.elapsed;
				}
				else
				{
					Globals.playing = true;
					state = "readying";
				}
			case "readying":
				if(Globals.allInPos)
				{
					waveText.alpha -= HXP.elapsed;
					if(waveText.alpha == 0)
					{
						state = "playing";
					}
				}
				else
				{
					if(enemiesAdded < Globals.enemiesInWave)
					{
						createWave(Globals.curWave);
					}

					if(Globals.numInPos == Globals.enemiesInWave)
					{
						//if(!bgmSnd.playing)
						{
							//bgmSnd.loop();
						}
						Globals.allInPos = true;
						Globals.inControl = true;
						waveText.alpha = 1;
					}
				}
			case "playing":
				Globals.enemiesArray = [];
				var pickups:Array<Entity> = [];

				getType("enemy", Globals.enemiesArray);
				getType("pickup", pickups);
			
				if(Globals.enemiesArray.length == 0 && pickups.length == 0)
				{
					Globals.inControl = false;
					for(j in 0...5)
					{
						Globals.candles[j].isFired = false;
						Globals.candles[j].y = 348;
					}

					var li:Array<Entity> = [];
					getType("lightning", li);
					for(j in 0...li.length)
					{
						HXP.scene.remove(li[j]);
					}
					timeLeftCountdownWaitTimer = 1.0;
					timeToAddToScoreTimer = 0.1;
					state = "timeLeftCountDown";
				}
				
				Globals.time -= HXP.elapsed;
				if(Globals.time <= 0 || Globals.player.dead)
				{
					state = "leaving";
				}

			case "timeLeftCountDown":
				if(timeLeftCountdownWaitTimer > 0) //wait briefly before adding score
				{
					timeLeftCountdownWaitTimer -= HXP.elapsed;
				}
				else
				{
					//"count down" the remaining time, adding to the score
					if(timeToAddToScoreTimer > 0)
					{
						timeToAddToScoreTimer -= HXP.elapsed;
					}
					else
					{
						if(Globals.time > 0)
						{
							//actually do the subtracting from the time left and adding to the score
							var difference:Int = Math.ceil(Math.min(3, Globals.time));
							Globals.time -= difference;
							Globals.score += difference * 10;
							timeToAddToScoreTimer = 0.1;
							timeToScoreSfx.play(0.5);
						}
						else
						{
							state = "waveEnd";
						}
					}
				}
			case "waveEnd":
				Globals.curWave += 1;
				waveText.text = "WAVE " + Globals.curWave;
				if(Globals.curWave > Globals.numWaves)
				{
					won = true;
					livesLeftCountdownWaitTimer = 0.25;
					livesToAddToScoreTimer = 0.5;
					state = "gameEnd";
				}
				else
				{
					Globals.numInPos = 0;
					Globals.allInPos = false;
					Globals.time = 99;
					enemiesAdded = 0;
					state = "readying";
				}
			case "gameEnd":
				if(livesLeftCountdownWaitTimer > 0)
				{
					livesLeftCountdownWaitTimer -= HXP.elapsed;
				}
				else
				{
					if(livesToAddToScoreTimer > 0)
					{
						livesToAddToScoreTimer -= HXP.elapsed;
					}
					else
					{
						if(Globals.player.life > 0)
						{
							Globals.player.countDownLife();
							livesToAddToScoreTimer = 0.5;
							lifeToScoreSfx.play(0.5);
						}
						else
						{
							state = "leaving";
						}
					}
				}
			case "leaving":
				if(black.alpha < 1)
				{
					black.alpha += HXP.elapsed;
				}
				else
				{
					//bgmSnd.stop();
					HXP.scene.removeAll();
					HXP.scene = new EndScene(won);
				}
		}
		
		//make PauseScene active
		if(Input.pressed("pause"))
		{
			HXP.engine.pushScene(new PauseScene());
		}

		//update text
		timeText.text = Std.string(Math.ceil(Globals.time));
		scoreText.text = "SCORE: " + Math.ceil(Globals.score);
		lifeText.text = "LIFE: " + Globals.player.life;

		super.update();
	}
	
	private function createWave(waveNum:Int)
	{
		switch(waveNum)
		{
			case 1:
				if(newEnemyX > enemiesPerRow * 50)
				{
					newEnemyX = 40;
				}
				if(enemiesAdded < enemiesPerRow)
				{
					add(new Enemy1(newEnemyX, row1Y, 110));
				}
				else
				{
					add(new Enemy1(newEnemyX, row2Y, 110));
				}
			case 2:
				if(newEnemyX > enemiesPerRow * 50)
				{
					newEnemyX = 40;
				}
				if(enemiesAdded < enemiesPerRow)
				{
					add(new Enemy1(newEnemyX, row1Y, 120));
				}
				else
				{
					add(new Enemy2(newEnemyX, row2Y, 120));
				}
			case 3:
				if(newEnemyX > enemiesPerRow * 50)
				{
					newEnemyX = 40;
				}
				if(enemiesAdded < enemiesPerRow)
				{
					add(new Enemy2(newEnemyX, row1Y, 130));
				}
				else
				{
					add(new Enemy1(newEnemyX, row2Y, 130));
				}
			case 4:
				if(newEnemyX > enemiesPerRow * 50)
				{
					newEnemyX = 40;
				}
				if(enemiesAdded < enemiesPerRow)
				{
					add(new Enemy2(newEnemyX, row1Y, 135));
				}
				else
				{
					add(new Enemy2(newEnemyX, row2Y, 135));
				}
			case 5:
				if(newEnemyX > enemiesPerRow * 50)
				{
					newEnemyX = 40;
				}
				if(enemiesAdded < enemiesPerRow)
				{
					add(new Enemy2(newEnemyX, row1Y, 140));
				}
				else
				{
					add(new Enemy2(newEnemyX, row2Y, 140));
				}
		}

		newEnemyX += 50;
		enemiesAdded += 1;
	}
	
	private function addTimeToScore()
	{

	}
}
