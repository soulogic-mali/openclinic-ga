<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%@page import="java.io.ByteArrayOutputStream,
                java.io.PrintWriter,
                com.itextpdf.text.*,
                com.itextpdf.text.pdf.*,
                be.mxs.common.util.pdf.general.dossierCreators.MedicalDossierPDFCreator,
                be.mxs.common.util.pdf.general.GeneralPDFCreator,
                be.mxs.common.util.system.Picture,
                be.openclinic.medical.ReasonForEncounter,be.mxs.common.util.pdf.PDFCreator"%>
<%@page import="be.openclinic.finance.Insurance"%>
<%@page import="org.dom4j.DocumentHelper"%>
<%@page import="org.apache.commons.io.IOUtils,be.mxs.common.util.system.*"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileOutputStream"%>
<%!
    //--- ADD FOOTER TO PDF -----------------------------------------------------------------------
    // Like PDFFooter-class but with total pagecount
    public ByteArrayOutputStream addFooterToPdf(ByteArrayOutputStream origBaos, HttpSession session) throws Exception {
	    com.itextpdf.text.pdf.PdfReader reader = new com.itextpdf.text.pdf.PdfReader(origBaos.toByteArray());
	    int totalPageCount = reader.getNumberOfPages(); 
	    
	    ByteArrayOutputStream newBaos = new ByteArrayOutputStream();
	    com.itextpdf.text.Document document = new com.itextpdf.text.Document();
	    com.itextpdf.text.pdf.PdfCopy copy = new com.itextpdf.text.pdf.PdfCopy(document,newBaos);
	    document.open();
	
	    String sProject = checkString((String)session.getAttribute("activeProjectTitle")).toLowerCase();
	    String sFooterText = MedwanQuery.getInstance().getConfigString("footer."+sProject,"OpenClinic pdf engine (c)2007-"+new SimpleDateFormat("yyyy").format(new java.util.Date())+", Post-Factum bvba");
	    
	    // Loop over the pages of the baos
	    com.itextpdf.text.pdf.PdfImportedPage pdfPage;
	    com.itextpdf.text.pdf.PdfCopy.PageStamp stamp;
	    com.itextpdf.text.Phrase phrase;

	    int fontSizePercentage = MedwanQuery.getInstance().getConfigInt("fontSizePercentage",100);
	    com.itextpdf.text.Rectangle rect = document.getPageSize();
	    for(int i=0; i<totalPageCount;){
	    	pdfPage = copy.getImportedPage(reader,++i);
	
	        //*** add footer with page numbers ***
	        stamp = copy.createPageStamp(pdfPage);
	        
	    	// footer text
	        phrase = com.itextpdf.text.Phrase.getInstance(0,sFooterText,com.itextpdf.text.FontFactory.getFont(FontFactory.HELVETICA,Math.round((double)10*fontSizePercentage/100.0)));
            com.itextpdf.text.pdf.ColumnText.showTextAligned(stamp.getUnderContent(),1,phrase,(rect.getLeft()+rect.getRight())/2,rect.getBottom()+26,0);
	       
	        // page count
	        phrase = com.itextpdf.text.Phrase.getInstance(0,String.format("%d/%d",i,totalPageCount),com.itextpdf.text.FontFactory.getFont(FontFactory.HELVETICA,Math.round((double)10*fontSizePercentage/100.0)));
            com.itextpdf.text.pdf.ColumnText.showTextAligned(stamp.getUnderContent(),1,phrase,(rect.getLeft()+rect.getRight())/2,rect.getBottom()+18,0);        
	   
	        stamp.alterContents();	
	        copy.addPage(pdfPage);
	    }
	
	    document.close();  
	    reader.close();
	    
	    return newBaos;
    }
