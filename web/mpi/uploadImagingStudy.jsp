<%@page import="java.io.File"%>
<%@page import="be.openclinic.mpi.PACS,org.hl7.fhir.r4.model.*,org.hl7.fhir.r4.model.ImagingStudy.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String studyuid = request.getParameter("studyuid");
	String seriesuid = request.getParameter("seriesuid");
	
	HashSet mpi_sequences = new HashSet();
	ImagingStudySeriesComponent series = PACS.getSeries(studyuid, seriesuid);
	if(series!=null && series.getEndpoint()!=null){
		List<Reference> sequences = series.getEndpoint();
		Iterator<Reference> iSequences = sequences.iterator();
		while(iSequences.hasNext()){
			Reference reference = iSequences.next();
			if(reference.getIdentifier()!=null && reference.getType()!=null && reference.getId()!=null && reference.getType().equalsIgnoreCase("mpi.dicom.sequence")){
				mpi_sequences.add(reference.getId());
			}
		}
	}
	
	//Now we find out which sequences exist locally
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	try {
		PreparedStatement ps = conn.prepareStatement("select * from oc_pacs where oc_pacs_studyuid=? and oc_pacs_series=?");
		ps.setString(1,studyuid);
		ps.setString(2, seriesuid);
		ResultSet rs = ps.executeQuery();
		while(rs.next()) {
			if(!mpi_sequences.contains(rs.getString("oc_pacs_sequence"))){
				String dicomfile=MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_basePath","/var/tomcat/webapps/openclinic/scan")+"/"+MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirTo","to")+"/"+rs.getString("OC_PACS_FILENAME");
				if(new File(dicomfile).exists()){
					//This file doesn't exist on the mpi-side, therefore it can be uploaded
					PreparedStatement ps2 = conn.prepareStatement("insert into oc_mpidocuments(oc_mpidocument_id,oc_mpidocument_direction,oc_mpidocument_updatetime,oc_mpidocument_url) values(?,?,?,?)");
					ps2.setString(1,studyuid+"$"+seriesuid+"$"+activePatient.adminextends.get("mpiid"));
					ps2.setString(2, "uploadDICOM");
					ps2.setTimestamp(3,new java.sql.Timestamp(new java.util.Date().getTime()));
					ps2.setString(4,dicomfile);
					ps2.execute();
					ps2.close();
				}
			}
		}
		rs.close();
		ps.close();
	}
	catch(Exception e) {
		e.printStackTrace();
	}
	conn.close();
%>