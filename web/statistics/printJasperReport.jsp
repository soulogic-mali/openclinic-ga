<%@page import="net.sf.jasperreports.web.util.*,be.mxs.common.util.db.*,net.admin.*,java.text.*,java.util.*,org.dom4j.io.SAXReader,org.dom4j.*,net.sf.jasperreports.export.ExporterInput"%><%@page import="be.openclinic.reporting.*,java.io.*"%><%@page import="net.sf.jasperreports.engine.*,net.sf.jasperreports.engine.export.*,net.sf.jasperreports.export.*"%><%@page errorPage="/includes/error.jsp"%><%!
	String checkString(String s){
		return s==null?"":s;
	}

	String getFieldType(Report report,String name){
		try{
		    SAXReader reader = new SAXReader(false);
			BufferedReader br = new BufferedReader(new StringReader(checkString(report.getInputxml())));
			Document document = reader.read(br);
			Element root = document.getRootElement();
			Iterator iFields = root.elementIterator();
			while(iFields.hasNext()){
				Element field = (Element)iFields.next();
				if(field.getName().equalsIgnoreCase("field") && field.elementText("name").equalsIgnoreCase(name.replaceAll("fieldname_", ""))){
					return field.elementText("type");
				}
			}
	    }
	    catch(Exception e){
	    	e.printStackTrace();
	    }
		return "";
	}
	
	String getFieldModifier(Report report,String name){
	    try{
			SAXReader reader = new SAXReader(false);
			BufferedReader br = new BufferedReader(new StringReader(checkString(report.getInputxml())));
			Document document = reader.read(br);
			Element root = document.getRootElement();
			Iterator iFields = root.elementIterator();
			while(iFields.hasNext()){
				Element field = (Element)iFields.next();
				if(field.getName().equalsIgnoreCase("field") && field.elementText("name").equalsIgnoreCase(name.replaceAll("fieldname_", ""))){
					return field.elementText("modifier");
				}
			}
	    }
	    catch(Exception e){
	    	e.printStackTrace();
	    }
		return "";
	}
	
	void addParameters(HttpServletRequest request,Report report, Map parameters, String name, String language){
		parameters.put(name.replaceAll("fieldname_", ""),checkString(request.getParameter(name)));
		if(getFieldType(report, name).equalsIgnoreCase("service")){
			Service service = Service.getService(checkString(request.getParameter(name)));	
			if(service!=null){
				parameters.put(name.replaceAll("fieldname_", "")+".name",service.getLabel(language));
				parameters.put(name.replaceAll("fieldname_", "")+".fullname",service.getFullyQualifiedName(language));
			}
		}
		else if(getFieldType(report, name).equalsIgnoreCase("patient")){
			AdminPerson person = AdminPerson.getAdminPerson(checkString(request.getParameter(name)));	
			if(person!=null){
				parameters.put(name.replaceAll("fieldname_", "")+".name",person.lastname.toUpperCase()+", "+person.firstname);
				parameters.put(name.replaceAll("fieldname_", "")+".lastname",person.lastname.toUpperCase());
				parameters.put(name.replaceAll("fieldname_", "")+".firstname",person.firstname);
				parameters.put(name.replaceAll("fieldname_", "")+".dateofbirth",person.dateOfBirth);
				parameters.put(name.replaceAll("fieldname_", "")+".gender",person.gender);
			}
		}
		else if(getFieldType(report, name).equalsIgnoreCase("date") && getFieldModifier(report, name).length()>0){
			try{
				parameters.put(name.replaceAll("fieldname_", ""),new SimpleDateFormat(getFieldModifier(report, name)).format(new SimpleDateFormat("dd/MM/yyyy").parse(checkString(request.getParameter(name)))));
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
	}
%><%
	String reportuid=checkString(request.getParameter("reportuid"));
	Report report = Report.get(reportuid);
	HashMap parameters =new HashMap();
	Enumeration ePars = request.getParameterNames();
	while(ePars.hasMoreElements()){
		String parname = (String)ePars.nextElement();
		if(parname.startsWith("fieldname_")){
			addParameters(request,report,parameters,parname,checkString(request.getParameter("language")));
		}
	}
	JasperReport jasperReport = JasperCompileManager.compileReport(new java.io.StringBufferInputStream(report.getReportxml()));
	JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, MedwanQuery.getInstance().getLongOpenclinicConnection());
    // prepare response
    if(checkString(request.getParameter("format")).equalsIgnoreCase("xls")){
        StringBuffer sbFilename = new StringBuffer();
        sbFilename.append("OpenClinicReport_").append(System.currentTimeMillis()).append(".xls");
        StringBuffer sbContentDispValue = new StringBuffer();
        sbContentDispValue.append("inline; filename=").append(sbFilename);
        response.setHeader("Cache-Control", "max-age=30");
        response.setHeader("Content-disposition", sbContentDispValue.toString());
        response.setContentType("application/ms-excel");
		JRXlsExporter exporter = new JRXlsExporter(); 
	    exporter.setParameter(JRXlsExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_ROWS, Boolean.TRUE);
	    exporter.setParameter(JRXlsExporterParameter.IS_WHITE_PAGE_BACKGROUND, Boolean.FALSE);
	    exporter.setParameter(JRXlsExporterParameter.IS_DETECT_CELL_TYPE, Boolean.TRUE);
	    exporter.setParameter(JRXlsExporterParameter.IGNORE_PAGE_MARGINS,Boolean.TRUE);
	    exporter.setParameter(JRXlsExporterParameter.MAXIMUM_ROWS_PER_SHEET,999999);
	    exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
	    exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, response.getOutputStream());
		//exporter.setExporterInput(new SimpleExporterInput(jasperPrint));
		//exporter.setExporterOutput(new SimpleOutputStreamExporterOutput(response.getOutputStream()));
		exporter.exportReport();
    }
    else if(checkString(request.getParameter("format")).equalsIgnoreCase("rtf")){
        StringBuffer sbFilename = new StringBuffer();
        sbFilename.append("OpenClinicReport_").append(System.currentTimeMillis()).append(".rtf");
        StringBuffer sbContentDispValue = new StringBuffer();
        sbContentDispValue.append("inline; filename=").append(sbFilename);
        response.setHeader("Cache-Control", "max-age=30");
        response.setHeader("Content-disposition", sbContentDispValue.toString());
        response.setContentType("application/ms-excel");
		JRRtfExporter exporter = new JRRtfExporter(); 
		exporter.setExporterInput(new SimpleExporterInput(jasperPrint));
		exporter.setExporterOutput(new SimpleWriterExporterOutput(response.getOutputStream()));
		exporter.exportReport();
    	
    }
    else if(checkString(request.getParameter("format")).equalsIgnoreCase("html")){
        StringBuffer sbFilename = new StringBuffer();
        sbFilename.append("OpenClinicReport_").append(System.currentTimeMillis()).append(".xls");
        StringBuffer sbContentDispValue = new StringBuffer();
        sbContentDispValue.append("inline; filename=").append(sbFilename);
        response.setHeader("Cache-Control", "max-age=30");
        response.setHeader("Content-disposition", sbContentDispValue.toString());
        response.setContentType("text/html");
        HtmlExporter exporterHTML = new HtmlExporter();
		SimpleExporterInput exporterInput = new SimpleExporterInput(jasperPrint);
		SimpleHtmlExporterOutput exporterOutput;
		exporterHTML.setExporterInput(exporterInput);
		exporterOutput = new SimpleHtmlExporterOutput(response.getOutputStream());
		exporterOutput.setImageHandler(new WebHtmlResourceHandler("image?image={0}"));
		exporterHTML.setExporterOutput(exporterOutput);
		
        SimpleHtmlReportConfiguration reportExportConfiguration = new SimpleHtmlReportConfiguration();
		reportExportConfiguration.setWhitePageBackground(false);
		reportExportConfiguration.setRemoveEmptySpaceBetweenRows(true);
		exporterHTML.setConfiguration(reportExportConfiguration);
		exporterHTML.exportReport();    
	}
    else if(checkString(request.getParameter("format")).equalsIgnoreCase("xml")){
        StringBuffer sbFilename = new StringBuffer();
        sbFilename.append("OpenClinicReport_").append(System.currentTimeMillis()).append(".xml");
        StringBuffer sbContentDispValue = new StringBuffer();
        sbContentDispValue.append("inline; filename=").append(sbFilename);
        response.setHeader("Cache-Control", "max-age=30");
        response.setHeader("Content-disposition", sbContentDispValue.toString());
        response.setContentType("text/xml");
    	JasperExportManager.exportReportToXmlStream(jasperPrint, response.getOutputStream());
    }
    else {
        StringBuffer sbFilename = new StringBuffer();
        sbFilename.append("OpenClinicReport_").append(System.currentTimeMillis()).append(".pdf");
        StringBuffer sbContentDispValue = new StringBuffer();
        sbContentDispValue.append("inline; filename=").append(sbFilename);
        response.setHeader("Cache-Control", "max-age=30");
        response.setHeader("Content-disposition", sbContentDispValue.toString());
        response.setContentType("application/pdf");
    	JasperExportManager.exportReportToPdfStream(jasperPrint, response.getOutputStream());
    }
%>