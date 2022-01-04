<%@page import="org.apache.commons.httpclient.*,org.apache.commons.httpclient.methods.*,java.io.*,org.dom4j.*,org.dom4j.util.*"%>
<%@include file="/includes/helper.jsp"%>
<%
	String sResult="<response type='error' message='[0.0] Undefined error'/>";
	try{
		Hashtable parameters = SH.getMultipartFormParameters(request);
		String operation = SH.c((String)parameters.get("operation"));
		String uid=SH.c((String)parameters.get("uid"));
		String xml=SH.c((String)parameters.get("xml"));
		int n=-1;
		
		if(operation.equalsIgnoreCase("store")){
			//Now we store these parameters in the database
			Connection conn = SH.getOpenClinicConnection();
			PreparedStatement ps = conn.prepareStatement("insert into OC_PHARMASYNC(OC_PHARMASYNC_ID,OC_PHARMASYNC_UID,OC_PHARMASYNC_XML,OC_PHARMASYNC_UPDATETIME) values(?,?,?,?)");
			n = MedwanQuery.getInstance().getOpenclinicCounter("PHARMASYNC");
			ps.setInt(1,n);
			ps.setString(2,uid);
			ps.setString(3,xml);
			ps.setTimestamp(4, new Timestamp(new java.util.Date().getTime()));
			ps.execute();
			ps.close();
			conn.close();
			sResult="<response type='pharmasync' updateid='"+n+"' message='Added sync data'/>";
		}
		else if(operation.equalsIgnoreCase("retrieve")){
			String lastupdateid=SH.c((String)parameters.get("lastupdateid"));
			int nLastupdateid =0;
			try{
				nLastupdateid=Integer.parseInt(lastupdateid);
			}
			catch(Exception e){ e.printStackTrace(); }
			//Get information from the database
			Element r = DocumentHelper.createElement("response");
			Connection conn = SH.getOpenClinicConnection();
			PreparedStatement ps = conn.prepareStatement("select * from OC_PHARMASYNC where OC_PHARMASYNC_UID=? and OC_PHARMASYNC_ID>? order by OC_PHARMASYNC_ID");
			ps.setString(1,uid);
			ps.setInt(2,nLastupdateid);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				try{
					Element message = DocumentHelper.parseText(rs.getString("OC_PHARMASYNC_XML")).getRootElement();
					message.addAttribute("id", rs.getString("OC_PHARMASYNC_ID"));
					r.add(message);
				}
				catch(Exception x){
					x.printStackTrace();
				}
			}
			rs.close();
			ps.close();
			conn.close();
			sResult=r.asXML();
		}
		else if(operation.equalsIgnoreCase("getlastid")){
			Element r = DocumentHelper.createElement("response");
			Connection conn = SH.getOpenClinicConnection();
			PreparedStatement ps = conn.prepareStatement("select max(OC_PHARMASYNC_ID) maxid from OC_PHARMASYNC");
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				r.addAttribute("lastid", rs.getString("maxid"));
			}
			rs.close();
			ps.close();
			conn.close();
			sResult=r.asXML();
		}
		else if(operation.equalsIgnoreCase("getnewuids")){
			String lastupdateid=SH.c((String)parameters.get("lastupdateid"));
			int nLastupdateid =0;
			try{
				nLastupdateid=Integer.parseInt(lastupdateid);
			}
			catch(Exception e){ e.printStackTrace(); }
			Element r = DocumentHelper.createElement("response");
			Connection conn = SH.getOpenClinicConnection();
			PreparedStatement ps = conn.prepareStatement("select distinct OC_PHARMASYNC_UID from OC_PHARMASYNC where OC_PHARMASYNC_ID>?");
			ps.setInt(1,nLastupdateid);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				Element message = DocumentHelper.createElement("message");
				message.addAttribute("uid", rs.getString("OC_PHARMASYNC_UID"));
				r.add(message);
			}
			rs.close();
			ps.close();
			conn.close();
			sResult=r.asXML();
		}
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>
<%=sResult %>
