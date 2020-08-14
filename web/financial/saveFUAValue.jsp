<%@include file="/includes/validateUser.jsp"%>
<%
	String encounteruid = checkString(request.getParameter("encounteruid"));
	String type = checkString(request.getParameter("type"));
	String value = checkString(request.getParameter("value"));
	if(encounteruid.length()>0){
		Encounter encounter = Encounter.get(encounteruid);
		if(type.equals("VALUE_36")){
			encounter.setCareModality(value);
			encounter.store();
		}
		else if(type.equals("VALUE_42")){
			encounter.setCareType(value);
			encounter.store();
		}
	}
%>
<script>
	window.opener.location.reload();
	window.close();
</script>