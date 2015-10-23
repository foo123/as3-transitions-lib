class de.argonauten.form.CheckBox extends de.argonauten.form.UIComponent
{
    var checkmark, hilite_mc, loaded, __get__numMode, __set__numMode, hilite, _totalframes, gotoAndPlay, dispatchEvent, _numMode, gotoAndStop;
    function CheckBox()
    {
        super();
        checkmark._visible = false;
        hilite_mc._visible = false;
        loaded = false;
    } // End of the function
    function getValue()
    {
        var _loc2 = this.__get__numMode() ? (Number(checkmark._visible)) : (checkmark._visible);
        return (_loc2);
    } // End of the function
    function setValue(v)
    {
        this.__set__numMode(Boolean(typeof(v) == "number"));
        var _loc2 = Boolean(v);
        if (checkmark._visible == _loc2)
        {
            return;
        } // end if
        checkmark._visible = _loc2;
        this.hilite(false);
        if (_totalframes > 2 && loaded)
        {
        } // end if
        this.dispatchEvent({type: "onChange", target: this});
    } // End of the function
    function set numMode(newnumMode)
    {
        _numMode = newnumMode;
        //return (this.numMode());
        null;
    } // End of the function
    function get numMode()
    {
        return (_numMode);
    } // End of the function
    function onLoad()
    {
        loaded = true;
    } // End of the function
    function onRollOver()
    {
        if (_totalframes > 2)
        {
            if (this.getValue() == 0)
            {
            } // end if
        } // end if
    } // End of the function
    function onRollOut()
    {
        if (_totalframes > 2)
        {
            if (this.getValue() == 0)
            {
            } // end if
        } // end if
    } // End of the function
    function onPress()
    {
        if (_totalframes > 2)
        {
            if (this.getValue() == 0)
            {
            } // end if
        } // end if
    } // End of the function
    function onRelease()
    {
        var _loc2 = !Boolean(this.getValue());
        var _loc3 = this.__get__numMode() ? (Number(_loc2)) : (_loc2);
        this.setValue(_loc3);
    } // End of the function
    function onReleaseOutside()
    {
        if (_totalframes > 2)
        {
            this.onRollOut();
        } // end if
    } // End of the function
} // End of Class
