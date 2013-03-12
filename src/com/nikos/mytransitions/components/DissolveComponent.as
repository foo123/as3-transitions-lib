package com.nikos.mytransitions.components
{ 

	import flash.display.*;
	import flash.events.*;
    import flash.utils.*;
	
	import com.nikos.mytransitions.*;
	
	public class DissolveComponent extends TransitionComponent	
	{ 
		
		public function DissolveComponent() 
		{
			super();
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
				this._transition=new Dissolve();
				Dissolve.dispatch=true;
				Dissolve.startNow=true;
				Dissolve.persist=true;
				Dissolve.useFrames=useFrames;
				this.addChild(this._transition);
				params.fromTarget=_source_mc;
				params.toTarget=_source2_mc;
				params.duration=duration;
				params.easing=getEasing(easing);
				this._transition.addEventListener(Transition.eventType,showTarget);
				this._transition.doit(params);
			}
		}
	}
}
