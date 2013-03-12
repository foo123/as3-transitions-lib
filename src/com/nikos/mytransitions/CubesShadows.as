package com.nikos.mytransitions
{
import flash.display.*;
import flash.geom.*;
import flash.events.*;
import flash.filters.*;
import flash.utils.*;

// TweenMax
import com.greensock.*;

// PaperVision3D
import org.papervision3d.*;
import org.papervision3d.core.math.*;
import org.papervision3d.core.proto.*;
import org.papervision3d.objects.primitives.*;
import org.papervision3d.view.*;
import org.papervision3d.materials.*;
import org.papervision3d.materials.utils.*;
import org.papervision3d.lights.PointLight3D;
import org.papervision3d.objects.DisplayObject3D;

import com.nikos.utils.TransitionUtils;

public class CubesShadows extends Transition
{
	public static var useFrames:Boolean=true;
	public static var persist:Boolean=true;
	public static var dispatch:Boolean=true;
	public static var startNow:Boolean=true;
	
	private var holder:Sprite=null,slider:BasicView,cubes:Array,count:int,slices:uint,tar:DisplayObject;
	private var shadowCaster:ShadowCaster,movieMaterial:MovieMaterial, movie:Sprite, bmp:BitmapData,shadowplane:Plane, l:PointLight3D,do3d:DisplayObject3D;

	public function CubesShadows()
	{
		super();
	}
	
	override public function doit(params:Object):void
	{
	slices=1;
	var slice_mode:String="horizontal";
	var dir:String="right";
	var dir_mode:String="none";
	var overlap:Number=0.8;
	var perc:Number=1.0;
	var mult:Number=30;
	var camtween:Boolean=false;
	var back:Boolean=false;
	var ord:String="columns-first";
	
	var t:DisplayObject, t2:DisplayObject, duration:Number, eas:Function;
	t=params.fromTarget;
	t2=params.toTarget;
	duration=params.duration;
	eas=params.easing;
	tar=t2;
	
	if (Transition.useGlobal)
	{
		useFrames=Transition.useFramesGlobal;
		persist=Transition.persistGlobal;
		dispatch=Transition.dispatchGlobal;
		startNow=Transition.startNowGlobal;
	}
	
	if (params!=null)
	{
		slices=((params.slices!=null)?params.slices:slices);
		slice_mode=((params.slicing!=null)?params.slicing:slice_mode);
		dir=((params.direction!=null)?params.direction:dir);
		dir_mode=((params.direction_mode!=null)?params.direction_mode:dir_mode);
		overlap=((params.overlap!=null)?params.overlap:overlap);
		/*perc=((params.zoomperc!=null)?params.zoomperc:perc);
		mult=((params.z_multiplier!=null)?params.z_multiplier:mult);
		camtween=(params.zoomperc!=null && params.zoomperc!=undefined);*/
		back=((params.background!=null)?params.background:back);
		ord=((params.ordering!=null)?params.ordering:ord);
	}
	
	//texture parts
	do3d=new DisplayObject3D();
	shadowCaster = new ShadowCaster("shadow1", 0, BlendMode.NORMAL, 0.6, [new BlurFilter(20, 20, 2)]);
	movie = new Sprite();
	shadowCaster.setType(ShadowCaster.DIRECTIONAL);
	bmp = new BitmapData(512, 512, true,0x00000000); // allow transparency;

	movie.graphics.beginBitmapFill(bmp, null, true);
	movie.graphics.drawRect(0, 0, 512, 512);
	movie.graphics.endFill();
	//bmp.dispose();
	
	var i1=TransitionUtils.createTiles(t);
	var i2=TransitionUtils.createTiles(t2);
	var dd=Math.max(i1[0].height,i1[0].width);
	var h=i1[0].height;
	//Where we cast our shadow.  The material must be animated, OR you can call 'drawBitmap' after casting your shadow
	//that is good for baking a shadow in.
	
	movieMaterial = new MovieMaterial(movie, true, true, true);
	shadowplane = new Plane(movieMaterial, 10*dd, 10*dd, 1, 1);
	shadowplane.pitch(89);
	shadowplane.y=-h*0.55;

	//we need this!
	l = new PointLight3D();
	l.x = 0;
	l.y = h*100;
	l.z = 0;


	
	holder=new Sprite();
	//holder.x=t.x;
	//holder.y=t.y;
	this.addChild(holder);
	var foc=100,zoo=80;
	var param3={easing:eas, numofslices:slices, slicing:slice_mode, direction:dir,direction_mode:dir_mode, 
	z_multiplier:mult, cube_color:0, focus:foc, zoom:zoo, z:-foc*zoo, zoomperc:perc,
	slideWidth:t.width, slideHeight:t.height, width:t.width, height:t.height};
	
	if (back)
	{
	var bkgr:Shape=new Shape();
	bkgr.graphics.beginFill(0x000000); //black
	bkgr.graphics.lineStyle(0, 0x000000);
	bkgr.graphics.drawRect(0, 0, param3.width, param3.height);
	bkgr.graphics.endFill();
	bkgr.x=0;
	bkgr.y=0;
	holder.addChild(bkgr); // add black background
	}
	
	slider = new BasicView(param3.width, param3.height, false, false);
	
	var light = null;
	cubes=[];
	var dispatchTime:Number = 0;
	var cub:Cube = null;
	
	slider.camera.focus = param3.focus;
	slider.camera.zoom = param3.zoom;
	slider.camera.z = param3.z;
	slider.camera.ortho = false;
	Papervision3D.useDEGREES=true;
	// create and add cubes to scene and stage.. and start papervision rendering engine
	cubes = slicedCubes([i1[0], i2[0]], param3/*, light*/);
	//add ordering
	var ordobj=TransitionUtils.ordering[ord](cubes,slices,1);
	cubes=ordobj.pieces;
	if (overlap<0) overlap=0;
	if (overlap>1) overlap=1;
	var groups=ordobj.groups
	var d:Number=duration/(groups-(groups-1)*overlap);
	var del=(1-overlap)*d;
	count=0;
	slider.scene.addChild(shadowplane);
	for each (cub in cubes)
	{		
		do3d.addChild(cub as Cube);
		//slider.scene.addChild(cub as Cube);
	}
	slider.scene.addChild(do3d);

	slider.startRendering();
    holder.addChild(slider);
	
	// animate cubes with TweenMax
	var pos0:Number = 0;
	var pos:Number = 0;
	var z0:Number = 0;
	var delay:Number = 0;
	var zz:Number=0;
	var zoomc=slider.camera.zoom;
	
	// tween camera also to zoom in/out
	/*if (camtween)
//		TweenMax.to(slider.camera, duration, {delay:0, useFrames:useFrames, immediateRender:startNow, zoom:zoomc, bezierThrough:[{zoom:param3.zoomperc*zoomc}], ease:param3.easing});
		var yy=slider.camera.y;
		//TweenMax.to(slider.camera, duration, {delay:0, useFrames:useFrames, immediateRender:startNow, y:yy, bezierThrough:[{y:500*(yy+1)}], ease:param3.easing});
	*/
	for(var i=0;i<cubes.length;i++)	
	{
		
		//delay = param3.delay * i;
		zz=cubes[i].z;
		z0 = (zz+0.1) * param3.z_multiplier;
		l.z = z0;
		shadowplane.z=z0;
		if (param3.direction == "up" || param3.direction == "down")
		{
			pos = cubes[i].x;
			pos0 = cubes[i].x + cubes[i].x * 0.1;
			TweenMax.to(cubes[i], d, {delay:ordobj.delays[i]*del, useFrames:useFrames, immediateRender:startNow, rotationX:cubes[i].extra.targetRotation, x:pos, z:zz, bezierThrough:[{x:pos0, z:z0}], ease:param3.easing, onUpdate:castShadow, onComplete:doall});
		}
		else
		{
			pos0 = cubes[i].y + cubes[i].y * 0.1;
			pos = cubes[i].y;
			TweenMax.to(cubes[i], d, {delay:ordobj.delays[i]*del, useFrames:useFrames, immediateRender:startNow, rotationY:cubes[i].extra.targetRotation, y:pos, z:zz, bezierThrough:[{y:pos0, z:z0}], ease:param3.easing, onUpdate:castShadow, onComplete:doall});
		}
	}
	// when all done undo them
	/*dispatchTime = param3.duration + param3.delay * (cubes.length - 1);
	TweenMax.delayedCall(dispatchTime, doall, null, useFrames);*/

	function slicedBitmap(param1:Bitmap, param2:String, param3:Number, param4:Number, param5:Number, param6:Number, param7:Boolean, param33:Object/*, param8 = null*/)
	{
		var m:Matrix = null;
		var img:Bitmap = param1 as Bitmap;
		var bmd:BitmapData = new BitmapData(param5, param6, true, 0);
		if (param7)
		{
			m = new Matrix();
			if (param2 == "vertical")
			{
				m.translate((-param33.slideWidth) / param33.numofslices, (-param33.slideHeight) * 0.5);
				m.rotate(Math.PI);
				m.translate(param3, param33.slideHeight * 0.5);
			}
			else
			{
				m.translate((-param33.slideWidth) * 0.5, (-param33.slideHeight) / param33.numofslices);
				m.rotate(Math.PI);
				m.translate(param33.slideWidth * 0.5, param4);
			}
			bmd.draw(img, m);
		}
		else
		{
			bmd.copyPixels(img.bitmapData, new Rectangle(param3, param4, param5, param6), new Point());
		}
		return(new BitmapMaterial(bmd, true));
	}// end function
	
	function slicedCubes(param2:Array, param32:Object/*, param4 = null*/) : Array
	{
		var cubes=[];
		var cube:Cube=null;
		var outImg:Bitmap,inImg:Bitmap;
		var targetRotation:Number = 0;
		var extra:Object;
		var slice = param32.slicing;
		var to = param32.direction;
		var dir_mode=param32.direction_mode;
		
		var sW = ((slice == "vertical") ? (param32.slideWidth / param32.numofslices) : (param32.slideWidth));
		var sH = ((slice == "horizontal") ? (param32.slideHeight / param32.numofslices) : (param32.slideHeight));
		outImg = param2[0] as Bitmap;
		inImg = param2[1] as Bitmap;
		
		for (var i=0; i<param32.numofslices; i++)
		{	
			var materialsList = new MaterialsList();
			var sX = ((slice == "vertical") ? (sW * i) : (0));
			var sY = ((slice == "horizontal") ? (sH * i) : (0));
			materialsList.addMaterial(new ColorMaterial(param3), "bottom");
			materialsList.addMaterial(new ColorMaterial(param3), "top");
			materialsList.addMaterial(new ColorMaterial(param3), "left");
			materialsList.addMaterial(new ColorMaterial(param3), "right");
			materialsList.addMaterial(new ColorMaterial(param3), "front");
			materialsList.addMaterial(slicedBitmap(outImg, slice, sX, sY, sW, sH, false, param32/*, param4*/), "back");
			switch(to)
			{
				case "up":
				{
					materialsList.removeMaterialByName("bottom");
					materialsList.addMaterial(slicedBitmap(inImg, slice, sX, sY, sW, sH, true, param32/*, param4*/), "bottom");
					break;
				}
				case "down":
				{
					materialsList.removeMaterialByName("top");
					materialsList.addMaterial(slicedBitmap(inImg, slice, sX, sY, sW, sH, false, param32/*, param4*/), "top");
					break;
				}
				case "left":
				{
					materialsList.removeMaterialByName("right");
					materialsList.addMaterial(slicedBitmap(inImg, slice, sX, sY, sW, sH, false, param32/*, param4*/), "right");
					break;
				}
				case "right":
				{
					materialsList.removeMaterialByName("left");
					materialsList.addMaterial(slicedBitmap(inImg, slice, sX, sY, sW, sH, false, param32/*, param4*/), "left");
					break;
				}
				default:
				{
					break;
				}
			}
			if (slice == "vertical")
			{
				if (to == "left" || to == "right")
				{
					cube = new Cube(materialsList, sW, sW, param32.slideHeight);
					cube.x = sX - param32.slideWidth * 0.5 + sW * 0.5;
					cube.z = sW * 0.5;
				}
				else
				{
					cube = new Cube(materialsList, sW, param32.slideHeight, param32.slideHeight);
					cube.x = sX - param32.slideWidth * 0.5 + sW * 0.5;
					cube.z = param32.slideHeight * 0.5;
				}
			}
			else if (to == "left" || to == "right")
			{
				cube = new Cube(materialsList, param32.slideWidth, param32.slideWidth, sH);
				cube.y = param32.slideHeight * 0.5 - sY - sH * 0.5;
				cube.z = param32.slideWidth * 0.5;
			}
			else
			{
				cube = new Cube(materialsList, param32.slideWidth, sH, sH);
				cube.y = param32.slideHeight * 0.5 - sY - sH * 0.5;
				cube.z = sH * 0.5;
			}
			
			if (to == "up" || to == "left")
			{
				extra={targetRotation:targetRotation + 90 % 360};
			}
			else if (to == "down" || to == "right")
			{
				extra={targetRotation:targetRotation - 90 % 360};
			}
			else extra={targetRotation:targetRotation};
			
			switch(dir_mode)
			{
				case "alternate":
								if (slice=="vertical")
								{
									if (to=="up")
										to="down";
									else to="up";
								}
								else
								{
									if (to=="right")
										to="left";
									else to="right";
								}
								break;
				case "random":
								if (slice=="vertical")
								{
									if (Math.random()<.5)
										to="down";
									else to="up";
								}
								else
								{
									if (Math.random()<.5)
										to="left";
									else to="right";
								}
								break;
				case "none":
				default:
						break;
			}
			cube.extra=extra;
			cubes.push(cube);
		}
		return (cubes as Array);
	}// end function
	
}
	override public function kill():void
	{
		if (holder==null) return;
		for (var i=0;i<slices;i++)
		{
			var tweens:Array=TweenMax.getTweensOf(cubes[i]);
			for (var j=0;j<tweens.length;j++)
			{
				tweens[j].complete(false);//.setEnabled(false, false); // kill tweens
			}
		}
		//count=slices;
		//doall();
	}
	
	private function destroyCubes(cont:BasicView) : void
	{
		var cub:Cube = null;
		cont.stopRendering();
		for each (cub in cubes)
		{
			
			cub.materials.getMaterialByName("top").destroy();
			cub.materials.getMaterialByName("bottom").destroy();
			cub.materials.getMaterialByName("front").destroy();
			cub.materials.getMaterialByName("back").destroy();
			cub.materials.getMaterialByName("left").destroy();
			cub.materials.getMaterialByName("right").destroy();
			cub.material.destroy();
			cub.destroy();
			shadowplane=null;
			movieMaterial.destroy();
			//cont.scene.removeChild(cub);
		}
		cont.viewport.destroy();
		return;
	}// end function
	
	private function castShadow():void
	{
	//for each (var cub in cubes as Cube)
		shadowCaster.castModel(do3d, l, shadowplane, true, true); //cast a shadow for next render!
	}
	
	private function doall() : void
	{
		count++;
		if (count>=slices)
		{
		this.removeChild(holder);
		holder.removeChild(slider);
		destroyCubes(slider);
		slider=null;
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
}