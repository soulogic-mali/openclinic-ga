<%@page import="be.openclinic.assets.Asset,
               java.text.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	Asset asset = new Asset();
	if(SH.p(request,"purchasedate").length()>0){
		asset.setPurchaseDate(SH.parseDate(SH.p(request,"purchasedate")));
	}
	if(SH.p(request,"comment12").length()>0){
		asset.setComment12(SH.p(request,"comment12"));
	}
	if(SH.p(request,"purchaseprice").length()>0){
		asset.setPurchasePrice(Double.parseDouble(SH.p(request,"purchaseprice")));
	}
	if(SH.p(request,"writeoffmethod").length()>0){
			asset.setWriteOffMethod(SH.p(request,"writeoffmethod"));
	}
	if(SH.p(request,"writeoffperiod").length()>0){
		asset.setWriteOffPeriod(Integer.parseInt(SH.p(request,"writeoffperiod")));
	}
	if(SH.p(request,"annuity").length()>0){
		asset.setAnnuity(SH.p(request,"annuity"));
	}
	double rv=asset.getRemainingValue(); 
	String value="";
	if(rv>-1){
		value=SH.getPriceFormat(rv);
	}
%>
{
	"remainingvalue":"<%=value %>"
}
