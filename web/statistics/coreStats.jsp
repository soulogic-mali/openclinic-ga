<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<head>
    <%=sJSTOGGLE%>
    <%=sJSFORM%>
    <%=sJSPOPUPMENU%>
    <%//=sCSSNORMAL%>
    <%=sJSPROTOTYPE %>
    <%=sJSAXMAKER %>
    <%=sJSPROTOCHART %>
    <!--[if IE]>
    <%=sJSEXCANVAS %>
    <![endif]-->
    <%=sJSFUSIONCHARTS%>
    <%=sJSAXMAKER %>
    <%=sJSSCRPTACULOUS %>
    <%=sJSMODALBOX%>
    <%=sCSSDATACENTER%>
    <%=sCSSMODALBOXDATACENTER%>
    <!--[if IE]>
    <%=sCSSDATACENTERIE%>
     <![endif]-->
</head>

<table width='100%'>
<%
try{
	String start = request.getParameter("start");
	String end = request.getParameter("end");
	java.util.Date dStart = new SimpleDateFormat("dd/MM/yyyy").parse(start);
	java.util.Date dEnd = new SimpleDateFormat("dd/MM/yyyy").parse(end);
	long day=3600*24*1000;
	double duration=(dEnd.getTime()-dStart.getTime())/day;
	
	out.println("<tr class='admin'><td colspan='2'>"+start+" - "+end+"</td></tr>");
	//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	out.println("<tr class='admin'><td colspan='2'>"+getTran(request,"web","encounters",sWebLanguage)+"</td></tr>");
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	String sql = "select count(*) total from oc_encounters where oc_encounter_type='visit' and oc_encounter_begindate>=? and oc_encounter_begindate<?";
	PreparedStatement ps = conn.prepareStatement(sql);
	ps.setDate(1,new java.sql.Date(dStart.getTime()));
	ps.setDate(2,new java.sql.Date(dEnd.getTime()));
	ResultSet rs = ps.executeQuery();
	int totalvisits=0;
	if(rs.next()){
		totalvisits=rs.getInt("total");
		out.println("<tr><td class='admin'>"+getTran(request,"web","visits",sWebLanguage)+"</td><td class='admin2'><a href='javascript:coreValueGraph(\"visits\");void(0);'>"+totalvisits+"</a></td></tr>");
	}
	rs.close();
	ps.close();
	
	sql = "select count(*) total from oc_encounters where oc_encounter_type='admission' and oc_encounter_begindate>=? and oc_encounter_begindate<?";
	ps = conn.prepareStatement(sql);
	ps.setDate(1,new java.sql.Date(dStart.getTime()));
	ps.setDate(2,new java.sql.Date(dEnd.getTime()));
	rs = ps.executeQuery();
	int totaladmissions=0;
	if(rs.next()){
		totaladmissions=rs.getInt("total");
		out.println("<tr><td class='admin'>"+getTran(request,"web","admissions",sWebLanguage)+"</td><td class='admin2'><a href='javascript:coreValueGraph(\"admissions\");void(0);'>"+totaladmissions+"</a></td></tr>");
	}
	rs.close();
	ps.close();
	
	sql = "select count(distinct oc_encounter_patientuid) total from oc_encounters where oc_encounter_begindate>=? and oc_encounter_begindate<?";
	ps = conn.prepareStatement(sql);
	ps.setDate(1,new java.sql.Date(dStart.getTime()));
	ps.setDate(2,new java.sql.Date(dEnd.getTime()));
	rs = ps.executeQuery();
	int totalpatients=0;
	if(rs.next()){
		totalpatients=rs.getInt("total");
		out.println("<tr><td class='admin'>"+getTran(request,"web","patients",sWebLanguage)+"</td><td class='admin2'><a href='javascript:coreValueGraph(\"patients\");void(0);'>"+totalpatients+"</a></td></tr>");
	}
	rs.close();
	ps.close();

	//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	out.println("<tr class='admin'><td colspan='2'>"+getTran(request,"web","informationsharing",sWebLanguage)+"</td></tr>");
	sql = "select avg(users) total from (select count(*) users,encounteruid from "+
			  " (select oc_encounter_updateuid uid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".'"+MedwanQuery.getInstance().concatSign()+MedwanQuery.getInstance().convert("varchar", "oc_encounter_objectid")+" encounteruid from oc_encounters where oc_encounter_begindate>=? and oc_encounter_begindate<?"+
			  " union"+
			  " select oc_debet_updateuid uid,oc_debet_encounteruid encounteruid from oc_debets,oc_encounters where  oc_encounter_objectid=replace(oc_debet_encounteruid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and oc_debet_date>=? and oc_debet_date<?"+
			  " union"+
			  " select userid uid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".'"+MedwanQuery.getInstance().concatSign()+MedwanQuery.getInstance().convert("varchar", "oc_encounter_objectid")+" encounteruid from transactions a,items b,oc_encounters c where a.serverid=b.serverid and a.transactionid=b.transactionid and b.type='be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID' and oc_encounter_objectid=replace(b.value,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and a.updatetime>=? and a.updatetime<? and oc_encounter_begindate>=? and oc_encounter_begindate<?) q"+
			  " group by encounteruid) r";
	ps = conn.prepareStatement(sql);
	ps.setDate(1,new java.sql.Date(dStart.getTime()));
	ps.setDate(2,new java.sql.Date(dEnd.getTime()));
	ps.setDate(3,new java.sql.Date(dStart.getTime()));
	ps.setDate(4,new java.sql.Date(dEnd.getTime()));
	ps.setDate(5,new java.sql.Date(dStart.getTime()));
	ps.setDate(6,new java.sql.Date(dEnd.getTime()));
	ps.setDate(7,new java.sql.Date(dStart.getTime()));
	ps.setDate(8,new java.sql.Date(dEnd.getTime()));
	rs = ps.executeQuery();
	if(rs.next()){
		out.println("<tr><td class='admin'>"+getTran(request,"web","userdensity",sWebLanguage)+"</td><td class='admin2'><a href='javascript:coreValueGraph(\"userdensity\");void(0);'>"+new DecimalFormat("#.00").format(rs.getDouble("total"))+"</a></td></tr>");
	}
	rs.close();
	ps.close();

	sql = "select avg(users) total from (select count(*) users,encounteruid from "+
			  " (select oc_encounter_updateuid uid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".'"+MedwanQuery.getInstance().concatSign()+MedwanQuery.getInstance().convert("varchar", "oc_encounter_objectid")+" encounteruid from oc_encounters where oc_encounter_type='visit' and oc_encounter_begindate>=? and oc_encounter_begindate<?"+
			  " union"+
			  " select oc_debet_updateuid uid,oc_debet_encounteruid encounteruid from oc_debets,oc_encounters where  oc_encounter_objectid=replace(oc_debet_encounteruid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and oc_encounter_type='visit' and oc_debet_date>=? and oc_debet_date<?"+
			  " union"+
			  " select userid uid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".'"+MedwanQuery.getInstance().concatSign()+MedwanQuery.getInstance().convert("varchar", "oc_encounter_objectid")+" encounteruid from transactions a,items b,oc_encounters c where oc_encounter_type='visit' and a.serverid=b.serverid and a.transactionid=b.transactionid and b.type='be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID' and oc_encounter_objectid=replace(b.value,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and a.updatetime>=? and a.updatetime<? and oc_encounter_begindate>=? and oc_encounter_begindate<?) q"+
			  " group by encounteruid) r";
	ps = conn.prepareStatement(sql);
	ps.setDate(1,new java.sql.Date(dStart.getTime()));
	ps.setDate(2,new java.sql.Date(dEnd.getTime()));
	ps.setDate(3,new java.sql.Date(dStart.getTime()));
	ps.setDate(4,new java.sql.Date(dEnd.getTime()));
	ps.setDate(5,new java.sql.Date(dStart.getTime()));
	ps.setDate(6,new java.sql.Date(dEnd.getTime()));
	ps.setDate(7,new java.sql.Date(dStart.getTime()));
	ps.setDate(8,new java.sql.Date(dEnd.getTime()));
	rs = ps.executeQuery();
	if(rs.next()){
		out.println("<tr><td class='admin'>"+getTran(request,"web","userdensity",sWebLanguage)+ " - "+getTran(request,"web","visits",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("#.00").format(rs.getDouble("total"))+"</td></tr>");
	}
	rs.close();
	ps.close();

	sql = "select avg(users) total from (select count(*) users,encounteruid from "+
			  " (select oc_encounter_updateuid uid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".'"+MedwanQuery.getInstance().concatSign()+MedwanQuery.getInstance().convert("varchar", "oc_encounter_objectid")+" encounteruid from oc_encounters where oc_encounter_type='admission' and oc_encounter_begindate>=? and oc_encounter_begindate<?"+
			  " union"+
			  " select oc_debet_updateuid uid,oc_debet_encounteruid encounteruid from oc_debets,oc_encounters where  oc_encounter_objectid=replace(oc_debet_encounteruid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and oc_encounter_type='admission' and oc_debet_date>=? and oc_debet_date<?"+
			  " union"+
			  " select userid uid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".'"+MedwanQuery.getInstance().concatSign()+MedwanQuery.getInstance().convert("varchar", "oc_encounter_objectid")+" encounteruid from transactions a,items b,oc_encounters c where oc_encounter_type='admission' and a.serverid=b.serverid and a.transactionid=b.transactionid and b.type='be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID' and oc_encounter_objectid=replace(b.value,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and a.updatetime>=? and a.updatetime<? and oc_encounter_begindate>=? and oc_encounter_begindate<?) q"+
			  " group by encounteruid) r";
	ps = conn.prepareStatement(sql);
	ps.setDate(1,new java.sql.Date(dStart.getTime()));
	ps.setDate(2,new java.sql.Date(dEnd.getTime()));
	ps.setDate(3,new java.sql.Date(dStart.getTime()));
	ps.setDate(4,new java.sql.Date(dEnd.getTime()));
	ps.setDate(5,new java.sql.Date(dStart.getTime()));
	ps.setDate(6,new java.sql.Date(dEnd.getTime()));
	ps.setDate(7,new java.sql.Date(dStart.getTime()));
	ps.setDate(8,new java.sql.Date(dEnd.getTime()));
	rs = ps.executeQuery();
	if(rs.next()){
		out.println("<tr><td class='admin'>"+getTran(request,"web","userdensity",sWebLanguage)+ " - "+getTran(request,"web","admissions",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("#.00").format(rs.getDouble("total"))+"</td></tr>");
	}
	rs.close();
	ps.close();

	//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	out.println("<tr class='admin'><td colspan='2'>"+getTran(request,"web","financial",sWebLanguage)+"</td></tr>");
	sql = "select sum(oc_debet_amount) total from oc_debets,oc_encounters,oc_patientinvoices where oc_patientinvoice_objectid=replace(oc_debet_patientinvoiceuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and oc_patientinvoice_status='closed' and oc_encounter_objectid=replace(oc_debet_encounteruid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and oc_encounter_type='visit' and oc_debet_date>=? and oc_debet_date<?";
	ps = conn.prepareStatement(sql);
	ps.setDate(1,new java.sql.Date(dStart.getTime()));
	ps.setDate(2,new java.sql.Date(dEnd.getTime()));
	rs = ps.executeQuery();
	double closedinvoicedvisits=0;
	if(rs.next()){
		closedinvoicedvisits=rs.getInt("total");
	}
	rs.close();
	ps.close();
	sql = "select sum(oc_debet_amount) total from oc_debets,oc_encounters,oc_patientinvoices where oc_patientinvoice_objectid=replace(oc_debet_patientinvoiceuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and oc_encounter_objectid=replace(oc_debet_encounteruid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and oc_encounter_type='visit' and oc_debet_date>=? and oc_debet_date<?";
	ps = conn.prepareStatement(sql);
	ps.setDate(1,new java.sql.Date(dStart.getTime()));
	ps.setDate(2,new java.sql.Date(dEnd.getTime()));
	rs = ps.executeQuery();
	double invoicedvisits=0;
	if(rs.next()){
		invoicedvisits=rs.getInt("total");
		out.println("<tr><td class='admin'>"+getTran(request,"web","invoicedpatients",sWebLanguage)+ " - "+getTran(request,"web","visits",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("###,##0.00").format(invoicedvisits)+" "+MedwanQuery.getInstance().getConfigString("currency")+" ("+getTran(request,"finance.patientinvoice.status","closed",sWebLanguage)+": "+new DecimalFormat("###,##0.00").format(closedinvoicedvisits)+" "+MedwanQuery.getInstance().getConfigString("currency")+")</td></tr>");
	}
	rs.close();
	ps.close();

	sql = "select sum(oc_debet_amount) total from oc_debets,oc_encounters,oc_patientinvoices where oc_patientinvoice_objectid=replace(oc_debet_patientinvoiceuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and oc_patientinvoice_status='closed' and oc_encounter_objectid=replace(oc_debet_encounteruid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and oc_encounter_type='admission' and oc_debet_date>=? and oc_debet_date<?";
	ps = conn.prepareStatement(sql);
	ps.setDate(1,new java.sql.Date(dStart.getTime()));
	ps.setDate(2,new java.sql.Date(dEnd.getTime()));
	rs = ps.executeQuery();
	double closedinvoicedadmissions=0;
	if(rs.next()){
		closedinvoicedadmissions=rs.getInt("total");
	}
	rs.close();
	ps.close();
	sql = "select sum(oc_debet_amount) total from oc_debets,oc_encounters,oc_patientinvoices where oc_patientinvoice_objectid=replace(oc_debet_patientinvoiceuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and oc_encounter_objectid=replace(oc_debet_encounteruid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and oc_encounter_type='admission' and oc_debet_date>=? and oc_debet_date<?";
	ps = conn.prepareStatement(sql);
	ps.setDate(1,new java.sql.Date(dStart.getTime()));
	ps.setDate(2,new java.sql.Date(dEnd.getTime()));
	rs = ps.executeQuery();
	double invoicedadmissions=0;
	if(rs.next()){
		invoicedadmissions=rs.getInt("total");
		out.println("<tr><td class='admin'>"+getTran(request,"web","invoicedpatients",sWebLanguage)+ " - "+getTran(request,"web","admissions",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("###,##0.00").format(invoicedadmissions)+" "+MedwanQuery.getInstance().getConfigString("currency")+" ("+getTran(request,"finance.patientinvoice.status","closed",sWebLanguage)+": "+new DecimalFormat("###,##0.00").format(closedinvoicedadmissions)+" "+MedwanQuery.getInstance().getConfigString("currency")+")</td></tr>");
	}
	rs.close();
	ps.close();

	out.println("<tr><td class='admin'>"+getTran(request,"web","invoicedpatients",sWebLanguage)+ " - "+getTran(request,"web","total",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("###,##0.00").format(invoicedvisits+invoicedadmissions)+" "+MedwanQuery.getInstance().getConfigString("currency")+" ("+new DecimalFormat("###,##0.00").format((invoicedvisits+invoicedadmissions)*365/duration)+" "+MedwanQuery.getInstance().getConfigString("currency")+")</td></tr>");
	out.println("<tr><td class='admin'>"+getTran(request,"web","closedinvoicedpatients",sWebLanguage)+ " - "+getTran(request,"web","total",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("###,##0.00").format(closedinvoicedvisits+closedinvoicedadmissions)+" "+MedwanQuery.getInstance().getConfigString("currency")+" ("+new DecimalFormat("###,##0.00").format((closedinvoicedvisits+closedinvoicedadmissions)*365/duration)+" "+MedwanQuery.getInstance().getConfigString("currency")+")</td></tr>");

	sql = "select sum(oc_debet_insuraramount) total1,sum(oc_debet_extrainsuraramount) total2,sum(oc_debet_extrainsuraramount2) total3 from oc_debets,oc_encounters,oc_patientinvoices where oc_patientinvoice_objectid=replace(oc_debet_patientinvoiceuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and oc_patientinvoice_status='closed' and oc_encounter_objectid=replace(oc_debet_encounteruid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and oc_encounter_type='visit' and oc_debet_date>=? and oc_debet_date<?";
	ps = conn.prepareStatement(sql);
	ps.setDate(1,new java.sql.Date(dStart.getTime()));
	ps.setDate(2,new java.sql.Date(dEnd.getTime()));
	rs = ps.executeQuery();
	double closedinvoicedinsurervisits=0;
	if(rs.next()){
		closedinvoicedinsurervisits=rs.getDouble("total1")+rs.getDouble("total2")+rs.getDouble("total3");
	}
	rs.close();
	ps.close();
	sql = "select sum(oc_debet_insuraramount) total1,sum(oc_debet_extrainsuraramount) total2,sum(oc_debet_extrainsuraramount2) total3 from oc_debets,oc_encounters,oc_patientinvoices where oc_patientinvoice_objectid=replace(oc_debet_patientinvoiceuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and oc_encounter_objectid=replace(oc_debet_encounteruid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and oc_encounter_type='visit' and oc_debet_date>=? and oc_debet_date<?";
	ps = conn.prepareStatement(sql);
	ps.setDate(1,new java.sql.Date(dStart.getTime()));
	ps.setDate(2,new java.sql.Date(dEnd.getTime()));
	rs = ps.executeQuery();
	double invoicedinsurervisits=0;
	if(rs.next()){
		invoicedinsurervisits=rs.getInt("total1")+rs.getInt("total2")+rs.getInt("total3");
		out.println("<tr><td class='admin'>"+getTran(request,"web","invoicedinsurers",sWebLanguage)+ " - "+getTran(request,"web","visits",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("###,##0.00").format(invoicedinsurervisits)+" "+MedwanQuery.getInstance().getConfigString("currency")+" ("+getTran(request,"finance.patientinvoice.status","closed",sWebLanguage)+": "+new DecimalFormat("###,##0.00").format(closedinvoicedinsurervisits)+" "+MedwanQuery.getInstance().getConfigString("currency")+")</td></tr>");
	}
	rs.close();
	ps.close();

	sql = "select sum(oc_debet_insuraramount) total1,sum(oc_debet_extrainsuraramount) total2,sum(oc_debet_extrainsuraramount2) total3 from oc_debets,oc_encounters,oc_patientinvoices where oc_patientinvoice_objectid=replace(oc_debet_patientinvoiceuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and oc_patientinvoice_status='closed' and oc_encounter_objectid=replace(oc_debet_encounteruid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and oc_encounter_type='admission' and oc_debet_date>=? and oc_debet_date<?";
	ps = conn.prepareStatement(sql);
	ps.setDate(1,new java.sql.Date(dStart.getTime()));
	ps.setDate(2,new java.sql.Date(dEnd.getTime()));
	rs = ps.executeQuery();
	double closedinvoicedinsureradmissions=0;
	if(rs.next()){
		closedinvoicedinsureradmissions=rs.getFloat("total1")+rs.getFloat("total2")+rs.getFloat("total3");
	}
	rs.close();
	ps.close();
	sql = "select sum(oc_debet_insuraramount) total1,sum(oc_debet_extrainsuraramount) total2,sum(oc_debet_extrainsuraramount2) total3 from oc_debets,oc_encounters,oc_patientinvoices where oc_patientinvoice_objectid=replace(oc_debet_patientinvoiceuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and oc_encounter_objectid=replace(oc_debet_encounteruid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and oc_encounter_type='admission' and oc_debet_date>=? and oc_debet_date<?";
	ps = conn.prepareStatement(sql);
	ps.setDate(1,new java.sql.Date(dStart.getTime()));
	ps.setDate(2,new java.sql.Date(dEnd.getTime()));
	rs = ps.executeQuery();
	double invoicedinsureradmissions=0;
	if(rs.next()){
		invoicedinsureradmissions=rs.getInt("total1")+rs.getInt("total2")+rs.getInt("total3");
		out.println("<tr><td class='admin'>"+getTran(request,"web","invoicedinsurers",sWebLanguage)+ " - "+getTran(request,"web","admissions",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("###,##0.00").format(invoicedinsureradmissions)+" "+MedwanQuery.getInstance().getConfigString("currency")+" ("+getTran(request,"finance.patientinvoice.status","closed",sWebLanguage)+": "+new DecimalFormat("###,##0.00").format(closedinvoicedinsureradmissions)+" "+MedwanQuery.getInstance().getConfigString("currency")+")</td></tr>");
	}
	rs.close();
	ps.close();

	out.println("<tr><td class='admin'>"+getTran(request,"web","invoicedinsurers",sWebLanguage)+ " - "+getTran(request,"web","total",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("###,##0.00").format(invoicedinsurervisits+invoicedinsureradmissions)+" ("+new DecimalFormat("###,##0.00").format((invoicedinsurervisits+invoicedinsureradmissions)*365/duration)+" "+MedwanQuery.getInstance().getConfigString("currency")+")</td></tr>");
	out.println("<tr><td class='admin'>"+getTran(request,"web","closedinvoicedinsurers",sWebLanguage)+ " - "+getTran(request,"web","total",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("###,##0.00").format(closedinvoicedinsurervisits+closedinvoicedinsureradmissions)+" ("+new DecimalFormat("###,##0.00").format((closedinvoicedinsurervisits+closedinvoicedinsureradmissions)*365/duration)+" "+MedwanQuery.getInstance().getConfigString("currency")+")</td></tr>");
	out.println("<tr><td class='admin'>"+getTran(request,"web","invoiced",sWebLanguage)+ " - "+getTran(request,"web","total",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("###,##0.00").format(invoicedvisits+invoicedadmissions+invoicedinsurervisits+invoicedinsureradmissions)+" "+MedwanQuery.getInstance().getConfigString("currency")+" ("+new DecimalFormat("###,##0.00").format((invoicedvisits+invoicedadmissions+invoicedinsurervisits+invoicedinsureradmissions)*365/duration)+" "+MedwanQuery.getInstance().getConfigString("currency")+")</td></tr>");
	out.println("<tr><td class='admin'>"+getTran(request,"web","closedinvoiced",sWebLanguage)+ " - "+getTran(request,"web","total",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("###,##0.00").format(closedinvoicedvisits+closedinvoicedadmissions+closedinvoicedinsurervisits+closedinvoicedinsureradmissions)+" "+MedwanQuery.getInstance().getConfigString("currency")+" ("+new DecimalFormat("###,##0.00").format((closedinvoicedvisits+closedinvoicedadmissions+closedinvoicedinsurervisits+closedinvoicedinsureradmissions)*365/duration)+" "+MedwanQuery.getInstance().getConfigString("currency")+")</td></tr>");

	sql = "select sum(oc_patientcredit_amount) total from oc_patientcredits,oc_encounters where oc_encounter_objectid=replace(oc_patientcredit_encounteruid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and oc_encounter_type='visit' and oc_patientcredit_date>=? and oc_patientcredit_date<?";
	ps = conn.prepareStatement(sql);
	ps.setDate(1,new java.sql.Date(dStart.getTime()));
	ps.setDate(2,new java.sql.Date(dEnd.getTime()));
	rs = ps.executeQuery();
	double paidvisits=0;
	if(rs.next()){
		paidvisits=rs.getInt("total");
		out.println("<tr><td class='admin'>"+getTran(request,"web","paidpatients",sWebLanguage)+ " - "+getTran(request,"web","visits",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("###,##0.00").format(paidvisits)+" "+MedwanQuery.getInstance().getConfigString("currency")+"</td></tr>");
	}
	rs.close();
	ps.close();

	sql = "select sum(oc_patientcredit_amount) total from oc_patientcredits,oc_encounters where oc_encounter_objectid=replace(oc_patientcredit_encounteruid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and oc_encounter_type='admission' and oc_patientcredit_date>=? and oc_patientcredit_date<?";
	ps = conn.prepareStatement(sql);
	ps.setDate(1,new java.sql.Date(dStart.getTime()));
	ps.setDate(2,new java.sql.Date(dEnd.getTime()));
	rs = ps.executeQuery();
	double paidadmissions=0;
	if(rs.next()){
		paidadmissions=rs.getInt("total");
		out.println("<tr><td class='admin'>"+getTran(request,"web","paidpatients",sWebLanguage)+ " - "+getTran(request,"web","admissions",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("###,##0.00").format(paidadmissions)+" "+MedwanQuery.getInstance().getConfigString("currency")+"</td></tr>");
	}
	rs.close();
	ps.close();

	out.println("<tr><td class='admin'>"+getTran(request,"web","paidpatients",sWebLanguage)+ " - "+getTran(request,"web","total",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("###,##0.00").format(paidvisits+paidadmissions)+" "+MedwanQuery.getInstance().getConfigString("currency")+"</td></tr>");
	out.println("<tr><td class='admin'>"+getTran(request,"web","patientpaymentcoverage",sWebLanguage)+ " - "+getTran(request,"web","visits",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("###,##0.00").format(paidvisits*100/invoicedvisits)+"% ("+getTran(request,"finance.patientinvoice.status","closed",sWebLanguage)+": "+new DecimalFormat("###,##0.00").format(paidvisits*100/closedinvoicedvisits)+"%)</td></tr>");
	out.println("<tr><td class='admin'>"+getTran(request,"web","patientpaymentcoverage",sWebLanguage)+ " - "+getTran(request,"web","admissions",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("###,##0.00").format(paidadmissions*100/invoicedadmissions)+"% ("+getTran(request,"finance.patientinvoice.status","closed",sWebLanguage)+": "+new DecimalFormat("###,##0.00").format(paidadmissions*100/closedinvoicedadmissions)+"%)</td></tr>");
	out.println("<tr><td class='admin'>"+getTran(request,"web","patientpaymentcoverage",sWebLanguage)+ " - "+getTran(request,"web","total",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("###,##0.00").format((paidadmissions+paidvisits)*100/(invoicedadmissions+invoicedvisits))+"% ("+getTran(request,"finance.patientinvoice.status","closed",sWebLanguage)+": "+new DecimalFormat("###,##0.00").format((paidadmissions+paidvisits)*100/(closedinvoicedadmissions+closedinvoicedvisits))+"%)</td></tr>");

	//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	out.println("<tr class='admin'><td colspan='2'>"+getTran(request,"web","clinical",sWebLanguage)+"</td></tr>");

	sql = "select count(*) total from transactions a,items b,oc_encounters c where oc_encounter_type='visit' and a.serverid=b.serverid and a.transactionid=b.transactionid and b.type='be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID' and oc_encounter_objectid=replace(b.value,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and a.updatetime>=? and a.updatetime<? and oc_encounter_begindate>=? and oc_encounter_begindate<?";
	ps = conn.prepareStatement(sql);
	ps.setDate(1,new java.sql.Date(dStart.getTime()));
	ps.setDate(2,new java.sql.Date(dEnd.getTime()));
	ps.setDate(3,new java.sql.Date(dStart.getTime()));
	ps.setDate(4,new java.sql.Date(dEnd.getTime()));
	rs = ps.executeQuery();
	if(rs.next()){
		out.println("<tr><td class='admin'>"+getTran(request,"web","transactiondensity",sWebLanguage)+ " - "+getTran(request,"web","visits",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("#0.00").format(rs.getDouble("total")/totalvisits)+"</td></tr>");
	}
	rs.close();
	ps.close();

	sql = "select count(*) total from transactions a,items b,oc_encounters c where oc_encounter_type='admission' and a.serverid=b.serverid and a.transactionid=b.transactionid and b.type='be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID' and oc_encounter_objectid=replace(b.value,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and a.updatetime>=? and a.updatetime<? and oc_encounter_begindate>=? and oc_encounter_begindate<?";
	ps = conn.prepareStatement(sql);
	ps.setDate(1,new java.sql.Date(dStart.getTime()));
	ps.setDate(2,new java.sql.Date(dEnd.getTime()));
	ps.setDate(3,new java.sql.Date(dStart.getTime()));
	ps.setDate(4,new java.sql.Date(dEnd.getTime()));
	rs = ps.executeQuery();
	if(rs.next()){
		out.println("<tr><td class='admin'>"+getTran(request,"web","transactiondensity",sWebLanguage)+ " - "+getTran(request,"web","admissions",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("#0.00").format(rs.getDouble("total")/totaladmissions)+"</td></tr>");
	}
	rs.close();
	ps.close();

	sql = "select count(*) total from transactions a,items b,oc_encounters c,items d where oc_encounter_type='visit' and a.serverid=b.serverid and a.transactionid=b.transactionid and a.serverid=d.serverid and a.transactionid=d.transactionid and b.type='be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID' and oc_encounter_objectid=replace(b.value,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and a.updatetime>=? and a.updatetime<? and oc_encounter_begindate>=? and oc_encounter_begindate<?";
	ps = conn.prepareStatement(sql);
	ps.setDate(1,new java.sql.Date(dStart.getTime()));
	ps.setDate(2,new java.sql.Date(dEnd.getTime()));
	ps.setDate(3,new java.sql.Date(dStart.getTime()));
	ps.setDate(4,new java.sql.Date(dEnd.getTime()));
	rs = ps.executeQuery();
	if(rs.next()){
		out.println("<tr><td class='admin'>"+getTran(request,"web","itemdensity",sWebLanguage)+ " - "+getTran(request,"web","visits",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("#0.00").format(rs.getDouble("total")/totalvisits)+"</td></tr>");
	}
	rs.close();
	ps.close();

	sql = "select count(*) total from transactions a,items b,oc_encounters c,items d where oc_encounter_type='admission' and a.serverid=b.serverid and a.transactionid=b.transactionid and a.serverid=d.serverid and a.transactionid=d.transactionid and b.type='be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID' and oc_encounter_objectid=replace(b.value,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and a.updatetime>=? and a.updatetime<? and oc_encounter_begindate>=? and oc_encounter_begindate<?";
	ps = conn.prepareStatement(sql);
	ps.setDate(1,new java.sql.Date(dStart.getTime()));
	ps.setDate(2,new java.sql.Date(dEnd.getTime()));
	ps.setDate(3,new java.sql.Date(dStart.getTime()));
	ps.setDate(4,new java.sql.Date(dEnd.getTime()));
	rs = ps.executeQuery();
	if(rs.next()){
		out.println("<tr><td class='admin'>"+getTran(request,"web","itemdensity",sWebLanguage)+ " - "+getTran(request,"web","admissions",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("#0.00").format(rs.getDouble("total")/totaladmissions)+"</td></tr>");
	}
	rs.close();
	ps.close();

	sql = "select count(*) total from oc_rfe,oc_encounters c where oc_encounter_type='visit' and oc_encounter_objectid=replace(oc_rfe_encounteruid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and oc_encounter_begindate>=? and oc_encounter_begindate<?";
	ps = conn.prepareStatement(sql);
	ps.setDate(1,new java.sql.Date(dStart.getTime()));
	ps.setDate(2,new java.sql.Date(dEnd.getTime()));
	rs = ps.executeQuery();
	if(rs.next()){
		out.println("<tr><td class='admin'>"+getTran(request,"web","rfedensity",sWebLanguage)+ " - "+getTran(request,"web","visits",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("#0.00").format(rs.getDouble("total")/totalvisits)+"</td></tr>");
	}
	rs.close();
	ps.close();

	sql = "select count(*) total from oc_rfe,oc_encounters c where oc_encounter_type='admission' and oc_encounter_objectid=replace(oc_rfe_encounteruid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and oc_encounter_begindate>=? and oc_encounter_begindate<?";
	ps = conn.prepareStatement(sql);
	ps.setDate(1,new java.sql.Date(dStart.getTime()));
	ps.setDate(2,new java.sql.Date(dEnd.getTime()));
	rs = ps.executeQuery();
	if(rs.next()){
		out.println("<tr><td class='admin'>"+getTran(request,"web","rfedensity",sWebLanguage)+ " - "+getTran(request,"web","admissions",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("#0.00").format(rs.getDouble("total")/totaladmissions)+"</td></tr>");
	}
	rs.close();
	ps.close();

	sql = "select count(*) total from oc_diagnoses,oc_encounters c where oc_encounter_type='visit' and oc_diagnosis_codetype='icd10' and oc_encounter_objectid=replace(oc_diagnosis_encounteruid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and oc_encounter_begindate>=? and oc_encounter_begindate<?";
	ps = conn.prepareStatement(sql);
	ps.setDate(1,new java.sql.Date(dStart.getTime()));
	ps.setDate(2,new java.sql.Date(dEnd.getTime()));
	rs = ps.executeQuery();
	if(rs.next()){
		out.println("<tr><td class='admin'>"+getTran(request,"web","diagnosisdensity",sWebLanguage)+ " - "+getTran(request,"web","visits",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("#0.00").format(rs.getDouble("total")/totalvisits)+"</td></tr>");
	}
	rs.close();
	ps.close();

	sql = "select count(*) total from oc_diagnoses,oc_encounters c where oc_encounter_type='admission' and oc_diagnosis_codetype='icd10' and oc_encounter_objectid=replace(oc_diagnosis_encounteruid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and oc_encounter_begindate>=? and oc_encounter_begindate<?";
	ps = conn.prepareStatement(sql);
	ps.setDate(1,new java.sql.Date(dStart.getTime()));
	ps.setDate(2,new java.sql.Date(dEnd.getTime()));
	rs = ps.executeQuery();
	if(rs.next()){
		out.println("<tr><td class='admin'>"+getTran(request,"web","diagnosisdensity",sWebLanguage)+ " - "+getTran(request,"web","admissions",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("#0.00").format(rs.getDouble("total")/totaladmissions)+"</td></tr>");
	}
	rs.close();
	ps.close();

	sql = "select count(*) total from transactions a,items b,oc_encounters c where transactiontype='be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_LAB_REQUEST' and oc_encounter_type='visit' and a.serverid=b.serverid and a.transactionid=b.transactionid and b.type='be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID' and oc_encounter_objectid=replace(b.value,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and a.updatetime>=? and a.updatetime<? and oc_encounter_begindate>=? and oc_encounter_begindate<?";
	ps = conn.prepareStatement(sql);
	ps.setDate(1,new java.sql.Date(dStart.getTime()));
	ps.setDate(2,new java.sql.Date(dEnd.getTime()));
	ps.setDate(3,new java.sql.Date(dStart.getTime()));
	ps.setDate(4,new java.sql.Date(dEnd.getTime()));
	rs = ps.executeQuery();
	if(rs.next()){
		out.println("<tr><td class='admin'>"+getTran(request,"web","laborderdensity",sWebLanguage)+ " - "+getTran(request,"web","visits",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("###,##0.00").format(rs.getDouble("total")/totalvisits)+"</td></tr>");
	}
	rs.close();
	ps.close();

	sql = "select count(*) total from transactions a,items b,oc_encounters c where transactiontype='be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_LAB_REQUEST' and oc_encounter_type='admission' and a.serverid=b.serverid and a.transactionid=b.transactionid and b.type='be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID' and oc_encounter_objectid=replace(b.value,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and a.updatetime>=? and a.updatetime<? and oc_encounter_begindate>=? and oc_encounter_begindate<?";
	ps = conn.prepareStatement(sql);
	ps.setDate(1,new java.sql.Date(dStart.getTime()));
	ps.setDate(2,new java.sql.Date(dEnd.getTime()));
	ps.setDate(3,new java.sql.Date(dStart.getTime()));
	ps.setDate(4,new java.sql.Date(dEnd.getTime()));
	rs = ps.executeQuery();
	if(rs.next()){
		out.println("<tr><td class='admin'>"+getTran(request,"web","laborderdensity",sWebLanguage)+ " - "+getTran(request,"web","admissions",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("#0.00").format(rs.getDouble("total")/totaladmissions)+"</td></tr>");
	}
	rs.close();
	ps.close();

	sql = "select avg(analyses) total from (select count(*) analyses,transactionid from requestedlabanalyses where requestdatetime>=? and requestdatetime<? group by transactionid) z";
	ps = conn.prepareStatement(sql);
	ps.setDate(1,new java.sql.Date(dStart.getTime()));
	ps.setDate(2,new java.sql.Date(dEnd.getTime()));
	rs = ps.executeQuery();
	if(rs.next()){
		out.println("<tr><td class='admin'>"+getTran(request,"web","analysesperlaborder",sWebLanguage)+"</td><td class='admin2'>"+new DecimalFormat("#0.00").format(rs.getDouble("total"))+"</td></tr>");
	}
	rs.close();
	ps.close();
	conn.close();


}
catch(Exception e){
	e.printStackTrace();
}
%>
</table>
<script>
function openPopupWindow(page, width, height, title){
    if (width == undefined){
        width = 700;
    }
    if (height == undefined){
        height = 400;
    }
    if (title == undefined) {
       title = "&nbsp;";
    }
    page = "<c:url value="/"/>"+page;

    Modalbox.show(page, {title: title, width: width,height: height} );
}

function coreValueGraph(type){
	openPopupWindow('statistics/coreStatsHistory.jsp?type='+type,700,400,'OpenClinicMetricHistory');
}
function coreValueGraphFull(type){
	openPopupWindow('statistics/coreStatsHistory.jsp?fullperiod=true&type='+type,700,400,'OpenClinicMetricHistory');
}
</script>