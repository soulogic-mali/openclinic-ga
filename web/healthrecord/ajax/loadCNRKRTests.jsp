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
	
	Set tests = new TreeSet();
	tests.add(checkString(request.getParameter("test1")));
	tests.add(checkString(request.getParameter("test2")));
	tests.add(checkString(request.getParameter("test3")));
	tests.add(checkString(request.getParameter("test4")));
	if(tests.contains("1.1")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineTestPASS.jsp"),pageContext);
	}
	if(tests.contains("1.2")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineTestACTIVLIM.jsp"),pageContext);
	}
	if(tests.contains("1.3")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineTestMMSE.jsp"),pageContext);
	}
	if(tests.contains("1.4")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineTestBBS.jsp"),pageContext);
	}
	if(tests.contains("2.1")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineTestABILHAND.jsp"),pageContext);
	}
	if(tests.contains("2.2")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineTestABILOCO.jsp"),pageContext);
	}
	if(tests.contains("3.1")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineTestStartBack.jsp"),pageContext);
	}
	if(tests.contains("3.2")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineTestEIFEL.jsp"),pageContext);
	}
	if(tests.contains("3.3")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineTestOSWESTRY.jsp"),pageContext);
	}
	if(tests.contains("3.4")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineTestTampaEKT.jsp"),pageContext);
	}
	if(tests.contains("4.1")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineTestKOOS.jsp"),pageContext);
	}
	if(tests.contains("4.2")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineTestHOOS.jsp"),pageContext);
	}
	if(tests.contains("5.1")){
		ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineTestSF36.jsp"),pageContext);
	}
    sessionContainerWO.setCurrentTransactionVO(currentTran);
%>
