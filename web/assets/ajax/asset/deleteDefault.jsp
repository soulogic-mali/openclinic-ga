<%@page import="be.openclinic.assets.MaintenancePlan,
               java.text.*,be.openclinic.util.*,be.openclinic.assets.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	Asset.deleteDefault(Integer.parseInt(request.getParameter("assetuid")));
%>