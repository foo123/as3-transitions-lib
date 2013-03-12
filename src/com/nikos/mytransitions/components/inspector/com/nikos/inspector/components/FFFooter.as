class com.nikos.inspector.components.FFFooter extends MovieClip
{
    var url, _tf, SCROLL_WIDTH, footer_bg_mc, img_mc, getURL;
    function FFFooter()
    {
        super();
    } // End of the function
    function init(support_string, support_url)
    {
        url = support_url;
        _tf.text = support_string;
        SCROLL_WIDTH = com.nikos.inspector.TransitionInspector.SCROLL_WIDTH;
    } // End of the function
    function onStageChange(cw, ch)
    {
        footer_bg_mc._width = cw + SCROLL_WIDTH;
        img_mc._x = cw + SCROLL_WIDTH;
    } // End of the function
    function onRelease()
    {
		getURL(url,"_blank");
    } // End of the function
} // End of Class
