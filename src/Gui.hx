package ;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.display.Sprite;
import flash.text.TextField;

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
	public var objectsToRemove:Array<Object_>;
	public var objects:Array<Object_>;
	public var comboText:TextField;
	public var score:TextField;
	public var addScore:TextField;
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
		
		if(Main.combo>0)
			comboText.text = Std.string(Main.nextScore) + " x" + Std.string(Main.combo);
			else
			comboText.text = "";
		score.text = Std.string(Main.score);
		StringTools.lpad(score.text, "0", 10);
		
		if (Main.addScore > 0)
			addScore.text = "+" + Std.string(Main.addScore);
			else
			addScore.text = "";
	}
	function init() 
	{
		if (inited) return;
		inited = true;
		_lastTime = Lib.getTimer();
		y = 4 * 48;
		x = 48;
		var bitmap;
		this.addChild(bitmap = new Bitmap(openfl.Assets.getBitmapData("img/border.png")));
		bitmap.x = -x;
		bitmap.y = -y;
		
		Gui.addObject(new IRotateH(stage));
		
		this.addChild(comboText = new TextField());
		comboText.x = 10-x;
		comboText.y = 80 - y;
		comboText.scaleX = comboText.scaleY = 1.8;
		comboText.textColor = 0xFFFFFF;
		
		this.addChild(score = new TextField());
		score.x = 10-x;
		score.y = 10 - y;
		score.scaleX = 3;
		score.scaleY = 3;
		score.textColor = 0xFFFFFF;
		
		this.addChild(addScore = new TextField());
		addScore.x = 20-x;
		addScore.y = 50 - y;
		addScore.scaleX = 2.1;
		addScore.scaleY = 2.1;
		addScore.textColor = 0xFFFFFF;
		
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