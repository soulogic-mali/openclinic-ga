<%@page import="be.mxs.common.util.db.MedwanQuery,
                be.openclinic.system.Config,java.util.Hashtable,java.util.Enumeration" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>
<%!
	private String writeConfigRow(String labtype,String defaultValue){
		String sOut="<tr class='admin2'>";
		sOut+="<td valign='top'>"+labtype+"</td><td><textarea onKeyup='resizeTextarea(this,10);' class='text' cols='100', rows='1' name='config$"+labtype+"'>"+MedwanQuery.getInstance().getConfigString(labtype,defaultValue)+"</textarea></td></tr>";
		sOut+="<tr><td colspan='2'><hr/></td></tr>";
		return sOut;
	}
	private String writeConfigRowLink(String labtype,String defaultValue,String link){
		String sOut="<tr class='admin2'>";
		sOut+="<td valign='middle'>"+labtype+" <img style='vertical-align: middle' src='"+sCONTEXTPATH+"/_img/icons/icon_search.png' onclick='"+link+"'/></td><td><textarea onKeyup='resizeTextarea(this,10);' class='text' cols='100', rows='1' name='config$"+labtype+"'id='config$"+labtype+"'>"+MedwanQuery.getInstance().getConfigString(labtype,defaultValue)+"</textarea></td></tr>";
		sOut+="<tr><td colspan='2'><hr/></td></tr>";
		return sOut;
	}
	private String writeConfigRowPassword(String labtype,String defaultValue){
		String sOut="<tr class='admin2'>";
		sOut+="<td valign='top'>"+labtype+"</td><td><input class='text' size='100', rows='1' type='password' name='config$"+labtype+"' id='config$"+labtype+"' value='"+MedwanQuery.getInstance().getConfigString(labtype,defaultValue)+"'/></td></tr>";
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
			if(sParName.split("\\$").length==2 && sParName.split("\\$")[0].equalsIgnoreCase("config")){
				MedwanQuery.getInstance().setConfigString(sParName.split("\\$")[1],checkString(request.getParameter(sParName)));
			}
		}
	}
%>
<form name="searchForm" method="post">
  <%=writeTableHeader("web.manage","manageDHIS2",sWebLanguage,"doBack();")%>
  <table width="100%" class="menu" cellspacing="0" cellpadding="1">
	<%
		out.println("<tr>");
		out.println("<td valign='middle'>enableDHIS2</td><td valign='middle'><input class='text' type='radio' "+(SH.cs("enableDHIS2","0").equalsIgnoreCase("0")?"checked":"")+" name='config$enableDHIS2' value='0'/>0 <input class='text' type='radio' "+(SH.cs("enableDHIS2","0").equalsIgnoreCase("1")?"checked":"")+" name='config$enableDHIS2' value='1'/>1</td></tr>");
		out.println("<tr><td colspan='2'><hr/></td></tr>");
		out.println(writeConfigRow("dhis2_server_uri","https://play.dhis2.org/demo"));
		out.println(writeConfigRow("dhis2_server_api","/api"));
		out.println(writeConfigRow("dhis2_server_port","443"));
		out.println(writeConfigRow("dhis2_server_username","demo"));
		out.println(writeConfigRowPassword("dhis2_server_pwd","demo"));
		out.println(writeConfigRowLink("dhis2_orgunit","","javascript:exploreDHIS2()"));
		out.println(writeConfigRow("dhis2document","dhis2.bi.xml"));
		out.println(writeConfigRow("dhis2_truststore","/temp/keystore"));
		out.println(writeConfigRowPassword("dhis2_truststore_pass","changeme"));
		out.println(writeConfigRow("sendFullDHIS2DataSets","0"));
	%>
  </table>
  <input type='submit' name='save' value='<%=getTranNoLink("web","save",sWebLanguage)%>'/>
</form>
	
<script>
	function exploreDHIS2(){
		if(document.getElementById('config$dhis2_orgunit').value.length>0){
			openPopup("dhis2/analyzeDHIS2.jsp&updatefield=config$dhis2_orgunit&getOrganisationunitsButton=1&organisationunitname="+document.getElementById('config$dhis2_orgunit').value,800,600);
		}
		else{
			openPopup("dhis2/analyzeDHIS2.jsp&updatefield=config$dhis2_orgunit",800,600);
		}
	}
</script>