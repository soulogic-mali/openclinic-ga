<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<table width='100%' cellpadding='5px'>
	<tr class='admin'><td colspan='2'><center><%=getTran(request,"web","gmaohome",sWebLanguage) %></center></td></tr>
	<%	if(activeUser.getAccessRight("gmao.homepage.maintenance.select")){ %>
			<tr>
				<td nowrap style='text-align: left;padding-left: 50px'>
					<a style='font-size: 14px;font-weight: normal;color: #4d7aae;text-decoration: none' href='main.jsp?Page=assets/manage_assets.jsp&assetType=equipment'>
						<img height='32px' style='vertical-align: middle;' src='<%=sCONTEXTPATH %>/_img/icons/icon_gmao_equipment.png'/>
						<%=getTran(request,"web","maintenance.equipment",sWebLanguage) %>
					</a>
				</td>
				<td nowrap style='text-align: left;padding-left: 50px'>
					<a style='font-size: 14px;font-weight: normal;color: #4d7aae;text-decoration: none' href='main.jsp?Page=assets/manage_assets.jsp&assetType=infrastructure'>
						<img height='32px' style='vertical-align: middle' src='<%=sCONTEXTPATH %>/_img/icons/icon_gmao_infrastructure.png'/>
						<%=getTran(request,"web","maintenance.infrastructure",sWebLanguage) %>
					</a>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
	<%	} %>
	<%	if(activeUser.getAccessRight("gmao.homepage.reporting.select")){ %>
			<tr>
				<td nowrap style='text-align: left;padding-left: 50px'>
					<a style='font-size: 14px;font-weight: normal;color: #3d618b;text-decoration: none' href='main.jsp?Page=statistics/jasperReports.jsp'>
						<img height='32px' style='vertical-align: middle;' src='<%=sCONTEXTPATH %>/_img/icons/icon_gmao_report.png'/>
						<%=getTran(request,"web","gmao.reporting",sWebLanguage) %>
					</a>
				</td>
				<td nowrap style='text-align: left;padding-left: 50px'>
					<a style='font-size: 14px;font-weight: normal;color: #3d618b;text-decoration: none' href='main.jsp?Page=assets/calculateNorms.jsp'>
						<img height='32px' style='vertical-align: middle;' src='<%=sCONTEXTPATH %>/_img/icons/icon_gmao_norms.png'/>
						<%=getTran(request,"web","gmao.norms",sWebLanguage) %>
					</a>
				</td>
			</tr>
			<tr>
				<td nowrap style='text-align: left;padding-left: 50px'>
					<a style='font-size: 14px;font-weight: normal;color: #3d618b;text-decoration: none' href='main.jsp?Page=assets/showUserActivity.jsp'>
						<img height='32px' style='vertical-align: middle;' src='<%=sCONTEXTPATH %>/_img/icons/icon_gmao_users.png'/>
						<%=getTran(request,"web","gmao.useractivity",sWebLanguage) %>
					</a>
				</td>
				<td nowrap style='text-align: left;padding-left: 50px'>
					<a style='font-size: 14px;font-weight: normal;color: #3d618b;text-decoration: none' href='main.jsp?Page=assets/dashboard.jsp'>
						<img height='32px' style='vertical-align: middle;' src='<%=sCONTEXTPATH %>/_img/icons/icon_gmao_dashboard.png'/>
						<%=getTran(request,"web","gmao.dashboard",sWebLanguage) %>
					</a>
				</td>
			</tr>
			<tr>
				<td nowrap style='text-align: left;padding-left: 50px'>
					<a style='font-size: 14px;font-weight: normal;color: #3d618b;text-decoration: none' href='javascript:requestNewUser();'>
						<img height='32px' style='vertical-align: middle;' src='<%=sCONTEXTPATH %>/_img/icons/icon_gmao_newuser.png'/>
						<%=getTran(request,"web","gmao.requestcreateuser",sWebLanguage) %>
					</a>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
	<%	} %>
	<%	if(activeUser.getAccessRight("gmao.homepage.administration.select")){ %>
		<tr>
			<td nowrap style='text-align: left;padding-left: 50px'>
				<a style='font-size: 14px;font-weight: normal;color: #ae4d7a;text-decoration: none' href='main.jsp?Page=assets/home.jsp&forcePatientHeader=1'>
					<img height='32px' style='vertical-align: middle;' src='<%=sCONTEXTPATH %>/_img/icons/icon_gmao_finduser.png'/>
					<%=getTran(request,"web","gmao.searchuser",sWebLanguage) %>
				</a>
			</td>
			<td nowrap style='text-align: left;padding-left: 50px'>
				<a style='font-size: 14px;font-weight: normal;color: #ae4d7a;text-decoration: none' href='patientnew.do?PatientNew=true&forcePatientHeader=1'>
					<img height='32px' style='vertical-align: middle;' src='<%=sCONTEXTPATH %>/_img/icons/icon_gmao_createuser.png'/>
					<%=getTran(request,"web","gmao.createuser",sWebLanguage) %>
				</a>
			</td>
		</tr>
		<tr>
			<td nowrap style='text-align: left;padding-left: 50px'>
				<a style='font-size: 14px;font-weight: normal;color: #ae4d7a;text-decoration: none' href='main.jsp?Page=system/menu.jsp'>
					<img height='32px' style='vertical-align: middle;' src='<%=sCONTEXTPATH %>/_img/icons/icon_gmao_system.png'/>
					<%=getTran(request,"web","gmao.system",sWebLanguage) %>
				</a>
			</td>
			<td nowrap style='text-align: left;padding-left: 50px'>
				<a style='font-size: 14px;font-weight: normal;color: #ae4d7a;text-decoration: none' href='main.jsp?Page=assets/manageSpareParts.jsp'>
					<img height='32px' style='vertical-align: middle;' src='<%=sCONTEXTPATH %>/_img/icons/icon_gmao_spareparts.png'/>
					<%=getTran(request,"web","gmao.spareparts",sWebLanguage) %>
				</a>
			</td>
		</tr>
		<tr>
			<td nowrap style='text-align: left;padding-left: 50px'>
				<a style='font-size: 14px;font-weight: normal;color: #ae4d7a;text-decoration: none' href='main.jsp?Page=assets/manage_maintenancePlansDefault.jsp'>
					<img height='32px' style='vertical-align: middle;' src='<%=sCONTEXTPATH %>/_img/icons/icon_gmao_maintenanceplan.png'/>
					<%=getTran(request,"web","gmao.defaultmanagementplans",sWebLanguage) %>
				</a>
			</td>
			<td nowrap style='text-align: left;padding-left: 50px'>
				<a style='font-size: 14px;font-weight: normal;color: #ae4d7a;text-decoration: none' href='main.jsp?Page=assets/manage_assetsDefault.jsp'>
					<img height='32px' style='vertical-align: middle;' src='<%=sCONTEXTPATH %>/_img/icons/icon_gmao_default.png'/>
					<%=getTran(request,"web","gmao.defaultassets",sWebLanguage) %>
				</a>
			</td>
		</tr>
			<% 	if(activePatient!=null && activePatient.isNotEmpty()){ %>
			<tr>
				<td nowrap style='text-align: left;padding-left: 50px'>
					<a style='font-size: 14px;font-weight: normal;color: #ae4d7a;text-decoration: none' href='patientedit.do?forcePatientHeader=1'>
						<img height='32px' style='vertical-align: middle;' src='<%=sCONTEXTPATH %>/_img/icons/icon_gmao_edituser.png'/>
						<%=getTran(request,"web","gmao.edituser",sWebLanguage) %>
					</a>
				</td>
			</tr>
			<%	} %>
	<%	} %>
</table>
<script>
	function requestNewUser(){
		window.open('<%=SH.cs("createUserRequestURL","http://helpdesk.mspls.org/helpdesk/")%>');
	}
</script>