<%@page import="be.openclinic.datacenter.DatacenterHelper"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>

<%
	String sId = SH.c(request.getParameter("id"));
%>

<table width='100%'>
	<tr>
		<td class='admin' width='1%' nowrap><%=getTran(request,"web","id",sWebLanguage) %>&nbsp;</td>
		<td class='admin2'><%=sId.equalsIgnoreCase("NEW")?"":sId %><input type='hidden' name='group_id' value='<%= sId %>'/></td>
	</tr>
	<%
		String[] supportedLanguages = SH.cs("supportedLanguages","en").split(",");
		for(int n=0;n<supportedLanguages.length;n++){
			out.println("<tr>");
			out.println("<td class='admin'>"+supportedLanguages[n].toUpperCase()+"</td>");
			if(sId.equalsIgnoreCase("NEW")){
				out.println("<td class='admin2'><input type='text' class='text' name='group_name_"+supportedLanguages[n].toLowerCase()+"' value='' size='40'/></td>");
			}
			else{
				out.println("<td class='admin2'><input type='text' class='text' name='group_name_"+supportedLanguages[n].toLowerCase()+"' value='"+getTranNoLink("datacenterservergroup",sId,supportedLanguages[n].toLowerCase())+"' size='40'/></td>");
			}
			out.println("</tr>");
		}
		int associatedServers = DatacenterHelper.getServersForGroup(sId).size();
	%>
	<% if(!sId.equalsIgnoreCase("NEW")){ %>
		<tr>
			<td class='admin' width='1%' nowrap><%=getTran(request,"web","serverslinked",sWebLanguage) %>&nbsp;</td>
			<td class='admin2'><a href="<%=sCONTEXTPATH %>/main.jsp?Page=system/manageDatacenterServers.jsp&groupid=<%=sId%>"><%=associatedServers %></a></td>
		</tr>
	<% } %>
	<tr>
		<td/>
		<td>
			<input type='submit' class='button' name='saveButton' value='<%=getTranNoLink("web","save",sWebLanguage) %>'/>
			<%if(!sId.equalsIgnoreCase("NEW") && associatedServers==0){%>
				<input type='submit' class='button' name='deleteButton' value='<%=getTranNoLink("web","delete",sWebLanguage) %>'/>
			<%} %>
		</td>
	</tr>
</table>
