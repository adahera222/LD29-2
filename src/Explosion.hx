package ;

import flash.display.BitmapData;

/**
 * ...
 * @author zacaj
 */
class Explosion extends Block
{
	var life:Int;
	public function new(_X:Int, _Y:Int,_life:Int=22) 
	{
		super(_X, _Y, openfl.Assets.getBitmapData("img/explosion.png"));
		life = _life;
	}
	override public function update(delta:Float) 
	{
		life--;
		if (life <= 0)
			Main.m.blocksToRemove.push(this);
		else
			Main.animating = true;
		super.update(delta);
	}
	override public function matches(b:Block):Bool 
	{
		return false;
	}
}