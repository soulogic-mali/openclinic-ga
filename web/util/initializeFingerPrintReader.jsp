<%@include file="/includes/helper.jsp"%><%
	response.setHeader("Cache-Control", "max-age=30");
	response.setContentType("application/x-java-OCFP-file OCFP");
	response.setHeader("Content-disposition", "inline; filename=openclinic.OCFP");
    String server=(request.getProtocol().toLowerCase().startsWith("https")?"https":"http")+"://"+ request.getServerName()+":"+request.getServerPort();
    if(checkString(request.getParameter("clear")).equalsIgnoreCase("1")){
    	session.setAttribute("fingerprintid", "");
    	session.setAttribute("fingerprintimage", "");
    }
    session.setAttribute("callId","");
%>fingerprinttest.bat checkReady <%=server+sCONTEXTPATH %>/util/sendFingerPrintData.jsp <%=session.getId() %>
