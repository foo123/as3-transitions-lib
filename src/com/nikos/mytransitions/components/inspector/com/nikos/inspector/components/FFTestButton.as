class com.nikos.inspector.components.FFTestButton extends com.nikos.inspector.components.FFComponent
{
    var _inspector, gotoAndStop;
    function FFTestButton()
    {
        super();
    } // End of the function
    function onRelease()
    {
        _inspector.testMovie();
    } // End of the function
    function onRollOver()
    {
        this.gotoAndStop("over");
    } // End of the function
    function onRollOut()
    {
        this.gotoAndStop("off");
    } // End of the function
} // End of Class
