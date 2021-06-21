<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=sJSCHARTJS %>
<table>
	<tr>
		<td>
			<canvas id="myChart" width="200" height="200"></canvas>
		</td>
	</tr>
</table>

<script>
	var ctx = document.getElementById("myChart");
	var data = {
		    datasets: [{
		        data: [10, 20, 30],
	            backgroundColor: [
	                'rgba(255, 99, 132, 0.2)',
	                'rgba(54, 162, 235, 0.2)',
	                'rgba(255, 206, 86, 0.2)'
	            ],
	            borderColor: [
	                'rgba(255,99,132,1)',
	                'rgba(54, 162, 235, 1)',
	                'rgba(255, 206, 86, 1)'
	            ],
	            borderWidth: 1
            }],

		    // These labels appear in the legend and in the tooltips when hovering different arcs
		    labels: [
		        'Red',
		        'Yellow',
		        'Blue'
		    ]
		};
	var myPieChart = new Chart(ctx,{
	    type: 'pie',
	    data: data,
	    options: Chart.defaults.doughnut
	});
</script>