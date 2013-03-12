package com.nikos.mytransitions.components
{ 

	import flash.display.*;
	import flash.events.*;
    import flash.utils.*;
	
	import com.nikos.mytransitions.*;
	
	public class FlipTilesComponent extends TransitionComponent	
	{ 
		// The name and variable of each parameter must match!
		// Keep these alphabetised!
		[Inspectable (name = "rows", variable = "rows", type = "Number", defaultValue = "1")]
		[Inspectable (name = "columns", variable = "columns", type = "Number", defaultValue = "1")]
		[Inspectable (name = "overlap", variable = "overlap", type = "Number", defaultValue = ".8")]
		[Inspectable (name = "ordering", variable = "ordering", type = "String", defaultValue = "spiral-top-left")]
		[Inspectable (name = "spin", variable = "spin", type = "String", defaultValue = "horizontal")]
		
		private var _rows:Number=1;
		private var _columns:Number=1;
		private var _overlap:Number=.8;
		private var _ordering:String="spiral-top-left";
		private var _spin:String="horizontal";
		
		public function FlipTilesComponent() 
		{
			super();
		} 
		
		
		public function get rows():Number { return _rows; }
		public function get columns():Number { return _columns; }
		public function get overlap():Number { return _overlap; }
		public function get ordering():String { return _ordering; }
		public function get spin():String { return _spin; }
		
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
		
		public function set spin(value:String):void 
		{
			_spin = value;
		}
		
		override protected function initLater(event:TimerEvent) : void
        {
            trace("initLater");
			init(this.parent[fromTarget], this.parent[toTarget]);
        }// end function
        
		private function init(target1:DisplayObject,target2:DisplayObject):void
		{
			var params={};
            trace("init");
			if (!initSuper(target1, target2))
            {
                trace("ERROR - The parameter \"Start MovieClip\" or \"End MovieClip\" is not defined properly!");
                return;
            }
            this._transition=new FlipTiles();
			FlipTiles.dispatch=true;
			FlipTiles.startNow=true;
			FlipTiles.persist=false;
			FlipTiles.useFrames=useFrames;
			this.addChild(this._transition);
			params.fromTarget=_source_mc;
			params.toTarget=_source2_mc;
			params.duration=duration;
			params.easing=getEasing(easing);
			params.rows=rows;
			params.columns=columns;
			params.spin=spin;
			params.ordering=ordering;
			params.overlap=overlap;
			this._transition.addEventListener(Transition.eventType,kill);
			this._transition.doit(params);
		}
	}
}
