<%@page import="java.io.*"%>
<%@include file="/includes/validateUser.jsp" %>
<%
	String sHtml="";
	String sFields = "<fields>"+checkString(request.getParameter("fieldlist"))+"</fields>";
    SAXReader reader = new SAXReader(false);
	BufferedReader br = new BufferedReader(new StringReader(sFields));
	Document document = reader.read(br);
	Element root = document.getRootElement();
	Iterator iFields = root.elementIterator();
	while(iFields.hasNext()){
		Element field = (Element)iFields.next();
		if(field.getName().equalsIgnoreCase("field")){
			sHtml+="<tr><td class='admin'></td><td class='admin2'><img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' onclick='deleteField(\\\""+field.elementText("name")+"\\\")'> "+field.elementText("name")+
					"</td><td class='admin2'>"+getTranNoLink("reportparametertypes",field.elementText("type"),sWebLanguage)+(checkString(field.elementText("type")).length()>0?" ("+field.elementText("type")+(field.elementText("modifier").length()>0?": "+field.elementText("modifier"):"")+")":"")+"</td><td class='admin2'/></tr>";
		}
	}
%>
<%
	out.print("{\"html\":\""+sHtml+"\"}");
%>