class com.nikos.inspector.components.FFHeader extends MovieClip
{
    var _headline_tf, SCROLL_WIDTH, header_bg_mc, img_mc;
    function FFHeader()
    {
        super();
    } // End of the function
    function init(name)
    {
        _headline_tf.text = name;
        SCROLL_WIDTH = com.nikos.inspector.TransitionInspector.SCROLL_WIDTH;
    } // End of the function
    function onStageChange(cw, ch)
    {
        header_bg_mc._width = cw + SCROLL_WIDTH;
        img_mc._x = cw + SCROLL_WIDTH;
    } // End of the function
} // End of Class
