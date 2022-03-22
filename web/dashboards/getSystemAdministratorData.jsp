<%@page import="be.openclinic.system.SystemInfo"%>
<%@include file="/includes/helper.jsp"%>
<%
	String Seconds_Behind_Master="";
	if(SH.cs("replicationServer","").length()>0){	
		Connection conn = null;
		PreparedStatement ps=null;
		ResultSet rs=null;
		try{
			Class.forName(SH.cs("replicationDatabaseDriver","com.mysql.jdbc.Driver"));			
			conn =  DriverManager.getConnection("jdbc:mysql://"+SH.cs("replicationServer","")+":"
																		  +SH.cs("replicationPort","3306")+"/openclinic_dbo?user="
																		  +SH.cs("replicationUser","root")+"&password="
																		  +SH.cs("replicationPassword","")
																		  +SH.cs("replicationConnectionParameters",""));
			ps = conn.prepareStatement("show slave status");
			rs = ps.executeQuery();
			if(rs.next()){
				Seconds_Behind_Master=SH.c(rs.getString("Seconds_Behind_Master"));
			}
		}
		catch(Exception e){
		}
		if(conn!=null){
			SH.close(conn, ps, rs);
		}
	}
%>
{
	"memoryload": "<%=SystemInfo.getUsedMemory()/(1024*1024)%>",
	"usersload": "<%=SystemInfo.getActiveUserCount()%>",
	"cpuload": "<%=SystemInfo.getSystemLoadAverage()%>",
	"replicationload": "<%=Seconds_Behind_Master%>",
	"end"		: ""
}