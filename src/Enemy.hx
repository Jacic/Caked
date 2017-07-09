
/**
 * ...
 * @author Jacob White
 */

import haxepunk.Entity;
import haxepunk.Sfx;
import haxepunk.HXP;
import haxepunk.graphics.Image;
 
class Enemy extends Entity
{	
	private static inline var enterSpeed:Int = 25;
	
	public var isHit:Bool;
	public var value(default, null):Int;
	private var inPosition:Bool;
	private var speed:Int;
	private var targY:Int;
	private var dir:Int;
	private var baseShootChance:Int;
	private var shootChance:Int;
	private var lightningSpeed:Int;
	private var shootTimer:Float;
	private var image:Image;
	private var shootSfx:Sfx;
	private var hitSfx:Sfx;

	override public function new()
	{
		super();

		y = -50;
		shootTimer = 0;
		isHit = false;
		type = "enemy";
		layer = -4;
		shootSfx = new Sfx("audio/enemyshoot.wav");
		hitSfx = new Sfx("audio/enemyhit.wav");
	}
	
	override public function update()
	{
		super.update();

		if(!inPosition)
		{
			//move downward
			y += enterSpeed * (targY - y) * 0.5 * HXP.elapsed;
			if(targY - y < 1)
			{
				//at the starting position
				y = targY;
				inPosition = true;
				Globals.numInPos += 1;
			}
		}
		else
		{
			if(Globals.allInPos)
			{
				//move back and forth
				if(x + width >= HXP.width)
				{
					dir = -1;
					x = HXP.width - width;
				}
				else if(x <= 0)
				{
					dir = 1;
					x = 0;
				}
				
				if(!isHit)
				{
					x += speed * dir * HXP.elapsed;

					if(Globals.inControl)
					{
						shootTimer += HXP.elapsed;
						if(shootTimer >= 1.4 - (Globals.curWave * 0.05) + Math.random())
						{
							shootChance = baseShootChance - Std.int(Globals.enemiesArray.length * 0.25);
							
							if(isOverPlayer() && Math.random() * (100 - (Globals.enemiesInWave - Globals.enemiesArray.length)) < shootChance * 2)
							{
								//fire lightning at the player
								shoot(lightningSpeed + 60);
							}
							else if(Math.random() * (100 - (Globals.enemiesInWave - Globals.enemiesArray.length)) < shootChance)
							{
								//fire lightning wherever we are
								shoot(lightningSpeed);
							}
							shootTimer = 0;
						}
					}
				}
				else
				{
					if(image.alpha > 0)
					{
						image.alpha -= 3 * HXP.elapsed;
					}
					else
					{
						HXP.scene.remove(this);
					}
				}
			}
		}
	}

	private function shoot(speed:Int)
	{
		HXP.scene.add(new Lightning(x + Std.int(halfWidth) - 6, y + height, speed));
		shootSfx.play(0.5);
	}

	private function isOverPlayer():Bool
	{
		if(x + halfWidth >= Globals.player.left && x + halfWidth <= Globals.player.right)
		{
			return true;
		}

		return false;
	}

	//returns whether or not the enemy registered the current hit
	public function hit():Bool
	{
		if(!Globals.inControl)
		{
			return false; //don't kill the enemy if the player isn't currently in control
		}

		if(!isHit)
		{
			isHit = true;
			type = "dying";

			if(Globals.enemiesDefeatedSincePickup >= 5 &&
				(Math.random() < Globals.pickupDropChance || Globals.enemiesDefeatedSincePickup >= Globals.enemiesInWave * 0.5))
			{
				//drop pickup and reset pickup chance
				var p:Pickup = new Pickup(x, y, speed, Pickup.getRandomType());
				HXP.scene.add(p);
				Globals.pickupDropChance = Globals.basePickupDropChance;
				Globals.enemiesDefeatedSincePickup = 0;
			}
			else
			{
				//increase chance of pickup
				Globals.pickupDropChance += Globals.basePickupDropChance;
				Globals.enemiesDefeatedSincePickup += 1;
			}

			Particles.deatheffects.enemyDeath(Type.getClassName(Type.getClass(this)), x, y, width, height);
			hitSfx.play(0.5);

			return true;
		}

		return false;
	}
}
