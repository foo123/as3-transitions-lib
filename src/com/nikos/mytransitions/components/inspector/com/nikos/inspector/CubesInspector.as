class com.nikos.inspector.CubesInspector extends com.nikos.inspector.TransitionInspector
{
	var slices,overlap,ordering,direction,direction_mode,slicing;
	var _line1, _line2, _line;
	var	FX_LIBRARY_NAME = "Cubes";
	var	FX_NAME = "Cubes";
	function CubesInspector()
    {
        super();
    } // End of the function
    function NEVER_CALLED()
    {
        var _loc1 = [de.argonauten.gui.ScrollBar, de.argonauten.form.RadioBT, com.nikos.inspector.components.FFRadioButtons, com.nikos.inspector.components.FFNumberInput, com.nikos.inspector.components.FFColorPicker];
    } // End of the function
    function buildInspector()
    {
		_contentContainer_mc = this.createEmptyMovieClip("_contentContainer_mc", 1);
		_sp = /*(de.argonauten.gui.ScrollPane)*/(this.attachMovie("scrollPane", "scrollPane", 2));
		_header_mc = /*(com.nikos.inspector.components.FFHeader)*/(this.attachMovie("ffHeader_mc", "header_mc", 3));
        _header_mc.init(FX_NAME);
        _stageChangeListener.push(_header_mc);
        _footer_mc = /*(com.nikos.inspector.components.FFFooter)*/(this.attachMovie("ffFooter_mc", "footer_mc", 4));
        _footer_mc.init(SUPPORT_STRING, SUPPORT_URL);
        _stageChangeListener.push(_footer_mc);
        if (!this.checkCommandExists())
        {
            return;
        } // end if
        var instances=this.getInstancesInCurrentFrame().inst;
		fromTarget = /*(com.nikos.inspector.components.FFSelectList)*/(_contentContainer_mc.attachMovie("ffSelectList_mc", "ffSelectList1_mc", _contentContainer_mc.getNextHighestDepth()));
        fromTarget.init(this, "fromTarget", xch.fromTarget, "Start MovieClip: ", instances);
		fromTarget._x = com.nikos.inspector.TransitionInspector.RASTER;
        fromTarget._y = com.nikos.inspector.TransitionInspector.RASTER;
        _line = this.drawLine("line0_mc", com.nikos.inspector.TransitionInspector.RASTER, fromTarget._y + fromTarget._height + com.nikos.inspector.TransitionInspector.RASTER);
        _stageChangeListener.push(_line1);
        toTarget = /*(com.nikos.inspector.components.FFSelectList)*/(_contentContainer_mc.attachMovie("ffSelectList_mc", "ffSelectList10_mc", _contentContainer_mc.getNextHighestDepth()));
        toTarget.init(this, "toTarget", xch.toTarget, "End MovieClip: ", instances);
        toTarget._x = com.nikos.inspector.TransitionInspector.RASTER;
        toTarget._y = _line._y + _line._height + com.nikos.inspector.TransitionInspector.RASTER;
		duration = /*(com.nikos.inspector.components.FFNumberInput)*/(_contentContainer_mc.attachMovie("ffNumberInput_mc", "number_input1_mc", _contentContainer_mc.getNextHighestDepth()));
        duration.init(this, "duration", xch.duration, "Transition duration: ", "frames or seconds", 0, 9999, false);
        duration._x = com.nikos.inspector.TransitionInspector.RASTER;
        duration._y = toTarget._y + toTarget._height + com.nikos.inspector.TransitionInspector.RASTER;
        useFrames = /*(com.nikos.inspector.components.FFRadioButtons)*/(_contentContainer_mc.attachMovie("ffRadioButtons_mc", "radioButtons_mc", _contentContainer_mc.getNextHighestDepth()));
        useFrames.init(this, "useFrames", xch.useFrames, "Use frames: ");
        useFrames._x = com.nikos.inspector.TransitionInspector.RASTER;
        useFrames._y = duration._y + duration._height + com.nikos.inspector.TransitionInspector.RASTER;
        easing = /*(com.nikos.inspector.components.FFSelectList)*/(_contentContainer_mc.attachMovie("ffSelectList_mc", "ffSelectList3_mc", _contentContainer_mc.getNextHighestDepth()));
        easing.init(this, "easing", xch.easing, "Easing: ", this.getEasing());
        easing._x = com.nikos.inspector.TransitionInspector.RASTER;
        easing._y = useFrames._y + useFrames._height + com.nikos.inspector.TransitionInspector.RASTER;
        _line1 = this.drawLine("line1_mc", com.nikos.inspector.TransitionInspector.RASTER, easing._y + easing._height + com.nikos.inspector.TransitionInspector.RASTER);
        _stageChangeListener.push(_line1);
        slices = /*(com.nikos.inspector.components.FFNumberInput)*/(_contentContainer_mc.attachMovie("ffNumberInput_mc", "number_input2_mc", _contentContainer_mc.getNextHighestDepth()));
        slices.init(this, "slices", xch.slices, "Slices: ", "", 1, 500, false);
        slices._x = com.nikos.inspector.TransitionInspector.RASTER;
		slices._y = _line1._y + _line1._height + com.nikos.inspector.TransitionInspector.RASTER;
        overlap = /*(com.nikos.inspector.components.FFNumberInput)*/(_contentContainer_mc.attachMovie("ffNumberInput_mc", "number_input4_mc", _contentContainer_mc.getNextHighestDepth()));
        overlap.init(this, "overlap", xch.overlap, "Overlap: ", "", 0.0, 1.0, false);
        overlap._x = com.nikos.inspector.TransitionInspector.RASTER;
        overlap._y = slices._y + slices._height + com.nikos.inspector.TransitionInspector.RASTER;
        slicing = /*(com.nikos.inspector.components.FFSelectList)*/(_contentContainer_mc.attachMovie("ffSelectList_mc", "ffSelectList4_mc", _contentContainer_mc.getNextHighestDepth()));
        slicing.init(this, "slicing", xch.slicing, "Slicing: ", ["horizontal","vertical"]);
        slicing._x = com.nikos.inspector.TransitionInspector.RASTER;
        slicing._y = overlap._y + overlap._height + com.nikos.inspector.TransitionInspector.RASTER;
        direction = /*(com.nikos.inspector.components.FFSelectList)*/(_contentContainer_mc.attachMovie("ffSelectList_mc", "ffSelectList31_mc", _contentContainer_mc.getNextHighestDepth()));
        direction.init(this, "direction", xch.direction, "Direction: ", ["left","right","up","down"]);
        direction._x = com.nikos.inspector.TransitionInspector.RASTER;
        direction._y = slicing._y + slicing._height + com.nikos.inspector.TransitionInspector.RASTER;
        direction_mode = /*(com.nikos.inspector.components.FFSelectList)*/(_contentContainer_mc.attachMovie("ffSelectList_mc", "ffSelectList32_mc", _contentContainer_mc.getNextHighestDepth()));
        direction_mode.init(this, "direction_mode", xch.direction_mode, "Direction Mode: ", ["none","alternate","random"]);
        direction_mode._x = com.nikos.inspector.TransitionInspector.RASTER;
        direction_mode._y = direction._y + direction._height + com.nikos.inspector.TransitionInspector.RASTER;
        ordering = /*(com.nikos.inspector.components.FFSelectList)*/(_contentContainer_mc.attachMovie("ffSelectList_mc", "ffSelectList5_mc", _contentContainer_mc.getNextHighestDepth()));
        ordering.init(this, "ordering", xch.ordering, "Ordering: ", this.getOrdering());
        ordering._x = com.nikos.inspector.TransitionInspector.RASTER;
        ordering._y = direction_mode._y + direction_mode._height + com.nikos.inspector.TransitionInspector.RASTER;
        _line2 = this.drawLine("line2_mc", com.nikos.inspector.TransitionInspector.RASTER, Math.round(ordering._y + ordering._height + com.nikos.inspector.TransitionInspector.RASTER));
        _stageChangeListener.push(_line2);
        _testMovieButton_mc = /*(com.nikos.inspector.components.FFTestButton)*/(_contentContainer_mc.attachMovie("ffTestButton_mc", "ffTestButton_mc", _contentContainer_mc.getNextHighestDepth()));
        _testMovieButton_mc.init(this);
        _testMovieButton_mc._y = Math.round(_line2._y + _line2._height + com.nikos.inspector.TransitionInspector.RASTER);
        this.onInspectorStageChange();
   } // End of the function
    function onInspectorStageChange()
    {
        this.resetComponents();
        this.finalizeView();
    } // End of the function
    function setFilterVar(varName, varValue, internal)
    {
		super.setFilterVar(varName, varValue);
    } // End of the function
} // End of Class
