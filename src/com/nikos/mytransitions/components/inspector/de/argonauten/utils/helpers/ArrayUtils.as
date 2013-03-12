class de.argonauten.utils.helpers.ArrayUtils
{
    function ArrayUtils()
    {
    } // End of the function
    static function contains(source, element)
    {
        for (var _loc1 = 0; _loc1 < source.length; ++_loc1)
        {
            if (source[_loc1] == element)
            {
                return (_loc1);
            } // end if
        } // end of for
        return (-1);
    } // End of the function
    static function removeElement(source, element)
    {
        var _loc3 = new Array();
        for (var _loc1 = 0; _loc1 < source.length; ++_loc1)
        {
            if (source[_loc1] != element)
            {
                _loc3.push(source[_loc1]);
            } // end if
        } // end of for
        return (_loc3);
    } // End of the function
} // End of Class
