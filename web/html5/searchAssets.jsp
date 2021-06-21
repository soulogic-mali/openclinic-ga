<%@ page errorPage="/includes/error.jsp" %>
<%@ include file="/includes/validateUser.jsp" %>
<table width='100%'>
<%
	String type = SH.p(request,"type");
	String code = SH.p(request,"code");
	String description = SH.p(request,"description");
	String descriptiontext = SH.p(request,"descriptiontext");
	String nomenclature = SH.p(request,"nomenclature");
	String highlight = SH.p(request,"highlight");
	String children = Service.getChildIdsAsString(SH.c((String)session.getAttribute("activeService")),500); 
	Connection conn = SH.getOpenclinicConnection();	
	PreparedStatement ps = conn.prepareStatement("select * from oc_assets where oc_asset_service in ("+children+") and oc_asset_nomenclature like ? and oc_asset_nomenclature like ? and oc_asset_code like ? and oc_asset_description like ? and oc_asset_description like ? order by oc_asset_nomenclature,oc_asset_description");
	ps.setString(1,type+"%");
	ps.setString(2,nomenclature.length()==0?"%":nomenclature);
	ps.setString(3,"%"+code+"%");
	ps.setString(4,description+"%");
	ps.setString(5,"%"+descriptiontext+"%");
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		out.println("<tr>");
		out.println("<td class='mobileadmin' "+(highlight.equalsIgnoreCase(rs.getInt("oc_asset_serverid")+"."+rs.getInt("oc_asset_objectid"))?"style='font-size:4vw;background-color: lightyellow'":"style='font-size:4vw;'")+">"+rs.getString("oc_asset_nomenclature").toUpperCase()+"</td>");
		out.println("<td class='mobileadmin2' rowspan='2' "+(highlight.equalsIgnoreCase(rs.getInt("oc_asset_serverid")+"."+rs.getInt("oc_asset_objectid"))?"style='background-color: lightyellow'":"")+"><a href='javascript:editAsset(\""+rs.getString("oc_asset_serverid")+"."+rs.getString("oc_asset_objectid")+"\");' style='font-size:5vw;font-weight: bold'>"+SH.capitalize(rs.getString("oc_asset_description"))+"</a></td>");
		out.println("</tr>");
		out.println("<tr>");
		out.println("<td class='mobileadmin' "+(highlight.equalsIgnoreCase(rs.getInt("oc_asset_serverid")+"."+rs.getInt("oc_asset_objectid"))?"style='font-size:4vw;background-color: lightyellow'":"style='font-size:4vw;'")+">"+rs.getString("oc_asset_code").toUpperCase()+"</td>");
		out.println("</tr>");
	}
	rs.close();
	ps.close();
	conn.close();
%>
</table>