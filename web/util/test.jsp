<%@page import="java.text.spi.DecimalFormatSymbolsProvider"%>
<%@page import="be.openclinic.knowledge.*"%>
<%@page import="be.openclinic.medical.*,be.openclinic.pharmacy.*"%>
<%@page import="java.util.*"%>
<%@page import="org.apache.http.client.utils.URIBuilder"%>
<%@page import="org.apache.commons.httpclient.*,org.apache.commons.httpclient.methods.*,be.openclinic.system.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	out.println(new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormatInsurarCsv","#,##0.00"),new DecimalFormatSymbols(Locale.getDefault())).format(1234.56));
%>