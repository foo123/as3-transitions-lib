function getInstancesInCurrentFrame(FILTER_LIBRARY_NAME){

	var elementList = new Array();
	var positionList=new Array();
	var t = fl.getDocumentDOM().getTimeline();
	var layer = t.layers.length;
	
	if(t.getSelectedFrames().length == 0){
		currentFrame = 0;
	}else{
		var currentFrame = Number(t.getSelectedFrames()[1]);
	}
	
	for(var i = 0; i < layer; i++){
		
		if(t.layers[i].frames[currentFrame] == undefined){
			continue;
		}
		
		var element_num = t.layers[i].frames[currentFrame].elements.length;
		
		for(var j = 0; j < element_num; j++){
			if(t.layers[i].frames[currentFrame].elements[j].elementType != "instance") continue;
			if(t.layers[i].frames[currentFrame].elements[j].libraryItem.itemType == "movie clip" &&
				t.layers[i].frames[currentFrame].elements[j].name == ""){
				t.layers[i].frames[currentFrame].elements[j].name="target_f"+currentFrame+"l"+i+"e"+j;
			}
			if(t.layers[i].frames[currentFrame].elements[j].libraryItem.itemType == "movie clip" &&
				t.layers[i].frames[currentFrame].elements[j].name != ""){
				elementList.push(t.layers[i].frames[currentFrame].elements[j].name);
				positionList.push(t.layers[i].frames[currentFrame].elements[j].left+"*"+t.layers[i].frames[currentFrame].elements[j].top+"*"+t.layers[i].frames[currentFrame].elements[j].width+"*"+t.layers[i].frames[currentFrame].elements[j].height);
			}
		}
	
	}
	
	return elementList.join(",")+"|"+positionList.join("&");
}

function getXY()
{
	var doc=fl.getDocumentDOM();
	if (!doc) return("false");
	if (doc.selection.length>0)
	{
		if (doc.selection[0] && doc.selection[0]!=null)
			return(doc.selection[0].left+","+doc.selection[0].top);
	}
	return("false");
}
