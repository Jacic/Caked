
/**
 * ...
 * @author Jacob White
 */

import haxepunk.Entity;
import haxepunk.HXP;
import haxepunk.graphics.Spritemap;
 
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
	private var baseShootTimer:Float;
	private var shootTimerModifier:Float;
	private var shootTimer:Float;
	private var image:Spritemap;

	override public function new()
	{
		super();

		y = -50;
		shootTimer = 0;
		shootTimerModifier = Math.random() * 2;
		isHit = false;
		inPosition = false;
		type = "enemy";
		layer = -4;
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
				if(!isHit)
				{
					//move back and forth
					move();

					if(Globals.inControl)
					{
						shootTimer += HXP.elapsed;
						if(shootTimer >= baseShootTimer - (Globals.curWave * 0.05) + shootTimerModifier)
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
							shootTimerModifier = Math.random() * 2;
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

	private function move()
	{
		if(x + width - originX >= HXP.width)
		{
			dir = -1;
			x = HXP.width - width + originX;
		}
		else if(x - originX <= 0)
		{
			dir = 1;
			x = originX;
		}

		x += speed * dir * HXP.elapsed;
	}

	private function shoot(speed:Int)
	{
		HXP.scene.add(new Lightning(x + Std.int(halfWidth) - 6, y + height, speed));
		AudioHandler.getInstance().enemyShoot.play(0.5);
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
	public function hit(shakeAmt:Int):Bool
	{
		if(!Globals.inControl)
		{
			return false; //don't kill the enemy if the player isn't currently in control
		}

		if(!isHit)
		{
			isHit = true;
			type = "dying";
			Globals.enemiesDefeated += 1;

			if(Globals.enemiesDefeatedSincePickup >= 5 &&
				(Math.random() < Globals.pickupDropChance || Globals.enemiesDefeatedSincePickup >= Globals.enemiesInWave * 0.5))
			{
				//drop pickup and reset pickup chance
				var p:Pickup = new Pickup(x, y, speed, Pickup.getRandomType());
				HXP.scene.add(p);
				Globals.pickupDropChance = Globals.BASE_PICKUP_DROP_CHANCE;
				Globals.enemiesDefeatedSincePickup = 0;
			}
			else
			{
				//increase chance of pickup
				Globals.pickupDropChance += Globals.BASE_PICKUP_DROP_CHANCE;
				Globals.enemiesDefeatedSincePickup += 1;
			}

			if(Globals.enemiesDefeated == Globals.enemiesInWave)
			{
				shakeAmt = 15;
				AudioHandler.getInstance().longExplosion.play();
			}
			else
			{
				AudioHandler.getInstance().enemyHit.play(0.5);
			}

			#if (HaxePunk <= "2.6.1")
			HXP.screen.shake(shakeAmt, 0.25);
			#elseif (HaxePunk < "4.0.0")
			HXP.screen.shake(0.25, shakeAmt);
			#else
			HXP.camera.shake(0.25, shakeAmt);
			#end

			Particles.deatheffects.enemyDeath(Type.getClassName(Type.getClass(this)), x, y, width, height);

			return true;
		}

		return false;
	}
}