%>
<%
	String sAction    = checkString(request.getParameter("actionField")),
	sSelectedFilter   = checkString(request.getParameter("filter")),
	sSelectedTranCtxt = checkString(request.getParameter("selectedTranCtxt"));

    if(sAction.equals("send")){
        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName() );
        sessionContainerWO.verifyPerson(activePatient.personid);
        sessionContainerWO.verifyHealthRecord(null);
        ByteArrayOutputStream origBaos = null;
		File file1=null,file2=null;
        try{
            PDFCreator pdfCreator = new GeneralPDFCreator(sessionContainerWO, activeUser, activePatient, sAPPTITLE, sAPPDIR, null, null, sWebLanguage);
            origBaos = pdfCreator.generatePDFDocumentBytes(request, application, (sSelectedFilter.length() > 0), (sSelectedFilter.equals("select_trantypes_recent") ? 0 : 1));
            ByteArrayOutputStream newBaos = addFooterToPdf(origBaos,session);

            //Add the PDF document as a file
            String filebase=MedwanQuery.getInstance().getConfigString("tempDirectory", "/temp")+"/"+activePatient.personid+"."+new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new java.util.Date());
            String filename =filebase+".pdf";
            file1 = new File(filename);
			if (!file1.exists()) {
				file1.createNewFile();
			}
            FileOutputStream fos = new FileOutputStream(file1);
            newBaos.writeTo(fos);
            fos.close();
            newBaos.close();
            Vector attachments = new Vector();
            attachments.add(filename);
            
            //Add a structured XML-header as a file
            filename = filebase+".xml";
            Document document = DocumentHelper.createDocument();
            Element root = DocumentHelper.createElement("message");
            document.setRootElement(root);
            root.setAttributeValue("type", "patientid");
            if(checkString(activePatient.comment4).split("\\.").length>1){
            	root.setAttributeValue("receiverpersonids", activePatient.comment4);
            }
            if(checkString(activePatient.getID("natreg")).length()>0){
            	root.setAttributeValue("natreg", activePatient.getID("natreg"));
            }
            root.setAttributeValue("senderpersonid", MedwanQuery.getInstance().getConfigString("datacenterSMTPFrom")+":"+checkString(activePatient.personid));
            root.setAttributeValue("sendername", HTMLEntities.xmlencode(getTranNoLink("web","hospitalname",sWebLanguage)));
            String insurancenumber = "";
            Vector insurances = Insurance.getCurrentInsurances(activePatient.personid);
            for(int n=0;n<insurances.size();n++){
            	Insurance insurance = (Insurance)insurances.elementAt(n);
            	if(insurance.getInsurarUid().equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("referenceInsurerUid",""))){
            		insurancenumber=insurance.getInsuranceNr();
            		break;
            	}
            }
            root.setAttributeValue("insurancenumber", insurancenumber);
           	Element sender = root.addElement("sender");
           	sender.addElement("email").setText(MedwanQuery.getInstance().getConfigString("datacenterSMTPFrom",""));
           	sender.addElement("name").setText(HTMLEntities.xmlencode(getTranNoLink("web","hospitalname",sWebLanguage)));
           	
           	Element doc = root.addElement("document");
           	TransactionVO transaction = MedwanQuery.getInstance().loadTransaction(Integer.parseInt(request.getParameter("tranAndServerID_1").split("_")[1]), Integer.parseInt(request.getParameter("tranAndServerID_1").split("_")[0]));
           	doc.setText(HTMLEntities.xmlencode(getTranNoLink("web.occup",transaction.getTransactionType(),sWebLanguage)+" "+getTranNoLink("web","hospitalname",sWebLanguage)));
           	Element patient = activePatient.toXmlElement();
           	root.add(patient);
           	
    		PrintWriter writer = new PrintWriter(filename);
    		writer.write(document.asXML());
    		writer.close();
    		
    		file2 = new File(filename);
            attachments.add(filename);
            
			Mail.sendMail(MedwanQuery.getInstance().getConfigString("PatientEdit.MailServer"), 
					MedwanQuery.getInstance().getConfigString("SA.MailAddress"), 
					request.getParameter("destination"), 
					getTranNoLink("web","sendMedicalRecord",sWebLanguage), 
					"ID: "+activePatient.personid,
					attachments);
			if(checkString(request.getParameter("destination2")).length()>0){
				Mail.sendMail(MedwanQuery.getInstance().getConfigString("PatientEdit.MailServer"), 
						MedwanQuery.getInstance().getConfigString("SA.MailAddress"), 
						request.getParameter("destination2"), 
						getTranNoLink("web","sendMedicalRecord",sWebLanguage), 
						"ID: "+activePatient.personid,
						attachments);
			}
			file1.delete();
			file2.delete();
			%>
			<script>
				alert('<%=getTranNoLink("web","record.successfully.sent",sWebLanguage)+" "+request.getParameter("destination")%>');
				window.close();
			</script>
			<%
			out.flush();
        }
        catch(Exception e){
        	try{
    			file1.delete();
    			file2.delete();
        	}
        	catch(Exception f){
        		f.printStackTrace();
        	}
            Debug.printStackTrace(e);
            %>
				<script>
					alert('<%=getTranNoLink("web","error.sending.record",sWebLanguage)+" "+request.getParameter("destination")+" ("+e.getMessage()+")"%>');
					window.close();
				</script>
			<%
        }
        finally{
            if(origBaos!=null) origBaos.reset();
        }
    }
%>