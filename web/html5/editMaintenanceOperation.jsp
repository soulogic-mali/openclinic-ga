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
<%
	MaintenanceOperation operation = new MaintenanceOperation();
	operation.setUid("-1");
	if(SH.p(request,"operationuid").length()>0){
		operation=MaintenanceOperation.get(SH.p(request,"operationuid"));
	}
	else if(SH.p(request,"planuid").length()>0){
		operation.setMaintenanceplanUID(SH.p(request,"planuid"));
		operation.setDate(new java.util.Date());
	}
	if(SH.p(request,"action").equalsIgnoreCase("save")){
		operation.setDate(SH.parseDate(SH.p(request,"date"),"yyyy-MM-dd"));
		operation.setNextDate(SH.parseDate(SH.p(request,"nextdate"),"yyyy-MM-dd"));
		operation.setOperator(SH.p(request,"operator"));
		operation.setSupplier(SH.p(request,"supplier"));
		operation.setResult(SH.p(request,"result"));
		operation.setComment1(SH.p(request,"comment1"));
		operation.setComment2(SH.p(request,"comment2"));
		operation.setComment3(SH.p(request,"comment3"));
		operation.setComment4(SH.p(request,"comment4"));
		operation.setComment5(SH.p(request,"comment5"));
		operation.store(activeUser.userid);
		out.println("<script>window.location.href='manageOperations.jsp?planuid="+operation.getMaintenanceplanUID()+"';</script>");
		out.flush();
	}
