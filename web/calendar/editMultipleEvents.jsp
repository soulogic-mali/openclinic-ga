<%@ page import="be.openclinic.adt.*" %>
<%@include file="/includes/validateUser.jsp"%>
<%=sCSSNORMAL %>
<%
	String begindate = checkString(request.getParameter("begindate"));
	String enddate = checkString(request.getParameter("enddate"));
	String count = checkString(request.getParameter("count"));
	String location = checkString(request.getParameter("location"));
	String userid = checkString(request.getParameter("userid"));
	String type = checkString(request.getParameter("type"));
	String color = checkString(request.getParameter("color"));
	Vector<Planning> appointments = Planning.getUserPlannings((String)session.getAttribute("calendarUser"), new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(begindate), new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(enddate));
	if(request.getParameter("submitButton")!=null){
		for(int n=0;n<appointments.size();n++){
			Planning appointment = appointments.elementAt(n);
			if(appointment.isFullDay() || new SimpleDateFormat("HH:mm:ss").format(appointment.getPlannedDate()).equalsIgnoreCase("00:00:00")){
				continue;
			}
			if(location.trim().length()>0){
				appointment.setLocation(location);
			}
			if(type.trim().length()>0){
				appointment.setType(type);
			}
			if(color.trim().length()>0){
				appointment.setColor(color);
			}
			if(userid.trim().length()>0){
				appointment.setUserUID(userid);
			}
			appointment.store();
		}
		out.println("<script>");
		out.println("if(window.opener.renderEvents) window.opener.renderEvents();");
		out.println("window.close();");
		out.println("</script>");
		out.flush();
	}
	else if(request.getParameter("doDelete")!=null){
		for(int n=0;n<appointments.size();n++){
			Planning appointment = appointments.elementAt(n);
			Planning.delete(appointment.getUid());
		}
		out.println("<script>");
		out.println("if(window.opener.renderEvents) window.opener.renderEvents();");
		out.println("window.close();");
		out.println("</script>");
		out.flush();
	}
	for(int n=0;n<appointments.size();n++){
		Planning appointment = appointments.elementAt(n);
		if(n>0 && !appointment.getLocation().equalsIgnoreCase(location)){
			location="";
			break;
		}
		else{
			location = appointment.getLocation();
		}
	}
	for(int n=0;n<appointments.size();n++){
		Planning appointment = appointments.elementAt(n);
		if(n>0 && !appointment.getType().equalsIgnoreCase(type)){
			type="";
			break;
		}
		else{
			type = appointment.getType();
		}
	}
	for(int n=0;n<appointments.size();n++){
		Planning appointment = appointments.elementAt(n);
		if(n>0 && !appointment.getColor().equalsIgnoreCase(color)){
			type="";
			break;
		}
		else{
			color = appointment.getColor();
		}
	}
	
%>
<form name='transactionForm' method='POST'>
	<input type='hidden' name='begindate' value='<%=begindate %>'/>
	<input type='hidden' name='enddate' value='<%=enddate %>'/>
	<input type='hidden' name='count' value='<%=count %>'/>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='2'><%=getTran(request,"web","editappointments",sWebLanguage)%> (<%=count %>)</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","begin",sWebLanguage) %></td>
			<td class='admin2'>
				<%=new SimpleDateFormat("dd/MM/yyyy HH:mm").format(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(begindate)) %>
			</td>
		</td>
		<tr>
			<td class='admin'><%=getTran(request,"web","end",sWebLanguage) %></td>
			<td class='admin2'>
				<%=new SimpleDateFormat("dd/MM/yyyy HH:mm").format(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(enddate)) %>
			</td>
		</td>
		<tr>
			<td class='admin'><%=getTran(request,"web","user",sWebLanguage) %></td>
			<td class='admin2'>
				<input type='hidden' name='userid' id='userid' value='<%=(String)session.getAttribute("calendarUser")%>'/>
				<input type='text' class='text' size='30' name='username' id='username' readonly value='<%=User.getFullUserName((String)session.getAttribute("calendarUser"))%>'/>
				<img style='vertical-align: middle' src='<%=sCONTEXTPATH %>/_img/icons/icon_search.png' onclick='showSearchUserPopup("userid","username")'/>
				<img style='vertical-align: middle' src='<%=sCONTEXTPATH %>/_img/icons/icon_delete.png' onclick='document.getElementById("userid").value="";document.getElementById("username").value="";'/>
			</td>
		</td>
		<tr>
			<td class='admin'><%=getTran(request,"web","location",sWebLanguage) %></td>
			<td class='admin2'>
				<select class='text' name='location' id='location'>
					<option value=' ' <%=location.length()==0?"selected":"" %>>-</option>
					<%=ScreenHelper.writeSelect(request,"appointment.location",location,sWebLanguage) %>
				</select>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","type",sWebLanguage) %></td>
			<td class='admin2'>
				<select class='text' name='type' id='type'>
					<option value=' ' <%=type.length()==0?"selected":"" %>>-</option>
					<%=ScreenHelper.writeSelect(request,"appointment.types",type,sWebLanguage) %>
				</select>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","color",sWebLanguage) %></td>
			<td class='admin2'>
				<select class='minitext' name='color' id='color' onchange='this.style.backgroundColor=this.options[this.selectedIndex].style.backgroundColor;this.style.color=this.options[this.selectedIndex].style.color;'>
					<option value=' ' <%=color.length()==0?"selected":"" %>>-</option>
					<option value=' ' style='background-color: #FFFFFF; color: #000000'>Auto</option>
					<%
						String[] colors = MedwanQuery.getInstance().getConfigString("agendaColors","E6C79C=000000;CDDFA0=000000;6FD08C=000000;7B9EA8=FFFFFF;78586F=FFFFFF;C8FFBE=000000;EDFFAB=000000;BA9593=FFFFFF;EBEBD3=000000;DA4167=FFFFFF;F78764=FFFFFF").split(";");
						for(int n=0;n<colors.length;n++){
							out.println("<option "+((colors[n]).equalsIgnoreCase(color)?"selected":"")+" value='"+colors[n]+"' style='background-color: #"+colors[n].split("=")[0]+";color: #"+colors[n].split("=")[1]+"'>"+ScreenHelper.padLeft(n+"", "&nbsp;", 6)+"</option>");
						}
					%>
				</select>
			</td>
		</tr>
	</table>
	<input type='hidden' name='doDelete' id='doDelete' value=''/>
	<input type='submit' class='button' name='submitButton' value='<%=getTranNoLink("web","update",sWebLanguage) %>'/>
	<input type='button' onclick='doDeleteFunction();' class='button' name='deleteButton' value='<%=getTranNoLink("web","delete",sWebLanguage) %>'/>
</form>

<script>
	function doDeleteFunction(){
		if(window.confirm('<%=getTranNoLink("web","areyousure",sWebLanguage)%>')){
			document.getElementById('doDelete').value='1';
			transactionForm.submit();
		}		
	}
	function showSearchUserPopup(pid,personName){
	  	var url = "<c:url value="/popup.jsp?Page=_common/search/searchUser.jsp"/>&ts=<%=getTs()%>&PopupWidth=600&PopupHeight=400"+
	              "&ReturnUserID="+pid+
	              "&ReturnName="+personName;
	
	  	window.open(url,"searchUserPopup","height=1,width=1,toolbar=no,status=no,scrollbars=no,resizable=no,menubar=no");
	}
	document.getElementById('color').onchange();
</script>