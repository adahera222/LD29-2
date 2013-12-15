package ;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
/**
 * ...
 * @author zacaj
 */
class ISwap extends Object_
{
	public static var edge = 3;
	public function onKeypress(e:KeyboardEvent)
	{
		var code:Int = e.keyCode;
		switch(code)
		{
			case 38://up
				if(y>edge)
					y -= Block.size;
			case 40://down
				if (y < Block.size * Board.h - Block.size-edge)
					y += Block.size;
			case 37://left
				if (x > edge)
					x -= Block.size;
			case 39://right
				if (x < Block.size * (Board.w - 2)-edge)
					x += Block.size;
			case 32://space
				var X = Math.floor((x + 3 + Block.size / 2) / Block.size);
				var Y = Math.floor((y + 3 + Block.size / 2) / Block.size);
				var a = Board.d[X][Y];
				var b = Board.d[X + 1][Y];
				var tempx = b.x;
				var tempy = b.y;
				b.tx = a.x;
				b.ty = a.y;
				a.tx = tempx;
				a.ty = tempy;
				a.place();
				b.place();
		}
	}
	public function new(_stage:Dynamic) 
	{
		super(openfl.Assets.getBitmapData("img/Swap.png"));
		//_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeypress);
		x = Block.size * 4-edge;
		y = Block.size * 8-edge;
	}
	override public function delete()
	{
		//stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeypress);
	}
	
}