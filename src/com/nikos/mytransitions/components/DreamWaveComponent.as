package com.nikos.mytransitions.components
{ 

	import flash.display.*;
	import flash.events.*;
    import flash.utils.*;
	
	import com.nikos.mytransitions.*;
	
	public class DreamWaveComponent extends TransitionComponent	
	{ 
		// The name and variable of each parameter must match!
		// Keep these alphabetised!
		[Inspectable (name = "speedx", variable = "speedx", type = "Number", defaultValue = "20")]
		[Inspectable (name = "speedy", variable = "speedy", type = "Number", defaultValue = "20")]
		[Inspectable (name = "maxx", variable = "maxx", type = "Number", defaultValue = "20")]
		[Inspectable (name = "maxy", variable = "maxy", type = "Number", defaultValue = "20")]
		
		private var _speedx:Number=20;
		private var _speedy:Number=20;
		private var _maxx:Number=20;
		private var _maxy:Number=20;
		
		public function DreamWaveComponent() 
		{
			super();
		} 
		
		
		public function get speedx():Number { return _speedx; }
		public function get speedy():Number { return _speedy; }
		public function get maxx():Number { return _maxx; }
		public function get maxy():Number { return _maxy; }
		
		public function set speedx(value:Number):void 
		{
			_speedx = value;
		}
		
		public function set speedy(value:Number):void 
		{
			_speedy = value;
		}
		
		public function set maxx(value:Number):void 
		{
			_maxx = value;
		}
		
		public function set maxy(value:Number):void 
		{
			_maxy = value;
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
				this._transition=new DreamWave();
				DreamWave.dispatch=true;
				DreamWave.startNow=true;
				DreamWave.persist=true;
				DreamWave.useFrames=useFrames;
				this.addChild(this._transition);
				params.fromTarget=_source_mc;
				params.toTarget=_source2_mc;
				params.duration=duration;
				params.easing=getEasing(easing);
				params.speedx=speedx;
				params.speedy=speedy;
				params.maxx=maxx;
				params.maxy=maxy;
				this._transition.addEventListener(Transition.eventType,showTarget);
				this._transition.doit(params);
			}
		}
	}
}
