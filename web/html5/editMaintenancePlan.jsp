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
	MaintenancePlan plan = new MaintenancePlan();
	plan.setUid("-1");
	if(SH.p(request,"planuid").length()>0){
		plan=MaintenancePlan.get(SH.p(request,"planuid"));
	}
	else if(SH.p(request,"assetuid").length()>0){
		plan.setAssetUID(SH.p(request,"assetuid"));
		plan.setStartDate(new java.util.Date());
	}
	if(SH.p(request,"action").equalsIgnoreCase("save")){
		System.out.println("Saving..."+SH.p(request,"startdate"));
		plan.setAssetUID(SH.p(request,"assetuid"));
		plan.setType(SH.p(request,"type"));
		plan.setName(SH.p(request,"name"));
		plan.setStartDate(SH.parseDate(SH.p(request,"startdate"),"yyyy-MM-dd"));
		plan.setEndDate(SH.parseDate(SH.p(request,"enddate"),"yyyy-MM-dd"));
		plan.setFrequency(SH.p(request,"frequency"));
		plan.setOperator(SH.p(request,"operator"));
		plan.setPlanManager(SH.p(request,"planmanager"));
		plan.setInstructions(SH.p(request,"instructions"));
		plan.setComment1(SH.p(request,"comment1"));
		plan.setComment2(SH.p(request,"comment2"));
		plan.setComment3(SH.p(request,"comment3"));
		plan.setComment4(SH.p(request,"comment4"));
		plan.setComment5(SH.p(request,"comment5"));
		plan.store(activeUser.userid);
		out.println("<script>window.location.href='manageMaintenancePlans.jsp?assetuid="+plan.getAssetUID()+"';</script>");
		out.flush();
	}
