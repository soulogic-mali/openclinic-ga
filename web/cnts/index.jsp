<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	//First check if patient is eligible as a donor
	boolean bRejected = false;
	Vector bloodgifts = MedwanQuery.getInstance().getTransactionsByType(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_CNTS_BLOODGIFT");
	for(int n=0;n<bloodgifts.size();n++){
		TransactionVO bloodgift = (TransactionVO)bloodgifts.elementAt(n);
		bRejected=bloodgift.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSBLOODGIFT_PERMANENTREJECTION").equalsIgnoreCase("medwan.common.true");
		if(bRejected){
			break;
		}
	}
	if(bRejected){
		out.println("<font style='font-size: 14px;color: red'>"+ScreenHelper.getTran(request,"cnts","patientpermanentlyrejected",sWebLanguage)+"</font>");
	}
	else {
		out.println("<font style='font-size: 14px'>"+ScreenHelper.getTran(request,"cnts","notrejected",sWebLanguage)+"</font>");
	}
%>
