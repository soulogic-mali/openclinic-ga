<%@page import="be.openclinic.system.SystemInfo"%>
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
			sOut+="<tr><td class='admin'>"+supportedlanguages.split(",")[n].toUpperCase()+" <input type='text' class='text' size='100' name='"+labtype+"$"+labid+"$"+supportedlanguages.split(",")[n]+"' value='"+getTranNoLink(labtype,labid,supportedlanguages.split(",")[n])+"'/></td></tr>";
		}
		sOut+="</table></td>";
		sOut+="</tr>";
		sOut+="<tr><td colspan='2'><hr/></td></tr>";
		return sOut;
	}
	private String writeConfigRow(String label,String value,String color){
		String sOut="<tr class='admin2'"+(color.length()>0?" bgcolor='"+color+"'":"")+">";
		sOut+="<td valign='top'><b>"+label+"</b></td><td><input type='text' class='text' size='100' name='config$"+value+"' value='"+MedwanQuery.getInstance().getConfigString(value)+"'/></td></tr>";
		sOut+="<tr><td colspan='2'><hr/></td></tr>";
		return sOut;
	}
	private String writeConfigRow(String label,String value,String color,String defaultValue){
		String sOut="<tr class='admin2'"+(color.length()>0?" bgcolor='"+color+"'":"")+">";
		sOut+="<td valign='top'><b>"+label+"</b></td><td><input type='text' class='text' size='100' name='config$"+value+"' value='"+MedwanQuery.getInstance().getConfigString(value,defaultValue)+"'/></td></tr>";
		sOut+="<tr><td colspan='2'><hr/></td></tr>";
		return sOut;
	}
	private String writeInfoRow(String label,String value,String color,String defaultValue){
		String sOut="<tr class='admin2'"+(color.length()>0?" bgcolor='"+color+"'":"")+">";
		sOut+="<td valign='top'><b>"+label+"</b></td><td>"+MedwanQuery.getInstance().getConfigString(value,defaultValue)+"</td></tr>";
		sOut+="<tr><td colspan='2'><hr/></td></tr>";
		return sOut;
	}
	private String writeConfigRowOnOff(String label,String value,String color,int defaultValue){
		String sOut="<tr class='admin2'"+(color.length()>0?" bgcolor='"+color+"'":"")+">";
		sOut+="<td valign='top'><b>"+label+"</b></td><td><input class='text' type='checkbox' name='config$"+value+"' "+(MedwanQuery.getInstance().getConfigInt(value,defaultValue)==1?"checked":"")+"/>";
		sOut+="<tr><td colspan='2'><hr/></td></tr>";
		return sOut;
	}
	private String writeConfigRowSelect(String label,String value,String color,String options){
		String sOut="<tr class='admin2'"+(color.length()>0?" bgcolor='"+color+"'":"")+">";
		sOut+=	"<td valign='top'><b>"+label+"</b></td><td>"+
				"<select class='text' name='config$"+value+"'>"+
				options+
				"</select>"+
				"</td></tr>";
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
		if(checkString(request.getParameter("config$reset")).equalsIgnoreCase("1")){
			MedwanQuery.getInstance().setConfigString("globalHealthBarometerUID", "");
			MedwanQuery.getInstance().setConfigString("lastPingMonitor","19000101010000");
			updated=true;
		}
	}
	if(updated){
        reloadSingleton(session);
	}
    MedwanQuery.getInstance().setConfigString("lastGlobalHealthBarometerMonitor","19000101");
    MedwanQuery.getInstance().setConfigString("lastPingMonitor","19000101010000");
	if(checkString(request.getParameter("AutoClose")).equalsIgnoreCase("1") && MedwanQuery.getInstance().getConfigString("globalHealthBarometerCenterCountry","").length()>0 && MedwanQuery.getInstance().getConfigString("globalHealthBarometerCenterCity","").length()>0){
		out.println("<script>window.close();</script>");
		out.flush();
	}
%>

<form name="searchForm" method="post">
  <%=writeTableHeader("web.manage","manageglobalhealthbarometerdata",sWebLanguage,"doBack();")%>
  <h4><%=getTran(request,"web","globalhealthbarometerinfo",sWebLanguage)%> <%=getTran(request,"web","redrowsaremandatory",sWebLanguage)%></h4><br/><hr/>
  <table width="100%" class="menu" cellspacing="0" cellpadding="1">
<%
	out.println(writeConfigRowSelect(getTran(request,"web","centerCountry",sWebLanguage),"globalHealthBarometerCenterCountry","orange","<option value=''/>"+ScreenHelper.writeSelectUpperCase("country", MedwanQuery.getInstance().getConfigString("globalHealthBarometerCenterCountry"), sWebLanguage,false,true)));
	out.println(writeConfigRow(getTran(request,"web","centerCity",sWebLanguage),"globalHealthBarometerCenterCity","orange"));
	out.println(writeConfigRow(getTran(request,"web","centerName",sWebLanguage),"globalHealthBarometerCenterName",""));
	out.println(writeConfigRow(getTran(request,"web","centerEmail",sWebLanguage),"globalHealthBarometerCenterEmail",""));
	out.println(writeConfigRow(getTran(request,"web","centerContact",sWebLanguage),"globalHealthBarometerCenterContact",""));
	out.println(writeConfigRowSelect(getTran(request,"web","centerType",sWebLanguage),"globalHealthBarometerCenterType","","<option value=''/>"+ScreenHelper.writeSelect(request,"centerType", MedwanQuery.getInstance().getConfigString("globalHealthBarometerCenterType"), sWebLanguage)));
	out.println(writeConfigRowSelect(getTran(request,"web","centerLevel",sWebLanguage),"globalHealthBarometerCenterLevel","","<option value=''/>"+ScreenHelper.writeSelect(request,"centerLevel", MedwanQuery.getInstance().getConfigString("globalHealthBarometerCenterLevel"), sWebLanguage)));
	out.println(writeConfigRow(getTran(request,"web","centerBeds",sWebLanguage),"globalHealthBarometerCenterBeds",""));
	out.println(writeConfigRowSelect(getTran(request,"web","globalhealthbarometerEnabled",sWebLanguage),"globalhealthbarometerEnabled","",ScreenHelper.writeSelect(request,"yesno", MedwanQuery.getInstance().getConfigString("globalhealthbarometerEnabled","1"), sWebLanguage)));
	out.println(writeConfigRow(getTran(request,"web","vpnDomain",sWebLanguage),"vpnDomain",""));
	out.println(writeConfigRow(getTran(request,"web","vpnName",sWebLanguage),"vpnName",""));
	out.println(writeInfoRow(getTran(request,"web","vpnAddress",sWebLanguage),"vpnAddress","",SystemInfo.getVPNIpAddress()));
	out.println(writeConfigRow(getTran(request,"web","vpnPort",sWebLanguage),"vpnPort","","80"));
	out.println(writeConfigRowSelect(getTran(request,"web","initialize",sWebLanguage),"reset","",ScreenHelper.writeSelect(request,"yesno", "0", sWebLanguage)));
	
	
%>
  </table>
  <input type='submit' name='save' value='<%=getTranNoLink("web","save",sWebLanguage)%>'/>
</form>

