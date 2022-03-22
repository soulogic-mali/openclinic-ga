<%@page import="be.openclinic.mobilemoney.*"%>
<%
	try{
		MTN mm = new MTN();
		System.out.println(1);
		mm.createSandBoxApiUser();
		System.out.println(2);
		out.println("<br/>Auth = "+mm.getBasicAuthentication());
		System.out.println(4);
		out.println("<br/>Token = "+mm.createCollectionToken().getToken());
		System.out.println(6);
		out.println("<br/>Token = "+mm.createDisbursementToken().getToken());
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>


