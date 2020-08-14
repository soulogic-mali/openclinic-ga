<%@include file="/includes/validateUser.jsp"%>
<p>List of consultations in 2018</p>
<%
	List persons = AdminPerson.getAllPatients("", "", "", "", "", "", "", "");
	Iterator iPersons = persons.iterator();
	while(iPersons.hasNext()){
		AdminPerson person = (AdminPerson)iPersons.next();
		if(person.getAge()<10){
			out.println("<br/>"+person.getFullName()+" "+person.dateOfBirth);
		}
	}
%>