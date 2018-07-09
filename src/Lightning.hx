
/**
 * ...
 * @author Jacob White
 */

import haxepunk.HXP;
import haxepunk.Entity;
import haxepunk.graphics.Spritemap;
 
class Lightning extends Entity
{	
	public var speed:Int;
	private var image:Spritemap;
	
	override public function new(xx:Float, yy:Float, spd:Int) 
	{
		super();

		image = new Spritemap("gfx/lightning.png", 12, 12);
		image.add("anim", [0, 1], 4, true);
		image.play("anim");
		graphic = image;
		setHitbox(12, 12);
		speed = spd;
		x = xx;
		y = yy;
		type = "lightning";
		layer = -7;
	}
	
	override public function update()
	{
		super.update();
		
		if(y <= 440)
		{
			y += speed * HXP.elapsed;
		}
		else
		{
			HXP.scene.remove(this);
		}
	}
}