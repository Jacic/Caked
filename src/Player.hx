
/**
 * ...
 * @author Jacob White
 */

import haxepunk.Entity;
import haxepunk.HXP;
import haxepunk.Sfx;
import haxepunk.graphics.Image;
#if (HaxePunk <= "2.6.1")
import haxepunk.utils.Input;
import haxepunk.utils.Key;
#else
import haxepunk.input.Input;
import haxepunk.input.Key;
#end
 
class Player extends Entity
{	
	public var life(default, null):Int;
	public var dead(default, null):Bool;
	private var dying:Bool;
	private var speed:Int;
	private var deadTimer:Float;
	private var playerImg:Image;
	private var playerW:Int;
	private var playerH:Int;
	private var hasSuper:Bool;
	private var superCandle:SuperCandle;
	private var shootSfx:Sfx;
	private var superShootSfx:Sfx;
	private var hitSfx:Sfx;
	private var deathSfx:Sfx;
	private var pickupSfx:Sfx;
	
	override public function new(life:Int)
	{
		super();

		this.life = life;
		speed = 190;
		dead = false;
		dying = false;
		deadTimer = 2.5;
		playerW = 80;
		playerH = 100;
		hasSuper = false;
		
		playerImg = new Image("gfx/cake.png");
		graphic = playerImg;
		setHitbox(64, 32, -8, -14);
		x = (HXP.screen.width * 0.5) - (playerW * 0.5);
		y = 440 - playerH;

		shootSfx = new Sfx("audio/playershoot.wav");
		superShootSfx = new Sfx("audio/supercandleshoot.wav");
		hitSfx = new Sfx("audio/playerhit.wav");
		deathSfx = new Sfx("audio/playerdead.wav");
		pickupSfx = new Sfx("audio/pickup.wav");
		
		Input.define("left", [Key.A, Key.LEFT]);
		Input.define("right", [Key.D, Key.RIGHT]);
		Input.define("shoot", [Key.SPACE]);
	}
	
	override public function update()
	{
		super.update();

		if(Globals.inControl)
		{
			if(Input.check("left"))
			{
				x -= speed * HXP.elapsed;
			}
			if(Input.check("right"))
			{
				x += speed * HXP.elapsed;
			}
			if(Input.pressed("shoot"))
			{
				shoot();
			}

			//fade the image back in after getting hit
			if(playerImg.alpha < 1)
			{
				playerImg.alpha += 3 * HXP.elapsed;
			}

			if(x < 0)
			{
				x = 0;
			}
			else if(x + playerW > HXP.width)
			{
				x = HXP.width - playerW;
			}
			
			var col:Array<Entity> = [];
			collideTypesInto(["lightning", "pickup"], x, y, col);
			for(e in col)
			{
				switch(e.type)
				{
					case "lightning":
						hit(e);
						HXP.scene.remove(e);
					case "pickup":
						switch(cast(e, Pickup).pickupType)
						{
							case Points500:
								Globals.score += 500;
							case Health:
								if(life < Globals.maxLife)
								{
									life += 1;
								}
							case Super:
								if(!hasSuper)
								{
									hasSuper = true;
									superCandle = new SuperCandle();
									HXP.scene.add(superCandle);
								}
						}
						pickupSfx.play(0.5);
						HXP.scene.remove(e);
				}
			}
		}
		else if(dying)
		{
			deadTimer -= HXP.elapsed;
			if(deadTimer <= 0)
			{
				dead = true;
			}
		}
	}
	
	public function shoot()
	{
		if(hasSuper)
		{
			superCandle.isFired = true;
			hasSuper = false;
			superShootSfx.play(0.5);
		}
		else
		{
			//normal candles
			for(i in 0...5)
			{
				if(!Globals.candles[i].isFired)
				{
					shootSfx.play(0.5);
					Globals.candles[i].isFired = true;
					break;
				}
			}
		}
	}

	public function hit(e:Entity)
	{
		if(playerImg.alpha == 1) //give the player a brief period of invincibility
		{
			life -= 1;
			playerImg.alpha = 0;
			Particles.deatheffects.playerHit(e.x + e.halfWidth - 4, this.top - 4);
			#if (HaxePunk <= "2.6.1")
			HXP.screen.shake(10, 0.15);
			#else
			HXP.screen.shake(0.15, 10);
			#end

			if(life <= 0)
			{
				life = 0;
				Globals.inControl = false;
				dying = true;
				playerImg.alpha = 0;
				for(i in 0...5)
				{
					Globals.candles[i].image.alpha = 0;
				}
				Particles.deatheffects.playerDeath(x, y, width, height);
				deathSfx.play(0.5);
			}
			else
			{
				//play the normal hit sound
				hitSfx.play(0.5);
			}
		}
	}

	public function countDownLife()
	{
		life -= 1;
		Globals.score += 200;
	}
}
