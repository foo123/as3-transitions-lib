class de.argonauten.gui.ScrollPane extends MovieClip
{
    var _width, w, _height, h, _xscale, _yscale, target_mc, _name, _parent, initOffset, guide_mc, createEmptyMovieClip, mask_mc, attachMovie, v_scroll_mc, h_scroll_mc, __get__scrollPercentageH, __get__scrollPercentageV;
    function ScrollPane()
    {
        super();
        w = _width;
        h = _height;
        _xscale = 100;
        _yscale = 100;
        this.init();
    } // End of the function
    function init(target_mc, innerMargin, scrollSpeed, scrollBarID_h, scrollBarID_v)
    {
        if (target_mc == undefined)
        {
            if (this.target_mc == undefined)
            {
                var _loc5 = _name.split("_");
                _loc5.pop();
                var _loc2 = _loc5.join("_");
                if (_parent[_loc2] instanceof MovieClip || _parent[_loc2] instanceof TextField)
                {
                    target_mc = _parent[_loc2];
                    this.target_mc = target_mc;
                } // end if
            } // end if
        }
        else
        {
            this.target_mc = target_mc;
        } // end else if
        if (initOffset == undefined)
        {
            initOffset = {x: this.target_mc._x, y: this.target_mc._y};
        }
        else
        {
            this.target_mc._x = initOffset.x;
            this.target_mc._y = initOffset.y;
        } // end else if
        innerMargin = innerMargin == undefined ? (de.argonauten.gui.ScrollPane.defaultInnerMargin) : (innerMargin);
        scrollSpeed = scrollSpeed == undefined ? (de.argonauten.gui.ScrollPane.defaultScrollSpeed) : (scrollSpeed);
        scrollBarID_h = scrollBarID_h == undefined ? (de.argonauten.gui.ScrollPane.defaultScrollBarID) : (scrollBarID_h);
        scrollBarID_v = scrollBarID_v == undefined ? (de.argonauten.gui.ScrollPane.defaultScrollBarID) : (scrollBarID_v);
        guide_mc._visible = false;
        mask_mc = this.createEmptyMovieClip("scroll_mask", 16000);
        this.drawRect(mask_mc, w, h, 16777215, 16777215, 100, 100, 1);
        this.target_mc.setMask(mask_mc);
        var _loc6 = {client: this.target_mc, referenceTL: mask_mc, pos: [w + 1, 0], useRefHeight: true, bottomMargin: 0, scrollSpeed: scrollSpeed, scrollDelay: 12, innerMargin: innerMargin};
        v_scroll_mc = /*(de.argonauten.gui.ScrollBar)*/(this.attachMovie(scrollBarID_v, "VscrollBar_mc", 15999, _loc6));
        this.setCorner();
    } // End of the function
    function refresh()
    {
        h_scroll_mc.init();
        v_scroll_mc.init();
        this.setCorner();
    } // End of the function
    function setCorner()
    {
        h_scroll_mc.corner_mc._visible = Boolean(h_scroll_mc._visible && v_scroll_mc._visible);
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
    function setHeight(height)
    {
        h = height;
    } // End of the function
    function setWidth(width)
    {
        w = width;
    } // End of the function
    function scrollToPercentage(dir, perc)
    {
        this[dir + "_scroll_mc"].scrollToPercentage(perc);
    } // End of the function
    function get scrollPercentageV()
    {
        //return (v_scroll_mc.scrollPercentage());
    } // End of the function
    function get scrollPercentageH()
    {
        //return (h_scroll_mc.scrollPercentage());
    } // End of the function
    static var defaultInnerMargin = 0;
    static var defaultScrollSpeed = 10;
    static var defaultScrollBarID = "scrollBar";
} // End of Class
