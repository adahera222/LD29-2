package ;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

/**
 * ...
 * @author zacaj
 */
class IRemove extends Object_
{
	
	public function onMouseMove(e:MouseEvent)
	{
		x = e.stageX;
		y = e.stageY;
	}
	public function onKeypress(e:KeyboardEvent)
	{
		var code:Int = e.keyCode;
		switch(code)
		{
			case 38://up
				if(y>0)
					y -= Block.size;
			case 40://down
				if (y < Block.size * Board.h - Block.size)
					y += Block.size;
			case 37://left
				if (x > 0)
					x -= Block.size;
			case 39://right
				if (x < Block.size * (Board.w - 1))
					x += Block.size;
		}
	}
	public function new(_stage:Dynamic) 
	{
		super(openfl.Assets.getBitmapData("img/Remove.png"));
		//_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeypress);
		x = Block.size * 4;
		y = Block.size * 8;
	}
	override public function delete()
	{
		//stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeypress);
	}
	
}