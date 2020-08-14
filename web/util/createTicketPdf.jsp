<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%@page import="java.io.ByteArrayOutputStream,
                com.itextpdf.text.DocumentException,
                java.io.PrintWriter,
                be.mxs.common.util.pdf.general.*"%>
<%@ page import="be.openclinic.finance.Invoice" %>
<%@ page import="be.openclinic.finance.PatientInvoice" %>
<%
    String sObjectid    = checkString(request.getParameter("objectid")),
           sPrintLanguage = checkString(request.getParameter("PrintLanguage"));
    ByteArrayOutputStream baosPDF = null;

    try{
        // PDF generator
        sProject = checkString((String)session.getAttribute("activeProjectTitle")).toLowerCase();
        PDFTicketGenerator pdfGenerator;
       	pdfGenerator = new PDFTicketGenerator(activeUser,activePatient,sProject,sPrintLanguage);
       	if(sObjectid.equalsIgnoreCase("NEW")){
       		be.openclinic.adt.Queue queue = new be.openclinic.adt.Queue();
       		queue.setBegin(new java.util.Date());
       		queue.setSubjecttype("patient");
       		queue.setId(checkString(request.getParameter("queue")));
       		queue.store();
       		sObjectid=queue.getObjectid()+"";
       	}
        baosPDF = pdfGenerator.generatePDFDocumentBytes(request,sObjectid);

        StringBuffer sbFilename = new StringBuffer();
        sbFilename.append("filename_").append(System.currentTimeMillis()).append(".pdf");

        StringBuffer sbContentDispValue = new StringBuffer();
        sbContentDispValue.append("inline; filename=")
                          .append(sbFilename);

        // prepare response
        response.setHeader("Cache-Control","max-age=30");
        response.setContentType("application/pdf");
        response.setHeader("Content-disposition",sbContentDispValue.toString());
        response.setContentLength(baosPDF.size());

        // write PDF to servlet
        ServletOutputStream sos = response.getOutputStream();
        baosPDF.writeTo(sos);
        sos.flush();
    }
    catch(DocumentException dex){
        response.setContentType("text/html");
        PrintWriter writer = response.getWriter();
        writer.println(this.getClass().getName()+ " caught an exception: "+ dex.getClass().getName()+ "<br>");
        writer.println("<pre>");
        dex.printStackTrace(writer);
        writer.println("</pre>");
    }
    finally{
        if(baosPDF != null) {
            baosPDF=null;
        }
    }
%>