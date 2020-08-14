<%@page errorPage="/includes/error.jsp"%>
<%@include file="/_common/patient/patienteditHelper.jsp"%>
<%
	String personid = SH.p(request, "personid");
	String firstname = SH.p(request, "firstname");
	String lastname = SH.p(request, "lastname");
	String gender = SH.p(request, "gender");
	String dateofbirth = SH.p(request, "dateofbirth");
	String phone = SH.p(request, "phone");
	String phonefather = SH.p(request, "phonefather");
	String phonemother = SH.p(request, "phonemother");
	String edit = SH.p(request, "edit");
	
	AdminPerson person = new AdminPerson();
	if(edit.equals("1")){
		person=activePatient;
		firstname=person.firstname;
		lastname=person.lastname;
		dateofbirth=person.dateOfBirth;
		gender=person.gender;
		phone=person.getActivePrivate().telephone;
		phonefather=person.getActivePrivate().city;
		phonemother=person.getActivePrivate().cell;
	}
	else if(personid.length()>0){
		person.getAdminPerson(personid);
		firstname=person.firstname;
		lastname=person.lastname;
		dateofbirth=person.dateOfBirth;
		gender=person.gender;
		phone=person.getActivePrivate().telephone;
		phonefather=person.getActivePrivate().city;
		phonemother=person.getActivePrivate().cell;
	}
%>
<form name='transactionForm' method='post' action='_common/patient/patientEditCompactSave.jsp'>
	<input type='hidden' name="personid" value='<%=person.personid %>'/>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='2'><%=getTran(request,"web","createnewpatient",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","firstname",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' name='firstname' size='40' value='<%=firstname%>'/></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","lastname",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' name='lastname' size='40' value='<%=lastname%>'/></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","dateofbirth",sWebLanguage) %></td>
			<td class='admin2'><%=SH.writeDateField("dateofbirth", "transactionForm", dateofbirth, true, false, sWebLanguage, sCONTEXTPATH) %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","gender",sWebLanguage) %></td>
			<td class='admin2'>
				<select class='text' name='gender'>
					<option/>
					<%=SH.writeSelect(request, "gender", gender, sWebLanguage) %>
				</select>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","phone",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' name='phone' size='40' value='<%=phone%>'/></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","phonefather",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' name='phonefather' size='40' value='<%=phonefather%>'/></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","phonemother",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' name='phonemother' size='40' value='<%=phonemother%>'/></td>
		</tr>
	</table>
	<input type='submit' name='submitButton' value='<%=getTranNoLink("web","save",sWebLanguage) %>'/>
</form>