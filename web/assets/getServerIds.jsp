<%@page import="be.mxs.common.util.system.*"%>
<%@page import="be.openclinic.assets.*"%>

<%
	String sXmlOut=Asset.convertNegativeIds(ScreenHelper.checkString(request.getParameter("xml")));
	response.setContentType("application/octet-stream");
	ServletOutputStream os = response.getOutputStream();
	byte[] b = sXmlOut.getBytes();
	for(int n=0; n<b.length; n++){
	    os.write(b[n]);
	}
	os.flush();
	os.close();
%>