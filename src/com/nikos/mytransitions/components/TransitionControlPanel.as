package {
	
	import adobe.utils.MMExecute;
	
	import flash.display.MovieClip;
	
	import flash.text.TextField;
	import fl.controls.Slider;
	
	import flash.events.Event;
	import fl.events.SliderEvent;

	public class TransitionControlPanel extends MovieClip {
		
		// on-stage
		public var durationSlider:Slider;
		public var DO1:TextField;
		public var DO2:TextField;
		public var trans:TextField;
		public var dur:TextField;
		
		// 
		// Parameters follow the same number order as they are
		// listed in the component... which MUST be alphabetical!
		//
		private const PARAMETER_DO1:String = "fl.getDocumentDOM().selection[0].parameters[0].value";
		private const PARAMETER_DO2:String = "fl.getDocumentDOM().selection[0].parameters[1].value";
		private const PARAMETER_DURATION:String = "fl.getDocumentDOM().selection[0].parameters[2].value";
		private const PARAMETER_TRANSITION:String = "fl.getDocumentDOM().selection[0].parameters[3].value";
		
		//--------------------------------------------
		
		public function TransitionControlPanel() {
			
			DO1.text=MMExecute(PARAMETER_DO1);
			DO2.text=MMExecute(PARAMETER_DO2);
			trans.text=MMExecute(PARAMETER_TRANSITION);
			dur.text = MMExecute(PARAMETER_DURATION);
			DO1.addEventListener(Event.CHANGE, setDO1FromText, false, 0, true);
			DO2.addEventListener(Event.CHANGE, setDO2FromText, false, 0, true);
			trans.addEventListener(Event.CHANGE, setTransFromText, false, 0, true);
			dur.addEventListener(Event.CHANGE, setDurFromText, false, 0, true);
			durationSlider.minimum=1;
			durationSlider.maximum=200;
			durationSlider.addEventListener(SliderEvent.CHANGE, setDur, false, 0, true);
			
			addEventListener(Event.ENTER_FRAME, setControls, false, 0, true);
		}
		
		//......................
		
		private function setControls(e:Event):void {
			dur.restrict="0123456789.";
			setDO1FromText();
			setDO2FromText();
			setTransFromText();
			setDurFromText();
			removeEventListener(Event.ENTER_FRAME, setControls);
		}
		
		//--------------------------------------------
		
		private function setDur(e:SliderEvent):void {
			dur.text = e.value.toString();
			MMExecute(PARAMETER_DURATION + "=" + e.value);
		}
		
		//--------------------------------------------
				
		private function setDurFromText(e:Event = null):void {
			var value:int = int(dur.text);
			MMExecute(PARAMETER_DURATION + "=" + value);
			durationSlider.value = value;
		}	
		
		private function setDO1FromText(e:Event = null):void {
			MMExecute(PARAMETER_DO1 + "=" + "\'"+DO1.text+"\';");
		}	
		
		private function setDO2FromText(e:Event = null):void {
			MMExecute(PARAMETER_DO2 + "=" + "\'"+DO2.text+"\';");
		}	
		
		private function setTransFromText(e:Event = null):void {
			MMExecute(PARAMETER_TRANSITION + "=" + "\'"+trans.text+"\';");
		}	
	}
}