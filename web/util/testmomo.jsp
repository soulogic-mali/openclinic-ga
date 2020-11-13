<%@page import="be.openclinic.mobilemoney.*"%>
<%
	MTN mm = new MTN();
	mm.createSandBoxApiUser();
	out.println("<br/>Auth = "+mm.getBasicAuthentication());
	out.println("<br/>Subscription = "+mm.getCollectionSubscriptionKey());
	out.println("<br/>Token = "+mm.createCollectionToken().getToken());
	out.println("<br/>Subscription = "+mm.getDisbursementSubscriptionKey());
	out.println("<br/>Token = "+mm.createDisbursementToken().getToken());
%>

