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
import org.papervision3d.objects.primitives.*;
import org.papervision3d.view.*;
import org.papervision3d.materials.*;
import org.papervision3d.materials.utils.*;

// TweenMax
import com.greensock.*;

import com.nikos.utils.TransitionUtils;

public class FlipTiles extends Transition
{
	public static var useFrames:Boolean=true;
	public static var persist:Boolean=true;
	public static var dispatch:Boolean=true;
	public static var startNow:Boolean=true;
	
	private var bigholder:Sprite=null,pieces0:Array,pieces1:Array,matlist0:Array,matlist1:Array,planelist0:Array,planelist1:Array,count:int=0,size:int,bv:BasicView,ho:Array,tar:DisplayObject;
	
	public function FlipTiles()
	{
		super();
	}
	
	override public function doit(params:Object):void
	{
	var rows:int=1;
	var columns:int=1;
	var overlap:Number=0.8;
	var ord:String="spiral-top-left";
	var spin:String="horizontal";
	var back:Boolean=false;
	
	var t0:DisplayObject, t1:DisplayObject, duration:Number, eas:Function;
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
	
	if (params!=null)
	{
		rows=((params.rows!=null)?params.rows:rows);
		columns=((params.columns!=null)?params.columns:columns);
		overlap=((params.overlap!=null)?params.overlap:overlap);
		ord=((params.ordering!=null)?params.ordering:ord);
		spin=((params.spin!=null)?params.spin:spin);
		back=((params.background!=null)?params.background:back);
	}
	if (rows<=0) rows=1;
	if (columns<=0) columns=1;
	
	var i:int,j:int;
	
		bigholder=new Sprite;
		// add a black background so to see the effect better
		if (back)
		{
		var bkgr:Shape=new Shape();
		bkgr.graphics.beginFill(0x000000); //black
    	bkgr.graphics.lineStyle(0, 0x000000);
    	bkgr.graphics.drawRect(0, 0, t0.width, t0.height);
		bkgr.graphics.endFill();
		bkgr.x=0;
		bkgr.y=0;
		bigholder.addChild(bkgr);
		}
		var tw=t0.width;
		var th=t0.height;
		pieces0=TransitionUtils.createTiles(t0,rows,columns);
		pieces1=TransitionUtils.createTiles(t1,rows,columns);
		var groups;
		
		// build 3D materials and planes of the image segments
		bv=new BasicView(tw,th,false,false);
		bv.camera.focus = 100;
		bv.camera.zoom = 80;
		bv.camera.z = -100*80;
		bv.camera.ortho = false;
		Papervision3D.useDEGREES=true;
		matlist0=[];
		matlist1=[];
		planelist0=[];
		planelist1=[];
		
		var ind=[]
		for (i=0;i<pieces0.length;i++)
			ind[i]=i;
		var ordobj=TransitionUtils.ordering[ord](ind,rows,columns);
		groups=ordobj.groups;
		if (overlap>1.0)	overlap=1.0;
		if (overlap<0.0)	overlap=0.0;
		var d:Number=duration/(groups-(groups-1)*overlap);
		var o:Number=d*overlap;
		count=0;
		size=pieces0.length;
		ind=ordobj.pieces;
		
		for (j=0; j<columns ; j++)
		{
			for(i=0; i<rows ; i++)
			{
				var k1=j*rows+i;
				matlist0[k1]=new BitmapMaterial(pieces0[k1].bitmapData,true);
				planelist0[k1]=new Plane(matlist0[k1],pieces0[k1].bitmapData.width,pieces0[k1].bitmapData.height);
				var arw=pieces0[k1].bitmapData.width;
				var arh=pieces0[k1].bitmapData.height;
				planelist0[k1].x=pieces0[k1].x+arw*0.5-tw/2;
				planelist0[k1].y=(th-pieces0[k1].y)-arh*0.5-th/2; // y is opposite in flash
				planelist0[k1].z=0;
				planelist0[k1].visible=true;	// show initial face
				bv.scene.addChild(planelist0[k1]);
				matlist1[k1]=new BitmapMaterial(pieces1[k1].bitmapData,true);
				planelist1[k1]=new Plane(matlist1[k1],pieces1[k1].bitmapData.width,pieces1[k1].bitmapData.height);
				arw=pieces1[k1].bitmapData.width;
				arh=pieces1[k1].bitmapData.height;
				planelist1[k1].x=pieces1[k1].x+arw*0.5-tw/2;
				planelist1[k1].y=(th-pieces1[k1].y)-arh*0.5-th/2;  // y is opposite in flash
				planelist1[k1].z=0;				
				planelist1[k1].visible=false; // hide back face			
				// initial rotation of back face
				if(spin=="vertical")
					planelist1[k1].rotationY = 180;
				else // horizontal
					planelist1[k1].rotationX = 180;
				bv.scene.addChild(planelist1[k1]);
			}
		}
		bv.startRendering();
		bigholder.addChild(bv);
		this.addChild(bigholder);
		//bigholder.x=t0.x;
		//bigholder.y=t0.y;
		
		ho=[];
		var rr=0,cc=0;
		for(i=0; i<pieces0.length; i++)
		{
			ho[i]={i:i, angle:0.0, prev:0.0};			
			TweenMax.to(ho[i], d, {delay:ordobj.delays[i]*(d-o), useFrames:useFrames, immediateRender:startNow, angle:180, ease:eas, onUpdate:renderView, onUpdateParams:[ho[i]], onComplete:doall});
		}
		
		function renderView(q:Object):void
		{
			if ( (q.angle < 90 && q.angle >= 0) || (q.angle > 270 && q.angle <= 360) 
				|| (q.angle > -90 && q.angle <= 0) || (q.angle < -270 && q.angle >= -360)) 
			{
				planelist0[ind[q.i]].visible = true;
				planelist1[ind[q.i]].visible = false;
			}
			else 
			{
				planelist0[ind[q.i]].visible = false;
				planelist1[ind[q.i]].visible = true;
			}
			
			if (spin=="vertical")
			{
				planelist0[ind[q.i]].rotationY = q.angle;
				// +initial rotation of back face
				planelist1[ind[q.i]].rotationY = q.angle+180;
			}
			else // horizontal
			{
				planelist0[ind[q.i]].rotationX = q.angle;
				// +initial rotation of back face
				planelist1[ind[q.i]].rotationX = q.angle+180;
			}
			q.prev=q.angle;
		}
	}
	
	override public function kill():void
	{
		if (bigholder==null) return;
		for (var i=0;i<size;i++)
		{
			var tweens:Array=TweenMax.getTweensOf(ho[i]);
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
			bv.stopRendering();
			this.removeChild(bigholder);
			for (var j=0; j<pieces0.length ; j++)
			{
					bv.scene.removeChild(planelist0[j]);
					matlist0[j].destroy();
					pieces0[j].bitmapData.dispose();
					bv.scene.removeChild(planelist1[j]);
					matlist1[j].destroy();
					pieces1[j].bitmapData.dispose();
			}
			bigholder=null;
			if (persist)
			{
				var newt1=TransitionUtils.createTiles(tar)[0];
				this.addChild(newt1);
			}
			if (dispatch)
			{					
				this.dispatchEvent(new Event(eventType));
			}
		}
	}

}
}