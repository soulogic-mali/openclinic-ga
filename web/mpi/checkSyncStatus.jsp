<%@include file="/includes/validateUser.jsp"%>
<%
	String syncedids="";
	String[] syncids = c(request.getParameter("syncids")).split(";");
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	try{
		for(int n=0;n<syncids.length;n++){
			PreparedStatement ps = conn.prepareStatement("select * from oc_mpidocuments where oc_mpidocument_id=? and oc_mpidocument_sentdatetime is null");
			ps.setString(1,syncids[n].split("\\*")[1]);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				//Do nothing
			}
			else{
				syncedids+=syncids[n]+";";
			}
			rs.close();
			ps.close();
		}
	}
	catch(Exception e){
		e.printStackTrace();
	}
	finally{
		conn.close();
	}
	System.out.println("Return {'syncedids': '"+syncedids+"'}");
%>
{
	"syncedids": "<%=syncedids%>"
}