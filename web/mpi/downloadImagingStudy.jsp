<%@page import="java.io.File"%>
<%@page import="be.openclinic.mpi.PACS,org.hl7.fhir.r4.model.*,org.hl7.fhir.r4.model.ImagingStudy.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String studyuid = request.getParameter("studyuid");
	String seriesuid = request.getParameter("seriesuid");
	
	HashSet local_sequences = new HashSet();
	//First we find out which sequences exist locally
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	try {
		PreparedStatement ps = conn.prepareStatement("select * from oc_pacs where oc_pacs_studyuid=? and oc_pacs_series=?");
		ps.setString(1,studyuid);
		ps.setString(2, seriesuid);
		ResultSet rs = ps.executeQuery();
		while(rs.next()) {
			local_sequences.add(rs.getString("oc_pacs_sequence"));
		}
		rs.close();
		ps.close();
	}
	catch(Exception e) {
		e.printStackTrace();
	}
	conn.close();
	ImagingStudySeriesComponent seriesComponent = PACS.getSeries(studyuid, seriesuid);
	if(seriesComponent!=null && seriesComponent.getEndpoint()!=null){
		List<Reference> sequencesList = seriesComponent.getEndpoint();
		Iterator<Reference> iSequences = sequencesList.iterator();
		while(iSequences.hasNext()){
			Reference reference = iSequences.next();
			if(reference.getId()!=null && reference.getType()!=null && reference.getType().equalsIgnoreCase("mpi.dicom.wado")){
				//Now we've got the WADO query for retrieving the list of downloadable files
				String wadoQuery = reference.getId();
		        SAXReader reader = new SAXReader(false);
		        Document document = reader.read(new URL(wadoQuery));
				Element root = document.getRootElement();
				String wadoURL = root.attributeValue("wadoURL");
				Element patient = root.element("Patient");
				Iterator<Element> studies = patient.elementIterator("Study");
				while(studies.hasNext()){
					Element study = studies.next();
					if(study.attributeValue("StudyInstanceUID").equalsIgnoreCase(studyuid)){
						//This is the study we searched for
						Element series = study.element("Series");
						//Now run through all image instances (sequences) of the series
						Iterator<Element> sequences = series.elementIterator("Instance");
						while(sequences.hasNext()){
							Element sequence = sequences.next();
							if(!local_sequences.contains(sequence.attributeValue("InstanceNumber"))){
								//This file doesn't yet exist on the local server, so put it in the download queue
								String fileURL = wadoURL+sequence.attributeValue("DirectDownloadFile");
								PreparedStatement ps2 = conn.prepareStatement("insert into oc_mpidocuments(oc_mpidocument_id,oc_mpidocument_direction,oc_mpidocument_updatetime,oc_mpidocument_url) values(?,?,?,?)");
								ps2.setString(1,studyuid+"$"+seriesuid+"$"+activePatient.adminextends.get("mpiid"));
								ps2.setString(2, "downloadDICOM");
								ps2.setTimestamp(3,new java.sql.Timestamp(new java.util.Date().getTime()));
								ps2.setString(4,fileURL);
								ps2.execute();
								ps2.close();
							}
						}
					}
				}
			}
		}
	}
	
	
%>