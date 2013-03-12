/*
USAGE:
    myMC.bringToFront();
    myMC.bringToFront({protect:[myMC2, myMC3]});

    The second form allows you to protect certain movieclips from having
    their stacking order affected. This is useful if you have some movieclips
    you want to stay in front of everything else. You pass the actual
    movieclip objects, not a string of the movieclip name.
*/

MovieClip.prototype.bringToFront = function(optionsObj:Object):Void{
    // define an array to hold a snapshot of the display list
    var displayList:Array = new Array();

    // traverse the current parent object's children
    for (var i:String in this._parent){
        // and only capture movieclips (not other properties) whose depth is greater than
        // the movieclip we're bringing to the front.
        // the _parent == this._parent is there to get around a strange bug I encountered
        // where we were digging into children's descendants. don't know why.
        if (typeof (this._parent[i]) == "movieclip"
                                    && this._parent[i]._parent == this._parent
                                    && this._parent[i].getDepth() > this.getDepth()){

            var includeItem:Boolean = true;
            // check to make sure this item is not one of the "protected" items
            for (var j:Number = 0; j < optionsObj.protect.length; j++){
                if (this._parent[i] == optionsObj.protect[j]){
                    includeItem = false;
                    break;
                }
            }

            // store it in the array.
            if (includeItem) displayList.push(this._parent[i]);
        }
    }

    // for (x in y) usually traverses the object backwards, so here we're
    // iterating over displayList in reverse, and just swapping the
    // original object's depth all the way up the list. Can't really think
    // of a more efficient way of doing this.
    for (var i:Number = displayList.length-1; i>=0; i--){
        this.swapDepths(displayList[i]);
    }
}