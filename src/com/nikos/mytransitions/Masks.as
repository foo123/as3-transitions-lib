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

public class Masks extends Transition
{
	public static var useFrames:Boolean=true;
	public static var persist:Boolean=true;
	public static var dispatch:Boolean=true;
	public static var startNow:Boolean=true;
	
	private var holder:Sprite=null,masker:Sprite,xup:Shape,xlo:Shape,uppermask:Sprite,lowermask:Sprite,cmasker:Sprite,cmasks:Array,tobj:Object,newt0:Bitmap,newt1:Bitmap;
	
	[Embed(source="assets/masks_assets.swf", symbol="upper")]
	private var upperClass:Class;
	[Embed(source="assets/masks_assets.swf", symbol="lower")]
	private var lowerClass:Class;
	
	public function Masks()
	{
		super();
	}
	
	override public function doit(params:Object):void
	{
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
	
	
	var i:int,j:int;
	holder=new Sprite();
	newt0=TransitionUtils.createTiles(t0)[0];
	newt1=TransitionUtils.createTiles(t1)[0];
	holder.addChild(newt0);
	masker=new Sprite();
	uppermask=new upperClass() as Sprite;
	lowermask=new lowerClass() as Sprite;
	//cmasker=[];
	//cmasks=[];
	addChild(holder);
	newt1.mask=masker;
	holder.addChild(newt1);
	holder.addChild(masker);
	// 795, 315
	uppermask.scaleX=newt1.width/uppermask.width;
	uppermask.scaleY=uppermask.scaleX;
	// 795, 230
	lowermask.scaleX=uppermask.scaleX;
	lowermask.scaleY=lowermask.scaleX;
	//lowermask.height=0.73*newt1.height;
	xup=new Shape();
	xup.graphics.beginFill(0);
	xup.graphics.drawRect(0,0,newt1.width,newt1.height);
	xup.graphics.endFill();
	xlo=new Shape();
	xlo.graphics.beginFill(0);
	xlo.graphics.drawRect(0,0,newt1.width,newt1.height);
	xlo.graphics.endFill();
	//uppermask.addChild(xup);
	masker.addChild(xup);
	masker.addChild(xlo);
	//xup.y=-xup.height;
	//lowermask.addChild(xlo);
	xlo.y=masker.height;
	
	masker.addChild(uppermask);
	masker.addChild(lowermask);
	uppermask.y=-uppermask.height;
	lowermask.y=newt1.height;
	/*
	var ww=newt1.width*126/450;
	var hh=newt1.height;
	var dd=ww*12/126;
	var rr=dd*22/12;
	var ddd=dd*10/12;
	var ss=1/14;
	var steps=Math.round((newt1.width+ww)/rr);
	var step=0;
	*/
	tobj={t:0};
	// animate them		
	TweenMax.to(tobj, duration, {delay:0, useFrames:useFrames, immediateRender:startNow, t:1, ease:eas, onUpdate:render, onComplete:doall});
	
	/*function makemasks():void
	{
		cmasker[step]=new Sprite();
		cmasks[step]=[];
		for (var i=0;i<24;i++)
		{
			cmasks[step][i]={ms:new Shape(), del:0};
			cmasks[step][i].ms.graphics.beginFill(0);
			cmasks[step][i].ms.graphics.drawCircle(rr/2,rr/2,rr);
			cmasks[step][i].ms.graphics.endFill();
			if (i<12 && i>0)
			{
				cmasks[step][i].ms.x=cmasks[step][i-1].ms.x+dd;
				cmasks[step][i].ms.y=cmasks[step][i-1].ms.y-dd;
				if (i%3==0)
				{
					cmasks[step][i].ms.x=cmasks[i-1].ms.x-ddd-dd;
					cmasks[step][i].ms.y=cmasks[i-1].ms.y-ddd+dd;
				}
				cmasks[step][i].del=i*ss;
			}
			else if (i>0)
			{
				cmasks[step][i].ms.x=cmasks[step][11-(i-12)].ms.x;
				cmasks[step][i].ms.y=cmasks[step][11-(i-12)].ms.y-i*;
			}
			else
			{
				cmasks[step][0].ms.x=0;
				cmasks[step][0].ms.y=hh;
				cmasks[step][0].del=0;
			}
			if (i>12)
			{
			 cmasks[step][i].del=cmasks[step][11-(i-12)].del;
			}
			cmasker[step].addChild(cmasks[step][i].ms);
		}
	}*/
	function render():void
	{
		var tt=tobj.t;
		
		uppermask.y=-uppermask.height+tt*(uppermask.height+(.5*newt1.height-uppermask.height+uppermask.height*.25));
		lowermask.y=newt1.height-tt*(.5*(newt1.height+lowermask.height));
		xup.y=uppermask.y-xup.height;
		xlo.y=lowermask.y+lowermask.height;
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
		/*for (var i=0;i<cmasks.length;i++)
		{
		 cmasker.removeChild(cmasks[i].ms);
		 cmasks[i].ms=null;
		 cmasks[i]=null;
		}
		cmasker=nulll;*/
		holder.removeChild(newt0);
		holder.removeChild(newt1);
		holder.removeChild(masker);
		masker.removeChild(uppermask);
		masker.removeChild(lowermask);
		masker.removeChild(xup);
		masker.removeChild(xlo);
		xup=null;
		xlo=null;
		this.removeChild(holder);
		newt0.bitmapData.dispose();
		newt0=null;
		holder=null;
		newt1.mask=null;
		uppermask=null;
		lowermask=null;
		masker=null;
		if (persist)
			this.addChild(newt1);
		else newt1.bitmapData.dispose();
		if (dispatch)
		{
			this.dispatchEvent(new Event(eventType));
		}
	}
}
}