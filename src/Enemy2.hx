
/**
 * ...
 * @author Jacob White
 */

import haxepunk.graphics.Image;
 
class Enemy2 extends Enemy
{	
	override public function new(xx:Int, yTarget:Int, speed:Int)
	{
		super();
		
		image = new Image("gfx/enemy2.png");
		graphic = image;
		setHitbox(24, 24, -4, -4);

		value = 500;
		inPosition = false;
		this.speed = speed;
		baseShootChance = 15;
		lightningSpeed = 160 + (Globals.curWave * 5);
		targY = yTarget;
		x = xx;
		dir = -1;
	}
}
