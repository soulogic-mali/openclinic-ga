<%@page import="be.mxs.common.util.system.HTMLEntities,
                be.openclinic.assets.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String uid = SH.p(request,"uid");
	Asset asset = Asset.getDefaultAsset(uid);
%>
{
  "accountingcode":"<%=SH.c(asset.getAccountingCode())%>",
  "annuity":"<%=SH.c(asset.getAnnuity())%>",
  "assettype":"<%=SH.c(asset.getAssetType())%>",
  "characteristics":"<%=SH.c(asset.getCharacteristics())%>",
  "code":"<%=SH.c(asset.getCode())%>",
  "comment1":"<%=SH.c(asset.getComment1())%>",
  "comment2":"<%=SH.c(asset.getComment2())%>",
  "comment3":"<%=SH.c(asset.getComment3())%>",
  "comment4":"<%=SH.c(asset.getComment4())%>",
  "comment5":"<%=SH.c(asset.getComment5())%>",
  "comment6":"<%=SH.c(asset.getComment6())%>",
  "comment7":"<%=SH.c(asset.getComment7())%>",
  "comment8":"<%=SH.c(asset.getComment8())%>",
  "comment9":"<%=SH.c(asset.getComment9())%>",
  "comment10":"<%=SH.c(asset.getComment10())%>",
  "comment11":"<%=SH.c(asset.getComment11())%>",
  "comment12":"<%=SH.c(asset.getComment12())%>",
  "comment13":"<%=SH.c(asset.getComment13())%>",
  "comment14":"<%=SH.c(asset.getComment14())%>",
  "comment15":"<%=SH.c(asset.getComment15())%>",
  "comment16":"<%=SH.c(asset.getComment16())%>",
  "comment17":"<%=SH.c(asset.getComment17())%>",
  "comment18":"<%=SH.c(asset.getComment18())%>",
  "comment19":"<%=SH.c(asset.getComment19())%>",
  "comment20":"<%=SH.c(asset.getComment20())%>",
  "description":"<%=SH.c(asset.getDescription())%>",
  "gains":"<%=SH.c(asset.getGains())%>",
  "gmdncode":"<%=SH.c(asset.getGmdncode())%>",
  "loanamount":"<%=asset.getLoanAmount()%>",
  "loancomment":"<%=SH.c(asset.getLoanComment())%>",
  "loaninterestrate":"<%=SH.c(asset.getLoanInterestRate())%>",
  "loanreimbursementamount":"<%=asset.getLoanReimbursementAmount()%>",
  "loadreimbursementplan":"<%=SH.c(asset.getLoanReimbursementPlan())%>",
  "losses":"<%=SH.c(asset.getLosses())%>",
  "nomenclature":"<%=SH.c(asset.getNomenclature())%>",
  "purchaseprice":"<%=asset.getPurchasePrice()%>",
  "quantity":"<%=asset.getQuantity()%>",
  "saleclient":"<%=SH.c(asset.getSaleClient())%>",
  "salevalue":"<%=asset.getSaleValue()%>",
  "serialnumber":"<%=SH.c(asset.getSerialnumber())%>",
  "suppliername":"<%=SH.c(asset.getSupplierName())%>",
  "supplieruid":"<%=SH.c(asset.getSupplierUid())%>"
}