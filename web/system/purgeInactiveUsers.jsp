<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>
<!-- 
	Code created by OpenClinic Developers Academy 2/2021 in Bujumbura
 -->
<%
	String lastAccess = "";
	if(request.getParameter("lastaccess")!=null){
		lastAccess=request.getParameter("lastaccess");
	}
	if(lastAccess.length()==0){
		lastAccess = SH.formatDate(new java.util.Date(new java.util.Date().getTime()-90*SH.getTimeDay()));
	}
	if(request.getParameter("deactivateButton")!=null){
		Enumeration parnames = request.getParameterNames();
		while(parnames.hasMoreElements()){
			String parname = (String)parnames.nextElement();
			if(parname.startsWith("deactivateuser")){
				String userid = parname.split("\\.")[1];
				User user = User.get(Integer.parseInt(userid));
				user.setStop(new java.util.Date());
				user.saveToDB();
			}
		}
	}
%>
<form name='reportForm' method='POST'>
	<%= getTran(request,"web","lastuseraccess",sWebLanguage)%>: <%=SH.writeDateField("lastaccess", "reportForm", lastAccess, true, false, sWebLanguage, sCONTEXTPATH) %>
	<input type='submit' name='submitButton' value='<%=getTranNoLink("web","search",sWebLanguage)%>'/>
	<input type='submit' name='deactivateButton' value='<%=getTranNoLink("web","deactivate",sWebLanguage)%>'/>

	<table width='100%'>
		<tr class='admin'>
			<td><%=getTran(request,"web","userid",sWebLanguage) %></td>
			<td><%=getTran(request,"web","username",sWebLanguage) %></td>
			<td><%=getTran(request,"web","lastaccess",sWebLanguage) %></td>
		</tr>
	<%
		Connection conn = MedwanQuery.getInstance().getAdminConnection();
		String sSql=	"select max(accesstime) maxtime,accesslogs.userid"+
						" from accesslogs,users where accesslogs.userid=users.userid"+
						" and users.stop is null group by userid having maxtime<?"+
						" union"+
						" select start maxtime, userid from users where"+
						" stop is null and userid not in (select userid from accesslogs)"+
						" and start<?";
		PreparedStatement ps = conn.prepareStatement(sSql);
		ps.setDate(1,new java.sql.Date(SH.parseDate(lastAccess).getTime()));
		ps.setDate(2,new java.sql.Date(SH.parseDate(lastAccess).getTime()));
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
			String userid = rs.getString("userid");
			User user = User.get(Integer.parseInt(userid));
			java.util.Date maxtime = rs.getTimestamp("maxtime");
			out.println("<tr>");
			out.println("	<td class='admin'>"+
						"		<input type='checkbox' class='text' checked "+
						"		name='deactivateuser."+userid+"'/> "+userid+
						"	</td>");
			out.println("	<td class='admin'>"+user.person.getFullName()+"</td>");
			out.println("	<td class='admin'>"+
						new SimpleDateFormat("dd/MM/yyyy HH:mm").format(maxtime)+"</td>");
			out.println("</tr>");
		}
		rs.close();
		ps.close();
		conn.close();
	%>
	</table>
</form>