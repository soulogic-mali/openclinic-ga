<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%@page import="java.io.ByteArrayOutputStream,be.dpms.medwan.common.model.vo.occupationalmedicine.ExaminationVO,
                com.itextpdf.text.DocumentException,
                java.io.PrintWriter,net.admin.*,
                be.mxs.common.util.pdf.general.*,be.openclinic.adt.*,be.openclinic.finance.*,java.util.Date"%>
<%@ page import="be.mxs.common.util.pdf.calendar.*" %>
<%
	String sAppointmentUid = request.getParameter("AppointmentUid");
    ByteArrayOutputStream baosPDF = null;

    try{
        Planning appointment = Planning.get(sAppointmentUid);
       // margin left
       appointment.setMargin(0);
       AdminPerson patient = appointment.getPatient();
       // PDF generator
       sProject = checkString((String)session.getAttribute("activeProjectTitle")).toLowerCase();
       PDFAppointmentGenerator pdfGenerator = new PDFAppointmentGenerator(activeUser,sProject,sWebLanguage);
       
       String sHeader = getTranNoLink("web","appointment.list.patient",sWebLanguage)+" \n"+patient.lastname+" "+patient.firstname+" \n°"+ patient.dateOfBirth+" ("+patient.personid+")";
       pdfGenerator.addHeader(sHeader);

       Date plannedStart=appointment.getPlannedDate();
       Date plannedEnd=appointment.getPlannedEndDate();
       pdfGenerator.addDateRow(appointment,10);
       if(patient!=null){
    	   pdfGenerator.addKeyValueRow(getTranNoLink("web","immatnew",sWebLanguage),patient.getID("immatnew"));
    	   pdfGenerator.addKeyValueRow(getTranNoLink("web.occup","medwan.common.patientname",sWebLanguage),patient.getFullName());
    	   pdfGenerator.addKeyValueRow(getTranNoLink("web","dateofbirth",sWebLanguage),patient.dateOfBirth);
    	   pdfGenerator.addKeyValueRow(getTranNoLink("web","gender",sWebLanguage),patient.gender);
    	   String s="";
    	   Encounter encounter = Encounter.getActiveEncounter(patient.personid);
    	   if(encounter!=null){
    		   s=getTranNoLink("web",encounter.getType(),sWebLanguage);
    	   }
    	   pdfGenerator.addKeyValueRow(getTranNoLink("web","encounter",sWebLanguage),s);
    	   AdminPrivateContact adminPrivate = patient.getActivePrivate();
    	   if(adminPrivate!=null){
    		   pdfGenerator.addKeyValueRow(getTranNoLink("web","telephone",sWebLanguage),adminPrivate.telephone);
    	   }
       }
	   pdfGenerator.addKeyValueRow(getTranNoLink("web","service",sWebLanguage),getTranNoLink("service",appointment.getServiceUid(),sWebLanguage));
	   try{
		   pdfGenerator.addKeyValueRow(getTranNoLink("web","user",sWebLanguage),MedwanQuery.getInstance().getUserName(Integer.parseInt(appointment.getUserUID())));
	   }
	   catch(Exception u){
		   u.printStackTrace();
	   }
       String s = "";
       if(appointment.getContact()!=null && appointment.getContact().getObjectUid()!=null){
	       if(MedwanQuery.getInstance().getConfigInt("enableCCBRT",0)==1){
		       Prestation prestation = Prestation.get(appointment.getContact().getObjectUid());
		       if(prestation!=null){
		    	   s=prestation.getDescription();
		       }
	       }
	       else{
               ExaminationVO examination = MedwanQuery.getInstance().getExamination(appointment.getContact().getObjectUid(), sWebLanguage);
               if(examination!=null){
                   s = getTranNoLink("web.occup", examination.getTransactionType(), sWebLanguage);
               }
	       }
       }
	   pdfGenerator.addKeyValueRow(getTranNoLink("web","prestation",sWebLanguage),s);
	   pdfGenerator.addKeyValueRow(getTranNoLink("web","description",sWebLanguage),appointment.getDescription());
	   pdfGenerator.addKeyValueRow(getTranNoLink("planning","preparationdate",sWebLanguage),appointment.getPreparationDate());
	   pdfGenerator.addKeyValueRow(getTranNoLink("planning","admissiondate",sWebLanguage),appointment.getAdmissionDate());
	   pdfGenerator.addKeyValueRow(getTranNoLink("planning","operationdate",sWebLanguage),appointment.getOperationDate());
	   pdfGenerator.addKeyValueRow(getTranNoLink("planning","reportingplace",sWebLanguage),appointment.getReportingPlace());
	   pdfGenerator.addKeyValueRow(getTranNoLink("planning","surgeon",sWebLanguage),appointment.getSurgeon());
	   pdfGenerator.addKeyValueRow(getTranNoLink("planning","remark",sWebLanguage),appointment.getComment());
       pdfGenerator.addPrintedRow();
       
       baosPDF = pdfGenerator.generatePDFDocumentBytes(request,sAppointmentUid);

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