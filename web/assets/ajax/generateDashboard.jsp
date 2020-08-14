<%@page import="be.openclinic.assets.Util"%>
<%@ page errorPage="/includes/error.jsp" %>
<%@ include file="/includes/validateUser.jsp" %>

<table width='100%'>
<%
	String serviceUid = checkString(request.getParameter("service"));
	java.util.Date dBegin = ScreenHelper.parseDate(request.getParameter("begin"));
	java.util.Date dEnd = new java.util.Date(ScreenHelper.parseDate(request.getParameter("end")).getTime()+SH.getTimeDay());
	Hashtable parameters = new Hashtable();
	int count =0, total=0;
%>
	<!-- INFRASTRUCTURE -->
	<tr class='admin'><td colspan='3'><%=getTran(request,"web","infrastructure",sWebLanguage) %></td></tr>
	<%
		parameters = new Hashtable();
		parameters.put("oc_asset_comment9","in;'0','1'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_asset_nomenclature","like;'I.%'");
		count=Util.countAssets(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalingoodstate",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+count+"</td></tr>");
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'I.%'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		total=Util.countAssets(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalinfrastructure",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+total+"</td></tr>");
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","fractioningoodstate",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+new DecimalFormat("#0.00").format(new Double(count)*100/new Double(total))+"%</td></tr>");
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'I.%'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_maintenanceplan_type","equals;'2'");
		parameters.put("oc_maintenanceoperation_date","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_maintenanceoperation_date","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		count=Util.countMaintenanceOperations(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalpreventiveoperations",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+count+"</td></tr>");
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'I.%'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_maintenanceplan_type","equals;'3'");
		parameters.put("oc_maintenanceoperation_date","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_maintenanceoperation_date","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		count=Util.countMaintenanceOperations(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalcorrectiveoperations",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+count+"</td></tr>");
		parameters.put("oc_maintenanceoperation_result","equals;'ok'");
		count=Util.countMaintenanceOperations(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalsuccesfulcorrectiveoperations",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+count+"</td></tr>");
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'I.%'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_asset_comment13 like '%/%/%' and str_to_date(oc_asset_comment13,'%d/%m/%Y')","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_asset_comment13 like '%/%/%' and str_to_date(oc_asset_comment13,'%d/%m/%Y')","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		count=Util.countAssets(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalupdates",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+count+"</td></tr>");
	%>
	<!-- EQUIPMENT -->
	<tr class='admin'><td colspan='3'><%=getTran(request,"web","equipment",sWebLanguage) %></td></tr>
	<%
		parameters = new Hashtable();
		parameters.put("oc_asset_comment7","equals;'1'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_asset_nomenclature","like;'E.%'");
		count=Util.countAssets(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totaloperational",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+count+"</td></tr>");
		parameters = new Hashtable();
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_asset_nomenclature","like;'E.%'");
		total=Util.countAssets(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalequipment",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+total+"</td></tr>");
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","fractionoperational",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+new DecimalFormat("#0.00").format(new Double(count)*100/new Double(total))+"%</td></tr>");
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'E.%'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_maintenanceplan_type","equals;'2'");
		parameters.put("oc_maintenanceoperation_date","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_maintenanceoperation_date","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		int preventativeoperations=Util.countMaintenanceOperations(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalpreventiveoperations",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+preventativeoperations+"</td></tr>");
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'E.%'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_maintenanceplan_type","equals;'3'");
		parameters.put("oc_maintenanceoperation_date","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_maintenanceoperation_date","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		count=Util.countMaintenanceOperations(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalcorrectiveoperations",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+count+"</td></tr>");
		parameters.put("oc_maintenanceoperation_result","equals;'ok'");
		count=Util.countMaintenanceOperations(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalsuccesfulcorrectiveoperations",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+count+"</td></tr>");
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'E.%'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_asset_comment13 like '%/%/%' and str_to_date(oc_asset_comment13,'%d/%m/%Y')","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_asset_comment13 like '%/%/%' and str_to_date(oc_asset_comment13,'%d/%m/%Y')","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		count=Util.countAssets(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalnewequipment",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+count+"</td></tr>");
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'E.%'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_asset_saledate","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_asset_saledate","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		count=Util.countAssets(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalevacuatedequipment",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+count+"</td></tr>");
		parameters = new Hashtable();
		parameters.put("oc_asset_comment7","notequals;'1'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_asset_nomenclature","like;'E.%'");
		total=Util.countAssets(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totaldysfunctional",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+total+"</td></tr>");
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","fractionevacuated",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+new DecimalFormat("#0.00").format(new Double(count)*100/new Double(total))+"%</td></tr>");
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'E.%'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_maintenanceplan_type","equals;'2'");
		parameters.put("length(oc_maintenanceoperation_supplier)","copy;>0");
		parameters.put("oc_maintenanceoperation_date","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_maintenanceoperation_date","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		count=Util.countMaintenanceOperations(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalexternalpreventative",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+count+"</td></tr>");
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'E.%'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_maintenanceplan_type","equals;'3'");
		parameters.put("length(oc_maintenanceoperation_supplier)","copy;>0");
		parameters.put("oc_maintenanceoperation_date","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_maintenanceoperation_date","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		count=Util.countMaintenanceOperations(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalexternalcorrective",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+count+"</td></tr>");
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'E.%'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_maintenanceplan_type","equals;'3'");
		parameters.put("oc_maintenanceoperation_date","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_maintenanceoperation_date","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		String s=Util.analyzeMaintenanceOperations(parameters,"sum(oc_maintenanceoperation_comment1)+sum(oc_maintenanceoperation_comment2)+sum(oc_maintenanceoperation_comment3)+sum(oc_maintenanceoperation_comment4)");
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalcorrectivecost",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+checkString(s)+"</td></tr>");
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'E.%'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_maintenanceplan_type","equals;'2'");
		parameters.put("oc_maintenanceoperation_date","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_maintenanceoperation_date","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		s=Util.analyzeMaintenanceOperations(parameters,"sum(oc_maintenanceoperation_comment1)+sum(oc_maintenanceoperation_comment2)+sum(oc_maintenanceoperation_comment3)+sum(oc_maintenanceoperation_comment4)");
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalpreventativecost",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+checkString(s)+"</td></tr>");
	%>
	<!-- PERFORMANCE -->
	<tr class='admin'><td colspan='3'><%=getTran(request,"web","performances",sWebLanguage) %></td></tr>
	<%
		//First check how many preventative maintenance operations were scheduled in the period
		HashSet plans = new HashSet();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		String sid=MedwanQuery.getInstance().getServerId()+"";
		String sSql = 	"select * from oc_assets a,oc_maintenanceplans p where oc_asset_objectid=replace(oc_maintenanceplan_assetuid,'"+sid+".','') and"+
								" oc_maintenanceplan_type=2 and oc_asset_service like '"+serviceUid+"%' and (oc_maintenanceplan_enddate is null or oc_maintenanceplan_enddate>'"+
								new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"') and oc_maintenanceplan_startdate<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'";
		PreparedStatement ps = conn.prepareStatement(sSql);
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
			//Each of these maintenance plans is due if (i) there has never been an operation or (ii) the expiry date of the 
			//latest maintenance operation falls before enddate (it should have been done) 
			String maintenancePlanUid = rs.getString("oc_maintenanceplan_serverid")+"."+rs.getString("oc_maintenanceplan_objectid");
			String frequency = rs.getString("oc_maintenanceplan_frequency");
			PreparedStatement ps2 = conn.prepareStatement("select max(oc_maintenanceoperation_nextdate) nextdate from oc_maintenanceoperations where oc_maintenanceoperation_maintenanceplanuid=?");
			ps2.setString(1,maintenancePlanUid);
			ResultSet rs2 = ps2.executeQuery();
			if(rs2.next()){
				java.util.Date nextdate = rs2.getTimestamp("nextdate");
				if(nextdate==null){
					java.util.Date d = dBegin;
					while(d.before(dEnd)){
						plans.add(maintenancePlanUid+"."+d);
						if(frequency.equalsIgnoreCase("1")){
							d=new java.util.Date(d.getTime()+SH.getTimeDay());
						}
						else if(frequency.equalsIgnoreCase("2")){
							d=new java.util.Date(d.getTime()+SH.getTimeDay()*7);
						}
						else if(frequency.equalsIgnoreCase("3")){
							d=new java.util.Date(d.getTime()+SH.getTimeDay()*30);
						}
						else if(frequency.equalsIgnoreCase("4")){
							d=new java.util.Date(d.getTime()+SH.getTimeDay()*91);
						}
						else if(frequency.equalsIgnoreCase("5")){
							d=new java.util.Date(d.getTime()+SH.getTimeDay()*182);
						}
						else if(frequency.equalsIgnoreCase("6")){
							d=new java.util.Date(d.getTime()+SH.getTimeYear());
						}
						else if(frequency.equalsIgnoreCase("7")){
							d=new java.util.Date(d.getTime()+SH.getTimeYear()*2);
						}
						else if(frequency.equalsIgnoreCase("8")){
							d=new java.util.Date(d.getTime()+SH.getTimeYear()*3);
						}
						else if(frequency.equalsIgnoreCase("9")){
							d=new java.util.Date(d.getTime()+SH.getTimeYear()*5);
						}
						else if(frequency.equalsIgnoreCase("10")){
							d=new java.util.Date(d.getTime()+SH.getTimeYear()*10);
						}
						else if(frequency.equalsIgnoreCase("11")){
							d=new java.util.Date(d.getTime()+SH.getTimeYear()*20);
						}
						else if(frequency.equalsIgnoreCase("12")){
							d=new java.util.Date(d.getTime()+SH.getTimeYear()*30);
						}
						else{
							d=dEnd;
						}
					}
				}
			}
			rs2.close();
			ps2.close();
		}
		rs.close();
		ps.close();
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalpreventativeforeseen",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+plans.size()+"</td></tr>");
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalpreventativefraction",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+new DecimalFormat("#0.00").format(new Double(preventativeoperations)*100/new Double(plans.size()))+"%</td></tr>");
		plans = new HashSet();
		sSql = 	"select * from oc_assets a,oc_maintenanceplans p where oc_asset_objectid=replace(oc_maintenanceplan_assetuid,'"+sid+".','') and"+
				" oc_maintenanceplan_type=3 and oc_asset_service like '"+serviceUid+"%' and oc_maintenanceplan_startdate<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"' and (oc_maintenanceplan_enddate is null or oc_maintenanceplan_enddate>'"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"')";
		ps = conn.prepareStatement(sSql);
		rs = ps.executeQuery();
		int c = 0;
		long days=0,successdays=0;
		while(rs.next()){
			java.util.Date requestDate = rs.getTimestamp("oc_maintenanceplan_startdate");
			if(requestDate!=null){
				String maintenancePlanUid = rs.getString("oc_maintenanceplan_serverid")+"."+rs.getString("oc_maintenanceplan_objectid");
				PreparedStatement ps2 = conn.prepareStatement("select min(oc_maintenanceoperation_date) date from oc_maintenanceoperations where oc_maintenanceoperation_maintenanceplanuid=?");
				ps2.setString(1,maintenancePlanUid);
				ResultSet rs2 = ps2.executeQuery();
				if(rs2.next()){
					java.util.Date d = rs2.getTimestamp("date");
					if(d==null){
						d=new java.util.Date();
					}
					c++;
					days+=(d.getTime()-requestDate.getTime());
				}
				rs2.close();
				ps2.close();
				ps2 = conn.prepareStatement("select min(oc_maintenanceoperation_date) date from oc_maintenanceoperations where oc_maintenanceoperation_result='ok' and oc_maintenanceoperation_maintenanceplanuid=?");
				ps2.setString(1,maintenancePlanUid);
				rs2 = ps2.executeQuery();
				if(rs2.next()){
					java.util.Date d = rs2.getTimestamp("date");
					if(d==null){
						d=new java.util.Date();
					}
					c++;
					successdays+=(d.getTime()-requestDate.getTime());
				}
				rs2.close();
				ps2.close();
			}
		}
		rs.close();
		ps.close();
		conn.close();
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","meanresponsetime",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+new DecimalFormat("#0.00").format((new Double(days)/+new Double(c))/ScreenHelper.getTimeDay())+" "+getTran(request,"web","days",sWebLanguage)+"</td></tr>");
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","meansuccessresponsetime",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+new DecimalFormat("#0.00").format((new Double(successdays)/+new Double(c))/ScreenHelper.getTimeDay())+" "+getTran(request,"web","days",sWebLanguage)+"</td></tr>");
	%>
</table>