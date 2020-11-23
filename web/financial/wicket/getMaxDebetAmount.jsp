<%@page import="be.openclinic.finance.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sEditWicketOperationWicket=SH.c(request.getParameter("EditWicketOperationWicket"));
	String sEditWicketOperationUID=SH.c(request.getParameter("EditWicketOperationUID"));
	
	double dAvailable =0;
	if(sEditWicketOperationWicket.length()>0){
		Wicket wicket = Wicket.get(sEditWicketOperationWicket);
		if(wicket!=null){
			dAvailable = wicket.calculateBalance(new java.util.Date());
		}
	}
	if(sEditWicketOperationUID.length()>0){
		WicketDebet operation = WicketDebet.get(sEditWicketOperationUID);
		if(operation!=null){
			dAvailable+=operation.getAmount();
		}
	}
	if(dAvailable<0){
		dAvailable=0;
	}
%>
{
	"maxAmount" : "<%=SH.getPriceFormat(dAvailable) %>"
}