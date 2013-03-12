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

public class FadeTiles extends Transition
{
	public static var useFrames:Boolean=true;
	public static var persist:Boolean=true;
	public static var dispatch:Boolean=true;
	public static var startNow:Boolean=true;
	
	private var holder:Sprite=null,pieces:Array,count:int=0,size:int,newt0:Bitmap,tar:DisplayObject;
	
	public function FadeTiles()
	{
		super();
	}
	
	override public function doit(params:Object):void
	{
		var rows:int=1;
		var columns:int=1;
		var overlap:Number=0.8;
		var ord:String="left-right";
		
		var target:DisplayObject, t0:DisplayObject, duration:Number, eas:Function;
		t0=params.fromTarget;
		target=params.toTarget;
		duration=params.duration;
		eas=params.easing;
		tar=target;
		
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
			overlap=((params.overlap!=null)?params.overlap:overlap);
			ord=((params.ordering!=null)?params.ordering:ord);
		}
		if (rows<=0) rows=1;
		if (columns<=0) columns=1;
		
		// split image
		pieces=TransitionUtils.createTiles(target,rows,columns);
		var ordobj=TransitionUtils.ordering[ord](pieces,rows,columns);
		pieces=ordobj.pieces;
		
		var groups=ordobj.groups;
		if (overlap>1.0)	overlap=1.0;
		if (overlap<0.0)	overlap=0.0;
		var d:Number=duration/(groups-(groups-1)*overlap);
		var o:Number=d*overlap;
		newt0=TransitionUtils.createTiles(t0)[0];
		holder=new Sprite();
		holder.addChild(newt0);
		//holder.x=target.x;
		//holder.y=target.y;
		this.addChild(holder);
		// animate them
		var rr=0;
		var cc=0;
		size=pieces.length;
		count=0;
		for (var j=0; j<pieces.length ; j++)
		{
			pieces[j].alpha=0.0;
			TweenMax.to(pieces[j], d, {delay:ordobj.delays[j]*(d-o), useFrames:useFrames, immediateRender:startNow, alpha:1.0, ease:eas, onInit:doinit, onInitParams:[pieces[j]], onComplete:doall});			
		}
		function doinit(gt:DisplayObject):void
		{
			holder.addChild(gt as DisplayObject);
		}
	}
	
	override public function kill():void
	{
		if (holder==null) return;
		for (var i=0;i<size;i++)
		{
			var tweens:Array=TweenMax.getTweensOf(pieces[i]);
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
				pieces[i].bitmapData.dispose();
			}
			newt0.bitmapData.dispose();
			newt0=null;
			this.removeChild(holder);
			holder=null;			
			if (persist)
			{
				var newtarget=TransitionUtils.createTiles(tar)[0];
				this.addChild(newtarget);
			}
			if (dispatch)
			{
				this.dispatchEvent(new Event(eventType));
			}
		}
	}
}
}