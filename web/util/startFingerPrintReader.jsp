<%@include file="/includes/helper.jsp"%><%
	response.setHeader("Cache-Control", "max-age=30");
	response.setContentType("application/x-java-OCFP-file OCFP");
	response.setHeader("Content-disposition", "inline; filename=openclinic.OCFP");
    String server=(request.getProtocol().toLowerCase().startsWith("https")?"https":"http")+"://"+ request.getServerName()+":"+request.getServerPort();
%>fingerprinttest.bat getFingerPrint <%=server+sCONTEXTPATH %>/util/sendFingerPrintData.jsp <%=session.getId() %>
