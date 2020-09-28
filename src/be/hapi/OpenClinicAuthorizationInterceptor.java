package be.hapi;

import java.io.IOException;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.itextpdf.xmp.impl.Base64;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;
import ca.uhn.fhir.rest.api.server.RequestDetails;
import ca.uhn.fhir.rest.server.exceptions.AuthenticationException;
import ca.uhn.fhir.rest.server.interceptor.auth.AuthorizationInterceptor;
import ca.uhn.fhir.rest.server.interceptor.auth.IAuthRule;
import ca.uhn.fhir.rest.server.interceptor.auth.RuleBuilder;
import net.admin.User;

@SuppressWarnings("ConstantConditions")
public class OpenClinicAuthorizationInterceptor extends AuthorizationInterceptor {

	   @Override
	   public List<IAuthRule> buildRuleList(RequestDetails theRequestDetails) {
		    if(MedwanQuery.getInstance().getConfigInt("enableFHIRAuthentication",1)==0) {
		    	return new RuleBuilder().allowAll().build();
		    }
			String authHeader = theRequestDetails.getHeader("Authorization");
		    if(authHeader==null || authHeader.split(" ")[1].length()<2 || Base64.decode(authHeader.split(" ")[1]).split(":").length<2) {
		    	throw new AuthenticationException("[E-KHIN.01] Missing or invalid Authorization header value");
		    }
		    else {
			    String headervalue = Base64.decode(authHeader.split(" ")[1]);
		    	String username = headervalue.split(":")[0];
		    	int userid = User.getUseridByAlias(username);
		    	if(userid<0) {
		    		try {
		    			userid = Integer.parseInt(username);
		    		}
		    		catch(Exception e) {
				    	throw new AuthenticationException("[E-KHIN.01] Missing or invalid Authorization header value");
		    		}
		    	}
		    	String password = headervalue.split(":")[1];
				if(User.validate(userid+"", password)){
			    	User user = User.get(userid);
					if(user!=null && user.userid.length()>0 && User.hasPermission(user.userid,ScreenHelper.getSQLDate(new java.util.Date()))){
						if(user.getAccessRight("mpi.api.select")) {
							MedwanQuery.getInstance().reloadConfigValues();
							MedwanQuery.getInstance().reloadLabels();
							return new RuleBuilder().allowAll().build();
						}
						else {
					    	throw new AuthenticationException("[E-KHIN.03] User has no API access rights");
						}
					}
					else {
				    	throw new AuthenticationException("[E-KHIN.02] Invalid user");
					}
				}
				else {
			    	throw new AuthenticationException("[E-KHIN.01] Missing or invalid Authorization header value");
				}
		    }
	   }
}
