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

import com.foxaweb.pageflip.PageFlip;	// modified page flip class

public class FlipPage extends Transition
{
	public static var useFrames:Boolean=true;
	public static var persist:Boolean=true;
	public static var dispatch:Boolean=true;
	public static var startNow:Boolean=true;
	
	private var outerholder:Sprite=null,holder:Shape,newt0:Bitmap,newt1:Bitmap,ms:Shape,page0:BitmapData,page1:BitmapData,to:Object,target:DisplayObject;
	
	public function FlipPage()
	{
		super();
	}
	
	override public function doit(params:Object):void
	{
	var mode:String="diagonal-top-left-reverse";
	
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
		mode=((params.mode!=null)?params.mode:mode);
	}
	
	var diag,spti,ish,revers;
	newt0=TransitionUtils.createTiles(t0)[0];
	newt1=TransitionUtils.createTiles(t1)[0];
	switch(mode)
	{
		case "horizontal-top-left":
					diag=false;
					ish=true;
					spti=0;
					revers=false;
					break;
		case "horizontal-top-right":
					diag=false;
					ish=true;
					spti=1;
					revers=false;
					break;
		case "horizontal-bottom-right":
					diag=false;
					ish=true;
					spti=3;
					revers=false;
					break;
		case "horizontal-bottom-left":
					diag=false;
					ish=true;
					spti=2;
					revers=false;
					break;
		case "vertical-top-left":
					diag=false;
					ish=false;
					spti=0;
					revers=false;
					break;
		case "vertical-top-right":
					diag=false;
					ish=false;
					spti=1;
					revers=false;
					break;
		case "vertical-bottom-left":
					diag=false;
					ish=false;
					spti=2;
					revers=false;
					break;
		case "vertical-bottom-right":
					diag=false;
					ish=false;
					spti=3;
					revers=false;
					break;
		case "horizontal-top-left-reverse":
					diag=false;
					ish=true;
					spti=0;
					revers=true;
					break;
		case "horizontal-top-right-reverse":
					diag=false;
					ish=true;
					spti=1;
					revers=true;
					break;
		case "horizontal-bottom-right-reverse":
					diag=false;
					ish=true;
					spti=3;
					revers=true;
					break;
		case "horizontal-bottom-left-reverse":
					diag=false;
					ish=true;
					spti=2;
					revers=true;
					break;
		case "vertical-top-left-reverse":
					diag=false;
					ish=false;
					spti=0;
					revers=true;
					break;
		case "vertical-top-right-reverse":
					diag=false;
					ish=false;
					spti=1;
					revers=true;
					break;
		case "vertical-bottom-left-reverse":
					diag=false;
					ish=false;
					spti=2;
					revers=true;
					break;
		case "vertical-bottom-right-reverse":
					diag=false;
					ish=false;
					spti=3;
					revers=true;
					break;
		case "diagonal-top-right-reverse":
					diag=true;
					ish=false;
					spti=1;
					revers=true;
					break;
		case "diagonal-bottom-right-reverse":
					diag=true;
					ish=false;
					spti=3;
					revers=true;
					break;
		case "diagonal-bottom-left-reverse":
					diag=true;
					ish=false;
					spti=2;
					revers=true;
					break;
		case "diagonal-top-left-reverse":
					diag=true;
					ish=false;
					spti=0;
					revers=true;
					break;
		case "diagonal-top-right":
					diag=true;
					ish=false;
					spti=1;
					revers=false;
					break;
		case "diagonal-bottom-right":
					diag=true;
					ish=false;
					spti=3;
					revers=false;
					break;
		case "diagonal-bottom-left":
					diag=true;
					ish=false;
					spti=2;
					revers=false;
					break;
		case "diagonal-top-left":
		default:
					diag=true;
					ish=false;
					spti=0;
					revers=false;
					break;
	}
	outerholder=new Sprite();
	this.addChild(outerholder);
	
