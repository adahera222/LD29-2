package ;

/**
 * ...
 * @author zacaj
 */
class Gravity extends Object_
{
	public var vx:Float;
	public var vy:Float;
	public function new(_vx,_vy) 
	{
		super(openfl.Assets.getBitmapData("img/none.png"));
		vx = _vx;
		vy = _vy;
	}
	override public function update(delta:Float) 
	{
		if (!Main.animating)
		{
			for (i in 0...Board.w)
			{
				var j = Board.h;
				while(--j>=0)
				//for(j in 0...Board.h)
				{
					var b:Block = Board.d[i][j];
					if (b != null)
					{
						var nx = Math.floor(b.X + vx);
						var ny = Math.floor(b.Y + vy);
						if(Board.isIn(nx,ny))
							if (Board.d[nx][ny] == null)
							{
								b.tx = nx * Block.size;
								b.ty = ny * Block.size;
								b.place();
								Main.animating = true;
							}
					}
				}
			}
		}
	}
	
}