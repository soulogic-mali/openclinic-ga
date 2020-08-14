<%@page import="java.util.*,be.openclinic.pharmacy.*,
                be.mxs.common.util.system.HTMLEntities"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<ul id="autocompletion">
    <%
		int iMaxRows = MedwanQuery.getInstance().getConfigInt("MaxSearchFieldsRows",30);
        String sName      = checkString(request.getParameter("findName"));
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("select * from ghb_servers where ghb_server_name like ? or ghb_server_domain like ? order by ghb_server_domain,ghb_server_name");
		ps.setString(1,"%"+sName+"%");
		ps.setString(2,"%"+sName+"%");
		ResultSet rs = ps.executeQuery();
		int counter=0;
		while(rs.next() && counter<iMaxRows){
			counter++;
			String id=rs.getString("ghb_server_id");
			if(!id.equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("ghb_ref_serverid","-"))){
	           	out.write("<li><b>"+HTMLEntities.htmlentities("["+rs.getString("ghb_server_domain")+"] "+HTMLEntities.unhtmlentities(checkString(rs.getString("ghb_server_name"))))+"</b>");
	            out.write("<span style='display:none'>"+id+"-idcache</span></li>");
			}
        }
    %>
</ul>
<%
    if(counter>=iMaxRows){
        out.write("<ul id='autocompletion'><li>...</li></ul>");
    }
%>
