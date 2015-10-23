class de.argonauten.form.RadioBT extends MovieClip
{
    var useHandCursor, _name, id, _parent, group, hilite_mc, tabEnabled, selected, gotoAndStop, __get__enabled, __set__enabled;
    function RadioBT()
    {
        super();
        useHandCursor = false;
        id = Number(_name.substr(5));
        group = /*(de.argonauten.form.RadioGroup)*/(_parent);
        hilite_mc._visible = false;
        tabEnabled = false;
    } // End of the function
    function select()
    {
        if (!selected && _enabled)
        {
            group.__set__index(id);
        } // end if
    } // End of the function
    function onRollOver()
    {
        if (!selected && _enabled)
        {
        } // end if
    } // End of the function
    function onRollOut()
    {
        if (!selected && _enabled)
        {
        } // end if
    } // End of the function
    function onPress()
    {
        if (!selected && _enabled)
        {
        } // end if
    } // End of the function
    function onRelease()
    {
        this.select();
    } // End of the function
    function onReleaseOutside()
    {
        this.onRollOut();
    } // End of the function
    function hilite(b)
    {
        hilite_mc._visible = b;
    } // End of the function
    function set enabled(bol)
    {
        de.argonauten.utils.logging.LogManager.$info(this + " set enabled: " + bol);
        _enabled = bol;
        //return (this.enabled());
        null;
    } // End of the function
    function get enabled()
    {
        return (_enabled);
    } // End of the function
    var _enabled = true;
} // End of Class
