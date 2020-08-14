<%@page import="be.openclinic.adt.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%!
	private java.util.Date roundMinutes(java.util.Date date,int n){
		long minute = 60*1000;
		date = new java.util.Date(Math.round(date.getTime()/(n*minute))*n*minute);
		return date;
	}
%>
<%
	try{
		boolean bInitialized=false;
		SimpleDateFormat ISO8601DATEFORMAT = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.ENGLISH);
		java.util.Date dStart = ISO8601DATEFORMAT.parse(request.getParameter("start"));
		java.util.Date dEnd = ISO8601DATEFORMAT.parse(request.getParameter("end"));
		String sType = checkString(request.getParameter("type"));
		StringBuffer sb = new StringBuffer();
		sb.append("[");
		if(sType.equalsIgnoreCase("resource")){
			//Show resource events
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			PreparedStatement ps = conn.prepareStatement("select * from oc_reservations r,oc_planning p where oc_planning_objectid=replace(oc_reservation_planninguid,'"+SH.sid()+".','') and oc_planning_planneddate<=? and oc_planning_plannedend>=?");
			ps.setTimestamp(1, new Timestamp(dEnd.getTime()));
			ps.setTimestamp(2, new Timestamp(dStart.getTime()));
			ResultSet rs = ps.executeQuery();
			bInitialized=false;
			while(rs.next()){
				if(bInitialized){
					sb.append(",");
				}
				sb.append("{");
				sb.append("\"id\":\""+rs.getString("oc_reservation_planninguid")+"\",");
				sb.append("\"resourceId\":\""+rs.getString("oc_reservation_resourceuid")+"\",");
				sb.append("\"backgroundColor\":\"darkred\",");
				sb.append("\"title\":\""+User.getFullUserName(rs.getString("oc_planning_useruid"))+"\",");
				sb.append("\"start\":\""+new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").format(rs.getTimestamp("oc_planning_planneddate"))+"\",");
				sb.append("\"end\":\""+new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").format(rs.getTimestamp("oc_planning_plannedend"))+"\"");
				sb.append("}");
				bInitialized=true;
			}
			rs.close();
			ps.close();
			ps = conn.prepareStatement("select * from oc_planning p where substring_index(oc_planning_modifiers,';',-6) not like ';;%' and oc_planning_modifiers not like '%medwan.common.free%' and oc_planning_planneddate<=? and oc_planning_plannedend>=?");
			ps.setTimestamp(1, new Timestamp(dEnd.getTime()));
			ps.setTimestamp(2, new Timestamp(dStart.getTime()));
			rs = ps.executeQuery();
			while(rs.next()){
				String mod = rs.getString("oc_planning_modifiers");
				String[] s =mod.split(";");
				if(s.length>7 && !s[5].equalsIgnoreCase("1")){
					String locationid = s[7];
					if(bInitialized){
						sb.append(",");
					}
					sb.append("{");
					sb.append("\"id\":\""+rs.getString("oc_planning_serverid")+"."+rs.getString("oc_planning_objectid")+"\",");
					sb.append("\"resourceId\":\"LOC."+locationid+"\",");
					sb.append("\"title\":\""+User.getFullUserName(rs.getString("oc_planning_useruid"))+"\",");
					sb.append("\"start\":\""+new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").format(rs.getTimestamp("oc_planning_planneddate"))+"\",");
					sb.append("\"end\":\""+new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").format(rs.getTimestamp("oc_planning_plannedend"))+"\"");
					sb.append("}");
					bInitialized=true;
				}
			}
			rs.close();
			ps.close();
			conn.close();
		}
		sb.append("]");
		out.print(sb.toString());
		System.out.println("-----------------------------------");
		System.out.println(sb.toString());
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>