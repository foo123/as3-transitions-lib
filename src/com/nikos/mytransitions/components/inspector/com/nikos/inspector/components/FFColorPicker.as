class com.nikos.inspector.components.FFColorPicker extends com.nikos.inspector.components.FFComponent
{
    var _copy_tf, _copy, _color_tf, _tf_bg_mc, _showColor_mc, _varName, _inspector, cp, createEmptyMovieClip, buffer, _bg_middle_mc, _bg_right_mc, getNextHighestDepth, attachMovie, _cross_mc, _xmouse, _ymouse;
    function FFColorPicker()
    {
        super();
    } // End of the function
    function init(inspector, varName, varValue, copy)
    {
        super.init(inspector, varName, varValue, copy);
        _copy_tf.text = _copy;
        _copy_tf.autoSize = true;
        _color_tf.text = varValue;
        _color_tf.restrict = "0-9a-fA-F#";
        _color_tf._x = _copy_tf._x + _copy_tf._width + 5;
        _tf_bg_mc._x = _color_tf._x - 2;
        _tf_bg_mc._y = 3;
        _showColor_mc._x = _tf_bg_mc._x + _tf_bg_mc._width + 10;
        _showColor_mc._y = _tf_bg_mc._y - 1;
        _color_tf.text = this.formatColor(Number(varValue));
        _color_tf.onChanged = mx.utils.Delegate.create(this, onChangeTf);
        _color_tf.onKillFocus = mx.utils.Delegate.create(this, onKillFocusTf);
        this.setColorDisplay(Number(varValue));
    } // End of the function
    function onChangeTf()
    {
        var _loc2 = _color_tf.text;
        if (_loc2.charAt(0) == "#")
        {
            _loc2 = _loc2.slice(1);
        } // end if
        var _loc3 = parseInt("0x" + this.addMissingZeros(_loc2));
        this.setColorDisplay(_loc3);
        _inspector.setFilterVar(_varName, _loc3);
    } // End of the function
    function onKillFocusTf()
    {
        var _loc2 = _color_tf.text;
        if (_loc2.charAt(0) == "#")
        {
            _loc2 = _loc2.slice(1);
        } // end if
        _loc2 = this.addMissingZeros(_loc2);
        if (_loc2.charAt(0) != "#")
        {
            _loc2 = "#" + _loc2.toUpperCase();
        } // end if
        _color_tf.text = _loc2;
    } // End of the function
    function onStageChange(cw, ch)
    {
        this.buildColorPicker(cw, ch);
    } // End of the function
    function buildColorPicker(cw, ch)
    {
        cp = new Object();
        var _loc4 = cw - 12 - 2 - 2;
        cp.width = _loc4;
        cp.height = 27;
        cp.colors = [16711680, 16711935, 255, 65535, 65280, 16776960, 16711680];
        cp.alphas = new Array(cp.colors.length);
        cp.ratios = new Array(cp.colors.length);
        cp.matrix = {matrixType: "box", x: 0, y: 0, w: cp.width, h: cp.height, r: 3.141593E+000};
        cp.matrix2 = {matrixType: "box", x: 0, y: 0, w: cp.width, h: cp.height, r: 4.712389E+000};
        for (var _loc2 = 0; _loc2 < cp.colors.length; ++_loc2)
        {
            cp.alphas[_loc2] = 100;
            cp.ratios[_loc2] = 255 / (cp.colors.length - 1) * _loc2;
        } // end of for
        buffer = this.createEmptyMovieClip("__buffer", 1);
        var _loc3 = buffer.createEmptyMovieClip("gradient", 1);
        var _loc5 = buffer.createEmptyMovieClip("gray", 2);
        _loc3.clear();
        _loc5.clear();
        _loc3.beginGradientFill("linear", cp.colors, cp.alphas, cp.ratios, cp.matrix);
        _loc3.lineTo(cp.width, 0);
        _loc3.lineTo(cp.width, cp.height);
        _loc3.lineTo(0, cp.height);
        _loc3.lineTo(0, 0);
        _loc3.endFill();
        _loc3.beginFill(16777215, 100);
        _loc3.moveTo(_loc4 - 24, 0);
        _loc3.lineTo(_loc4, 0);
        _loc3.lineTo(_loc4, 13);
        _loc3.lineTo(_loc4 - 24, 13);
        _loc3.lineTo(_loc4 - 24, 0);
        _loc3.endFill();
        _loc3.endFill();
        _loc3.beginFill(0, 100);
        _loc3.moveTo(_loc4 - 24, 13);
        _loc3.lineTo(_loc4, 13);
        _loc3.lineTo(_loc4, 27);
        _loc3.lineTo(_loc4 - 24, 27);
        _loc3.lineTo(_loc4 - 24, 13);
        _loc3.endFill();
        _loc5.beginGradientFill("linear", [0, 8421504, 16777215], [100, 0, 100], [0, 128, 255], cp.matrix2);
        _loc5.lineTo(cp.width - 24, 0);
        _loc5.lineTo(cp.width - 24, cp.height);
        _loc5.lineTo(0, cp.height);
        _loc5.lineTo(0, 0);
        _loc5.endFill();
        buffer.cacheAsBitmap = true;
        cp.bmp = new flash.display.BitmapData(cp.width, cp.height, false, 0);
        cp.bmp.draw(buffer, new flash.geom.Matrix(), new flash.geom.ColorTransform());
        var _loc6 = new flash.display.BitmapData(24, 13, false, 16777215);
        var _loc7 = new flash.display.BitmapData(24, 14, false, 0);
        cp.bmp.copyPixels(_loc6, new flash.geom.Rectangle(0, 0, 24, 13), new flash.geom.Point(_loc4, 0));
        cp.bmp.copyPixels(_loc7, new flash.geom.Rectangle(0, 0, 24, 13), new flash.geom.Point(_loc4, 13));
        buffer.onRollOver = mx.utils.Delegate.create(this, onBufferOver);
        buffer.onRollOut = mx.utils.Delegate.create(this, onBufferOut);
        buffer.onRelease = mx.utils.Delegate.create(this, onBufferClick);
        buffer._x = 2;
        buffer._y = 23;
        _bg_middle_mc._x = 3;
        _bg_middle_mc._width = _loc4 - 1;
        _bg_right_mc._x = _loc4;
    } // End of the function
    function onBufferOver()
    {
        _cross_mc = this.attachMovie("cross_mc", "cross_mc", this.getNextHighestDepth());
        _cross_mc.onEnterFrame = mx.utils.Delegate.create(this, crossOnEnterFrame);
        this.crossOnEnterFrame();
        Mouse.hide();
    } // End of the function
    function crossOnEnterFrame()
    {
        _cross_mc._x = _xmouse;
        _cross_mc._y = _ymouse;
    } // End of the function
    function onBufferOut()
    {
        _cross_mc.removeMovieClip();
        Mouse.show();
    } // End of the function
    function onBufferClick()
    {
        var _loc2;
        var _loc4 = buffer._xmouse;
        var _loc3 = buffer._ymouse;
        if (_loc4 >= 0 && _loc4 <= cp.width && _loc3 >= 0 && _loc3 <= cp.height)
        {
            var _loc6 = _loc4 | 0;
            var _loc5 = _loc3 | 0;
            _loc2 = cp.bmp.getPixel(_loc6, _loc5);
            var _loc7 = (_loc2 & 16711680) >> 16;
            var _loc9 = (_loc2 & 65280) >> 8;
            var _loc8 = _loc2 & 255;
            _color_tf.text = this.formatColor(_loc2);
            this.setColorDisplay(_loc2);
            _inspector.setFilterVar(_varName, _loc2);
        } // end if
    } // End of the function
    function formatColor(c)
    {
        var _loc4 = c.toString(16);
        var _loc2 = 6 - _loc4.length;
        if (_loc2 >= 1)
        {
            var _loc3 = "";
            for (var _loc1 = 0; _loc1 < _loc2; ++_loc1)
            {
                _loc3 = _loc3 + "0";
            } // end of for
            _loc4 = _loc3 + _loc4;
        } // end if
        var _loc5 = "#" + _loc4.toUpperCase();
        return (_loc5);
    } // End of the function
    function addMissingZeros(s)
    {
        var _loc2 = 6 - s.length;
        if (_loc2 >= 1)
        {
            var _loc3 = "";
            for (var _loc1 = 0; _loc1 < _loc2; ++_loc1)
            {
                _loc3 = _loc3 + "0";
            } // end of for
            s = _loc3 + s;
        } // end if
        return (s);
    } // End of the function
    function setColorDisplay(c)
    {
        var _loc3 = new flash.display.BitmapData(21, 10, false, c);
        var _loc2 = _showColor_mc.createEmptyMovieClip("cmc", 1);
        _loc2._x = 3;
        _loc2._y = 3;
        _loc2.attachBitmap(_loc3, 1);
    } // End of the function
} // End of Class
