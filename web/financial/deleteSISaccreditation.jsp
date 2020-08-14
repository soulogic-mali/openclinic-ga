<%@page import="net.admin.*,
                java.text.*,
                java.util.*,
                be.mxs.common.util.system.*,
                be.mxs.common.util.db.*,be.openclinic.reporting.*,pe.gob.sis.*,be.openclinic.finance.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sAccreditationId=SH.c(request.getParameter("accreditationid"));
	Acreditacion.delete(sAccreditationId);
%>