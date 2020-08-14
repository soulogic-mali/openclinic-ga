<%@page import="be.mxs.common.util.system.HTMLEntities,
                be.openclinic.util.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%
	String uid = checkString(request.getParameter("uid"));
	String sName="";
	String sNomenclature="";
	String sFrequency="";
	String sOperator="";
	String sPlanmanager="";
	String sInstructions="";
	String sType="";
	String sComment1="";
	String sComment2="";
	String sComment3="";
	String sComment4="";
	String sComment5="";
	String sComment6="";
	String sComment7="";
	String sComment8="";
	String sComment9="";
	String sComment10="";
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from oc_defaultmaintenanceplans where oc_maintenanceplan_uid=?");
	ps.setString(1,uid);
	ResultSet rs = ps.executeQuery();
	if(rs.next()){
		sName=checkString(rs.getString("oc_maintenanceplan_name"));
		sNomenclature=checkString(rs.getString("oc_maintenanceplan_nomenclature"));
		sFrequency=checkString(rs.getString("oc_maintenanceplan_frequency"));
		sOperator=checkString(rs.getString("oc_maintenanceplan_operator"));
		sPlanmanager=checkString(rs.getString("oc_maintenanceplan_planmanager"));
		sType=checkString(rs.getString("oc_maintenanceplan_type"));
		sInstructions=checkString(rs.getString("oc_maintenanceplan_instructions"));
		sComment1=checkString(rs.getString("oc_maintenanceplan_comment1"));
		sComment2=checkString(rs.getString("oc_maintenanceplan_comment2"));
		sComment3=checkString(rs.getString("oc_maintenanceplan_comment3"));
		sComment4=checkString(rs.getString("oc_maintenanceplan_comment4"));
		sComment5=checkString(rs.getString("oc_maintenanceplan_comment5"));
		sComment6=checkString(rs.getString("oc_maintenanceplan_comment6"));
		sComment7=checkString(rs.getString("oc_maintenanceplan_comment7"));
		sComment8=checkString(rs.getString("oc_maintenanceplan_comment8"));
		sComment9=checkString(rs.getString("oc_maintenanceplan_comment9"));
		sComment10=checkString(rs.getString("oc_maintenanceplan_comment10"));
	}
    rs.close();
    ps.close();
    conn.close();
%>

{
  "name":"<%=sName%>",
  "frequency":"<%=sFrequency%>",
  "nomenclature":"<%=sNomenclature%>",
  "operator":"<%=sOperator%>",
  "planmanager":"<%=sPlanmanager%>",
  "instructions":"<%=sInstructions.replaceAll("\n","<br>")%>",
  "type":"<%=sType%>",
  "comment1":"<%=sComment1%>",
  "comment2":"<%=sComment2%>",
  "comment3":"<%=sComment3%>",
  "comment4":"<%=sComment4%>",
  "comment5":"<%=sComment5%>",
  "comment6":"<%=sComment6%>",
  "comment7":"<%=sComment7%>",
  "comment8":"<%=sComment8%>",
  "comment9":"<%=sComment9%>",
  "comment10":"<%=sComment10%>"
}