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

public class JigsawPuzzle extends Transition
{
	public static var useFrames:Boolean=true;
	public static var persist:Boolean=true;
	public static var dispatch:Boolean=true;
	public static var startNow:Boolean=true;
	
	private var ww=339.2;
	private var hh=294.6;
	
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask000")]
	private var msk000:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask001")]
	private var msk001:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask002")]
	private var msk002:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask003")]
	private var msk003:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask004")]
	private var msk004:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask005")]
	private var msk005:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask006")]
	private var msk006:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask007")]
	private var msk007:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask008")]
	private var msk008:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask009")]
	private var msk009:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask010")]
	private var msk010:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask011")]
	private var msk011:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask012")]
	private var msk012:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask013")]
	private var msk013:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask014")]
	private var msk014:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask015")]
	private var msk015:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask016")]
	private var msk016:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask017")]
	private var msk017:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask018")]
	private var msk018:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask019")]
	private var msk019:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask020")]
	private var msk020:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask021")]
	private var msk021:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask022")]
	private var msk022:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask023")]
	private var msk023:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask024")]
	private var msk024:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask025")]
	private var msk025:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask026")]
	private var msk026:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask027")]
	private var msk027:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask028")]
	private var msk028:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask029")]
	private var msk029:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask030")]
	private var msk030:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask031")]
	private var msk031:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask032")]
	private var msk032:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask033")]
	private var msk033:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask034")]
	private var msk034:Class;
	[Embed(source="assets/puzzle_assets.swf", symbol="theMask035")]
	private var msk035:Class;
	
	private var holder:Sprite,masks:Array,maskho:Array,pos:Array,count:int=0,size:int,pieces0:Array,pieces1:Array,to:Array,tar:DisplayObject;
	
	public function JigsawPuzzle()
	{
		super();
	}
	
	override public function doit(params:Object):void
	{
	var overlap:Number=0.8;
	var ord:String="random";
	var mode:String="random-move";
	
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
		ord=((params.ordering!=null)?params.ordering:ord);
		mode=((params.mode!=null)?params.mode:mode);
	}
	
	var t0:DisplayObject, t1:DisplayObject, duration:Number, eas:Function;
	t0=params.fromTarget;
	t1=params.toTarget;
	duration=params.duration;
	eas=params.easing;
	tar=t1;
	
	var i:int,j:int;
	
	holder=new Sprite();
	addChild(holder);
	
