package com.nikos.mytransitions
{
import flash.display.*;
import flash.geom.*;
import flash.events.*;
import flash.filters.*;
import flash.utils.*;

// TweenMax
import com.greensock.*;

import com.nikos.utils.TransitionUtils;

public class Dissolve extends Transition
{
	public static var useFrames:Boolean=true;
	public static var persist:Boolean=true;
	public static var dispatch:Boolean=true;
	public static var startNow:Boolean=true;
	
	private var holder:Sprite=null,obj:Object,newt:Bitmap,newt2:Bitmap,_bmpDataPerlin:BitmapData;
	
	public function Dissolve()
	{
		super();
	}
	
	override public function doit(params:Object):void
	{
	
	var t:DisplayObject, t2:DisplayObject, duration:Number, eas:Function;
	t=params.fromTarget;
	t2=params.toTarget;
	duration=params.duration;
	eas=params.easing;
	
	if (Transition.useGlobal)
	{
		useFrames=Transition.useFramesGlobal;
		persist=Transition.persistGlobal;
		dispatch=Transition.dispatchGlobal;
		startNow=Transition.startNowGlobal;
	}
	
	
	holder=new Sprite();
    var rect:Rectangle;
    var pt:Point;
    newt=TransitionUtils.createTiles(t)[0];
    newt2=TransitionUtils.createTiles(t2)[0];
	holder.addChild(newt2);
	holder.addChild(newt);
	addChild(holder);
	
    // capture the _clip as a bitmap
    _bmpDataPerlin = new BitmapData(newt.width,newt.height,false);
    _bmpDataPerlin.perlinNoise(50,50,2,1,true,true,7,true);
    rect = new Rectangle(0,0,_bmpDataPerlin.width,_bmpDataPerlin.height);
    pt = new Point(0,0);
	//var threshold:uint = 0x7F000000;
	var threshold:uint = 0xFFFFFF;
	var color:uint = 0x00FF00;
	var maskColor:uint = 0xffffff;
	obj={value:1.0}
	TweenMax.to(obj, duration, {delay:0, useFrames:useFrames, immediateRender:startNow, value:0.0, ease:eas, onUpdate:applyEffect, onComplete:doall});
	
	function applyEffect():void
    {     
		newt.bitmapData.threshold(_bmpDataPerlin, rect, pt, ">=", (obj.value *threshold), color, maskColor, false);
    }
	}
	
	override public function kill():void
	{
		//trace("kill 1");
		if (holder==null) return;
		//trace("kill 2");
		var tweens:Array=TweenMax.getTweensOf(obj);
		for (var j=0;j<tweens.length;j++)
		{
			tweens[j].complete(false);//.setEnabled(false, false); // kill tweens
		}
		//doall();
	}
	
	private function doall()
	{
		_bmpDataPerlin.dispose();
		this.removeChild(holder);
		newt.bitmapData.dispose();
		holder=null;
		if (persist)
		{
			this.addChild(newt2);
		}
		else newt2.bitmapData.dispose();
		if (dispatch)
		{
			this.dispatchEvent(new Event(eventType));
		}
	}
}
}