<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<ul id="autocompletion">
<%
    String sFindCode = checkString(request.getParameter("findcode")).toUpperCase();
	String sLabelType = checkString(request.getParameter("labeltype")).toUpperCase();
	if(sFindCode.length()>0){
		int counter=0;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("select * from oc_labels where oc_label_type=? and oc_label_language=? and (oc_label_value like ? or oc_label_id like ?)");
		ps.setString(1,sLabelType);
		ps.setString(2,sWebLanguage);
		ps.setString(3,"%"+sFindCode+"%");
		ps.setString(4,"%"+sFindCode+"%");
		ResultSet rs = ps.executeQuery();
     	int iMaxRows = MedwanQuery.getInstance().getConfigInt("MaxSearchFieldsRows",30);
		while(rs.next() && iMaxRows>counter){
			counter++;
			String lbl = rs.getString("oc_label_value");
			String lblid=rs.getString("oc_label_id");
            out.write("<li>"+lbl+"<span style='display:none'>"+lblid+"-idcache</span></li>");
			
		}
	    if(iMaxRows<=counter){
	        out.write("<ul id='autocompletion'><li>...</li></ul>");
	    }
		rs.close();
		ps.close();
		conn.close();
	}
%>
</ul>
