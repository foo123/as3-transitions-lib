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

public class Pixelate extends Transition
{
	public static var useFrames:Boolean=true;
	public static var persist:Boolean=true;
	public static var dispatch:Boolean=true;
	public static var startNow:Boolean=true;
	
	private var holder:Sprite=null,prevbmpd:BitmapData,bmpd:BitmapData,pix1:Object,pix2:Object,tar:DisplayObject;
	
	public function Pixelate()
	{
		super();
	}
	
	override public function doit(params:Object):void
	{
	
	var t:DisplayObject, t2:DisplayObject, duration:Number, eas:Function;
	t=params.fromTarget;
	t2=params.toTarget;
	duration=params.duration;
	eas=params.easing;
	tar=t2;
	
	var maxx:Number=100, maxy:Number=100;
	var geometric:Boolean=true;
	
	if (Transition.useGlobal)
	{
		useFrames=Transition.useFramesGlobal;
		persist=Transition.persistGlobal;
		dispatch=Transition.dispatchGlobal;
		startNow=Transition.startNowGlobal;
	}
	
	if (params!=null)
	{
		maxx=((params.maxx!=null)?params.maxx:maxx);
		maxy=((params.maxy!=null)?params.maxy:maxy);
		geometric=((params.geometric!=null)?params.geometric:geometric);
	}
	
	if (maxx < 0) maxx=-maxx;
	if (maxy < 0) maxy=-maxy;
	if (maxx<1)  maxx=1;
	if (maxy<1)  maxy=1;
	holder=new Sprite();
	var bmp:Bitmap=new Bitmap();
	prevbmpd=null;
	//holder.x=t.x;
	//holder.y=t.y;
	holder.addChild(bmp);
	this.addChild(holder);
	var mod1x:Number=Math.pow(maxx/1,1/(duration/2));
	var mod1y:Number=Math.pow(maxy/1,1/(duration/2));
	var mod2x:Number=Math.pow(1/maxx,1/(duration/2));
	var mod2y:Number=Math.pow(1/maxy,1/(duration/2));
	pix1={a:0.0, modx:mod1x, mody:mod1y, pixxi:1, pixyi:1, pixxf:maxx, pixyf:maxy, sourc:t};
	pix2={a:0.0, modx:mod2x, mody:mod2y, pixxi:maxx, pixyi:maxy, pixxf:1, pixyf:1, sourc:t2};
	TweenMax.to(pix1, duration, {delay:0, useFrames:useFrames, immediateRender:startNow, a:1.0, ease:eas, onInit:render, onInitParams:[pix1], onUpdate:render, onUpdateParams:[pix1], onComplete:doall});
	
	function render(tobj:Object):void
	{
		var sx:Number;
		var sy:Number;
		var aa=tobj.a;
		var aaa:Number=0;
		var obj:Object=null;
		if (aa<0.5)
		{
			obj=pix1;
			aaa=2*aa;
		}
		else
		{
			obj=pix2;
			aaa=2*(aa-0.5);
		}
		if (geometric)
		{
			sx=obj.pixxi*Math.pow(obj.modx,aaa*duration/2);
			sy=obj.pixyi*Math.pow(obj.mody,aaa*duration/2);
		}
		else
		{
			sx=(obj.pixxf-obj.pixxi)*aaa+obj.pixxi;
			sy=(obj.pixyf-obj.pixyi)*aaa+obj.pixyi;
		}
		prevbmpd=bmpd;
		bmpd = new BitmapData(obj.sourc.width/sx, obj.sourc.height/sy, true, 0);
		var _scaleMatrix = new Matrix();
		_scaleMatrix.scale(1/sx, 1/sy);
		bmpd.draw(obj.sourc, _scaleMatrix);
		bmp.bitmapData = bmpd;
		bmp.width = obj.sourc.width;
		bmp.height = obj.sourc.height;
		if (prevbmpd!=null)
			prevbmpd.dispose();
	}
	}
	
	override public function kill():void
	{
		if (holder==null) return;
		var tweens:Array=TweenMax.getTweensOf(pix1);
		for (var j=0;j<tweens.length;j++)
		{
			tweens[j].complete(false); //.setEnabled(false, false); // kill tweens
		}
		//doall();
	}
	
	private function doall()
	{
		this.removeChild(holder);
		prevbmpd.dispose();
		bmpd.dispose();
		holder=null;
		if (persist)
		{
			var newt2=TransitionUtils.createTiles(tar)[0];
			this.addChild(newt2);
		}
		if (dispatch)
		{
			this.dispatchEvent(new Event(eventType));
		}
	}
	
}
}