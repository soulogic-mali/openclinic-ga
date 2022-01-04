package be.mayele.bi;

import java.sql.*;

import javax.servlet.http.HttpServletRequest;
import org.dom4j.Element;

import be.mayele.MayeleAPI;
import be.mayele.Module;
import be.openclinic.system.SH;

/* Parameters
bi.ins      - uid           = lettercode+checkdigit
            - idtype        = INS (insurance number)
            - id
            - ref           = reference person (adhérent) => ins uid
            - lastname
            - firstname
            - dob           = YYYYMMDD
            - gender        = M,F
            - phone
            - insc			insurance coverage plan
            
*/

public class ins extends Module{
	public void process(HttpServletRequest request, Element root) {
		String uid 		= SH.p(request, "uid");
		String idtype 	= SH.p(request, "idtype");
		String id 		= SH.p(request, "id");
		String ref 		= SH.p(request, "ref");
		String lastname = SH.p(request, "lastname");
		String firstname= SH.p(request, "firstname");
		String dob 		= SH.p(request, "dob");
		String gender	= SH.p(request, "gender");
		String phone	= SH.p(request, "phone");
		String insc		= SH.p(request, "insc");
		
		Connection conn = SH.getOpenClinicConnection();
		try {
			//First check for parameter errors
			if(idtype.length()>0 && "*pc*".indexOf("*"+idtype.toLowerCase()+"*")<0) {
				MayeleAPI.error(root, "BI-INS.E006", "unknown idtype: "+idtype);
				return;
			}
			if(idtype.length()>0 && id.length()==0) {
				MayeleAPI.error(root, "BI-INS.E002", "id is mandatory when idtype is specified: "+idtype);
				return;
			}
			if(idtype.length()>0 && id.length()==0) {
				MayeleAPI.error(root, "BI-INS.E003", "idtype is mandatory when id is specified: "+id);
				return;
			}
			if(gender.length()>0 && "*m*f*".indexOf("*"+gender.toLowerCase()+"*")<0) {
				MayeleAPI.error(root, "BI-INS.E004", "unknown gender: "+gender);
				return;
			}
			
			//No errors detected, execute query
			String sSql = "select distinct a.personid,lastname,firstname,dateofbirth,gender,telephone,mobile,email from adminview a,oc_insurances b,privateview c where oc_insurance_patientuid=a.personid and a.personid=c.personid";
			if(uid.length()>0) {
				sSql+=" and a.personid=?";
			}
			if(idtype.equalsIgnoreCase("ins")) {
				sSql+=" and oc_insurance_nr=?";
			}
			if(lastname.length()>0) {
				sSql+=" and lastname like ?";
			}
			if(firstname.length()>0) {
				sSql+=" and firstname like ?";
			}
			if(ref.length()>0) {
				sSql+=" and oc_insurance_member = ?";
			}
			if(dob.length()>0) {
				sSql+=" and dateofbirth=?";
			}
			if(gender.length()>0) {
				sSql+=" and gender=?";
			}
			if(phone.length()>0) {
				sSql+=" and (telephone like ? or mobile like ?)";
			}
			if(insc.length()>0) {
				sSql+=" and oc_insurance_insuraruid=?";
			}
			PreparedStatement ps = conn.prepareStatement(sSql);
			int idx = 1;
			if(uid.length()>0) {
				ps.setString(idx++, uid);
			}
			if(idtype.equalsIgnoreCase("ins")) {
				ps.setString(idx++, id);
			}
			if(lastname.length()>0) {
				ps.setString(idx++, "%"+lastname+"%");
			}
			if(firstname.length()>0) {
				ps.setString(idx++, "%"+firstname+"%");
			}
			if(ref.length()>0) {
				ps.setString(idx++, ref);
			}
			if(dob.length()>0) {
				ps.setDate(idx++, new java.sql.Date(SH.parseDate(dob, "yyyyMMdd").getTime()));
			}
			if(gender.length()>0) {
				ps.setString(idx++, gender);
			}
			if(phone.length()>0) {
				ps.setString(idx++, phone);
				ps.setString(idx++, phone);
			}
			if(insc.length()>0) {
				ps.setString(idx++, insc);
			}
			ResultSet rs = ps.executeQuery();
			int maxrecords = 100,count=0;
			if(SH.p(request, "records").length()>0) {
				maxrecords=Integer.parseInt(SH.p(request, "records"));
			}
			while(rs.next() && count++<maxrecords) {
				Element ins = root.addElement("record");
				ins.addAttribute("uid", SH.c(rs.getString("personid")));
				ins.addElement("lastname").addCDATA(SH.c(rs.getString("lastname")));
				ins.addElement("firstname").addCDATA(SH.c(rs.getString("firstname")));
				ins.addElement("dob").setText(SH.formatSQLDate(rs.getDate("dateofbirth"),"yyyyMMdd"));
				ins.addElement("gender").setText(SH.c(rs.getString("gender")));
				ins.addElement("phone").setText(SH.c(rs.getString("telephone")));
				ins.addElement("mobile").setText(SH.c(rs.getString("mobile")));
				ins.addElement("email").setText(SH.c(rs.getString("email")));
				PreparedStatement ps2 = conn.prepareStatement("select * from oc_insurances,oc_insurars where oc_insurar_objectid=replace(oc_insurance_insuraruid,'"+SH.getServerId()+".','') and oc_insurance_patientuid=? order by oc_insurance_start");
				ps2.setString(1, SH.c(rs.getString("personid")));
				ResultSet rs2 = ps2.executeQuery();
				while(rs2.next()) {
					Element ins_insc = ins.addElement("insc");
					ins_insc.addAttribute("uid", SH.c(rs2.getString("oc_insurance_objectid")));
					ins_insc.addElement("id").addCDATA(SH.c(rs2.getString("oc_insurance_nr")));
					Element i=ins_insc.addElement("insc");
					i.addAttribute("uid", rs2.getString("oc_insurance_insuraruid"));
					i.addElement("name").addCDATA(rs2.getString("oc_insurar_name"));
					i.addElement("tariffcat").setText(rs2.getString("oc_insurar_type"));
					ins_insc.addElement("ref").addCDATA(SH.c(rs2.getString("oc_insurance_member")));
					ins_insc.addElement("begin").setText(SH.formatSQLDate(rs2.getDate("oc_insurance_start"), "yyyyMMdd"));
					ins_insc.addElement("end").setText(SH.formatSQLDate(rs2.getDate("oc_insurance_stop"), "yyyyMMdd"));
				}
				rs2.close();
				ps2.close();
			}
			rs.close();
			ps.close();
		}
		catch(Exception e) {
			MayeleAPI.error(root, "BI-INS.E001", "Error accessing patient insurance table. "+e.getMessage());
			e.printStackTrace();
		}
		try {
			conn.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
}
