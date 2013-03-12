class com.nikos.inspector.components.FFRadioButtons extends com.nikos.inspector.components.FFComponent
{
    var _internal, _tf, _copy, _laterInterval, _varValue, _field_obj, _radioForm, _varName, _inspector;
    function FFRadioButtons()
    {
        super();
    } // End of the function
    function RadioButtons()
    {
    } // End of the function
    function init(inspector, varName, varValue, copy, internal)
    {
        super.init(inspector, varName, varValue, copy);
        _internal = internal == undefined ? (false) : (internal);
        _tf.text = _copy;
        _laterInterval = setInterval(this, "initLater", 100);
    } // End of the function
    function initLater()
    {
        clearInterval(_laterInterval);
        _field_obj = {option2: {def: _varValue, values: _radioArray}};
        _radioForm = new de.argonauten.form.Form(_field_obj, this, "");
        _radioForm.addEventListener("onReply", this);
        _radioForm.addEventListener("onValidate", this);
        _radioForm.addEventListener("onChange", this);
    } // End of the function
    function onReply(e)
    {
    } // End of the function
    function onValidate(e)
    {
    } // End of the function
    function onChange(e)
    {
        _inspector.setFilterVar(_varName, e.target.getValue(), _internal);
    } // End of the function
    var _radioArray = [true, false];
} // End of Class
