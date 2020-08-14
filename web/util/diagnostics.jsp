<%@page import="be.mxs.common.util.system.HTMLEntities"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	//Transactions
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select count(*),serverid,transactionid from transactions group by serverid,transactionid having count(*)>1;");
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		int serverid = rs.getInt("serverid");
		int transactionid = rs.getInt("transactionid");
		PreparedStatement ps2 = conn.prepareStatement("select distinct healthrecordid from transactions where serverid=? and transactionid=?");
		ps2.setInt(1,serverid);
		ps2.setInt(2,transactionid);
		ResultSet rs2 = ps2.executeQuery();
		rs2.next();
		while(rs2.next()){
			int tranid = MedwanQuery.getInstance().getOpenclinicCounter("TransactionID");
			System.out.println("Transferring transaction "+transactionid+" to "+tranid);
			PreparedStatement ps3 = conn.prepareStatement("update transactions set transactionid=? where serverid=? and transactionid=? and healthrecordid=?");
			ps3.setInt(1,tranid);
			ps3.setInt(2,serverid);
			ps3.setInt(3,transactionid);
			ps3.setInt(4,rs2.getInt("healthrecordid"));
			ps3.execute();
			ps3.close();
			ps3 = conn.prepareStatement("insert into items(serverid,itemid,type,value,date,transactionid,version,versionserverid,priority,valuehash) select serverid,itemid,type,value,date,?,version,versionserverid,priority,valuehash from items where serverid=? and transactionid=?");
			ps3.setInt(1,tranid);
			ps3.setInt(2,serverid);
			ps3.setInt(3,transactionid);
			ps3.execute();
			ps3.close();
		}
		rs2.close();
		ps2.close();
	}
	rs.close();
	ps.close();

	//Encounters
	ps = conn.prepareStatement("select count(*),oc_encounter_objectid from oc_encounters group by oc_encounter_objectid having count(*)>1");
	rs = ps.executeQuery();
	while(rs.next()){
		int objectid = rs.getInt("oc_encounter_objectid");
		PreparedStatement ps2 = conn.prepareStatement("select distinct oc_encounter_patientuid from oc_encounters where oc_encounter_objectid=?");
		ps2.setInt(1,objectid);
		ResultSet rs2 = ps2.executeQuery();
		rs2.next();
		while(rs2.next()){
			int newobjectid = MedwanQuery.getInstance().getOpenclinicCounter("OC_ENCOUNTERS");
			System.out.println("Transferring encounter "+objectid+" to "+newobjectid);
			PreparedStatement ps3 = conn.prepareStatement("update oc_encounters set oc_encounter_objectid=? where oc_encounter_objectid=? and oc_encounter_patientuid=?");
			ps3.setInt(1,newobjectid);
			ps3.setInt(2,objectid);
			ps3.setInt(3,rs2.getInt("oc_encounter_patientuid"));
			ps3.execute();
			ps3.close();
		}
		rs2.close();
		ps2.close();
	}
	rs.close();
	ps.close();

	conn.close();
%>