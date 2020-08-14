 <%@page import="pe.gob.sis.*,java.util.*,javax.xml.soap.*,org.dom4j.*,org.dom4j.io.*,java.io.*"%>
<%@page import="pe.gob.sis.FUAGenerator"%>
<%
	FUAGenerator generator = new FUAGenerator();
	String zipfile = generator.generateFUAs(Integer.parseInt(request.getParameter("year")),Integer.parseInt(request.getParameter("month")));
	if(request.getParameter("sendfile")!=null && request.getParameter("sendfile").length()>0){
		//Send the file to SIS
	    SOAPMessage mresponse = generator.sendSOAPFUAZip(zipfile.split("/")[zipfile.split("/").length-1], zipfile);
		System.out.println("*********************SOAP RESPONSE******************************");
		System.out.println(generator.getPrettyPrint(mresponse));
		System.out.println("*******************END SOAP RESPONSE****************************");
	}
    response.setContentType("application/octet-stream; charset=windows-1252");
    response.setHeader("Content-Disposition", "Attachment;Filename=\""+zipfile.split("/")[zipfile.split("/").length-1]+"\"");
   
    ServletOutputStream os = response.getOutputStream();
    File file = new File(zipfile);
    byte[] b = new byte[(int) file.length()];
    InputStream is = new FileInputStream(file);
    is.read(b);
    is.close();    
    for(int n=0; n<b.length; n++){
        os.write(b[n]);
    }
    os.flush();
    os.close();
%>