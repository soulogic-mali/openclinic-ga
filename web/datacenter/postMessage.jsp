<%@page import="java.io.*,be.openclinic.datacenter.*,org.dom4j.DocumentException"%>
<%@include file="/includes/helper.jsp"%>
<%
	String key = SH.c(request.getParameter("key"));
	String type = SH.c(request.getParameter("type"));
	String message = SH.c(request.getParameter("message"));
	String sResult = "<ERROR>";
	if(type.equalsIgnoreCase("post")){
    	//Store the message in the oc_imports database here and delete it if successful
        SAXReader reader = new SAXReader(false);
        try{
		    if(message.indexOf("</message>")>-1){
		    	message=message.substring(0,message.indexOf("</message>")+10);
		    }
			Document document = reader.read(new ByteArrayInputStream(message.getBytes("UTF-8")));
			Element root = document.getRootElement();
			Iterator msgs = root.elementIterator("data");
			Vector ackMessages=new Vector();
			while(msgs.hasNext()){
				Element data = (Element)msgs.next();
		    	ImportMessage msg = new ImportMessage(data);
				msg.setType(root.attributeValue("type"));
			    Debug.println("Message type = "+root.attributeValue("type")+ " from "+SH.getRemoteAddr(request));
		    	msg.setReceiveDateTime(new java.util.Date());
		    	msg.setRef("HTTP:"+SH.getRemoteAddr(request));
		    	try {
					msg.setAckDateTime(new java.util.Date());
					msg.store();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		    Debug.println("Sending ACK for received message ");
			sResult="<OK>";
        } catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (DocumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
%>
<%=sResult%>