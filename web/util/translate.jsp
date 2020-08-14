<%@page import="be.mxs.common.util.system.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String from="fr";
	String to=request.getParameter("to");
	boolean done=false,recycle=false;
	int n=0;
	while(!done){
		Connection conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("select * from oc_labels a where oc_label_language=? and not exists (select * from oc_labels where oc_label_type=a.oc_label_type and oc_label_id=a.oc_label_id and oc_label_language=?)");
		ps.setString(1, from);
		ps.setString(2, to);
		ResultSet rs = ps.executeQuery();
		n=0;
		while(rs.next() && n<50){
			n++;
			String type = rs.getString("oc_label_type");
			String id = rs.getString("oc_label_id");
			if(!Label.labelExists(type, id, to)){
				Translate.translateLabel(type, id, from, to);
			}
		}
		rs.close();
		ps.close();
		conn.close();
		if(n<50){
			done=true;
		}
	}
%>