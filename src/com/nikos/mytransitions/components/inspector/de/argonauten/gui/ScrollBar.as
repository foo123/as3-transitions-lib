class de.argonauten.gui.ScrollBar extends MovieClip
{
    var axis, mouseListener, mc, _x, _y, _rotation, innerMargin, bottomMargin, clientOffset, client, localToGlobal, referenceTL, bounds, down_mc, btHeight, fullLength, useRefHeight, visibleLength, scrollLength, ratio, minClientPos, maxClientPos, _visible, up_mc, gotoAndStop, frameCount, bar_mc, bg_mc, _height, startDrag, stopDrag, corner_mc, dispatchEvent, __get__scrollPercentage;
    function ScrollBar()
    {
        super();
        mx.events.EventDispatcher.initialize(this);
        axis = axis == "x" ? (axis) : ("y");
        if (axis == "y")
        {
            mouseListener = new Object();
            mouseListener.mc = this;
            mouseListener.onMouseWheel = function (delta)
            {
                var _loc3 = mc;
                var _loc5 = _root._xmouse > _loc3.bounds.xMin && _root._xmouse < _loc3.bounds.xMax;
                var _loc4 = _root._ymouse > _loc3.bounds.yMin && _root._ymouse < _loc3.bounds.yMax;
                if (_loc5 && _loc4 && _loc3._visible)
                {
                    _loc3.scrollStep(delta * _loc3.scrollSpeed, _loc3);
                } // end if
            };
            Mouse.addListener(mouseListener);
        } // end if
        this.init();
    } // End of the function
    function init()
    {
        var mc = this;
        _x = pos[0];
        _y = pos[1];
        if (axis == "x")
        {
            _rotation = -90;
        } // end if
        innerMargin = innerMargin == undefined ? (0) : (innerMargin);
        bottomMargin = bottomMargin ? (bottomMargin) : (0);
        clientOffset = clientOffset == undefined ? ({x: client._x, y: client._y}) : (clientOffset);
        var _loc3 = {x: 0, y: 0};
        this.localToGlobal(_loc3);
        bounds = referenceTL.getBounds(_root);
        btHeight = down_mc._height;
        fullLength = axis == "y" ? (client._height + 2 * innerMargin) : (client._width + 2 * innerMargin);
        if (axis == "y")
        {
            visibleLength = useRefHeight ? (referenceTL._height) : (Math.min(fullLength, Stage.height - _loc3.y + referenceTL._y));
        }
        else
        {
            visibleLength = useRefHeight ? (referenceTL._width) : (Math.min(fullLength, Stage.width - _loc3.x + referenceTL._x));
        } // end else if
        scrollLength = visibleLength - 2 * btHeight - bottomMargin;
        ratio = fullLength / visibleLength;
        minClientPos = axis == "y" ? (clientOffset.y + innerMargin) : (clientOffset.x + innerMargin);
        maxClientPos = visibleLength - fullLength + minClientPos;
        _visible = Boolean(visibleLength < fullLength);
        client["_" + axis] = minClientPos;
        client.bounds = client.getBounds(referenceTL);
        up_mc.useHandCursor = false;
        up_mc._y = 0;
        up_mc.onPress = function ()
        {
            this.gotoAndStop(3);
            frameCount = 0;
            mc.scrollStep(mc.scrollSpeed, this);
            function onEnterFrame()
            {
                ++frameCount;
                if (frameCount > mc.scrollDelay)
                {
                    mc.scrollStep(mc.scrollSpeed, this);
                } // end if
            } // End of the function
        };
        down_mc.useHandCursor = false;
        down_mc._y = Math.floor(visibleLength - btHeight - bottomMargin - 1);
        down_mc.onPress = function ()
        {
            this.gotoAndStop(3);
            frameCount = 0;
            mc.scrollStep(-mc.scrollSpeed, this);
            function onEnterFrame()
            {
                ++frameCount;
                if (frameCount > mc.scrollDelay)
                {
                    mc.scrollStep(-mc.scrollSpeed, this);
                } // end if
            } // End of the function
        };
        up_mc.onRollOver = down_mc.onRollOver = bar_mc.onRollOver = bg_mc.onRollOver = function ()
        {
            this.gotoAndStop(2);
        };
        up_mc.onRollOut = down_mc.onRollOut = bar_mc.onRollOut = bg_mc.onRollOut = function ()
        {
            this.gotoAndStop(1);
        };
        up_mc.onRelease = up_mc.onReleaseOutside = down_mc.onRelease = down_mc.onReleaseOutside = function ()
        {
            this.gotoAndStop(2);
            onEnterFrame = undefined;
            mc.dispatchEvent({type: "onScrollEnd", target: mc});
        };
        bg_mc.useHandCursor = false;
        bg_mc._height = scrollLength;
        bg_mc._y = btHeight;
        bg_mc.onPress = function ()
        {
            this.gotoAndStop(3);
            if (mc._ymouse < mc.bar_mc._y)
            {
                mc.client["_" + mc.axis] = Math.min(mc.client["_" + mc.axis] + mc.scrollLength, mc.minClientPos);
            }
            else
            {
                mc.client["_" + mc.axis] = Math.max(mc.client["_" + mc.axis] - mc.scrollLength, mc.maxClientPos);
            } // end else if
            mc.setBar();
            mc.dispatchEvent({type: "onScrollStep", target: mc});
        };
        bg_mc.onRelease = bg_mc.onReleaseOutside = function ()
        {
            this.gotoAndStop(1);
            mc.dispatchEvent({type: "onScrollEnd", target: mc});
        };
        bar_mc._y = btHeight;
        var _loc4 = Math.floor(scrollLength / ratio) - 1;
        bar_mc.middle_mc._y = bar_mc.header_mc._y + bar_mc.header_mc._height;
        bar_mc.middle_mc._height = _loc4 - bar_mc.header_mc._height - bar_mc.buttom_mc._height;
        bar_mc.buttom_mc._y = bar_mc.middle_mc._y + bar_mc.middle_mc._height;
        bar_mc.useHandCursor = true;
        bar_mc.onPress = function ()
        {
            this.gotoAndStop(3);
            var _loc2 = this;
            this.startDrag(false, _x, mc.btHeight, _x, mc.btHeight + mc.scrollLength - _height - 2);
            mc.client.onMouseMove = function ()
            {
                mc.setClient();
                updateAfterEvent();
            };
            mc.dispatchEvent({type: "onScrollStep", target: mc});
        };
        bar_mc.onRelease = bar_mc.onReleaseOutside = function ()
        {
            this.gotoAndStop(1);
            this.stopDrag();
            mc.client.onMouseMove = undefined;
            mc.dispatchEvent({type: "onScrollEnd", target: mc});
        };
        corner_mc._x = down_mc._x;
        corner_mc._y = down_mc._y + down_mc._height;
        corner_mc._visible = false;
    } // End of the function
    function scrollStep(step, sender)
    {
        var _loc2 = Math.round(client["_" + axis] + step);
        if (_loc2 >= minClientPos)
        {
            _loc2 = minClientPos;
            sender.onEnterFrame = undefined;
        }
        else if (_loc2 <= maxClientPos)
        {
            _loc2 = maxClientPos;
            sender.onEnterFrame = undefined;
        } // end else if
        client["_" + axis] = _loc2;
        this.setBar();
        this.dispatchEvent({type: "onScrollStep", target: this});
    } // End of the function
    function setBar()
    {
        if (axis == "y")
        {
            bar_mc._y = Math.round(scrollLength * (client._y - clientOffset.y - innerMargin) / -fullLength + btHeight);
        }
        else
        {
            bar_mc._y = Math.round(scrollLength * (client._x - clientOffset.x - innerMargin) / -fullLength + btHeight);
        } // end else if
        updateAfterEvent();
    } // End of the function
    function setClient()
    {
        if (axis == "y")
        {
            client._y = Math.round(Math.min((bar_mc._y - btHeight) * fullLength / -scrollLength, 0) + minClientPos);
        }
        else
        {
            client._x = Math.round(Math.min((bar_mc._y - btHeight - 1) * fullLength / -scrollLength, 0) + minClientPos);
        } // end else if
        updateAfterEvent();
    } // End of the function
    function scrollToPercentage(perc)
    {
        var _loc2 = visibleLength / 2;
        var _loc5 = Math.abs(maxClientPos - minClientPos) + visibleLength;
        var _loc3 = _loc5 / 100 * perc - _loc2;
        var _loc4 = Math.round(Math.min(Math.max(-_loc3 + clientOffset[axis], maxClientPos), minClientPos));
        client["_" + axis] = _loc4;
        this.setBar();
    } // End of the function
    function get scrollPercentage()
    {
        var _loc2 = visibleLength / 2;
        var _loc3 = Math.abs(maxClientPos - minClientPos) + visibleLength;
        var _loc4 = Math.round((clientOffset[axis] - client["_" + axis] + _loc2) * 100 / _loc3);
        return (_loc4);
    } // End of the function
    var pos = [0, 0];
} // End of Class
