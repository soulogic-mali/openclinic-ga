<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%@page import="java.io.ByteArrayOutputStream,
                com.itextpdf.text.DocumentException,
                java.io.PrintWriter,
                be.mxs.common.util.pdf.general.*"%>
<%@ page import="be.openclinic.finance.Invoice" %>
<%@ page import="be.openclinic.finance.PatientInvoice" %>
<%
    String sInvoiceUid    = checkString(request.getParameter("InvoiceUid")),
           sPrintLanguage = checkString(request.getParameter("PrintLanguage"));
    ByteArrayOutputStream baosPDF = null;

    try{
        // PDF generator
        PatientInvoice invoice = PatientInvoice.get(sInvoiceUid);
        sProject = checkString((String)session.getAttribute("activeProjectTitle")).toLowerCase();
        PDFInvoiceGenerator pdfGenerator;
        if(MedwanQuery.getInstance().getConfigInt("enablePatientInvoiceReceiptCPLR",0)==1){
        	com.itextpdf.text.Image image = null;
        	
            // Try to find the image in the config cache
            String imageSource = MedwanQuery.getInstance().getConfigString("PDFIMG.JavaPOSImage1.gif."+sProject);
            if(imageSource!=null && imageSource.length()>0){
                try {
                	Debug.println("(config cache) imageSource : "+imageSource);
                }
                catch (Exception e){
                	e.printStackTrace();
                }
            }
        	pdfGenerator = new PDFPatientInvoiceReceiptGeneratorCPLR(activeUser,invoice.getPatient(),sProject,sPrintLanguage);
        }
        else{
        	pdfGenerator = new PDFPatientInvoiceReceiptGenerator(activeUser,invoice.getPatient(),sProject,sPrintLanguage);
        }
        baosPDF = pdfGenerator.generatePDFDocumentBytes(request,sInvoiceUid);

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