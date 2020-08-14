<%@ page import="be.mxs.common.util.system.*" %>
<%
	String sPatientInvoiceUid=request.getParameter("EditPatientInvoiceUID");
	String sUserId=request.getParameter("EditUserUID");
	Pointer.deletePointers(sPatientInvoiceUid+".INV.CORROK");
	Pointer.storePointer(sPatientInvoiceUid+".INV.CORROK", sUserId);
%>