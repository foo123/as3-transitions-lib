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

public class DreamWave extends Transition
{
	public static var useFrames:Boolean=true;
	public static var persist:Boolean=true;
	public static var dispatch:Boolean=true;
	public static var startNow:Boolean=true;
	
	private var holder:Sprite=null,newt:Bitmap,newt2:Bitmap,ho:Object;
	
	public function DreamWave()
	{
		super();
	}
	
	override public function doit(params:Object):void
	{
	var speedx:Number=20;
	var speedy:Number=20;
	var maxx:Number=20, maxy:Number=20;
	var maxbx:Number=20,maxby:Number=20;
	var px:Number=1,py:Number=1,dx:Number=0,dy:Number=0;
	
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
	
	if (params!=null)
	{
		speedx=((params.speedx!=null)?params.speedx:speedx);
		speedy=((params.speedy!=null)?params.speedy:speedy);
		maxx=((params.maxx!=null)?params.maxx:maxx);
		maxy=((params.maxy!=null)?params.maxy:maxy);
		maxbx=((params.maxbx!=null)?params.maxbx:maxbx);
		maxby=((params.maxby!=null)?params.maxby:maxby);
		px=((params.px!=null)?params.px:px);
		py=((params.py!=null)?params.py:py);
		dx=((params.dx!=null)?params.dx:dx);
		dy=((params.dy!=null)?params.dy:dy);
	}
	
	holder=new Sprite();
	var sp2x=0,sp2y=0,spx=0,spy=0;
	var par=100;
	var channel = 1;
	var flapX = 0;
	var flapY = 0;
	var mode = "clamp";
	var offset = new Point(dx, dy);
	var startpt=new Point(0,0);
	var baseX = px*t.width;
	var baseY = py*t.height;
	var octs = 1;
	var seed = Math.floor(Math.random() * 50);
	var stitch = true;
	var fractal = true;
	var gray = false;
	var perlin = new BitmapData(1.5*t.width, 1.5*t.height);
	perlin.perlinNoise(baseX, baseY, octs, seed, stitch, fractal, channel, gray, [offset]);
	var dF = new DisplacementMapFilter(perlin, startpt, channel, channel, flapX, flapY, mode);
	var bF=new BlurFilter(2,2,3);
	newt=TransitionUtils.createTiles(t)[0];
	newt2=TransitionUtils.createTiles(t2)[0];
	newt.alpha=1.0;
	newt2.alpha=0.0;
	holder.addChild(newt);
	holder.addChild(newt2);
	addChild(holder);
	var ho={tt:0.0};
	TweenMax.to(ho, duration, {useFrames:useFrames, immediateRender:startNow, tt:1.0, ease:eas, onUpdate:wave, onUpdateParams:[ho], onComplete:doall});
	
	function wave(gt : Object)
	{
		var tt=gt.tt;
		newt.alpha=1.0-tt;
		newt2.alpha=tt;
		if (tt<0.5)
		{
			sp2x=maxbx*2*tt;
			sp2y=maxby*2*tt;
			spx=maxx*2*tt;
			spy=maxy*2*tt;
		}
		else
		{
			sp2x=maxbx*2*(1-tt);
			sp2y=maxby*2*(1-tt);
			spx=maxx*2*(1-tt);
			spy=maxy*2*(1-tt);
		}
		
		offset.x-=speedx;
		offset.y-=speedy;
		bF.blurX=sp2x;
		bF.blurY=sp2y;
		dF.scaleX=spx;
		dF.scaleY=spy;
		perlin.perlinNoise(baseX, baseY, octs, seed, stitch, fractal, channel, gray, [offset]);
		holder.filters=[bF, dF];
	}
	}
	
	override public function kill():void
	{
		if (holder==null) return;
		var tweens:Array=TweenMax.getTweensOf(ho);
		for (var j=0;j<tweens.length;j++)
		{
			tweens[j].complete(false);//.setEnabled(false, false); // kill tweens
		}
		//doall();
	}
	
	private function doall()
	{
		//wave(gt);
		holder.filters=[];
		this.removeChild(holder);
		newt.bitmapData.dispose();
		holder=null;
		if (persist)
			this.addChild(newt2);
		else
		 newt2.bitmapData.dispose();
		if (dispatch)
		{
			this.dispatchEvent(new Event(eventType));
		}
	}
	
}
}