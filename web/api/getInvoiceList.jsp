<%@page import="be.openclinic.api.*"%>
<%
	InvoiceList invoicelist = new InvoiceList(request);
	if(invoicelist.value("output","body").equalsIgnoreCase("attachment")){
		String extension=invoicelist.value("format","xml").equalsIgnoreCase("json")?"json":"xml";
		String s=invoicelist.get();
	    response.setContentType("application/octet-stream; charset=windows-1252");
	    response.setHeader("Content-Disposition", "Attachment;Filename=\"openclinic_api_"+new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date())+"."+extension+"\"");
	    ServletOutputStream os = response.getOutputStream();
    	byte[] b = s.getBytes("ISO-8859-1");
        for(int n=0; n<b.length; n++){
            os.write(b[n]);
        }
        os.flush();
        os.close();
	}
	else{
		out.println(invoicelist.get());
	}
%>