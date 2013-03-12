class de.argonauten.utils.logging.LogManager extends de.argonauten.utils.logging.LoggerAdapter
{
    var loggerList;
    static var instance;
    function LogManager()
    {
        super();
        loggerList = new Array();
    } // End of the function
    static function getInstance()
    {
        if (de.argonauten.utils.logging.LogManager.instance == undefined)
        {
            instance = new de.argonauten.utils.logging.LogManager();
        } // end if
        return (de.argonauten.utils.logging.LogManager.instance);
    } // End of the function
    function addLogger(logger)
    {
        if (de.argonauten.utils.helpers.ArrayUtils.contains(loggerList, logger) != -1)
        {
            return (false);
        } // end if
        hasLogger = true;
        loggerList.push(logger);
        return (true);
    } // End of the function
    function removeLogger(logger)
    {
        var _loc2 = de.argonauten.utils.helpers.ArrayUtils.contains(loggerList, logger);
        if (_loc2 == -1)
        {
            return (false);
        } // end if
        de.argonauten.utils.helpers.ArrayUtils.removeElement(loggerList, logger);
    } // End of the function
    function log(msg, level)
    {
        for (var _loc2 = 0; _loc2 < loggerList.length; ++_loc2)
        {
            var _loc3 = (de.argonauten.utils.logging.ILogger)(loggerList[_loc2]);
            _loc3.log(msg, level);
        } // end of for
    } // End of the function
    function inspectObject(obj, msg)
    {
        for (var _loc2 = 0; _loc2 < loggerList.length; ++_loc2)
        {
            var _loc3 = (de.argonauten.utils.logging.ILogger)(loggerList[_loc2]);
            _loc3.inspectObject(obj, msg);
        } // end of for
    } // End of the function
    static function $debug(msg)
    {
        if (de.argonauten.utils.logging.LogManager.hasLogger)
        {
            de.argonauten.utils.logging.LogManager.getInstance().debug(msg);
        } // end if
    } // End of the function
    static function $info(msg)
    {
        if (de.argonauten.utils.logging.LogManager.hasLogger)
        {
            de.argonauten.utils.logging.LogManager.getInstance().info(msg);
        } // end if
    } // End of the function
    static function $warning(msg)
    {
        if (de.argonauten.utils.logging.LogManager.hasLogger)
        {
            de.argonauten.utils.logging.LogManager.getInstance().warning(msg);
        } // end if
    } // End of the function
    static function $error(msg)
    {
        if (de.argonauten.utils.logging.LogManager.hasLogger)
        {
            de.argonauten.utils.logging.LogManager.getInstance().error(msg);
        } // end if
    } // End of the function
    static function $inspectObject(obj, msg)
    {
        if (de.argonauten.utils.logging.LogManager.hasLogger)
        {
            de.argonauten.utils.logging.LogManager.getInstance().inspectObject(obj, msg);
        } // end if
    } // End of the function
    static var hasLogger = false;
} // End of Class
