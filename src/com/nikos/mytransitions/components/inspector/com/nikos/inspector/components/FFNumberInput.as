class com.nikos.inspector.components.FFNumberInput extends com.nikos.inspector.components.FFComponent
{
    var _minVar, _maxVar, _copy2, _internal, RASTER, _copy1_tf, _copy, _num_mc, _copy2_tf, _varValue, _varName, _inspector;
    function FFNumberInput()
    {
        super();
    } // End of the function
    function init(inspector, varName, varValue, copy, copy2, minVar, maxVar, internal, angle)
    {
        super.init(inspector, varName, varValue, copy);
        _minVar = minVar;
        _maxVar = maxVar;
        _copy2 = copy2;
        _internal = internal == undefined ? (false) : (internal);
        RASTER = com.nikos.inspector.TransitionInspector.RASTER;
        _copy1_tf.text = _copy;
        _copy1_tf.autoSize = true;
        _num_mc._x = _copy1_tf._x + _copy1_tf._width;
        _copy2_tf._x = _num_mc._x + _num_mc._width + 2;
        _copy2_tf.text = _copy2 != undefined ? (_copy2) : ("");
        _copy2_tf.autoSize = true;
        if (angle)
        {
            _num_mc.tf.restrict = "0-9.\\-";
        }
        else
        {
            _num_mc.tf.restrict = "0-9.";
        } // end else if
        _num_mc.tf.onChanged = mx.utils.Delegate.create(this, onChangeTf);
        _num_mc.tf.onKillFocus = mx.utils.Delegate.create(this, onKillFocusTf);
        _num_mc.tf.text = String(_varValue);
    } // End of the function
    function onChangeTf()
    {
        var _loc2 = Number(_num_mc.tf.text);
        if (isNaN(_loc2))
        {
            return;
        } // end if
        if (_loc2 < _minVar && _minVar != null && _minVar != undefined)
        {
            _loc2 = _minVar;
        } // end if
        if (_loc2 > _maxVar && _maxVar != null && _maxVar != undefined)
        {
            _loc2 = _maxVar;
        } // end if
        _varValue = String(_loc2);
        _inspector.setFilterVar(_varName, _loc2, _internal);
    } // End of the function
    function onKillFocusTf()
    {
        _num_mc.tf.text = _varValue;
    } // End of the function
    function round3komma(num)
    {
        return (Math.round(num * 100) / 100);
    } // End of the function
} // End of Class
