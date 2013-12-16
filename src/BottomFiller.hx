package ;

/**
 * ...
 * @author zacaj
 */
class BottomFiller extends Object_
{
	var originalY:Float;
	var blocks:Array<Block>;
	var time = 400;
	public function new() 
	{
		super(openfl.Assets.getBitmapData("img/none.png"));
		originalY = Main.m.y;
		blocks = new Array<Block>();
		reset();
	}
	override public function update(delta:Float) 
	{
		super.update(delta);
		if (Main.animating)
		return;
		for (i in 0...Board.w)
			if (Board.d[i][0] != null)
				{
					time--;
					Gui.gui.alert = true;
					if (time <= 0)
						Main.gameOver();
					return;
				}
				Gui.gui.alert = false;
		time = 400;
		Main.m.y -= .03;
		for (o in Gui.gui.objects)
			o.y -= .03;
		if (Main.m.y + Block.size <= originalY)
		{
			for (b in blocks)
				Main.m.blocks.push(b);
			for (b in Main.m.blocks)
			{
				b.y = b.ty = b.y - Block.size;
				b.place();
			}
			reset();
			Main.wasAnimating = true;
		}
	}
	function reset()
	{
		Main.m.y = originalY;
		blocks.splice(0, blocks.length);
		for (i in 0...Board.w)
		{
			var b:Block=null;
			while (true)
			{
				b = Block.getBlock(i,Board.h);
				if (((i > 0 && !b.matches(blocks[i-1])) ||i==0) && (Board.d[i][Board.h-1]!=null && !b.matches(Board.d[i][Board.h-1])))
						break;
			}
			blocks.push(b);
			Main.m.addChild(b);
		}
	}
}