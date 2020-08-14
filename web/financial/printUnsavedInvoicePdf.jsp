<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%@page import="java.io.ByteArrayOutputStream,
                com.itextpdf.text.DocumentException,
                java.io.PrintWriter,
                be.mxs.common.util.pdf.general.*"%>
<%@ page import="be.openclinic.finance.*" %>
<%
    String sInvoiceUid    = "",
           sPrintLanguage = sWebLanguage,
           sPrintModel = "deafult",
           sProforma      = "yes";
 


	ByteArrayOutputStream baosPDF = null;

    try{
        // PDF generator
        PatientInvoice invoice = new PatientInvoice();
        invoice.setPatient(activePatient);
        invoice.setUid("0.0");
        
        String sEditDate = checkString(request.getParameter("EditDate"));
        String sEditDeliveryDate = checkString(request.getParameter("EditDeliveryDate"));
        String sEditPatientInvoiceUID = checkString(request.getParameter("EditPatientInvoiceUID"));
        String sEditInvoiceUID = checkString(request.getParameter("EditInvoiceUID"));
        String sEditStatus = checkString(request.getParameter("EditStatus"));
        String sEditBalance = checkString(request.getParameter("EditBalance"));
        String sEditCBs = checkString(request.getParameter("EditCBs"));
        String sEditInvoiceSeries = checkString(request.getParameter("EditInvoiceSeries"));
        String sEditInsurarReference = checkString(request.getParameter("EditInsurarReference"));
        String sEditInvoiceVerifier = checkString(request.getParameter("EditInvoiceVerifier"));
        String sEditInsurarReferenceDate = checkString(request.getParameter("EditInsurarReferenceDate"));
        String sEditReduction = checkString(request.getParameter("EditReduction"));
        String sEditComment = checkString(request.getParameter("EditComment"));
        String acceptationuid = checkString(request.getParameter("EditAcceptationUid"));
        String sEditInvoiceDoctor=checkString(request.getParameter("EditInvoiceDoctor"));
        String sEditInvoicePost=checkString(request.getParameter("EditInvoicePost"));
        String sEditInvoiceAgent=checkString(request.getParameter("EditInvoiceAgent"));
        String sEditInvoiceDrugsIdCard=checkString(request.getParameter("EditInvoiceDrugsIdCard"));
        String sEditInvoiceDrugsRecipient=checkString(request.getParameter("EditInvoiceDrugsRecipient"));
        String sEditInvoiceDrugsIdCardPlace=checkString(request.getParameter("EditInvoiceDrugsIdCardPlace"));
        String sEditInvoiceDrugsIdCardDate=checkString(request.getParameter("EditInvoiceDrugsIdCardDate"));

        invoice.setCreateDateTime(getSQLTime());
        invoice.setStatus(sEditStatus);
        invoice.setEstimatedDeliveryDate(sEditDeliveryDate);
        invoice.setPatientUid(activePatient.personid);
        invoice.setInvoiceUid(sEditInvoiceUID);
        invoice.setDate(ScreenHelper.getSQLDate(sEditDate));
        invoice.setUid(sEditPatientInvoiceUID);
        invoice.setUpdateDateTime(ScreenHelper.getSQLDate(getDate()));
        invoice.setUpdateUser(activeUser.userid);
        invoice.setInsurarreference(sEditInsurarReference);
        invoice.setInsurarreferenceDate(sEditInsurarReferenceDate);
        invoice.setVerifier(sEditInvoiceVerifier);
        invoice.setComment(sEditComment);
        invoice.setMfpDoctor(sEditInvoiceDoctor);
        invoice.setMfpPost(sEditInvoicePost);
        invoice.setMfpAgent(sEditInvoiceAgent);
        invoice.setMfpDrugReceiver(sEditInvoiceDrugsRecipient);
        invoice.setMfpDrugReceiverId(sEditInvoiceDrugsIdCard);
        invoice.setMfpDrugIdCardDate(sEditInvoiceDrugsIdCardDate);
        invoice.setMfpDrugIdCardPlace(sEditInvoiceDrugsIdCardPlace);
        invoice.setDebets(new Vector());
        invoice.setCredits(new Vector());
        double dTotalCredits = 0;
        double dTotalDebets = 0;
        if (sEditCBs.length() > 0) {
            String[] aCBs = sEditCBs.split(",");
            String sID;
            PatientCredit patientcredit;
            Debet debet;

            for (int i = 0; i < aCBs.length; i++) {
                if (checkString(aCBs[i]).length() > 0) {	
                    if (checkString(aCBs[i]).startsWith("cbDebet")) {
                        sID = aCBs[i].substring(7);
                        debet = Debet.get(sID);
                        invoice.getDebets().add(debet);

                        if (debet != null) {
                            dTotalDebets += debet.getAmount();
                        }
                    } 
                }
            }
            if(acceptationuid.length()>0){
            	invoice.setAcceptationUid(acceptationuid);
            }
        }
        
        sProject = checkString((String)session.getAttribute("activeProjectTitle")).toLowerCase();
        PDFInvoiceGenerator pdfGenerator;
        if(!sProforma.equalsIgnoreCase("debetnote") && sPrintModel.equalsIgnoreCase("ctams")){
        	pdfGenerator = new PDFPatientInvoiceGeneratorCTAMS(activeUser,invoice.getPatient(),sProject,sPrintLanguage,sProforma);
        }
        else if(!sProforma.equalsIgnoreCase("debetnote") && sPrintModel.equalsIgnoreCase("cmck")){
        	pdfGenerator = new PDFPatientInvoiceGeneratorCMCK(activeUser,invoice.getPatient(),sProject,sPrintLanguage,sProforma);
        }
        else if(!sProforma.equalsIgnoreCase("debetnote") && sPrintModel.equalsIgnoreCase("hmk")){
        	pdfGenerator = new PDFPatientInvoiceGeneratorHMK(activeUser,invoice.getPatient(),sProject,sPrintLanguage,sProforma);
        }
        else if(!sProforma.equalsIgnoreCase("debetnote") && sPrintModel.equalsIgnoreCase("mfp")){
        	pdfGenerator = new PDFPatientInvoiceGeneratorMFP(activeUser,invoice.getPatient(),sProject,sPrintLanguage,sProforma);
        }
        else if(!sProforma.equalsIgnoreCase("debetnote") && sPrintModel.equalsIgnoreCase("mfppharma")){
        	pdfGenerator = new PDFPatientInvoiceGeneratorMFPPharma(activeUser,invoice.getPatient(),sProject,sPrintLanguage,sProforma);
        }
        else {
        	pdfGenerator = new PDFPatientInvoiceGenerator(activeUser,invoice.getPatient(),sProject,sPrintLanguage,sProforma);
        }
        baosPDF = pdfGenerator.generatePDFDocumentBytes(request,invoice);

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