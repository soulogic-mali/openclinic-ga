package be.hapi;

import java.util.List;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hl7.fhir.r4.model.Coverage;
import org.hl7.fhir.r4.model.IdType;
import org.hl7.fhir.r4.model.ServiceRequest;

import be.openclinic.finance.Insurance;
import ca.uhn.fhir.rest.annotation.Create;
import ca.uhn.fhir.rest.annotation.Destroy;
import ca.uhn.fhir.rest.annotation.IdParam;
import ca.uhn.fhir.rest.annotation.OptionalParam;
import ca.uhn.fhir.rest.annotation.Read;
import ca.uhn.fhir.rest.annotation.ResourceParam;
import ca.uhn.fhir.rest.annotation.Search;
import ca.uhn.fhir.rest.annotation.Update;
import ca.uhn.fhir.rest.api.MethodOutcome;
import ca.uhn.fhir.rest.param.DateParam;
import ca.uhn.fhir.rest.param.NumberParam;
import ca.uhn.fhir.rest.server.IResourceProvider;

public class RestfulCoverageResourceProvider implements IResourceProvider {

	@Override
		public Class<Coverage> getResourceType() {
		return Coverage.class;
	}

	@Read()
	public ServiceRequest getResourceById(@IdParam IdType theId) {
		//Todo: find the Lab Order in the OpenClinic database
		//Return the ServiceRequest if it is found
		Insurance insurance = Insurance.get(theId.getIdPart());
		return null;
	}

	@Search()
	public List<ServiceRequest> findLaborders(
				@OptionalParam(name = "personid") NumberParam personid,
				@OptionalParam(name = "begindate") DateParam begindate,
				@OptionalParam(name = "enddate") DateParam enddate,
				HttpServletRequest theRequest, 
				HttpServletResponse theResponse) {
		List<ServiceRequest> laborders = new Vector<ServiceRequest>();
		if(personid!=null && personid.getValue().intValue()>0) {
		}
	    return laborders;
	}
	
	@Update
	public MethodOutcome update(@IdParam IdType theId, @ResourceParam ServiceRequest theLaborder) {
	    MethodOutcome retVal = new MethodOutcome();
	    //We first check if the lab order already exists. If it doesn't exist set an error code in retVal
	    return retVal;
	}
	
	@Create 
	public MethodOutcome createLaborder(@ResourceParam ServiceRequest theLaborder) {
	    MethodOutcome retVal = new MethodOutcome();
	    //We first check if the lab order already exists. If it already exists set an error code in retVal
	    return retVal;
	}
			
	
	@Destroy
	public void destroy() {
		//Delete the lab order
	}
	
}
