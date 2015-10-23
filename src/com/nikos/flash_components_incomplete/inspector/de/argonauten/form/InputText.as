class de.argonauten.form.InputText extends de.argonauten.form.UIComponent
{
    var __set__uppercase, hilite, input_txt, _val, _uppercase, dispatchEvent, _enabled, gotoAndPlay, hilite_mc, __get__enabled, __get__restrict, __get__password, __get__maxChars, __get__uppercase, __set__enabled, __set__maxChars, __set__password, __set__restrict;
    function InputText()
    {
        super();
        var currentObject = this;
        this.__set__uppercase(false);
        this.hilite(false);
        input_txt.addListener(this);
        input_txt.onSetFocus = function (oldFocus)
        {
            currentObject.onSetFocus(oldFocus);
        };
        input_txt.onKillFocus = function (newFocus)
        {
            currentObject.onKillFocus(newFocus);
        };
    } // End of the function
    function getValue()
    {
        return (_val);
    } // End of the function
    function setValue(str)
    {
        var _loc3;
        if (_uppercase)
        {
            _loc3 = Boolean(str.toUpperCase() != _val);
        }
        else
        {
            _loc3 = Boolean(str != _val);
        } // end else if
        if (!_loc3)
        {
            return;
        } // end if
        input_txt.text = _val = _uppercase ? (str.toUpperCase()) : (str);
        this.hilite(false);
        this.dispatchEvent({type: "onChange", target: this});
    } // End of the function
    function onChanged(txt)
    {
        this.setValue(txt.text);
    } // End of the function
    function set enabled(arg)
    {
        _enabled = arg;
        input_txt.selectable = arg;
        hilite_mc._visible = false;
        //return (this.enabled());
        this.gotoAndPlay(arg ? ("active") : ("disabled"));
    } // End of the function
    function get enabled()
    {
        return (_enabled);
    } // End of the function
    function set restrict(str)
    {
        input_txt.restrict = str;
        //return (this.restrict());
        null;
    } // End of the function
    function get restrict()
    {
        return (input_txt.restrict);
    } // End of the function
    function set password(pw)
    {
        input_txt.password = pw;
        //return (this.password());
        null;
    } // End of the function
    function get password()
    {
        return (input_txt.password);
    } // End of the function
    function set maxChars(num)
    {
        input_txt.maxChars = num;
        //return (this.maxChars());
        null;
    } // End of the function
    function get maxChars()
    {
        return (input_txt.maxChars);
    } // End of the function
    function get uppercase()
    {
        return (_uppercase);
    } // End of the function
    function set uppercase(b)
    {
        _uppercase = b;
        if (b)
        {
            input_txt.text = input_txt.text.toUpperCase();
        } // end if
        //return (this.uppercase());
        null;
    } // End of the function
    function setTab(tab)
    {
        input_txt.tabIndex = tab;
    } // End of the function
    function setFocus()
    {
        Selection.setFocus(input_txt);
    } // End of the function
    function toString()
    {
        return ("[InputText]");
    } // End of the function
    function log(msg)
    {
        if (_DEBUG)
        {
            de.argonauten.utils.logging.LogManager.$info(this.toString() + "\t" + msg);
        } // end if
    } // End of the function
    var _DEBUG = true;
} // End of Class
