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

import be.nascom.flash.graphics.Rippler;  // modified rippler class

public class Ripples extends Transition
{
	public static var useFrames:Boolean=true;
	public static var persist:Boolean=true;
	public static var dispatch:Boolean=true;
	public static var startNow:Boolean=true;
	
	private var holder:Sprite=null,holder2:Sprite,ms:Shape,tobj:Object,rip:Rippler,newt:Bitmap,newt2:Bitmap;
	
	public function Ripples()
	{
		super();
	}
	
	override public function doit(params:Object):void
	{
	var maxs:Number=60;
	var dens:int=2;
	
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
		maxs=((params.maxs!=null)?params.maxs:maxs);
		dens=((params.dens!=null)?params.dens:dens);
	}
	if (dens>10) dens=10;
	if (dens<0) dens=0;
	
	holder=new Sprite();
	holder2=new Sprite();
	ms=new Shape();
	var bF=new BlurFilter(2,2,3);
	//var rip:Rippler;
	var pp1=6,pp2=20,palpha=1;
	var tw=t.width;
	var th=t.height;
	ms.graphics.beginFill(0xFFFFFF); //white
    ms.graphics.lineStyle(0, 0xFFFFFF);
    ms.graphics.drawRect(0, 0, tw, th);
	ms.graphics.endFill();
	//ms.x=t.x;
	//ms.y=t.y;
	//holder.x=t.x;
	//holder.y=t.y;
	//t.x=0;
	//t.y=0;
	//t2.x=0;
	//t2.y=0;
	newt=TransitionUtils.createTiles(t)[0];
	newt2=TransitionUtils.createTiles(t2)[0];
	newt.alpha=1.0;
	holder2.addChild(newt);
	newt2.alpha=0.0;
	holder2.addChild(newt2);
	holder.addChild(holder2);
	this.addChild(ms);
	holder.mask=ms; // add mask
	this.addChild(holder);
	
	var tobj:Object={t:-1, tprev:-2};
	TweenMax.to(tobj, duration, {onInit:doinit, onComplete:doall, onUpdate:doripple, onUpdateParams:[tobj], immediateRender:startNow, useFrames:useFrames, t:-1, bezierThrough:[{t:0}], ease:eas});
	
	function doinit():void
	{
		rip=new Rippler(holder,maxs,pp1);
	}
	
	function doripple(gt : Object):void
	{
		var bb=10;
		var tt=gt.t;
		var rc=6;
		var p=0.1;
		
		//rip.pp=new Point(-10,-10);
		if (gt.tprev<tt)
		{
			if ((Math.round(Math.random()*10)<=dens) || tt<-0.9)
			{
				rip.drawRipple(0.5*tw+2*(Math.random()-0.5)*tw/2,0.5*th+2*(Math.random()-0.5)*th/2,pp2,palpha);
			}
			newt.alpha=1-Math.exp(rc*tt)*p;
			newt2.alpha=(1-newt.alpha);
		}
		else
		{
			newt.alpha=Math.exp(rc*tt)*(1-p);
			newt2.alpha=1-newt.alpha;
			rip.strengthdmF=maxs*(tt+1);
		}
		gt.tprev=tt;
		bF.blurX=(tt+1)*bb;
		bF.blurY=(tt+1)*bb;
		holder2.filters=[bF];
	}
	}
	
	override public function kill():void
	{
		if (holder==null) return;
		var tweens:Array=TweenMax.getTweensOf(tobj);
		for (var j=0;j<tweens.length;j++)
		{
			tweens[j].complete(false);//.setEnabled(false, false); // kill tweens
		}
		//doall();
	}
	
	private function doall():void
	{
		rip.destroy();
		this.removeChild(holder);
		newt.bitmapData.dispose();
		newt=null;
		holder=null;
		if (persist)
		{
			//t2.x=holder.x;
			//t2.y=holder.y;
			this.addChild(newt2);
		}
		else
		{
		 newt2.bitmapData.dispose();
		 newt2=null;
		}
		if (dispatch)
		{
			this.dispatchEvent(new Event(eventType));
		}
	}

}
}