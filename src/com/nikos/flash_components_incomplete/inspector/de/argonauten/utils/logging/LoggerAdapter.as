class de.argonauten.utils.logging.LoggerAdapter extends /*implements*/ de.argonauten.utils.logging.ILogger
{
    var lineBreak;
    function LoggerAdapter()
    {
        lineBreak = "\n";
    } // End of the function
    function log(msg, level)
    {
    } // End of the function
    function debug(msg)
    {
        this.log(msg.toString(), de.argonauten.utils.logging.LogLevel.DEBUG);
    } // End of the function
    function info(msg)
    {
        this.log(msg.toString(), de.argonauten.utils.logging.LogLevel.INFO);
    } // End of the function
    function warning(msg)
    {
        this.log(msg.toString(), de.argonauten.utils.logging.LogLevel.WARNING);
    } // End of the function
    function error(msg)
    {
        this.log(msg.toString(), de.argonauten.utils.logging.LogLevel.ERROR);
    } // End of the function
    function inspectObject(obj, msg)
    {
        var indentLevel = -1;
        var indentString = "                                                                                      ";
        var lines = new Array();
        if (msg != undefined)
        {
            lines.push(msg);
        } // end if
        var ref = this;
        var _loc5 = function (id, localObj)
        {
            ++indentLevel;
            if (indentLevel <= ref.getNesting())
            {
                var _loc3 = typeof(localObj);
                if (_loc3 == "number" || _loc3 == "integer" || _loc3 == "string" || _loc3 == "boolean")
                {
                    lines.push(indentString.substr(0, indentLevel * 2) + id + ": " + localObj + " (" + typeof(localObj) + ")");
                }
                else if (_loc3 == "object" || _loc3 == "movieclip")
                {
                    lines.push(indentString.substr(0, indentLevel * 2) + id + " (" + typeof(localObj) + ")");
                    for (var _loc4 in localObj)
                    {
                        arguments.callee(_loc4, localObj[_loc4]);
                    } // end of for...in
                }
                else if (_loc3 == "function")
                {
                    lines.push(indentString.substr(0, indentLevel * 2) + id + " (" + typeof(localObj) + ")");
                } // end else if
                --indentLevel;
            }
            else
            {
                lines.push("NESTING TOO DEEP");
            } // end else if
        };
        if (obj != undefined)
        {
            for (var _loc7 in obj)
            {
                _loc5(_loc7, obj[_loc7]);
            } // end of for...in
        }
        else
        {
            lines.push("UNDEFINED");
        } // end else if
        var _loc8 = lines.join(lineBreak);
        this.debug(_loc8);
    } // End of the function
    function setNesting(nesting)
    {
        if (nesting > 0)
        {
            this.nesting = nesting;
        }
        else
        {
            this.warning("Invalid value for nesting depth: " + nesting.toString());
        } // end else if
    } // End of the function
    function getNesting()
    {
        return (nesting);
    } // End of the function
    var nesting = 5;
} // End of Class
