<%@page import="java.text.spi.DecimalFormatSymbolsProvider"%>
<%@page import="be.openclinic.pharmacy.RemotePharmacy"%>
<%@page import="be.openclinic.medical.*,be.openclinic.pharmacy.*"%>
<%@page import="java.util.*"%>
<%@page import="org.apache.http.client.utils.URIBuilder"%>
<%@page import="org.apache.commons.httpclient.*,org.apache.commons.httpclient.methods.*,be.openclinic.system.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	DecimalFormat df = new DecimalFormat("0.00",new DecimalFormatSymbols(Locale.getDefault()));
	out.println(df.toPattern()+"<br/>");
	out.println(df.format(1.234));
%>