<%@page import="be.openclinic.reporting.*,java.io.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>
<%!
	Element getElement(Element element, String elementname, String attributename,String attributevalue){
		Iterator elements = element.elementIterator(elementname);
		while(elements.hasNext()){
			Element e = (Element)elements.next();
			if(e.attributeValue(attributename)!=null && ((attributevalue==null) || (e.attributeValue(attributename).equalsIgnoreCase(attributevalue)))){
				return e;
			}
		}
		return null;
	}
%>

<table width='100%'>
	<tr class='admin'>
		<td colspan='2'><%=getTran(request,"web","jasperreportdetails",sWebLanguage) %></td>
	</tr>
	<%
		String uid = request.getParameter("uid");
		Report report = Report.get(uid);
	    SAXReader reader = new SAXReader(false);
		BufferedReader br = new BufferedReader(new StringReader(report.getReportxml()));
		Document document = reader.read(br);
		Element root = document.getRootElement();
		out.println("<tr><td nowrap class='admin'>Internal Report Name</td><td class='admin2'>"+root.attributeValue("name")+"</td></tr>");
		out.println("<tr><td nowrap class='admin'>Page width</td><td class='admin2'>"+new Double((Double.parseDouble(root.attributeValue("pageWidth"))-Double.parseDouble(root.attributeValue("leftMargin"))-Double.parseDouble(root.attributeValue("rightMargin")))*0.3937).intValue()+" mm</td></tr>");
		out.println("<tr><td nowrap class='admin'>Page height</td><td class='admin2'>"+new Double((Double.parseDouble(root.attributeValue("pageHeight"))-Double.parseDouble(root.attributeValue("topMargin"))-Double.parseDouble(root.attributeValue("bottomMargin")))*0.3937).intValue()+" mm</td></tr>");
		Element e = getElement(root, "property", "name","net.sf.jasperreports.export.xls.exclude.origin.keep.first.band.1");
		if(e!=null){
			out.println("<tr><td class='admin'>Suppress header band 1 in Excel format</td><td class='admin2'>"+e.attributeValue("value")+"</td></tr>");
		}
		e = getElement(root, "property", "name","net.sf.jasperreports.export.xls.exclude.origin.keep.first.band.2");
		if(e!=null){
			out.println("<tr><td nowrap class='admin'>Suppress header band 2 in Excel format</td><td class='admin2'>"+e.attributeValue("value")+"</td></tr>");
		}
		out.println("<tr><td nowrap class='admin'>Query</td><td class='admin2'>"+root.elementText("queryString").replace("\n"," ").replace("$P", "<b>$P").replaceAll("}", "}</b>").replaceAll(" and", "<br/>and").replaceAll(" from", "<br/>from").replaceAll(" where", "<br/>where")+"</td></tr>");
	%>
	<tr class='admin'>
		<td colspan='2'><%=getTran(request,"web","fields",sWebLanguage) %></td>
	</tr>
	<%
		Iterator elements = root.elementIterator("field");
		while(elements.hasNext()){
			Element element = (Element)elements.next();
			out.println("<tr><td nowrap class='admin'>"+element.attributeValue("name")+"</td><td class='admin2'>"+element.attributeValue("class")+"</td></tr>");
		}
	%>
	<tr class='admin'>
		<td colspan='2'><%=getTran(request,"web","parameters",sWebLanguage) %></td>
	</tr>
	<%
		elements = root.elementIterator("parameter");
		while(elements.hasNext()){
			Element element = (Element)elements.next();
			out.println("<tr><td nowrap class='admin'>"+element.attributeValue("name")+"</td><td class='admin2'>"+element.attributeValue("class")+"</td></tr>");
		}
	%>

</table>

