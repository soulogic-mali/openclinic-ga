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
			boolean bOk=true;
			while(msgs.hasNext()){
				Element data = (Element)msgs.next();
		    	ImportMessage msg = new ImportMessage(data);
		    	Connection conn = SH.getOpenclinicConnection();
		    	PreparedStatement ps = conn.prepareStatement("select * from dc_servers where dc_server_serverid=? and dc_server_key=?");
		    	ps.setInt(1,msg.getServerId());
		    	ps.setString(2,key);
		    	ResultSet rs = ps.executeQuery();
		    	if(rs.next()){
		    		rs.close();
		    		ps.close();
		    		conn.close();
					msg.setType(root.attributeValue("type"));
			    	msg.setReceiveDateTime(new java.util.Date());
			    	msg.setRef("HTTP:"+SH.getRemoteAddr(request));
					msg.setAckDateTime(new java.util.Date());
	    			msg.store();
		    	}
		    	else{
		    		rs.close();
		    		ps.close();
		    		conn.close();
		    		bOk=false;
		    		break;
		    	}
			}
			if(bOk){
			    Debug.println("Sending ACK for received message ");
				sResult="<OK>";
			}
			else{ 
			    Debug.println("Refusing received message");
				sResult="<ERROR>";
			}
		} catch (DocumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		    Debug.println("Document exception. Sending ACK for received message in order to not block further messages");
			sResult="<OK>";
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
%>
<%=sResult%>