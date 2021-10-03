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
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalingoodstate",sWebLanguage)+"</td><td class='admin2'><span id='infragoodstate'>"+count+"</span></td><td class='admin2' rowspan='7'><table><tr><td width='200px'><canvas id='infraStateChart' width='200px' height='200px'></canvas></td><td width='200px'><canvas id='infraOperationChart' width='200px' height='200px'></canvas></td><td width='200px'><canvas id='infraSuccessChart' width='200px' height='200px'></canvas></td><td></td></tr></table></td></tr>");
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'I.%'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		total=Util.countAssets(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalinfrastructure",sWebLanguage)+"</td><td class='admin2'><span id='infratotalstate'>"+total+"</span></td></tr>");
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","fractioningoodstate",sWebLanguage)+"</td><td class='admin2'><b style='font-size: 14px'>"+new DecimalFormat("#0.00").format(new Double(count)*100/new Double(total))+"%</b></td></tr>");
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'I.%'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_maintenanceplan_type","equals;'2'");
		parameters.put("oc_maintenanceoperation_date","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_maintenanceoperation_date","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		count=Util.countMaintenanceOperations(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalpreventiveoperations",sWebLanguage)+"</td><td class='admin2'><span id='infrapreventative'>"+count+"</span></td></tr>");
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'I.%'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_maintenanceplan_type","equals;'3'");
		parameters.put("oc_maintenanceoperation_date","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_maintenanceoperation_date","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		count=Util.countMaintenanceOperations(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalcorrectiveoperations",sWebLanguage)+"</td><td class='admin2'><span id='infracorrective'>"+count+"</span></td></tr>");
		parameters.put("oc_maintenanceoperation_result","equals;'ok'");
		count=Util.countMaintenanceOperations(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalsuccesfulcorrectiveoperations",sWebLanguage)+"</td><td class='admin2'><span id='infracorrectivesuccess'>"+count+"</span></td></tr>");
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'I.%'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_asset_comment13 like '%/%/%' and str_to_date(oc_asset_comment13,'%d/%m/%Y')","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_asset_comment13 like '%/%/%' and str_to_date(oc_asset_comment13,'%d/%m/%Y')","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		count=Util.countAssets(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalupdates",sWebLanguage)+"</td><td class='admin2'>"+count+"</td></tr>");
	%>
	<!-- EQUIPMENT -->
	<tr class='admin'><td colspan='3'><%=getTran(request,"web","equipment",sWebLanguage) %></td></tr>
	<%
		parameters = new Hashtable();
		parameters.put("oc_asset_comment7","equals;'1'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_asset_nomenclature","like;'E%'");
		int state1=Util.countAssets(parameters);
		parameters = new Hashtable();
		parameters.put("oc_asset_comment7","equals;'2'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_asset_nomenclature","like;'E%'");
		int state2=Util.countAssets(parameters);
		parameters = new Hashtable();
		parameters.put("oc_asset_comment7","equals;'3'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_asset_nomenclature","like;'E%'");
		int state3=Util.countAssets(parameters);
		parameters = new Hashtable();
		parameters.put("oc_asset_comment7","equals;'4'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_asset_nomenclature","like;'E%'");
		int state4=Util.countAssets(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totaloperational",sWebLanguage)+"</td><td class='admin2'><span id='matgoodstate'>"+state1+"</span></td><td class='admin2' rowspan='7'><input type='hidden' id='state2' value='"+state2+"'/><input type='hidden' id='state3' value='"+state3+"'/><input type='hidden' id='state4' value='"+state4+"'/><table><tr><td width='200px'><canvas id='matStateChart' width='200px' height='200px'></canvas></td><td width='200px'><canvas id='matOperationChart' width='200px' height='200px'></canvas></td><td width='200px'><canvas id='matSuccessChart' width='200px' height='200px'></canvas></td><td></td></tr></table></td></tr>");
		parameters = new Hashtable();
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_asset_nomenclature","like;'E%'");
		total=Util.countAssets(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalequipment",sWebLanguage)+"</td><td class='admin2'><span id='mattotalstate'>"+total+"</span></td></tr>");
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","fractionoperational",sWebLanguage)+"</td><td class='admin2'><b style='font-size: 14px'>"+new DecimalFormat("#0.00").format(new Double(state1)*100/new Double(total))+"%</b></td></tr>");
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'E%'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_maintenanceplan_type","equals;'2'");
		parameters.put("oc_maintenanceoperation_date","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_maintenanceoperation_date","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		int preventativeoperations=Util.countMaintenanceOperations(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalpreventiveoperations",sWebLanguage)+"</td><td class='admin2'><span id='matpreventative'>"+preventativeoperations+"</span></td></tr>");
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'E%'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_maintenanceplan_type","equals;'3'");
		parameters.put("oc_maintenanceoperation_date","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_maintenanceoperation_date","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		count=Util.countMaintenanceOperations(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalcorrectiveoperations",sWebLanguage)+"</td><td class='admin2'><span id='matcorrective'>"+count+"</span></td></tr>");
		parameters.put("oc_maintenanceoperation_result","equals;'ok'");
		count=Util.countMaintenanceOperations(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalsuccesfulcorrectiveoperations",sWebLanguage)+"</td><td class='admin2'><span id='matcorrectivesuccess'>"+count+"</span></td></tr>");
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'E%'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_asset_comment13 like '%/%/%' and str_to_date(oc_asset_comment13,'%d/%m/%Y')","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_asset_comment13 like '%/%/%' and str_to_date(oc_asset_comment13,'%d/%m/%Y')","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		count=Util.countAssets(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalnewequipment",sWebLanguage)+"</td><td class='admin2'>"+count+"</td></tr>");
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'E%'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_asset_saledate","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_asset_saledate","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		count=Util.countAssets(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalevacuatedequipment",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+count+"</td></tr>");
		parameters = new Hashtable();
		parameters.put("oc_asset_comment7","notequals;'1'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_asset_nomenclature","like;'E%'");
		total=Util.countAssets(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totaldysfunctional",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+total+"</td></tr>");
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","fractionevacuated",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+new DecimalFormat("#0.00").format(new Double(count)*100/new Double(total))+"%</td></tr>");
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'E%'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_maintenanceplan_type","equals;'2'");
		parameters.put("length(oc_maintenanceoperation_supplier)","copy;>0");
		parameters.put("oc_maintenanceoperation_date","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_maintenanceoperation_date","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		count=Util.countMaintenanceOperations(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalexternalpreventative",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+count+"</td></tr>");
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'E%'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_maintenanceplan_type","equals;'3'");
		parameters.put("length(oc_maintenanceoperation_supplier)","copy;>0");
		parameters.put("oc_maintenanceoperation_date","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_maintenanceoperation_date","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		count=Util.countMaintenanceOperations(parameters);
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalexternalcorrective",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+count+"</td></tr>");
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'E%'");
		parameters.put("oc_asset_service","like;'"+serviceUid+"%'");
		parameters.put("oc_maintenanceplan_type","equals;'3'");
		parameters.put("oc_maintenanceoperation_date","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_maintenanceoperation_date","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		String s=Util.analyzeMaintenanceOperations(parameters,"sum(oc_maintenanceoperation_comment1)+sum(oc_maintenanceoperation_comment2)+sum(oc_maintenanceoperation_comment3)+sum(oc_maintenanceoperation_comment4)");
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalcorrectivecost",sWebLanguage)+"</td><td class='admin2' colspan='2'>"+checkString(s)+"</td></tr>");
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'E%'");
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
		int[] nFunctionalStatus = new int[5];
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
			//Was there an intervention action planned in the selected period?
			//Check if any existing intervention had a nextdate in this period
			boolean bMaintenancePlanDue=false,bInit=false;
			PreparedStatement ps2 = conn.prepareStatement("select * from oc_maintenanceoperations where oc_maintenanceoperation_maintenanceplanuid=?");
			ps2.setString(1,maintenancePlanUid);
			ResultSet rs2 = ps2.executeQuery();
			while(rs2.next()){
				bInit=true;
				java.util.Date d = rs2.getDate("oc_maintenanceoperation_nextdate");
				if(d!=null && !d.before(dBegin) && d.before(dEnd)){
					bMaintenancePlanDue=true;
				}
			}
			rs2.close();
			ps2.close();
			if(!bInit){
				bMaintenancePlanDue=true;
			}
			if(bMaintenancePlanDue){
				String functionalStatus=SH.c(rs.getString("oc_asset_comment7"));
				if(functionalStatus.equalsIgnoreCase("1")){
					nFunctionalStatus[1]++;
				}
				else if(functionalStatus.equalsIgnoreCase("2")){
					nFunctionalStatus[2]++;
				}
				else if(functionalStatus.equalsIgnoreCase("3")){
					nFunctionalStatus[3]++;
				}
				else if(functionalStatus.equalsIgnoreCase("4")){
					nFunctionalStatus[4]++;
				}
				else{
					nFunctionalStatus[0]++;
				}
				plans.add(maintenancePlanUid);
			}
		}
		rs.close();
		ps.close();
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalpreventativeforeseen",sWebLanguage)+"</td><td class='admin2'><span id='perftotal'><a href='javascript:showPreventativeMaintenanceList()'>"+plans.size()+"</a></span></td><td class='admin2' rowspan='4'><table><tr><td width='200px'><canvas id='performanceChart' width='200px' height='200px'></canvas></td><td width='200px'><canvas id='functionalStatusChart' width='200px' height='200px'></canvas></td></tr></table></td></tr>");
		if(preventativeoperations>plans.size()){
			preventativeoperations=plans.size();
		}
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","totalpreventativefraction",sWebLanguage)+"</td><td class='admin2'><b><span  style='font-size: 14px' id='perfseen'>"+new DecimalFormat("#0.00").format(new Double(preventativeoperations)*100/new Double(plans.size()))+"</span>%</b></td></tr>");
		plans = new HashSet();
		sSql = 	"select * from oc_assets a,oc_maintenanceplans p where oc_asset_objectid=replace(oc_maintenanceplan_assetuid,'"+sid+".','') and"+
				" oc_maintenanceplan_type=3 and oc_asset_service like '"+serviceUid+"%' and oc_maintenanceplan_startdate>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"' and oc_maintenanceplan_startdate<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"' and (oc_maintenanceplan_enddate is null or oc_maintenanceplan_enddate>'"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"')";
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
					if(d!=null && !d.before(requestDate)){
						c++;
						days+=(d.getTime()-requestDate.getTime());
					}
				}
				rs2.close();
				ps2.close();
				ps2 = conn.prepareStatement("select min(oc_maintenanceoperation_date) date from oc_maintenanceoperations where oc_maintenanceoperation_result='ok' and oc_maintenanceoperation_maintenanceplanuid=?");
				ps2.setString(1,maintenancePlanUid);
				rs2 = ps2.executeQuery();
				if(rs2.next()){
					java.util.Date d = rs2.getTimestamp("date");
					if(d!=null && !d.before(requestDate)){
						c++;
						successdays+=(d.getTime()-requestDate.getTime());
					}
				}
				rs2.close();
				ps2.close();
			}
		}
		rs.close();
		ps.close();
		conn.close();
		out.println("<input type='hidden' name='functionalStatus' id='functionalStatus' value='"+nFunctionalStatus[0]+","+nFunctionalStatus[1]+","+nFunctionalStatus[2]+","+nFunctionalStatus[3]+","+nFunctionalStatus[4]+"'/>");
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","meanresponsetime",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("#0.00").format((new Double(days)/new Double(c))/ScreenHelper.getTimeDay())+" "+getTran(request,"web","days",sWebLanguage)+"</td></tr>");
		out.println("<tr><td class='admin' width='30%'>"+getTran(request,"asset","meansuccessresponsetime",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("#0.00").format((new Double(successdays)/new Double(c))/ScreenHelper.getTimeDay())+" "+getTran(request,"web","days",sWebLanguage)+"</td></tr>");
	%>
</table>