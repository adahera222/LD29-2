package ;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.display.Sprite;

/**
 * ...
 * @author zacaj
 */
class Gui extends Sprite
{
	public static var gui:Gui;
	var inited:Bool;
	/* ENTRY POINT */
	var _deltaTime = 0.0;
	var _lastTime=0.0;
	var _speed = 1000 / 40;
	public static var score = 0;
	public var objectsToRemove:Array<Object_>;
	public var objects:Array<Object_>;
	public function new() 
	{
		super();
		Gui.gui = this;
		objectsToRemove = new Array<Object_>();
		objects = new Array<Object_>();
		addEventListener(Event.ADDED_TO_STAGE, added);
	}
	public static function addObject(b:Object_)
	{
		Gui.gui.addChild(b);
		Gui.gui.objects.push(b);
	}
	public static function removeObject(b:Object_)
	{
		if (b == null)
		return;
		
		Gui.gui.objects.remove(b);
		Gui.gui.removeChild(b);
	}
	function onEnterFrame(e) {
		var now:Float = Lib.getTimer();
		var delta = now - _lastTime;
		_deltaTime += delta - _speed;
		_lastTime = now;
		for (object in objects)
		{
			object.update(delta);
		}
		for (object in objectsToRemove)
			removeObject(object);
		objectsToRemove.splice(0, objectsToRemove.length);
	}
	function init() 
	{
		if (inited) return;
		inited = true;
		_lastTime = Lib.getTimer();
		y = 4 * 48;
		x = 48;
		Gui.addObject(new IRotateH(stage));
		//objects.push(new Filler(0));
	}
	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
	}
	function added(e)
	{init() ;
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
}