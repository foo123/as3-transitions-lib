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

public class Blinds extends Transition
{
	public static var useFrames:Boolean=true;
	public static var persist:Boolean=true;
	public static var dispatch:Boolean=true;
	public static var startNow:Boolean=true;
	
	private var holder:Sprite=null,pieces:Array,masks:Array,count:int,size:int,newt0:Bitmap,tar:DisplayObject;
	
	public function Blinds()
	{
		super();
	}
	
	override public function doit(params:Object):void
	{
		var rows:int=1;
		var columns:int=1;
		var overlap:Number=0.8;
		var ord:String="left-right";
		
		var t1:DisplayObject, t0:DisplayObject, duration:Number, eas:Function;
		t0=params.fromTarget;
		t1=params.toTarget;
		duration=params.duration;
		eas=params.easing;
		tar=t1;
		
	if (Transition.useGlobal)
	{
		useFrames=Transition.useFramesGlobal;
		persist=Transition.persistGlobal;
		dispatch=Transition.dispatchGlobal;
		startNow=Transition.startNowGlobal;
	}
	
		var mode:String="left";
		
		if (params!=null)
		{
			rows=((params.rows!=null)?params.rows:rows);
			columns=((params.columns!=null)?params.columns:columns);
			overlap=((params.overlap!=null)?params.overlap:overlap);
			ord=((params.ordering!=null)?params.ordering:ord);
			mode=((params.mode!=null)?params.mode:mode);
		}
		if (rows<=0) rows=1;
		if (columns<=0) columns=1;
		
		// split image
		pieces=TransitionUtils.createTiles(t1,rows,columns);
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
		masks=[];
		for (var j=0; j<pieces.length ; j++)
		{
			
			masks[j]=new Sprite();
			var msk=new Shape();
			masks[j].addChild(msk);
			msk.graphics.beginFill(0);
			msk.graphics.drawRect(0,0,pieces[j].width,pieces[j].height);
			msk.graphics.endFill();
			
			switch(mode)
			{
				case "right": 	
								msk.x=-pieces[j].width;
								msk.y=0;
								masks[j].x=pieces[j].x+pieces[j].width;
								masks[j].y=pieces[j].y;
								masks[j].scaleX=0;
								break;
				case "top": 	
								msk.x=0;
								msk.y=0;
								masks[j].x=pieces[j].x;
								masks[j].y=pieces[j].y;
								masks[j].scaleY=0;
								break;
				case "bottom": 	
								msk.x=0;
								msk.y=-pieces[j].height;
								masks[j].x=pieces[j].x;
								masks[j].y=pieces[j].y+pieces[j].height;
								masks[j].scaleY=0;
								break;
				case "top-left": 	
								msk.x=0;
								msk.y=0;
								masks[j].x=pieces[j].x;
								masks[j].y=pieces[j].y;
								masks[j].scaleX=0;
								masks[j].scaleY=0;
								break;
				case "bottom-right": 	
								msk.x=-pieces[j].width;
								msk.y=-pieces[j].height;
								masks[j].x=pieces[j].x+pieces[j].width;
								masks[j].y=pieces[j].y+pieces[j].height;
								masks[j].scaleX=0;
								masks[j].scaleY=0;
								break;
				case "bottom-left": 	
								msk.x=0;
								msk.y=-pieces[j].height;
								masks[j].x=pieces[j].x;
								masks[j].y=pieces[j].y+pieces[j].height;
								masks[j].scaleX=0;
								masks[j].scaleY=0;
								break;
				case "top-right": 	
								msk.x=-pieces[j].width;
								msk.y=0;
								masks[j].x=pieces[j].x+pieces[j].width;
								masks[j].y=pieces[j].y;
								masks[j].scaleX=0;
								masks[j].scaleY=0;
								break;
				case "center": 	
								msk.x=-pieces[j].width/2;
								msk.y=-pieces[j].height/2;
								masks[j].x=pieces[j].x+pieces[j].width/2;
								masks[j].y=pieces[j].y+pieces[j].height/2;
								masks[j].scaleX=0;
								masks[j].scaleY=0;
								break;
				case "left":
				default:				
								msk.x=0;
								msk.y=0;
								masks[j].x=pieces[j].x;
								masks[j].y=pieces[j].y;
								masks[j].scaleX=0;
								break;
			}
			pieces[j].mask=masks[j];
			holder.addChild(pieces[j]);
			holder.addChild(masks[j]);
			TweenMax.to(masks[j], d, {delay:ordobj.delays[j]*(d-o), immediateRender:startNow, useFrames:useFrames, scaleX:1.0, scaleY:1.0, ease:eas, onComplete:doall});
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
			for (var i=0;i<pieces.length;i++)
			{
				holder.removeChild(pieces[i]);
				holder.removeChild(masks[i]);
				pieces[i].bitmapData.dispose();
				pieces[i]=null;
				masks[i].removeChildAt(0);
				masks[i]=null;
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