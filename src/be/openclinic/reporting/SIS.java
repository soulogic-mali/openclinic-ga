package be.openclinic.reporting;

import javax.xml.ws.Service;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.ScreenHelper;
import net.admin.AdminPerson;
import pe.gob.sis.ResultQueryAsegurado;
import pe.gob.sis.Service1;
import pe.gob.sis.Service1Soap;
import pe.gob.sis.ServiceProduction;

public class SIS {

	public static ResultQueryAsegurado getAffiliationInformation(int personid){
		AdminPerson person = AdminPerson.getAdminPerson(personid+"");
		Service service = null;
		Service1Soap soap = null;
		if(MedwanQuery.getInstance().getConfigInt("enableSISProduction",0)==1) {
			Debug.println("Using SIS production environment");
			service = new ServiceProduction();
			soap=((ServiceProduction)service).getService1Soap();
		} else {
			Debug.println("Using SIS test environment");
			service = new Service1();
			soap=((Service1)service).getService1Soap();
		}
		String autorization = soap.getSession(MedwanQuery.getInstance().getConfigString("sis.username","OPENCLINIC"), MedwanQuery.getInstance().getConfigString("sis.password","123456"));
		Debug.println("SIS communication session authorization key = "+autorization);
		try{
			autorization = Long.parseLong(autorization)+"";
		}
		catch(Exception e){
			autorization="0";
		}
		ResultQueryAsegurado r = soap.consultarAfiliadoFuaE(1, autorization, MedwanQuery.getInstance().getConfigString("sis.senderdni","02424160"), "1", ScreenHelper.checkString(person.getID("natreg")), "", "", "", "");
		if(r.getIdError().equalsIgnoreCase("0") && !autorization.equalsIgnoreCase("0")){
			r.setResultado(autorization);
		}
		Debug.println("SIS query error = "+r.getIdError());
		Debug.println("SIS query patient insurance status = "+r.getEstado());
		return r;
	}
	
	public static ResultQueryAsegurado getAffiliationInformationFromDNI(String dni){
		Service1 service = new Service1();
		Service1Soap soap = service.getService1Soap();
		String autorization = soap.getSession(MedwanQuery.getInstance().getConfigString("sis.username","OPENCLINIC"), MedwanQuery.getInstance().getConfigString("sis.password","123456"));
		try{
			autorization = Long.parseLong(autorization)+"";
		}
		catch(Exception e){
			autorization="0";
		}
		ResultQueryAsegurado r = soap.consultarAfiliadoFuaE(1, autorization, MedwanQuery.getInstance().getConfigString("sis.senderdni","02424160"), "1", dni, "", "", "", "");
		if(!autorization.equalsIgnoreCase("0")){
			r.setResultado(autorization);
		}
		return r;
	}
	
}
