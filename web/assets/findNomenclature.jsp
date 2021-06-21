<%@page import="be.mxs.common.util.system.HTMLEntities"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<ul id="autocompletion">
<%
	String sText = SH.p(request,"text");
	String sCode = SH.p(request,"code");
	int iMaxRows = MedwanQuery.getInstance().getConfigInt("MaxSearchFieldsRows",30);
	int nRows=0;
	if(sText.length()>0){
		Connection conn = SH.getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("SELECT * FROM oc_labels WHERE oc_label_type='admin.nomenclature.asset' and oc_label_language=? and oc_label_value like ? and oc_label_id like ? order by oc_label_id");
		ps.setString(1,sWebLanguage);
		ps.setString(2, "%"+sText+"%");
		ps.setString(3, sCode+"%");
		ResultSet rs=ps.executeQuery();
		while(rs.next() && nRows++<iMaxRows){
            out.write("<li>");
        	out.write("<table><tr><td width='60px' nowrap>"+HTMLEntities.htmlentities(rs.getString("oc_label_id")+"</td><td>"+rs.getString("oc_label_value"))+"</td></tr></table>");
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
