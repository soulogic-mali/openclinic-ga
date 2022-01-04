package be.mayele.bi;

import java.io.IOException;
import java.sql.*;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.httpclient.HttpException;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import be.mayele.MayeleAPI;
import be.mayele.MayeleClient;
import be.mayele.Module;
import be.openclinic.system.SH;

	/* Parameters
	bi.hf       - uid           = from health facility registry
				- idtype        = DHIS,GMAO
				- id
				- name
				- province
				- district
				- type          - hos   =   hôpital
				                - hc    =   centre de santé
				                - pha   =   pharmacie
				                - lab   =   laboratoire
				                - oth   =   autre 
				- cat           - pub   =   public
				                - priv  =   private
	*/

public class hf extends Module{
	String uid;
	String idtype;
	String id;
	String name;
	String province;
	String district;
	String type;
	String cat;
	String longitude;
	String latitude;
	
	public void process(HttpServletRequest request, Element root) {
		String uid 		= SH.p(request, "uid");
		String idtype 	= SH.p(request, "idtype");
		String id 		= SH.p(request, "id");
		String name 	= SH.p(request, "name");
		String province = SH.p(request, "province");
		String district = SH.p(request, "district");
		String type 	= SH.p(request, "type");
		String cat 		= SH.p(request, "cat");
		
		Connection conn = SH.getOpenClinicConnection();
		try {
			//First check for parameter errors
			if(idtype.length()>0 && "*dhis*gmao*".indexOf("*"+idtype.toLowerCase()+"*")<0) {
				MayeleAPI.error(root, "BI-HF.E006", "unknown idtype: "+idtype);
				return;
			}
			if(idtype.length()>0 && id.length()==0) {
				MayeleAPI.error(root, "BI-HF.E002", "id is mandatory when idtype is specified: "+idtype);
				return;
			}
			if(idtype.length()==0 && id.length()>0) {
				MayeleAPI.error(root, "BI-HF.E003", "idtype is mandatory when id is specified: "+id);
				return;
			}
			if(type.length()>0 && "*hos*hc*pha*lab*oth*".indexOf("*"+type.toLowerCase()+"*")<0) {
				MayeleAPI.error(root, "BI-HF.E004", "unknown type: "+type);
				return;
			}
			if(cat.length()>0 && "*pub*priv*".indexOf("*"+cat.toLowerCase()+"*")<0) {
				MayeleAPI.error(root, "BI-HF.E005", "unknown cat: "+cat);
				return;
			}
			
			//No errors detected, execute query
			String sSql = "select * from mayele_hf where 1=1";
			if(uid.length()>0) {
				sSql+=" and uid=?";
			}
			if(idtype.equalsIgnoreCase("dhis")) {
				sSql+=" and dhis=?";
			}
			if(idtype.equalsIgnoreCase("gmao")) {
				sSql+=" and gmao=?";
			}
			if(name.length()>0) {
				sSql+=" and name like ?";
			}
			if(province.length()>0) {
				sSql+=" and province = ?";
			}
			if(district.length()>0) {
				sSql+=" and district = ?";
			}
			if(type.length()>0) {
				sSql+=" and type = ?";
			}
			if(cat.length()>0) {
				sSql+=" and cat = ?";
			}
			PreparedStatement ps = conn.prepareStatement(sSql);
			int idx = 1;
			if(uid.length()>0) {
				ps.setString(idx++, uid);
			}
			if(idtype.equalsIgnoreCase("dhis")) {
				ps.setString(idx++, id);
			}
			if(idtype.equalsIgnoreCase("gmao")) {
				ps.setString(idx++, id);
			}
			if(name.length()>0) {
				ps.setString(idx++, "%"+name+"%");
			}
			if(province.length()>0) {
				ps.setString(idx++, province);
			}
			if(district.length()>0) {
				ps.setString(idx++, district);
			}
			if(type.length()>0) {
				ps.setString(idx++, type);
			}
			if(cat.length()>0) {
				ps.setString(idx++, cat);
			}
			ResultSet rs = ps.executeQuery();
			int maxrecords = 100,count=0;
			if(SH.p(request, "records").length()>0) {
				maxrecords=Integer.parseInt(SH.p(request, "records"));
			}
			while(rs.next() && count++<maxrecords) {
				Element hf = root.addElement("record");
				hf.addAttribute("uid", SH.c(rs.getString("uid")));
				hf.addElement("dhis").setText(SH.c(rs.getString("dhis")));
				hf.addElement("gmao").setText(SH.c(rs.getString("gmao")));
				hf.addElement("name").addCDATA(SH.c(rs.getString("name")));
				hf.addElement("province").setText(SH.c(rs.getString("province")));
				hf.addElement("district").setText(SH.c(rs.getString("district")));
				hf.addElement("type").setText(SH.c(rs.getString("type")));
				hf.addElement("cat").setText(SH.c(rs.getString("cat")));
				hf.addElement("longitude").setText(SH.c(rs.getString("longitude")));
				hf.addElement("latitude").setText(SH.c(rs.getString("latitude")));
			}
			rs.close();
			ps.close();
		}
		catch(Exception e) {
			MayeleAPI.error(root, "BI-HF.E001", "Error accessing mayele_hf table. "+e.getMessage());
			e.printStackTrace();
		}
		try {
			conn.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public String getLongitude() {
		return longitude;
	}

	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}

	public String getLatitude() {
		return latitude;
	}

	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}

	public String getUid() {
		return uid;
	}

	public void setUid(String uid) {
		this.uid = uid;
	}

	public String getIdtype() {
		return idtype;
	}

	public void setIdtype(String idtype) {
		this.idtype = idtype;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDistrict() {
		return district;
	}

	public void setDistrict(String district) {
		this.district = district;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getCat() {
		return cat;
	}

	public void setCat(String cat) {
		this.cat = cat;
	}

	public static Vector<hf> find(String url,HashMap<String,String> parameters) throws HttpException, DocumentException, IOException {
		Vector<hf> v = new Vector();
		Document document = DocumentHelper.parseText(MayeleClient.find(url, parameters));
		Element root = document.getRootElement();
		Iterator<Element> i = root.elementIterator("record");
		while(i.hasNext()) {
			Element record = i.next();
			hf hf = new hf();
			hf.setUid(record.attributeValue("uid"));
			if(record.elementText("idtype")!=null) hf.setIdtype(record.elementText("idtype"));
			if(record.elementText("id")!=null) hf.setId(record.elementText("id"));
			if(record.elementText("name")!=null) hf.setName(record.elementText("name"));
			if(record.elementText("province")!=null) hf.setProvince(record.elementText("province"));
			if(record.elementText("district")!=null) hf.setDistrict(record.elementText("district"));
			if(record.elementText("longitude")!=null) hf.setLongitude(record.elementText("longitude"));
			if(record.elementText("latitude")!=null) hf.setLatitude(record.elementText("latitude"));
			if(record.elementText("type")!=null) hf.setType(record.elementText("type"));
			if(record.elementText("cat")!=null) hf.setCat(record.elementText("cat"));
			v.add(hf);
		}
		return v;
	}

	public String getProvince() {
		return province;
	}

	public void setProvince(String province) {
		this.province = province;
	}
}
