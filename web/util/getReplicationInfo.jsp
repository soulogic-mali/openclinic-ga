<%@page import="java.lang.management.ManagementFactory"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String Slave_IO_Running="", Slave_SQL_Running="", Slave_SQL_Running_State="", Seconds_Behind_Master="";
	java.util.Date dLastTransaction=null, dLastDebet=null, dLastImage=null, dLastLab=null;

	try{
		Class.forName(SH.cs("replicationDatabaseDriver","com.mysql.jdbc.Driver"));			
		Connection conn =  DriverManager.getConnection("jdbc:mysql://"+SH.cs("replicationServer","")+":"
																	  +SH.cs("replicationPort","3306")+"/openclinic_dbo?user="
																	  +SH.cs("replicationUser","root")+"&password="
																	  +SH.cs("replicationPassword","")
																	  +SH.cs("replicationConnectionParameters",""));
		PreparedStatement ps = conn.prepareStatement("show slave status");
		ResultSet rs = ps.executeQuery();
		if(rs.next()){
			Slave_IO_Running=rs.getString("Slave_IO_Running")+"<br/>"+rs.getString("Last_IO_Error");
			Slave_SQL_Running=rs.getString("Slave_SQL_Running");
			Slave_SQL_Running_State=rs.getString("Slave_SQL_Running_State");
			Seconds_Behind_Master=SH.c(rs.getString("Seconds_Behind_Master"));
		}
		rs.close();
		ps.close();
		
		if(!Slave_SQL_Running.equalsIgnoreCase("yes")){
			try{
				ps = conn.prepareStatement("select LAST_ERROR_MESSAGE from performance_schema.replication_applier_status_by_worker where LAST_ERROR_NUMBER>0");
				rs=ps.executeQuery();
				while(rs.next()){
					Slave_SQL_Running+="<br/>"+rs.getString("LAST_ERROR_MESSAGE")+"<<br/><input type='button' class='button' name='skipButton' value='Skip error' onclick='skipError()'/>";
				}
				rs.close();
				ps.close();
			}
			catch(Exception e){};
		}
		
		
		ps=conn.prepareStatement("select max(ts) last from transactions");
		rs=ps.executeQuery();
		if(rs.next()){
			dLastTransaction=rs.getTimestamp("last");
		}
		rs.close();
		ps.close();
		
		ps=conn.prepareStatement("select max(oc_debet_updatetime) last from oc_debets");
		rs=ps.executeQuery();
		if(rs.next()){
			dLastDebet=rs.getTimestamp("last");
		}
		rs.close();
		ps.close();
		
		ps=conn.prepareStatement("select max(oc_pacs_updatetime) last from oc_pacs");
		rs=ps.executeQuery();
		if(rs.next()){
			dLastImage=rs.getTimestamp("last");
		}
		rs.close();
		ps.close();
		
		ps=conn.prepareStatement("select max(updatetime) last from requestedlabanalyses");
		rs=ps.executeQuery();
		if(rs.next()){
			dLastLab=rs.getTimestamp("last");
		}
		rs.close();
		ps.close();
		
		conn.close();
	}
	catch(Exception e){}
%>
{
	"Slave_IO_Running":"<%=Slave_IO_Running %>",
	"Slave_SQL_Running":"<%=Slave_SQL_Running %>",
	"Slave_SQL_Running_State":"<%=Slave_SQL_Running_State %>",
	"Seconds_Behind_Master":"<%=Seconds_Behind_Master %>",
	"Last_Transaction":"<%=SH.formatSQLDate(dLastTransaction, "dd/MM/yyyy HH:mm:ss") %>",
	"Last_Debet":"<%=SH.formatSQLDate(dLastDebet, "dd/MM/yyyy HH:mm:ss") %>",
	"Last_Image":"<%=SH.formatSQLDate(dLastImage, "dd/MM/yyyy HH:mm:ss") %>",
	"Last_Update":"<%=SH.formatSQLDate(new java.util.Date(), "dd/MM/yyyy HH:mm:ss") %>",
	"activesessions":"<%=MedwanQuery.getSessions().size() %>",
	"systemload":"<%=ManagementFactory.getOperatingSystemMXBean().getSystemLoadAverage() %> %",
	"Last_Lab":"<%=SH.formatSQLDate(dLastLab, "dd/MM/yyyy HH:mm:ss") %>"
}