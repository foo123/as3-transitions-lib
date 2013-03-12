package com.nikos.mytransitions.components
{ 

	import flash.display.*;
	import flash.events.*;
    import flash.utils.*;
	
	import com.nikos.mytransitions.*;
	
	public class JigsawPuzzleComponent extends TransitionComponent	
	{ 
		// The name and variable of each parameter must match!
		// Keep these alphabetised!
		[Inspectable (name = "ordering", variable = "ordering", type = "String", defaultValue = "random")]
		[Inspectable (name = "overlap", variable = "overlap", type = "Number", defaultValue = "0.8")]
		[Inspectable (name = "mode", variable = "mode", type = "String", defaultValue = "random-move")]
		
		private var _ordering:String="random";
		private var _overlap:Number=.8;
		private var _mode:String="random-move";
		
		public function JigsawPuzzleComponent() 
		{
			super();
		} 
		
		
		public function get ordering():String { return _ordering; }
		public function get overlap():Number { return _overlap; }
		public function get mode():String { return _mode; }
		
		public function set ordering(value:String):void 
		{
			_ordering = value;
		}
		
		public function set overlap(value:Number):void 
		{
			_overlap = value;
		}
		
		public function set mode(value:String):void 
		{
			_mode = value;
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
				this._transition=new JigsawPuzzle();
				JigsawPuzzle.dispatch=true;
				JigsawPuzzle.startNow=true;
				JigsawPuzzle.persist=true;
				JigsawPuzzle.useFrames=useFrames;
				this.addChild(this._transition);
				params.fromTarget=_source_mc;
				params.toTarget=_source2_mc;
				params.duration=duration;
				params.easing=getEasing(easing);
				params.ordering=ordering;
				params.overlap=overlap;
				params.mode=mode;
				this._transition.addEventListener(Transition.eventType,showTarget);
				this._transition.doit(params);
			}
		}
	}
}
