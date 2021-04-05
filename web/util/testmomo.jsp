<%@page import="be.openclinic.mobilemoney.*"%>
<%
	try{
		MTN mm = new MTN();
		System.out.println(1);
		mm.createSandBoxApiUser();
		System.out.println(2);
		out.println("<br/>Auth = "+mm.getBasicAuthentication());
		System.out.println(3);
		out.println("<br/>Subscription = "+mm.getCollectionSubscriptionKey());
		System.out.println(4);
		out.println("<br/>Token = "+mm.createCollectionToken().getToken());
		System.out.println(5);
		out.println("<br/>Subscription = "+mm.getDisbursementSubscriptionKey());
		System.out.println(6);
		out.println("<br/>Token = "+mm.createDisbursementToken().getToken());
		System.out.println(7);
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>

