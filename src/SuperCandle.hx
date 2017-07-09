
/**
 * ...
 * @author Jacob White
 */

import haxepunk.Entity;
import haxepunk.HXP;
import haxepunk.graphics.Spritemap;
 
class SuperCandle extends Entity
{
	private static inline var particleCreateTime:Float = 0.01;

	public var isFired:Bool;
	public var image(default, null):Spritemap;
	private var speed:Int;
	private var particleTimer:Float;
	
	override public function new()
	{
		super();

		image = new Spritemap("gfx/supercandle.png", 16, 36);
		image.add("anim", [0, 1, 2, 3], 4, true);
		image.play("anim");
		graphic = image;
		setHitbox(16, 30, 0, -6);
		
		x = -width;
		y = Globals.player.top - image.height + 2; //2 pixels lower so the cake appears slightly more "3d"
		speed = 220;
		isFired = false;
		particleTimer = particleCreateTime;
		type = "candle";
	}
	
	override public function update()
	{
		super.update();
		
		if(isFired)
		{
			if(y >= -height)
			{
				y -= speed * HXP.elapsed;

				particleTimer -= HXP.elapsed;
				if(particleTimer <= 0)
				{
					Particles.candletrail.superCandle(x + halfWidth, y + image.height);
					particleTimer += particleCreateTime;
				}
			}
			else
			{
				HXP.scene.remove(this);
			}
			
			var en:Enemy = null;
			#if html5
			if(collide("enemy", x, y) != null)
			{
				en = cast(collide("enemy", x, y), Enemy);
			}
			#else
			en = cast(collide("enemy", x, y), Enemy);
			#end
			if(en != null)
			{
				if(en.hit())
				{
					Globals.score += en.value;
					#if (HaxePunk <= "2.6.1")
					HXP.screen.shake(4, 0.25);
					#else
					HXP.screen.shake(0.25, 4);
					#end
				}
			}
		}
		else
		{
			x = Globals.player.left + (Globals.player.width * 0.5) - (width * 0.5);
		}
	}
}
