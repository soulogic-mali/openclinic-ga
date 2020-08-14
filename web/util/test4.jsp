<%@page import="java.io.File"%>
<%@page import="ocdhis2.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<table border="1">
<%
	SAXReader reader = new SAXReader(false);
	Document document;
	try {
		document = reader.read(new File("c:/temp/dhis2.bi.xml"));
		Element root = document.getRootElement();
		Iterator i = root.elementIterator("dataset");
		while(i.hasNext()){
			Element dataset = (Element)i.next();
			if(dataset.attributeValue("uid").equals("hv4xIeOnn5A")){
				Element dataelements = dataset.element("dataelements");
				Iterator iDataElements = dataelements.elementIterator("dataelement");
				while(iDataElements.hasNext()){
					Element dataElement = (Element)iDataElements.next();
					String code = dataElement.attributeValue("code");
					String diagnose = MedwanQuery.getInstance().getCodeTran("icd10code"+code, sWebLanguage);
					out.println("<tr><td>"+code+"</td><td>"+diagnose+"</td></tr>");
				}
			}
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
%>
</table>