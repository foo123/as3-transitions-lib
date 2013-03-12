function getInstancesInCurrentFrame(FILTER_LIBARY_NAME){

	elementList = new Array();
	
	t = fl.getDocumentDOM().getTimeline();
	
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
				t.layers[i].frames[currentFrame].elements[j].name=FILTER_LIBRARY_NAME+"_MovieClipInstance_"+i+""+_j;
			}
			if(t.layers[i].frames[currentFrame].elements[j].libraryItem.itemType == "movie clip" &&
				t.layers[i].frames[currentFrame].elements[j].name != ""){
				elementList.push(t.layers[i].frames[currentFrame].elements[j].name);
			}
		}
	
	}
	
	return elementList.join(",");

}

/*function getCurrentMC()
{
	var doc = fl.getDocumentDOM();
	var mc = doc.selection[0];//get the mc
}*/

function checkVersion()
{
  var v = parseInt(fl.version.split(" ")[1].split(",")[0]);
  if(v >= 9)
  {
    var dom = fl.getDocumentDOM();
    var filterName = dom.selection[0].libraryItem.name;
    var filterVersion = parseInt(filterName.charAt(filterName.length-1));
    if(filterVersion == 2 && dom.asVersion != 2)
    {
      alert("This filter version only works with ActionScript 2.0 Projects.\n\nSet the export settings to ActionScript 2.0 or get the\nActionScript 3.0 version from flash-filter.net")
    }
    else if(filterVersion == 3 && dom.asVersion != 3)
    {
      alert("This filter version only works with ActionScript 3.0 Projects.\n\nSet the export settings to ActionScript 3.0 or get the\nActionScript 2.0 version from flash-filter.net")
    }
  }
}

function getVersion()
{
  return fl.version;
}

function checkRescale(mc_name){

	elementList = new Array();
	
	t = fl.getDocumentDOM().getTimeline();
	
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
				t.layers[i].frames[currentFrame].elements[j].name == mc_name){
          if(t.layers[i].frames[currentFrame].elements[j].scaleX != 1 || t.layers[i].frames[currentFrame].elements[j].scaleY != 1){
            alert("Script detected that Movieclip "+mc_name+" is scaled.\n\nMake sure, that the Movieclip has a scale of\n100.0% x 100.0% to avoid rendering problems.")
          }
			}
		}
	
	}

}


function testMovie(){

	fl.getDocumentDOM().testMovie();

}