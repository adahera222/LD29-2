package ;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.KeyboardEvent;
import flash.Lib;

/**
 * ...
 * @author zacaj
 */
class Main extends Sprite 
{
	public static var m:Main;
	var inited:Bool;
	/* ENTRY POINT */
	var _deltaTime = 0.0;
	var _lastTime=0.0;
	var _speed = 1000 / 40;
	public static var combo = 0;
	public static var comboTimeLeft = -1;
	public static var score = 0;
	public static var nextScore = 0;
	public static var addScore = 0;
	public static var groups:Array<Int>;
	public static var animating = false;
	public static var wasAnimating = false;
	public static var gameover = false;
	public static var guiObjects:Array<Object_>;
	var combos = true;
	
	public var objects:Array<Object_>;
	public var blocks:Array<Block>;
	
	public var lastState:Array<Array<Block>> = null;
	public var changeCheckers:Array<ChangeChecker>;
	
	public var blocksToRemove:Array<Block>;

	function onEnterFrame(e) {
		var now:Float = Lib.getTimer();
		var delta = now - _lastTime;
		_deltaTime += delta - _speed;
		_lastTime = now;
		if (addScore > 0)
		{
			var change:Int=Math.floor(Math.max(Math.min(Math.max(Math.floor(addScore * .003), Math.floor(score*.05)),addScore),1));
			score += change;
			addScore-= change;
		}
		if (gameover)
			return;
		Board.clear();
		animating = false;
		for (block in blocks)
		{
			block.update(delta);
		}
		for (block in blocksToRemove)
			removeBlock(block);
		blocksToRemove.splice(0, blocksToRemove.length);
		for (object in objects)
		{
			object.update(delta);
		}
		if (!animating && wasAnimating)
		{
			var oldGroupLength:Int = groups.length;
			for (i in 0...Board.w)
			{
				for (j in 0...Board.h)
				{
					if (lastState[i][j] != Board.d[i][j])
					{
						if (Board.d[i][j] != null)
						{
							for (c in changeCheckers)
								c.blockChanged(Board.d[i][j]);
							var bs:Array<Block> = Board.d[i][j].getAdjacentBlocks();
							for (b in bs)
							{
								b.adjacentBlockChanged(Board.d[i][j]);
								Board.d[i][j].adjacentBlockChanged(b);
							}
						}
					}
				}
			}
			if (Block.primed.length > 0)
			{		
				combo++;
				comboTimeLeft = 60;
				combo += Math.floor(Math.max(groups.length-oldGroupLength - 1,0));
			}
			updateNextScore();
			while (Block.primed.length > 0)
			{
				var b = Block.primed.shift();
				Main.removeBlock(b);
				addBlock(new Explosion(b.X, b.Y,60));
			}
			updateLastState();
		}
		wasAnimating = animating;
		if (!animating)
		{
			comboTimeLeft--;
			if (comboTimeLeft == 0)
			{
				//combo += groups.length - combo;
				updateNextScore();
				addScore+= nextScore * combo;
				nextScore = 0;
				combo = 0;
				comboTimeLeft = -1;
				groups.splice(0, groups.length);
			}
		}
	}
	function updateNextScore()
	{
		nextScore = 0;
		for (c in changeCheckers)
			c.updateNextScore();
	}
	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
	}
	function onMouseDown(e:MouseEvent) 
	{
		return;
		//bitmap.x = e.localX;
		//bitmap.y = e.localY;
	#if html5
	trace(e.localX);
	//	e.localX -= x;
	trace(e.localY);
	//	e.localY -= y;
		#end
		var row = Math.floor((e.localY) / Block.size);
		var column = Math.floor((e.localX) / Block.size);
		if(Board.isIn(column,row))
		Main.removeBlock(Board.d[column][row]);
		/*var end = Board.d[0][row];
		for (i in 0...Board.w - 1)
		{
			Board.d[i][row] = Board.d[i + 1][row];
			if (Board.d[i][row] != null)
			{
				Board.d[i][row].tx -= Block.size;
			}
		}
		Board.d[Board.w - 1][row] = end;
		if (end != null)
		{
			end.x = Board.w*Block.size;
			end.tx = end.x - Block.size;
		}*/
	}
	function onKeyDown(e:KeyboardEvent)
	{
		//if (e.keyCode == 38)
			//bitmap.y -=5;
	}
	public static function addBlock(b:Block)
	{
		m.addChild(b);
		m.blocks.push(b);
		
		b.place();
	}
	public static function addObject(b:Object_)
	{
		m.addChild(b);
		m.objects.push(b);
	}
	public static function removeBlock(b:Block)
	{
		if (b == null)
		return;
		
		m.blocks.remove(b);
		m.removeChild(b);
		Board.d[b.X][b.Y] = null;
	}
	function init() 
	{
		if (inited) return;
		inited = true;
		guiObjects=new Array<Object_>();
		_lastTime = Lib.getTimer();
		groups = new Array<Int>();
		y = 4 * 48;
		x = 48;
		var q = Math.random();
		Board.initBoard(8, 12);
		updateLastState();
		if (false)
		{
		Board.makeRegularBoard(8, 4);
		objects.push(new Gravity(0,1));
		//objects.push(new Filler(0));
		objects.push(new BottomFiller());
		changeCheckers.push(new FloodChecker(3));
		//Main.addObject(new ISwap(stage,1,0));
		}
		else
		{
			var dir:Int = rand([96, 0, 1, 1, 1, 2, 1, 3]);
			var dir2:Int = dir;
			if (rand([99.9, 1, .1, 0]) == 0)
				dir2=rand([96, 0, 1, 1, 1, 2, 1, 3]);
			var vx=1, vy=0,hor=true;
			switch(dir2)
			{
				case 0:
					vx = 0;
					vy = 1;
				case 1:
					vx = -1;
					vy = 0;
					hor = false;
				case 2:
					vx = 0;
					vy = -1;
				case 3:
					vx = 1;
					vy = 0;
					hor = false;
			}
			var fill:Int = 0;
			if(hor)
				Board.makeRegularBoard(rand([95, 8, 5, Math.floor(Math.random() * 8)]), fill=rand([70, 4, 40, 5, 40, 3, 20, 12, 30, 2, 30, Math.floor(Math.random() * 8) + 4]));
			else
				Board.makeRegularBoard(fill=rand([70, 3, 40, 2, 20, 8, 30, 1, 30, Math.floor(Math.random() * 4) + 4]), rand([95, 12, 5, Math.floor(Math.random() * 12)]));
			
			if (rand([95, 1, 5, 0]) == 0)
				combos = false;
			
			if (rand([99.9, 1, .1, 0]) == 1)
				objects.push(new Gravity(vx, vy));
			
			for(i in 0...rand([99.999,1,.0001,2]))
			switch(rand([fill<8?95:1, 0, 5, 1]))
			{
				case 0:
					objects.push(new BottomFiller());
				case 1:
					objects.push(new Filler(rand([99.99,dir,.001,Math.floor(Math.random()*4)])));
			}
			switch(rand([70, 0, 70, 1]))
			{
				case 0:
					guiObjects.push(new IRotateH(stage));
				case 1:
					if (rand([95, 1, 5, 0]) == 1)
						guiObjects.push(new ISwap(stage, 1, 0));
					else
						guiObjects.push(new ISwap(stage, 0, 1));
				case 2:
					guiObjects.push(new IRemove(stage));
			}
			switch(rand([100, 0]))
			{
				case 0:			
					changeCheckers.push(new FloodChecker(rand([99,3,1,4])));
			}
		}
	}
	public function rand(a:Array<Float>):Int
	{
		var i = 0;
		while (i<a.length)
		{
			if (Math.random() * 100 < a[i])
				return Math.floor(a[i + 1]);
			i += 2;
		}
		return Math.floor(a[1]);
	}
	public function updateLastState()
	{
		lastState = new Array<Array<Block>>();
		for (i in 0...Board.w)
		{
			var row:Array<Block> = new Array<Block>();
			for (j in 0...Board.h)
			{
				row.push(Board.d[i][j]);
			}
			lastState.push(row);
		}
	}
	public function new() 
	{
		super();	
		blocks = new Array<Block>();
		blocksToRemove = new Array<Block>();
		objects = new Array<Object_>();
		changeCheckers = new Array<ChangeChecker>();
		Main.m = this;
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	public static function gameOver()
	{
		gameover = true;
		
				Main.m.updateNextScore();
				addScore+= nextScore * combo;
				nextScore = 0;
				combo = 0;
				comboTimeLeft = -1;
				groups.splice(0, groups.length);
	}
	public static function main() 
	{
		Block.primed = new Array<Block>();
		// static entry point
		//Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.EXACT_FIT;
		Lib.current.addChild(new Main());
		Lib.current.addChild(new Gui());
	}
	public static 
function insertInto(a:Array<Dynamic > , i:Dynamic )
{
	var found = false;
	for (e in a)
		if (e == i)
		{
			found = true;
			break;
		}
	if (!found)
		a.push(i);
}
}
