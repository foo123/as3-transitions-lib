class com.nikos.inspector.components.FFSelectList extends com.nikos.inspector.components.FFComponent
{
    var _internal, _dir, _selectListEntryArray, _tf, _laterInterval, _selectList, _varValue, _field_obj, _targetForm, _varName, _inspector;
    var dd;
	
	function FFSelectList()
    {
        super();
		dd=this.getDepth();
    } // End of the function
    function init(inspector, varName, varValue, copy, selectListEntryArray, internal, dir)
    {
        super.init(inspector, varName, varValue, copy);
        _internal = internal == undefined ? (false) : (internal);
        _dir = dir == undefined ? ("down") : (dir);
        _selectListEntryArray = selectListEntryArray;
        _tf.text = copy;
        clearInterval(_laterInterval);
        _laterInterval = setInterval(this, "initForm", 100);
    } // End of the function
    function initForm()
    {
        clearInterval(_laterInterval);
        _selectList.__set__embedFonts(true);
        _selectList.__set__openDir(_dir);
        _field_obj = {_selectList: {def: _varValue, req: true, values: _selectListEntryArray, maxHeight: 4, msg: "Select.."}};
        _targetForm = new de.argonauten.form.Form(_field_obj, this, "");
        _targetForm.addEventListener("onReply", this);
        _targetForm.addEventListener("onValidate", this);
        _targetForm.addEventListener("onChange", this);
        _targetForm.addEventListener("onOpen", this);
        if (_varValue == "")
        {
            /*if (_internal)
            {
                _selectList.__set__topText("Select..");
            }
            else
            {*/
                _selectList.__set__topText("Select..");
            //} // end if
        } // end else if
    } // End of the function
    function onOpen(e)
    {
		this.swapDepths(_inspector._contentContainer_mc.getNextHighestDepth());
    } // End of the function
    function onReply(e)
    {
    } // End of the function
    function onValidate(e)
    {
    } // End of the function
    function onChange(e)
    {
        //this.swapDepths(dd);
		_inspector.setFilterVar(_varName, e.target.getValue(), _internal);
    } // End of the function
} // End of Class
