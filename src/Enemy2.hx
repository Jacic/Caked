
/**
 * ...
 * @author Jacob White
 */

import haxepunk.graphics.Spritemap;
 
class Enemy2 extends Enemy
{
	override public function new(xx:Int, yTarget:Int, speed:Int)
	{
		super();
		
		image = new Spritemap("gfx/enemy2.png", 30, 30);
		image.add("move", [0, 1, 2, 1, 0, 3, 4, 5], 4, true);
		image.play("move");
		graphic = image;
		setHitbox(24, 24, -4, -4);

		value = 500;
		this.speed = speed;
		baseShootTimer = 1.35;
		baseShootChance = 15;
		lightningSpeed = 160 + (Globals.curWave * 5);
		targY = yTarget;
		x = xx;
		dir = -1;
	}
}
