<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/helper.jsp"%>
<%
	String key = ScreenHelper.checkString(request.getParameter("key"));
	String natreg = ScreenHelper.checkString(request.getParameter("natreg"));
	String personid = ScreenHelper.checkString(request.getParameter("personid"));
	String orderuid = ScreenHelper.checkString(request.getParameter("orderuid"));
	String sError = "";
	if(key.length()==0 || MedwanQuery.getInstance().getConfigInt("restKey."+key,0)==0){
		sError="ERROR: InvalidKey";
	}
	if(natreg.length()==0 && personid.length()==0){
		sError="ERROR: InvalidPatientIdentification";
	}
	if(personid.length()>0){
		AdminPerson person = AdminPerson.getAdminPerson(personid);
		if(!person.isNotEmpty()){
			sError="ERROR: InvalidPersonId";
		}
	}
	if(orderuid.length()==0){
		sError="ERROR: MissingOrderUid";
	}
	if(natreg.length()>0){
		String pid = AdminPerson.getPersonIdByNatReg(natreg);
		if(pid==null || (personid.length()>0 && !pid.equalsIgnoreCase(personid))){
			sError="ERROR: InvalidNatReg";
		}
		else{
			personid=pid;
		}
	}
	if(sError.length()==0){
		User activeUser = User.get(MedwanQuery.getInstance().getConfigInt("restKey."+key,0));
		session.setAttribute("activeUser", activeUser);
	    MedwanQuery.setSession(session,activeUser);
		AdminPerson activePatient = AdminPerson.getAdminPerson(personid);
		session.setAttribute("activePatient",activePatient);
	%>
	<script>
		window.location.href='../popup.jsp?Page=pacs/studyList.jsp&orderuid=<%=orderuid%>';
	</script>
	<%
	}
	else{
		out.println("<h1>"+sError+"</h1>");
	}
	%>