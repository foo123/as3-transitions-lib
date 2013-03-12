package com.nikos.mytransitions
{
import flash.display.*;
import flash.events.*;

public class Transition extends Sprite
{
	public static var useFramesGlobal:Boolean=true;
	public static var persistGlobal:Boolean=true;
	public static var dispatchGlobal:Boolean=true;
	public static const eventType:String="TR_Transition_Complete_Event!";
	public static var useGlobal:Boolean=false;
	public static var startNowGlobal:Boolean=true;
	
	public function Transition()
	{
		super();
	}
	
	public function doit(params:Object):void
	{
		// subclasses override this
	}
	
	public function kill():void
	{
		// subclasses override this
	}
}
}