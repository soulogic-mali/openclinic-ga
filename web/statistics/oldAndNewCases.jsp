<%@page import="java.util.*,
                java.sql.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"statistics","select",activeUser)%>

<%
	String begin = checkString(request.getParameter("start")),
	       end   = checkString(request.getParameter("end"));

	Hashtable newcases = new Hashtable(),
			  oldcases = new Hashtable();
	int unknown=0;
	
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	String serverid = MedwanQuery.getInstance().getConfigString("serverId");
	String sSql = "select distinct a.OC_RFE_ENCOUNTERUID, a.OC_RFE_FLAGS"+
	              " from OC_RFE a, OC_ENCOUNTERS b"+
	              "  where b.OC_ENCOUNTER_OBJECTID = replace(a.OC_RFE_ENCOUNTERUID,'"+serverid+".','')"+
	              "   and b.OC_ENCOUNTER_BEGINDATE >= ?"+
	              "   and OC_ENCOUNTER_BEGINDATE < ?";
	PreparedStatement ps = conn.prepareStatement(sSql);
	ps.setTimestamp(1,new java.sql.Timestamp(ScreenHelper.parseDate(begin).getTime()));
	ps.setTimestamp(2,new java.sql.Timestamp(ScreenHelper.fullDateFormat.parse(end+" 23:59").getTime()));
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		if(rs.getString("OC_RFE_FLAGS").indexOf("N")>-1){
			newcases.put(rs.getString("OC_RFE_ENCOUNTERUID"),"1");
		}
		else {
			oldcases.put(rs.getString("OC_RFE_ENCOUNTERUID"),"1");
		}
	}
	rs.close();
	ps.close();
	ps=conn.prepareStatement("select count(*) unknown from oc_encounters where not exists (select * from oc_rfe where oc_rfe_encounteruid=oc_encounter_serverid"+
								MedwanQuery.getInstance().concatSign()+"'.'"+MedwanQuery.getInstance().concatSign()+"oc_encounter_objectid) and"+
								" OC_ENCOUNTER_BEGINDATE >= ? and OC_ENCOUNTER_BEGINDATE < ?");
	ps.setTimestamp(1,new java.sql.Timestamp(ScreenHelper.parseDate(begin).getTime()));
	ps.setTimestamp(2,new java.sql.Timestamp(ScreenHelper.fullDateFormat.parse(end+" 23:59").getTime()));
	rs=ps.executeQuery();
	if(rs.next()){
		unknown=rs.getInt("unknown");
	}
	rs.close();
	ps.close();
%>

<table width="100%" class="list" cellspacing="1" cellpadding="0">
	<tr class='admin'><td colspan='2'><%=getTran(request,"web","statistics.oldandnewcases",sWebLanguage)%></td></tr>
	<tr class='admin'><td colspan='2'><%=getTran(request,"web","clinicaldefinition",sWebLanguage)%></td></tr>
	
	<tr class='admin2'>
		<td class='admin'><%=getTran(request,"web","period",sWebLanguage)%></td>
		<td class='admin2'><%=begin%> - <%=end%></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","statistics.oldcases",sWebLanguage)%></td>
		<td class='admin2'><%=oldcases.size()%></td>
	</tr>
	<tr class='admin2'>
		<td class='admin'><%=getTran(request,"web","statistics.newcases",sWebLanguage)%></td>
		<td class='admin2'><%=newcases.size()%></td>
	</tr>
	<tr class='admin2'>
		<td class='admin'><%=getTran(request,"web","statistics.unknown",sWebLanguage)%></td>
		<td class='admin2'><%=unknown%></td>
	</tr>

<%
	int nNewcases=0,nOldcases=0;
	ps=conn.prepareStatement("select count(*) newcases from oc_encounters a where not exists (select * from oc_encounters "+
			" where oc_encounter_patientuid=a.oc_encounter_patientuid and oc_encounter_begindate<a.oc_encounter_begindate and"+
			" "+MedwanQuery.getInstance().datediff("d", "oc_encounter_begindate", "a.oc_encounter_begindate")+"<"+MedwanQuery.getInstance().getConfigInt("maxIntervalInDaysForOldCase",15)+") and"+
			" OC_ENCOUNTER_BEGINDATE >= ? and OC_ENCOUNTER_BEGINDATE < ?");
	ps.setTimestamp(1,new java.sql.Timestamp(ScreenHelper.parseDate(begin).getTime()));
	ps.setTimestamp(2,new java.sql.Timestamp(ScreenHelper.fullDateFormat.parse(end+" 23:59").getTime()));
	rs=ps.executeQuery();
	if(rs.next()){
		nNewcases=rs.getInt("newcases");
	}
	rs.close();
	ps.close();
	ps=conn.prepareStatement("select count(*) oldcases from oc_encounters a where exists (select * from oc_encounters "+
			" where oc_encounter_patientuid=a.oc_encounter_patientuid and oc_encounter_begindate<a.oc_encounter_begindate and"+
			" "+MedwanQuery.getInstance().datediff("d", "oc_encounter_begindate", "a.oc_encounter_begindate")+"<"+MedwanQuery.getInstance().getConfigInt("maxIntervalInDaysForOldCase",15)+") and"+
			" OC_ENCOUNTER_BEGINDATE >= ? and OC_ENCOUNTER_BEGINDATE < ?");
	ps.setTimestamp(1,new java.sql.Timestamp(ScreenHelper.parseDate(begin).getTime()));
	ps.setTimestamp(2,new java.sql.Timestamp(ScreenHelper.fullDateFormat.parse(end+" 23:59").getTime()));
	rs=ps.executeQuery();
	if(rs.next()){
		nOldcases=rs.getInt("oldcases");
	}
	rs.close();
	ps.close();
	conn.close();

%>

	<tr><td colspan='2'><hr/></td></tr>
	<tr class='admin'><td colspan='2'><%=getTran(request,"web","administrativedefinition",sWebLanguage)%> (<<%=MedwanQuery.getInstance().getConfigInt("maxIntervalInDaysForOldCase",15)%> <%=getTran(request,"web","days",sWebLanguage)%>)</td></tr>
	
	<tr>
		<td class='admin'><%=getTran(request,"web","statistics.oldcases",sWebLanguage)%></td>
		<td class='admin2'><%=nOldcases%></td>
	</tr>
	<tr class='admin2'>
		<td class='admin'><%=getTran(request,"web","statistics.newcases",sWebLanguage)%></td>
		<td class='admin2'><%=nNewcases%></td>
	</tr>

</table>

<%=ScreenHelper.alignButtonsStart()%>
    <input type="button" class="button" name="closeButton" value="<%=getTranNoLink("web","close",sWebLanguage)%>" onClick="window.close();">
<%=ScreenHelper.alignButtonsStop()%>