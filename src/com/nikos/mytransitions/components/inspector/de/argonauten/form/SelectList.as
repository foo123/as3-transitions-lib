class de.argonauten.form.SelectList extends de.argonauten.form.UIComponent
{
    var __get__maxHeight, __set__maxHeight, TF, _guide_txt, _openDir, _enabled, selectList_bg, width, height, bt, createTextField, displayTF, _embedFonts, __set__topText, selectedValue, hilite, focus_mc, onKeyOpenListener, ref, mouseListener, list, dispatchEvent, __get__topText, _maxHeight, __get__openDir, mouseOverEnabled, createEmptyMovieClip, listCont_mc, mask_mc, _parent, scroll_mc, gotoAndPlay, hilite_mc, __get__enabled, onMouseUp, hilite_i, tabIndex, onKeyDown, __get__embedFonts, __set__embedFonts, __set__enabled, __set__openDir;
    function SelectList()
    {
        super();
        this.__set__maxHeight(this.__get__maxHeight() ? (this.__get__maxHeight()) : (de.argonauten.form.SelectList.defaultMaxHeight));
        if (!TF)
        {
            TF = _guide_txt.getTextFormat();
        } // end if
        _guide_txt._visible = false;
        _openDir = _openDir ? (_openDir) : (de.argonauten.form.SelectList.defaultOpenDir);
        _enabled = _enabled == undefined ? (true) : (_enabled);
        width = selectList_bg._width;
        height = selectList_bg._height;
        this.createTextField("displayTF", 0, de.argonauten.form.SelectList.tfIndent, 0, bt._x - de.argonauten.form.SelectList.tfIndent, height);
        displayTF.selectable = false;
        _embedFonts = false;
        displayTF.setNewTextFormat(TF);
        this.__set__topText(de.argonauten.form.SelectList.defaultTopText);
        selectedValue = undefined;
        this.hilite(false);
        focus_mc._visible = false;
        onKeyOpenListener = {ref: this};
        onKeyOpenListener.onKeyDown = function ()
        {
            ref.onKeyOpen();
        };
        mouseListener = {ref: this};
        mouseListener.onMouseMove = function ()
        {
            ref.mouseOverEnabled = true;
            Mouse.removeListener(this);
        };
        this.close();
    } // End of the function
    function setValues(li)
    {
        if (typeof(li[0]) == "string")
        {
            var _loc6 = [];
            for (var _loc2 = 0; _loc2 < li.length; ++_loc2)
            {
                _loc6[_loc2] = {text: li[_loc2], value: li[_loc2]};
            } // end of for
            list = _loc6;
        }
        else
        {
            list = li;
            for (var _loc7 in list)
            {
                if (list[_loc7].value == undefined)
                {
                    list[_loc7].value = list[_loc7].text;
                } // end if
            } // end of for...in
        } // end else if
    } // End of the function
    function getValues()
    {
        return (list);
    } // End of the function
    function addToValues(entry, sel)
    {
        if (!list)
        {
            list = [];
        } // end if
        list.push(entry);
        if (sel)
        {
            this.select(entry);
        } // end if
    } // End of the function
    function setValue(v)
    {
        for (var _loc3 in list)
        {
            if (list[_loc3].value == v)
            {
                this.select(list[_loc3]);
                return;
            } // end if
        } // end of for...in
    } // End of the function
    function getValue()
    {
        return (selectedValue);
    } // End of the function
    function selectByID(id)
    {
        this.select(list[id]);
    } // End of the function
    function selectByText(str)
    {
        for (var _loc3 in list)
        {
            if (list[_loc3].text == str)
            {
                this.select(list[_loc3]);
                return (true);
            } // end if
        } // end of for...in
        return (false);
    } // End of the function
    function select(item)
    {
        this.__set__topText(item.text);
        selectedValue = item.value;
        this.close();
        this.hilite(false);
        this.dispatchEvent({type: "onChange", target: this});
    } // End of the function
    function set topText(txt)
    {
        displayTF.text = txt;
        //return (this.topText());
        null;
    } // End of the function
    function get topText()
    {
        return (displayTF.text);
    } // End of the function
    function set maxHeight(h)
    {
        _maxHeight = h;
        //return (this.maxHeight());
        null;
    } // End of the function
    function get maxHeight()
    {
        return (_maxHeight);
    } // End of the function
    function set openDir(d)
    {
        _openDir = d;
        //return (this.openDir());
        null;
    } // End of the function
    function get openDir()
    {
        return (_openDir);
    } // End of the function
    function open()
    {
         this.dispatchEvent({type: "onOpen", target: this});
		var currentObject = this;
        mouseOverEnabled = true;
        var _loc11 = this.__get__openDir() == "up" ? (-1) : (1);
        var _loc10 = height * list.length;
        var _loc8 = Math.min(_loc10, height * this.__get__maxHeight());
        listCont_mc = this.createEmptyMovieClip("listCont_mc", 1);
        listCont_mc._y = _loc11 == 1 ? (height) : (-_loc8);
        mask_mc = listCont_mc.createEmptyMovieClip("mask_mc", 3);
        this.drawRect(mask_mc, width, _loc8, 0, 16777215, 100, 100, 1);
        mask_mc._y = 1;
        var _loc7 = listCont_mc.createEmptyMovieClip("list_mc", 2);
        var _loc9 = listCont_mc.createEmptyMovieClip("bg", 1);
        this.drawRect(_loc9, width - 1, _loc8 + 1, de.argonauten.form.SelectList.strokeColor, de.argonauten.form.SelectList.bgColor, 100, 100, 1);
        _loc7.setMask(mask_mc);
        for (var _loc2 = 0; _loc2 < list.length; ++_loc2)
        {
            var _loc3 = _loc7.createEmptyMovieClip("select" + _loc2, _loc2 + 2);
            _loc3.item = list[_loc2];
            _loc3._y = height * _loc2;
            var _loc5 = _loc3.createEmptyMovieClip("bt", 0);
            this.drawRect(_loc5, width - 1, height, 16777215, 16777215, 0, 0, 1);
            _loc5.onRollOver = function ()
            {
                if (currentObject.mouseOverEnabled)
                {
                    currentObject.clearHiliteElement();
                    currentObject.activateMouseUp(false);
                    _parent.bg._visible = true;
                } // end if
            };
            _loc5.onRollOut = function ()
            {
                if (currentObject.mouseOverEnabled)
                {
                    currentObject.activateMouseUp(true);
                    _parent.bg._visible = false;
                } // end if
            };
            _loc5.onRelease = function ()
            {
                currentObject.select(_parent.item);
            };
            var _loc6 = _loc3.createEmptyMovieClip("bg", 1);
            this.drawRect(_loc6, width - 2, height, de.argonauten.form.SelectList.rollOverColor, de.argonauten.form.SelectList.rollOverColor, 100, 100, 1);
            _loc6._x = 1;
            _loc6._visible = false;
            _loc3.createTextField("tf" + _loc2, 2, de.argonauten.form.SelectList.tfIndent, 0, width - de.argonauten.form.SelectList.tfIndent, 0);
            var _loc4 = _loc3["tf" + _loc2];
            _loc4.embedFonts = _embedFonts;
            _loc4.autoSize = TF.align ? (TF.align) : ("left");
            _loc4.selectable = false;
            _loc4.setNewTextFormat(TF);
            _loc4.text = _loc3.item.text;
            _loc4._visible = true;
        } // end of for
        bt.onRelease = selectList_bg.onRelease = function ()
        {
            currentObject.close();
        };
        bt.onRollOver = selectList_bg.onRollOver = function ()
        {
            currentObject.activateMouseUp(false);
        };
        bt.onRollOut = selectList_bg.onRollOut = function ()
        {
            currentObject.activateMouseUp(true);
        };
        var _loc12 = {client: _loc7, referenceTL: mask_mc, pos: [width - de.argonauten.form.SelectList.scrollBarWidth, 1], useRefHeight: true, bottomMargin: 1, scrollSpeed: height, scrollDelay: 12};
        scroll_mc = listCont_mc.attachMovie("scrollBar", "scrollBar_mc", 200, _loc12);
        scroll_mc.addEventListener("onScrollStep", this);
        scroll_mc.addEventListener("onScrollEnd", this);
        Key.addListener(onKeyOpenListener);
    } // End of the function
    function set enabled(arg)
    {
        _enabled = arg;
        bt.enabled = arg;
        selectList_bg.enabled = arg;
        hilite_mc._visible = false;
        //return (this.enabled());
        this.gotoAndPlay(arg ? ("active") : ("disabled"));
    } // End of the function
    function get enabled()
    {
        return (_enabled);
    } // End of the function
    function close()
    {
        listCont_mc.removeMovieClip();
        bt.onRelease = selectList_bg.onRelease = function ()
        {
            _parent.open();
        };
        onMouseUp = undefined;
        Key.removeListener(onKeyOpenListener);
        Mouse.removeListener(mouseListener);
        hilite_i = undefined;
    } // End of the function
    function onScrollStep(e)
    {
        this.activateMouseUp(false);
    } // End of the function
    function onScrollEnd(e)
    {
        this.activateMouseUp(true);
    } // End of the function
    function activateMouseUp(enable)
    {
        if (enable)
        {
            onMouseUp = mx.utils.Delegate.create(this, close);
        }
        else
        {
            delete this.onMouseUp;
        } // end else if
    } // End of the function
    function setTab(tab)
    {
        tabIndex = tab;
    } // End of the function
    function setFocus()
    {
        Selection.setFocus(this);
    } // End of the function
    function onSetFocus(oldFocus)
    {
        focus_mc._visible = true;
        onKeyDown = onKey;
    } // End of the function
    function onKillFocus(newFocus)
    {
        focus_mc._visible = false;
        delete this.onKeyDown;
    } // End of the function
    function onKey()
    {
        if (!this.__get__enabled())
        {
            return;
        } // end if
        var _loc3;
        for (var _loc2 = 0; _loc2 < list.length; ++_loc2)
        {
            if (list[_loc2].text == this.__get__topText())
            {
                _loc3 = _loc2;
                break;
            } // end if
        } // end of for
        if (Key.isDown(40) || Key.isDown(38))
        {
            if (_loc3 == undefined)
            {
                _loc3 = 0;
            }
            else if (Key.isDown(40))
            {
                _loc3 = _loc3 >= list.length - 1 ? (list.length - 1) : (_loc3 + 1);
            }
            else if (Key.isDown(38))
            {
                _loc3 = _loc3 <= 1 ? (0) : (_loc3 - 1);
            } // end else if
            this.selectByID(_loc3);
        }
        else if (Key.getAscii() >= 97 && Key.getAscii() <= 122)
        {
            var _loc4 = String.fromCharCode(Key.getAscii());
            for (var _loc2 = _loc3 + 1; _loc2 < list.length; ++_loc2)
            {
                if (list[_loc2].text.charAt(0).toLowerCase() == _loc4)
                {
                    this.select(list[_loc2]);
                    return;
                } // end if
            } // end of for
            for (var _loc2 = 0; _loc2 < _loc3; ++_loc2)
            {
                if (list[_loc2].text.charAt(0).toLowerCase() == _loc4)
                {
                    this.select(list[_loc2]);
                    return;
                } // end if
            } // end of for
        }
        else if (Key.isDown(13))
        {
            this.open();
        } // end else if
    } // End of the function
    function onKeyOpen()
    {
        if (Key.isDown(40) || Key.isDown(38))
        {
            if (hilite_i == undefined)
            {
                hilite_i = 0;
            }
            else if (Key.isDown(40))
            {
                hilite_i = hilite_i >= list.length - 1 ? (list.length - 1) : (hilite_i + 1);
            }
            else if (Key.isDown(38))
            {
                hilite_i = hilite_i <= 1 ? (0) : (hilite_i - 1);
            } // end else if
            this.hiliteElement(hilite_i);
        }
        else if (Key.getAscii() >= 97 && Key.getAscii() <= 122)
        {
            var _loc3 = String.fromCharCode(Key.getAscii());
            if (hilite_i == undefined)
            {
                for (var _loc2 = 0; _loc2 < list.length; ++_loc2)
                {
                    if (list[_loc2].text.charAt(0).toLowerCase() == _loc3)
                    {
                        this.hiliteElement(_loc2);
                        return;
                    } // end if
                } // end of for
            }
            else
            {
                for (var _loc2 = hilite_i + 1; _loc2 < list.length; ++_loc2)
                {
                    if (list[_loc2].text.charAt(0).toLowerCase() == _loc3)
                    {
                        this.hiliteElement(_loc2);
                        return;
                    } // end if
                } // end of for
                for (var _loc2 = 0; _loc2 < hilite_i; ++_loc2)
                {
                    if (list[_loc2].text.charAt(0).toLowerCase() == _loc3)
                    {
                        this.hiliteElement(_loc2);
                        return;
                    } // end if
                } // end of for
            } // end else if
        }
        else if (Key.isDown(13))
        {
            if (hilite_i != undefined)
            {
                this.select(list[hilite_i]);
            } // end else if
        } // end else if
    } // End of the function
    function hiliteElement(num)
    {
        this.clearHiliteElement();
        listCont_mc.list_mc["select" + hilite_i].bg._visible = false;
        listCont_mc.list_mc["select" + num].bg._visible = true;
        hilite_i = num;
        if (scroll_mc._visible)
        {
            var _loc3 = num / list.length * 100;
            mouseOverEnabled = false;
            scroll_mc.scrollToPercentage(_loc3);
            Mouse.addListener(mouseListener);
        } // end if
    } // End of the function
    function clearHiliteElement()
    {
        for (var _loc2 = 0; _loc2 < list.length; ++_loc2)
        {
            listCont_mc.list_mc["select" + _loc2].bg._visible = false;
        } // end of for
        hilite_i = undefined;
    } // End of the function
    function set embedFonts(b)
    {
        displayTF.embedFonts = b;
        _embedFonts = b;
        //return (this.embedFonts());
        null;
    } // End of the function
    function get embedFonts()
    {
        return (_embedFonts);
    } // End of the function
    function drawRect(mc, w, h, lineColor, fillColor, lineAlpha, fillAlpha, lineThick)
    {
        mc.clear();
        mc.lineStyle(lineThick, lineColor, lineAlpha);
        mc.beginFill(fillColor, fillAlpha);
        mc.lineTo(w, 0);
        mc.lineTo(w, h);
        mc.lineTo(0, h);
        mc.lineTo(0, 0);
        mc.endFill();
    } // End of the function
    static var bgColor = 16777215;
    static var strokeColor = 12763842;
    static var rollOverColor = 15329769;
    static var defaultMaxHeight = 6;
    static var scrollBarWidth = 15;
    static var tfIndent = 2;
    static var defaultTopText = " ... ";
    static var defaultOpenDir = "down";
} // End of Class