	pos=[];
	masks=[];
	pieces0=[];
	pieces1=[];
	masks[0]=new msk000();
	pos[0]={};
	pos[0].xpos=0;
	pos[0].ypos=0;
	masks[1]=new msk001();
	pos[1]={};
	pos[1].xpos=54;
	pos[1].ypos=0;
	masks[2]=new msk002();
	pos[2]={};
	pos[2].xpos=106;
	pos[2].ypos=0;
	masks[3]=new msk003();
	pos[3]={};
	pos[3].xpos=186;
	pos[3].ypos=0;
	masks[4]=new msk004();
	pos[4]={};
	pos[4].xpos=239;
	pos[4].ypos=0;
	masks[5]=new msk005();
	pos[5]={};
	pos[5].xpos=279.4;
	pos[5].ypos=0;
	masks[6]=new msk006();
	pos[6]={};
	pos[6].xpos=0;
	pos[6].ypos=50.4;
	masks[7]=new msk007();
	pos[7]={};
	pos[7].xpos=54;
	pos[7].ypos=52;
	masks[8]=new msk008();
	pos[8]={};
	pos[8].xpos=118;
	pos[8].ypos=49;
	masks[9]=new msk009();
	pos[9]={};
	pos[9].xpos=178;
	pos[9].ypos=49.5;
	masks[10]=new msk010();
	pos[10]={};
	pos[10].xpos=241.5;
	pos[10].ypos=38;
	masks[11]=new msk011();
	pos[11]={};
	pos[11].xpos=280.4;
	pos[11].ypos=49;
	masks[12]=new msk012();
	pos[12]={};
	pos[12].xpos=0;
	pos[12].ypos=107;
	masks[13]=new msk013();
	pos[13]={};
	pos[13].xpos=40.2;
	pos[13].ypos=104.5;
	masks[14]=new msk014();
	pos[14]={};
	pos[14].xpos=113.3;
	pos[14].ypos=106.7;
	masks[15]=new msk015();
	pos[15]={};
	pos[15].xpos=177.1;
	pos[15].ypos=97.6;
	masks[16]=new msk016();
	pos[16]={};
	pos[16].xpos=233.3;
	pos[16].ypos=102.8;
	masks[17]=new msk017();
	pos[17]={};
	pos[17].xpos=274.1;
	pos[17].ypos=101.5;
	masks[18]=new msk018();
	pos[18]={};
	pos[18].xpos=0;
	pos[18].ypos=147.2;
	masks[19]=new msk019();
	pos[19]={};
	pos[19].xpos=42.4;
	pos[19].ypos=153.5;
	masks[20]=new msk020();
	pos[20]={};
	pos[20].xpos=117.6;
	pos[20].ypos=154.9;
	masks[21]=new msk021();
	pos[21]={};
	pos[21].xpos=174.1;
	pos[21].ypos=140.5;
	masks[22]=new msk022();
	pos[22]={};
	pos[22].xpos=230.6;
	pos[22].ypos=144.7;
	masks[23]=new msk023();
	pos[23]={};
	pos[23].xpos=273.4;
	pos[23].ypos=152;
	masks[24]=new msk024();
	pos[24]={};
	pos[24].xpos=0;
	pos[24].ypos=207.2;
	masks[25]=new msk025();
	pos[25]={};
	pos[25].xpos=53.5;
	pos[25].ypos=192.3;
	masks[26]=new msk026();
	pos[26]={};
	pos[26].xpos=107.3;
	pos[26].ypos=195.8;
	masks[27]=new msk027();
	pos[27]={};
	pos[27].xpos=178.7;
	pos[27].ypos=207.2;
	masks[28]=new msk028();
	pos[28]={};
	pos[28].xpos=226.1;
	pos[28].ypos=194.9;
	masks[29]=new msk029();
	pos[29]={};
	pos[29].xpos=277.6;
	pos[29].ypos=203.0;
	masks[30]=new msk030();
	pos[30]={};
	pos[30].xpos=0;
	pos[30].ypos=248.9;
	masks[31]=new msk031();
	pos[31]={};
	pos[31].xpos=52.3;
	pos[31].ypos=241.8;
	masks[32]=new msk032();
	pos[32]={};
	pos[32].xpos=117.0;
	pos[32].ypos=237.4;
	masks[33]=new msk033();
	pos[33]={};
	pos[33].xpos=184.4;
	pos[33].ypos=247.3;
	masks[34]=new msk034();
	pos[34]={};
	pos[34].xpos=234.5;
	pos[34].ypos=238.6;
	masks[35]=new msk035();
	pos[35]={};
	pos[35].xpos=267.5;
	pos[35].ypos=235.4;
	
	maskho=[];
	var sx=t0.width/ww;
	var sy=t0.height/hh;
	to=[];
	// build them
	for (j=0; j<masks.length ; j++)
	{		
		maskho[j]=new Sprite();
		masks[j].scaleX=sx;
		masks[j].scaleY=sy;
		var xx=pos[j].xpos*sx;
		var yy=pos[j].ypos*sy;
		pieces0[j]=TransitionUtils.drawArea(t0,xx,yy,masks[j].width,masks[j].height);
		pieces1[j]=TransitionUtils.drawArea(t1,xx,yy,masks[j].width,masks[j].height);
		pieces0[j].mask=masks[j];
		maskho[j].addChild(pieces0[j]);
		maskho[j].addChild(masks[j]);
		masks[j].x=-masks[j].width/2;
		masks[j].y=-masks[j].height/2;
		pieces0[j].x=masks[j].x;
		pieces0[j].y=masks[j].y;
		pieces1[j].x=masks[j].x;
		pieces1[j].y=masks[j].y;
		maskho[j].x=xx+masks[j].width/2;
		maskho[j].y=yy+masks[j].height/2;
		holder.addChild(maskho[j]);
		to[j]={t:0.0,i:j,prevt:-1,x:xx+masks[j].width/2,y:yy+masks[j].height/2,rx:2*Math.random()-1,ry:2*Math.random()-1,swap:false};
	}
	
