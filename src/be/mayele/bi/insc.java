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
bi.insc      - uid
            - name
*/

public class insc extends Module{
	public void process(HttpServletRequest request, Element root) {
		String uid 		= SH.p(request, "uid");
		String name 	= SH.p(request, "name");
		
		Connection conn = SH.getOpenClinicConnection();
		try {
			String sSql = "select * from oc_insurars where 1=1";
			if(uid.length()>0) {
				sSql+=" and oc_insurar_objectid=?";
			}
			if(name.length()>0) {
				sSql+=" and oc_insurar_name like ?";
			}
			PreparedStatement ps = conn.prepareStatement(sSql);
			int idx = 1;
			if(uid.length()>0) {
				ps.setString(idx++, uid);
			}
			if(name.length()>0) {
				ps.setString(idx++, "%"+name+"%");
			}
			ResultSet rs = ps.executeQuery();
			int maxrecords = 100,count=0;
			if(SH.p(request, "records").length()>0) {
				maxrecords=Integer.parseInt(SH.p(request, "records"));
			}
			while(rs.next() && count++<maxrecords) {
				Element insc = root.addElement("record");
				insc.addAttribute("uid", SH.c(rs.getString("oc_insurar_objectid")));
				insc.addElement("name").addCDATA(SH.c(rs.getString("oc_insurar_name")));
				insc.addElement("tariffcat").setText(SH.c(rs.getString("oc_insurar_type")));
			}
			rs.close();
			ps.close();
		}
		catch(Exception e) {
			MayeleAPI.error(root, "BI-INSC.E001", "Error accessing oc_insurars table. "+e.getMessage());
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
