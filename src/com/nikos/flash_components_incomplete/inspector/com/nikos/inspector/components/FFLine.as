class com.nikos.inspector.components.FFLine extends MovieClip
{
    var RASTER, _width;
    function FFLine()
    {
        super();
        RASTER = com.nikos.inspector.TransitionInspector.RASTER;
    } // End of the function
    function onStageChange(cw, ch)
    {
        _width = cw - RASTER * 2;
    } // End of the function
} // End of Class