	var ordobj=TransitionUtils.ordering[ord](TransitionUtils.rowsFirst(to,6,6).pieces,6,6);
	to=ordobj.pieces;
	if (overlap>1.0)	overlap=1.0;
	if (overlap<0.0)	overlap=0.0;
	var d:Number=duration/(ordobj.groups-(ordobj.groups-1)*overlap);
	var o:Number=d*overlap;
	count=0;
	size=36;
	
	// animate them
	for (j=0; j<masks.length ; j++)
	{		
		TweenMax.to(to[j], d, {delay:ordobj.delays[j]*(d-o), useFrames:useFrames, immediateRender:startNow, t:0, bezierThrough:[{t:1.0}], ease:eas, onUpdate:render, onUpdateParams:[to[j]], onComplete:doall});
	}
	
	function render(oo:Object):void
	{

		if (oo.t>oo.prevt)
		{
			if (mode=="center-move")
			{
				maskho[oo.i].x=(1-oo.t)*maskho[oo.i].x+oo.t*.5*(t0.width);
				maskho[oo.i].y=(1-oo.t)*maskho[oo.i].y+oo.t*.5*(t0.height);
				maskho[oo.i].scaleX=1+.6*oo.t;
				maskho[oo.i].scaleY=maskho[oo.i].scaleX;
			}
			else if (mode=="swap")
			{
			}
			else if (mode=="rotate")
			{
				maskho[oo.i].scaleX=1-.6*oo.t;
				maskho[oo.i].scaleY=maskho[oo.i].scaleX;
				maskho[oo.i].rotation=720*oo.t;
			}
			else if (mode=="scale")
			{
				maskho[oo.i].scaleX=1-.6*oo.t;
				maskho[oo.i].scaleY=maskho[oo.i].scaleX;
			}
			else
			{
				maskho[oo.i].x+=oo.t*(oo.rx)*20;
				maskho[oo.i].y+=oo.t*(oo.ry)*20;
			}
		}
		else
		{
			if (!oo.swap)
			{
				maskho[oo.i].removeChild(pieces0[oo.i]);
				pieces0[oo.i].mask=null;
				pieces1[oo.i].mask=masks[oo.i];
				maskho[oo.i].addChild(pieces1[oo.i]);
				oo.swap=true;
			}
			if (mode=="center-move")
			{
				maskho[oo.i].x=oo.t*maskho[oo.i].x+(1-oo.t)*oo.x;
				maskho[oo.i].y=oo.t*maskho[oo.i].y+(1-oo.t)*oo.y;
				maskho[oo.i].scaleX=1+.6*oo.t;
				maskho[oo.i].scaleY=maskho[oo.i].scaleX;
			}
			else if (mode=="swap")
			{
			}
			else if (mode=="rotate")
			{
				maskho[oo.i].scaleX=maskho[oo.i].scaleX*oo.t+(1-oo.t);
				maskho[oo.i].scaleY=maskho[oo.i].scaleX;
				maskho[oo.i].rotation=720*oo.t;
			}
			else if (mode=="scale")
			{
				maskho[oo.i].scaleX=maskho[oo.i].scaleX*oo.t+(1-oo.t);
				maskho[oo.i].scaleY=maskho[oo.i].scaleX;
			}
			else
			{
				maskho[oo.i].x=oo.t*maskho[oo.i].x+(1-oo.t)*oo.x;
				maskho[oo.i].y=oo.t*maskho[oo.i].y+(1-oo.t)*oo.y;
			}
		}
		
		oo.prevt=oo.t;
	}
	}
	
	override public function kill():void
	{
		if (holder==null) return;
		for (var i=0;i<size;i++)
		{
			var tweens:Array=TweenMax.getTweensOf(to[i]);
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
			this.removeChild(holder);
			for (var i=0;i<size;i++)
			{
				maskho[i]=null;
				pieces0[i].bitmapData.dispose();
				pieces1[i].bitmapData.dispose();
				pieces0[i]=null;
				pieces1[i]=null;
				masks[i]=null;
				pos[i]=null;
				to[i]=null;
			}
			holder=null;
			if (persist)
			{
				var newt=TransitionUtils.createTiles(tar)[0];
				this.addChild(newt);
			}
			else
			if (dispatch)
			{
				this.dispatchEvent(new Event(eventType));
			}
		}
	}
}
}