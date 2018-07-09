import haxepunk.Entity;
#if (HaxePunk <= "2.6.1")
import haxepunk.graphics.Emitter;
#else
import haxepunk.graphics.emitter.Emitter;
#end

class CandleTrail extends Entity
{
	private var emitter:Emitter;

	override public function new()
	{
		super();

		emitter = new Emitter("gfx/candletrail.png", 8, 8);
		emitter.newType("normalCandle", [5]);
		emitter.setMotion("normalCandle", 260, 10, 0.1, 20, 5);
		
		emitter.newType("superCandle", [0, 1, 2, 3, 4, 5]);
		emitter.setMotion("superCandle", 260, 10, 0.1, 20, 5);

		graphic = emitter;
		layer = -3;
	}

	public function normalCandle(x:Float, y:Float)
	{
		emitter.emit("normalCandle", x, y);
	}
	
	public function superCandle(x:Float, y:Float)
	{
		emitter.emit("superCandle", x, y);
	}
}