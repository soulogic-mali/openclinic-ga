package be.hapi;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hl7.fhir.r4.model.Endpoint;
import org.hl7.fhir.r4.model.Coding;
import org.hl7.fhir.r4.model.IdType;
import org.hl7.fhir.r4.model.Identifier;
import org.hl7.fhir.r4.model.ImagingStudy;
import org.hl7.fhir.r4.model.ImagingStudy.ImagingStudySeriesComponent;
import org.hl7.fhir.r4.model.Reference;

import java.io.File;
import java.sql.Connection;

import be.mxs.common.model.vo.healthrecord.TransactionVO;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.db.ObjectCache;
import be.mxs.common.util.system.ScreenHelper;
import ca.uhn.fhir.rest.annotation.Destroy;
import ca.uhn.fhir.rest.annotation.IdParam;
import ca.uhn.fhir.rest.annotation.OptionalParam;
import ca.uhn.fhir.rest.annotation.Read;
import ca.uhn.fhir.rest.annotation.RequiredParam;
import ca.uhn.fhir.rest.annotation.Search;
import ca.uhn.fhir.rest.param.StringParam;
import ca.uhn.fhir.rest.server.IResourceProvider;

public class RestfulImagingStudyResourceProvider implements IResourceProvider {

	@Override
	public Class<ImagingStudy> getResourceType() {
		return ImagingStudy.class;
	}

