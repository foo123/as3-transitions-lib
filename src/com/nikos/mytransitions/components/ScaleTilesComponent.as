package com.nikos.mytransitions.components
{ 

	import flash.display.*;
	import flash.events.*;
    import flash.utils.*;
	
	import com.nikos.mytransitions.*;
	
	public class ScaleTilesComponent extends TransitionComponent	
	{ 
		// The name and variable of each parameter must match!
		// Keep these alphabetised!
		[Inspectable (name = "rows", variable = "rows", type = "Number", defaultValue = "1")]
		[Inspectable (name = "columns", variable = "columns", type = "Number", defaultValue = "1")]
		[Inspectable (name = "overlap", variable = "overlap", type = "Number", defaultValue = ".8")]
		[Inspectable (name = "ordering", variable = "ordering", type = "String", defaultValue = "left-right")]
		[Inspectable (name = "rotate", variable = "rotate", type = "Boolean", defaultValue = true)]
		[Inspectable (name = "reverse", variable = "reverse", type = "Boolean", defaultValue = false)]
		
		private var _rows:Number=1;
		private var _columns:Number=1;
		private var _overlap:Number=.8;
		private var _ordering:String="left-right";
		private var _rotate:Boolean=true;
		private var _reverse:Boolean=false;
		
		public function ScaleTilesComponent() 
		{
			super();
		} 
		
		
		public function get rows():Number { return _rows; }
		public function get columns():Number { return _columns; }
		public function get overlap():Number { return _overlap; }
		public function get ordering():String { return _ordering; }
		public function get rotate():Boolean { return _rotate; }
		public function get reverse():Boolean { return _reverse; }
		
		public function set overlap(value:Number):void 
		{
			_overlap = value;
		}
		
		public function set rows(value:Number):void 
		{
			_rows = value;
		}
		
		public function set columns(value:Number):void 
		{
			_columns = value;
		}
		
		public function set ordering(value:String):void 
		{
			_ordering = value;
		}
		
		public function set rotate(value:Boolean):void 
		{
			_rotate = value;
		}
		
		public function set reverse(value:Boolean):void 
		{
			_reverse = value;
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
				this._transition=new ScaleTiles();
				ScaleTiles.dispatch=true;
				ScaleTiles.startNow=true;
				ScaleTiles.persist=true;
				ScaleTiles.useFrames=useFrames;
				this.addChild(this._transition);
				params.fromTarget=_source_mc;
				params.toTarget=_source2_mc;
				params.duration=duration;
				params.easing=getEasing(easing);
				params.rows=rows;
				params.columns=columns;
				params.rotate=rotate;
				params.reverse=reverse;
				params.ordering=ordering;
				params.overlap=overlap;
				this._transition.addEventListener(Transition.eventType,showTarget);
				this._transition.doit(params);
			}
		}
	}
}
