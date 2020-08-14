<%@page import="be.mxs.common.util.system.HTMLEntities"%>
<%@page import="org.dom4j.io.SAXReader,
				java.awt.*,java.awt.image.*,be.openclinic.adt.*,
                java.net.URL,
                org.dom4j.Document,
                org.dom4j.Element,
                be.mxs.common.util.db.MedwanQuery,
                org.dom4j.DocumentException,
                java.net.MalformedURLException,java.util.*,
                be.openclinic.knowledge.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%
String id = checkString(request.getParameter("id"));

String sDoc = MedwanQuery.getInstance().getConfigString("templateSource") + "/sdt.xml";
SAXReader reader = new SAXReader(false);
Document document = reader.read(new URL(sDoc));
Element root = document.getRootElement();
Iterator sdts = root.elementIterator("treatment");
while(sdts.hasNext()){
	Element sdt = (Element)sdts.next();
	if(sdt.attributeValue("id").equalsIgnoreCase(id)){
		out.println("<table width='100%'>");
		out.println("<tr><td class='admin'>"+HTMLEntities.htmlentities(sdt.getText())+"</td></tr>");
		if(sdt.element("refs")!=null){
			Iterator refs = sdt.element("refs").elementIterator("ref");
			while(refs.hasNext()){
				Element ref = (Element)refs.next();
				out.println("<tr><td class='admin2'><i>"+HTMLEntities.htmlentities(ref.getText())+"</i></td></tr>");
			}
		}
		out.println("</table>");
	}
}
%>