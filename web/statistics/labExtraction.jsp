<%@page import="be.openclinic.medical.LabAnalysis"%>
<%@page import="org.apache.commons.codec.digest.DigestUtils"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/helper.jsp"%>
<%
session.removeAttribute("dataExtractResult");
try{
	String delimiter=MedwanQuery.getInstance().getConfigString("labExportSeparator","{tab}").replaceAll("\\{tab\\}","\t"), endofline="\r\n";
	java.util.Date dBegin = ScreenHelper.parseDate(request.getParameter("start"));
	java.util.Date dEnd = ScreenHelper.parseDate(request.getParameter("end"));
	String sWebLanguage = ScreenHelper.checkString(request.getParameter("language"),"fr");
    response.setContentType("application/octet-stream");
    response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicLabExtract."+MedwanQuery.getInstance().getConfigString("defaultProject","OC")+"." + new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date()) + ".txt\"");
    ServletOutputStream os = response.getOutputStream();
    StringBuffer sOutput = new StringBuffer();
    //Header
    sOutput.append("PatientID"+delimiter);
    sOutput.append("SampleID"+delimiter);
    sOutput.append("SampleOriginLocation"+delimiter);
    sOutput.append("TestPriority"+delimiter);
    sOutput.append("TestOrderedDateTime"+delimiter);
    sOutput.append("TestSiteSampleReceivedDateTime"+delimiter);
    sOutput.append("TestDepartment"+delimiter);
    sOutput.append("SampleFluidType"+delimiter);
    sOutput.append("TestInstrument"+delimiter);
    sOutput.append("TestLISCode"+delimiter);
    sOutput.append("TestLISName"+delimiter);
    sOutput.append("TestResultFirstReviewedDateTime"+delimiter);
    sOutput.append("TestResultReleasedDateTime"+delimiter);
    sOutput.append("TestSite"+delimiter);
    sOutput.append("TestType"+delimiter);
    sOutput.append("TestAnalyzerCompletionDateTime"+endofline); //result received from analyzer
    
    String sQuery="select * from requestedlabanalyses where resultdate >=? and resultdate<? and resultvalue is not null and resultvalue<>'' order by resultdate";
    Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    PreparedStatement ps = conn.prepareStatement(sQuery);
    ps.setDate(1,new java.sql.Date(dBegin.getTime()));
    ps.setDate(2,new java.sql.Date(dEnd.getTime()));
    ResultSet rs = ps.executeQuery();
    int 	missingPatientID=0,
    		missingSampleID=0,
    		missingSampleOriginLocation=0,
    		missingSampleFluidType=0,
    		missingTestLISCode=0,
    		missingTestLISName=0,
    		missingTestPriority=0,
    		missingTestDepartment=0,
    		missingTestInstrument=0,
    		missingTestSite=0,
    		missingTestType=0,
    		missingTestAnalyzerCompletionDateTime=0,
    		missingTestSiteSampleReceivedDateTime=0,
    		missingTestOrderedDateTime=0,
    		missingTestResultFirstReviewedDateTime=0,
    		missingTestResultReleasedDateTime=0;
    int counter=0;
    while(rs.next()){
    	LabAnalysis analysis = LabAnalysis.getLabAnalysisByLabcode(rs.getString("analysiscode"));
    	if(analysis!=null){
        	counter++;
    		boolean bCanWrite=true;
    		StringBuffer sLine=new StringBuffer();
    		TransactionVO transaction = MedwanQuery.getInstance().loadTransaction(rs.getInt("serverid"), rs.getInt("transactionId"));
    		if(transaction==null){
    			continue;
    		}
	    	sLine.append(DigestUtils.sha256Hex(rs.getString("patientid"))+delimiter);
	    	if(rs.getString("patientid").length()==0){missingPatientID++;bCanWrite=false;};
	    	sLine.append(DigestUtils.sha256Hex(rs.getString("transactionid")+"."+analysis.getMonster())+delimiter);
	    	if(rs.getString("transactionid").length()==0){missingSampleID++;bCanWrite=false;};
	    	String sLocation="LAB";
	    	String sampler = checkString(rs.getString("sampler"));
	    	if(sampler.length()>0){
	    		try{
	    			User user = User.get(Integer.parseInt(sampler));
	    			sLocation=user.getParameter("defaultserviceid");
	    		}
	    		catch(Exception e){}
	    	}
	    	sLine.append(sLocation.toLowerCase()+delimiter);
	    	String sPriority="Normal";
	    	if(";Routine;Urgent;".contains(";"+transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_URGENCY")+";")){
	    		sPriority=transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_URGENCY");
	    	}
	    	sLine.append(sPriority.toLowerCase()+delimiter);
	    	sLine.append(new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(transaction.getCreationDate())+delimiter);
	    	if(rs.getTimestamp("samplereceptiondatetime")==null){
	    		missingTestSiteSampleReceivedDateTime++;
	    		bCanWrite=false;
	    	}
	    	else{
	    		sLine.append(new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(rs.getTimestamp("samplereceptiondatetime"))+delimiter);
	    	}
	    	if(analysis.getSection().startsWith("Cho")){missingTestDepartment++;};
	    	sLine.append((analysis.getSection().startsWith("Cho")?"":getTranNoLink("labanalysis.section",analysis.getSection(),sWebLanguage))+delimiter);
	    	if(SH.c(analysis.getMonster()).length()==0){missingSampleFluidType++;};
	    	sLine.append(getTranNoLink("labanalysis.monster",analysis.getMonster(),sWebLanguage).toLowerCase()+delimiter);
			if(!checkString(rs.getString("Comment")).startsWith("###")){missingTestInstrument++;};
	    	sLine.append((checkString(rs.getString("Comment")).startsWith("###")?rs.getString("Comment").replaceAll("###", ""):"")+delimiter);
	    	String analysercode=analysis.getLabcode();
			if(MedwanQuery.getInstance().getConfigString("labanalysercodemapping","loinc").equalsIgnoreCase("loinc") && ScreenHelper.checkString(analysis.getMedidoccode()).length()>0) {
				analysercode = analysis.getMedidoccode();
			}
			if(analysercode.length()==0){missingTestLISCode++;bCanWrite=false;};
	    	sLine.append(analysercode+delimiter);
	    	if(getTranNoLink("labanalysis",analysis.getLabId()+"",sWebLanguage).length()==0){missingTestLISName++;};
	    	sLine.append(getTranNoLink("labanalysis",analysis.getLabId()+"",sWebLanguage)+delimiter);
	    	if(rs.getTimestamp("technicalvalidationdatetime")==null){missingTestResultFirstReviewedDateTime++;};
	    	sLine.append((rs.getTimestamp("technicalvalidationdatetime")==null?"":new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(rs.getTimestamp("technicalvalidationdatetime")))+delimiter);
	    	if(rs.getTimestamp("finalvalidationdatetime")==null){missingTestResultReleasedDateTime++;};
	    	sLine.append((rs.getTimestamp("finalvalidationdatetime")==null?"":new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(rs.getTimestamp("finalvalidationdatetime")))+delimiter);
	    	if(MedwanQuery.getInstance().getConfigString("defaultProject","?").equalsIgnoreCase("?")){missingTestSite++;};
	    	sLine.append(MedwanQuery.getInstance().getConfigString("defaultProject","?")+delimiter);
			if(SH.c(analysis.getLabgroup()).length()==0){missingTestType++;};
	    	sLine.append(getTranNoLink("labanalysis.section",analysis.getLabgroup(),sWebLanguage)+delimiter);
	    	if(rs.getTimestamp("resultdate")==null){missingTestAnalyzerCompletionDateTime++;};
	    	sLine.append((rs.getTimestamp("resultdate")==null?"":new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(rs.getTimestamp("resultdate")))+endofline);
	    	if(rs.getTimestamp("technicalvalidationdatetime")==null && rs.getTimestamp("finalvalidationdatetime")==null){
	    		bCanWrite=false;
	    	}
	    	//Add line to output (the whole line or nothing)
	    	if(bCanWrite){
	    		sOutput.append(sLine);
	    	}
    	}
    	if(counter % 100 ==0){
    	    byte[] b = sOutput.toString().getBytes();
    	    for (int n=0;n<b.length;n++) {
    	        os.write(b[n]);
    	    }
    	    os.flush();
    	    sOutput=new StringBuffer();
    	}
    }
    rs.close();
    ps.close();
    conn.close();
	if(sOutput.length()>0){
	    byte[] b = sOutput.toString().getBytes();
	    for (int n=0;n<b.length;n++) {
	        os.write(b[n]);
	    }
	    os.flush();
	    os.close();
	}
	String sResult = "missingPatientID="+missingPatientID+
	";missingSampleID="+missingSampleID+
	";missingSampleOriginLocation="+missingSampleOriginLocation+
	";missingSampleFluidType="+missingSampleFluidType+
	";missingTestLISCode="+missingTestLISCode+
	";missingTestLISName="+missingTestLISName+
	";missingTestPriority="+missingTestPriority+
	";missingTestDepartment="+missingTestDepartment+
	";missingTestInstrument="+missingTestInstrument+
	";missingTestSite="+missingTestSite+
	";missingTestType="+missingTestType+
	";missingTestAnalyzerCompletionDateTime="+missingTestAnalyzerCompletionDateTime+
	";missingTestSiteSampleReceivedDateTime="+missingTestSiteSampleReceivedDateTime+
	";missingTestOrderedDateTime="+missingTestOrderedDateTime+
	";missingTestResultFirstReviewedDateTime="+missingTestResultFirstReviewedDateTime+
	";missingTestResultReleasedDateTime="+missingTestResultReleasedDateTime+
	";totalRecords="+counter;
	session.setAttribute("dataExtractResult", sResult);
}
catch(Exception ex){
	ex.printStackTrace();
}
%>