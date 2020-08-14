<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String sName = checkString(request.getParameter("name"));
	String sDocumentName = "";
	String sDocumentId = "";
	String sDocumentVisible = "";
	
	if(sName.length()>0){
		Connection conn = MedwanQuery.getInstance().getAdminConnection();
		PreparedStatement ps = conn.prepareStatement("select * from WordDocuments where name = ?");
		ps.setString(1,new String(Base64.getDecoder().decode(sName)));
		ResultSet rs = ps.executeQuery();
		if(rs.next()){
			sDocumentName = rs.getString("name");
			sDocumentId = checkString(rs.getString("id"));
			sDocumentVisible = rs.getInt("visible")+"";
		}
		rs.close();
		ps.close();
	}
%>

{
	"documentname":"<%=Base64.getEncoder().encodeToString(sDocumentName.getBytes()) %>",
	"documentid":"<%=sDocumentId %>",
	"documentvisible":"<%=sDocumentVisible %>"
}
