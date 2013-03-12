//If the browser is W3 DOM compliant, execute setImageSwaps function
if (document.getElementsByTagName && document.getElementById) {
if (window.addEventListener) window.addEventListener('load', setImageSwaps, false);
else if (window.attachEvent) window.attachEvent('onload', setImageSwaps);
}

//When document loads, apply the prepareImageSwap function to various images with our desired settings
function setImageSwaps() {
//Mousedown, restore - for images in container with ID=example2
prepareImageSwap('example2',true,true,true,true);
//Hover, mousedown, no restore - for images in container with ID=example3
prepareImageSwap('example3',true,false,true,false);
//Hover with restore, most basic usage - for any image in document.body that are not yet processed (function accepts elements,too)
prepareImageSwap(document.body);
//Note that once an image is processed, it won't be processed again, so you should set more specific images first, e.g. document.body, as it is the grand
//container, has to be processed last.
}


//The following is the function that do the actual job

function prepareImageSwap(elem,mouseOver,mouseOutRestore,mouseDown,mouseUpRestore,mouseOut,mouseUp) {
//Do not delete these comments.
//Non-Obtrusive Image Swap Script by Hesido.com
//V1.1
//Attribution required on all accounts
	if (typeof(elem) == 'string') elem = document.getElementById(elem);
	if (elem == null) return;
	var regg = /(.*)(_nm\.)([^\.]{3,4})$/
	var prel = new Array(), img, imgList, imgsrc, mtchd;
	imgList = elem.getElementsByTagName('img');

	for (var i=0; img = imgList[i]; i++) {
		if (!img.rolloverSet && img.src.match(regg)) {
			mtchd = img.src.match(regg);
			img.hoverSRC = mtchd[1]+'_hv.'+ mtchd[3];
			img.outSRC = img.src;
			if (typeof(mouseOver) != 'undefined') {
				img.hoverSRC = (mouseOver) ? mtchd[1]+'_hv.'+ mtchd[3] : false;
				img.outSRC = (mouseOut) ? mtchd[1]+'_ou.'+ mtchd[3] : (mouseOver && mouseOutRestore) ? img.src : false;
				img.mdownSRC = (mouseDown) ? mtchd[1]+'_md.' + mtchd[3] : false;
				img.mupSRC = (mouseUp) ? mtchd[1]+'_mu.' + mtchd[3] : (mouseOver && mouseDown && mouseUpRestore) ? img.hoverSRC : (mouseDown && mouseUpRestore) ? img.src : false;
				}
			if (img.hoverSRC) {preLoadImg(img.hoverSRC); img.onmouseover = imgHoverSwap;}
			if (img.outSRC) {preLoadImg(img.outSRC); img.onmouseout = imgOutSwap;}
			if (img.mdownSRC) {preLoadImg(img.mdownSRC); img.onmousedown = imgMouseDownSwap;}
			if (img.mupSRC) {preLoadImg(img.mupSRC); img.onmouseup = imgMouseUpSwap;}
			img.rolloverSet = true;
		}
	}

	function preLoadImg(imgSrc) {
		prel[prel.length] = new Image(); prel[prel.length-1].src = imgSrc;
	}

}

function imgHoverSwap() {this.src = this.hoverSRC;}
function imgOutSwap() {this.src = this.outSRC;}
function imgMouseDownSwap() {this.src = this.mdownSRC;}
function imgMouseUpSwap() {this.src = this.mupSRC;}