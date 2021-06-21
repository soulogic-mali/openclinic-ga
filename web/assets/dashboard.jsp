<%@ page errorPage="/includes/error.jsp" %>
<%@ include file="/includes/validateUser.jsp" %>
<%=sJSCHARTJS %>
<%
	String sBegin = SH.formatDate(SH.getPreviousMonthBegin());
	String sEnd = SH.formatDate(SH.getPreviousMonthEnd());
%>

<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'><td colspan='2'><%=getTran(request,"asset","dashboard",sWebLanguage) %></td></tr>
		<tr>
		    <td class="admin"><%=getTran(request,"web","service",sWebLanguage)%></td>
		    <td class="admin2">
	            <%
	            	if(checkString(request.getParameter("serviceuid")).length()>0){
	            		session.setAttribute("activeservice", request.getParameter("serviceuid"));
	            	}
	            	String sServiceUid = checkString((String)session.getAttribute("activeservice"));
	            	if(sServiceUid.length()==0){   	
	            		sServiceUid=activeUser.getParameter("defaultserviceid");
	            	}
	            %>
                <input type="hidden" name="serviceuid" id="serviceuid" value="<%=sServiceUid%>">
                <input onblur="if(document.getElementById('serviceuid').value.length==0){this.value='';}" class="text" type="text" name="servicename" id="servicename" size="50" value="<%=getTranNoLink("service",sServiceUid,sWebLanguage) %>" >
                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTran(null,"Web","select",sWebLanguage)%>" onclick="searchService('serviceuid','servicename');">
	            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTran(null,"Web","delete",sWebLanguage)%>" onclick="document.getElementById('serviceuid').value='';document.getElementById('servicename').value='';document.getElementById('servicename').focus();">
				<div id="autocomplete_service" class="autocomple"></div>
		    </td>                        
		</tr>
		<tr>
		    <td class="admin"><%=getTran(request,"web","period",sWebLanguage)%></td>
		    <td class='admin2'>
		    	<%= SH.writeDateField("dashboardBegin", "transactionForm", sBegin, true, false, sWebLanguage, sCONTEXTPATH)%>
		    	<%= SH.writeDateField("dashboardEnd", "transactionForm", sEnd, true, false, sWebLanguage, sCONTEXTPATH)%>
		    	<input type='button' onclick='doAnalyze()' name='submitButton' class='button' value='<%=getTranNoLink("web","analyze",sWebLanguage) %>'/>
		    </td>
		</tr>
	</table>
	<div id='divDashboard'></div>
</form>

<script>
	function doAnalyze(){
	    document.getElementById('divDashboard').innerHTML = "<img height='14px' src='<c:url value="/_img/themes/default/ajax-loader.gif"/>'/>";
	    var params = "service="+document.getElementById("serviceuid").value+"&begin="+document.getElementById("dashboardBegin").value+"&end="+document.getElementById("dashboardEnd").value;
	    var url = "<%=sCONTEXTPATH%>/assets/ajax/generateDashboard.jsp";
		new Ajax.Request(url,{
		method: "POST",
		parameters: params,
		onSuccess: function(resp){
			document.getElementById('divDashboard').innerHTML=resp.responseText;
			drawCharts();
		}
		});
	}
	
	function searchService(serviceUidField,serviceNameField){
	  	openPopup("/_common/search/searchService.jsp&ts=<%=getTs()%>&VarCode="+serviceUidField+"&VarText="+serviceNameField);
	  	document.getElementById(serviceNameField).focus();
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
		
		ctx = document.getElementById("infraOperationChart");
		var data = {
			    datasets: [{
			        data: [document.getElementById('infrapreventative').innerHTML*1, document.getElementById('infracorrective').innerHTML*1],
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

		ctx = document.getElementById("infraSuccessChart");
		var data = {
			    datasets: [{
			        data: [document.getElementById('infracorrectivesuccess').innerHTML*1, document.getElementById('infracorrective').innerHTML*1-document.getElementById('infracorrectivesuccess').innerHTML*1],
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
	}
	
	new Ajax.Autocompleter('servicename','autocomplete_service','assets/findService.jsp',{
	  minChars:1,
	  method:'post',
	  afterUpdateElement: afterAutoCompleteService,
	  callback: composeCallbackURLService
	});

	function afterAutoCompleteService(field,item){
	  var regex = new RegExp('[-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.]*-idcache','i');
	  var nomimage = regex.exec(item.innerHTML);
	  var id = nomimage[0].replace('-idcache','');
	  document.getElementById("serviceuid").value = id;
	  document.getElementById("servicename").value=item.innerHTML.split("$")[1];
	}
	
	function composeCallbackURLService(field,item){
	  document.getElementById('serviceuid').value
	  var url = "";
	  if(field.id=="servicename"){
		url = "text="+field.value;
	  }
	  return url;
	}

</script>