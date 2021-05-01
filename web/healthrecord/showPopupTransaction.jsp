<%@page import="be.mxs.common.model.vo.healthrecord.util.TransactionFactoryGeneral"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	int serverid=Integer.parseInt(request.getParameter("be.mxs.healthrecord.server_id"));
	int transactionid=Integer.parseInt(request.getParameter("be.mxs.healthrecord.transaction_id"));
    SessionContainerWO sessionContainerWO = (SessionContainerWO) SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
    TransactionVO showTransaction = MedwanQuery.getInstance().loadTransaction(serverid, transactionid); 
    TransactionFactoryGeneral factory = new TransactionFactoryGeneral();
	String transactiontype="";
	String customexamtype="";
    if(showTransaction!=null){
	    TransactionVO tempTran = factory.createTransactionVO(sessionContainerWO.getUserVO(),showTransaction.getTransactionType());
	    factory.populateTransaction(tempTran,showTransaction);
	    sessionContainerWO.setCurrentTransactionVO(tempTran);
		transactiontype=showTransaction.getTransactionType();
		if(transactiontype.indexOf("_CUSTOMEXAMINATION")>-1){
			customexamtype="&CustomExamType="+transactiontype.substring(transactiontype.indexOf("_CUSTOMEXAMINATION")+"_CUSTOMEXAMINATION".length());
			transactiontype = transactiontype.substring(0,transactiontype.indexOf("_CUSTOMEXAMINATION")+"_CUSTOMEXAMINATION".length());
		}
    }
%>
<script>
	window.location.href="<c:url value="/"/><%=MedwanQuery.getInstance().getForward(transactiontype).replaceAll("main.do","popup.jsp")+customexamtype%>&title=<%=SH.c(request.getParameter("title"))%>&be.mxs.healthrecord.transaction_id=<%=transactionid%>&be.mxs.healthrecord.server_id=<%=serverid%>&PopupHeight=600&readonly=true&nobuttons=1";
</script>