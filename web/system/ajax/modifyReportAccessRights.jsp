<%@page import="java.util.*,net.admin.*,be.mxs.common.util.db.*"%>
<%
	String reportgroup=request.getParameter("reportgroup");
	String groupaccessrights=MedwanQuery.getInstance().getConfigString("reportGroupAccessRights."+reportgroup,"");
%>
<table width='100%'>
	<tr>
		<td><%=request.getParameter("title") %></td>
		<td>
			<select size="5" name='reportprofiles' id='reportprofiles' multiple="multiple">
			<%
				Vector userprofiles = UserProfile.getUserProfiles();
				for(int n=0;n<userprofiles.size();n++){
					UserProfile userprofile = (UserProfile)userprofiles.elementAt(n);
					if(userprofile.getUserprofilename()!=null && userprofile.getUserprofilename().trim().length()>0){
						out.println("<option value='"+userprofile.getUserprofileid()+"'"+(groupaccessrights.indexOf(";"+userprofile.getUserprofileid()+";")>-1?" selected":"")+">"+userprofile.getUserprofilename()+"</option>");
					}
				}
			%>
			</select>
		</td>
	</tr>
</table>							
<%
%>
