<%@page import="java.io.PrintWriter"%>
<%@page import="org.dom4j.DocumentHelper"%>
<%@page import="be.mxs.common.util.system.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%!
	void changeLabels(Element element,String targetLanguage){
		Iterator iElements = element.elementIterator();
		while(iElements.hasNext()){
			Element e = (Element)iElements.next();
			if(e.getName().equalsIgnoreCase("label")){
				String sourceLanguage=e.attributeValue("language");
				String s = MedwanQuery.getInstance().translate(e.getText(),sourceLanguage , targetLanguage);
				System.out.println("Translating "+e.getText()+" from "+sourceLanguage+" to "+targetLanguage);
				System.out.println(s);
				e.setAttributeValue("language", targetLanguage);
				e.setText("");
				e.addCDATA(s);
			}
			else if(e.getName().equalsIgnoreCase("cave") || e.getName().equalsIgnoreCase("exclude")){
				String sourceLanguage="fr";
				String s = MedwanQuery.getInstance().translate(e.getText(),sourceLanguage , targetLanguage);
				System.out.println("Translating "+e.getText()+" from "+sourceLanguage+" to "+targetLanguage);
				System.out.println(s);
				e.setAttributeValue("language", targetLanguage);
				e.setText("");
				e.addCDATA(s);
			}
			else{
				changeLabels(e,targetLanguage);
			}
		}
	}
%>
<%
	String targetLanguage="en";

	SAXReader reader = new SAXReader(false);
	Document document = reader.read(new File("c:/temp/pathways.bi.xml"));
	Element root = document.getRootElement();
	changeLabels(root,targetLanguage);
	PrintWriter pw = new PrintWriter("c:/temp/pathways."+targetLanguage+".xml");
	pw.print(new String(document.asXML().getBytes("utf-8")));
	pw.flush();
	pw.close();
%>