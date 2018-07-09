import haxepunk.Entity;
#if (HaxePunk <= "2.6.1")
import haxepunk.graphics.Emitter;
#else
import haxepunk.graphics.emitter.Emitter;
#end

class Twinkle extends Entity
{
	private var emitter:Emitter;

	override public function new()
	{
		super();

		//the "twinkle" trail behind falling pickups
		emitter = new Emitter("gfx/twinkle.png", 6, 6);
		emitter.newType("twinkle", [0, 1, 2, 3, 1, 0, 4, 5]);
		emitter.setMotion("twinkle", 0, 0, 0.5);

		graphic = emitter;
		layer = -5;
	}

	public function twinkle(x:Float, y:Float)
	{
		emitter.emit("twinkle", x, y);
	}
}