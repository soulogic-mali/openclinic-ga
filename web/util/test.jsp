<%@page import="be.openclinic.pharmacy.RemotePharmacy"%>
<%@page import="be.openclinic.medical.*,be.openclinic.pharmacy.*"%>
<%@page import="java.util.*"%>
<%@page import="org.apache.http.client.utils.URIBuilder"%>
<%@page import="org.apache.commons.httpclient.*,org.apache.commons.httpclient.methods.*,be.openclinic.system.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%

RemotePharmacy.getPharmacyOperations(ServiceStock.get("1.10"),activeUser.userid);
/*
System.out.println(r.asXML());
Iterator<Element> messages = r.elementIterator("message");
	while(messages.hasNext()){
		RemotePharmacy.processPharmacyOperation("1.10", messages.next(), activeUser.userid);
	}
*/

%>