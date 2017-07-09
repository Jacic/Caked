import haxepunk.Entity;
#if (HaxePunk <= "2.6.1")
import haxepunk.graphics.Emitter;
#else
import haxepunk.graphics.emitter.Emitter;
#end

class DeathEffects extends Entity
{
	private var emitter:Emitter;

	override public function new()
	{
		super();

		emitter = new Emitter("gfx/deatheffects.png", 8, 8);
		emitter.newType("playerHit", [0, 1, 2, 3, 4]);
		emitter.setMotion("playerHit", 80, 90, 0.75, 20, 20);
		emitter.setGravity("playerHit", 10.0, 1.0);
		
		emitter.newType("playerDeath", [0, 1, 2, 3, 4]);
		emitter.setMotion("playerDeath", 0, 75, 0.9, 180, 15, 0.5);
		emitter.setGravity("playerDeath", 10.0, 1.0);
		
		emitter.newType("enemy1Death", [5, 6, 7, 8, 9]);
		emitter.setMotion("enemy1Death", 0, 75, 0.75, 180, 15, 0.5);
		emitter.setGravity("enemy1Death", 8.0, 1.0);
		
		emitter.newType("enemy2Death", [10, 11, 12, 13, 14]);
		emitter.setMotion("enemy2Death", 0, 75, 0.75, 180, 15, 0.5);
		emitter.setGravity("enemy2Death", 8.0, 1.0);

		graphic = emitter;
		layer = -5;
	}

	public function playerHit(x:Float, y:Float)
	{
		emitter.emit("playerHit", x, y);
	}
	
	public function playerDeath(x:Float, y:Float, width:Float, height:Float)
	{
		for(i in 0...10)
		{
			emitter.emitInRectangle("playerDeath", x, y, width, height);
		}
	}
	
	public function enemyDeath(enemyType:String, x:Float, y:Float, width:Float, height:Float)
	{
		for(i in 0...5)
		{
			switch(enemyType)
			{
				case "Enemy1":
					emitter.emitInRectangle("enemy1Death", x, y, width, height);
				case "Enemy2":
					emitter.emitInRectangle("enemy2Death", x, y, width, height);
			}
		}
	}
}