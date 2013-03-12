class de.argonauten.form.Form
{
    var fields, target_mc, sendURL, send_lv, rec_lv, names_array, listeners, name, tgt, dispatchEvent;
    function Form(fields, target_mc, sendURL)
    {
        mx.events.EventDispatcher.initialize(this);
        target_mc._focusrect = false;
        this.init(fields, target_mc, sendURL);
    } // End of the function
    function init(fields, target_mc, sendURL)
    {
        var currentObject = this;
        this.fields = fields;
        this.target_mc = target_mc;
        if (sendURL.length)
        {
            this.sendURL = sendURL;
            send_lv = new LoadVars();
            rec_lv = new LoadVars();
            rec_lv.onLoad = function (success)
            {
                currentObject.onReply(success);
            };
        } // end if
        names_array = [];
        for (var _loc4 in fields)
        {
            names_array.push(_loc4);
        } // end of for...in
        for (var _loc3 in fields)
        {
            if (fields[_loc3].def != undefined)
            {
                fields[_loc3].val = fields[_loc3].def;
            } // end if
        } // end of for...in
        this.initPage();
    } // End of the function
    function initPage()
    {
        if (!listeners)
        {
            listeners = {};
        } // end if
        for (var _loc5 = 0; _loc5 < names_array.length; ++_loc5)
        {
            var _loc4 = names_array[_loc5];
            var _loc3;
            if (target_mc[_loc4])
            {
                _loc3 = target_mc[_loc4];
            }
            else
            {
                continue;
            } // end else if
            var _loc6 = false;
            for (var _loc8 in de.argonauten.form.Form.compatibles)
            {
                if (_loc3 instanceof de.argonauten.form.Form.compatibles[_loc8])
                {
                    _loc6 = true;
                    break;
                } // end if
            } // end of for...in
            if (_loc6)
            {
                var _loc2 = fields[_loc4];
                if (_loc2.values != undefined)
                {
                    _loc3.setValues(_loc2.values);
                } // end if
                if (_loc2.maxHeight != undefined)
                {
                    _loc3.maxHeight = _loc2.maxHeight;
                } // end if
                if (_loc2.openDir != undefined)
                {
                    _loc3.openDir = _loc2.openDir;
                } // end if
                if (_loc3 instanceof de.argonauten.form.InputText)
                {
                    _loc3.restrict = _loc2.restrict;
                } // end if
                if (_loc2.uppercase != undefined)
                {
                    _loc3.uppercase = _loc2.uppercase;
                } // end if
                if (_loc2.enabled != undefined)
                {
                    _loc3.enabled = _loc2.enabled;
                } // end if
                if (_loc2.max != undefined)
                {
                    _loc3.maxChars = _loc2.max;
                } // end if
                if (_loc2.password)
                {
                    _loc3.password = true;
                } // end if
                if (!listeners[_loc4])
                {
                    listeners[_loc4] = {name: _loc4, tgt: this};
                    listeners[_loc4].onChange = function (e)
                    {
                        tgt.changeValue(name, e.target.getValue(), e.target);
                    };
                    listeners[_loc4].onOpen = function (e)
                    {
                        tgt.onChildOpen(e);
                    };
                } // end if
                _loc3.addEventListener("onChange", listeners[_loc4]);
                _loc3.addEventListener("onOpen", listeners[_loc4]);
                _loc3.setTab(_loc5);
                var _loc7 = _loc2.val == undefined ? (_loc2.def) : (_loc2.val);
                _loc3.setValue(_loc7);
            } // end if
        } // end of for
    } // End of the function
    function onChildOpen(e)
	{
        this.dispatchEvent({type: "onOpen", target: e.target});
	}
	function changeValue(key, val, targetObject)
    {
        fields[key].val = val;
        this.dispatchEvent({type: "onChange", target: targetObject});
    } // End of the function
    function reset()
    {
        for (var _loc2 in fields)
        {
            if (fields[_loc2].def != undefined)
            {
                fields[_loc2].val = fields[_loc2].def;
            } // end if
        } // end of for...in
        this.initPage();
    } // End of the function
    function submit()
    {
        if (this.validate())
        {
            this.send();
        } // end if
    } // End of the function
    function validate()
    {
        this.resetHilites();
        for (var _loc6 = 0; _loc6 < names_array.length; ++_loc6)
        {
            var _loc7 = names_array[_loc6];
            var _loc4 = target_mc[_loc7];
            if (!_loc4)
            {
                continue;
            } // end if
            var _loc2 = fields[_loc7];
            if (_loc2.req)
            {
                var _loc3 = true;
                if (typeof(_loc2.val) == "string")
                {
                    var _loc5 = de.argonauten.form.Form.trim(_loc2.val);
                    if (_loc5 != _loc2.val)
                    {
                        if (_loc4 instanceof de.argonauten.form.InputText)
                        {
                            _loc4.setValue(_loc5);
                        }
                        else
                        {
                            _loc2.val = _loc5;
                        } // end if
                    } // end if
                } // end else if
                if (_loc2.checkEmail)
                {
                    _loc3 = de.argonauten.form.Form.checkEmail(_loc2.val);
                }
                else if (_loc2.match != undefined)
                {
                    var _loc8 = fields[_loc2.match].val;
                    if (_loc8 != _loc2.val)
                    {
                        _loc3 = false;
                    } // end if
                }
                else if (_loc2.val == undefined || _loc2.val == "")
                {
                    _loc3 = false;
                }
                else if (_loc2.val == false && typeof(_loc2.val) == "boolean")
                {
                    _loc3 = false;
                    for (var _loc9 in _loc2.values)
                    {
                        if (_loc2.values[_loc9] == false && typeof(_loc2.values[_loc9]) == "boolean")
                        {
                            _loc3 = true;
                        } // end if
                    } // end of for...in
                }
                else if (_loc2.val == 0 && _loc4 instanceof de.argonauten.form.CheckBox)
                {
                    _loc3 = false;
                }
                else if (_loc2.min && _loc2.val.length < _loc2.min)
                {
                    _loc3 = false;
                } // end else if
                if (!_loc3)
                {
                    _loc4.hilite(true);
                    _loc4.setFocus();
                    this.dispatchEvent({type: "onValidate", target: _loc4, error: true, msg: _loc2.msg});
                    return (false);
                } // end if
            } // end if
        } // end of for
        this.dispatchEvent({type: "onValidate", error: false});
        return (true);
    } // End of the function
    function resetHilites()
    {
        for (var _loc2 = 0; _loc2 < names_array.length; ++_loc2)
        {
            var _loc4 = names_array[_loc2];
            var _loc3 = target_mc[_loc4];
            _loc3.hilite(false);
        } // end of for
    } // End of the function
    function send(str)
    {
        for (var _loc2 in fields)
        {
            if (fields[_loc2].dontSend != true)
            {
                send_lv[_loc2] = de.argonauten.form.Form.trim(fields[_loc2].val);
            } // end if
        } // end of for...in
        var _loc3 = str.length ? (str) : (sendURL);
        if (_loc3.length)
        {
            send_lv.sendAndLoad(_loc3, rec_lv);
        } // end if
    } // End of the function
    function testServer(str)
    {
        if (this.validate())
        {
            for (var _loc2 in fields)
            {
                if (fields[_loc2].dontSend != true)
                {
                    send_lv[_loc2] = fields[_loc2].val;
                } // end if
            } // end of for...in
            this.debug();
            var _loc3 = str.length ? (str) : (sendURL);
            send_lv.send(_loc3, "_blank");
        } // end if
    } // End of the function
    function fakeServer(vars)
    {
        if (this.validate())
        {
            for (var _loc4 in fields)
            {
                if (fields[_loc4].dontSend != true)
                {
                    send_lv[_loc4] = fields[_loc4].val;
                } // end if
            } // end of for...in
            this.debug();
            var _loc3 = new LoadVars();
            for (var _loc4 in vars)
            {
                _loc3[_loc4] = vars[_loc4];
            } // end of for...in
            this.dispatchEvent({type: "onReply", target: this, result: _loc3});
        } // end if
    } // End of the function
    function debug()
    {
        trace ("send_lv:" + send_lv.toString());
        return (send_lv.toString());
    } // End of the function
    function onReply(success)
    {
        if (success)
        {
            this.dispatchEvent({type: "onReply", target: this, result: rec_lv});
        }
        else
        {
            this.dispatchEvent({type: "onReply", target: this, result: {noReply: true}});
        } // end else if
    } // End of the function
    static function checkEmail(s)
    {
        if (s.indexOf(" ") != -1)
        {
            return (false);
        } // end if
        for (var _loc1 = 0; _loc1 < s.length; ++_loc1)
        {
            if (s.charCodeAt(_loc1) > 127)
            {
                return (false);
            } // end if
        } // end of for
        var _loc4 = s.split("@");
        if (_loc4.length != 2 || _loc4[0].length < 1)
        {
            return (false);
        } // end if
        var _loc2 = _loc4[1].split(".");
        if (_loc2.length < 2)
        {
            return (false);
        } // end if
        if (_loc2[_loc2.length - 1].length < 2)
        {
            return (false);
        } // end if
        for (var _loc1 = 0; _loc1 < _loc2.length; ++_loc1)
        {
            if (_loc2[_loc1].length < 1)
            {
                return (false);
            } // end if
        } // end of for
        return (true);
    } // End of the function
    static function trim(str)
    {
        if (str == undefined || str == null)
        {
            return ("");
        } // end if
        for (var str = String(str); str.charAt(0) == " "; str = str.substring(1))
        {
        } // end of for
        while (str.charAt(str.length - 1) == " ")
        {
            str = str.substring(0, str.length - 1);
        } // end while
        return (str);
    } // End of the function
    static var compatibles = [de.argonauten.form.InputText, de.argonauten.form.SelectList, de.argonauten.form.RadioGroup, de.argonauten.form.CheckBox];
} // End of Class
