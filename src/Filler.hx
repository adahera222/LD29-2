package ;

/**
 * ...
 * @author zacaj
 */
class Filler extends Object_
{
	public var side:Int;
	public function new(_side:Int=0) 
	{
		super(openfl.Assets.getBitmapData("img/none.png"));
		side = _side;
	}
	override public function update(delta:Float) 
	{
		super.update(delta);
		if (Main.animating)
			return;
		switch(side)
		{
			case 0://top
				for (i in 0...Board.w)
				{
					var j = 0;
					while (Board.d[i][j] == null) { j++; };
					for (k in 0...j)
					{
						var b = Block.getBlock(i, -1-k);
						b.ty = Block.size*(j-k-1);
						Main.addBlock(b);
					}
				}
			case 1://right
				for (i in 0...Board.h)
				{
					var j = 0;
					while (Board.d[Board.w-1-j][i] == null) { j++; };
					for (k in 0...j)
					{
						var b = Block.getBlock(Board.w+k,i);
						b.tx = Board.w*Block.size-Block.size*(j-k);
						Main.addBlock(b);
					}
				}
			case 2://bottom
				for (i in 0...Board.w)
				{
					var j = 0;
					while (Board.d[i][Board.h-1-j] == null) { j++; };
					for (k in 0...j)
					{
						var b = Block.getBlock(i,Board.h+k);
						b.ty = Board.h*Block.size-Block.size*(j-k);
						Main.addBlock(b);
					}
				}
			case 3://left
				for (i in 0...Board.h)
				{
					var j = 0;
					while (Board.d[j][i] == null) { j++; };
					for (k in 0...j)
					{
						var b = Block.getBlock(-1-k,i);
						b.tx = Block.size*(j-k-1);
						Main.addBlock(b);
					}
				}
		}
	}
	
}