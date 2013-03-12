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

public class Fly extends Transition
{
	public static var useFrames:Boolean=true;
	public static var persist:Boolean=true;
	public static var dispatch:Boolean=true;
	public static var startNow:Boolean=true;
	
	private var newt0:Bitmap=null,newt1:Bitmap;
	
	public function Fly()
	{
		super();
	}
	
	override public function doit(params:Object):void
	{
	var startp:String="top-left";
	
	var t0:DisplayObject, t1:DisplayObject, duration:Number, eas:Function;
	t0=params.fromTarget;
	t1=params.toTarget;
	duration=params.duration;
	eas=params.easing;
	
	if (Transition.useGlobal)
	{
		useFrames=Transition.useFramesGlobal;
		persist=Transition.persistGlobal;
		dispatch=Transition.dispatchGlobal;
		startNow=Transition.startNowGlobal;
	}
	
	if (params!=null)
	{
		startp=((params.mode!=null)?params.mode:startp);
	}
	
	var ix,iy,fx,fy;
	var sw=t0.width;
	var sh=t0.height;
	fx=0;
	fy=0;
	switch(startp)
	{
			case "top-right":
								ix=sw;
								iy=-t1.height;
								break;
			case "bottom-left":
								ix=-t1.width;
								iy=sh;
								break;
			case "bottom-right":
								ix=sw;
								iy=sh;
								break;
			case "left":
								ix=-t1.width;
								iy=fy;
								break;
			case "right":
								ix=sw;
								iy=fy;
								break;
			case "bottom":
								ix=fx;
								iy=sh;
								break;
			case "top":
								ix=fx;
								iy=-t1.height;
								break;
			case "top-left":
			default:
								ix=-t1.width;
								iy=-t1.height;
								break;
	}
	newt0=TransitionUtils.createTiles(t0)[0];
	newt1=TransitionUtils.createTiles(t1)[0];
	addChild(newt0);
	newt1.x=ix;
	newt1.y=iy;
	var tthis=this;
	TweenMax.to(newt1, duration, {onComplete:doall, onInit:init, useFrames:useFrames, immediateRender:startNow, x:fx, y:fy, ease:eas});
	
	
	function init():void
	{
		tthis.addChild(newt1);
	}
	}
	
	override public function kill():void
	{
		if (newt0==null) return;
		var tweens:Array=TweenMax.getTweensOf(newt1);
		for (var j=0;j<tweens.length;j++)
		{
			tweens[j].complete(false);//.setEnabled(false, false); // kill tweens
		}
		//doall();
	}
	
	private function doall():void
	{
		removeChild(newt0);
		newt0.bitmapData.dispose();
		newt0=null;
		if (!(persist))
		{
			this.removeChild(newt1);
			newt1.bitmapData.dispose();
		}
		if (dispatch)
		{
			this.dispatchEvent(new Event(eventType));
		}		
	}
}
}