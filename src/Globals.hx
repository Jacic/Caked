
/**
 * ...
 * @author Jacob White
 */
 
class Globals
{
	public static inline var basePickupDropChance:Float = 0.04;
	public static inline var maxLife:Int = 3;
	public static inline var numWaves:Int = 5;
	public static var pickupDropChance:Float;
	public static var enemiesDefeatedSincePickup:Int;
	public static var curWave:Int;
	public static var playing:Bool;
	public static var enemiesInWave:Int;
	public static var enemiesArray:Array<Enemy>;
	public static var numInPos:Int;
	public static var allInPos:Bool;
	public static var inControl:Bool;
	public static var player:Player;
	public static var candles:Array<Candle>;
	public static var time:Float;
	public static var score:Int;
}
