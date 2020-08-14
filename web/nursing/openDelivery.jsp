<%@page import="be.dpms.medwan.common.model.vo.administration.PersonVO"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String patientid=request.getParameter("patientuid");
	String transactionid = request.getParameter("transactionid");
	String serverid = request.getParameter("serverid");
    PersonVO person = MedwanQuery.getInstance().getPerson(patientid + "");
    SessionContainerWO sessionContainerWO = (SessionContainerWO) SessionContainerFactory.getInstance().getSessionContainerWO(request, SessionContainerWO.class.getName());
    sessionContainerWO.setPersonVO(person);
    sessionContainerWO.setHealthRecordVO(MedwanQuery.getInstance().loadHealthRecord(person, null, sessionContainerWO));
    sessionContainerWO.setUserVO(MedwanQuery.getInstance().getUser(activeUser.userid));

    activePatient = new AdminPerson();
    activePatient.initialize( patientid + "");
    session.setAttribute("activePatient", activePatient);
%>
<script>
	window.location.href='<%=sCONTEXTPATH%>/healthrecord/editTransaction.do?be.mxs.healthrecord.createTransaction.transactionType=be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_DELIVERY_MSPLS&be.mxs.healthrecord.transaction_id=<%=transactionid%>&be.mxs.healthrecord.server_id=<%=serverid%>';
</script>