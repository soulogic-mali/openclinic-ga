package be.mayele.bi;

import java.sql.*;

import javax.servlet.http.HttpServletRequest;
import org.dom4j.Element;

import be.mayele.MayeleAPI;
import be.mayele.Module;
import be.openclinic.system.SH;

/* Parameters
bi.hrh      - uid           = from human resources registry
            - idtype        = PC (professional council)
            - id
            - lastname
            - firstname
            - type          - md    =   physician
                            - nurse =   nurse
                            - pha   =   pharmacist
                            - den   =   dentist
                            - lab   =   lab technician
                            - img   =   radiology technician
                            - adm   =   administrative and financial staff
                            - oth   =   other staff
            - hf            = health facility uid
*/

public class hrh extends Module{
	public void process(HttpServletRequest request, Element root) {
		String uid 		= SH.p(request, "uid");
		String idtype 	= SH.p(request, "idtype");
		String id 		= SH.p(request, "id");
		String lastname = SH.p(request, "lastname");
		String firstname= SH.p(request, "firstname");
		String type 	= SH.p(request, "type");
		String hf 		= SH.p(request, "hf");
		
		Connection conn = SH.getOpenClinicConnection();
		try {
			//First check for parameter errors
			if(idtype.length()>0 && "*pc*".indexOf("*"+idtype.toLowerCase()+"*")<0) {
				MayeleAPI.error(root, "BI-HRH.E006", "unknown idtype: "+idtype);
				return;
			}
			if(idtype.length()>0 && id.length()==0) {
				MayeleAPI.error(root, "BI-HRH.E002", "id is mandatory when idtype is specified: "+idtype);
				return;
			}
			if(idtype.length()>0 && id.length()==0) {
				MayeleAPI.error(root, "BI-HRH.E003", "idtype is mandatory when id is specified: "+id);
				return;
			}
			if(type.length()>0 && "*md*nurse*pha*den*lab*img*adm*oth*".indexOf("*"+type.toLowerCase()+"*")<0) {
				MayeleAPI.error(root, "BI-HRH.E004", "unknown type: "+type);
				return;
			}
			
			//No errors detected, execute query
			String sSql = "select * from mayele_hrh where 1=1";
			if(uid.length()>0) {
				sSql+=" and uid=?";
			}
			if(idtype.equalsIgnoreCase("pc")) {
				sSql+=" and pc=?";
			}
			if(lastname.length()>0) {
				sSql+=" and lastname like ?";
			}
			if(firstname.length()>0) {
				sSql+=" and firstname like ?";
			}
			if(type.length()>0) {
				sSql+=" and type = ?";
			}
			if(hf.length()>0) {
				sSql+=" and exists (select * from hrh_hf where hrh=uid and hf=? and (end is null or end>=now()))";
			}
			PreparedStatement ps = conn.prepareStatement(sSql);
			int idx = 1;
			if(uid.length()>0) {
				ps.setString(idx++, uid);
			}
			if(idtype.equalsIgnoreCase("pc")) {
				ps.setString(idx++, id);
			}
			if(lastname.length()>0) {
				ps.setString(idx++, "%"+lastname+"%");
			}
			if(firstname.length()>0) {
				ps.setString(idx++, "%"+firstname+"%");
			}
			if(type.length()>0) {
				ps.setString(idx++, type);
			}
			if(hf.length()>0) {
				ps.setString(idx++, hf);
			}
			ResultSet rs = ps.executeQuery();
			int maxrecords = 100,count=0;
			if(SH.p(request, "records").length()>0) {
				maxrecords=Integer.parseInt(SH.p(request, "records"));
			}
			while(rs.next() && count++<maxrecords) {
				Element hrh = root.addElement("record");
				hrh.addAttribute("uid", SH.c(rs.getString("uid")));
				hrh.addElement("pctype").setText(SH.c(rs.getString("pctype")));
				hrh.addElement("pcid").setText(SH.c(rs.getString("pcid")));
				hrh.addElement("lastname").addCDATA(SH.c(rs.getString("lastname")));
				hrh.addElement("firstname").addCDATA(SH.c(rs.getString("firstname")));
				hrh.addElement("type").setText(SH.c(rs.getString("type")));
				hrh.addElement("title").addCDATA(SH.c(rs.getString("title")));
				PreparedStatement ps2 = conn.prepareStatement("select * from mayele_hrh_hf where hrh=? order by begin");
				ps2.setString(1, SH.c(rs.getString("uid")));
				ResultSet rs2 = ps2.executeQuery();
				while(rs2.next()) {
					Element hrh_hf = hrh.addElement("hf");
					hrh_hf.addAttribute("uid", SH.c(rs2.getString("hf")));
					hrh_hf.addElement("function").addCDATA(SH.c(rs2.getString("function")));
					hrh_hf.addElement("begin").setText(SH.formatSQLDate(rs2.getDate("begin"), "yyyyMMdd"));
					hrh_hf.addElement("end").setText(SH.formatSQLDate(rs2.getDate("end"), "yyyyMMdd"));
				}
				rs2.close();
				ps2.close();
			}
			rs.close();
			ps.close();
		}
		catch(Exception e) {
			MayeleAPI.error(root, "BI-HRH.E001", "Error accessing mayele_hrh table. "+e.getMessage());
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
