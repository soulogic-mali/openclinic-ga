<%@page import="be.openclinic.assets.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String serviceuid=SH.c((String)session.getAttribute("activeService"));
	String begin = SH.p(request,"begin");
	java.util.Date dBegin=SH.parseDate(begin,"yyyy-MM-dd");
	String end = SH.p(request,"end");
	java.util.Date dEnd=SH.parseDate(end,"yyyy-MM-dd");
	Hashtable parameters = new Hashtable();
	int count =0, total=0;
%>
<table width='100%'>
	<tr>
		<td colspan='2' class='mobileadmin' style='font-size:5vw;'>
			<%=getTranNoLink("web","infrastructure",sWebLanguage)%>
		</td>
	</tr>
	<%
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'I.%'");
		parameters.put("oc_asset_service","like;'"+serviceuid+"%'");
		total=Util.countAssets(parameters);
	%>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("asset","totalinfrastructure",sWebLanguage)%>
		</td>
		<td class='mobileadmin2'><span id='infratotalstate' style='font-size:4vw;font-weight: bold'><%=total %></span></td>
	</tr>
	<%
		parameters = new Hashtable();
		parameters.put("oc_asset_comment9","in;'0','1'");
		parameters.put("oc_asset_service","like;'"+serviceuid+"%'");
		parameters.put("oc_asset_nomenclature","like;'I.%'");
		count=Util.countAssets(parameters);
	%>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("asset","totalingoodstate",sWebLanguage)%>
		</td>
		<td class='mobileadmin2'><span id='infragoodstate' style='font-size:4vw;font-weight: bold'><%=count %></span></td>
	</tr>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("asset","fractioningoodstate",sWebLanguage)%>
		</td>
		<td class='mobileadmin2' style='font-size:5vw;font-weight: bold'><%=new DecimalFormat("#0.#").format(new Double(count)*100/new Double(total)) %>%</td>
	</tr>
	<tr>
		<td colspan='2'><canvas id='infraStateChart'></canvas></td>
	</tr>
	<%
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'I.%'");
		parameters.put("oc_asset_service","like;'"+serviceuid+"%'");
		parameters.put("oc_maintenanceplan_type","equals;'2'");
		parameters.put("oc_maintenanceoperation_date","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_maintenanceoperation_date","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		count=Util.countMaintenanceOperations(parameters);
	%>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("asset","totalpreventiveoperations",sWebLanguage)%>
		</td>
		<td class='mobileadmin2'><span id='infrapreventative' style='font-size:4vw;font-weight: bold'><%=count %></span></td>
	</tr>
	<%
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'I.%'");
		parameters.put("oc_asset_service","like;'"+serviceuid+"%'");
		parameters.put("oc_maintenanceplan_type","equals;'3'");
		parameters.put("oc_maintenanceoperation_date","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_maintenanceoperation_date","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		count=Util.countMaintenanceOperations(parameters);
	%>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("asset","totalcorrectiveoperations",sWebLanguage)%>
		</td>
		<td class='mobileadmin2'><span id='infracorrective' style='font-size:4vw;font-weight: bold'><%=count %></span></td>
	</tr>
	<%
		parameters.put("oc_maintenanceoperation_result","equals;'ok'");
		count=Util.countMaintenanceOperations(parameters);
	%>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("asset","totalsuccesfulcorrectiveoperations",sWebLanguage)%>
		</td>
		<td class='mobileadmin2'><span id='infracorrectivesuccess' style='font-size:4vw;font-weight: bold'><%=count %></span></td>
	</tr>
	<%
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'I.%'");
		parameters.put("oc_asset_service","like;'"+serviceuid+"%'");
		parameters.put("oc_asset_comment13 like '%/%/%' and str_to_date(oc_asset_comment13,'%d/%m/%Y')","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_asset_comment13 like '%/%/%' and str_to_date(oc_asset_comment13,'%d/%m/%Y')","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		count=Util.countAssets(parameters);
	%>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("asset","totalupdates",sWebLanguage)%>
		</td>
		<td class='mobileadmin2'><span style='font-size:4vw;font-weight: bold'><%=count %></span></td>
	</tr>
	<tr>
		<td colspan='2' class='mobileadmin' style='font-size:5vw;'>
			<%=getTranNoLink("web","equipment",sWebLanguage)%>
		</td>
	</tr>
	<%
		parameters = new Hashtable();
		parameters.put("oc_asset_service","like;'"+serviceuid+"%'");
		parameters.put("oc_asset_nomenclature","like;'E%'");
		total=Util.countAssets(parameters);
	%>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("asset","totalequipment",sWebLanguage)%>
		</td>
		<td class='mobileadmin2'><span id='mattotalstate' style='font-size:4vw;font-weight: bold'><%=total %></span></td>
	</tr>
	<%
		parameters = new Hashtable();
		parameters.put("oc_asset_comment7","equals;'1'");
		parameters.put("oc_asset_service","like;'"+serviceuid+"%'");
		parameters.put("oc_asset_nomenclature","like;'E%'");
		count=Util.countAssets(parameters);
	%>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("asset","totaloperational",sWebLanguage)%>
		</td>
		<td class='mobileadmin2'><span id='matgoodstate' style='font-size:4vw;font-weight: bold'><%=count %></span></td>
	</tr>
	<tr>
		<td colspan='2'><canvas id='matStateChart'></canvas></td>
	</tr>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("asset","fractionoperational",sWebLanguage)%>
		</td>
		<td class='mobileadmin2'><span style='font-size:5vw;font-weight: bold'><%=new DecimalFormat("#0.#").format(new Double(count)*100/new Double(total)) %>%</span></td>
	</tr>
	<%
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'E%'");
		parameters.put("oc_asset_service","like;'"+serviceuid+"%'");
		parameters.put("oc_maintenanceplan_type","equals;'2'");
		parameters.put("oc_maintenanceoperation_date","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_maintenanceoperation_date","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		int preventativeoperations=Util.countMaintenanceOperations(parameters);
	%>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("asset","totalpreventiveoperations",sWebLanguage)%>
		</td>
		<td class='mobileadmin2'><span id='matpreventative' style='font-size:4vw;font-weight: bold'><%=preventativeoperations %></span></td>
	</tr>
	<%
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'E%'");
		parameters.put("oc_asset_service","like;'"+serviceuid+"%'");
		parameters.put("oc_maintenanceplan_type","equals;'3'");
		parameters.put("oc_maintenanceoperation_date","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_maintenanceoperation_date","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		count=Util.countMaintenanceOperations(parameters);
	%>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("asset","totalcorrectiveoperations",sWebLanguage)%>
		</td>
		<td class='mobileadmin2'><span id='matcorrective' style='font-size:4vw;font-weight: bold'><%=count %></span></td>
	</tr>
	<tr>
		<td colspan='2'><canvas id='matOperationChart'></canvas></td>
	</tr>
	<%
		parameters.put("oc_maintenanceoperation_result","equals;'ok'");
		count=Util.countMaintenanceOperations(parameters);
	%>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("asset","totalsuccesfulcorrectiveoperations",sWebLanguage)%>
		</td>
		<td class='mobileadmin2'><span id='matcorrectivesuccess' style='font-size:4vw;font-weight: bold'><%=count %></span></td>
	</tr>
	<tr>
		<td colspan='2'><canvas id='matSuccessChart'></canvas></td>
	</tr>
	<%
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'E%'");
		parameters.put("oc_asset_service","like;'"+serviceuid+"%'");
		parameters.put("oc_asset_comment13 like '%/%/%' and str_to_date(oc_asset_comment13,'%d/%m/%Y')","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_asset_comment13 like '%/%/%' and str_to_date(oc_asset_comment13,'%d/%m/%Y')","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		count=Util.countAssets(parameters);
	%>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("asset","totalnewequipment",sWebLanguage)%>
		</td>
		<td class='mobileadmin2'><span style='font-size:4vw;font-weight: bold'><%=count %></span></td>
	</tr>
	<%
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'E%'");
		parameters.put("oc_asset_service","like;'"+serviceuid+"%'");
		parameters.put("oc_asset_saledate","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_asset_saledate","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		count=Util.countAssets(parameters);
	%>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("asset","totalevacuatedequipment",sWebLanguage)%>
		</td>
		<td class='mobileadmin2'><span style='font-size:4vw;font-weight: bold'><%=count %></span></td>
	</tr>
	<%
		parameters = new Hashtable();
		parameters.put("oc_asset_comment7","notequals;'1'");
		parameters.put("oc_asset_service","like;'"+serviceuid+"%'");
		parameters.put("oc_asset_nomenclature","like;'E%'");
		total=Util.countAssets(parameters);
	%>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("asset","totaldysfunctional",sWebLanguage)%>
		</td>
		<td class='mobileadmin2'><span style='font-size:4vw;font-weight: bold'><%=total %></span></td>
	</tr>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("asset","fractionevacuated",sWebLanguage)%>
		</td>
		<td class='mobileadmin2'><span style='font-size:4vw;font-weight: bold'><%=new DecimalFormat("#0.#").format(new Double(count)*100/new Double(total)) %>%</span></td>
	</tr>
	<%
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'E%'");
		parameters.put("oc_asset_service","like;'"+serviceuid+"%'");
		parameters.put("oc_maintenanceplan_type","equals;'2'");
		parameters.put("length(oc_maintenanceoperation_supplier)","copy;>0");
		parameters.put("oc_maintenanceoperation_date","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_maintenanceoperation_date","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		count=Util.countMaintenanceOperations(parameters);
	%>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("asset","totalexternalpreventative",sWebLanguage)%>
		</td>
		<td class='mobileadmin2'><span style='font-size:4vw;font-weight: bold'><%=count %></span></td>
	</tr>
	<%
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'E%'");
		parameters.put("oc_asset_service","like;'"+serviceuid+"%'");
		parameters.put("oc_maintenanceplan_type","equals;'3'");
		parameters.put("length(oc_maintenanceoperation_supplier)","copy;>0");
		parameters.put("oc_maintenanceoperation_date","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_maintenanceoperation_date","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		count=Util.countMaintenanceOperations(parameters);
	%>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("asset","totalexternalcorrective",sWebLanguage)%>
		</td>
		<td class='mobileadmin2'><span style='font-size:4vw;font-weight: bold'><%=count %></span></td>
	</tr>
	<%
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'E%'");
		parameters.put("oc_asset_service","like;'"+serviceuid+"%'");
		parameters.put("oc_maintenanceplan_type","equals;'3'");
		parameters.put("oc_maintenanceoperation_date","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_maintenanceoperation_date","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		String s=Util.analyzeMaintenanceOperations(parameters,"sum(oc_maintenanceoperation_comment1)+sum(oc_maintenanceoperation_comment2)+sum(oc_maintenanceoperation_comment3)+sum(oc_maintenanceoperation_comment4)");
	%>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("asset","totalcorrectivecost",sWebLanguage)%>
		</td>
		<td class='mobileadmin2'><span style='font-size:4vw;font-weight: bold'><%=checkString(s) %></span></td>
	</tr>
	<%
		parameters = new Hashtable();
		parameters.put("oc_asset_nomenclature","like;'E%'");
		parameters.put("oc_asset_service","like;'"+serviceuid+"%'");
		parameters.put("oc_maintenanceplan_type","equals;'2'");
		parameters.put("oc_maintenanceoperation_date","copy;>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"'");
		parameters.put(" oc_maintenanceoperation_date","copy;<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"'");
		s=Util.analyzeMaintenanceOperations(parameters,"sum(oc_maintenanceoperation_comment1)+sum(oc_maintenanceoperation_comment2)+sum(oc_maintenanceoperation_comment3)+sum(oc_maintenanceoperation_comment4)");
	%>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("asset","totalpreventativecost",sWebLanguage)%>
		</td>
		<td class='mobileadmin2'><span style='font-size:4vw;font-weight: bold'><%=checkString(s) %></span></td>
	</tr>
	<tr>
		<td colspan='2' class='mobileadmin' style='font-size:5vw;'>
			<%=getTranNoLink("web","performances",sWebLanguage)%>
		</td>
	</tr>
	<%
		//First check how many preventative maintenance operations were scheduled in the period
		HashSet plans = new HashSet();
		int[] nFunctionalStatus = new int[5];
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		String sid=MedwanQuery.getInstance().getServerId()+"";
		String sSql = 	"select * from oc_assets a,oc_maintenanceplans p where oc_asset_objectid=replace(oc_maintenanceplan_assetuid,'"+sid+".','') and"+
								" oc_maintenanceplan_type=2 and oc_asset_service like '"+serviceuid+"%' and (oc_maintenanceplan_enddate is null or oc_maintenanceplan_enddate>'"+
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
	%>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("asset","totalpreventativeforeseen",sWebLanguage)%>
		</td>
		<td class='mobileadmin2'><span style='font-size:4vw;font-weight: bold'><%=plans.size() %></span></td>
	</tr>
	<%
		if(preventativeoperations>plans.size()){
			preventativeoperations=plans.size();
		}
	%>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("asset","totalpreventativefraction",sWebLanguage)%>
		</td>
		<td class='mobileadmin2'><span id='perfseen' style='font-size:5vw;font-weight: bold'><%=new DecimalFormat("#0.#").format(new Double(preventativeoperations)*100/new Double(plans.size())) %></span><span style='font-size:5vw;font-weight: bold'>%</span></td>
	</tr>
	<tr>
		<td colspan='2'><canvas id='performanceChart'></canvas></td>
	</tr>
	<tr>
		<td colspan='2'><canvas id='functionalStatusChart'></canvas></td>
	</tr>
	<%
		plans = new HashSet();
		sSql = 	"select * from oc_assets a,oc_maintenanceplans p where oc_asset_objectid=replace(oc_maintenanceplan_assetuid,'"+sid+".','') and"+
				" oc_maintenanceplan_type=3 and oc_asset_service like '"+serviceuid+"%' and oc_maintenanceplan_startdate>='"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"' and oc_maintenanceplan_startdate<'"+new SimpleDateFormat("yyyy-MM-dd").format(dEnd)+"' and (oc_maintenanceplan_enddate is null or oc_maintenanceplan_enddate>'"+new SimpleDateFormat("yyyy-MM-dd").format(dBegin)+"')";
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
	%>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<input type='hidden' name='functionalStatus' id='functionalStatus' value='<%=nFunctionalStatus[0]+","+nFunctionalStatus[1]+","+nFunctionalStatus[2]+","+nFunctionalStatus[3]+","+nFunctionalStatus[4]%>'/>
			<%=getTranNoLink("asset","meanresponsetime",sWebLanguage)%>
		</td>
		<td class='mobileadmin2'><span style='font-size:5vw;font-weight: bold'><%=c==0?"?":new DecimalFormat("#0.#").format((new Double(days)/new Double(c))/ScreenHelper.getTimeDay())+" "+getTran(request,"web","days",sWebLanguage) %></span></td>
	</tr>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("asset","meansuccessresponsetime",sWebLanguage)%>
		</td>
		<td class='mobileadmin2'><span style='font-size:5vw;font-weight: bold'><%=c==0?"?":new DecimalFormat("#0.#").format((new Double(successdays)/new Double(c))/ScreenHelper.getTimeDay())+" "+getTran(request,"web","days",sWebLanguage) %></span></td>
	</tr>
</table>