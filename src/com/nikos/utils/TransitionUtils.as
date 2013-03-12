package com.nikos.utils
{
import flash.display.*;
import flash.geom.*;
import flash.events.*;
import fl.transitions.*;
import fl.transitions.easing.*;
import fl.motion.easing.*;
import flash.filters.*;
import flash.utils.*;

public class TransitionUtils
{
	/*public static function copyData(source:Object, destination:Object):void 
	{
		//copies data from commonly named properties and getter/setter pairs
		if((source) && (destination))
		{
			try 
			{
				var sourceInfo:XML = describeType(source);
				var prop:XML;
	 
				for each(prop in sourceInfo.variable) 
				{
	 
					if(destination.hasOwnProperty(prop.@name)) 
					{
						destination[prop.@name] = source[prop.@name];
					}
				}
	 
				for each(prop in sourceInfo.accessor) 
				{
					if(prop.@access == "readwrite") 
					{
						if(destination.hasOwnProperty(prop.@name)) 
						{
							destination[prop.@name] = source[prop.@name];
						}
					}
				}
			}
			catch (err:Object) 
			{
			}
		}
	}

	public static function cloneobj(o:Object):Object
	{
		if(o) 
		{
			var objSibling:*;
			try 
			{
				var classOfSourceObj:Class = getDefinitionByName(getQualifiedClassName(o)) as Class;
				objSibling = new classOfSourceObj();
			}
			catch(e:Object) {}
		
			if(objSibling) 
			{
				copyData(o, objSibling);
			}
			return(objSibling);
		}
		return(null);
	}
	
	public static function segmentm(target:DisplayObject,numofstrips:Number):Array
	{
		var pieces = [];
		var co:DisplayObject;
		var msk:Shape;
		var o:Object;
		
		for (var i=0; i< numofstrips; i++) 
		{
			co = cloneobj(target) as DisplayObject;
			var msk = new Shape();
			msk.x = co.x + i*co.width/numofstrips;
			msk.graphics.beginFill(0,100);
			msk.graphics.drawRect(-4,0,kMaskWidth+8,stage.stageHeight);
			msk.graphics.endFill();
			co.mask = msk;
			pieces[i] = co;
		}
		return()
	}
	*/
	
	/*public static function applyImageFilter(image:BitmapData,filter:Function)
	{
		var p:Point;
		var filterp:Point;
		var col:int;
		for (var i=0;i<image.width;i++)
		{
			 for (var j=0;j<image.height;j++)
			 {
				p=new Point(i,j);
				filterp=filter(p);
				image.setPixel32(i,j,image.getPixel32(filterp.x,filterp.y));
			 }
		}
	}*/
	
	public static function drawArea(target:DisplayObject,x:Number,y:Number,w:Number,h:Number)
	{
		var bmd=new BitmapData(w,h,true,0);
		var mat=new Matrix(1, 0, 0, 1, -x, -y);
		bmd.draw(target, mat, new ColorTransform(), BlendMode.NORMAL, new Rectangle(0,0,w,h), false);
		return(new Bitmap(bmd));
	}
	
	public static function createTiles(target:DisplayObject,rows:uint=1,columns:uint=1):Array
	{
		if (target==null) return(null);
		columns=Math.max(1,columns);
		rows=Math.max(1,rows);
		if (columns==target.width && rows==target.height)
		{
			columns=Math.round(0.5*columns);
			rows=Math.round(0.5*rows);
		}
		var w=Math.round(target.width/columns);
		var h=Math.round(target.height/rows);
		var px=0;
		var py=0;

		var pieces:Array = []; //array to store references to each piece
		for (var i=0;i<columns; i++)
		{
			for (var j=0; j<rows; j++)
			{
				var nw=w;
				var nh=h;
				if (px+w>target.width) nw=target.width-px;
				if (py+h>target.height) nh=target.height-py;
				var bmpdata:BitmapData = new BitmapData(w, h, true,0x000000); // allow transparency
				bmpdata.draw(target, new Matrix(1, 0, 0, 1, -px, -py), new ColorTransform(), BlendMode.NORMAL, new Rectangle(0,0,w,h), false); // works fine
				var bmp:Bitmap = new Bitmap(bmpdata);
				bmp.x = px;
				bmp.y = py;
				pieces[i*rows+j]=bmp;
				py+=nh;
			}
			py=0;
			px+=nw;
		}
		return(pieces);
	}
	
	public static function destroyTiles(pieces:Array)
	{
		if (pieces!=null)
		{
			for (var i=0;i<pieces.length;i++)
			{
				pieces[i].parent.removeChild(pieces[i]);
				pieces[i].bitmapData.dispose();
				pieces[i]=null;
			}
			pieces=null;
		}
		return(pieces);
	}

	public static function linearArray(howmany:int):Array
	{
		var a:Array=[];
		for (var i=0;i<howmany;i++)
			a[i]=i;
		return(a);
	}
	
	public static function columnsFirst(pieces:Array,rows:uint,columns:uint):Object
	{
		return({pieces:pieces, delays:linearArray(pieces.length), groups:pieces.length});
	}
	
	public static function columnsFirstReverse(pieces:Array,rows:uint,columns:uint):Object
	{
		return({pieces:pieces.reverse(), delays:linearArray(pieces.length), groups:pieces.length});
	}
	
	public static function rowsFirst(pieces:Array,rows:uint,columns:uint):Object
	{
		var newpieces:Array=[];
		
		for (var i=0; i<rows; i++)
		{
			for (var j=0;j<columns;j++)
			{
				newpieces[i*columns+j]=pieces[j*rows+i];
			}
		}
		return({pieces:newpieces, delays:linearArray(pieces.length), groups:pieces.length});
	}
	
	public static function rowsFirstReverse(pieces:Array,rows:uint,columns:uint):Object
	{
		var obj=rowsFirst(pieces,rows,columns);
		return({pieces:obj.pieces.reverse(), delays:obj.delays, groups:pieces.length});
	}
	
	public static function spiral(pieces:Array,rows:uint,columns:uint,type:int):Object
	{
		var temp:Array=[];
		var i:int=0;
		var j:int=0;
		var order:Array=[0,1,2,3];
		var min_i:int=0;
		var min_j:int=0;
		var max_i:int=rows-1;
		var max_j:int=columns-1;
		var dir:int=1;
		var mode:int=0;
		var inc:Boolean=true;
		
		switch(type%4)
		{
			case 1: i=min_i;
					j=max_j;
					order=[2,1,0,3];
					dir=-1;
					break;
			case 2: i=max_i;
					j=min_j;
					order=[0,3,2,1];
					dir=-1;
					break;
			case 3: i=max_i;
					j=max_j;
					order=[2,3,0,1];
					dir=1;
					break;
			default: i=min_i;
					j=min_j;
					order=[0,1,2,3]; // 0=>,  1=\/, 2=<, 3=/\
					dir=1;
					break;
		}
		while ((max_i>=min_i) && (max_j>=min_j))
		{
			if (inc)
			{
				temp.push(pieces[j*rows+i]);
			}
			inc=true;
			switch (order[mode]) 
			{
			case 0:	// left to right
				if (j>=max_j)
				{
					mode=(mode+1)%4;
					inc=false;
					if (dir==1)
						min_i++;
					else
						max_i--;
				}
				else
					j++;
				break;
			case 1: // top to bottom 
				if (i>=max_i)
				{
					mode=(mode+1)%4;
					inc=false;
					if (dir==1)
						max_j--;
					else
						min_j++;
				}
				else
					i++;
				break;
			case 2:	// right to left 
				if (j<=min_j)
				{
					mode=(mode+1)%4;
					inc=false;
					if (dir==1)
						max_i--;
					else
						min_i++;
				}
				else
					j--;
				break;
			case 3:  // bottom to top
				if (i<=min_i)
				{
					mode=(mode+1)%4;
					inc=false;
					if (dir==1)
						min_j++;
					else
						max_j--;
				}
				else
					i--;
				break;
			}
		}
		if (type>=4) temp.reverse();
		return({pieces:temp, delays:linearArray(temp.length), groups:temp.length});
	}
				
	public static function spiralTopLeft(pieces:Array,rows:uint,columns:uint):Object
	{
		return(spiral(pieces,rows,columns,0));
	}
	
	public static function spiralTopRight(pieces:Array,rows:uint,columns:uint):Object
	{
		return(spiral(pieces,rows,columns,1));
	}
	
	public static function spiralBottomLeft(pieces:Array,rows:uint,columns:uint):Object
	{
		return(spiral(pieces,rows,columns,2));
	}
	
	public static function spiralBottomRight(pieces:Array,rows:uint,columns:uint):Object
	{
		return(spiral(pieces,rows,columns,3));
	}
	
	public static function spiralTopLeftRev(pieces:Array,rows:uint,columns:uint):Object
	{
		return(spiral(pieces,rows,columns,4));
	}
	
	public static function spiralTopRightRev(pieces:Array,rows:uint,columns:uint):Object
	{
		return(spiral(pieces,rows,columns,5));
	}
	
	public static function spiralBottomLeftRev(pieces:Array,rows:uint,columns:uint):Object
	{
		return(spiral(pieces,rows,columns,6));
	}
	
	public static function spiralBottomRightRev(pieces,rows,columns):Object
	{
		return(spiral(pieces,rows,columns,7));
	}
	
	public static function upDown(pieces:Array,rows:uint,columns:uint):Object
	{
		var newpieces:Array=[];
		var odd:Boolean=false;
		for (var i=0;i<columns;i++)
		{
			for (var j=0;j<rows;j++)
			{
				if (!odd)
				newpieces[i*rows+j]=pieces[i*rows+j];
				else
				newpieces[i*rows+j]=pieces[(i)*rows+rows-1-j];
			}
			odd=!odd;
		}
		return({pieces:newpieces, delays:linearArray(pieces.length), groups:pieces.length});
	}
	
	public static function rows(pieces:Array,rowsi:uint,columnsi:uint):Object
	{
		var delays=[];
		for (var i=0;i<columnsi;i++)
		{
			for (var j=0;j<rowsi;j++)
			{
				delays[i*rowsi+j]=j;
			}
		}
		return({pieces:pieces, delays:delays, groups:rowsi});
	}
	
	public static function rowsReverse(pieces:Array,rowsi:uint,columnsi:uint):Object
	{
		var delays=[];
		for (var i=0;i<columnsi;i++)
		{
			for (var j=0;j<rowsi;j++)
			{
				delays[i*rowsi+j]=rowsi-1-j;
			}
		}
		return({pieces:pieces, delays:delays, groups:rowsi});
	}
	
	public static function columns(pieces:Array,rowsi:uint,columnsi:uint):Object
	{
		var delays=[];
		for (var i=0;i<columnsi;i++)
		{
			for (var j=0;j<rowsi;j++)
			{
				delays[i*rowsi+j]=i;
			}
		}
		return({pieces:pieces, delays:delays, groups:columnsi});
	}
	
	public static function columnsReverse(pieces:Array,rowsi:uint,columnsi:uint):Object
	{
		var delays=[];
		for (var i=0;i<columnsi;i++)
		{
			for (var j=0;j<rowsi;j++)
			{
				delays[i*rowsi+j]=columnsi-1-i;
			}
		}
		return({pieces:pieces, delays:delays, groups:columnsi});
	}
	
	public static function upDownReverse(pieces:Array,rows:uint,columns:uint):Object
	{
		var obj=upDown(pieces,rows,columns);
		return({pieces:obj.pieces.reverse(), delays:obj.delays, groups:pieces.length});
	}
	
	public static function leftRight(pieces,rows,columns):Object
	{
		var newpieces:Array=[];
		var odd:Boolean=false;
		for (var i=0;i<rows;i++)
		{
			for (var j=0;j<columns;j++)
			{
				if (!odd)
				newpieces[i*columns+j]=pieces[j*rows+i];
				else
				newpieces[i*columns+j]=pieces[(columns-1-j)*rows+i];
			}
			odd=!odd;
		}
		return({pieces:newpieces, delays:linearArray(pieces.length), groups:pieces.length});
	}
	
	public static function leftRightReverse(pieces:Array,rows:uint,columns:uint):Object
	{
		var obj=leftRight(pieces,rows,columns);
		return({pieces:obj.pieces.reverse(), delays:obj.delays, groups:pieces.length});
	}
	
	public static function random(pieces:Array,rows:uint,columns:uint):Object
	{ //v1.0
		for(var j, x, i = pieces.length; i; j = Math.floor(Math.random() * i), x = pieces[--i], pieces[i] = pieces[j], pieces[j] = x);
		return ({pieces:pieces, delays:linearArray(pieces.length), groups:pieces.length});
	}
	
	public static function diagonalTopLeft(pieces:Array,rows:uint,columns:uint):Object
	{ 	
		var delays=[];
		for (var i=0;i<columns;i++)
		{
			for (var j=0;j<rows;j++)
			{
				delays[i*rows+j]=(i+j);
			}
		}
		return ({pieces:pieces, delays:delays, groups:rows+columns-1});
	}
	
	public static function diagonalBottomRight(pieces:Array,rows:uint,columns:uint):Object
	{ 	
		var delays=[];
		for (var i=0;i<columns;i++)
		{
			for (var j=0;j<rows;j++)
			{
				delays[i*rows+j]=(columns-1-i+rows-1-j);
			}
		}
		return ({pieces:pieces, delays:delays, groups:rows+columns-1});
	}
	
	public static function diagonalBottomLeft(pieces:Array,rows:uint,columns:uint):Object
	{ 	
		var delays=[];
		for (var i=0;i<columns;i++)
		{
			for (var j=0;j<rows;j++)
			{
				delays[i*rows+j]=(i+rows-1-j);
			}
		}
		return ({pieces:pieces, delays:delays, groups:rows+columns-1});
	}
	
	public static function diagonalTopRight(pieces:Array,rows:uint,columns:uint):Object
	{ 	
		var delays=[];
		for (var i=0;i<columns;i++)
		{
			for (var j=0;j<rows;j++)
			{
				delays[i*rows+j]=(columns-1-i+j);
			}
		}
		return ({pieces:pieces, delays:delays, groups:rows+columns-1});
	}
	
	public static function checkerBoard(pieces:Array,rows:uint,columns:uint):Object
	{ 	
		var delays=[];
		var odd1:Boolean=false,odd2:Boolean;
		for (var i=0;i<columns;i++)
		{
			odd2=odd1;
			for (var j=0;j<rows;j++)
			{
				delays[i*rows+j]=(odd2)?1:0;
				odd2=!odd2;
			}
			odd1=!odd1;
		}
		return ({pieces:pieces, delays:delays, groups:2});
	}
	
	public static var ordering={
		"checkerboard":checkerBoard,
		"diagonal-top-left":diagonalTopLeft,
		"diagonal-top-right":diagonalTopRight,
		"diagonal-bottom-left":diagonalBottomLeft,
		"diagonal-bottom-right":diagonalBottomRight,
		"rows":rows,
		"rows-reverse":rowsReverse,
		"columns":columns,
		"columns-reverse":columnsReverse,
		"rows-first":rowsFirst,
		"rows-first-reverse":rowsFirstReverse,
		"columns-first":columnsFirst,
		"columns-first-reverse":columnsFirstReverse,
		"spiral-top-left":spiralTopLeft,
		"spiral-top-right":spiralTopRight,
		"spiral-bottom-left":spiralBottomLeft,
		"spiral-bottom-right":spiralBottomRight,
		"spiral-top-left-reverse":spiralTopLeftRev,
		"spiral-top-right-reverse":spiralTopRightRev,
		"spiral-bottom-left-reverse":spiralBottomLeftRev,
		"spiral-bottom-right-reverse":spiralBottomRightRev,
		"random":random,
		"up-down":upDown,
		"up-down-reverse":upDownReverse,
		"left-right":leftRight,
		"left-right-reverse":leftRightReverse
	};
}
}