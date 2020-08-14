<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%@page import="java.io.ByteArrayOutputStream,
                com.itextpdf.text.DocumentException,
                java.io.PrintWriter,
                be.mxs.common.util.pdf.general.*"%>
<%@ page import="be.openclinic.finance.Invoice" %>
<%@ page import="be.openclinic.finance.PatientInvoice" %>
<%@ page import="be.openclinic.finance.PatientCredit" %>
<%@ page import="be.mxs.common.util.pdf.general.PDFReceiptGenerator" %>

<%
	String sPrintLanguage = checkString(request.getParameter("PrintLanguage"),sWebLanguage);
	String sReportFileName = checkString(request.getParameter("filename"));
	Encounter encounter = Encounter.getActiveEncounter(activePatient.personid);
	
    ByteArrayOutputStream baosPDF = null;

    try{
        // PDF generator
        sProject = checkString((String)session.getAttribute("activeProjectTitle")).toLowerCase();
        PDFXMLReportGenerator pdfGenerator = new PDFXMLReportGenerator(activeUser,sProject,sPrintLanguage);
        baosPDF = pdfGenerator.generatePDFDocumentBytes(request, sReportFileName, encounter.getUid());

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
            baosPDF.reset();
        }
    }
%>