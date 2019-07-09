
/**
 * ...
 * @author Jacob White
 */
 
class Globals
{
	public static inline var BASE_PICKUP_DROP_CHANCE:Float = 0.04;
	public static inline var NUM_WAVES:Int = 5;
	public static inline var FLOOR_POS:Int = 440;
	public static inline var ROW_Y_DIFF:Int = 40;
	
	public static var pickupDropChance:Float;
	public static var enemiesDefeatedSincePickup:Int;
	public static var curWave:Int;
	public static var playing:Bool;
	public static var enemiesInWave:Int;
	public static var enemiesDefeated:Int;	//Number of enemies killed. Increments before enemy is removed from scene.
	public static var numEnemyRows:Int;
	public static var enemiesArray:Array<Enemy>;
	public static var numInPos:Int;
	public static var allInPos:Bool;
	public static var inControl:Bool;
	public static var player:Player;
	public static var candles:Array<Candle>;
	public static var time:Float;
	public static var score:Int;
}
