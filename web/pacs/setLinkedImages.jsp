<%@page import="be.mxs.common.model.vo.healthrecord.ItemContextVO"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String[] link = SH.c(request.getParameter("link")).split(";");
	String[] unlink = SH.c(request.getParameter("unlink")).split(";");
	String orderuid = SH.c(request.getParameter("orderuid"));
	for(int n=0;n<link.length;n++){
		TransactionVO tran = MedwanQuery.getInstance().loadTransaction(link[n]);
		if(tran!=null){
			if(tran.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_ORDERUID")!=null){
				tran.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_ORDERUID").setValue(orderuid);
			}
			else{
				ItemContextVO itemContextVO = new ItemContextVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", "");
    			tran.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
    					"be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_ORDERUID",orderuid,new java.util.Date(),itemContextVO));
			}
			MedwanQuery.getInstance().updateTransaction(Integer.parseInt(activePatient.personid), tran);
		}
	}
	for(int n=0;n<unlink.length;n++){
		TransactionVO tran = MedwanQuery.getInstance().loadTransaction(unlink[n]);
		if(tran!=null){
			if(tran.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_ORDERUID")!=null){
				tran.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_ORDERUID").setValue("");
			}
			MedwanQuery.getInstance().updateTransaction(Integer.parseInt(activePatient.personid), tran);
		}
	}
	
%>