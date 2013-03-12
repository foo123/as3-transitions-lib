package com.nikos.mytransitions
{
import flash.display.*;
import flash.geom.*;
import flash.events.*;
import flash.filters.*;
import flash.utils.*;

// PaperVision3D
import org.papervision3d.*;
import org.papervision3d.core.math.*;
import org.papervision3d.core.proto.*;
import org.papervision3d.objects.*;
import org.papervision3d.objects.primitives.*;
import org.papervision3d.view.*;
import org.papervision3d.materials.*;
import org.papervision3d.materials.utils.*;

// TweenMax
import com.greensock.*;

import com.nikos.utils.TransitionUtils;

public class Shuffle extends Transition
{
	public static var useFrames:Boolean=true;
	public static var persist:Boolean=true;
	public static var dispatch:Boolean=true;
	public static var startNow:Boolean=true;
	
	private var holder:Sprite=null,newt0:Bitmap,newt1:Bitmap,mat0:MovieMaterial,mat1:MovieMaterial,bv:BasicView,mask0:Sprite,mask1:Sprite,rev0:Bitmap,rev1:Bitmap,srev0:Sprite,srev1:Sprite;
	private var plane0:Plane,plane1:Plane,count:int=0;
	
	public function Shuffle()
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
	
	var mode="left";
	
	if (params!=null)
	{
		mode=((params.mode!=null)?params.mode:mode);
	}
	
		holder=new Sprite();
		var dmrefl=50;
		var cols=[0x000000, 0x000000];
		var alphas=[0.4, 0];
		var ratios=[0, 50];
		// bitmaps and sprites
		newt0=TransitionUtils.createTiles(t0)[0];
		newt1=TransitionUtils.createTiles(t1)[0];
		rev0=TransitionUtils.createTiles(t0)[0];
		rev1=TransitionUtils.createTiles(t1)[0];
		rev0.scaleY=-1; // reflect
		// create the mask for reflection  
		mask0 = new Sprite();
		var mat=new Matrix();
		mat.createGradientBox(newt0.width,newt0.height,Math.PI/2);
		// fade gradually
		mask0.graphics.beginGradientFill("linear",cols,alphas,ratios,mat);
		mask0.graphics.drawRect(0,0,newt0.width,newt0.height);
		mask0.graphics.endFill();
		mask0.cacheAsBitmap=true;
		rev0.cacheAsBitmap=true;
		rev0.mask = mask0;  
		srev0=new Sprite();
		srev0.addChild(newt0);
		srev0.addChild(rev0);
		rev0.y=2*newt0.height+dmrefl;
		srev0.addChild(mask0);
		mask0.y=newt0.height+dmrefl;
		
		rev1.scaleY=-1; // reflect
		// create the mask for reflection  
		mask1 = new Sprite();
		mat=new Matrix();
		mat.createGradientBox(newt1.width,newt1.height,Math.PI/2);
		// fade gradually
		mask1.graphics.beginGradientFill("linear",cols,alphas,ratios,mat);
		mask1.graphics.drawRect(0,0,newt1.width,newt1.height);
		mask1.graphics.endFill();
		mask1.cacheAsBitmap=true;
		rev1.cacheAsBitmap=true;
		rev1.mask = mask1;  
		srev1=new Sprite();
		srev1.addChild(newt1);
		srev1.addChild(rev1);
		rev1.y=2*newt1.height+dmrefl;
		srev1.addChild(mask1);
		mask1.y=newt1.height+dmrefl;
		
		bv=new BasicView(t0.width,t0.height,false,false);
		bv.camera.focus = 100;
		bv.camera.zoom = 80;
		bv.camera.z = -100*80;
		bv.camera.ortho = false;
		Papervision3D.useDEGREES=true;
		
		// materials and planes
		mat0=new MovieMaterial(srev0,true,false,true);
		mat0.oneSide=false;
		mat0.doubleSided=true;
		mat1=new MovieMaterial(srev1,true,false,true);
		mat1.oneSide=false;
		mat1.doubleSided=true;
		
		plane0=new Plane(mat0,srev0.width,srev0.height);
		plane1=new Plane(mat1,srev1.width,srev1.height);
		bv.scene.addChild(plane0);
		bv.scene.addChild(plane1);
		bv.startRendering();
		holder.addChild(bv);
		this.addChild(holder);
		var zb=5000;
		plane0.y=-(newt0.height+dmrefl)*.5;
		plane1.y=-(newt1.height+dmrefl)*.5;
		plane1.z=zb;
		
		// animate transition
		var rot;
		var xx0;
		var xx1;
		if (mode=="right")
		{
			rot=-60;
			xx0=newt0.width/4;
			xx1=-newt1.width/4;
		}
		else
		{
			rot=60;
			xx0=-newt0.width/4;
			xx1=newt1.width/4;
		}
		count=0;
		TweenMax.to(plane0, duration, {delay:0, useFrames:useFrames, immediateRender:startNow, rotationY:0, z:zb, x:0, bezierThrough:[{rotationY:-rot,x:xx0}], ease:eas, onComplete:doall});
		TweenMax.to(plane1, duration, {delay:0, useFrames:useFrames, immediateRender:startNow, rotationY:0, z:0, x:0, bezierThrough:[{rotationY:rot,x:xx1}], ease:eas, onComplete:doall});
	}
	
	override public function kill():void
	{
		if (holder==null) return;
			var tweens:Array=TweenMax.getTweensOf(plane0);
			for (var j=0;j<tweens.length;j++)
			{
				tweens[j].complete(false);//.setEnabled(false, false); // kill tweens
			}
			tweens=TweenMax.getTweensOf(plane1);
			for (j=0;j<tweens.length;j++)
			{
				tweens[j].complete(false);//.setEnabled(false, false); // kill tweens
			}
		//count=size;
		//doall();
	}
	
	private function doall():void
	{
		count++;
		if (count>=2)
		{
		bv.stopRendering();
		this.removeChild(holder);
		holder.removeChild(bv);
		bv.scene.removeChild(plane0);
		bv.scene.removeChild(plane1);
		plane0=null;
		plane1=null;
		mat0.destroy();
		mat1.destroy();
		newt0.bitmapData.dispose();
		rev0.bitmapData.dispose();
		rev1.bitmapData.dispose();
		mask0=null;
		mask1=null;
		rev0.mask=null;
		rev1.mask=null;
		srev0=null;
		srev1=null;
		holder=null;
		if (persist)
		{
			this.addChild(newt1);
		}
		else newt1.bitmapData.dispose();
		if (dispatch)
		{					
			this.dispatchEvent(new Event(eventType));
		}
		}
	}

}
}