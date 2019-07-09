
/**
 * ...
 * @author Jacob White
 */

import haxepunk.graphics.Spritemap;
import haxepunk.HXP;
 
//This enemy moves down the screen each time it reaches the screen edge, and thus may collide with the player
class Enemy3 extends Enemy
{
	private var movingDown:Bool;
	private var newYTarg:Float;
	private var rowNum:Int;

	override public function new(xx:Int, yTarget:Int, speed:Int, rowNum:Int)
	{
		super();
		
		image = new Spritemap("gfx/enemy3.png", 30, 30);
		image.add("move", [0, 1, 0, 2, 3, 0, 4, 5], 4, true);
		image.play("move");
		graphic = image;
		setHitbox(24, 24, -4, -4);

		value = 750;
		this.speed = speed;
		this.rowNum = rowNum;
		baseShootTimer = 1.3;
		baseShootChance = 16;
		lightningSpeed = 160 + (Globals.curWave * 5);
		targY = yTarget;
		x = xx;
		dir = 1;
		movingDown = false;
		newYTarg = y;
	}

	override private function move()
	{
		if(movingDown)
		{
			if(y < newYTarg)
			{
				y += speed * HXP.elapsed;
			}
			else
			{
				y = newYTarg;
				movingDown = false;
			}
		}
		else
		{
			if(x + width - originX >= HXP.width)
			{
				dir = -1;
				x = HXP.width - width + originX;
				setNewYTarg();
			}
			else if(x - originX <= 0)
			{
				dir = 1;
				x = originX;
				setNewYTarg();
			}

			x += speed * dir * HXP.elapsed;
		}
	}

	//set new row to move to.
	private function setNewYTarg()
	{
		movingDown = true;
		newYTarg = y + Globals.ROW_Y_DIFF;
		if(newYTarg > 320 - ((Globals.numEnemyRows - rowNum) * Globals.ROW_Y_DIFF))
		{
			newYTarg = 320 - ((Globals.numEnemyRows - rowNum) * Globals.ROW_Y_DIFF);
		}
	}
}