%>
<html>
	<body onresize='window.parent.document.getElementById("ocframe").style.height=screen.height;'>
		<div>
			<form name='transactionForm' method='post'>
				<input type='hidden' name='planuid' id='planuid' value='<%=operation.getMaintenanceplanUID()%>'/>
				<input type='hidden' name='action' id='action' value=''/>
				<table width='100%'>
					<tr>
						<td style='font-size:4vw;text-align: left' nowrap>
							<%=SH.c((String)session.getAttribute("activeService")).toUpperCase() %><br/>
							<b style='font-size:4vw;text-align: left'><%=getTranNoLink("service",SH.c((String)session.getAttribute("activeService")),sWebLanguage) %></b>
						</td>
						<td style='font-size:8vw;text-align: right' nowrap>
							<img onclick="window.location.href='manageOperations.jsp'" style='max-height: 40px' src='<%=sCONTEXTPATH%>/_img/icons/mobile/worker.png'/>
							<img onclick="window.location.href='welcomegmao.jsp'" style='max-height: 40px' src='<%=sCONTEXTPATH%>/_img/icons/mobile/home.png'/>
						</td>
					</tr>
					<tr>
						<td colspan='2' class='mobileadmin' style='font-size:6vw;'>
							<%=getTranNoLink("web","managemaintenanceoperation",sWebLanguage)%><br/>
							<img onclick='savePlan();' style='max-width:10%;height:auto;vertical-align:middle' src='<%=sCONTEXTPATH %>/_img/icons/mobile/save.png'/>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web","asset",sWebLanguage)%>
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
							<%=operation.getMaintenancePlan().getAssetUID()+" - "+operation.getMaintenancePlan().getAssetName()%>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web","maintenanceplan",sWebLanguage)%>
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
							<input type='hidden' name='planuid' id='planuid' value='<%=operation.getMaintenanceplanUID()%>'/>
							<%=operation.getMaintenanceplanUID()+" - "+operation.getMaintenancePlan().getName()+" - "+getTranNoLink("maintenanceplan.frequency",operation.getMaintenancePlan().getFrequency(),sWebLanguage)%>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web","begindate",sWebLanguage)%>&nbsp;*
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
							<input style='width: 80% !important;padding:4px; font-size: 4vw;' type='date' name='date' id='date' value='<%=operation.getDate()==null?"":new SimpleDateFormat("yyyy-MM-dd").format(operation.getDate()) %>' onchange='getNextOperationDate();' size='10'/>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web","enddate",sWebLanguage)%>
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
							<input style='width: 80% !important;padding:4px; font-size: 4vw;' type='date' name='comment5' id='comment5' value='<%=operation.getComment5()==null||operation.getComment5().length()==0?"":operation.getComment5() %>' size='10'/>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web.assets","operator",sWebLanguage)%>&nbsp;*
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
							<input type='text' style='width: 95% !important;font-size: 4vw;height: 6vw;' name='operator' id='operator' size='10' value='<%=operation.getOperator()%>'/>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web.assets","externalsupplier",sWebLanguage)%>
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
							<input type='text' style='width: 95% !important;font-size: 4vw;height: 6vw;' name='supplier' id='supplier' size='10' value='<%=operation.getSupplier()%>'/>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web.assets","result",sWebLanguage)%>&nbsp;*
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
					       	<select name='result' id='result' style='width: 95% !important;font-size: 4vw;height: 6vw;'>
					       		<option style='font-size:4vw;'/>
				                <%=ScreenHelper.writeSelectWithStyle(request,"assets.maintenanceoperations.result",checkString(operation.getResult()),sWebLanguage,"font-size: 4vw;")%>
				            </select>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web.assets","nextMaintenanceDate",sWebLanguage)%>
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
							<input style='width: 80% !important;padding:4px; font-size: 4vw;' type='date' name='nextdate' id='nextdate' value='<%=operation.getNextDate()==null?"":new SimpleDateFormat("yyyy-MM-dd").format(operation.getNextDate()) %>' size='10'/>
						</td>
					</tr>
					<tr>
						<td colspan='2' class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web","comment",sWebLanguage)%>
						</td>
					</tr>
					<tr>
						<td colspan='2' class='mobileadmin2' style='font-size:4vw;'>
							<textarea style='width: 98% !important;font-size: 4vw;height: 85vw;' cols='10' rows='2' name='comment' id='comment'><%=checkString(operation.getComment().replaceAll("<br>", "\n"))%></textarea>
						</td>
					</tr>
					<tr>
						<td colspan='2' class='mobileadmin' style='font-size:4vw;'><%=getTran(request,"web","costs",sWebLanguage) %></td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web.assets","transportcost",sWebLanguage)%>
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
							<input type='text' style='width: 95% !important;font-size: 4vw;height: 6vw;' name='comment1' id='comment1' size='10' onkeyup="calculateCosts();" value='<%=SH.c(operation.getComment1())%>'/>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web.assets","consumables",sWebLanguage)%>
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
							<input type='text' style='width: 95% !important;font-size: 4vw;height: 6vw;' name='comment2' id='comment2' size='10' onkeyup="calculateCosts();" value='<%=SH.c(operation.getComment2())%>'/>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web.assets","externalfee",sWebLanguage)%>
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
							<input type='text' style='width: 95% !important;font-size: 4vw;height: 6vw;' name='comment3' id='comment3' size='10' onkeyup="calculateCosts();" value='<%=SH.c(operation.getComment3())%>'/>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web.assets","other",sWebLanguage)%>
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
							<input type='text' style='width: 95% !important;font-size: 4vw;height: 6vw;' name='comment4' id='comment4' size='10' onkeyup="calculateCosts();" value='<%=SH.c(operation.getComment4())%>'/>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web.assets","total",sWebLanguage)%>
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
							<span id='totalcost' style='width: 95% !important;font-weight: bold;font-size: 4vw;height: 6vw;'></span>
						</td>
					</tr>
					<%	if(operation.getUid().split("\\.").length>1){ %>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web","lastmodificationby",sWebLanguage)%>
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
							<%=User.getFullUserName(operation.getUpdateUser()) %> (<%=ScreenHelper.formatDate(operation.getUpdateDateTime(), ScreenHelper.fullDateFormat) %>)
						</td>
					</tr>
					<% } %>
				</table>
			</form>
		</div>
        <script>
        	function calculateCosts(){
        		document.getElementById("totalcost").innerHTML=(document.getElementById("comment1").value*1+document.getElementById("comment2").value*1+document.getElementById("comment3").value*1+document.getElementById("comment4").value*1)+' <%=MedwanQuery.getInstance().getConfigString("currency","EUR")%>';
        	}
        	if(document.getElementById('nextdate').value.length==0){
        		window.setTimeout("getNextOperationDate();",500);
        	}
        	window.setTimeout("calculateCosts();",800);
        </script>
		<script>
			  function getNextOperationDate(){
			      var url = "<c:url value='/assets/ajax/maintenanceOperation/getNextOperationDate.jsp'/>?ts="+new Date().getTime();
			      new Ajax.Request(url,{
			        method: "POST",
			        parameters: "MaintenancePlanUID="+document.getElementById("planuid").value+
			        			"&date="+document.getElementById("date").value+"&format=yyyy-MM-dd",
			        onSuccess: function(resp){
			          var data = eval("("+resp.responseText+")");
			          $("nextdate").value = data.nextdate;
			        },
			        onFailure: function(resp){
			        }  
			      });
			  }
			  
			  function savePlan(){
	        		if(requiredFieldsProvided()){
		        		document.getElementById('action').value='save';
		        		transactionForm.submit();
	        		}
	        		else{
				    	alert('<%=getTranNoLink("web.manage","dataMissing",sWebLanguage)%>');
	        		}
			  }
			  
			  function requiredFieldsProvided(){
				    return (document.getElementById("date").value.length > 0 &&
				            document.getElementById("operator").value.length > 0 &&
				            document.getElementById("result").selectedIndex > 0);
			  }

		</script>
	</body>
</html>