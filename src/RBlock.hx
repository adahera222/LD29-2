package ;

/**
 * ...
 * @author zacaj
 */
class RBlock extends Block
{
	var type:Int;
	public function new(_X:Int, _Y:Int,_type:Int) 
	{
		super(_X, _Y,openfl.Assets.getBitmapData("img/block"+_type+".png"));
		type = _type;
	}
	override public function matches(b:Block):Bool 
	{
		if (!(Std.is(b,RBlock)))
			return false;
		var rb = cast(b, RBlock);
		return rb.type == type;
	}
	override public function adjacentBlockChanged(block:Block) 
	{
		super.adjacentBlockChanged(block);
		
	}
}