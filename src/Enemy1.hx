
/**
 * ...
 * @author Jacob White
 */

import haxepunk.graphics.Image;
 
class Enemy1 extends Enemy
{	
	override public function new(xx:Int, yTarget:Int, speed:Int)
	{
		super();
		
		image = new Image("gfx/enemy1.png");
		graphic = image;
		setHitbox(24, 24, -4, -4);

		value = 250;
		inPosition = false;
		this.speed = speed;
		baseShootChance = 13;
		lightningSpeed = 140 + (Globals.curWave * 5);
		targY = yTarget;
		x = xx;
		dir = 1;
	}
}
