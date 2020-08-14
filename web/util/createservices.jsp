<%@page import="be.mxs.common.util.system.*,net.admin.*,be.openclinic.finance.*,be.mxs.common.util.db.MedwanQuery,java.sql.*,java.util.*,
be.openclinic.knowledge.*"%>
<%
	Vector cdsservices= new Vector(),hdservices=new Vector();
	Connection conn = MedwanQuery.getInstance().getLongAdminConnection();
	PreparedStatement ps = conn.prepareStatement("select distinct service from openclinic.cleaned where type_structure='CDS' order by service");
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		cdsservices.add(rs.getString("service"));
	}
	rs.close();
	ps.close();
	ps = conn.prepareStatement("select distinct service from openclinic.cleaned where type_structure='HD' order by service");
	rs = ps.executeQuery();
	while(rs.next()){
		hdservices.add(rs.getString("service"));
	}
	rs.close();
	ps.close();
	ps = conn.prepareStatement("select * from services where serviceid like '%.%.%.%' order by serviceid");
	rs = ps.executeQuery();
	while(rs.next()){
		String serviceid = rs.getString("serviceid");
		if(serviceid.split("\\.").length==4){
			if(serviceid.split("\\.")[3].startsWith("CDS")){
				//Create health center services
				for(int n=0;n<cdsservices.size();n++){
					String service = (String)cdsservices.elementAt(n);
					Service s = Service.getService(serviceid+"."+n);
					if(s==null){
						s = new Service();
						s.setCode(serviceid+"."+n);
						s.setParentcode(serviceid);
						s.store();
						MedwanQuery.getInstance().updateLabel("service", serviceid+"."+n, "fr", service);
						MedwanQuery.getInstance().updateLabel("service", serviceid+"."+n, "en", service);
					}
				}
				Service s = Service.getService(serviceid+".99");
				if(s==null){
					s = new Service();
					s.setCode(serviceid+".99");
					s.setParentcode(serviceid);
					s.store();
					MedwanQuery.getInstance().updateLabel("service", serviceid+".99", "fr", "AUTRE");
					MedwanQuery.getInstance().updateLabel("service", serviceid+".99", "en", "OTHER");
				}
			}
			else if(serviceid.split("\\.")[3].startsWith("HD") || serviceid.split("\\.")[3].startsWith("HR")){
				//Create hospital services
				for(int n=0;n<hdservices.size();n++){
					String service = (String)hdservices.elementAt(n);
					Service s = Service.getService(serviceid+"."+n);
					if(s==null){
						s = new Service();
						s.setCode(serviceid+"."+n);
						s.setParentcode(serviceid);
						s.store();
						MedwanQuery.getInstance().updateLabel("service", serviceid+"."+n, "fr", service);
						MedwanQuery.getInstance().updateLabel("service", serviceid+"."+n, "en", service);
					}
				}
				Service s = Service.getService(serviceid+".99");
				if(s==null){
					s = new Service();
					s.setCode(serviceid+".99");
					s.setParentcode(serviceid);
					s.store();
					MedwanQuery.getInstance().updateLabel("service", serviceid+".99", "fr", "AUTRE");
					MedwanQuery.getInstance().updateLabel("service", serviceid+".99", "en", "OTHER");
				}
			}
		}
	}
%>
