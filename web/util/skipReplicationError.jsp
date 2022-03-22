<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String Slave_IO_Running="", Slave_SQL_Running="", Slave_SQL_Running_State="", Seconds_Behind_Master="";
	java.util.Date dLastTransaction=null, dLastDebet=null, dLastImage=null, dLastLab=null;

	Class.forName(SH.cs("replicationDatabaseDriver","com.mysql.jdbc.Driver"));			
	Connection conn =  DriverManager.getConnection("jdbc:mysql://"+SH.cs("replicationServer","")+":"
																  +SH.cs("replicationPort","3306")+"/openclinic_dbo?user="
																  +SH.cs("replicationUser","root")+"&password="
																  +SH.cs("replicationPassword","")
																  +SH.cs("replicationConnectionParameters",""));
	PreparedStatement ps = conn.prepareStatement("stop slave;");
	ps.execute();
	ps.close();
	ps = conn.prepareStatement("SET GLOBAL SQL_SLAVE_SKIP_COUNTER = 1;");
	ps.execute();
	ps.close();
	ps = conn.prepareStatement("start slave;");
	ps.execute();
	ps.close();
	
	conn.close();
%>
