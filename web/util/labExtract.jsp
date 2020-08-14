<%@page import="org.apache.commons.codec.digest.DigestUtils"%>
<%@page import="java.io.FileOutputStream"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String delimiter="\t";
	java.io.PrintWriter writer = new java.io.PrintWriter("/tmp/labextract.csv", "UTF-8");
	writer.print("PatientID"+delimiter);
	writer.print("PatientDOB"+delimiter);
	writer.print("PatientSex"+delimiter);
	writer.print("EpisodeID"+delimiter);
	writer.print("ReqPhysicianID"+delimiter);
	writer.print("SampleID"+delimiter);
	writer.print("SampleCollectionDateTime"+delimiter);
	writer.print("TestLISCode"+delimiter);
	writer.print("TestValue"+delimiter);
	writer.print("TestNormalRange"+delimiter);
	writer.print("TestUnits"+delimiter);
	writer.print("TestSite"+delimiter);
	writer.print("TestType"+delimiter);
	writer.print("TestOrderedDateTime"+delimiter);
	writer.print("TestResultFirstReviewedDateTime"+delimiter);
	writer.print("TestResultReleasedDateTime"+"\n");
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from labextract");
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		writer.print(DigestUtils.sha256Hex(checkString(rs.getString("PatientID")))+delimiter);
		writer.print((rs.getDate("PatientDOB")==null?"":ScreenHelper.formatDate(rs.getDate("PatientDOB")))+delimiter);
		writer.print(checkString(rs.getString("PatientSex"))+delimiter);
		writer.print(DigestUtils.sha256Hex(checkString(rs.getString("EpisodeID")))+delimiter);
		writer.print(checkString(rs.getString("ReqPhysicianID"))+delimiter);
		writer.print(DigestUtils.sha256Hex(checkString(rs.getString("SampleID")))+delimiter);
		writer.print((rs.getTimestamp("SampleCollectionDateTime")==null?"":new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(rs.getTimestamp("SampleCollectionDateTime")))+delimiter);
		writer.print(checkString(rs.getString("TestLISCode"))+delimiter);
		writer.print(checkString(rs.getString("TestValue")).replaceAll(delimiter,", ").replaceAll("\n",", ")+delimiter);
		writer.print(checkString(rs.getString("TestNormalRange"))+delimiter);
		writer.print(checkString(rs.getString("TestUnits"))+delimiter);
		writer.print(checkString(rs.getString("TestSite"))+delimiter);
		writer.print(checkString(rs.getString("TestType"))+delimiter);
		writer.print((rs.getTimestamp("TestOrderedDateTime")==null?"":new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(rs.getTimestamp("TestOrderedDateTime")))+delimiter);
		writer.print((rs.getTimestamp("TestResultFirstReviewedDateTime")==null?"":new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(rs.getTimestamp("TestResultFirstReviewedDateTime")))+delimiter);
		writer.print((rs.getTimestamp("TestResultReleasedDateTime")==null?"":new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(rs.getTimestamp("TestResultReleasedDateTime")))+"\n");
		writer.flush();
	}
	rs.close();
	ps.close();
	writer.close();
	writer = new java.io.PrintWriter("/tmp/diagnosisextract.csv", "UTF-8");
	writer.print("EpisodeID"+delimiter);
	writer.print("PatientID"+delimiter);
	writer.print("DPName"+delimiter);
	writer.print("DPCode"+delimiter);
	writer.print("DPDescription"+"\n");
	ps = conn.prepareStatement("select * from diagnosisextract");
	rs = ps.executeQuery();
	while(rs.next()){
		writer.print(DigestUtils.sha256Hex(checkString(rs.getString("EpisodeID")))+delimiter);
		writer.print(DigestUtils.sha256Hex(checkString(rs.getString("PatientID")))+delimiter);
		writer.print(checkString(rs.getString("DPName"))+delimiter);
		writer.print(checkString(rs.getString("DPCode"))+delimiter);
		writer.print(checkString(rs.getString("DPDescription")).replaceAll(delimiter,", ").replaceAll("\n",", ")+"\n");
		writer.flush();
	}
	rs.close();
	ps.close();
	writer.close();
	writer = new java.io.PrintWriter("/tmp/prescriptionextract.csv", "UTF-8");
	writer.print("EpisodeID"+delimiter);
	writer.print("PatientID"+delimiter);
	writer.print("PrescriptionDrug"+delimiter);
	writer.print("PrescriptionDateTime"+"\n");
	ps = conn.prepareStatement("select * from prescriptionextract");
	rs = ps.executeQuery();
	while(rs.next()){
		writer.print(DigestUtils.sha256Hex(checkString(rs.getString("EpisodeID")))+delimiter);
		writer.print(DigestUtils.sha256Hex(checkString(rs.getString("PatientID")))+delimiter);
		writer.print(checkString(rs.getString("PrescriptionDrug")).replaceAll(delimiter,", ").replaceAll("\n",", ")+delimiter);
		writer.print((rs.getTimestamp("PrescriptionDateTime")==null?"":new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(rs.getTimestamp("PrescriptionDateTime")))+"\n");
		writer.flush();
	}
	rs.close();
	ps.close();
	conn.close();
%>