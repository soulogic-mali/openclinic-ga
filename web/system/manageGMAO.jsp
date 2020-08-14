<%@page import="be.mxs.common.util.db.MedwanQuery,
                be.openclinic.system.Config,java.util.Hashtable,java.util.Enumeration" %>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>
<%!
	private String writeRow(String labtype,String labid){
		String sOut="<tr class='admin2'>";
		sOut+="<td valign='top'>"+labtype+"$"+labid+"</td><td><table width='100%'>";
		String supportedlanguages=MedwanQuery.getInstance().getConfigString("supportedLanguages","fr,en,nl");
		for(int n=0;n<supportedlanguages.split(",").length;n++){
			sOut+="<tr><td class='admin'>"+supportedlanguages.split(",")[n].toUpperCase()+" <textarea onKeyup='resizeTextarea(this,10);' class='text' cols='100', rows='1' name='"+labtype+"$"+labid+"$"+supportedlanguages.split(",")[n]+"'>"+getTranNoLink(labtype,labid,supportedlanguages.split(",")[n])+"</textarea></td></tr>";
		}
		sOut+="</table></td>";
		sOut+="</tr>";
		sOut+="<tr><td colspan='2'><hr/></td></tr>";
		return sOut;
	}
	private String writeConfigRow(String labtype,String sDefault){
		String sOut="<tr class='admin2'>";
		sOut+="<td valign='top'>"+labtype+"</td><td><textarea onKeyup='resizeTextarea(this,10);' class='text' cols='100', rows='1' name='config$"+labtype+"'>"+MedwanQuery.getInstance().getConfigString(labtype,sDefault)+"</textarea></td></tr>";
		sOut+="<tr><td colspan='2'><hr/></td></tr>";
		return sOut;
	}
%>
<%
	boolean updated=false;
	if(request.getParameter("save")!=null){
		//Save configuration
		Enumeration e = request.getParameterNames();
		while(e.hasMoreElements()){
			String sParName=(String)e.nextElement();
			if(sParName.split("\\$").length==3){
				String sParValue=checkString(request.getParameter(sParName));
				if(!sParValue.equals(getTranNoLink(sParName.split("\\$")[0],sParName.split("\\$")[1],sParName.split("\\$")[2]))){
					updated=true;
	                boolean bExists=false;
					Label oldLabel = new Label();
	                oldLabel.type = sParName.split("\\$")[0];
	                oldLabel.id = sParName.split("\\$")[1];
	                oldLabel.language = sParName.split("\\$")[2];

	                if (oldLabel.exists()) bExists = true;

	                if (bExists) {
	                    Label label = new Label();
	                    label.type = sParName.split("\\$")[0];
	                    label.id = sParName.split("\\$")[1];
	                    label.language = sParName.split("\\$")[2];
	                    label.value = sParValue;
	                    label.updateUserId = activeUser.userid;
	                    label.showLink = "false";

	                    label.updateByTypeIdLanguage(sParName.split("\\$")[0], sParName.split("\\$")[1], sParName.split("\\$")[2]);

	                }
	                else {
	                	MedwanQuery.getInstance().storeLabel(sParName.split("\\$")[0],sParName.split("\\$")[1],sParName.split("\\$")[2],sParValue,Integer.parseInt(activeUser.userid));	
	                }
				}
			}
			else if(sParName.split("\\$").length==2 && sParName.split("\\$")[0].equalsIgnoreCase("config")){
				MedwanQuery.getInstance().setConfigString(sParName.split("\\$")[1],checkString(request.getParameter(sParName)));
			}
			
		}
	}
	if(updated){
        reloadSingleton(session);
	}
%>

<form name="searchForm" method="post">
  <%=writeTableHeader("web.manage","gmaoconfig",sWebLanguage,"doBack();")%>
  <table width="100%" class="menu" cellspacing="0" cellpadding="1">
<%
	out.println(writeConfigRow("GMAOCentralServer","http://localhost/gmao"));
	out.println(writeConfigRow("GMAOCentralServerDocumentStore","http://localhost/gmao/scan/to"));
	out.println(writeConfigRow("GMAOLocalServerId","0"));
%>
  </table>
  <input type='submit' name='save' value='<%=getTranNoLink("web","save",sWebLanguage)%>'/>
</form>

