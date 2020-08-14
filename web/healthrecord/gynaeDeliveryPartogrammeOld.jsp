<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=sJSCHARTJS%>
<%=sJSEXCANVAS%>

<table width='100%'>
	<tr class='admin'><td><%=getTran(request,"web","foetalheartrythm",sWebLanguage) %></td></tr>
    <tr><td><canvas id="diagFoetalHeartRythm" width="400" height="220"></canvas></td>
    </tr>
</table>

<script>
	var diagFoetalHeartRythm;
	
	Chart.defaults.global.showTooltips = true;
	Chart.defaults.global.animation = false;
	Chart.defaults.global.scaleOverride = true;
	Chart.defaults.global.scaleSteps = 12;
	Chart.defaults.global.scaleStepWidth = 10;
	Chart.defaults.global.scaleStartValue = 80;
	
	var options = {
			  scaleShowGridLines : true,
			  scaleGridLineColor : "rgba(0,0,0,.05)",
			  scaleGridLineWidth : 1,
			  bezierCurve : true,
			  bezierCurveTension : 0.2,
			  pointDot : true,
			  pointDotRadius : 3,
			  pointDotStrokeWidth : 1,
			  pointHitDetectionRadius : 16,
			  datasetStroke : true,
			  datasetStrokeWidth : 2,
			  datasetFill : true   
			};
	window.onload = function(){
		var data = {
   			labels: 	["125","250","500","1k","2k","4k","8k"],
   			datasets: 	[
   			    {	label: "HF",
	   		        fillColor: "rgba(250,250,250,0)",
	   		        strokeColor: "#CC3333",
	   		        pointColor: "#CC3333",
	   			    pointHighlightStroke: "#CC3333",
	   		        pointStrokeColor: "#fff",
	   			    data: [100,120,130,120,100,120,130,120]
   			    }
   			]
		}
		var ctx = document.getElementById("diagFoetalHeartRythm").getContext("2d");		
		diagFoetalHeartRythm = new Chart(ctx).Line(data,options);
	}
</script>