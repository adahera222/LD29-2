package ;
import flash.display.Bitmap;
import flash.display.BitmapData;

/**
 * ...
 * @author zacaj
 */
class Block extends Bitmap
{
	public var X:Int;
	public var Y:Int;
	public var tx:Float;
	public var ty:Float;
	public static var primed:Array<Block>;
	public static var size = 48;
	public var speed = 3.0;
	public function new(_X:Int,_Y:Int,data:BitmapData=null) 
	{
		if (data == null)
			data = openfl.Assets.getBitmapData("img/block.png");
		super(data);
		X = _X;
		Y = _Y;
		x = X * size;
		y = Y * size;
		tx = x;
		ty = y;
	}
	public function adjacentBlockChanged(block:Block){};
	public static function getBlock(x:Int=-1,y:Int=-1):Block
	{
		return new RBlock( x,y, Math.floor(Math.random() * 6)+1);
	}
	public function place()
	{
		var oldX = X;
		var oldY = Y;
		X = Math.floor((tx+size/2) / size);
		Y = Math.floor((ty + size / 2) / size);//yay strong static typing!!!!
		//if (X != oldX || Y != oldY)
		{
			if(Board.isIn(oldX,oldY))
				Board.d[oldX][oldY] = null;
			if (Board.isIn(X, Y))
				Board.d[X][Y] = this;
		}
	}
	public function update(delta:Float)
	{
		if (x != tx || y != ty )
		{	
			Main.animating = true;
			var dx = tx - x;
			var dy = ty - y;
			var length = Math.sqrt(dx * dx + dy * dy);
			if (length > speed)
			{
				dx /= length;
				dy /= length;
				dx *= speed;
				dy *= speed;
				x += dx;
				y += dy;
			}
			else
			{
				x = tx;
				y = ty;
			}
		}
		else
			place();
	}
	public function matches(b:Block):Bool
	{
		return Type.getClassName(Type.getClass(b)) == "Block";
	}
	public function getAdjacentBlocks():Array<Block>
	{
		var bs = new Array<Block>();
		if (X > 0)
			if (Board.d[X - 1][Y] != null)
				bs.push(Board.d[X - 1][Y]);
		if (X < Board.w-1)
			if (Board.d[X + 1][Y] != null)
				bs.push(Board.d[X + 1][Y]);
		if (Y > 0)
			if (Board.d[X][Y-1] != null)
				bs.push(Board.d[X][Y-1]);
		if (Y < Board.h-1)
			if (Board.d[X ][Y+1] != null)
				bs.push(Board.d[X][Y + 1]);
		return bs;
	}
}