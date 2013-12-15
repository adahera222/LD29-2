package ;

import haxe.ds.ObjectMap;
/**
 * ...
 * @author zacaj
 */
class FloodChecker extends ChangeChecker
{
	public var min:Int;
	public function new(_min:Int) 
	{
		super();
		min = _min;
	}
	override public function updateNextScore() 
	{
		super.updateNextScore();
		for (i in Main.groups)
		{
			Main.nextScore += i * 100 + 100 * (i - min);
		}
	}
	override public function blockChanged(block:Block) 
	{
		super.blockChanged(block);
			var checked = new ObjectMap<Block,Bool>();
			var tocheck = [block];
			var match = new Array<Block>();
			while (tocheck.length > 0)
			{
				var checking = tocheck.shift();
				var bs = checking.getAdjacentBlocks();
				for (b in bs)
				{
					if (b.matches(checking))
					{
						Main.insertInto(match , b);
						if (!checked.exists(b))
							Main.insertInto(tocheck, b);
					}
				}
				checked.set(checking,true);
			}
			if (match.length >= min)
			{
				for(b in match)
					Main.insertInto(Block.primed, b);
				Main.groups.push(match.length);
			}
	}
}