package com.nikos.mytransitions
{
import flash.display.*;
import flash.geom.*;
import flash.events.*;
import fl.transitions.*;
import fl.transitions.easing.*;
import fl.motion.easing.*;
import flash.filters.*;
import flash.utils.*;

// TweenMax
import com.greensock.*;

import com.nikos.utils.TransitionUtils;

public class Clock extends Transition
{
	public static var useFrames:Boolean=true;
	public static var persist:Boolean=true;
	public static var dispatch:Boolean=true;
	public static var startNow:Boolean=true;
	
	private var holder:Sprite=null,tobj:Object,maska:Shape,newt:Bitmap,newt0:Bitmap;
	
	public function Clock()
	{
		super();
	}
	
	override public function doit(params:Object):void
	{
	var groups:uint=1;
	var start_angle:Number=0;
	var cw:Boolean=false;
	
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
		groups=((params.segments!=null)?params.segments:groups);
		start_angle=((params.start_angle!=null)?params.start_angle:start_angle);
		cw=((params.clockwise!=null)?params.clockwise:cw);
	}
	
	var mult:int=1;
	if (cw) mult=-1;
	var i:int=0;
	//var masks=new Array(groups), maskees=new Array(groups);
	var pp=new Array(groups);
	holder=new Sprite();
	var radius=0.5*Math.sqrt(t1.width*t1.width+t1.height*t1.height);
	var cx=t1.width/2,cy=t1.height/2;
	//holder.x=t.x;
	//holder.y=t.y;
	
	/*for (i=0;i<groups;i++)
	{
		masks[i]=new Shape();
		var temp=utils.segment(t,t.width,t.height);
		maskees[i]=temp[0][0];
		maskees[i].mask=masks[i];
		holder.addChild(maskees[i]);
		holder.addChild(masks[i]);
	}*/
	maska=new Shape();
	//t.x=0;
	//t.y=0;
	newt=TransitionUtils.createTiles(t1)[0];
	newt0=TransitionUtils.createTiles(t0)[0];
	newt.mask=maska;
	holder.addChild(newt0);
	holder.addChild(newt);
	holder.addChild(maska);
	this.addChild(holder);
	var tobj={tt:0.0};
	TweenMax.to(tobj, duration, {delay:0, useFrames:useFrames, immediateRender:startNow, tt:1.0, ease:eas, onInit:render, onInitParams:[tobj], onUpdate:render, onUpdateParams:[tobj], onComplete:doall});
	
	function render(g:Object)
	{
		var tt=g.tt;
		maska.graphics.clear();
		for (i=0;i<groups;i++)
		{
			/*masks[i].graphics.beginFill(0xFFFFFF); //white
			masks[i].graphics.lineStyle(0, 0xFFFFFF);
			masks[i].graphics.moveTo(cx, cy);
			masks[i].graphics.lineTo(cx+radius*Math.cos(-Math.PI*(start_angle+i*360/groups)/180), cy+radius*Math.sin(-Math.PI*(start_angle+i*360/groups)/180));
			pp[i]=drawarc(masks[i],new Point(cx, cy),radius,tt*360/groups,start_angle+i*360/groups);
			if (tt==1 && i<groups-1)
				masks[i].graphics.lineTo(cx+radius*Math.cos(-Math.PI*(start_angle+(i+1)*360/groups)/180), cy+radius*Math.sin(-Math.PI*(start_angle+(i+1)*360/groups)/180));		
			else if (tt==1)
				masks[i].graphics.lineTo(cx+radius*Math.cos(-Math.PI*(start_angle)/180), cy+radius*Math.sin(-Math.PI*(start_angle)/180));		
			masks[i].graphics.lineTo(cx, cy);		
			masks[i].graphics.endFill();*/
			maska.graphics.beginFill(0xFFFFFF); //white
			maska.graphics.lineStyle(0, 0xFFFFFF);
			maska.graphics.moveTo(cx, cy);
			maska.graphics.lineTo(cx+radius*Math.cos(-Math.PI*(start_angle+mult*i*360/groups)/180), cy+radius*Math.sin(-Math.PI*(start_angle+mult*i*360/groups)/180));
			pp[i]=drawarc(maska,new Point(cx, cy),radius,mult*tt*360/groups,start_angle+mult*i*360/groups);
			if (tt==1 && i<groups-1)
				maska.graphics.lineTo(cx+radius*Math.cos(-Math.PI*(start_angle+mult*(i+1)*360/groups)/180), cy+radius*Math.sin(-Math.PI*(start_angle+mult*(i+1)*360/groups)/180));		
			else if (tt==1)
				maska.graphics.lineTo(cx+radius*Math.cos(-Math.PI*(start_angle)/180), cy+radius*Math.sin(-Math.PI*(start_angle)/180));		
			maska.graphics.lineTo(cx, cy);		
			maska.graphics.endFill();
		}
	}
	
	function drawarc(who:Shape,center:Point,radius:Number,angle:Number,start_angle:Number=0,numpoints:uint=100):Point
	{
		var nextp=new Array();
		var aa=Math.PI*angle/180;
		var sa=Math.PI*start_angle/180;
		for (var i=0;i<numpoints;i++)
		{
			nextp[i]=new Point(center.x+radius*Math.cos(-sa-i*aa/numpoints),center.y+radius*Math.sin(-sa-i*aa/numpoints))
			if (i==0)
				who.graphics.moveTo(nextp[i].x,nextp[i].y);
			else
				who.graphics.lineTo(nextp[i].x,nextp[i].y);
	
		}
		if (angle==360)
		{
			who.graphics.lineTo(nextp[0].x,nextp[0].y);
			return(nextp[0]);
		}
		return(nextp[numpoints-1]);
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
	
	private function doall()
	{
		this.removeChild(holder);
		maska=null;
		newt0.bitmapData.dispose();
		newt0=null;
		holder=null;
		if (persist)
		{
			//t.x=holder.x;
			//t.y=holder.y;
			newt.mask=null;
			this.addChild(newt);
		}
		else
			newt.bitmapData.dispose();
		if (dispatch)
		{
			this.dispatchEvent(new Event(eventType));
		}
	}
}
}