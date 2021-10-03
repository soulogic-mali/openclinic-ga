<%@page import="be.openclinic.assets.*"%>
<%@include file="/includes/validateUser.jsp"%>
<!DOCTYPE html>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<head>
	<link rel="apple-touch-icon" sizes="180x180" href="/openclinic/apple-touch-icon.png">
	<link rel="icon" type="image/png" sizes="32x32" href="/openclinic/favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="16x16" href="/openclinic/favicon-16x16.png">
	<link rel="manifest" href="/openclinic/site.webmanifest">
	<link rel="mask-icon" href="/openclinic/safari-pinned-tab.svg" color="#5bbad5">
	<meta name="msapplication-TileColor" content="#da532c">
	<meta name="theme-color" content="#ffffff">
</head>
<%=sCSSNORMAL %>
<%=sJSPROTOTYPE %>
<%=sJSSCRPTACULOUS%>
<%=sJSCHARTJS %>
<%
	java.util.Date dBegin = SH.getPreviousMonthBegin(new java.util.Date());
	java.util.Date dEnd = SH.getPreviousMonthEnd(new java.util.Date());
%>
<html>
	<body onresize='window.parent.document.getElementById("ocframe").style.height=screen.height;'>
		<div>
			<form name='transactionForm' method='post'>
				<input type='hidden' name='assetuid' id='assetuid' value='<%=SH.p(request,"assetuid")%>'/>
				<input type='hidden' name='action' id='action' value=''/>
				<table width='100%'>
					<tr>
						<td style='font-size:4vw;text-align: left' nowrap>
							<%=SH.c((String)session.getAttribute("activeService")).toUpperCase() %><br/>
							<b style='font-size:4vw;text-align: left'><%=getTranNoLink("service",SH.c((String)session.getAttribute("activeService")),sWebLanguage) %></b>
						</td>
						<td style='font-size:8vw;text-align: right' nowrap>
							<img onclick="window.location.href='welcomegmao.jsp'" style='max-height: 40px' src='<%=sCONTEXTPATH%>/_img/icons/mobile/home.png'/>
						</td>
					</tr>
					<tr>
						<td colspan='2' class='mobileadmin' style='font-size:6vw;'>
							<%=getTranNoLink("asset","dashboard",sWebLanguage)%>
							<img onclick='execute();' style='max-height:32px;height:auto;vertical-align:middle' src='<%=sCONTEXTPATH %>/_img/icons/mobile/icon_dashboard.png'/>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web","begin",sWebLanguage)%>
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
							<input style='width: 80% !important;padding:4px; font-size: 4vw;' type='date' name='begin' id='begin' value='<%=dBegin==null?"":new SimpleDateFormat("yyyy-MM-dd").format(dBegin) %>' size='10'/>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web","end",sWebLanguage)%>
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
							<input style='width: 80% !important;padding:4px; font-size: 4vw;' type='date' name='end' id='end' value='<%=dBegin==null?"":new SimpleDateFormat("yyyy-MM-dd").format(dEnd) %>' size='10'/>
						</td>
					</tr>
				</table>
				<div id="dashboarddiv"></div>
			</form>
		</div>
		<script>
			function execute(){
				document.getElementById('dashboarddiv').innerHTML="<center><img src='<%=sCONTEXTPATH%>/_img/themes/default/ajax-loader.gif'/></center>";
			    var url = "<c:url value='/'/>html5/loadDashboard.jsp";
			    new Ajax.Request(url,{
				      method: "POST",
				      parameters: "begin="+document.getElementById('begin').value+
				      			  "&end="+document.getElementById('end').value,
				      onSuccess: function(resp){
				        document.getElementById('dashboarddiv').innerHTML=resp.responseText;
				        drawCharts();
				      }
				    });
			}
			
			function drawPieChart(ctx,data){
				var myPieChart = new Chart(ctx,{
				    type: 'pie',
				    data: data,
				    options: Chart.defaults.doughnut
				});
			}

			function drawCharts(){
				var ctx = document.getElementById("infraStateChart");
				var data = {
					    datasets: [{
					        data: [document.getElementById('infragoodstate').innerHTML*1, document.getElementById('infratotalstate').innerHTML*1-document.getElementById('infragoodstate').innerHTML*1],
				            backgroundColor: [
				                'rgba(255, 206, 86, 0.2)',
				                'rgba(255, 99, 132, 0.2)'
				            ],
				            borderColor: [
				                'rgba(255, 206, 86, 1)',
				                'rgba(255,99,132,1)'
				            ],
				            borderWidth: 1
			            }],

					    // These labels appear in the legend and in the tooltips when hovering different arcs
					    labels: [
					        '<%=getTranNoLink("web","shortgoodstate",sWebLanguage)%>',
					        '<%=getTranNoLink("web","shortbadstate",sWebLanguage)%>'
					    ]
					};
				drawPieChart(ctx,data);

				ctx = document.getElementById("matStateChart");
				data = {
					    datasets: [{
					        data: [document.getElementById('matgoodstate').innerHTML*1, document.getElementById('mattotalstate').innerHTML*1-document.getElementById('matgoodstate').innerHTML*1],
				            backgroundColor: [
				                'rgba(255, 206, 86, 0.2)',
				                'rgba(255, 99, 132, 0.2)'
				            ],
				            borderColor: [
				                'rgba(255, 206, 86, 1)',
				                'rgba(255,99,132,1)'
				            ],
				            borderWidth: 1
			            }],

					    // These labels appear in the legend and in the tooltips when hovering different arcs
					    labels: [
					        '<%=getTranNoLink("web","shortgoodstate",sWebLanguage)%>',
					        '<%=getTranNoLink("web","shortbadstate",sWebLanguage)%>'
					    ]
					};
				drawPieChart(ctx,data);
	
				ctx = document.getElementById("matOperationChart");
				var data = {
					    datasets: [{
					        data: [document.getElementById('matpreventative').innerHTML*1, document.getElementById('matcorrective').innerHTML*1],
				            backgroundColor: [
				                'rgba(153, 102, 255, 0.2)',
				                'rgba(255, 159, 64, 0.2)'
				            ],
				            borderColor: [
				                'rgba(153, 102, 255, 1)',
				                'rgba(255, 159, 64, 1)'
				            ],
				            borderWidth: 1
			            }],
	
					    // These labels appear in the legend and in the tooltips when hovering different arcs
					    labels: [
					        '<%=getTranNoLink("web","shortpreventative",sWebLanguage)%>',
					        '<%=getTranNoLink("web","shortcorrective",sWebLanguage)%>'
					    ]
					};
				drawPieChart(ctx,data);
				
				ctx = document.getElementById("matSuccessChart");
				var data = {
					    datasets: [{
					        data: [document.getElementById('matcorrectivesuccess').innerHTML*1, document.getElementById('matcorrective').innerHTML*1-document.getElementById('matcorrectivesuccess').innerHTML*1],
				            backgroundColor: [
				                'rgba(75, 192, 192, 0.2)',
				                'rgba(255, 99, 132, 0.2)'
				            ],
				            borderColor: [
				                'rgba(75, 192, 192, 1)',
				                'rgba(255,99,132,1)'
				            ],
				            borderWidth: 1
			            }],

					    // These labels appear in the legend and in the tooltips when hovering different arcs
					    labels: [
					        '<%=getTranNoLink("web","shortcorrected",sWebLanguage)%>',
					        '<%=getTranNoLink("web","shortnotcorrected",sWebLanguage)%>'
					    ]
					};
				drawPieChart(ctx,data);	

				ctx = document.getElementById("performanceChart");
				data = {
					    datasets: [{
					        data: [document.getElementById('perfseen').innerHTML.replace(',','.')*1, 100-document.getElementById('perfseen').innerHTML.replace(',','.')*1],
				            backgroundColor: [
				                'rgba(255, 206, 86, 0.2)',
				                'rgba(255, 99, 132, 0.2)'
				            ],
				            borderColor: [
				                'rgba(255, 206, 86, 1)',
				                'rgba(255,99,132,1)'
				            ],
				            borderWidth: 1
			            }],
			
					    // These labels appear in the legend and in the tooltips when hovering different arcs
					    labels: [
					        '<%=getTranNoLink("web","shortseen",sWebLanguage)%>',
					        '<%=getTranNoLink("web","shortnotseen",sWebLanguage)%>'
					    ]
					};
				drawPieChart(ctx,data);

				ctx = document.getElementById("functionalStatusChart");
				data = {
					    datasets: [{
					        data: [document.getElementById('functionalStatus').value.split(",")[0]*1,document.getElementById('functionalStatus').value.split(",")[1]*1,document.getElementById('functionalStatus').value.split(",")[2]*1,document.getElementById('functionalStatus').value.split(",")[3]*1,document.getElementById('functionalStatus').value.split(",")[4]*1],
				            backgroundColor: ["#8e5ea2","#3cba9f","#e8c3b9","#c45850"],
				            borderColor: ["#8e5ea2","#3cba9f","#e8c3b9","#c45850"],
				            borderWidth: 1
			            }],
			
					    // These labels appear in the legend and in the tooltips when hovering different arcs
					    labels: [
					    	'?',
					        '<%=getTranNoLink("assets.functionality","1",sWebLanguage)%>',
					        '<%=getTranNoLink("assets.functionality","2",sWebLanguage)%>',
					        '<%=getTranNoLink("assets.functionality","3",sWebLanguage)%>',
					        '<%=getTranNoLink("assets.functionality","4",sWebLanguage)%>'
					    ]
					};
				drawPieChart(ctx,data);
			}				

			window.parent.parent.scrollTo(0,0);
		</script>
	</body>
</html>					