%>
<html>
	<body onresize='window.parent.document.getElementById("ocframe").style.height=screen.height;'>
		<div>
			<form name='transactionForm' method='post'>
				<input type='hidden' name='planuid' id='planuid' value='<%=SH.p(request,"planuid")%>'/>
				<input type='hidden' name='action' id='action' value=''/>
				<table width='100%'>
					<tr>
						<td style='font-size:4vw;text-align: left' nowrap>
							<%=SH.c((String)session.getAttribute("activeService")).toUpperCase() %><br/>
							<b style='font-size:4vw;text-align: left'><%=getTranNoLink("service",SH.c((String)session.getAttribute("activeService")),sWebLanguage) %></b>
						</td>
						<td style='font-size:8vw;text-align: right' nowrap>
							<img onclick="window.location.href='manageMaintenancePlans.jsp'" style='max-height: 40px' src='<%=sCONTEXTPATH%>/_img/icons/mobile/planning.png'/>
							<img onclick="window.location.href='welcomegmao.jsp'" style='max-height: 40px' src='<%=sCONTEXTPATH%>/_img/icons/mobile/home.png'/>
						</td>
					</tr>
					<tr>
						<td colspan='2' class='mobileadmin' style='font-size:6vw;'>
							<%=getTranNoLink("web","managemaintenanceplan",sWebLanguage)%><br/>
							<img onclick='savePlan();' style='max-width:10%;height:auto;vertical-align:middle' src='<%=sCONTEXTPATH %>/_img/icons/mobile/save.png'/>
							<% if(SH.p(request,"planuid").length()>0){ %>
								<img onclick='manageOperations();' style='max-width:10%;height:auto;vertical-align:middle' src='<%=sCONTEXTPATH %>/_img/icons/mobile/worker.png'/>
							<% }%>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web","asset",sWebLanguage)%>
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
							<input type='hidden' name='assetuid' id='assetuid' value='<%=plan.getAssetUID()%>'/>
							<%=plan.getAssetUID()+" - "+plan.getAssetName()%>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web","nomenclature",sWebLanguage)%>
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
							<%=plan.getAssetNomenclature().toUpperCase()+" - "+getTranNoLink("admin.nomenclature.asset",plan.getAssetNomenclature(),sWebLanguage)%>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web.assets","type",sWebLanguage)%>
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
					       	<select name='type' id='type' style='width: 95% !important;font-size: 4vw;height: 6vw;'>
					       		<option style='font-size:4vw;'/>
				                <%=ScreenHelper.writeSelectWithStyle(request,"maintenanceplan.type",checkString(plan.getType()),sWebLanguage,"font-size: 4vw;")%>
				            </select>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web","name",sWebLanguage)%>&nbsp;*
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
							<input type='text' style='width: 95% !important;font-size: 4vw;height: 6vw;' name='name' id='name' size='10' value='<%=plan.getName()%>'/>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web","begindate",sWebLanguage)%>&nbsp;*
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
							<input style='width: 80% !important;padding:4px; font-size: 4vw;' type='date' name='startdate' id='startdate' value='<%=plan.getStartDate()==null?"":new SimpleDateFormat("yyyy-MM-dd").format(plan.getStartDate()) %>' size='10'/>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web","enddate",sWebLanguage)%>
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
							<input style='width: 80% !important;padding:4px; font-size: 4vw;' type='date' name='enddate' id='enddate' value='<%=plan.getEndDate()==null?"":new SimpleDateFormat("yyyy-MM-dd").format(plan.getEndDate()) %>' size='10'/>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web.assets","frequency",sWebLanguage)%>
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
					       	<select name='frequency' id='frequency' style='width: 95% !important;font-size: 4vw;height: 6vw;'>
					       		<option style='font-size:4vw;'/>
				                <%=ScreenHelper.writeSelectWithStyle(request,"maintenanceplan.frequency",checkString(plan.getFrequency()),sWebLanguage,"font-size: 4vw;")%>
				            </select>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web.assets","operator",sWebLanguage)%>&nbsp;*
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
							<input type='text' style='width: 95% !important;font-size: 4vw;height: 6vw;' name='operator' id='operator' size='10' value='<%=plan.getOperator()%>'/>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web.assets","externalsupplier",sWebLanguage)%>
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
							<input type='text' style='width: 95% !important;font-size: 4vw;height: 6vw;' name='comment4' id='comment4' size='10' value='<%=plan.getComment4()%>'/>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web","manager",sWebLanguage)%>
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
							<input type='text' style='width: 95% !important;font-size: 4vw;height: 6vw;' name='planmanager' id='planmanager' size='10' value='<%=plan.getPlanManager()%>'/>
						</td>
					</tr>
					<tr>
						<td colspan='2' class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web.assets","instructions",sWebLanguage)%>
						</td>
					</tr>
					<tr>
						<td colspan='2' class='mobileadmin2' style='font-size:4vw;'>
							<textarea style='width: 98% !important;font-size: 4vw;height: 85vw;' cols='10' rows='2' name='instructions' id='instructions'><%=checkString(plan.getInstructions().replaceAll("<br>", "\n"))%></textarea>
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
							<input type='text' style='width: 95% !important;font-size: 4vw;height: 6vw;' name='comment1' id='comment1' size='10' onkeyup="calculateCosts();" value='<%=SH.c(plan.getComment1())%>'/>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web.assets","consumables",sWebLanguage)%>
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
							<input type='text' style='width: 95% !important;font-size: 4vw;height: 6vw;' name='comment2' id='comment2' size='10' onkeyup="calculateCosts();" value='<%=SH.c(plan.getComment2())%>'/>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web.assets","externalfee",sWebLanguage)%>
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
							<input type='text' style='width: 95% !important;font-size: 4vw;height: 6vw;' name='comment5' id='comment5' size='10' onkeyup="calculateCosts();" value='<%=SH.c(plan.getComment5())%>'/>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web.assets","other",sWebLanguage)%>
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
							<input type='text' style='width: 95% !important;font-size: 4vw;height: 6vw;' name='comment3' id='comment3' size='10' onkeyup="calculateCosts();" value='<%=SH.c(plan.getComment3())%>'/>
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
					<%	if(plan.getUid().split("\\.").length>1){ %>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web","lastmodificationby",sWebLanguage)%>
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
							<%=User.getFullUserName(plan.getUpdateUser()) %> (<%=ScreenHelper.formatDate(plan.getUpdateDateTime(), ScreenHelper.fullDateFormat) %>)
						</td>
					</tr>
					<% } %>
				</table>
		        <script>
		        	function calculateCosts(){
		        		document.getElementById("totalcost").innerHTML=(document.getElementById("comment1").value*1+document.getElementById("comment2").value*1+document.getElementById("comment3").value*1+document.getElementById("comment5").value*1)+' <%=MedwanQuery.getInstance().getConfigString("currency","EUR")%>';
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
		        		  if(document.getElementById("startdate").value.length == 0 ){
		        			  document.getElementById("startDate").focus();
		        			  return false;
		        		  }
		        		  else if(document.getElementById("name").value.length == 0 ){
		        			  document.getElementById("name").focus();
		        			  return false;
		        		  }
		        		  else if(document.getElementById("operator").value.length == 0 ){
		        			  document.getElementById("operator").focus();
		        			  return false;
		        		  }
		        	    return true;
		        	  }
		        	
		        	function manageOperations(){
		        		window.location.href='manageOperations.jsp?planuid=<%=plan.getUid()%>';
		        	}
		        	
		        	calculateCosts();
		        </script>
			</form>
		</div>
		<script>
			window.parent.parent.scrollTo(0,0);
		</script>
	</body>
</html>
