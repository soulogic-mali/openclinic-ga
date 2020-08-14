<%@page import="java.io.*,be.openclinic.reporting.*,be.mxs.common.util.pdf.general.*,com.itextpdf.text.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sLanguage = checkString(request.getParameter("language"));
	String sBegindate = checkString(request.getParameter("begindate"));
	String sEnddate = checkString(request.getParameter("enddate"));
	String id = checkString(request.getParameter("id"));
	ByteArrayOutputStream baosPDF = null;
	try {
	    // PDF generator
	    PDFRegisterGenerator pdfRegisterGenerator = new PDFRegisterGenerator(activeUser, sProject);
	    baosPDF = pdfRegisterGenerator.generatePDFDocumentBytes(request, id,sBegindate,sEnddate,sLanguage);
	    StringBuffer sbFilename = new StringBuffer();
	    sbFilename.append("filename_").append(System.currentTimeMillis()).append(".pdf");
	
	    StringBuffer sbContentDispValue = new StringBuffer();
	    sbContentDispValue.append("inline; filename=")
	            .append(sbFilename);
	
	    // prepare response
	    response.setHeader("Cache-Control", "max-age=30");
	    response.setContentType("application/pdf");
	    response.setHeader("Content-disposition", sbContentDispValue.toString());
	    response.setContentLength(baosPDF.size());
	
	    // write PDF to servlet
	    ServletOutputStream sos = response.getOutputStream();
	    baosPDF.writeTo(sos);
	    sos.flush();
	}
	catch (DocumentException dex) {
	    response.setContentType("text/html");
	    PrintWriter writer = response.getWriter();
	    writer.println(this.getClass().getName() + " caught an exception: " + dex.getClass().getName() + "<br>");
	    writer.println("<pre>");
	    dex.printStackTrace(writer);
	    writer.println("</pre>");
	}
	finally {
	    if (baosPDF != null) {
	        baosPDF.reset();
	    }
	}
%>
