<%@ page import="be.mxs.common.util.system.*" %>
<%
	String sPatientInvoiceUid=request.getParameter("EditPatientInvoiceUID");
	String sCorrectionRequest=request.getParameter("EditInvoiceCorrection");
	Pointer.deletePointers(sPatientInvoiceUid+".INV.CORRECT");
	Pointer.storePointer(sPatientInvoiceUid+".INV.CORRECT", sCorrectionRequest.replaceAll("\n"," ").replaceAll("\r"," ").replaceAll("'","´"));
%>