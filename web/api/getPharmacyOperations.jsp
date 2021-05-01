<%@page import="org.apache.commons.httpclient.*,org.apache.commons.httpclient.methods.*,java.io.*"%>
<%@include file="/includes/helper.jsp"%>
<%
	String sResult="<response type='error' message='[0.0] Undefined error'/>";
	try{
		String objecttype=request.getParameter("objecttype");
		String xml=request.getParameter("xml");
        SAXReader reader = new SAXReader(false);
		Document document = reader.read(new ByteArrayInputStream(s.getBytes()));
		if(objecttype.equalsIgnoreCase("operation")){
			Element operation = document.getRootElement();
			String operationType = operation.attributeValue("type"); //Add or Remove
			String operationQuantity = SH.c(operation.attributeValue("quantity"));
			Element product = operation.element("product");
			String productCode = SH.c(product.attributeValue("code"));
			String productATCCode = SH.c(product.attributeValue("atc"));
			String productRxNormCode = SH.c(product.attributeValue("rxnorm"));
			String productName = SH.c(product.elementText("name"));
			String productDose = SH.c(product.elementText("dose"));
			String productUnit = SH.c(product.elementText("unit"));
			String productUnitPrice = SH.c(product.elementText("unitprice"));
			String productPackageUnits = SH.c(product.elementText("packageunits"));
		}
		else if(objecttype.equalsIgnoreCase("order")){
			
		}
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>
<%=sResult %>
