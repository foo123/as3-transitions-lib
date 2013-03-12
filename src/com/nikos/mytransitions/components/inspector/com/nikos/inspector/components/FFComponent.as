class com.nikos.inspector.components.FFComponent extends MovieClip
{
    var _inspector, _varName, _varValue, _copy;
    function FFComponent()
    {
        super();
    } // End of the function
    function init(inspector, varName, varValue, copy)
    {
        _inspector = inspector;
        _varName = varName;
        _varValue = varValue;
        _copy = copy;
    } // End of the function
} // End of Class
