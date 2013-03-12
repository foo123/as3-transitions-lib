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

public class ScaleTiles extends Transition
{
	public static var useFrames:Boolean=true;
	public static var persist:Boolean=true;
	public static var dispatch:Boolean=true;
	public static var startNow:Boolean=true;
	
	private var holder:Sprite=null,holders:Array,pieces:Array,count:int=0,size:int,newt0:Bitmap,newt1:Bitmap;
	
	public function ScaleTiles()
	{
		super();
	}
	
	override public function doit(params:Object):void
	{
	var rows:int=1;
	var columns:int=1;
	var rotate:Boolean=true;
	var overlap:Number=0.5;
	var ord:String="random";
	var rev:Boolean=false;
	
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
		rows=((params.rows!=null)?params.rows:rows);
		columns=((params.columns!=null)?params.columns:columns);
		rotate=((params.rotate!=null)?params.rotate:rotate);
		rev=((params.reverse!=null)?params.reverse:rev);
		overlap=((params.overlap!=null)?params.overlap:overlap);
		ord=((params.ordering!=null)?params.ordering:ord);
	}
	count=0;
	var a;
	holder=new Sprite();
	newt0=TransitionUtils.createTiles(t0)[0];
	newt1=TransitionUtils.createTiles(t1)[0];
	if (rev)
	{
		pieces=TransitionUtils.createTiles(t0,rows,columns);
		holder.addChild(newt1);
		a=1.0;
	}
	else
	{
		pieces=TransitionUtils.createTiles(t1,rows,columns);
		holder.addChild(newt0);
		a=0.0;
	}
	var i:int,j:int;
	var ordobj=TransitionUtils.ordering[ord](pieces,rows,columns)
	pieces=ordobj.pieces;
	var groups=ordobj.groups;
	if (overlap>1.0)	overlap=1.0;
	if (overlap<0.0)	overlap=0.0;
	var d:Number=duration/(groups-(groups-1)*overlap);
	var o:Number=d*overlap;
	size=pieces.length;
	addChild(holder);
	holders=new Array(pieces.length);
	
	// animate them
	for (j=0; j<pieces.length ; j++)
	{		
		holders[j]=new Sprite();
		holders[j].addChild(pieces[j]);
		holders[j].x=pieces[j].x+pieces[j].width/2;
		holders[j].y=pieces[j].y+pieces[j].height/2;
		pieces[j].x=-pieces[j].width/2;
		pieces[j].y=-pieces[j].height/2;
		holders[j].scaleX=a;
		holders[j].scaleY=holders[j].scaleX;
		//if (rev)
			holder.addChild(holders[j]);
		if (!rotate)
		TweenMax.to(holders[j], d, {delay:ordobj.delays[j]*(d-o), useFrames:useFrames, immediateRender:startNow, scaleX:1.0-a,scaleY:1.0-a, ease:eas, onComplete:doall});
		else
		TweenMax.to(holders[j], d, {delay:ordobj.delays[j]*(d-o), useFrames:useFrames, immediateRender:startNow, rotation:720, scaleX:1.0-a,scaleY:1.0-a, ease:eas, onComplete:doall});
	}	
	}
	
	override public function kill():void
	{
		if (holder==null) return;
		for (var i=0;i<size;i++)
		{
			var tweens:Array=TweenMax.getTweensOf(holders[i]);
			for (var j=0;j<tweens.length;j++)
			{
				tweens[j].complete(false);//.setEnabled(false, false); // kill tweens
			}
		}
		//count=size;
		//doall();
	}
	
	private function doall():void
	{
		count++;
		if (count>=size)
		{
			for (var i=0;i<size;i++)
			{
				holder.removeChild(holders[i]);
				holders[i].removeChild(pieces[i]);
				pieces[i].bitmapData.dispose();
				holders[i]=null;
				pieces[i]=null;
			}
			holder.removeChildAt(0);
			this.removeChild(holder);
			newt0.bitmapData.dispose();
			holder=null;
			if (persist)
				this.addChild(newt1);
			else
			 newt1.bitmapData.dispose();
			 
			if (dispatch)
			{				
				this.dispatchEvent(new Event(eventType));
			}
		}
	}

}
}