<%@page import="java.util.Iterator,org.apache.commons.httpclient.*,org.apache.commons.httpclient.methods.*,org.apache.http.client.methods.*,
org.apache.http.impl.client.*,org.apache.http.message.*,org.apache.http.client.entity.*,org.apache.http.entity.mime.*,org.apache.http.*,org.apache.http.entity.*"%>
<%@page import="org.dom4j.*,java.net.*"%>
<%@page import="org.dom4j.io.SAXReader"%>
<%@page import="java.io.File,java.util.*"%>
<%@page import="be.mxs.common.util.db.MedwanQuery,java.sql.*,be.openclinic.assets.*,org.apache.commons.io.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%!
	java.util.Date std(String s){
		try{
			return new SimpleDateFormat("yyyyMMddHHmmssSSS").parse(s);
		}
		catch(Exception e){
			e.printStackTrace();
			return null;
		}
	}
%>
<%
	String filename=SH.p(request,"filename");
	String filter=SH.p(request,"filter");
	if(SH.p(request,"forcefilter").length()>0){
		filter=SH.p(request,"forcefilter");
	}
	if(!filter.equalsIgnoreCase("all")){
		%>
		<form name='myform' method='post'><input type='hidden' name='forcefilter' id='forcefilter' value='all'/><a href='javascript:myform.submit()'><%=getTran(request,"web","viewall",sWebLanguage) %></a></form>
		<%
	}
%>
<table width='100%'>
	<tr class='admin'>
		<td><%=getTran(request,"web","id",sWebLanguage) %></td>
		<td><%=getTran(request,"web","type",sWebLanguage) %></td>
		<td><%=getTran(request,"web","datemodified",sWebLanguage) %></td>
		<td><%=getTran(request,"web","service",sWebLanguage) %></td>
		<td><%=getTran(request,"web","description",sWebLanguage) %></td>
	</tr>
<%
try{
	SAXReader reader = new SAXReader(false);
	Document document = reader.read(new File(filename));
	Element root = document.getRootElement();
	Iterator<Element> iAssets = root.elementIterator("asset");
	while(iAssets.hasNext()){
		Element eAsset = iAssets.next();
		if(filter.equalsIgnoreCase("all") || SH.c(eAsset.elementText("lockeddate")).length()>0 && std(SH.c(eAsset.elementText("lockeddate"))).before(std(SH.c(eAsset.elementText("updatetime"))))){
			out.println("<tr><td class='admin'>"+eAsset.attributeValue("serverid")+"."+eAsset.attributeValue("objectid")+"</td>"+
					 "<td class='admin2'>"+getTran(request,"web","asset",sWebLanguage)+"</td>"+
			 		 "<td class='admin2'>"+SH.formatDate(std(eAsset.elementText("updatetime")),SH.fullDateFormatSS)+"</td>"+
					 "<td class='admin2'><b>"+eAsset.elementText("service").toUpperCase()+"</b></td>"+
					 "<td class='admin2'><b>"+eAsset.elementText("description").toUpperCase()+"</b></td></tr>");
		}
		Iterator<Element> iPlans = eAsset.element("maintenanceplans").elementIterator("maintenanceplan");
		while(iPlans.hasNext()){
			Element ePlan =iPlans.next();
			if(filter.equalsIgnoreCase("all") || SH.c(eAsset.elementText("lockeddate")).length()>0 && std(SH.c(eAsset.elementText("lockeddate"))).before(std(SH.c(ePlan.elementText("updatetime"))))){
				out.println("<tr><td class='admin'>"+ePlan.attributeValue("serverid")+"."+ePlan.attributeValue("objectid")+"</td>"+
						 "<td class='admin2'>"+getTran(request,"web","maintenanceplan",sWebLanguage)+"</td>"+
						 "<td class='admin2'>"+SH.formatDate(std(ePlan.elementText("updatetime")),SH.fullDateFormatSS)+"</td>"+
						 "<td class='admin2'><b>"+eAsset.elementText("service").toUpperCase()+"</b></td>"+
						 "<td class='admin2'>==> "+ePlan.elementText("name")+"</td></tr>");
			}
			Iterator<Element> iOperations = ePlan.element("maintenanceoperations").elementIterator("maintenanceoperation");
			while(iOperations.hasNext()){
				Element eOperation =iOperations.next();
				if(filter.equalsIgnoreCase("all") || SH.c(eAsset.elementText("lockeddate")).length()>0 && std(SH.c(eAsset.elementText("lockeddate"))).before(std(SH.c(eOperation.elementText("updatetime"))))){
					out.println("<tr><td class='admin'>"+eOperation.attributeValue("serverid")+"."+eOperation.attributeValue("objectid")+"</td>"+
							 "<td class='admin2'>"+getTran(request,"web","maintenanceoperation",sWebLanguage)+"</td>"+
							 "<td class='admin2'>"+SH.formatDate(std(eOperation.elementText("updatetime")),SH.fullDateFormatSS)+"</td>"+
							 "<td class='admin2'><b>"+eAsset.elementText("service").toUpperCase()+"</b></td>"+
							 "<td class='admin2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;==> <i>"+eOperation.elementText("operator")+"</i></td></tr>");
				}
				
			}
		}
	}
}
catch(Exception e){
	e.printStackTrace();
}

%>
</table>