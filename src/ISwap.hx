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
	public static var vx:Int;
	public static var vy:Int;
	public function onKeypress(e:KeyboardEvent)
	{ 
		var code:Int = e.keyCode;
		switch(code)
		{
			case 38://up
				if(y>edge)
					y -= Block.size;
			case 40://down
				if (y < Block.size * (Board.h - vy)-edge)
					y += Block.size;
			case 37://left
				if (x > edge)
					x -= Block.size;
			case 39://right
				if (x < Block.size * (Board.w - vx)-edge)
					x += Block.size;
			case 32://space
				var X = Math.floor((x + 3 + Block.size / 2) / Block.size);
				var Y = Math.floor((y + 3 + Block.size / 2) / Block.size);
				var a = Board.d[X][Y];
				var b = Board.d[X + vx][Y+vy];
				var ax = (a!=null)?a.x:(X)*Block.size;
				var ay = (a != null)?a.y:(Y) * Block.size;
				var bx = (b!=null)?b.x:(X+vx)*Block.size;
				var by = (b != null)?b.y:(Y + vy) * Block.size;
				if (b != null)
				{
					b.tx = ax;
					b.ty = ay;
					b.place();
				}
				if (a != null)
				{
					a.tx = bx;
					a.ty = by;
					a.place();
				}
		}
	}
	public function new(_stage:Dynamic,_vx:Int=1,_vy:Int=0) 
	{
		var path = "";
		vx = _vx;
		vy = _vy;
		if (vx != 0 && vy == 0)
			path = "img/SwapH.png";
		if (vx == 0 && vy != 0)
			path = "img/SwapV.png";
		if (vx !=0 && vy < 0)
			path = "img/SwapUR.png";
		if (vx !=0 && vy > 0)
			path = "img/SwapDR.png";
		super(openfl.Assets.getBitmapData(path));
		//_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeypress);
		x = Block.size * 4-edge;
		y = Block.size * 8 - edge;
	}
	override public function delete()
	{
		//stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeypress);
	}
	
}