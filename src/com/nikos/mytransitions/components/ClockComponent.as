package com.nikos.mytransitions.components
{ 

	import flash.display.*;
	import flash.events.*;
    import flash.utils.*;
	
	import com.nikos.mytransitions.*;
	
	public class ClockComponent extends TransitionComponent	
	{ 
		// The name and variable of each parameter must match!
		// Keep these alphabetised!
		[Inspectable (name = "segments", variable = "segments", type = "Number", defaultValue = "1")]
		[Inspectable (name = "start_angle", variable = "start_angle", type = "Number", defaultValue = "0")]
		[Inspectable (name = "clockwise", variable = "clockwise", type = "Boolean", defaultValue = false)]
		
		private var _segments:Number=1;
		private var _start_angle:Number=0;
		private var _clockwise:Boolean=false;
		
		public function ClockComponent() 
		{
			super();
		} 
		
		
		public function get segments():Number { return _segments; }
		public function get start_angle():Number { return _start_angle; }
		public function get clockwise():Boolean { return _clockwise; }
		
		public function set segments(value:Number):void 
		{
			_segments = value;
		}
		
		public function set start_angle(value:Number):void 
		{
			_start_angle = value;
		}
		
		public function set clockwise(value:Boolean):void 
		{
			_clockwise = value;
		}
		
		
		override protected function initLater(event:TimerEvent) : void
        {
            //trace("initLater");
			init(this.parent[fromTarget], this.parent[toTarget]);
        }// end function
        
		private function init(target1:DisplayObject,target2:DisplayObject):void
		{
			var params={};
            //trace("init");
			if (!initSuper(target1, target2))
            {
                trace("ERROR - The parameter \"Start MovieClip\" or \"End MovieClip\" is not defined properly!");
                return;
            }
			if (this.parent!=null && getQualifiedClassName(this.parent) != "fl.livepreview::LivePreviewParent")
			{
				this._transition=new Clock();
				Clock.dispatch=true;
				Clock.startNow=true;
				Clock.persist=true;
				Clock.useFrames=useFrames;
				this.addChild(this._transition);
				params.fromTarget=_source_mc;
				params.toTarget=_source2_mc;
				params.duration=duration;
				params.easing=getEasing(easing);
				params.segments=segments;
				params.start_angle=start_angle;
				params.clockwise=clockwise;
				this._transition.addEventListener(Transition.eventType,showTarget);
				this._transition.doit(params);
			}
		}
	}
}
