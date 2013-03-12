class com.nikos.inspector.TransitionInspector extends MovieClip
{
    var _stageChangeListener, xch, _contentContainer_mc, FX_LIBRARY_NAME, FX_NAME , JSFL_PATH, _testMovieButton_mc, _footer_mc, _header_mc, _sp;
    var fromTarget,toTarget,duration,useFrames,easing;
    var SUPPORT_STRING = "WEB: http://nikos-web-development.netai.net";
    var SUPPORT_URL = "http://nikos-web-development.netai.net/";
    var firstTime=true;
	
	function TransitionInspector()
    {
        super();
   } // End of the function
    
   /* function NEVER_CALLED()
    {
        var _loc1 = [de.argonauten.gui.ScrollBar, de.argonauten.form.RadioBT, com.nikos.inspector.components.FFRadioButtons, com.nikos.inspector.components.FFNumberInput, com.nikos.inspector.components.FFColorPicker];
    } // End of the function
	*/
	function getEasing()
	{
		var eas=[];
		eas.push("None");
		eas.push("None.easeIn");
		eas.push("None.easeInOut");
		eas.push("None.easeOut");
		eas.push("Bounce.easeIn");
		eas.push("Bounce.easeInOut");
		eas.push("Back.easeOut");
		eas.push("Back.easeIn");
		eas.push("Back.easeInOut");
		eas.push("Back.easeOut");
		eas.push("Regular.easeIn");
		eas.push("Regular.easeInOut");
		eas.push("Regular.easeOut");
		eas.push("Strong.easeIn");
		eas.push("Strong.easeInOut");
		eas.push("Strong.easeOut");
		eas.push("Elastic.easeIn");
		eas.push("Elastic.easeInOut");
		eas.push("Elastic.easeOut");
		return(eas);
	}
	
	function getOrdering()
	{
		var ord=[];
		ord.push("diagonal-top-left");
		ord.push("diagonal-top-right");
		ord.push("diagonal-bottom-left");
		ord.push("diagonal-bottom-right");
		ord.push("checkerboard");
		ord.push("up-down");
		ord.push("up-down-reverse");
		ord.push("left-right");
		ord.push("left-right-reverse");
		ord.push("rows");
		ord.push("rows-first");
		ord.push("rows-reverse");
		ord.push("rows-first-reverse");
		ord.push("columns");
		ord.push("columns-first");
		ord.push("columns-reverse");
		ord.push("columns-first-reverse");
		ord.push("random");
		ord.push("spiral-top-left");
		ord.push("spiral-top-left-reverse");
		ord.push("spiral-top-right");
		ord.push("spiral-top-right-reverse");
		ord.push("spiral-bottom-left");
		ord.push("spiral-bottom-left-reverse");
		ord.push("spiral-bottom-right");
		ord.push("spiral-bottom-right-reverse");
		return(ord);
	}
	
	function init()
    {
        _root.onEnterFrame = mx.utils.Delegate.create(this, waitOnEnterFrame);
        _stageChangeListener = new Array();
		JSFL_PATH=MMExecute("fl.configURI") + "Components/nikos-components/commands.jsfl";
    } // End of the function
    function waitOnEnterFrame()
    {
        /*xch=new Object();
		xch.fromTarget="s3";
		xch.toTarget="s4";
		xch.duration=4;
		xch.useFrames=true;
		xch.easing="None";
		xch.rows=2;
		xch.columns=2;
		xch.spin="horizontal";
		xch.ordering="random";
		xch.overlap=.9;*/
		if (xch != undefined)
        {
            _root.onEnterFrame = function ()
            {
            };
			this.initLater();
        } // end if
    } // End of the function
    function initLater()
    {
        var _loc2 = new Object();
        _loc2.onResize = mx.utils.Delegate.create(this, onInspectorStageChange);
        Stage.addListener(_loc2);
       this.buildInspector();
       _root.onEnterFrame = mx.utils.Delegate.create(this, updateTargetAndPosition);
    } // End of the function
	function updateTargetAndPosition()
	{
		if (xch!=undefined && xch!=null)
		{
		var foo;
		var xchxy=MMExecute("fl.runScript(\"" + JSFL_PATH + "\", \"getXY\") ");
		if (xchxy=="false") return;
		var fooxy=xchxy.split(",");
		var fx=Number(fooxy[0]);
		var fy=Number(fooxy[1]);
		if (firstTime)
		{
			xch.posx=fx;
			xch.posy=fy;
		}
		if (Math.abs(xch.posx-fx)>.05 || Math.abs(xch.posy-fy)>.05 || firstTime)
		{
			foo=this.getInstancesInCurrentFrame();
			if (foo.inst.length>0)
			{
				var ii=-1;
				var xywh;
				for (var i=0;i<foo.inst.length;i++)
				{
					xywh=foo.xy[i].split("*");
					if (fx>=Number(xywh[0]) && fx <=Number(xywh[0])+Number(xywh[2]) && fy>=Number(xywh[1]) && fy <=Number(xywh[1])+Number(xywh[3]))
					{
						ii=i;
						break;
					}
				}
				if (ii>-1)
				{
					setFilterVar("fromTarget",foo.inst[ii]);
					var ffx=Number(xywh[0]);
					var ffy=Number(xywh[1]);
					if (Math.abs(fx-ffx)>0.05 || Math.abs(fy-ffy)>0.05)
					{
						xch.posx=ffx;
						xch.posy=ffy;
						MMExecute("fl.getDocumentDOM().moveSelectionBy({x:"+(ffx-fx)+", y:"+(ffy-fy)+"})");
					}
					fromTarget.init(this, "fromTarget", xch.fromTarget, "Start MovieClip: ", foo.inst);
					toTarget.init(this, "toTarget", xch.toTarget, "End MovieClip: ", foo.inst);
				}
			}
			firstTime=false;
		}
		}
	}
    function buildInspector()
    {
    } // End of the function
    function onInspectorStageChange()
    {
    } // End of the function
    function setFilterVar(varName, varValue)
    {
        if (xch[varName] == varValue)
        {
            return;
        } // end if
        xch[varName] = varValue;
    } // End of the function
    function drawLine(name, x, y)
    {
        var _loc2 = /*(com.nikos.inspector.components.FFLine)*/(_contentContainer_mc.attachMovie("ffLine_mc", name, 1/*_contentContainer_mc.getNextHighestDepth()*/));
        _loc2._x = x;
        _loc2._y = y;
        return (_loc2);
    } // End of the function
	function getInstancesInCurrentFrame()
    {
		var _loc3 = MMExecute("fl.runScript(\"" + JSFL_PATH + "\", \"getInstancesInCurrentFrame\", \"" + FX_LIBRARY_NAME + "\") ").split("|");
		return ({inst:_loc3[0].split(","), xy:_loc3[1].split("&")});
    } // End of the function
    function testMovie()
    {
        if (xch.fromTarget == "")
        {
            trace (FX_LIBRARY_NAME + " ERROR - No Start MovieClip defined");
            return;
        } // end if
        if (xch.toTarget == "")
        {
            trace (FX_LIBRARY_NAME + " ERROR - No End MovieClip defined");
            return;
        } // end if
        MMExecute("fl.getDocumentDOM().testMovie()");
        this.initLater();
    } // End of the function
    function resetComponents()
    {
        _testMovieButton_mc._x = 10;
        _footer_mc._y = Stage.height;
        _contentContainer_mc._y = _header_mc._y + _header_mc._height;
        for (var _loc2 in _stageChangeListener)
        {
            _stageChangeListener[_loc2].onStageChange(20, 0);
        } // end of for...in
    } // End of the function
    function finalizeView()
    {
        var _loc6 = Stage.width;
        var _loc5 = Math.round(Stage.height - _header_mc._height - _footer_mc._height);
        var _loc3 = Stage.height;
        var _loc2;
        if (_loc5 < _contentContainer_mc._height)
        {
            _loc2 = Stage.width - 16;
            _loc6 = Stage.width - 16;
        }
        else
        {
            _loc2 = Stage.width;
        } // end else if
        for (var _loc4 in _stageChangeListener)
        {
            _stageChangeListener[_loc4].onStageChange(_loc2, _loc3);
        } // end of for...in
        _testMovieButton_mc._x = _loc2 - _testMovieButton_mc._width - com.nikos.inspector.TransitionInspector.RASTER;
        _sp._x = 0;
        _sp._y = _header_mc._y + _header_mc._height;
        _sp.setWidth(_loc6);
        _sp.setHeight(_loc5);
        _sp.init(_contentContainer_mc, 0);
        //_sp.swapDepths(this.getNextHighestDepth());
    } // End of the function
    function checkCommandExists()
    {
        if (MMExecute("fl.fileExists(\"" + JSFL_PATH + "\")") == "false")
        {
            MMExecute("alert(\"The FX is not installed properly. Please reinstall the FX.\\n\\nFor instructions how to install see documentation.\")");
            this.resetComponents();
            this.finalizeView();
            return (false);
        }
        else
        {
            return (true);
        } // end else if
    } // End of the function
    static var RASTER = 10;
    static var SCROLL_WIDTH = 16;
} // End of Class
