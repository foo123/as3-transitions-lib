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

public class Slices extends Transition
{
	public static var useFrames:Boolean=true;
	public static var persist:Boolean=true;
	public static var dispatch:Boolean=true;
	public static var startNow:Boolean=true;
	
	private var holder:Sprite=null,masks:Array,maskees:Array,objs:Array;
	private var newt0:Bitmap,newt1:Bitmap;
	private var count:int=0,nummasks;
	private var type:String="in";
	
	public function Slices()
	{
		super();
	}
	
	override public function doit(params:Object):void
	{
	var overlap:Number=0.8;
	var up_down:Boolean=true;
	/*var type:String="in";*/
	var w:Number=10;
	var angle:Number=45;
	var ord:String="random";
	
	var t1:DisplayObject,t0:DisplayObject, duration:Number, eas:Function;
	t1=params.toTarget;
	t0=params.fromTarget;
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
		overlap=((params.overlap!=null)?params.overlap:overlap);
		up_down=((params.alternate!=null)?params.alternate:up_down);
		type=((params.type!=null)?params.type:type);
		w=((params.area!=null)?params.area:w);
		angle=((params.angle!=null)?params.angle:angle);
		ord=((params.ordering!=null)?params.ordering:ord);
	}
	
	if (angle <0) angle=-angle;
	while (angle>90) angle-=90;
	
	var aa=(angle/180)*Math.PI;
	var m1:Number=0,m2:Number=0;
	if (angle==90)
	{
		m1=1;
		m2=0;
	}
	else if (angle==0)
	{
		m1=0;
		m2=1;
	}
	else
	{
		m1=1;
		m2=1/Math.tan(aa);
	}
	var tw=t1.width;
	var th=t1.height;
	nummasks=Math.ceil(m1*tw/w+m2*th/w);
	masks=new Array(nummasks);
	//maskees=new Array(nummasks);
	objs=new Array(nummasks);
	holder=new Sprite();
	count=0;
	var i:int=0;
	var up_or_down:Boolean=true;
	
	newt0=TransitionUtils.createTiles(t0)[0];
	newt1=TransitionUtils.createTiles(t1)[0];
	var ttin,ttout;
	if (type=="in")
	{
		holder.addChild(newt0);
		ttin=newt0;
		ttout=newt1;
	}
	else
	{
		holder.addChild(newt1);
		type="out";
		ttin=newt1;
		ttout=newt0;
	}
	
