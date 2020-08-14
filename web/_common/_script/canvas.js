<!-- DRAWING BEGIN -->
<!-- Global drawing variables -->
var clickX = new Array();
var clickY = new Array();
var originX;
var originY;
var clickDrag = new Array();
var clickColor = new Array();
var clickSize = new Array();
var clickTool = new Array();
var paint;
var context;
var canvasOffsetLeft;
var canvasOffsetTop;
var outlineImage = new Image();
var baseImage;

var colorBlack = "#000000";
var curColor = colorBlack;
var curSize = 5;
var curTool = "crayon";

var touchX;
var touchY;

<!-- Drawing functions -->
function addClick(x, y, dragging)
{
	clickX.push(x);
	clickY.push(y);
	clickDrag.push(dragging);
	if(curTool == "eraser"){
		clickColor.push("white");
	}else{
	    clickColor.push(curColor);
	}		
	clickSize.push(curSize);
}

function redraw(){
	context.clearRect(0, 0, context.canvas.width, context.canvas.height);
	ctx.drawImage(outlineImage, 0, 0, canvas.width, canvas.height);

	context.lineJoin = "round";
	for(var i=0; i < clickX.length; i++) {		
		context.beginPath();
		if(clickDrag[i] && i){
			originX=clickX[i-1];
			originY=clickY[i-1];
 		}else{
			originX=clickX[i]-1;
			originY=clickY[i]-1;
 		}
		context.moveTo(originX, originY);
 		context.lineTo(clickX[i], clickY[i]);
 		context.strokeStyle = clickColor[i];
 		context.lineWidth = clickSize[i];
 		context.closePath();
 		context.stroke();
	}
}

function initCanvas(parentDiv,canvasWidth,canvasHeight,canvasImage){
	baseImage=canvasImage;
	var canvasDiv = document.getElementById(parentDiv);
	canvas = document.createElement('canvas');
	canvas.id='canvas';
	canvasDiv.appendChild(canvas);
	if(typeof G_vmlCanvasManager != 'undefined') {
		canvas = G_vmlCanvasManager.initElement(canvas);
	}
	ctx = canvas.getContext("2d");
	canvas.width=canvasWidth;
	canvas.height=canvasHeight;
	if(canvasImage && canvasImage.length>0){
		outlineImage.src = canvasImage;
		outlineImage.onload=function(){
			window.setTimeout('resizeCanvasToImage();document.getElementById("drawingContent").value=document.getElementById("canvas").toDataURL();',100);
		}
	}

	<!-- Event listeners -->
	canvas.onmousedown = function(e){
		var activeElement=this;
		canvasOffsetLeft=0;
		canvasOffsetTop=0;
		while(activeElement.parentElement){
			if(activeElement.tagName!='TR' && activeElement.tagName!='DIV'){
				canvasOffsetLeft+=activeElement.offsetLeft;
				canvasOffsetTop+=activeElement.offsetTop;
			}
			else if(activeElement.tagName=='DIV'){
				canvasOffsetTop-=activeElement.scrollTop;
			}
			activeElement=activeElement.parentElement;
		}
	  	paint = true;
	  	addClick(e.pageX - canvasOffsetLeft, e.pageY - canvasOffsetTop);
	  	redraw();
	};

	canvas.ontouchstart = function(){
		var activeElement=this;
		canvasOffsetLeft=0;
		canvasOffsetTop=0;
		while(activeElement.parentElement){
			if(activeElement.tagName!='TR' && activeElement.tagName!='DIV'){
				canvasOffsetLeft+=activeElement.offsetLeft;
				canvasOffsetTop+=activeElement.offsetTop;
			}
			else if(activeElement.tagName=='DIV'){
				canvasOffsetTop-=activeElement.scrollTop;
			}
			activeElement=activeElement.parentElement;
		}
	  	paint = true;
	  	var e = event;
	  	if(e.touches && e.touches.length==1){
	  		var touch = e.touches[0];
	  		addClick(touch.pageX - canvasOffsetLeft, touch.pageY - canvasOffsetTop);
		  	redraw();
	  	}
	  	event.preventDefault();
	};
	
	canvas.onmousemove = function(e){
		if(paint){
			var activeElement=this;
			canvasOffsetLeft=0;
			canvasOffsetTop=0;
			while(activeElement.parentElement){
				if(activeElement.tagName!='TR' && activeElement.tagName!='DIV'){
					canvasOffsetLeft+=activeElement.offsetLeft;
					canvasOffsetTop+=activeElement.offsetTop;
				}
				else if(activeElement.tagName=='DIV'){
					canvasOffsetTop-=activeElement.scrollTop;
				}
				activeElement=activeElement.parentElement;
			}
		    addClick(e.pageX - canvasOffsetLeft, e.pageY - canvasOffsetTop, true);
		    redraw();
		}
	};

	canvas.ontouchmove = function(e){
		if(paint){
			var activeElement=this;
			canvasOffsetLeft=0;
			canvasOffsetTop=0;
			while(activeElement.parentElement){
				if(activeElement.tagName!='TR' && activeElement.tagName!='DIV'){
					canvasOffsetLeft+=activeElement.offsetLeft;
					canvasOffsetTop+=activeElement.offsetTop;
				}
				else if(activeElement.tagName=='DIV'){
					canvasOffsetTop-=activeElement.scrollTop;
				}
				activeElement=activeElement.parentElement;
			}
		  	if(e.touches && e.touches.length==1){
		  		var touch = e.touches[0];
		  		addClick(touch.pageX - canvasOffsetLeft, touch.pageY - canvasOffsetTop,true);
			  	redraw();
		  	}
		  	event.preventDefault();
		}
	};
	
	canvas.onmouseup = function(e){
		paint = false;
	};
	
	canvas.ontouchend = function(){
		if(clickX.length>0){
			document.getElementById('drawingContent').value=document.getElementById('canvas').toDataURL();
		}
		paint = false;
	};
	
	canvas.onmouseleave = function(e){
		if(clickX.length>0){
			document.getElementById('drawingContent').value=document.getElementById('canvas').toDataURL();
		}
		paint = false;
	};
	return ctx;
}

function resizeCanvasToImage(){
	canvas = document.getElementById('canvas');
	canvas.width=outlineImage.width;
	canvas.height=outlineImage.height;
	redraw();
}



function canvasSetColor(color){
	curColor=color;
}

function canvasSetRadius(radius){
	curSize=radius;
}

function canvasReloadBaseImage(){
	canvasLoadImage(baseImage);
	resetArrays();
}

function canvasLoadImage(image){
	outlineImage.src = image;
	outlineImage.onload=function(){
		window.setTimeout('resizeCanvasToImage();',1);
	}
	resetArrays();
}

function resetArrays(){
	clickX=new Array();
	clickY=new Array();
	clickDrag=new Array();
	clickColor=new Array();
	clickSize=new Array();
	clickTool=new Array();
}

<!-- DRAWING END -->
