package be.mayele.bi;

import java.sql.*;

import javax.servlet.http.HttpServletRequest;
import org.dom4j.Element;

import be.mayele.MayeleAPI;
import be.mayele.Module;
import be.mxs.common.model.vo.healthrecord.ICPCCode;
import be.mxs.common.util.db.MedwanQuery;
import be.openclinic.system.SH;
import java.util.Vector;

/* Parameters
bi.nom      - idtype        = ICD10,ICD11,ICPC2,ATC,RXNORM,LOINC,NNPB,ZIP
            - id
            - lang
            - keywords
*/

public class nom extends Module{
	public void process(HttpServletRequest request, Element root) {
		String idtype 	= SH.p(request, "idtype");
		String id 		= SH.p(request, "id");
		String lang 	= SH.p(request, "lang");
		String keywords = SH.p(request, "keywords").replaceAll(",", " ");
		
		//First check for parameter errors
		if(idtype.length()==0) {
			MayeleAPI.error(root, "BI-NOM.E003", "idtype is mandatory");
			return;
		}
		if(lang.length()>0 && "*fr*en*".indexOf("*"+lang.toLowerCase()+"*")<0) {
			MayeleAPI.error(root, "BI-NOM.E004", "unsupported lang: "+lang);
			return;
		}
		if(lang.length()==0) {
			MayeleAPI.error(root, "BI-NOM.E007", "lang is mandatory");
			return;
		}
		
		//No errors detected, execute query
		if(idtype.contains("icpc2")) {
			Vector codes = MedwanQuery.getInstance().findICPCCodes(id+" "+keywords, lang);
			int maxrecords = 100,count=0;
			if(SH.p(request, "records").length()>0) {
				maxrecords=Integer.parseInt(SH.p(request, "records"));
			}
			for(int n=0;n<codes.size() && n<maxrecords;n++) {
				ICPCCode code = (ICPCCode)codes.elementAt(n);
				Element nom = root.addElement("record");
				nom.addAttribute("idtype", "icpc2");
				nom.addAttribute("id", code.code);
				nom.addElement("lang").setText(lang);
				nom.addElement("label").addCDATA(code.label);
			}
		}
		if(idtype.contains("icd10")) {
			Vector codes = MedwanQuery.getInstance().findICD10Codes(id+" "+keywords, lang);
			int maxrecords = 100,count=0;
			if(SH.p(request, "records").length()>0) {
				maxrecords=Integer.parseInt(SH.p(request, "records"));
			}
			for(int n=0;n<codes.size() && n<maxrecords;n++) {
				ICPCCode code = (ICPCCode)codes.elementAt(n);
				Element nom = root.addElement("record");
				nom.addAttribute("idtype", "icd10");
				nom.addAttribute("id", code.code);
				nom.addElement("lang").setText(lang);
				nom.addElement("label").addCDATA(code.label);
			}
		}
	}
}
