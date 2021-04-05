<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String giftid = SH.c(request.getParameter("giftid"));
	//Find patientid and transaction that match this blood gift
	TransactionVO transaction = MedwanQuery.getInstance().loadTransaction(MedwanQuery.getInstance().getServerId(), Integer.parseInt(giftid.split("\\.")[0]));
	if(transaction!=null){
		int personid = MedwanQuery.getInstance().getPersonIdFromHealthrecordId(transaction.getHealthrecordId());
		activePatient = AdminPerson.get(personid+"");
		session.setAttribute("activePatient", activePatient);
		be.mxs.webapp.wo.common.system.SessionContainerWO sessionContainerWO = SessionContainerFactory.getInstance().getSessionContainerWO(request);
		sessionContainerWO.setCurrentTransactionVO(transaction);
		%>
		<script>
			window.location='<%=sCONTEXTPATH%>/healthrecord/editTransaction.do?be.mxs.healthrecord.createTransaction.transactionType=<%=transaction.getTransactionType()%>&PersonID=<%=personid%>&be.mxs.healthrecord.server_id=<%=transaction.getServerId()%>&be.mxs.healthrecord.transaction_id=<%=transaction.getTransactionId()%>';
		</script>
		<%
	}
	else{
		%>
		<script>
			alert('<%=getTranNoLink("web","invalidbarcode",sWebLanguage)%>');
			history.go(-1);
		</script>
		<%
	}
%>