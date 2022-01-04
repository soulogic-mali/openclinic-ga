<%@page import="java.text.SimpleDateFormat,
                be.openclinic.pharmacy.Product,
                be.openclinic.medical.Prescription,
                java.text.DecimalFormat,
                be.openclinic.pharmacy.ServiceStock,
                be.openclinic.common.KeyValue,
                be.openclinic.pharmacy.PrescriptionSchema,
                be.openclinic.finance.*,
                java.util.Vector"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<table width='100%'>
<%
	boolean bInit=false;
	boolean bPaid=false;
	String sKey = checkString(request.getParameter("key"));
	String encounterUid=checkString(request.getParameter("EditEncounterUID"));
	Encounter encounter = Encounter.get(encounterUid);
	if(encounter!=null && encounter.hasValidUid()){
		Connection conn=MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps=conn.prepareStatement("select * from OC_NURSINGDEBETS where OC_NURSINGDEBET_KEY like ? and OC_NURSINGDEBET_DATE>? order by OC_NURSINGDEBET_DATE DESC,OC_NURSINGDEBET_DEBETUID");
		if(sKey.split("\\_").length<3){
			ps.setString(1,sKey+"%");
		}
		else{
			ps.setString(1,sKey);
		}
		long day = 24*3600*1000;
		ps.setDate(2,new java.sql.Date(new java.util.Date().getTime()-SH.ci("nursingPrestationsSearchablePeriod",365)*day));
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
			if(ScreenHelper.parseDate(ScreenHelper.formatDate(encounter.getBegin())).after(rs.getDate("OC_NURSINGDEBET_DATE"))){
				continue;
			}
			else if(encounter.getEnd()!=null && ScreenHelper.parseDate(ScreenHelper.formatDate(encounter.getEnd())).before(rs.getDate("OC_NURSINGDEBET_DATE"))){
				continue;
			}
			Prestation prestation = Prestation.get(rs.getString("OC_NURSINGDEBET_PRESTATIONUID"));
			if(prestation!=null){
				if(!bInit){
					out.println("<tr class='admin'>");
					out.println("<td/>");
					out.println("<td>"+getTran(request,"web","date",sWebLanguage)+"&nbsp;</td>");
					out.println("<td/><td>"+getTran(request,"web","prestation",sWebLanguage)+"&nbsp;</td>");
					out.println("<td>"+getTran(request,"web","user",sWebLanguage)+"&nbsp;</td>");
					out.println("</tr>");
					bInit=true;
				}
				if(checkString(rs.getString("OC_NURSINGDEBET_DEBETUID")).length()==0 && activeUser.getAccessRight("financial.invoicenursingactivities.add")){
					String uid=rs.getString("OC_NURSINGDEBET_SERVERID")+"."+rs.getString("OC_NURSINGDEBET_OBJECTID");
					out.println("<tr>");
					out.println("<td class='admin2' nowrap width='1%'><img height='16px' src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' onclick='deletePrestation(\""+uid+"\")'/>&nbsp;</td>");
					out.println("<td class='admin2' nowrap width='1%'>"+ScreenHelper.formatDate(rs.getDate("OC_NURSINGDEBET_DATE"))+"&nbsp;</td>");
					out.println("<td class='admin2' nowrap width='1%'><input type='checkbox' class='text' name='cb_"+uid+"' checked/></td>");
					out.println("<td class='admin2'>"+rs.getInt("OC_NURSINGDEBET_QUANTITY")+" x "+prestation.getDescription()+"</td>");
					out.println("<td class='admin2'>"+User.getFullUserName(rs.getString("OC_NURSINGDEBET_USERUID"))+"</td>");
					out.println("</tr>");
				}
				else if(checkString(request.getParameter("showall")).equalsIgnoreCase("1") || sKey.split("\\_").length>=3){
					out.println("<tr>");
					out.println("<td class='admin3'><img height='16px' src='"+sCONTEXTPATH+"/_img/icons/icon_money2.png'/></td>");
					out.println("<td class='admin3' nowrap width='1%'>"+ScreenHelper.formatDate(rs.getDate("OC_NURSINGDEBET_DATE"))+"&nbsp;</td>");
					out.println("<td class='admin3' nowrap width='1%'></td>");
					out.println("<td class='admin3'>"+rs.getInt("OC_NURSINGDEBET_QUANTITY")+" x "+prestation.getDescription()+"</td>");
					out.println("<td class='admin3'>"+User.getFullUserName(rs.getString("OC_NURSINGDEBET_USERUID"))+"</td>");
					out.println("</tr>");
				}
				else{
					bPaid=true;
				}
			}
		}
		rs.close();
		ps.close();
		conn.close();
	}
	else{
		out.println("<empty/>");
	}
%>
</table>
<%
	if(bPaid){
%>
	<a href='javascript:loadPrestations(true)'><%=getTran(request,"web","showinvoicedprestations",sWebLanguage) %></a>
<%
	}
	if(checkString(request.getParameter("showall")).equalsIgnoreCase("1")){
	%>
		<a href='javascript:loadPrestations()'><%=getTran(request,"web","hideinvoicedprestations",sWebLanguage) %></a>
	<%
	}
%>

