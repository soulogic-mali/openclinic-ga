<%@page import="be.openclinic.medical.Vaccination"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	long day = 24*3600*1000;
	long week=7*day;
	long month=30*day;
	long year=365*day;
	long age=0;
	try{
    	age = new java.util.Date().getTime()-ScreenHelper.parseDate(activePatient.dateOfBirth).getTime();
	}
	catch(Exception e){
		e.printStackTrace();
	}
	Hashtable vaccinations = Vaccination.getVaccinations(activePatient.personid);
%>
<table width="100%">
	<tr>
		<td>
			<table width="100%">
				<tr class='admin'>
					<td colspan='6'><%=getTran(request,"web","dateandtypeofvaccination",sWebLanguage) %></td>
				</tr>
				<tr class='admin'>
					<td><%=getTran(request,"web","period",sWebLanguage) %></td>
					<td><%=getTran(request,"web","type",sWebLanguage) %></td>
					<td><%=getTran(request,"web","date",sWebLanguage) %></td>
					<td><%=getTran(request,"web","batchnumber",sWebLanguage) %></td>
					<td><%=getTran(request,"web","expirydate",sWebLanguage) %></td>
					<td><%=getTran(request,"web","vaccinationlocation",sWebLanguage) %></td>
				</tr>
				<!-- Birth -->
				<tr>
					<td class='admin' rowspan='2'><%=getTran(request,"web","birth",sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"web","BCG",sWebLanguage) %></td>
					<%=Vaccination.getVaccination(vaccinations,age,request,"bcg","date")%>
					<%=Vaccination.getVaccination(vaccinations,age,request,"bcg","batchnumber")%>
					<%=Vaccination.getVaccination(vaccinations,age,request,"bcg","expiry")%>
					<%=Vaccination.getVaccination(vaccinations,age,request,"bcg","location")%>
				</tr>
				<tr>
					<td class='admin2'><%=getTran(request,"web","Polio",sWebLanguage) %> 0</td>
					<%=Vaccination.getVaccination(vaccinations,age,request,"polio0","date")%>
					<%=Vaccination.getVaccination(vaccinations,age,request,"polio0","batchnumber")%>
					<%=Vaccination.getVaccination(vaccinations,age,request,"polio0","expiry")%>
					<%=Vaccination.getVaccination(vaccinations,age,request,"polio0","location")%>
				</tr>
				<%
					if(age>=5*week){
				%>
					<tr><td colspan='6'><hr/></td></tr>
					<!-- 6 weeks -->
					<tr>
						<td class='admin' rowspan='4'><%=getTran(request,"web","6weeks",sWebLanguage) %></td>
						<td class='admin2'><%=getTran(request,"web","Polio",sWebLanguage) %> 1</td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"polio1","date")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"polio1","batchnumber")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"polio1","expiry")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"polio1","location")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","Penta",sWebLanguage) %> 1</td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"penta1","date")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"penta1","batchnumber")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"penta1","expiry")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"penta1","location")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","Pneumo",sWebLanguage) %> 1</td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"pneumo1","date")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"pneumo1","batchnumber")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"pneumo1","expiry")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"pneumo1","location")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","Rota",sWebLanguage) %> 1</td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"rota1","date")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"rota1","batchnumber")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"rota1","expiry")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"rota1","location")%>
					</tr>
				<%
					}
					if(age>=9*week){
				%>
					<tr><td colspan='6'><hr/></td></tr>
					<!-- 10 weeks -->
					<tr>
						<td class='admin' rowspan='4'><%=getTran(request,"web","10weeks",sWebLanguage) %></td>
						<td class='admin2'><%=getTran(request,"web","Polio",sWebLanguage) %> 2</td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"polio2","date")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"polio2","batchnumber")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"polio2","expiry")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"polio2","location")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","Penta",sWebLanguage) %> 2</td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"penta2","date")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"penta2","batchnumber")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"penta2","expiry")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"penta2","location")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","Pneumo",sWebLanguage) %> 2</td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"pneumo2","date")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"pneumo2","batchnumber")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"pneumo2","expiry")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"pneumo2","location")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","Rota",sWebLanguage) %> 2</td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"rota2","date")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"rota2","batchnumber")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"rota2","expiry")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"rota2","location")%>
					</tr>
				<%
					}
					if(age>=13*week){
				%>
					<tr><td colspan='6'><hr/></td></tr>
					<!-- 14 weeks -->
					<tr>
						<td class='admin' rowspan='4'><%=getTran(request,"web","14weeks",sWebLanguage) %></td>
						<td class='admin2'><%=getTran(request,"web","Polio",sWebLanguage) %> 3</td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"polio3","date")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"polio3","batchnumber")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"polio3","expiry")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"polio3","location")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","Penta",sWebLanguage) %> 3</td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"penta3","date")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"penta3","batchnumber")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"penta3","expiry")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"penta3","location")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","Pneumo",sWebLanguage) %> 3</td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"pneumo3","date")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"pneumo3","batchnumber")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"pneumo3","expiry")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"pneumo3","location")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","Rota",sWebLanguage) %> 3</td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"rota3","date")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"rota3","batchnumber")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"rota3","expiry")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"rota3","location")%>
					</tr>
				<%
					}
					if(age>=9*month-week){
				%>
					<tr><td colspan='6'><hr/></td></tr>
					<!-- 9 mois -->
					<tr>
						<td class='admin' rowspan='3'><%=getTran(request,"web","9months",sWebLanguage) %></td>
						<td class='admin2'><%=getTran(request,"web","Measles",sWebLanguage) %></td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"measles","date")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"measles","batchnumber")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"measles","expiry")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"measles","location")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","Yellowfever",sWebLanguage) %></td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"yellowfever","date")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"yellowfever","batchnumber")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"yellowfever","expiry")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"yellowfever","location")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","MeningitisA",sWebLanguage) %></td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"meningitisa","date")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"meningitisa","batchnumber")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"meningitisa","expiry")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"meningitisa","location")%>
					</tr>
				<%
					}
					if(age>=MedwanQuery.getInstance().getConfigInt("minimalFemaleAgeMaliVaccinations",11)*year && activePatient.gender.equalsIgnoreCase("f")){
				%>
					<tr><td colspan='6'><hr/></td></tr>
					<tr class='admin'>
						<td colspan='6'><%=getTran(request,"web","vatwomen15to49",sWebLanguage) %></td>
					</tr>
					<!-- 15-49 ans -->
					<tr>
						<td class='admin' rowspan='5'><%=getTran(request,"web","15to49years",sWebLanguage) %></td>
						<td class='admin2'><%=getTran(request,"web","VAT",sWebLanguage) %> 1</td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vat1","date")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vat1","batchnumber")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vat1","expiry")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vat1","location")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","VAT",sWebLanguage) %> 2</td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vat2","date")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vat2","batchnumber")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vat2","expiry")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vat2","location")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","VAT",sWebLanguage) %> R1</td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vatr1","date")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vatr1","batchnumber")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vatr1","expiry")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vatr1","location")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","VAT",sWebLanguage) %> R2</td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vatr2","date")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vatr2","batchnumber")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vatr2","expiry")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vatr2","location")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","VAT",sWebLanguage) %> R3</td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vatr3","date")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vatr3","batchnumber")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vatr3","expiry")%>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vatr3","location")%>
					</tr>
				<%
					}
				%>
				</table>
			</td>
			<td style='vertical-align: top'>
				<table width='100%'>	
				<%
					if(age>=6*month-week){
				%>
					<tr class='admin'>
						<td colspan='6'><%=getTran(request,"web","supplementsandalbendazole",sWebLanguage) %></td>
					</tr>
					<tr class='admin'>
						<td><%=getTran(request,"web","period",sWebLanguage) %></td>
						<td><%=getTran(request,"web","type",sWebLanguage) %></td>
						<td><%=getTran(request,"web","date",sWebLanguage) %></td>
					</tr>
					<!-- 6-11 mois -->
					<tr>
						<td class='admin' rowspan='2'><%=getTran(request,"web","6to11months",sWebLanguage) %></td>
						<td class='admin2'><%=getTran(request,"web","vitaminea100",sWebLanguage) %></td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vita100","date")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","vitaminea100",sWebLanguage) %></td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vita100a","date")%>
					</tr>
					<tr><td colspan='6'><hr/></td></tr>
				<%
					}
					if(age>=12*month-week){
				%>
					<!-- 12-23 mois -->
					<tr>
						<td class='admin' rowspan='6'><%=getTran(request,"web","12to23months",sWebLanguage) %></td>
						<td class='admin2'><%=getTran(request,"web","vitaminea200",sWebLanguage) %></td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.1","date")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","vitaminea200",sWebLanguage) %></td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.1a","date")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","vitaminea200",sWebLanguage) %></td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.1b","date")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","Albendazole200",sWebLanguage) %></td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"alben200.1","date")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","Albendazole200",sWebLanguage) %></td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"alben200.1a","date")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","Albendazole200",sWebLanguage) %></td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"alben200.1b","date")%>
					</tr>
					<tr><td colspan='6'><hr/></td></tr>
				<%
					}
					if(age>=24*month-week){
				%>
					<!-- 24-59 mois -->
					<tr>
						<td class='admin' rowspan='10'><%=getTran(request,"web","24to59months",sWebLanguage) %></td>
						<td class='admin2'><%=getTran(request,"web","vitaminea200",sWebLanguage) %></td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.2","date")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","vitaminea200",sWebLanguage) %></td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.2a","date")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","vitaminea200",sWebLanguage) %></td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.2b","date")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","vitaminea200",sWebLanguage) %></td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.2c","date")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","vitaminea200",sWebLanguage) %></td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"vita200.2d","date")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","Albendazole400",sWebLanguage) %></td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"alben400.1","date")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","Albendazole400",sWebLanguage) %></td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"alben400.1a","date")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","Albendazole400",sWebLanguage) %></td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"alben400.1b","date")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","Albendazole400",sWebLanguage) %></td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"alben400.1c","date")%>
					</tr>
					<tr>
						<td class='admin2'><%=getTran(request,"web","Albendazole400",sWebLanguage) %></td>
						<%=Vaccination.getVaccination(vaccinations,age,request,"alben400.1d","date")%>
					</tr>
				<%
					}
				%>

				</table>
			</td>
		</tr>
	</table>
			
<script>
	function editVaccination(type){
		window.location.href='<c:url value="main.do"/>?Page=healthrecord/maliVaccinationEdit.jsp&type='+type;
	}
</script>