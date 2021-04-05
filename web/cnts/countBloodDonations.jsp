<%@page import="be.mxs.common.util.system.Pointer"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	if(SH.c(request.getParameter("setold")).length()>0){
		Pointer.deletePointers("oldblooddonations."+activePatient.personid);
		Pointer.storePointer("oldblooddonations."+activePatient.personid,request.getParameter("setold"));
	}
	int n = MedwanQuery.getInstance().getTransactionsByType(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_CNTS_BLOODGIFT").size();
	String sOld=Pointer.getPointer("oldblooddonations."+activePatient.personid,"0");
	try{
		n+=Integer.parseInt(sOld);
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>
{
	"total":"<%=n %>",
	"old":"<%=sOld %>"
}