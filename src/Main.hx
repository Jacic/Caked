
/**
 * ...
 * @author Jacob White
 */

import haxepunk.Engine;
import haxepunk.HXP;

class Main extends Engine
{
	public function new()
	{
		super(640, 480, 60, false);
	}

	override public function init()
	{
	#if debug
		#if (HaxePunk <= "2.6.1")
		HXP.console.enable();
		#else
		haxepunk.debug.Console.enable();
		#end
	#end

		Particles.twinkle = new Twinkle();
		Particles.candletrail = new CandleTrail();
		Particles.deatheffects = new DeathEffects();

		HXP.scene = new TitleScene();
	}

	public static function main()
	{
		var app = new Main();
	}
}