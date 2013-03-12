class de.argonauten.form.UIComponent extends MovieClip
{
    var _id, __get__id, hilite_mc, dispatchEvent, __set__id;
    function UIComponent()
    {
        super();
        mx.events.EventDispatcher.initialize(this);
    } // End of the function
    function set id(newid)
    {
        _id = newid;
        //return (this.id());
        null;
    } // End of the function
    function get id()
    {
        return (_id);
    } // End of the function
    function hilite(b)
    {
        hilite_mc._visible = b;
    } // End of the function
    function onSetFocus(oldFocus)
    {
        this.dispatchEvent({type: "onSetFocus", target: this});
    } // End of the function
    function onKillFocus(newFocus)
    {
        this.dispatchEvent({type: "onKillFocus", target: this});
    } // End of the function
} // End of Class
