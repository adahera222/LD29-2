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
	public static var m;
	var inited:Bool;
	/* ENTRY POINT */
	var _deltaTime = 0.0;
	var _lastTime=0.0;
	var _speed = 1000 / 40;
	
	public var blocks:Array<Block>;

	function onEnterFrame(e) {
		var now:Float = Lib.getTimer();
		var delta = now - _lastTime;
		_deltaTime += delta - _speed;
		_lastTime = now;
		Board.clear();
		for (block in blocks)
		{
			block.update(delta);
		}
	}

	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
	}
	function onMouseDown(e:MouseEvent)
	{
		//bitmap.x = e.localX;
		//bitmap.y = e.localY;
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
	function init() 
	{
		if (inited) return;
		inited = true;
		_lastTime = Lib.getTimer();
		Board.initBoard(8, 12);
		Board.makeRegularBoard(8, 4);
		// (your code here)
		
		// Stage:
		// stage.stageWidth x stage.stageHeight @ stage.dpiScale
		
		// Assets:
	//	var bitmapData = openfl.Assets.getBitmapData("img/avatar.png");
		//bitmap = new Bitmap(bitmapData);
		//addChild(bitmap);
	}

	/* SETUP */

	public function new() 
	{
		super();	
		blocks = new Array<Block>();
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
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
}
