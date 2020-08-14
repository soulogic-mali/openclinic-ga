<%@page import="be.mxs.common.util.system.HTMLEntities,
                be.openclinic.util.*,be.openclinic.assets.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%
	String assetuid = checkString(request.getParameter("assetuid"));
	String serviceuid = "";
	String servicename = "";
	Asset asset = Asset.get(assetuid);
	if(asset!=null){
		serviceuid = checkString(asset.getServiceuid());
		servicename = getTranNoLink("service",checkString(asset.getServiceuid()),sWebLanguage);
	}
%>

{
  "serviceuid":"<%=HTMLEntities.htmlentities(serviceuid)%>",
  "servicename":"<%=HTMLEntities.htmlentities(servicename)%>"
}