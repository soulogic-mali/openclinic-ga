<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%!
	String doCompare(String field, HttpServletRequest request,String mpi, String local, String sWebLanguage){
		String f_mpi = checkString(mpi);
		String f_local = checkString(local);
		if(f_mpi.equalsIgnoreCase(f_local)){
			String checkMark="";
			if(f_mpi.length()>0){
				checkMark="<img style='vertical-align: middle' src='"+sCONTEXTPATH+"/_img/icons/icon_check.png'>";
			}
			return checkMark+"<font style='font-size:12px;font-weight: bolder' color='black'>"+f_mpi+"</font></td><td class='admin2'/>";
		}
		else{
			String sRadios="<script>document.getElementById('updatempiidButton').style.display='';</script>";
			if(f_mpi.length()>0){
				sRadios+="<br/><input type='radio' ondblclick='this.checked=!this.checked' class='text' value='"+f_mpi+"' name='rb_"+field+"' id='rb_"+field+"' "+(f_local.length()==0?"checked":"")+">"+getTran(request,"web","usevalue",sWebLanguage)+" <b>"+f_mpi+"</b> "+getTran(request,"web","forbothservers",sWebLanguage);
			}
			if(f_local.length()>0){
				sRadios+="<br/><input type='radio' ondblclick='this.checked=!this.checked' class='text' value='"+f_local+"' name='rb_"+field+"' id='rb_"+field+"' "+(f_mpi.length()==0?"checked":"")+">"+getTran(request,"web","usevalue",sWebLanguage)+" <b>"+f_local+"</b> "+getTran(request,"web","forbothservers",sWebLanguage);
			}
			return "<img style='vertical-align: middle' src='"+sCONTEXTPATH+"/_img/icons/icon_warning.gif'><font style='font-size:12px;font-weight: bolder' color='black'>"+f_mpi+"</font></td><td class='admin2'><font style='font-style:italic' color='grey'>"+getTran(request,"web","localvaluediffersfrommpi",sWebLanguage)+"</font>: <b>"+f_local+"</b>"+sRadios+"</i></td>";
		}
	}
	String doCompare(String field, String mpivalue, String localvalue,HttpServletRequest request,String mpi, String local, String sWebLanguage){
		String f_mpi = checkString(mpi);
		String f_local = checkString(local);
		if(f_mpi.equalsIgnoreCase(f_local)){
			String checkMark="";
			if(f_mpi.length()>0){
				checkMark="<img style='vertical-align: middle' src='"+sCONTEXTPATH+"/_img/icons/icon_check.png'>";
			}
			return checkMark+"<font style='font-size:12px;font-weight: bolder' color='black'>"+f_mpi+"</font></td><td class='admin2'/>";
		}
		else{
			String sRadios="<script>document.getElementById('updatempiidButton').style.display='';</script>";
			if(f_mpi.length()>0){
				sRadios+="<br/><input type='radio' ondblclick='this.checked=!this.checked' class='text' value='"+mpivalue+"' name='rb_"+field+"' id='rb_"+field+"' "+(f_local.length()==0?"checked":"")+">"+getTran(request,"web","usevalue",sWebLanguage)+" <b>"+f_mpi+"</b> "+getTran(request,"web","forbothservers",sWebLanguage);
			}
			if(f_local.length()>0){
				sRadios+="<br/><input type='radio' ondblclick='this.checked=!this.checked' class='text' value='"+localvalue+"' name='rb_"+field+"' id='rb_"+field+"' "+(f_mpi.length()==0?"checked":"")+">"+getTran(request,"web","usevalue",sWebLanguage)+" <b>"+f_local+"</b> "+getTran(request,"web","forbothservers",sWebLanguage);
			}
			return "<img style='vertical-align: middle' src='"+sCONTEXTPATH+"/_img/icons/icon_warning.gif'><font style='font-size:12px;font-weight: bolder' color='black'>"+f_mpi+"</font></td><td class='admin2'><font style='font-style:italic' color='grey'>"+getTran(request,"web","localvaluediffersfrommpi",sWebLanguage)+"</font>: <b>"+f_local+"</b>"+sRadios+"</i></td>";
		}
	}
