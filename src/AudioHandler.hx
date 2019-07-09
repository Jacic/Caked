import haxepunk.Sfx;

class AudioHandler
{
	private static var instance:AudioHandler;

	public var bgm(default, null):Sfx;
	public var enemyHit(default, null):Sfx;
	public var enemyShoot(default, null):Sfx;
	public var timeAddToScore(default, null):Sfx;
	public var lifeAddToScore(default, null):Sfx;
	public var longExplosion(default, null):Sfx;
	public var pickup(default, null):Sfx;
	public var playerDead(default, null):Sfx;
	public var playerHit(default, null):Sfx;
	public var playerShoot(default, null):Sfx;
	public var superCandleShoot(default, null):Sfx;

	private function new()
	{
		bgm = new Sfx("audio/bgm.wav");
		enemyHit = new Sfx("audio/enemyhit.wav");
		enemyShoot = new Sfx("audio/enemyshoot.wav");
		timeAddToScore = new Sfx("audio/timeaddtoscore.wav");
		lifeAddToScore = new Sfx("audio/lifeaddtoscore.wav");
		longExplosion = new Sfx("audio/longexplosion.wav");
		pickup = new Sfx("audio/pickup.wav");
		playerDead = new Sfx("audio/playerdead.wav");
		playerHit = new Sfx("audio/playerhit.wav");
		playerShoot = new Sfx("audio/playershoot.wav");
		superCandleShoot = new Sfx("audio/supercandleshoot.wav");
	}

	public static function getInstance():AudioHandler
	{
		if(instance == null)
		{
			instance = new AudioHandler();
		}

		return instance;
	}
}