	if (mode.substr(mode.length-8,8)=="-reverse")
	{
		outerholder.addChild(newt0);
		target=newt1;
	}
	else
	{
		outerholder.addChild(newt1);
		target=newt0;
	}
	//var stag=target.stage;
	var theta:Number=Math.PI*2/180; //rads for 2 degrees for flip angle
	var perc:Number=0.6;
	var sens:Number=1.0;
	var spt:Point=new Point();
	spti=spti%4;
	holder=new Shape();
	var tw=target.width;
	var th=target.height;
	page0 = new BitmapData(tw, th, true, 0);
	page0.draw(target); // draw target as front page
	page1 = new BitmapData(page0.width, page0.height, true, 0);
	var mat=new Matrix();
	mat.createBox(-1,1,0,target.width,0);
	page1.draw(target,mat); // draw flipped target as back page
	var rect:Rectangle = new Rectangle(0, 0, page0.width, page0.height);
	var ptr:Point = new Point(0, 0);
	// simple gray scale back page of the same bitmap 
	page1.copyChannel(page1, rect, ptr, BitmapDataChannel.GREEN, BitmapDataChannel.BLUE);
	page1.copyChannel(page1, rect, ptr, BitmapDataChannel.GREEN, BitmapDataChannel.RED);
	page1.copyChannel(page1, rect, ptr, BitmapDataChannel.GREEN, BitmapDataChannel.GREEN);
	ms=new Shape();
	this.addChild(ms);
	ms.graphics.beginFill(0xFFFFFF); //white
    ms.graphics.lineStyle(0, 0xFFFFFF);
    ms.graphics.drawRect(0, 0, tw, th);
	ms.graphics.endFill();
	//ms.x=target.x;
	//ms.y=target.y;
	holder.mask=ms; // add mask
	this.addChild(holder);
	//holder.x=target.x;
	//holder.y=target.y;
	var mux=1,muy=1;
			
			switch(spti)
			{
				case 0:
						spt=new Point(0,0);
						mux=1;
						muy=1;
						break;
				case 1:
						spt=new Point(1,0);
						mux=-1;
						muy=1;
						break;
				case 2:
						spt=new Point(0,1);
						mux=1;
						muy=-1;
						break;
				default:
						spt=new Point(1,1);
						mux=-1;
						muy=-1;
						break;
			}

	if (!revers)
	{
	to={tt:0.0};
	TweenMax.to(to, duration, {useFrames:useFrames, immediateRender:startNow, tt:1.0, ease:eas, onInit:doflip, onInitParams:[to], onUpdate:doflip, onUpdateParams:[to], onComplete:doall});
	}
	else
	{
	to={tt:1.0};
	TweenMax.to(to, duration, {useFrames:useFrames, immediateRender:startNow, tt:0.0, ease:eas, onInit:doflip, onInitParams:[to], onUpdate:doflip, onUpdateParams:[to], onComplete:doall});
	}
	
	function doflip(qt : Object):void
	{
		var tt=qt.tt;
		var pt:Point=new Point();
		if (diag)
		{
			pt.x=spt.x*tw+mux*2*tt*tw;
			pt.y=spt.y*th+muy*2*tt*th;
		}
		else
		{
		if (ish)
		{
			if (2*tt<perc)
			{
				pt.x=spt.x*tw+mux*2*tt*tw;
				pt.y=spt.y*th+muy*pt.x*Math.tan(theta);
			}
			else if (2*tt>perc && 2*tt<2*perc)
			{
				pt.x=spt.x*tw+mux*2*tt*tw;
				pt.y=spt.y*th-muy*pt.x*Math.tan(theta);
			}
			else
			{
				pt.x=spt.x*tw+mux*2*tt*tw;
				pt.y=spt.y*th;
			}
		}
		else
		{
			if (2*tt<perc)
			{
				pt.y=spt.y*th+muy*2*tt*th;
				pt.x=spt.x*tw+mux*pt.y*Math.tan(theta);
			}
			else if (2*tt>perc && 2*tt<2*perc)
			{
				pt.y=spt.y*th+muy*2*tt*th;
				pt.x=spt.x*tw-mux*pt.y*Math.tan(theta);
			}
			else
			{
				pt.y=spt.y*th+muy*2*tt*th;
				pt.x=spt.x*tw;
			}
		}
		}
		var o:Object=PageFlip.computeFlip(pt,	// flipped point
										spt,		// of bottom-right corner
										tw,		// size of the sheet
										th,
										ish,				// in horizontal mode
										sens,diag);					// sensibility to one 

		PageFlip.drawBitmapSheet(o,			// computeflip returned object
								holder,		// target
								page0,		// bitmap page 0
								page1);		// bitmap page 1
	}
	}
	
	override public function kill():void
	{
		if (holder==null) return;
		var tweens:Array=TweenMax.getTweensOf(to);
		for (var j=0;j<tweens.length;j++)
		{
			tweens[j].complete(false);//.setEnabled(false, false); // kill tweens
		}
		//doall();
	}
	
	private function doall() : void
	{
		//doflip(g);
		this.removeChild(outerholder)
		this.removeChild(holder);
		ms=null;
		page0.dispose();
		page1.dispose();
		newt0.bitmapData.dispose();
		newt0=null;
		outerholder=null;
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