%>
<%
	AdminPerson person = (AdminPerson)session.getAttribute("f_person");
	AdminPrivateContact apc = person.getActivePrivate();
	if(checkString((String)person.adminextends.get("mpiid")).length()>0){
%>
<form name="mpiTransactionForm" method="post">
	<table width='100%'>
		<tr class='admin'>
			<td><%=getTran(request,"web","field",sWebLanguage) %></td>
			<td><%=getTran(request,"web","mpivalue",sWebLanguage) %></td>
			<td><%=getTran(request,"web","remarks",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin' nowrap><%=getTran(request,"web","MPIID",sWebLanguage) %></td>
			<td class='admin2'><font style='font-size:14px;font-weight: bolder' color='red'><%=checkString((String)person.adminextends.get("mpiid")) %></font></td>
			<td class='admin2'>
				<input type='button' class='button' name='unlinkmpiidButton' onclick='unlinkmpiid("<%=checkString((String)person.adminextends.get("mpiid")) %>");' value='<%=getTranNoLink("web","unlinkthisid",sWebLanguage)%>'/>
				<input type='button' class='button' style='display: none' name='updatempiidButton' id='updatempiidButton' onclick='updatempi()' value='<%=getTranNoLink("web","update",sWebLanguage)%>'/>
			</td>
		</tr>
		<tr valign='middle'>
			<td class='admin' nowrap><%=getTran(request,"web","natreg",sWebLanguage) %></td>
			<td class='admin2' nowrap><%=doCompare("natreg",request,person.getID("natreg"),activePatient.getID("natreg"),sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin' nowrap><%=getTran(request,"web","lastname",sWebLanguage) %></td>
			<td class='admin2' nowrap><%=doCompare("lastname",request,person.lastname.toUpperCase(),activePatient.lastname.toUpperCase(),sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin' nowrap><%=getTran(request,"web","firstname",sWebLanguage) %></td>
			<td class='admin2' nowrap><%=doCompare("firstname",request,person.firstname.toUpperCase(),activePatient.firstname.toUpperCase(),sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin' nowrap><%=getTran(request,"web","dateofbirth",sWebLanguage) %></td>
			<td class='admin2' nowrap><%=doCompare("dateofbirth",request,person.dateOfBirth,activePatient.dateOfBirth,sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin' nowrap><%=getTran(request,"web","gender",sWebLanguage) %></td>
			<td class='admin2' nowrap><%=doCompare("gender",checkString(person.gender),checkString(activePatient.gender),request,getTranNoLink("gender",checkString(person.gender),sWebLanguage),getTranNoLink("gender",checkString(activePatient.gender),sWebLanguage),sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin' nowrap><%=getTran(request,"web","language",sWebLanguage) %></td>
			<td class='admin2' nowrap><%=doCompare("language",checkString(person.language),checkString(activePatient.language),request,getTranNoLink("web.language",checkString(person.language),sWebLanguage),getTranNoLink("web.language",checkString(activePatient.language),sWebLanguage),sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin' nowrap><%=getTran(request,"web","address",sWebLanguage) %></td>
			<td class='admin2' nowrap><%=doCompare("address",request,apc.address,activePatient.getActivePrivate().address,sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin' nowrap><%=getTran(request,"web","city",sWebLanguage) %></td>
			<td class='admin2' nowrap><%=doCompare("city",request,apc.city,activePatient.getActivePrivate().city,sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin' nowrap><%=getTran(request,"web","zipcode",sWebLanguage) %></td>
			<td class='admin2' nowrap><%=doCompare("zipcode",request,apc.zipcode,activePatient.getActivePrivate().zipcode,sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin' nowrap><%=getTran(request,"web","district",sWebLanguage) %></td>
			<td class='admin2' nowrap><%=doCompare("district",request,apc.district,activePatient.getActivePrivate().district,sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin' nowrap><%=getTran(request,"web","country",sWebLanguage) %></td>
			<td class='admin2' nowrap><%=doCompare("country",checkString(apc.country),checkString(activePatient.getActivePrivate().country),request,getTranNoLink("country",checkString(apc.country),sWebLanguage),getTranNoLink("country",checkString(activePatient.getActivePrivate().country),sWebLanguage),sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin' nowrap><%=getTran(request,"web","telephone",sWebLanguage) %></td>
			<td class='admin2' nowrap><%=doCompare("telephone",request,apc.telephone,activePatient.getActivePrivate().telephone,sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin' nowrap><%=getTran(request,"web","mobile",sWebLanguage) %></td>
			<td class='admin2' nowrap><%=doCompare("mobile",request,apc.mobile,activePatient.getActivePrivate().mobile,sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin' nowrap><%=getTran(request,"web","email",sWebLanguage) %></td>
			<td class='admin2' nowrap><%=doCompare("email",request,apc.email,activePatient.getActivePrivate().email,sWebLanguage) %></td>
		</tr>
	</table>
</form>
<%
	}
	else{
		if(checkString(person.updateStatus).length()>0){
			%>
			<table width='100%'>
			<tr>
				<td id='divmpi' width='100%'>
					<font style='font-size: 12px;color: red'><%=getTran(request,"web","mpiservererror",sWebLanguage) %></font><br/><br/><%=person.updateStatus %>
				</td>
			</tr>
		</table>
		<%
		}
		else{
%>
	<table width='100%'>
		<tr>
			<td id='divmpi' width='100%'>
				<br/><font style='font-size: 12px;color: red'><%=getTran(request,"web","nompiid_search",sWebLanguage) %></font> <input type='button' class='button' onclick='loadSearchMPI();' name='searchmpi' id='searchmpi' value='<%=getTranNoLink("web","yes",sWebLanguage)%>'/>
			</td>
		</tr>
		<tr id='divmpisearch' style='display:none'>
		</tr>
	</table>
<%
		}
	}
%>