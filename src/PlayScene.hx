
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

enum GameState
{
	Entering;
	Readying;
	Playing;
	TimeLeftCountdown;
	WaveEnd;
	GameEnd;
	Leaving;
}
 
class PlayScene extends Scene
{	
	private static inline var ROW1Y:Int = 40;
	private static inline var ROW2Y:Int = 90;
	private static inline var ROW3Y:Int = 130;
	
	private var black:Image;
	private var gameMode:TitleScene.GameMode;
	private var state:GameState;
	private var won:Bool;
	private var newEnemyX:Int;
	private var enemiesPerRow:Int;
	private var enemiesAdded:Int;
	private var timeToAddToScoreTimer:Float;
	private var timeLeftCountdownWaitTimer:Float;
	private var livesToAddToScoreTimer:Float;
	private var livesLeftCountdownWaitTimer:Float;

	private var timeText:Text;
	private var scoreText:Text;
	private var lifeText:Text;
	private var waveText:Text;
	private var timeToScoreSfx:Sfx;
	private var lifeToScoreSfx:Sfx;
	private var bgmSfx:Sfx;
	
	override public function new(gameMode:TitleScene.GameMode)
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
		Globals.player = new Player(Player.MAX_LIFE);
		Globals.candles = [];
		Globals.enemiesArray = [];
		Globals.enemiesDefeatedSincePickup = 0;
		Globals.pickupDropChance = Globals.BASE_PICKUP_DROP_CHANCE;

		add(Particles.twinkle);
		add(Particles.candletrail);
		add(Particles.deatheffects);

		this.gameMode = gameMode;
		state = Entering;
		won = false;
		newEnemyX = 30;
		enemiesPerRow = 12;
		enemiesAdded = 0;
		
		bgmSfx = new Sfx("audio/bgm.wav");
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
		timeText.x = (HXP.screen.width * 0.5) - (timeText.textWidth * 0.5);
		timeText.y = 2;
		addGraphic(timeText, -10);
		
		waveText = new Text("WAVE 1");
		waveText.color = 0xccaa00;
		waveText.size = 70;
		waveText.x = (HXP.screen.width * 0.5) - (waveText.textWidth * 0.5);
		waveText.y = (HXP.screen.height * 0.5) - (waveText.textHeight * 0.5);
		waveText.alpha = 0;
		addGraphic(waveText, -10);
		
		var hud:Image = Image.createRect(640, 43, 0x333333, 1);
		hud.x = 0;
		hud.y = 437;
		addGraphic(hud, -10);
		
		scoreText = new Text("SCORE:");
		scoreText.color = 0xccbb00;
		scoreText.size = 35;
		scoreText.x = 50;
		scoreText.y = hud.y + (hud.height * 0.5) - (scoreText.textHeight * 0.5);
		addGraphic(scoreText, -10);
		
		lifeText = new Text("LIFE:");
		lifeText.color = 0xdd1111;
		lifeText.size = 35;
		lifeText.x = 460;
		lifeText.y = hud.y + (hud.height * 0.5) - (lifeText.textHeight * 0.5);
		addGraphic(lifeText, -10);
		
		black = Image.createRect(640, 480, 0x000000, 1);
		addGraphic(black, -20, 0, 0);

