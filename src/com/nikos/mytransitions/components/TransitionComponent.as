package com.nikos.mytransitions.components
{ 

	import flash.display.*;
	import flash.events.*;
    import flash.utils.*;
	import adobe.utils.*;
	
	import com.nikos.mytransitions.*;
	import fl.transitions.easing.*;
	
	public class TransitionComponent extends MovieClip	
	{ 
		// The name and variable of each parameter must match!
		// Keep these alphabetised!
		[Inspectable (name = "fromTarget", variable = "fromTarget", type = "String", defaultValue = "")]
		[Inspectable (name = "toTarget", variable = "toTarget", type = "String", defaultValue = "")]
		[Inspectable (name = "duration", variable = "duration", type = "Number", defaultValue = "1")]
		[Inspectable (name = "useFrames", variable = "useFrames", type = "Boolean", defaultValue = true)]
		[Inspectable (name = "easing", variable = "easing", type = "String", defaultValue = "None")]
		[Inspectable (name = "posx", variable = "posx", type = "Number", defaultValue = "0" )]
		[Inspectable (name = "posy", variable = "posy", type = "Number", defaultValue = "0")]
		
		protected var _toTarget:String="";
		protected var _fromTarget:String="";
		protected var _duration:Number=1;
		protected var _easing:String="None";
		protected var _useFrames:Boolean=true;
		protected var easingf:Array=[];
		protected var _transition:Transition=null;
        protected var _source_mc:DisplayObject;
        protected var _source2_mc:DisplayObject;
        
		public var posx:Number=0;
		public var posy:Number=0;
		//public var jsflGetInstances:String="";
		//public var jsflGetXY:String="";
		
        private var _waitTimer:Timer;
        public var _logo_mc:MovieClip;
		
		public function TransitionComponent() 
		{
			//trace("Constructor");
			if (this.parent==null) return;
			if (this.parent!=null && getQualifiedClassName(this.parent) != "fl.livepreview::LivePreviewParent")
			{
				_logo_mc.visible = false;
			}
			
			// expose jsfl utility function commands from here (AS3 multiline heredoc utility)
			/*var jsfl1:* = <jsfl>
			<![CDATA[
				function getInstancesInCurrentFrame(FILTER_LIBRARY_NAME){

					var elementList = new Array();
					var positionList=new Array();
					var t = fl.getDocumentDOM().getTimeline();
					var layer = t.layers.length;
					
					if(t.getSelectedFrames().length == 0){
						currentFrame = 0;
					}else{
						var currentFrame = Number(t.getSelectedFrames()[1]);
					}
					
					for(var i = 0; i < layer; i++){
						
						if(t.layers[i].frames[currentFrame] == undefined){
							continue;
						}
						
						var element_num = t.layers[i].frames[currentFrame].elements.length;
						
						for(var j = 0; j < element_num; j++){
							if(t.layers[i].frames[currentFrame].elements[j].elementType != "instance") continue;
							if(t.layers[i].frames[currentFrame].elements[j].libraryItem.itemType == "movie clip" &&
								t.layers[i].frames[currentFrame].elements[j].name == ""){
								t.layers[i].frames[currentFrame].elements[j].name="target_f"+currentFrame+"l"+i+"e"+j;
							}
							if(t.layers[i].frames[currentFrame].elements[j].libraryItem.itemType == "movie clip" &&
								t.layers[i].frames[currentFrame].elements[j].name != ""){
								elementList.push(t.layers[i].frames[currentFrame].elements[j].name);
								positionList.push(t.layers[i].frames[currentFrame].elements[j].left+"*"+t.layers[i].frames[currentFrame].elements[j].top+"*"+t.layers[i].frames[currentFrame].elements[j].width+"*"+t.layers[i].frames[currentFrame].elements[j].height);
							}
						}
					
					}
					
					return elementList.join(",")+"|"+positionList.join("&");
				}
			]]>	
			 </jsfl>;
			jsflGetInstances=jsfl1.toString();
			var jsfl2:* = <jsfl>
			<![CDATA[
				function getXY()
				{
					var doc=fl.getDocumentDOM();
					if (!doc) return("false");
					if (doc.selection.length>0)
					{
						if (doc.selection[0] && doc.selection[0]!=null)
							return(doc.selection[0].left+","+doc.selection[0].top);
					}
					return("false");
				}
			]]>	
			 </jsfl>;
			jsflGetXY=jsfl2.toString();
			*/
			addEventListener(Event.REMOVED_FROM_STAGE, kill);
			_waitTimer = new Timer(2, 1);
			_waitTimer.addEventListener(TimerEvent.TIMER, initLater);
			_waitTimer.start();
            return;
		} 
		
		
        public function setSize(w:Number,h:Number):void
		{
			return;
		}
		
		public function onResize(param1:Number, param2:Number) : void
        {
            return;
        }// end function

        public function onUpdate(... args) : void
        {
            trace("update");
			return;
        }// end function
		
		public function get fromTarget():String { return _fromTarget; }
		public function get toTarget():String { return _toTarget; }
		public function get easing():String { return _easing; }
		public function get duration():Number { return _duration; }
		public function get useFrames():Boolean { return _useFrames; }
		
		public function set fromTarget(value:String):void 
		{
             //   trace("set from");
			_fromTarget = value;
			/*if (this.parent!=null && this.parent[fromTarget]!=null)
			{
				var rect = this.parent[fromTarget].getBounds(this.parent);
				this.x = rect.x;
				this.y = rect.y;
			}*/
		}
		
		public function set toTarget(value:String):void 
		{
               // trace("set to");
			_toTarget = value;
		}
		
		public function set duration(value:Number):void 
		{
               // trace("set dur");
			_duration = value;
		}
		
		public function set useFrames(value:Boolean):void 
		{
               // trace("set frames");
			_useFrames = value;
		}
		
		public function set easing(value:String):void 
		{
               // trace("set eas");
			_easing = value;
		}
		
        protected function initLater(event:TimerEvent) : void
        {
            return;
        }// end function
        
		protected function getEasing(eas:String):Function
		{
			// include some easing functions
			easingf["None"]=None.easeNone;
			easingf["None.easeIn"]=None.easeIn;
			easingf["None.easeOut"]=None.easeOut;
			easingf["None.easeInOut"]=None.easeInOut;
			easingf["Back.easeIn"]=Back.easeIn;
			easingf["Back.easeOut"]=Back.easeOut;
			easingf["Back.easeInOut"]=Back.easeInOut;
			easingf["Bounce.easeIn"]=Bounce.easeIn;
			easingf["Bounce.easeOut"]=Bounce.easeOut;
			easingf["Bounce.easeInOut"]=Bounce.easeInOut;
			easingf["Elastic.easeIn"]=Elastic.easeIn;
			easingf["Elastic.easeOut"]=Elastic.easeOut;
			easingf["Elastic.easeInOut"]=Elastic.easeInOut;
			easingf["Regular.easeIn"]=Regular.easeIn;
			easingf["Regular.easeOut"]=Regular.easeOut;
			easingf["Regular.easeInOut"]=Regular.easeInOut;
			easingf["Strong.easeIn"]=Strong.easeIn;
			easingf["Strong.easeOut"]=Strong.easeOut;
			easingf["Strong.easeInOut"]=Strong.easeInOut;
			
			if (easingf[eas]!=null)
				return(easingf[eas]);
			return(None.easeNone);
		}
		
		protected function initSuper(target1:DisplayObject,target2:DisplayObject) : Boolean
        {
            //trace("initSuper");
			if (target1==null || !(target1 is DisplayObject))
            {
                return false;
            }
			if (target2==null || !(target2 is DisplayObject))
            {
                return false;
            }
            _source_mc = target1;
            _source2_mc = target2;
            var rect = _source_mc.getBounds(this.parent);
            this.x = rect.x;
            this.y = rect.y;
            //this.addChild(_transition);
            _source_mc.visible = false;
			_source2_mc.visible = false;
            _logo_mc.visible = false;
            return true;
        }// end function
        
		protected function kill(e:Event=null) : void
        {
            if (_transition!=null)
			{
				_transition.kill();
				this.removeChild(_transition);
				_transition=null;
			}
            /*try{
			if (this.parent!=null && this.parent.contains(this))
				this.parent.removeChild(this);
			}catch (e){}*/
            showTarget();
        }// end function

        protected function showTarget(event:Event = null) : void
        {
			if (_source_mc != null)
				_source_mc.visible = true;
            if (_source2_mc != null)
                _source2_mc.visible = true;
        }// end function
	}
}
