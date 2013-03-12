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

public class GradientSweep extends Transition
{
	public static var useFrames:Boolean=true;
	public static var persist:Boolean=true;
	public static var dispatch:Boolean=true;
	public static var startNow:Boolean=true;
	
	private var holder:Sprite=null,masker:Sprite,tt:Object,newt0:Bitmap,newt1:Bitmap;
	
	public function GradientSweep()
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
		
		
		var type:String="top-left";
	
	if (Transition.useGlobal)
	{
		useFrames=Transition.useFramesGlobal;
		persist=Transition.persistGlobal;
		dispatch=Transition.dispatchGlobal;
		startNow=Transition.startNowGlobal;
	}
	
		if (params!=null)
		{
			type=((params.mode!=null)?params.mode:type);
		}
		
		var angle:Number=0,xx=0,yy=0,sx=0,sy=0;
		var px:Number=1,py:Number=1;
		masker = new Sprite();
		var mat=new Matrix();
		newt1=TransitionUtils.createTiles(t1)[0];
		newt0=TransitionUtils.createTiles(t0)[0];
		newt1.cacheAsBitmap=true;
		holder=new Sprite();
		holder.addChild(newt0);
		newt1.mask=masker;
		masker.cacheAsBitmap=true;
		holder.addChild(newt1);
		holder.addChild(masker);
		this.addChild(holder);
		
		if (type!="radial")
		{
		switch(type)
		{
			case "left": // left to right
					angle=Math.PI;
					xx=0;
					yy=0;
					px=2;
					sx=-px*t1.width;
					break;
			case "top": // top to bottom
					angle=-Math.PI/2;
					xx=0;
					yy=0;
					py=2;
					sy=-py*t1.height;
					break;
			case "bottom": // bottom to top
					angle=Math.PI/2;
					xx=0;
					py=2;
					yy=-t1.height;
					sy=t1.height;
					break;
			case "right": // right to left
					angle=0;
					yy=0;
					px=2;
					xx=-t1.width;
					sx=t1.width;
					break;
			case "bottom-left":	// bottom left to top right
					angle=Math.atan(t1.width/t1.height)+Math.PI/2;
					xx=0;
					px=2;
					py=2
					yy=-t1.height;
					sx=-px*t1.width;
					sy=t1.height;
					break;
			case "top-right":	// top right to bottom left
					angle=-Math.atan(t1.height/t1.width);
					yy=0;
					px=2;
					py=2;
					xx=-t1.width;
					sx=t1.width;
					sy=-py*t1.height;
					break;
			case "bottom-right":	// bottom right to top left
					angle=Math.atan(t1.width/t1.height);
					px=2;
					py=2;
					xx=-t1.width;
					yy=-t1.height;
					sx=t1.width;
					sy=t1.height;
					break;
			default: // top left to bottom right
					angle=-Math.atan(t1.height/t1.width)-Math.PI/2;
					xx=0;
					yy=0;
					px=2;
					py=2;
					sx=-px*t1.width;
					sy=-py*t1.height;
					break;
		}
		mat.createGradientBox(px*t1.width,py*t1.height,angle);
		masker.graphics.clear();
		masker.graphics.beginGradientFill("linear",[0,0,0],[0,1,1],[0,127,255],mat);
		masker.graphics.drawRect(0,0,px*t1.width,py*t1.height);
		masker.graphics.endFill();
		masker.cacheAsBitmap=true;
		masker.x = sx;
		masker.y = sy;
		TweenMax.to(masker, duration, {useFrames:useFrames, immediateRender:startNow, x:xx,y:yy, ease:eas, onComplete:doall});
		}
		else
		{
		masker.x = t1.width/2;
		masker.y = t1.height/2;
		tt={t:0.0};
		var tw=t1.width;
		var th=t1.height;
		var radius=0.5*Math.sqrt(tw*tw+th*th);
		var p=0.4;
		var k=p*radius;
		TweenMax.to(tt, duration, {useFrames:useFrames, t:1.0+p, ease:eas, onUpdate:render, onComplete:doall});
		}
		
		function render():void
		{
			if (tt.t>0)
			{
			mat.createGradientBox(2*tt.t*radius,2*tt.t*radius,0,-tt.t*radius,-tt.t*radius);	
			masker.graphics.clear();
			masker.graphics.beginGradientFill("radial",[0, 0],[1, 0],[100+155*(tt.t*(radius-k))/(tt.t*radius), 255],mat);
			masker.graphics.drawCircle(0,0,tt.t*radius);
			masker.graphics.endFill();
			}
		}
		
	}
	
	override public function kill():void
	{
		if (holder==null) return;
		var tweens:Array=TweenMax.getTweensOf(masker);
		for (var j=0;j<tweens.length;j++)
		{
			tweens[j].setEnabled(false, false); // kill tweens
		}
		tweens=TweenMax.getTweensOf(tt);
		for (j=0;j<tweens.length;j++)
		{
			tweens[j].complete(false);//.setEnabled(false, false); // kill tweens
		}
		//doall();
	}
	
	private function doall() : void
	{
		holder.removeChild(masker);
		holder.removeChild(newt0);
		holder.removeChild(newt1);
		this.removeChild(holder);
		masker=null;
		newt1.mask=null;
		newt0.bitmapData.dispose();
		holder=null;
		if (persist)
		{
			this.addChild(newt1);
			//t1.x=holder.x;
			//t1.y=holder.y;
		}
		else newt1.bitmapData.dispose();
		if (dispatch)
		{
			this.dispatchEvent(new Event(eventType));
		}
	}
}
}