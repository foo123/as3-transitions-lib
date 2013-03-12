package com.nikos.mytransitions.fp10
{
import flash.display.*;
import flash.geom.*;
import flash.events.*;
import flash.filters.*;
import flash.utils.*;
import flash.utils.ByteArray;	

// TweenMax
import com.greensock.*;

import com.nikos.utils.TransitionUtils;
import com.nikos.mytransitions.*;

public class Twirl extends Transition
{
	public static var useFrames:Boolean=true;
	public static var persist:Boolean=true;
	public static var dispatch:Boolean=true;
	public static var startNow:Boolean=true;
	
	private var holder:Sprite=null,hold:Bitmap,newt:Bitmap,newt2:Bitmap,obj:Object;
	
	[Embed("../assets/twirle2.pbj", mimeType="application/octet-stream")]
	private static var TwirlData : Class;
	private var TwirlShader : Shader;	
	private var filter:ShaderFilter;
	
	public function Twirl()
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
	
	
	TwirlShader=new Shader(new TwirlData() as ByteArray);
	filter = new ShaderFilter(TwirlShader);
	holder=new Sprite();
    newt=TransitionUtils.createTiles(t)[0];
    newt2=TransitionUtils.createTiles(t2)[0];
	holder.addChild(newt2);
	holder.addChild(newt);
	addChild(holder);
	//hold=new Bitmap();
	//addChild(hold);
	TwirlShader.data.center.value = [holder.width/2, holder.height/2];
	obj={value:0.0}
	
	TweenMax.to(obj, duration, {delay:0, useFrames:useFrames, immediateRender:startNow, value:1.0, ease:eas, onUpdate:applyEffect, onComplete:doall});
	
	function applyEffect():void
    {
		var tt=obj.value;
		newt.alpha=1-tt;
		newt2.alpha=tt;
		var aa=(1-Math.abs(2*tt-1));
		var alpha=aa*holder.width;
		var beta=aa*holder.height;
		var angle=aa*Math.PI;
		TwirlShader.data.alpha.value = [alpha/2];
		TwirlShader.data.beta.value = [beta/2];
		TwirlShader.data.angle.value = [angle];
		holder.filters=[filter];
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