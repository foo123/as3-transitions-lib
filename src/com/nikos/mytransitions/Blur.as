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

public class Blur extends Transition
{
	public static var useFrames:Boolean=true;
	public static var persist:Boolean=true;
	public static var dispatch:Boolean=true;
	public static var startNow:Boolean=true;
	
	private var holder:Sprite=null,newt:Bitmap,newt2:Bitmap,obj:Object;
	
	public function Blur()
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
    newt=TransitionUtils.createTiles(t)[0];
    newt2=TransitionUtils.createTiles(t2)[0];
	holder.addChild(newt2);
	holder.addChild(newt);
	addChild(holder);
	var qual=1;
	var blurf=new BlurFilter(0,0,qual);
	obj={value:-1.0}
	TweenMax.to(obj, duration, {delay:0, useFrames:useFrames, immediateRender:startNow, value:1.0, ease:eas, onUpdate:applyEffect, onComplete:doall});
	
	function applyEffect():void
    {     
		var maxbX=150;
		var tt=1-Math.abs(obj.value);
		blurf.blurX=tt*maxbX;
		holder.filters=[blurf];
		newt.alpha=1-0.5*(1+obj.value);
		newt2.alpha=1-newt.alpha;
    }
	}
	
	override public function kill():void
	{
		if (holder==null) return;
		var tweens:Array=TweenMax.getTweensOf(obj);
		for (var j=0;j<tweens.length;j++)
		{
			tweens[j].complete(false);//.setEnabled(false, false); // kill tweens
		}
		//doall();
	}
	
	private function doall()
	{
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