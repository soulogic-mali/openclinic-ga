<%@page import="be.mxs.webapp.wl.session.*,be.dpms.medwan.webapp.wo.common.system.*,be.mxs.common.util.pdf.general.*,be.mxs.common.util.pdf.*,java.io.*,be.dpms.medwan.common.model.vo.authentication.*,be.mxs.common.model.vo.*,be.mxs.common.model.vo.healthrecord.*,be.mxs.common.model.vo.healthrecord.util.*,java.sql.*,java.text.*,java.util.*,org.dom4j.*,be.mxs.common.util.system.*,net.admin.*,be.mxs.common.util.db.*"%><%@include file="/includes/helper.jsp"%><%
	String docuid=com.itextpdf.xmp.impl.Base64.decode(request.getParameter("docuid"));
	Map<String,String> pars = new TreeMap<String,String>();
	for(int n=0;n<docuid.split("\\&").length;n++){
		pars.put(docuid.split("\\&")[n].split("=")[0], docuid.split("\\&")[n].split("=")[1]);
	}
	String key = ScreenHelper.checkString(pars.get("key"));
	String natreg = ScreenHelper.checkString(pars.get("natreg"));
	String personid = ScreenHelper.checkString(pars.get("personid"));
	String language = ScreenHelper.checkString(pars.get("language"));
	String documentuid = ScreenHelper.checkString(pars.get("documentuid"));

	AdminPerson person = null;
	Vector<String> errors = new Vector<String>();
	Vector<String> warnings = new Vector<String>();
	if(key.length()==0 || MedwanQuery.getInstance().getConfigInt("restKey."+key,0)==0){
		errors.add("InvalidKey");
	}
	if(natreg.length()==0 && personid.length()==0){
		errors.add("MissingPatientIdentification");
	}
	if(personid.length()>0){
		person = AdminPerson.getAdminPerson(personid);
		if(!person.isNotEmpty()){
			errors.add("InvalidPersonId");
		}
	}
	if(natreg.length()>0){
		String pid = AdminPerson.getPersonIdByNatReg(natreg);
		if(pid==null || (personid.length()>0 && !pid.equalsIgnoreCase(personid))){
			errors.add("InvalidNatreg");
		}
		else{
			personid=pid;
		}
	}
	if(documentuid.length()==0){
		errors.add("MissingDocumentUid");
	}
	if(language.length()==0){
		errors.add("MissingLanguage");
	}
	
	if(errors.size()>0){
		org.dom4j.Document document = DocumentHelper.createDocument();
		for(int n=0;n<errors.size();n++){
			document.addElement("error").setText(errors.elementAt(n));
		}
		out.println(document.asXML());
	}
	else{
		//We gaan de PDF voor deze transaction afdrukken
        ByteArrayOutputStream origBaos = null;
        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request, SessionContainerWO.class.getName());
        GeneralPDFCreator pdfCreator = new GeneralPDFCreator(sessionContainerWO, User.get(MedwanQuery.getInstance().getConfigInt("restKey."+key,0)), AdminPerson.getAdminPerson(personid),SH.cs("defaultProject","oc"), "projects/"+SH.cs("defaultProject","oc"), null, null, language);
        origBaos = pdfCreator.generatePDFDocumentBytes(request, application, documentuid);
        // prevent caching
        response.setHeader("Expires","Sat, 6 May 1995 12:00:00 GMT");
        response.setHeader("Cache-Control","Cache=0, must-revalidate");
        response.addHeader("Cache-Control","post-check=0, pre-check=0");
        response.setContentType("application/pdf");

        String sFileName = "filename_"+System.currentTimeMillis()+".pdf";
        response.setHeader("Content-disposition","inline; filename="+sFileName);
        response.setContentLength(origBaos.size());

        ServletOutputStream sos = response.getOutputStream();
        origBaos.writeTo(sos);
        sos.flush();
	}
%>