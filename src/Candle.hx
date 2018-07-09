
/**
 * ...
 * @author Jacob White
 */

import haxepunk.Entity;
import haxepunk.HXP;
import haxepunk.graphics.Image;
 
class Candle extends Entity
{
	private static inline var particleCreateTime:Float = 0.01;

	public var isFired:Bool;
	public var image(default, null):Image;
	private var speed:Int;
	private var candleNum:Int;
	private var particleTimer:Float;
	
	override public function new(num:Int)
	{
		super();

		image = new Image("gfx/candle.png");
		graphic = image;
		setHitbox(2, 8);
		
		x = -width;
		y = Globals.player.top - image.height + 2; //2 pixels lower so the cake appears slightly more "3d"
		speed = 170;
		isFired = false;
		candleNum = num;
		particleTimer = particleCreateTime;
		type = "candle";
		layer = -3;
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
					Particles.candletrail.normalCandle(x + halfWidth, y + height);
					particleTimer += particleCreateTime;
				}
			}
			else
			{
				isFired = false;
				x = Globals.player.x + 15 + (12 * candleNum);
				y = Globals.player.top - image.height + 2;
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
					isFired = false;
					x = Globals.player.x + 15 + (12 * candleNum);
					y = Globals.player.top - image.height + 2;
					Globals.score += en.value;
					#if (HaxePunk <= "2.6.1")
					HXP.screen.shake(2, 0.25);
					#elseif (HaxePunk < "4.0.0")
					HXP.screen.shake(0.25, 2);
					#else
					HXP.camera.shake(0.25, 2);
					#end
				}
			}
		}
		else
		{
			x = Globals.player.x + 15 + (12 * candleNum);
		}
	}
}