	@Read()
	public ImagingStudy getResourceById(@IdParam IdType theId,
										HttpServletRequest theRequest, 
										HttpServletResponse theResponse) {
		ImagingStudy study = null;
		//First find the transactions this study belongs to
		TransactionVO tran = MedwanQuery.getInstance().getTransactionForItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID", theId.getIdPart());
		if(tran!=null) {
			study = new ImagingStudy();
			String studyuid = ScreenHelper.checkString(tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID"));
			study.setId(studyuid);
			String seriesuid = ScreenHelper.checkString(tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID"));
			ImagingStudySeriesComponent seriesComponent = new ImagingStudySeriesComponent();
			study.addSeries(seriesComponent);
			seriesComponent.setId(seriesuid);
			seriesComponent.setModality(new Coding("DICOM",tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_MODALITY"),tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_MODALITY")));
			seriesComponent.setStarted(ScreenHelper.parseDate(tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYDATE")));
			seriesComponent.setDescription(tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYDESCRIPTION"));
			Reference reference = new Reference();
			reference.setType("mpi.dicom.wado");
			reference.setId((theRequest.isSecure()?"https":"http")+"://"+theRequest.getServerName()+":"+theRequest.getServerPort()+theRequest.getContextPath()+"/pacs/wadoQuery.jsp?studyuid="+studyuid+"&seriesuid="+seriesuid);
			seriesComponent.addEndpoint(reference);
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			try {
				PreparedStatement ps = conn.prepareStatement("select * from oc_pacs where oc_pacs_studyuid=? and oc_pacs_series=?");
				ps.setString(1,studyuid);
				ps.setString(2, seriesuid);
				ResultSet rs = ps.executeQuery();
				while(rs.next()) {
					String filename = rs.getString("oc_pacs_filename");
					String dicomfile=MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_basePath","/var/tomcat/webapps/openclinic/scan")+"/"+MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirTo","to")+"/"+filename;
					if(new File(dicomfile).exists()) {
						reference = new Reference();
						reference.setType("mpi.dicom.sequence");
						reference.setId(rs.getString("oc_pacs_sequence"));
						seriesComponent.addEndpoint(reference);
					}
				}
				rs.close();
				ps.close();
			}
			catch(Exception e) {
				e.printStackTrace();				
			}
			finally {
				try {
					conn.close();
				}
				catch(Exception ee) {
					ee.printStackTrace();
				}
			}
		}
		return study;
	}
	
	@Search()
	public List<ImagingStudy> getStudy(	@RequiredParam (name = "studyuid") StringParam studyuid,
									@OptionalParam (name = "seriesuid") StringParam seriesuid,
									HttpServletRequest theRequest, 
									HttpServletResponse theResponse
									) {
		Vector<ImagingStudy> studies = new Vector<ImagingStudy>();
		ImagingStudy study = null;
		//First find the transactions this study belongs to
		TransactionVO tran = MedwanQuery.getInstance().getTransactionForItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID", studyuid.getValue());
		if(tran!=null) {
			String seriesvalue=seriesuid==null?ScreenHelper.checkString(tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID")):seriesuid.getValue();
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			try {
				PreparedStatement ps = conn.prepareStatement("select * from oc_pacs where oc_pacs_studyuid=? and oc_pacs_series=?");
				ps.setString(1,studyuid.getValue());
				ps.setString(2, seriesvalue);
				ResultSet rs = ps.executeQuery();
				if(rs.next()) {
					rs.close();
					ps.close();
					study = new ImagingStudy();
					study.setId(studyuid.getValue());
					ImagingStudySeriesComponent seriesComponent = new ImagingStudySeriesComponent();
					study.addSeries(seriesComponent);
					seriesComponent.setId(seriesvalue);
					seriesComponent.setModality(new Coding("DICOM",tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_MODALITY"),tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_MODALITY")));
					seriesComponent.setStarted(ScreenHelper.parseDate(tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYDATE")));
					seriesComponent.setDescription(tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYDESCRIPTION"));
					Reference reference = new Reference();
					reference.setType("mpi.dicom.wado");
					reference.setId((theRequest.isSecure()?"https":"http")+"://"+theRequest.getServerName()+":"+theRequest.getServerPort()+theRequest.getContextPath()+"/pacs/wadoQuery.jsp?studyuid="+studyuid.getValue()+"&seriesuid="+seriesvalue);
					seriesComponent.addEndpoint(reference);
					ps = conn.prepareStatement("select * from oc_pacs where oc_pacs_studyuid=? and oc_pacs_series=?");
					ps.setString(1,studyuid.getValue());
					ps.setString(2, seriesvalue);
					rs = ps.executeQuery();
					while(rs.next()) {
						String filename = rs.getString("oc_pacs_filename");
						String dicomfile=MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_basePath","/var/tomcat/webapps/openclinic/scan")+"/"+MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirTo","to")+"/"+filename;
						if(new File(dicomfile).exists()) {
							reference = new Reference();
							reference.setType("mpi.dicom.sequence");
							reference.setId(rs.getString("oc_pacs_sequence"));
							seriesComponent.addEndpoint(reference);
						}
					}
					rs.close();
					ps.close();
					studies.add(study);
				}
				else {
					rs.close();
					ps.close();
				}
			}
			catch(Exception e) {
				e.printStackTrace();				
			}
			finally {
				try {
					conn.close();
				}
				catch(Exception ee) {
					ee.printStackTrace();
				}
			}
		}
		return studies;
	}
	
	@Search()
	public List<ImagingStudy> findStudies(@RequiredParam (name = "mpiid") StringParam mpiid,
											HttpServletRequest theRequest, 
											HttpServletResponse theResponse){
		List<ImagingStudy> studies = new Vector<ImagingStudy>();
		if(mpiid!=null && !mpiid.isEmpty()) {
			Hashtable<String,ImagingStudy> is = new Hashtable<String,ImagingStudy>();
			int personid = ScreenHelper.convertFromUUID(mpiid.getValue());
			if(personid<0) {
				try {
					personid = Integer.parseInt(mpiid.getValue());
				}
				catch(Exception e) {
					System.out.println("Not a valid mpiid: "+mpiid.getValue());
				}
			}
			if(personid>-1) {
				MedwanQuery.getInstance().setObjectCache(new ObjectCache());
				Vector<TransactionVO> pacstran = MedwanQuery.getInstance().getTransactionsByType(personid, "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_PACS");
				for(int n=0;n<pacstran.size();n++) {
					TransactionVO tran = pacstran.elementAt(n);
					
					//First make sure we get the ImagingStudy object matching the transaction
					String studyuid = ScreenHelper.checkString(tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID"));
					if(is.get(studyuid)==null) {
						is.put(studyuid, new ImagingStudy());
					}
					ImagingStudy study = is.get(studyuid);
					study.setId(studyuid);
					
					//Then make sure we get the ImagingStudySeriesComponent object matching the transaction
					String seriesuid = ScreenHelper.checkString(tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID"));
					ImagingStudySeriesComponent seriesComponent = null;
					List<ImagingStudySeriesComponent> series = study.getSeries();
					Iterator<ImagingStudySeriesComponent> iSeries = series.iterator();
					while(iSeries.hasNext()) {
						ImagingStudySeriesComponent theSeries = iSeries.next();
						if(theSeries.getId().equalsIgnoreCase(seriesuid)) {
							seriesComponent = theSeries;
							break;
						}
					}
					if(seriesComponent==null) {
						seriesComponent = new ImagingStudySeriesComponent();
						study.addSeries(seriesComponent);
					}
					seriesComponent.setId(seriesuid);
					seriesComponent.setModality(new Coding("DICOM",tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_MODALITY"),tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_MODALITY")));
					seriesComponent.setStarted(ScreenHelper.parseDate(tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYDATE")));
					seriesComponent.setDescription(tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYDESCRIPTION"));
					Reference reference = new Reference();
					reference.setType("mpi.dicom.wado");
					reference.setId((theRequest.isSecure()?"https":"http")+"://"+theRequest.getServerName()+":"+theRequest.getServerPort()+theRequest.getContextPath()+"/pacs/wadoQuery.jsp?studyuid="+studyuid+"&seriesuid="+seriesuid);
					seriesComponent.addEndpoint(reference);
				}
			}
			Iterator<String> iStudies = is.keySet().iterator();
			while(iStudies.hasNext()) {
				studies.add(is.get(iStudies.next()));
			}
		}
		return studies;
	}
	
	@Destroy
	public void destroy() {
	}
}
