package be.openclinic.mpi;

import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;

import org.hl7.fhir.r4.model.Bundle;
import org.hl7.fhir.r4.model.ImagingStudy;
import org.hl7.fhir.r4.model.ImagingStudy.ImagingStudySeriesComponent;

import be.hapi.BundleProcessor;
import be.mxs.common.model.vo.IdentifierFactory;
import be.mxs.common.model.vo.healthrecord.ItemVO;
import be.mxs.common.model.vo.healthrecord.TransactionVO;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;
import ca.uhn.fhir.context.FhirContext;
import ca.uhn.fhir.rest.client.api.IGenericClient;
import ca.uhn.fhir.rest.client.interceptor.BasicAuthInterceptor;
import ca.uhn.fhir.rest.gclient.StringClientParam;

public class PACS {
    public static Vector<ImagingStudy> searchMPI(String mpiid){
    	Vector<ImagingStudy> studies = new Vector<ImagingStudy>();
    	try {
	    	FhirContext ctx = MedwanQuery.getInstance().getFhirContext();
	    	String url=MedwanQuery.getInstance().getConfigString("MPIFhirServerURL","http://mpi.ocf.world/openclinic/fhir");
	    	IGenericClient client = ctx.newRestfulGenericClient(url);
    		BasicAuthInterceptor auth = new BasicAuthInterceptor(MedwanQuery.getInstance().getConfigString("MPIServerLogin","changeme"),MedwanQuery.getInstance().getConfigString("MPIServerPassword","changeme"));
	    	client.registerInterceptor(auth);
	    	// Perform a search
	    	 Bundle results = client
	    	      .search()
	    	      .forResource(ImagingStudy.class)
	    	      .where(new StringClientParam("mpiid").matches().value(mpiid))
	    	      .returnBundle(Bundle.class)
	    	      .prettyPrint()
	    	      .execute();
	    	studies = BundleProcessor.extractResourcesFromBundle(results, "ImagingStudy");    
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}
    	return studies;
    }
    
    public static ImagingStudy getStudy(String studyuid,String seriesuid) {
    	ImagingStudy study = null;
    	try {
	    	FhirContext ctx = MedwanQuery.getInstance().getFhirContext();
	    	String url=MedwanQuery.getInstance().getConfigString("MPIFhirServerURL","http://mpi.ocf.world/openclinic/fhir");
	    	IGenericClient client = ctx.newRestfulGenericClient(url);
    		BasicAuthInterceptor auth = new BasicAuthInterceptor(MedwanQuery.getInstance().getConfigString("MPIServerLogin","changeme"),MedwanQuery.getInstance().getConfigString("MPIServerPassword","changeme"));
	    	client.registerInterceptor(auth);
	    	// Perform a search
	    	 Bundle results = client
	    	      .search()
	    	      .forResource(ImagingStudy.class)
	    	      .where(new StringClientParam("studyuid").matches().value(studyuid))
	    	      .where(new StringClientParam("seriesuid").matches().value(seriesuid))
	    	      .returnBundle(Bundle.class)
	    	      .prettyPrint()
	    	      .execute();
	    	Vector<ImagingStudy> studies = BundleProcessor.extractResourcesFromBundle(results, "ImagingStudy");   
	    	if(studies.size()>0) {
	    		study=studies.firstElement();
	    	}
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}
    	return study;
    }
    
    public static ImagingStudySeriesComponent getSeries(String studyuid,String seriesuid) {
    	return getSeries(getStudy(studyuid, seriesuid),seriesuid);
    }
    
    public static ImagingStudySeriesComponent getSeries(ImagingStudy study, String seriesid) {
    	if(study==null) {
    		return null;
    	}
    	try {
	    	ImagingStudySeriesComponent series = null;
	    	List<ImagingStudySeriesComponent> components = study.getSeries();
	    	Iterator<ImagingStudySeriesComponent> iComponents = components.iterator();
	    	while(iComponents.hasNext()) {
	    		ImagingStudySeriesComponent component = iComponents.next();
	    		if(component.getId().equalsIgnoreCase(seriesid)) {
	    			series=component;
	    			break;
	    		}
	    	}
	    	return series;
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}
    	return null;
    }
    
    public static TransactionVO getTransaction(ImagingStudySeriesComponent series,String studyuid) {
    	String url=MedwanQuery.getInstance().getConfigString("MPIFhirServerURL","http://mpi.ocf.world/openclinic/fhir");
    	studyuid=studyuid.replaceAll(url+"/", "").replaceAll(url, "").replaceAll("ImagingStudy/", "");
    	String seriesid=series.getId().toString().replaceAll(url+"/", "").replaceAll(url, "").replaceAll("ImagingStudySeriesComponent/", "");
    	TransactionVO transaction = new TransactionVO();
    	transaction.setCreationDate(series.getStarted());
    	transaction.setTransactionType("be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_PACS");
    	transaction.setUpdateUser("mpi");
    	transaction.setStatus(1);
    	transaction.setTimestamp(series.getStarted());
    	transaction.setServerId(-1);
    	transaction.setTransactionId(-1);
    	transaction.setUpdateTime(series.getStarted());
    	transaction.setVersion(1);
    	transaction.setUid(seriesid);
    	transaction.setItems(new Vector<ItemVO>());
        transaction.getItems().add( new ItemVO(  new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier() ),
        		"be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID",
        		studyuid,
                new Date(),
                null));
        transaction.getItems().add( new ItemVO(  new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier() ),
        		"be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID",
        		seriesid,
                new Date(),
                null));
        transaction.getItems().add( new ItemVO(  new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier() ),
        		"be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYDATE",
        		ScreenHelper.formatDate(series.getStarted()),
                new Date(),
                null));
        transaction.getItems().add( new ItemVO(  new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier() ),
        		"be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_MODALITY",
        		series.getModality().getDisplay(),
                new Date(),
                null));
        transaction.getItems().add( new ItemVO(  new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier() ),
        		"be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYDESCRIPTION",
        		series.getDescription(),
                new Date(),
                null));

    	return transaction;
    }
}
