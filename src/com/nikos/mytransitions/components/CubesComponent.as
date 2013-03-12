package com.nikos.mytransitions.components
{ 

	import flash.display.*;
	import flash.events.*;
    import flash.utils.*;
	
	import com.nikos.mytransitions.*;
	
	public class CubesComponent extends TransitionComponent	
	{ 
		// The name and variable of each parameter must match!
		// Keep these alphabetised!
		[Inspectable (name = "slices", variable = "slices", type = "Number", defaultValue = "1")]
		[Inspectable (name = "overlap", variable = "overlap", type = "Number", defaultValue = ".8")]
		[Inspectable (name = "ordering", variable = "ordering", type = "String", defaultValue = "columns-first")]
		[Inspectable (name = "slicing", variable = "slicing", type = "String", defaultValue = "horizontal")]
		[Inspectable (name = "direction", variable = "direction", type = "String", defaultValue = "right")]
		[Inspectable (name = "direction_mode", variable = "direction_mode", type = "String", defaultValue = "none")]
		
		private var _slices:Number=1;
		private var _overlap:Number=.8;
		private var _ordering:String="spiral-top-left";
		private var _slicing:String="horizontal";
		private var _direction:String="right";
		private var _direction_mode:String="none";
		
		public function CubesComponent() 
		{
			super();
		} 
		
		
		public function get slices():Number { return _slices; }
		public function get overlap():Number { return _overlap; }
		public function get ordering():String { return _ordering; }
		public function get slicing():String { return _slicing; }
		public function get direction():String { return _direction; }
		public function get direction_mode():String { return _direction_mode; }
		
		public function set overlap(value:Number):void 
		{
			_overlap = value;
		}
		
		public function set slices(value:Number):void 
		{
			_slices = value;
		}
		
		public function set ordering(value:String):void 
		{
			_ordering = value;
		}
		
		public function set slicing(value:String):void 
		{
			_slicing = value;
		}
		
		public function set direction(value:String):void 
		{
			_direction = value;
		}
		
		public function set direction_mode(value:String):void 
		{
			_direction_mode = value;
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
				this._transition=new Cubes();
				Cubes.dispatch=true;
				Cubes.startNow=true;
				Cubes.persist=true;
				Cubes.useFrames=useFrames;
				this.addChild(this._transition);
				params.fromTarget=_source_mc;
				params.toTarget=_source2_mc;
				params.duration=duration;
				params.easing=getEasing(easing);
				params.slices=slices;
				params.slicing=slicing;
				params.direction=direction;
				params.direction_mode=direction_mode;
				params.ordering=ordering;
				params.overlap=overlap;
				this._transition.addEventListener(Transition.eventType,showTarget);
				this._transition.doit(params);
			}
		}
	}
}
