package be.hapi;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import javax.servlet.ServletException;

import be.mxs.common.util.db.MedwanQuery;
import ca.uhn.fhir.context.FhirContext;
import ca.uhn.fhir.rest.server.IResourceProvider;
import ca.uhn.fhir.rest.server.RestfulServer;
import ca.uhn.fhir.rest.server.interceptor.ResponseHighlighterInterceptor;

public class RestfulServlet extends RestfulServer{
	private static final long serialVersionUID = 1L;
	
	public RestfulServlet () {
		super(FhirContext.forR4());
	}
	
	@Override
	protected String createPoweredByHeader() {
		  StringBuilder b = new StringBuilder();
		  b.append("<img height='16px' src='"+getServletContext().getContextPath()+"/_img/icons/khinfavicon-32x32.png'/> OpenClinic GA");
		  b.append(" ");
    	  String sUpdateVersion = ""+MedwanQuery.getInstance().getConfigInt("updateVersion",0);
    	  String sMajor = sUpdateVersion.substring(0,1),
    		   sMinor = sUpdateVersion.substring(1,sUpdateVersion.length()-3), 
    		   sBug   = sUpdateVersion.substring(sUpdateVersion.length()-3);  
       	  if(sMinor.startsWith("0")) sMinor = sMinor.substring(1);  
      	  if(sBug.startsWith("0")) sBug = sBug.substring(1);
      	  sUpdateVersion = sMajor+"."+sMinor+"."+sBug;
          String version = "v" + sUpdateVersion;
		  b.append(version);
		  b.append(" ");
		  b.append("Master Patient Index server");
		  b.append(" (");
		  List<String> poweredByAttributes = createPoweredByAttributes();
		  for (ListIterator<String> iter = poweredByAttributes.listIterator(); iter.hasNext(); ) {
		    if (iter.nextIndex() > 0) {
		      b.append("; ");
		    }
		    b.append(iter.next());
		  }
		  b.append(")");
		  return b.toString();
	}
	
	@Override
	protected void initialize() throws ServletException {
	    /*
	     * The servlet defines any number of resource providers, and
	     * configures itself to use them by calling
	     * setResourceProviders()
	     */
	    List<IResourceProvider> resourceProviders = new ArrayList<IResourceProvider>();
	    resourceProviders.add(new RestfulPatientResourceProvider());
	    resourceProviders.add(new RestfulImagingStudyResourceProvider());
	    resourceProviders.add(new RestfulServiceRequestResourceProvider());
	    setResourceProviders(resourceProviders);
	    
		/*
		 * Use nice coloured HTML when a browser is used to request the content
		 */		
		registerInterceptor(new ResponseHighlighterInterceptor());
		/*
		 * Use authentication check by OpenClinic
		 */		
		registerInterceptor(new OpenClinicAuthorizationInterceptor());
		
	}

}
