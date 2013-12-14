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
	static var primed:Array<Block>;
	static var size = 40;
	public function new(_X:Int,_Y:Int,data:BitmapData=null) 
	{
		if (data == null)
			data = openfl.Assets.getBitmapData("img/block.png");
		super(data);
		X = _X;
		Y = _Y;
		x = X * size;
		y = Y * size;
	}
	public function adjacentBlockChanged(block:Block){};
	public static function getBlock(x:Int=-1,y:Int=-1):Block
	{
		return new RBlock( x,y, Math.floor(Math.random() * 6)+1);
	}
	public function place()
	{
		X = Math.floor((x+size/2) / size);
		Y = Math.floor((y+size/2) / size);//yay strong static typing!!!!
		Board.d[X][Y] = this;
	}
	public function update(delta:Float)
	{
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