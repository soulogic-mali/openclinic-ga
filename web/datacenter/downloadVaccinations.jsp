<%@include file="/includes/validateUser.jsp"%>
<%
	Connection conn = MedwanQuery.getInstance().getStatsConnection();
	StringBuffer sResult = new StringBuffer();
	String serverid=checkString(request.getParameter("serverid"));
	String period=checkString(request.getParameter("period"));
	java.util.Date begin=null,end=null;
	if(period.split("\\.").length<2){
		begin=new SimpleDateFormat("dd/MM/yyyy").parse("01/01/"+period);
		end=new SimpleDateFormat("dd/MM/yyyy").parse("01/01/"+(Integer.parseInt(period)+1));
	}
	else{
		begin=new SimpleDateFormat("dd/MM/yyyy").parse("01/"+period.split("\\.")[1]+"/"+period.split("\\.")[0]);
		if(Integer.parseInt(period.split("\\.")[1])<12){
			end=new SimpleDateFormat("dd/MM/yyyy").parse("01/"+(Integer.parseInt(period.split("\\.")[1])+1)+"/"+period.split("\\.")[0]);
		}
		else{
			end=new SimpleDateFormat("dd/MM/yyyy").parse("01/01/"+(Integer.parseInt(period.split("\\.")[0])+1));
		}
	}
	
	// search all the invoices from this period     
	String query = 	"select DC_VACCINATION_SERVERUID SERVERUID,DC_VACCINATION_PATIENTUID PATIENTUID,DC_VACCINATION_BIRTH PATIENTDATEOFBIRTH,DC_VACCINATION_DATE DATE,DC_VACCINATION_TYPE TYPE from "+
					" DC_VACCINATIONS where DC_VACCINATION_DATE >= ? and DC_VACCINATION_DATE<? and DC_VACCINATION_SERVERUID=? order by DC_VACCINATION_DATE,DC_VACCINATION_TYPE";
	PreparedStatement ps = conn.prepareStatement(query);
	ps.setDate(1, new java.sql.Date(begin.getTime()));
	ps.setDate(2, new java.sql.Date(end.getTime()));
	ps.setInt(3,Integer.parseInt(serverid));
	ResultSet rs = ps.executeQuery();
	
	response.setContentType("application/octet-stream; charset=windows-1252");
	response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date())+".csv\"");
	
	ServletOutputStream os = response.getOutputStream();
	
	// header
	sResult.append("SERVERUID;PATIENTUID;PATIENTDATEOFBIRTH;DATE;TYPE\r\n");
	while(rs.next()){
		java.util.Date birth=rs.getDate("PATIENTDATEOFBIRTH");
		sResult.append(rs.getString("SERVERUID")+";"+rs.getString("PATIENTUID")+";"+(birth==null?"": new SimpleDateFormat("dd/MM/yyyy").format(birth))+";"+new SimpleDateFormat("dd/MM/yyyy").format(rs.getDate("DATE"))+";"+rs.getString("TYPE")+"\r\n");
	}
	
	byte[] b = sResult.toString().getBytes();
	for(int n=0; n<b.length; n++){
	    os.write(b[n]);
	}
	os.flush();

%>