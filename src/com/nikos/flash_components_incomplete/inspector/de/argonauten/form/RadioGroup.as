class de.argonauten.form.RadioGroup extends de.argonauten.form.UIComponent
{
    var valArray, btns_array, __set__index, val, __get__enabled, selected, dispatchEvent, __get__index, __set__enabled;
    function RadioGroup()
    {
        super();
    } // End of the function
    function setValues(valArr)
    {
        valArray = valArr;
        btns_array = [];
        for (var _loc2 = 0; _loc2 < valArray.length; ++_loc2)
        {
            btns_array.push(this["radio" + _loc2]);
        } // end of for
    } // End of the function
    function setValue(v)
    {
        for (var _loc2 = 0; _loc2 < valArray.length; ++_loc2)
        {
            if (v == valArray[_loc2])
            {
                this.__set__index(_loc2);
                break;
            } // end if
        } // end of for
    } // End of the function
    function getValue()
    {
        return (val);
    } // End of the function
    function set enabled(bol)
    {
        _enabled = bol;
        for (var _loc2 = 0; _loc2 < btns_array.length; ++_loc2)
        {
            btns_array[_loc2].enabled = _enabled;
        } // end of for
        //return (this.enabled());
        null;
    } // End of the function
    function get enabled()
    {
        return (_enabled);
    } // End of the function
    function set index(num)
    {
        if (num == selected)
        {
            return;
        } // end if
        val = valArray[num];
        selected = num;
        for (var _loc2 in btns_array)
        {
            btns_array[_loc2].gotoAndStop("out");
            btns_array[_loc2].selected = false;
        } // end of for...in
        this["radio" + num].gotoAndStop("selected");
        this["radio" + num].selected = true;
        this.hilite(false);
        this.dispatchEvent({type: "onChange", target: this});
        //return (this.index());
        null;
    } // End of the function
    function get index()
    {
        return (selected);
    } // End of the function
    function hilite(b)
    {
        for (var _loc3 in btns_array)
        {
            btns_array[_loc3].hilite(b);
        } // end of for...in
    } // End of the function
    var _enabled = true;
} // End of Class