		Input.define("pause", [Key.P]);
	}
	
	override public function update()
	{
		switch(state)
		{
			case Entering:
				if(black.alpha > 0)
				{
					black.alpha -= HXP.elapsed;
				}
				else
				{
					Globals.playing = true;
					state = Readying;
				}
			case Readying:
				if(Globals.allInPos)
				{
					waveText.alpha -= HXP.elapsed;
					if(waveText.alpha == 0)
					{
						state = Playing;
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
						if(!bgmSfx.playing)
						{
							bgmSfx.loop(0.5);
						}
						Globals.allInPos = true;
						Globals.inControl = true;
						waveText.alpha = 1;
					}
				}
			case Playing:
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
					timeToAddToScoreTimer = 0.09;
					state = TimeLeftCountdown;
				}
				
				Globals.time -= HXP.elapsed;
				if(Globals.time <= 0 || Globals.player.dead)
				{
					state = Leaving;
				}
			case TimeLeftCountdown:
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
							addTimeToScore();
							timeToScoreSfx.play(0.5);
						}
						else
						{
							state = WaveEnd;
						}
					}
				}
			case WaveEnd:
				Globals.curWave += 1;
				waveText.text = "WAVE " + Globals.curWave;
				waveText.x = (HXP.screen.width * 0.5) - (waveText.textWidth * 0.5);
				if(gameMode != TitleScene.GameMode.Endless && Globals.curWave > Globals.NUM_WAVES)
				{
					won = true;
					livesLeftCountdownWaitTimer = 0.25;
					livesToAddToScoreTimer = 0.5;
					state = GameEnd;
				}
				else
				{
					Globals.numInPos = 0;
					Globals.allInPos = false;
					Globals.time = 99;
					enemiesAdded = 0;
					state = Readying;
				}
			case GameEnd:
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
							state = Leaving;
						}
					}
				}
			case Leaving:
				if(black.alpha < 1)
				{
					black.alpha += HXP.elapsed;
					bgmSfx.volume -= 0.5 * HXP.elapsed;
				}
				else
				{
					bgmSfx.stop();
					HXP.scene.removeAll();
					HXP.scene = new EndScene(won, gameMode);
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
					add(new Enemy1(newEnemyX, ROW1Y, 110));
				}
				else
				{
					add(new Enemy1(newEnemyX, ROW2Y, 110));
				}
			case 2:
				if(newEnemyX > enemiesPerRow * 50)
				{
					newEnemyX = 40;
				}
				if(enemiesAdded < enemiesPerRow)
				{
					add(new Enemy1(newEnemyX, ROW1Y, 120));
				}
				else
				{
					add(new Enemy2(newEnemyX, ROW2Y, 120));
				}
			case 3:
				if(newEnemyX > enemiesPerRow * 50)
				{
					newEnemyX = 40;
				}
				if(enemiesAdded < enemiesPerRow)
				{
					add(new Enemy2(newEnemyX, ROW1Y, 130));
				}
				else
				{
					add(new Enemy1(newEnemyX, ROW2Y, 130));
				}
			case 4:
				if(newEnemyX > enemiesPerRow * 50)
				{
					newEnemyX = 40;
				}
				if(enemiesAdded < enemiesPerRow)
				{
					add(new Enemy2(newEnemyX, ROW1Y, 135));
				}
				else
				{
					add(new Enemy2(newEnemyX, ROW2Y, 135));
				}
			case 5:
				if(newEnemyX > enemiesPerRow * 50)
				{
					newEnemyX = 40;
				}
				if(enemiesAdded < enemiesPerRow)
				{
					add(new Enemy2(newEnemyX, ROW1Y, 140));
				}
				else
				{
					add(new Enemy2(newEnemyX, ROW2Y, 140));
				}
			default: //endless mode
				Globals.enemiesInWave = 36;
				if(newEnemyX > enemiesPerRow * 50)
				{
					newEnemyX = 40;
				}
				if(enemiesAdded < enemiesPerRow)
				{
					add(new Enemy2(newEnemyX, ROW1Y, 140));
				}
				else if(enemiesAdded < enemiesPerRow * 2)
				{
					add(new Enemy1(newEnemyX, ROW2Y, 140));
				}
				else
				{
					add(new Enemy2(newEnemyX, ROW3Y, 140));
				}
		}

		newEnemyX += 50;
		enemiesAdded += 1;
	}
	
	private function addTimeToScore()
	{
		var difference:Int = Math.ceil(Math.min(3, Globals.time));
		Globals.time -= difference;
		Globals.score += difference * 10;
		timeToAddToScoreTimer = 0.09;
	}
}
