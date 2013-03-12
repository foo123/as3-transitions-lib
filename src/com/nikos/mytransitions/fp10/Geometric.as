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

public class Geometric extends Transition
{
	public static var useFrames:Boolean=true;
	public static var persist:Boolean=true;
	public static var dispatch:Boolean=true;
	public static var startNow:Boolean=true;
	
	private var holder:Sprite=null,hold:Bitmap,newt:Bitmap,newt2:Bitmap,obj:Object;
	
	public function Geometric()
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
	
	if (Transition.useGlobal)
	{
		useFrames=Transition.useFramesGlobal;
		persist=Transition.persistGlobal;
		dispatch=Transition.dispatchGlobal;
		startNow=Transition.startNowGlobal;
	}
	
	
	holder=new Sprite();
    newt=TransitionUtils.createTiles(t)[0];
    newt2=TransitionUtils.createTiles(t2)[0];
	holder.addChild(newt2);
	holder.addChild(newt);
	//addChild(holder);
	hold=new Bitmap();
	addChild(hold);
	
	obj={value:0.0}
	var amplitudeX,amplitudeY,frequencyX,frequencyY;
	var centerX,centerY,radius,angle;
	
	TweenMax.to(obj, duration, {delay:0, useFrames:useFrames, immediateRender:startNow, value:1.0, ease:eas, onUpdate:applyEffect, onComplete:doall});
	
	function ripplesFilter(point:Point):Point
	{
		var newpoint:Point=new Point();
            newpoint.x = point.x + amplitudeX * Math.sin(point.y * frequencyX);
            newpoint.y = point.y + amplitudeY * Math.sin(point.x * frequencyY);
		return(newpoint);
	}
	
	function swirl2(point:Point):Point
	{
		var a = 1
		var b = radius

		var x=point.x-centerX;
		var y=point.y-centerY;
		var angle2 = angle*a*Math.exp(-(x*x+y*y)/(b*b))
		var c=Math.cos(angle2);
		var s=Math.sin(angle2);
		var u = c*x + s*y+centerX;
		var v = -s*x + c*y+centerY;	
		return(new Point(u,v));
	}
	function twirlFilter(point:Point):Point
	{
		var _loc_2:Number = NaN;
		var _loc_3:Number = NaN;
		var _loc_4:Number = NaN;
		var _loc_5:Number = NaN;
		var _loc_6:Number = NaN;
		var _loc_7:Number = NaN;
		_loc_2 = point.x;
		_loc_3 = point.y;
		_loc_4 = _loc_2 - centerX;
		_loc_5 = _loc_3 - centerY;
		_loc_6 = Math.sqrt(_loc_4 * _loc_4 + _loc_5 * _loc_5);
		if (_loc_6 < radius)
		{
			_loc_7 = Math.atan2(_loc_5, _loc_4) + angle * (radius - _loc_6) / radius;
			point.x = centerX + _loc_6 * Math.cos(_loc_7);
			point.y = centerY + _loc_6 * Math.sin(_loc_7);
		}
		return point;
	}
	
	function applyEffect():void
    {
		var tt=obj.value;
		newt.alpha=1-tt;
		newt2.alpha=tt;
		var aa=(1-Math.abs(2*tt-1));
		//amplitudeX=amplitudeY=aa*5;
		//frequencyX=frequencyY=Math.PI/4;
		radius=500;
		angle=aa*Math.PI/4;
		centerX=holder.width/2;
		centerY=holder.height/2;
		//hold.bitmapData.dispose();
		hold.bitmapData=new BitmapData(holder.width,holder.height,true,0);
		hold.bitmapData.draw(holder);
		TransitionUtils.applyImageFilter(hold.bitmapData,swirl2);
    }
	}
	
	override public function kill():void
	{
		if (holder==null) return;
		var tweens:Array=TweenMax.getTweensOf(obj);
		for (var j=0;j<tweens.length;j++)
		{
			tweens[j].complete(false);//.setEnabled(false, false); // kill tweens
		}
		//doall();
	}
	
	private function doall()
	{
		//this.removeChild(holder);
		newt.bitmapData.dispose();
		if (persist)
		{
			this.addChild(newt2);
		}
		else newt2.bitmapData.dispose();
		if (dispatch)
		{
			this.dispatchEvent(new Event(eventType));
		}
	}
}
}