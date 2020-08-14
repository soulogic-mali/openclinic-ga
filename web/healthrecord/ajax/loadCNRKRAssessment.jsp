<%@page import="be.mxs.common.model.vo.healthrecord.util.TransactionFactoryGeneral"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	SessionContainerWO sessionContainerWO = (SessionContainerWO) SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
	TransactionVO currentTran = sessionContainerWO.getCurrentTransactionVO();
	String referenceTransactionUid=checkString(request.getParameter("referenceTransactionUid"));
	if(referenceTransactionUid.length()>0){
    	TransactionVO showTransaction = MedwanQuery.getInstance().loadTransaction(Integer.parseInt(referenceTransactionUid.split("\\.")[0]),Integer.parseInt(referenceTransactionUid.split("\\.")[1]));
        TransactionFactoryGeneral factory = new TransactionFactoryGeneral();
        if(showTransaction!=null){
    	    TransactionVO tempTran = factory.createTransactionVO(sessionContainerWO.getUserVO(),showTransaction.getTransactionType());
    	    factory.populateTransaction(tempTran,showTransaction);

    	    // set showtran as current tran
    	    sessionContainerWO.setCurrentTransactionVO(tempTran);
        }
	}

	String assessmentType = checkString(request.getParameter("assessmenttype"));
	if(assessmentType.equalsIgnoreCase("1")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentReumatology.jsp"),pageContext);
	}
	else if(assessmentType.equalsIgnoreCase("2")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentReumatology2.jsp"),pageContext);
	}
	else if(assessmentType.equalsIgnoreCase("3")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentTraumatology.jsp"),pageContext);
	}
	else if(assessmentType.equalsIgnoreCase("4")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentRespiratory.jsp"),pageContext);
	}
	else if(assessmentType.equalsIgnoreCase("5")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentNeurologyChild.jsp"),pageContext);
	}
	else if(assessmentType.equalsIgnoreCase("6")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentNeurologyAdult.jsp"),pageContext);
	}
	else if(assessmentType.equalsIgnoreCase("7")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentPerineology.jsp"),pageContext);
	}
	else if(assessmentType.equalsIgnoreCase("99")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentOther.jsp"),pageContext);
	}
    sessionContainerWO.setCurrentTransactionVO(currentTran);
%>