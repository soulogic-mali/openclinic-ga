<%@page import="be.mxs.common.util.system.HTMLEntities,
                be.openclinic.util.*,be.openclinic.assets.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%
	String assetuid = checkString(request.getParameter("assetuid"));
	String nomenclaturecode = "";
	Asset asset = Asset.get(assetuid);
	if(asset!=null){
		nomenclaturecode=asset.getNomenclature();
	}
%>

{
  "nomenclaturecode":"<%=HTMLEntities.htmlentities(nomenclaturecode)%>",
  "nomenclature":"<%=HTMLEntities.htmlentities(getTranNoLink("admin.nomenclature.asset",nomenclaturecode,sWebLanguage))%>"
}