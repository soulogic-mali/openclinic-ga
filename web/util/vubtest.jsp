<%@include file="/includes/validateUser.jsp"%>
<p>List of consultations in 2018</p>
<%
	//Find list of consultations in 2018
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement p = conn.prepareStatement("select * from oc_encounters,adminview where oc_encounter_patientuid=personid and oc_encounter_type='visit' order by oc_encounter_begindate");
	ResultSet r = p.executeQuery();
	while(r.next()){
		java.util.Date encounterDate = r.getDate("oc_encounter_begindate");
		if(new SimpleDateFormat("yyyy").format(encounterDate).equals("2018")){
			//This record shoud be shown
			String patientUid = r.getString("oc_encounter_patientuid");
			String patientName=r.getString("firstname")+" "+r.getString("lastname");
			String origin = r.getString("oc_encounter_origin");
			out.println("<br/>"+patientName+" consulted on "+new SimpleDateFormat("dd/MM/yyyy").format(encounterDate)+" coming from "+origin);
		}
	}
	r.close();
	p.close();
	conn.close();
%>