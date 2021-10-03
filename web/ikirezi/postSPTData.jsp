<%@page import="org.dom4j.*"%>
<%@page import="be.openclinic.system.*" %>
<%@include file="/includes/helper.jsp"%>

<%
	Connection conn = SH.getStatsConnection();
	Hashtable parameters = SH.getMultipartFormParameters(request);
	Enumeration<String> eParameters = parameters.keys();
	while(eParameters.hasMoreElements()){
		String parName=eParameters.nextElement();
		if(parName.equalsIgnoreCase("sptdata")){
			FormFile formFile = (FormFile)parameters.get(parName);
			org.dom4j.Document document = DocumentHelper.parseText(new String(formFile.getDocument()));
			Element root = document.getRootElement();
			int serverid = Integer.parseInt(root.attributeValue("server"));
			String version = root.attributeValue("version");
			//We do not accept sptdata from an unidentified server
			if(serverid>1){
				Iterator<Element> patients = root.elementIterator("patient");
				while(patients.hasNext()){
					try{
						Element patient = patients.next();
						long patientid = Long.parseLong(patient.attributeValue("id"));
						int patientage = Integer.parseInt(patient.attributeValue("ageinmonths"));
						String patientgender = patient.attributeValue("gender");
						try{
							Iterator<Element> statuses = patient.elementIterator("status");
							while(statuses.hasNext()){
								Element status = statuses.next();
								java.util.Date datetime = new SimpleDateFormat("yyyyMMddHHmmss").parse(status.attributeValue("datetime"));
								int userid = Integer.parseInt(status.attributeValue("user"));
								String treatment = status.attributeValue("treatment");
								String signs = status.getText();
								//Store the data only if it doesn't exist yet
								PreparedStatement ps = conn.prepareStatement("select * from SPT_SIGNS where SPT_SIGN_SERVERID=? AND SPT_SIGN_PATIENTUID=? AND SPT_SIGN_UPDATETIME=?");
								ps.setInt(1,serverid);
								ps.setLong(2,patientid);
								ps.setTimestamp(3, new java.sql.Timestamp(datetime.getTime()));
								ResultSet rs = ps.executeQuery();
								if(!rs.next()){
									rs.close();
									ps.close();
									ps = conn.prepareStatement("insert into SPT_SIGNS(SPT_SIGN_SERVERID,SPT_SIGN_PATIENTUID,SPT_SIGN_PATIENTAGE,SPT_SIGN_PATIENTGENDER,SPT_SIGN_SIGNS,SPT_SIGN_TREATMENT,SPT_SIGN_UPDATETIME,SPT_SIGN_UPDATEUID) values(?,?,?,?,?,?,?,?)");
									ps.setInt(1,serverid);
									ps.setLong(2,patientid);
									ps.setInt(3,patientage);
									ps.setString(4, patientgender);
									ps.setString(5,signs);
									ps.setString(6,treatment);
									ps.setTimestamp(7,SH.ts(datetime));
									ps.setInt(8,userid);
									ps.execute();
								}
								else{
									rs.close();
								}
								ps.close();
							}
						}
						catch(Exception i){
							i.printStackTrace();
						}
					}
					catch(Exception e){
						e.printStackTrace();
					}
				}
				out.println("<OK>");
			}
		}
	}
	conn.close();
%>