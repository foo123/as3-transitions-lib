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

public class GradientMasks extends Transition
{
	public static var useFrames:Boolean=true;
	public static var persist:Boolean=true;
	public static var dispatch:Boolean=true;
	public static var startNow:Boolean=true;
	
	private var holder:Sprite=null,pieces:Array,count:int=0,size:int,masks:Array,newt0:Bitmap,newt1:Bitmap;
	
	public function GradientMasks()
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
	
	var rows:int;
	var columns:int;
	var nslices:int=3;
	var horizontal:String="horizontal";
	var alternate:Boolean=true;
	var overlap:Number=0.5;
	var ord:String="random";
	if (params!=null)
	{
		nslices=((params.slices!=null)?params.slices:nslices);
		//rows=((params.rows!=null)?params.rows:rows);
		//columns=((params.columns!=null)?params.columns:columns);
		horizontal=((params.mode!=null)?params.mode:horizontal);
		alternate=((params.alternate!=null)?params.alternate:alternate);
		overlap=((params.overlap!=null)?params.overlap:overlap);
		ord=((params.ordering!=null)?params.ordering:ord);
	}
	count=0;
	if (nslices<=0) nslices=1;
	if (horizontal=="horizontal")
	{
		rows=nslices;
		columns=1;
	}
	else
	{
		rows=1;
		columns=nslices;
	}
	pieces=TransitionUtils.createTiles(t1,rows,columns);
	var ordobj=TransitionUtils.ordering[ord](pieces,rows,columns);
	pieces=ordobj.pieces;
	
	var i:int,j:int;
	holder=new Sprite();
	newt0=TransitionUtils.createTiles(t0)[0];
	newt1=TransitionUtils.createTiles(t1)[0];
	holder.addChild(newt0);
	var groups=ordobj.groups;
	if (overlap>1.0)	overlap=1.0;
	if (overlap<0.0)	overlap=0.0;
	var d:Number=duration/(groups-(groups-1)*overlap);
	var o:Number=d*overlap;
	size=pieces.length;
	addChild(holder);
	
	// animate them
	masks = new Array(size);
	var even=true;
	for (j=0; j<pieces.length ; j++)
	{		
		var px=1,py=1;
		var xx=pieces[j].x;
		var yy=pieces[j].y;
		var type;
		var angle=0,sx=pieces[j].x,sy=pieces[j].y;
		if ((alternate && even) || !alternate)
		{
			if (horizontal=="horizontal")
				type="left";
			else
				type="top";
		}
		else
		{
			if (horizontal=="horizontal")
				type="right";
			else
				type="bottom";
		}
		switch(type)
		{
			case "left": // left to right
					angle=Math.PI;
					xx=pieces[j].x;
					yy=pieces[j].y;
					px=2;
					sx=pieces[j].x-px*pieces[j].width;
					break;
			case "top": // top to bottom
					angle=-Math.PI/2;
					xx=pieces[j].x;
					yy=pieces[j].y;
					py=2;
					sy=pieces[j].y-py*pieces[j].height;
					break;
			case "bottom": // bottom to top
					angle=Math.PI/2;
					xx=pieces[j].x;
					py=2;
					yy=pieces[j].y-pieces[j].height;
					sy=pieces[j].y+pieces[j].height;
					break;
			case "right": // right to left
					angle=0;
					yy=pieces[j].y;
					px=2;
					xx=pieces[j].x-pieces[j].width;
					sx=pieces[j].x+pieces[j].width;
					break;
		}
		masks[j]=new Sprite();
		var mat=new Matrix();
		mat.createGradientBox(px*pieces[j].width,py*pieces[j].height,angle);
		masks[j].graphics.clear();
		masks[j].graphics.beginGradientFill("linear",[0,0,0],[0,1,1],[0,127,255],mat);
		masks[j].graphics.drawRect(0,0,px*pieces[j].width,py*pieces[j].height);
		masks[j].graphics.endFill();
		masks[j].cacheAsBitmap=true;
		masks[j].x = sx;
		masks[j].y = sy;
		pieces[j].mask=masks[j];
		pieces[j].cacheAsBitmap=true;
		holder.addChild(pieces[j]);
		holder.addChild(masks[j]);
		
		TweenMax.to(masks[j], d, {delay:ordobj.delays[j]*(d-o), useFrames:useFrames, immediateRender:startNow, x:xx, y:yy, ease:eas, onComplete:doall});
		even=!even;
	}
	
	}
	
	override public function kill():void
	{
		if (holder==null) return;
		for (var i=0;i<size;i++)
		{
			var tweens:Array=TweenMax.getTweensOf(masks[i]);
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
				holder.removeChild(pieces[i]);
				holder.removeChild(masks[i]);
				pieces[i].bitmapData.dispose();
				masks[i]=null;
				pieces[i]=null;
			}
			holder.removeChild(newt0);
			this.removeChild(holder);
			newt0.bitmapData.dispose();
			newt0=null;
			holder=null;
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
}