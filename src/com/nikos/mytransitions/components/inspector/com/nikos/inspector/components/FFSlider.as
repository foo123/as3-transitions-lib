class com.nikos.inspector.components.FFSlider extends com.nikos.inspector.components.FFComponent
{
    var _minVar, _maxVar, _copy, _copy2, _internal, RASTER, _varRange, _copy1_tf, _num_mc, _copy2_tf, _minVar_tf, _maxVar_tf, _touch_mc, _click_touch_mc, _varValue, _minXPos, _maxXPos, _currentPerc, _varName, _inspector, _line_mc;
    function FFSlider()
    {
        super();
    } // End of the function
    function init(inspector, varName, varValue, copy, copy2, minVar, maxVar, internal)
    {
        super.init(inspector, varName, varValue, copy);
        _minVar = minVar;
        _maxVar = maxVar;
        _copy = copy;
        _copy2 = copy2;
        _internal = internal == undefined ? (false) : (internal);
        RASTER = com.nikos.inspector.TransitionInspector.RASTER;
        _varRange = _maxVar - _minVar;
        _copy1_tf.text = _copy;
        _copy1_tf.autoSize = true;
        _num_mc._x = _copy1_tf._x + _copy1_tf._width;
        _copy2_tf._x = _num_mc._x + _num_mc._width + 2;
        _copy2_tf.text = _copy2;
        _copy2_tf.autoSize = true;
        _minVar_tf.text = String(minVar);
        _minVar_tf.autoSize = true;
        _maxVar_tf.text = String(maxVar);
        _maxVar_tf.autoSize = true;
        _touch_mc.onPress = mx.utils.Delegate.create(this, onPressTouch);
        _touch_mc.onRelease = mx.utils.Delegate.create(this, onReleaseTouch);
        _touch_mc.onReleaseOutside = mx.utils.Delegate.create(this, onReleaseTouch);
        _num_mc.tf.onChanged = mx.utils.Delegate.create(this, onChangeTf);
        _num_mc.tf.onKillFocus = mx.utils.Delegate.create(this, onKillFocusTf);
        this.onStageChange();
        _click_touch_mc.onPress = mx.utils.Delegate.create(this, onPressBgTouch);
        _num_mc.tf.restrict = "0-9.";
        _num_mc.tf.text = String(_varValue);
        this.onChangeTf();
    } // End of the function
    function onPressBgTouch()
    {
        _touch_mc._x = _root._xmouse - 7;
        this.onEnterFrameMoving();
    } // End of the function
    function onChangeTf()
    {
        var _loc2 = Number(_num_mc.tf.text);
        if (isNaN(_loc2))
        {
            return;
        } // end if
        if (_loc2 < _minVar)
        {
            _loc2 = _minVar;
        } // end if
        if (_loc2 > _maxVar)
        {
            _loc2 = _maxVar;
        } // end if
        _varValue = String(_loc2);
        var _loc3 = (_loc2 - _minVar) / _varRange;
        var _loc4 = _minXPos + _loc3 * (_maxXPos - _minXPos);
        _touch_mc._x = _loc4;
        _currentPerc = _loc3;
        _inspector.setFilterVar(_varName, _loc2, _internal);
    } // End of the function
    function onKillFocusTf()
    {
        _num_mc.tf.text = _varValue;
    } // End of the function
    function onPressTouch()
    {
        _touch_mc.startDrag(true, _minXPos, 27, _maxXPos, 27);
        onEnterFrame = onEnterFrameMoving;
    } // End of the function
    function onReleaseTouch()
    {
        _touch_mc.stopDrag();
        function onEnterFrame()
        {
        } // End of the function
    } // End of the function
    function onEnterFrameMoving()
    {
        var _loc2 = (_touch_mc._x - _minXPos) / (_maxXPos - _minXPos);
        _varValue = String(this.round3komma(_minVar + _varRange * _loc2));
        _num_mc.tf.text = _varValue;
        _currentPerc = _loc2;
        _inspector.setFilterVar(_varName, Number(_varValue), _internal);
    } // End of the function
    function round3komma(num)
    {
        return (Math.round(num * 100) / 100);
    } // End of the function
    function onStageChange(cw, ch)
    {
        var _loc2 = cw;
        _maxVar_tf._x = Math.round(_loc2 - _maxVar_tf._width) - RASTER;
        _line_mc._x = _minVar_tf._x + _minVar_tf._width + 4;
        _line_mc._width = Math.round(_loc2 - RASTER * 2 - _minVar_tf._width - _maxVar_tf._width);
        _click_touch_mc._x = _line_mc._x;
        _click_touch_mc._width = _line_mc._width;
        _minXPos = _line_mc._x;
        _maxXPos = _line_mc._x + _line_mc._width;
        var _loc3 = _minXPos + _currentPerc * (_maxXPos - _minXPos);
        _touch_mc._x = _loc3;
    } // End of the function
} // End of Class
