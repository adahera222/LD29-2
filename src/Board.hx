package ;
import Main;
/**
 * ...
 * @author zacaj
 */
class Board
{
	public static var d:Array<Array<Block>>;
	public static var w:Int;
	public static var h:Int;
	public static function initBoard(_w:Int, _h:Int) 
	{
		w = _w;
		h = _h;
		d = new Array<Array<Block>>();
		for (i in  0...w)
		{
			var row:Array<Block> = new Array<Block>();
			for (j in 0...h)
			{
				row.push(null);
			}
			d.push(row);
		}
	}
	public static function makeRegularBoard(w:Int, h:Int)
	{
		for (i in 0...w)
		{
			var j = Board.h;
			while (--j>=Board.h - h)
			{
				var b=null;
				while (b==null)
				{
					var b1 = Block.getBlock(i, j);
					var bs = b1.getAdjacentBlocks();
					var match = false;
					for (b2 in bs)
						if (b2.matches(b1))
						{
							match = true;
							break;
						}
					if (!match)
						b = b1;
				}
				Main.addBlock(b);
			}
		}
	}
	public static function clear()
	{
		for (i in  0...w)
		{
			for (j in 0...h)
			{
				d[i][j] = null;
			}
		}
	}
	public static function update()
	{
		for (i in  0...w)
		{
			for (j in 0...h)
			{
				
			}
		}
	}
	public static function isIn(X:Int, Y:Int):Bool
	{
		if (X >= 0 && X < Board.w && Y >= 0 && Y < Board.h)
		return true;
		return false;
	}
}