	// create masks
	for (i=0;i<nummasks;i++)
	{
		masks[i]=new Shape();
		//masks[i].graphics.beginFill(0xFFFFFF); //white
		//masks[i].graphics.lineStyle(0, 0xFFFFFF);
		if (angle==0)
		{
			masks[i].graphics.beginBitmapFill(ttout.bitmapData,new Matrix(1,0,0,1,0,(i+1)*w),false,true);
			masks[i].graphics.moveTo(0, th);
			masks[i].graphics.lineTo(tw, th);
			masks[i].graphics.lineTo(tw, th+w);		
			masks[i].graphics.lineTo(0, th+w);
			masks[i].graphics.lineTo(0, th);
			masks[i].graphics.endFill();
			masks[i].x=0;
			masks[i].y=-(i+1)*w;
		}
		else
		{
			masks[i].graphics.beginBitmapFill(ttout.bitmapData,new Matrix(1,0,0,1,-i*w+m2*th,0),false,true);
			masks[i].graphics.moveTo(0, th);
			masks[i].graphics.lineTo(m2*th, 0);
			masks[i].graphics.lineTo(m2*th+w, 0);		
			masks[i].graphics.lineTo(w, th);
			masks[i].graphics.lineTo(0, th);
			masks[i].graphics.endFill();
			masks[i].x=i*w-m2*th;
			masks[i].y=0;
		}
		var temp;
		/*if (type=="out") 
		temp=TransitionUtils.createTiles(t0);
		else
		temp=TransitionUtils.createTiles(t1);
		maskees[i]=temp[0];
		maskees[i].mask=masks[i];*/
		objs[i]={ud:up_or_down, oo:new Sprite(), x:0, y:0};
		//objs[i].oo.addChild(maskees[i]);
		objs[i].oo.addChild(masks[i]);
		if (angle==0)
		{
			if ((up_down && up_or_down) || !up_down)
			{
				if (type=="out")
				{
					objs[i].y=0;
					objs[i].x=tw;
					objs[i].oo.x=0;
					objs[i].oo.y=0;
				}
				else
				{
					objs[i].oo.y=0;
					objs[i].oo.x=tw;
					objs[i].x=0;
					objs[i].y=0;
				}
			}
			else if (up_down)
			{
				if (type=="out")
				{
					objs[i].y=0;
					objs[i].x=-tw;
					objs[i].oo.x=0;
					objs[i].oo.y=0;
				}
				else
				{
					objs[i].oo.y=0;
					objs[i].oo.x=-tw;
					objs[i].x=0;
					objs[i].y=0;
				}
			}
		}
		else
		{
			if ((up_down && up_or_down) || !up_down)
			{
				if (type=="out")
				{
					objs[i].y=-th;
					objs[i].x=m2*th;
					objs[i].oo.x=0;
					objs[i].oo.y=0;
				}
				else
				{
					objs[i].oo.y=-th;
					objs[i].oo.x=m2*th;
					objs[i].x=0;
					objs[i].y=0;
				}
			}
			else if (up_down)
			{
				if (type=="out")
				{
					objs[i].y=parent.height;
					objs[i].x=-m2*parent.height;
					objs[i].oo.x=0;
					objs[i].oo.y=0;
				}
				else
				{
					objs[i].oo.y=th;
					objs[i].oo.x=-m2*th;
					objs[i].x=0;
					objs[i].y=0;
				}
			}
		}
		up_or_down=!up_or_down;
		if (type=="out")
			holder.addChild(objs[i].oo);
	}
	this.addChild(holder);
	
	var ordobj=TransitionUtils.ordering[ord](objs,1,nummasks);
	objs=ordobj.pieces;
	if (overlap>1.0)	overlap=1.0;
	if (overlap<0.0)	overlap=0.0;
	var groups=ordobj.groups;
	var d:Number=duration/(groups-(groups-1)*overlap);
	var o:Number=d*overlap;
	
	// animate masks
	for (i=0; i<nummasks ; i++)
	{
		TweenMax.to(objs[i].oo, d, {delay:ordobj.delays[i]*(d-o), useFrames:useFrames, immediateRender:startNow, x:objs[i].x, y:objs[i].y, ease:eas, onInit:doinit, onInitParams:[objs[i].oo], onComplete:doall, onCompleteParams:[objs[i].oo]});
	}
	
	function doinit(g:Object):void
	{
		//stage.addChild(g.target as DisplayObject);
		if (type=="in")
			holder.addChild(g as DisplayObject);
	}
	
	}
	
	override public function kill():void
	{
		if (holder==null) return;
		for (var i=0;i<nummasks;i++)
		{
			var tweens:Array=TweenMax.getTweensOf(objs[i].oo);
			for (var j=0;j<tweens.length;j++)
			{
				tweens[j].complete(false);//.setEnabled(false, false); // kill tweens
			}
		}
		//count=nummasks;
		//doall(objs[nummasks-1].oo);
	}
	
	private function doall(o:DisplayObject):void
	{
		count++;
		if (type=="out")
			holder.removeChild(o);
		if (count>=nummasks)
		{
			for (var i=0;i<nummasks;i++)
			{
				if (type=="in")
					holder.removeChild(objs[i].oo);
				//maskees[i].bitmapData.dispose();
				masks[i]=null;
			}
			newt0.bitmapData.dispose();
			newt0=null;
			this.removeChild(holder);
			holder=null;
			if (persist)
			{
				this.addChild(newt1);
			}
			else
			{
				newt1.bitmapData.dispose();
				newt1=null;
			}
			if (dispatch)
			{
				this.dispatchEvent(new Event(eventType));
			}
		}
	}
}
}