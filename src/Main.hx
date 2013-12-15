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
	public static var animating = false;
	public static var wasAnimating = false;
	
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
			
			while (Block.primed.length > 0)
			{
				var b = Block.primed.shift();
				Main.removeBlock(b);
				addBlock(new Explosion(b.X, b.Y,60));
			}
			
			updateLastState();
		}
		wasAnimating = animating;
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
		_lastTime = Lib.getTimer();
		Board.initBoard(8, 12);
		Board.makeRegularBoard(8, 12);
		updateLastState();
		y = 4 * 48;
		x = 48;
		objects.push(new Gravity(0, 1));
		objects.push(new Filler(0));
		changeCheckers.push(new FloodChecker(3));
		//Main.addObject(new ISwap(stage,1,0));
		Main.addObject(new IRotateH(stage));
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
	
	public static function main() 
	{
		Block.primed = new Array<Block>();
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
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
