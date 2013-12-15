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
		return;
		switch(side)
		{
			case 0://top
				for (i in 0...Board.w)
				{
					if (Board.d[i][0] == null)
					{
						var b = Block.getBlock(i, -1);
						b.ty += Block.size;
						Main.addBlock(b);
					}
				}
			case 1://right
				for (i in 0...Board.h)
				{
					if (Board.d[Board.w-1][i] == null)
					{
						var b = Block.getBlock(Board.w,i);
						b.tx -= Block.size;
						Main.addBlock(b);
					}
				}
			case 2://bottom
				for (i in 0...Board.w)
				{
					if (Board.d[i][Board.h-1] == null)
					{
						var b = Block.getBlock(i,Board.h);
						b.ty -= Block.size;
						Main.addBlock(b);
					}
				}
			case 3://left
				for (i in 0...Board.h)
				{
					if (Board.d[0][i] == null)
					{
						var b = Block.getBlock(-1,i);
						b.tx += Block.size;
						Main.addBlock(b);
					}
				}
		}
	}
	
}