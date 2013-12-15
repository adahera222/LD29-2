package ;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
/**
 * ...
 * @author zacaj
 */
class IRotateH extends Object_
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
				if (y < Block.size * (Board.h - 0)-edge)
					y += Block.size;
			case 37://left
				var Y = Math.floor((y + 3 + Block.size / 2) / Block.size);
				var moved = new Array<Block>();
				if (Board.d[0][Y] != null)
				{
					Board.d[0][Y].x = Board.w * Block.size;
					Board.d[0][Y].tx = Board.d[0][Y].x - Block.size;
					moved.push(Board.d[0][Y]);
				}
				for (i in 1...Board.w)
				{
					if (Board.d[i][Y] != null)
					{
						Board.d[i][Y].tx -= Block.size;
						moved.push(Board.d[i][Y]);
					}
				}
				for (b in moved)
					b.place();
			case 39://left
				var Y = Math.floor((y + 3 + Block.size / 2) / Block.size);
				var moved = new Array<Block>();
				if (Board.d[Board.w-1][Y] != null)
				{
					Board.d[Board.w-1][Y].x = -Block.size;
					Board.d[Board.w-1][Y].tx = 0;
					moved.push(Board.d[Board.w-1][Y]);
				}
				for (i in 0...Board.w-1)
				{
					if (Board.d[i][Y] != null)
					{
						Board.d[i][Y].tx += Block.size;
						moved.push(Board.d[i][Y]);
					}
				}
				for (b in moved)
					b.place();
		}
	}
	public function new(_stage:Dynamic) 
	{
		var path = "";
			path = "img/RotateH.png";
		super(openfl.Assets.getBitmapData(path));
		//_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeypress);
		x = -edge;
		y = Block.size * 8 - edge;
	}
	override public function delete()
	{
		//stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeypress);
	}
	
}