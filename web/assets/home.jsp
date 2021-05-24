<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<table width='100%' cellpadding='5px'>
	<tr class='admin'><td><center><%=getTran(request,"web","gmaohome",sWebLanguage) %></center></td></tr>
	<%	if(activeUser.getAccessRight("gmao.homepage.maintenance.select")){ %>
			<tr>
				<td>
					<center>
						<table style='padding: 5px;background-color: #004268' width='40%'>
							<tr>
								<td style='text-align: center' nowrap><a style='font-size: 14px;color: white;text-decoration: none' href='main.jsp?Page=assets/manage_assets.jsp&assetType=equipment'><%=getTran(request,"web","maintenance.equipment",sWebLanguage) %></a></td>
							</tr>
						</table>
					</center>
				</td>
			</tr>
			<tr>
				<td>
					<center>
						<table style='padding: 5px;background-color: #004268' width='40%'>
							<tr>
								<td style='text-align: center' nowrap><a style='font-size: 14px; color: white;text-decoration: none' href='main.jsp?Page=assets/manage_assets.jsp&assetType=infrastructure'><%=getTran(request,"web","maintenance.infrastructure",sWebLanguage) %></a></td>
							</tr>
						</table>
					</center>
				</td>
			</tr>
			<tr><td><hr/></td></tr>
	<%	} %>
	<%	if(activeUser.getAccessRight("gmao.homepage.reporting.select")){ %>
			<tr>
				<td>
					<center>
						<table style='padding: 5px;background-color: #004228' width='40%'>
							<tr>
								<td style='text-align: center' nowrap><a style='font-size: 14px;color: white;text-decoration: none' href='main.jsp?Page=statistics/jasperReports.jsp'><%=getTran(request,"web","gmao.reporting",sWebLanguage) %></a></td>
							</tr>
						</table>
					</center>
				</td>
			</tr>
			<tr>
				<td>
					<center>
						<table style='padding: 5px;background-color: #004228' width='40%'>
							<tr>
								<td style='text-align: center' nowrap><a style='font-size: 14px;color: white;text-decoration: none' href='main.jsp?Page=statistics/calculateNorms.jsp'><%=getTran(request,"web","gmao.norms",sWebLanguage) %></a></td>
							</tr>
						</table>
					</center>
				</td>
			</tr>
			<tr>
				<td>
					<center>
						<table style='padding: 5px;background-color: #004228' width='40%'>
							<tr>
								<td style='text-align: center' nowrap><a style='font-size: 14px; color: white;text-decoration: none' href='main.jsp?Page=assets/dashboard.jsp'><%=getTran(request,"web","gmao.dashboard",sWebLanguage) %></a></td>
							</tr>
						</table>
					</center>
				</td>
			</tr>
			<tr>
				<td>
					<center>
						<table style='padding: 5px;background-color: #004228' width='40%'>
							<tr>
								<td style='text-align: center' nowrap><a style='font-size: 14px; color: white;text-decoration: none' href='main.jsp?Page=assets/home.jsp&forcePatientHeader=1'><%=getTran(request,"web","gmao.searchuser",sWebLanguage) %></a></td>
							</tr>
						</table>
					</center>
				</td>
			</tr>
			<% 	if(activePatient!=null && activePatient.isNotEmpty()){ %>
				<tr>
					<td>
						<center>
							<table style='padding: 5px;background-color: #004228' width='40%'>
								<tr>
									<td style='text-align: center' nowrap><a style='font-size: 14px; color: white;text-decoration: none' href='patientedit.do?forcePatientHeader=1'><%=getTran(request,"web","gmao.edituser",sWebLanguage) %> [<%=activePatient.getFullName() %>]</a></td>
								</tr>
							</table>
						</center>
					</td>
				</tr>
			<%	} %>
			<tr>
				<td>
					<center>
						<table style='padding: 5px;background-color: #004228' width='40%'>
							<tr>
								<td style='text-align: center' nowrap><a style='font-size: 14px; color: white;text-decoration: none' href='patientnew.do?PatientNew=true&forcePatientHeader=1'><%=getTran(request,"web","gmao.createuser",sWebLanguage) %></a></td>
							</tr>
						</table>
					</center>
				</td>
			</tr>
			<tr><td><hr/></td></tr>
	<%	} %>
	<%	if(activeUser.getAccessRight("gmao.homepage.administration.select")){ %>
		<tr>
			<td>
				<center>
					<table style='padding: 5px;background-color: #004288' width='40%'>
						<tr>
							<td style='text-align: center' nowrap><a style='font-size: 14px; color: white;text-decoration: none' href='main.jsp?Page=assets/home.jsp&forcePatientHeader=1'><%=getTran(request,"web","gmao.searchuser",sWebLanguage) %></a></td>
						</tr>
					</table>
				</center>
			</td>
		</tr>
		<% 	if(activePatient!=null && activePatient.isNotEmpty()){ %>
			<tr>
				<td>
					<center>
						<table style='padding: 5px;background-color: #004288' width='40%'>
							<tr>
								<td style='text-align: center' nowrap><a style='font-size: 14px; color: white;text-decoration: none' href='patientedit.do?forcePatientHeader=1'><%=getTran(request,"web","gmao.edituser",sWebLanguage) %> [<%=activePatient.getFullName() %>]</a></td>
							</tr>
						</table>
					</center>
				</td>
			</tr>
		<%	} %>
		<tr>
			<td>
				<center>
					<table style='padding: 5px;background-color: #004288' width='40%'>
						<tr>
							<td style='text-align: center' nowrap><a style='font-size: 14px; color: white;text-decoration: none' href='patientnew.do?PatientNew=true&forcePatientHeader=1'><%=getTran(request,"web","gmao.createuser",sWebLanguage) %></a></td>
						</tr>
					</table>
				</center>
			</td>
		</tr>
		<tr>
			<td>
				<center>
					<table style='padding: 5px;background-color: #004288' width='40%'>
						<tr>
							<td style='text-align: center' nowrap><a style='font-size: 14px; color: white;text-decoration: none' href='main.jsp?Page=system/menu.jsp'><%=getTran(request,"web","gmao.system",sWebLanguage) %></a></td>
						</tr>
					</table>
				</center>
			</td>
		</tr>
		<tr>
			<td>
				<center>
					<table style='padding: 5px;background-color: #004288' width='40%'>
						<tr>
							<td style='text-align: center' nowrap><a style='font-size: 14px; color: white;text-decoration: none' href='main.jsp?Page=assets/manage_maintenancePlansDefault.jsp'><%=getTran(request,"web","gmao.defaultmanagementplans",sWebLanguage) %></a></td>
						</tr>
					</table>
				</center>
			</td>
		</tr>
		<tr>
			<td>
				<center>
					<table style='padding: 5px;background-color: #004288' width='40%'>
						<tr>
							<td style='text-align: center' nowrap><a style='font-size: 14px; color: white;text-decoration: none' href='main.jsp?Page=assets/manage_assetsDefault.jsp'><%=getTran(request,"web","gmao.defaultassets",sWebLanguage) %></a></td>
						</tr>
					</table>
				</center>
			</td>
		</tr>
		<tr><td><hr/></td></tr>
	<%	} %>
</table>