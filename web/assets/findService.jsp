<%@page import="be.mxs.common.util.system.HTMLEntities"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<ul id="autocompletion">
<%
	System.out.println("UUUUUUUUUUUUUUUUUUUUUUUUUUUU");
	String sText = SH.p(request,"text");
	int iMaxRows = MedwanQuery.getInstance().getConfigInt("MaxSearchFieldsRows",30);
	int nRows=0;
	if(sText.length()>0){
		Connection conn = SH.getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("SELECT * FROM servicesview s,oc_labels l where s.serviceid=l.oc_label_id and l.oc_label_type='service' and l.oc_label_language=? and l.oc_label_value like ? and users like ? order by oc_label_id");
		ps.setString(1,sWebLanguage);
		ps.setString(2, "%"+sText+"%");
		ps.setString(3, activeUser.isAdmin()?"%":"%"+activeUser.userid+"$%");
		ResultSet rs=ps.executeQuery();
		while(rs.next() && nRows++<iMaxRows){
            out.write("<li>");
        	out.write("<table><tr><td width='150px' nowrap>"+HTMLEntities.htmlentities(rs.getString("oc_label_id").toUpperCase()+"</td><td>"+rs.getString("oc_label_value"))+"</td></tr></table>");
            out.write("<span style='display:none'>"+rs.getString("oc_label_id")+"-idcache</span>");
            out.write("<span style='display:none'>$"+rs.getString("oc_label_value")+"$</span>");
            out.write("</li>");
		}
		rs.close();
		ps.close();
		conn.close();
	}
%>
</ul>
<%
    boolean hasMoreResults = nRows>0 && (nRows >= iMaxRows);
    if(hasMoreResults){
        out.write("<ul id='autocompletion'><li>...</li></ul>");
    }
%>
