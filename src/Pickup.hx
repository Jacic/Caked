
/**
 * ...
 * @author Jacob White
 */

import haxepunk.HXP;
import haxepunk.Entity;
import haxepunk.graphics.Spritemap;
import haxepunk.masks.Circle;

enum PickupType
{
	Points500;
	Health;
	Super;
}

class Pickup extends Entity
{	
	private static inline var particleCreateTime:Float = 0.25;

	public var pickupType(default, null):PickupType;
	private var image:Spritemap;
	private var speed:Int;
	private var particleTimer:Float;
	private var collected:Bool;
	
	override public function new(xx:Float, yy:Float, speed:Int, pickupType:PickupType)
	{
		super();

		switch(pickupType)
		{
			case Points500:
				image = new Spritemap("gfx/500pointpickup.png", 24, 24);
			case Health:
				image = new Spritemap("gfx/healthpickup.png", 24, 24);
			case Super:
				image = new Spritemap("gfx/superpickup.png", 24, 24);
		}

		image.add("anim", [0, 1, 2, 3], 8, true);
		image.play("anim");
		graphic = image;
		mask = new Circle(12);
		image.originX = halfWidth;
		image.originY = halfHeight;
		image.x += image.originX;
		image.y += image.originY;
		
		this.speed = speed;
		this.pickupType = pickupType;
		x = xx;
		y = yy;
		type = "pickup";
		layer = -6;
		particleTimer = 0;
		collected = false;
	}
	
	override public function update()
	{
		super.update();
		
		if(collected)
		{
			if(image.alpha > 0)
			{
				image.alpha -= 2 * HXP.elapsed;
			}
			else
			{
				HXP.scene.remove(this);
			}
		}
		else
		{
			if(y <= 440)
			{
				y += speed * HXP.elapsed;
				image.angle += speed * HXP.elapsed;

				particleTimer -= HXP.elapsed;
				if(particleTimer <= 0)
				{
					Particles.twinkle.twinkle(x + halfWidth, y + halfHeight);
					particleTimer += particleCreateTime;
				}
			}
			else
			{
				HXP.scene.remove(this);
			}
		}
	}

	public function collect()
	{
		collected = true;
		type = "";
	}

	public static function getRandomType():PickupType
	{
		return switch(Std.int(Math.random() * 3))
		{
			case 0: Points500;
			case 1: Health;
			default: Super;
		}
	}
}