package com.nikos.mytransitions
{
import flash.display.*;
import flash.geom.*;
import flash.events.*;
import flash.filters.*;
import flash.utils.*;

import com.as3dmod.ModifierStack;
import com.as3dmod.modifiers.*;
import com.as3dmod.plugins.pv3d.LibraryPv3d;
import com.as3dmod.util.ModConstant;

import org.papervision3d.*;
import org.papervision3d.core.math.*;
import org.papervision3d.core.proto.*;
import org.papervision3d.objects.primitives.*;
import org.papervision3d.view.*;
import org.papervision3d.materials.*;
import org.papervision3d.materials.utils.*;
import org.papervision3d.core.effects.BitmapLayerEffect;
import org.papervision3d.view.layer.BitmapEffectLayer;

// TweenMax
import com.greensock.*;

import com.nikos.utils.TransitionUtils;


public class FlipPage3D extends Transition
{
	public static var useFrames:Boolean=true;
	public static var persist:Boolean=true;
	public static var dispatch:Boolean=true;
	public static var startNow:Boolean=true;
	
	private var holder:Sprite=null,bv:BasicView,mt0:BitmapMaterial,mt1:BitmapMaterial,emptymt:ColorMaterial,newt0:Bitmap,newt1:Bitmap,to:Object,target:DisplayObject;
	
	private var _mod:ModifierStack;
	private var _bend:Bend;
	private var _twist:Twist;

	private var _cube:Cube=null;

	private var _bitmapEffectLayer:BitmapEffectLayer;
	private var _blur:BlurFilter;

	
	public function FlipPage3D()
	{
		super();
	}
	
	override public function doit(params:Object):void
	{
	var mode:String="bend";
	
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
 
		newt0=TransitionUtils.createTiles(t0)[0];
		newt1=TransitionUtils.createTiles(t1)[0];
		holder=new Sprite();
		addChild(holder);
		bv = new BasicView(newt0.width, newt0.height, false, false);
		holder.addChild(bv);
		bv.camera.focus = 100;
		bv.camera.zoom = 80;
		bv.camera.z = -80*100;
		bv.camera.ortho = false;
		Papervision3D.useDEGREES=true;
		
		mt0 = new BitmapMaterial( newt0.bitmapData, true );
		mt1 = new BitmapMaterial( newt1.bitmapData, true );


		emptymt = new ColorMaterial( 0xffffff ,0);

		// MATERIALS.. materials with loaders on two sides all other materials transparent color material
		var mats:MaterialsList = new MaterialsList();
		mats.addMaterial( emptymt, "bottom");
		mats.addMaterial( emptymt , "top" );
		mats.addMaterial( emptymt , "left");
		mats.addMaterial( emptymt , "right");
		mats.addMaterial( mt1 , "front" );
		mats.addMaterial( mt0 , "back");

		// CUBE.. that appears as a plane with two sides
		_cube = new Cube( mats, newt0.width, 1, newt0.height, 20, 10, 1 );
		_cube.useOwnContainer = true;

		bv.scene.addChild( _cube);

		_mod = new ModifierStack( new LibraryPv3d() , _cube );
		if (mode=="twist")
		{
		_twist = new Twist();
		_twist.angle=0;
		_mod.addModifier( _twist );
		}
		else
		{
		_bend = new Bend();
		if (newt0.height>newt0.width)
			_bend.switchAxes=true;
		_bend.constraint = ModConstant.NONE;
		_mod.addModifier( _bend );
		}
		_bitmapEffectLayer = new BitmapEffectLayer( bv.viewport , newt0.width , newt0.height);
		_bitmapEffectLayer.renderAbove = true;

		bv.viewport.containerSprite.addLayer( _bitmapEffectLayer ); 

		_bitmapEffectLayer.addDisplayObject3D( _cube );
		_blur = new BlurFilter(0,0);
		_blur.quality = 1;
		_bitmapEffectLayer.addEffect( new BitmapLayerEffect( _blur ));

		_bitmapEffectLayer.clearBeforeRender = true;
		_bitmapEffectLayer.drawLayer.blendMode = BlendMode.ADD;

		to={flipValue:0,z:_cube.z};
		var zz=_cube.z;
		bv.startRendering();
		TweenMax.to(to, duration, {delay:0, useFrames:useFrames, immediateRender:startNow, flipValue:1, z:zz, bezierThrough:[{z:5000}], ease:eas, onUpdate:render, onComplete:doall});

		function render():void
		{
			_cube.rotationY = 180*to.flipValue;
			_cube.z=to.z;
			_blur.blurX = _blur.blurY = (1-Math.abs(2*to.flipValue-1))*5;
			if (mode=="twist")
			{
				_twist.angle=-(1-Math.abs(2*to.flipValue-1))*45*Math.PI/180;
			}
			else
			{
			//if (to.flipValue>.5)
				_bend.force=  -(1-Math.abs(2*to.flipValue-1))*2.5;
			//else
				//_bend.force=  (1-Math.abs(2*to.flipValue-1))*2;
			_bend.offset = 0.5 /*+ _tweenX*/;
			//_bend.angle = (1-Math.abs(2*to.flipValue-1))*90*Math.PI/180;
			}
			_mod.apply();
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
		this.removeChild(holder);
		holder.removeChild(bv);
		bv.stopRendering();
		_cube.materials.getMaterialByName("top").destroy();
		_cube.materials.getMaterialByName("bottom").destroy();
		_cube.materials.getMaterialByName("front").destroy();
		_cube.materials.getMaterialByName("back").destroy();
		_cube.materials.getMaterialByName("left").destroy();
		_cube.materials.getMaterialByName("right").destroy();
		_cube.material.destroy();
		_cube.destroy();
		bv.scene.removeChild(_cube);
		bv.viewport.destroy();
		newt0.bitmapData.dispose();
		newt0=null;
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