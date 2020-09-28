<%@page import="java.io.*,be.mxs.common.util.system.Base64Coder,net.admin.*,org.apache.commons.io.IOUtils,be.mxs.common.util.system.SessionMessage,java.util.*,be.mxs.common.util.db.*,org.dom4j.*,java.io.ByteArrayOutputStream,java.io.PrintWriter,java.text.*"%><%@ page import="be.openclinic.sync.*" %>
<%
	try{
	InputStream input = request.getInputStream();
    String xml = IOUtils.toString(input);

    if(xml!=null){
		Document message = DocumentHelper.parseText(xml);
		Element root = message.getRootElement();
		//First check if this is a valid login
		String login =root.attributeValue("login");
		byte[] encryptedpassword = Base64Coder.decode(root.attributeValue("password"));
		if(!User.validate(login, new String(encryptedpassword))){
			message=DocumentHelper.createDocument();
			message.setRootElement(DocumentHelper.createElement("export"));
			message.getRootElement().addAttribute("error", "remote.login.error");
		}
		else if(!User.hasAccessRight(login, "system.exporttomaster","select")){
			message=DocumentHelper.createDocument();
			message.setRootElement(DocumentHelper.createElement("export"));
			message.getRootElement().addAttribute("error", "remote.login.nopermission");
		}
		else if(root.attributeValue("command").equalsIgnoreCase("getIds")){
			root.setAttributeValue("command", "setIds");
			OpenclinicSlaveExporter openclinicSlaveExporter = new OpenclinicSlaveExporter(new SessionMessage());
			message=openclinicSlaveExporter.getNewIds(message);
		}
		else if(root.attributeValue("command").equalsIgnoreCase("store")){
			OpenclinicSlaveExporter openclinicSlaveExporter = new OpenclinicSlaveExporter(new SessionMessage());
			message=openclinicSlaveExporter.store(message);
		}
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicExport" + new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date()) + ".xml\"");
        ServletOutputStream os = response.getOutputStream();
        byte[] b = null;
        try{
        	b = message.asXML().getBytes();
        }
        catch(Exception e){
        	e.printStackTrace();
        }
        for (int n=0;n<b.length;n++) {
            os.write(b[n]);
        }
        os.flush();
        os.close();
	}
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>