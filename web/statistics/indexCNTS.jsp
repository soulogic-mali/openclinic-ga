<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"statistics","select",activeUser)%>

<%!
	//--- GET FIRST DAY PREVIOUS MONTH ------------------------------------------------------------
	public String getFirstDayPreviousMonth(){
	    // DATE
	    Calendar cal = Calendar.getInstance();
	    cal.setTime(new java.util.Date()); // now
	    cal.add(Calendar.MONTH,-1); // previous month
	    cal.set(Calendar.DAY_OF_MONTH,1); // first day

	    // HOUR
	    cal.set(Calendar.HOUR_OF_DAY,0);
	    cal.set(Calendar.MINUTE,0);
	    cal.set(Calendar.SECOND,0);
	    cal.set(Calendar.MILLISECOND,0);
	    
        return ScreenHelper.formatDate(cal.getTime());  
	}

	//--- GET LAST DAY PREVIOUS MONTH -------------------------------------------------------------
	public String getLastDayPreviousMonth(){
	    // DATE
	    Calendar cal = Calendar.getInstance();
	    cal.setTime(new java.util.Date()); // now
	    cal.add(Calendar.MONTH,-1); // previous month
	    cal.set(Calendar.DAY_OF_MONTH,cal.getActualMaximum(Calendar.DAY_OF_MONTH)); // last day
	
	    // HOUR
	    cal.set(Calendar.HOUR_OF_DAY,23);
	    cal.set(Calendar.MINUTE,59);
	    cal.set(Calendar.SECOND,59);
	    cal.set(Calendar.MILLISECOND,99);
	    	    
	    return ScreenHelper.formatDate(cal.getTime());    
	}
%>

<%
    String firstdayPreviousMonth = getFirstDayPreviousMonth(),
           lastdayPreviousMonth  = getLastDayPreviousMonth();

    Debug.println("firstdayPreviousMonth : "+firstdayPreviousMonth);
    Debug.println("lastdayPreviousMonth  : "+lastdayPreviousMonth);
%>
<form name="stats">
<%
	long day=24*3600*1000;
    //*** 1 - RECORD CREATION *********************************************************************
	if(true){	    
	    out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","statistics.record.creation",sWebLanguage),sCONTEXTPATH));
	    out.print("<tr>"+
	               "<td class='admin2' colspan='2'>"+
	                getTran(request,"web","from",sWebLanguage)+"&nbsp;"+writeDateField("begincnar","stats",firstdayPreviousMonth,sWebLanguage)+"&nbsp;&nbsp;"+
	                getTran(request,"web","to",sWebLanguage)+"&nbsp;"+writeDateField("endcnar","stats",lastdayPreviousMonth,sWebLanguage)+
	               "</td>"+
	              "</tr>"+
	              writeTblChildWithCode(activeUser.getAccessRight("statistics.oldandnewcases.select"),"javascript:oldandnewcases()",getTran(request,"Web","statistics.oldandnewcases",sWebLanguage))+
	              writeTblChildWithCode(activeUser.getAccessRight("statistics.newpatients.select"),"javascript:newpatients()",getTran(request,"Web","statistics.newpatients",sWebLanguage))+
	              writeTblChildWithCode(activeUser.getAccessRight("statistics.agedistribution.select"),"javascript:agedistribution()",getTran(request,"Web","statistics.agedistribution",sWebLanguage)));
        out.print(ScreenHelper.writeTblFooter()+"<br>");
	}

	if(activeUser.getAccessRight("statistics.select")){	    
        String today = ScreenHelper.formatDate(new java.util.Date()); // now
        String service="",serviceName="";
        out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","statistics.bloodbank",sWebLanguage),sCONTEXTPATH));
        out.print("<tr>"+
                   "<td class='admin2' colspan='2'>"+
                    getTran(request,"web","from",sWebLanguage)+"&nbsp;"+writeDateField("begincnts","stats",firstdayPreviousMonth,sWebLanguage)+"&nbsp;&nbsp;"+
                    getTran(request,"web","to",sWebLanguage)+"&nbsp;"+writeDateField("endcnts","stats",lastdayPreviousMonth,sWebLanguage)+
                   "</td>"+
                  "</tr>");
        out.println(writeTblChildWithCode(activeUser.getAccessRight("statistics.bloodbank.select"),"javascript:cntsHemovigilanceReport()",getTran(request,"Web","statistics.bloodbank.hemovigilance",sWebLanguage)));

        out.print("<tr>"+
                   "<td class='admin2' colspan='2'>"+getTran(request,"Web","site",sWebLanguage)+" "+
        		   "	<select class='text' name='cntssite' id='cntssite'>"+
                   "		<option>"+
        				   SH.writeSelect(request,"cnts.sites","",sWebLanguage)+
        		   "	</select>"+
                   "</td>"+
                  "</tr>");
                  
        out.println(writeTblChildWithCode(activeUser.getAccessRight("statistics.bloodbank.select"),"javascript:cntsActivityReport()",getTran(request,"Web","statistics.bloodbank.activityreport",sWebLanguage)));
        out.print(ScreenHelper.writeTblFooter()+"<br>");
	}


    //*** 4 - TECHNICAL STATS *********************************************************************
    if(activeUser.getAccessRight("statistics.select")){        
        out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","statistics.technicalstats",sWebLanguage),sCONTEXTPATH));
        out.print("<tr>"+
                   "<td class='admin2' colspan='2'>"+
                    getTran(request,"web","from",sWebLanguage)+"&nbsp;"+writeDateField("begintech","stats",firstdayPreviousMonth,sWebLanguage)+"&nbsp;&nbsp;"+
                    getTran(request,"web","to",sWebLanguage)+"&nbsp;"+writeDateField("endtech","stats",lastdayPreviousMonth,sWebLanguage)+
                   "</td>"+
                  "</tr>"+
                  writeTblChildWithCode(activeUser.getAccessRight("statistics.lab.select"),"javascript:labStatistics()",getTran(request,"Web","statistics.lab",sWebLanguage))+
			      writeTblChildWithCode(activeUser.getAccessRight("statistics.lab.extraction.select"),"javascript:labExtraction()",getTran(request,"Web","statistics.lab.extraction",sWebLanguage)));
        out.print(ScreenHelper.writeTblFooter()+"<br>");
    }

    //*** 5 - ACTIVITY STATS **********************************************************************
    if(activeUser.getAccessRight("statistics.select")){
        out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","statistics.activitystats",sWebLanguage),sCONTEXTPATH));
        out.print(writeTblChildNoButton(activeUser.getAccessRight("statistics.activitystats.database.select"),"main.do?Page=statistics/databaseStatistics.jsp",getTran(request,"Web","statistics.activitystats.database",sWebLanguage))+
                  writeTblChildNoButton(activeUser.getAccessRight("statistics.activitystats.encountercoding.select"),"main.do?Page=statistics/encounterCodingStats.jsp",getTran(request,"Web","statistics.activitystats.encountercoding",sWebLanguage))+
                  writeTblChildNoButton(activeUser.getAccessRight("statistics.activitystats.recordviewing.select"),"main.do?Page=statistics/recordViewingStats.jsp",getTran(request,"Web","statistics.activitystats.recordviewing",sWebLanguage))+
                  writeTblChildNoButton(activeUser.getAccessRight("statistics.activitystats.transactionviewing.select"),"main.do?Page=statistics/transactionViewingStats.jsp",getTran(request,"Web","statistics.activitystats.transactionviewing",sWebLanguage)));
        out.print(ScreenHelper.writeTblFooter()+"<br>");

        String service = activeUser.activeService.code;
        String serviceName = activeUser.activeService.getLabel(sWebLanguage);
        
        String today = ScreenHelper.formatDate(new java.util.Date()); // now
        out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","statistics.treatedpatients",sWebLanguage),sCONTEXTPATH));
        out.print("<tr>"+
                   "<td class='admin2' colspan='2'>"+
                    getTran(request,"web","from",sWebLanguage)+"&nbsp;"+writeDateField("begin3b","stats",today,sWebLanguage)+"&nbsp;&nbsp;"+
                    getTran(request,"web","to",sWebLanguage)+"&nbsp;"+writeDateField("end3b","stats",today,sWebLanguage)+
                   "</td>"+
                  "</tr>");

        out.print("<tr>"+
                   "<td class='admin2' colspan='2'>"+getTran(request,"Web","service",sWebLanguage)+" "+
                    "<input type='hidden' name='statserviceid' id='statserviceid' value='"+service+"'>"+
                    "<input class='text' type='text' name='statservicename' id='statservicename' readonly size='"+sTextWidth+"' value='"+serviceName+"'>&nbsp;"+
                    "<img src='_img/icons/icon_search.png' class='link' alt='"+getTranNoLink("Web","select",sWebLanguage)+"' onclick='searchService(\"statserviceid\",\"statservicename\");'>&nbsp;"+
                    "<img src='_img/icons/icon_delete.png' class='link' alt='"+getTranNoLink("Web","clear",sWebLanguage)+"' onclick='statserviceid.value=\"\";statservicename.value=\"\";'>"+
                   "</td>"+
                  "</tr>"+
                  writeTblChildWithCode(activeUser.getAccessRight("statistics.patientslist.visits.select"),"javascript:patientslistvisits()",getTran(request,"Web","statistics.patientslist.visits",sWebLanguage)+"</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a>"));
        out.print(ScreenHelper.writeTblFooter()+"<br>");

        //*** 5d - DOWNLOADS ***********************************
        String sBeginOfYear = "01/01/"+new SimpleDateFormat("yyyy").format(new java.util.Date());
       
        String sEndOfYear = "31/12/"+new SimpleDateFormat("yyyy").format(new java.util.Date());
        if(ScreenHelper.stdDateFormat.toPattern().equals("MM/dd/yyyy")){
            sEndOfYear = "12/31/"+(Integer.parseInt(new SimpleDateFormat("yyyy").format(new java.util.Date()))-1); // US-date
        }
        
        String e = ScreenHelper.formatDate(ScreenHelper.getBeginOfMonth(new java.util.Date()));
        String b = ScreenHelper.formatDate(ScreenHelper.getBeginOfMonth(ScreenHelper.getBeginOfMonth(new java.util.Date(new java.util.Date().getTime()-day*70))));
    	
        out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","statistics.download",sWebLanguage),sCONTEXTPATH));
        out.print(writeTblChildWithCodeNoButton(activeUser.getAccessRight("statistics.download.patients.select"),"javascript:downloadStats(\"patients.list\",\"openclinic\");",getTran(request,"Web","statistics.download.patients",sWebLanguage))+
                  "<tr>"+
        		   "<td class='admin2' colspan='2'>"+
                    getTran(request,"web","from",sWebLanguage)+"&nbsp;"+writeDateField("begin","stats",b,sWebLanguage)+"&nbsp;&nbsp;"+
        		    getTran(request,"web","to",sWebLanguage)+"&nbsp;"+writeDateField("end","stats",e,sWebLanguage)+
        		   "</td>"+
        		  "</tr>"+
                  writeTblChildWithCodeNoButton(activeUser.getAccessRight("statistics.download.global.select"),"javascript:downloadStats(\"global.list\",\"openclinic\");",getTran(request,"Web","statistics.download.global",sWebLanguage))+
                  writeTblChildWithCodeNoButton(activeUser.getAccessRight("statistics.download.encounterlist.select"),"javascript:downloadStats(\"encounter.list\",\"openclinic\");",getTran(request,"Web","statistics.download.encounterlist",sWebLanguage))+
                  writeTblChildWithCodeNoButton(activeUser.getAccessRight("statistics.download.userlist.select"),"javascript:downloadStats(\"user.list\",\"admin\");",getTran(request,"Web","statistics.download.userlist",sWebLanguage))+
                  writeTblChildWithCodeNoButton(activeUser.getAccessRight("statistics.download.servicelist.select"),"javascript:downloadStats(\"service.list\",\"openclinic\");",getTran(request,"Web","statistics.download.servicelist",sWebLanguage))+
                  writeTblChildWithCodeNoButton(activeUser.getAccessRight("statistics.download.debetlist.select"),"javascript:downloadStats(\"debet.list\",\"openclinic\");",getTran(request,"Web","statistics.download.debetlist",sWebLanguage))+
                  writeTblChildWithCodeNoButton(activeUser.getAccessRight("statistics.download.debetlist.per.encounter.select"),"javascript:downloadStats(\"debet.list.per.encounter\",\"openclinic\");",getTran(request,"Web","statistics.download.debetlist.per.encounter",sWebLanguage))+
                  writeTblChildWithCodeNoButton(activeUser.getAccessRight("statistics.download.prestationlist.select"),"javascript:downloadStats(\"prestation.list\",\"openclinic\");",getTran(request,"Web","statistics.download.prestationlist",sWebLanguage))+
                  writeTblChildWithCodeNoButton(activeUser.getAccessRight("statistics.download.wicketcredits.select"),"javascript:downloadStats(\"wicketcredits.list\",\"openclinic\");",getTran(request,"Web","statistics.download.wicketcredits",sWebLanguage))+
                  writeTblChildWithCodeNoButton(activeUser.getAccessRight("statistics.download.labresults.select"),"javascript:downloadStats(\"lab.list\",\"openclinic\");",getTran(request,"Web","statistics.download.labresults",sWebLanguage))+
                  writeTblChildWithCodeNoButton(activeUser.getAccessRight("statistics.download.invoicessummary.select"),"javascript:downloadInvoicesSummary(\"hmk.invoices.list\",\"openclinic\");",getTran(request,"Web","statistics.download.invoicessummary",sWebLanguage))+
		          writeTblChildWithCodeNoButton(activeUser.getAccessRight("statistics.download.bloodgift.select"),"javascript:downloadBloodgifts(\"cnts.bloodgifts\",\"openclinic\");",getTran(request,"Web","statistics.download.bloodgift",sWebLanguage)));
        out.print(ScreenHelper.writeTblFooter()+"<br>");

        //*** 5e - PATHOLOGY ***********************************	    
        out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","financial",sWebLanguage),sCONTEXTPATH));	    
        out.print(writeTblChildNoButton(activeUser.getAccessRight("statistics.toinvoicelists.select"),"main.do?Page=statistics/toInvoiceLists.jsp",getTran(request,"Web","statistics.toinvoicelists",sWebLanguage))+
                  "<tr>"+
                   "<td class='admin2' colspan='2'>"+
                    getTran(request,"web","from",sWebLanguage)+"&nbsp;"+writeDateField("beginfin","stats",firstdayPreviousMonth,sWebLanguage)+"&nbsp;&nbsp;"+
                    getTran(request,"web","to",sWebLanguage)+"&nbsp;"+writeDateField("endfin","stats",lastdayPreviousMonth,sWebLanguage)+
                   "</td>"+
                  "</tr>"+
                  writeTblChildWithCode(activeUser.getAccessRight("statistics.openinvoicelists.select"),"javascript:getOpenInvoices()",getTran(request,"Web","statistics.openinvoicelists",sWebLanguage))+
                  writeTblChildWithCode(activeUser.getAccessRight("statistics.closednonzeroinvoicelists.select"),"javascript:getClosedNonZeroInvoices()",getTran(request,"Web","statistics.closednonzeroinvoicelists",sWebLanguage))+
                  writeTblChildWithCode(activeUser.getAccessRight("statistics.canceledinvoicelists.select"),"javascript:getCanceledInvoices()",getTran(request,"Web","statistics.canceledinvoicelists",sWebLanguage))+
                  writeTblChildWithCode(activeUser.getAccessRight("statistics.issuedinsurerinvoices.select"),"javascript:getIssuedInsurerInvoices()",getTran(request,"Web","statistics.issuedinsurerinvoices",sWebLanguage))+
        		  writeTblChildWithCode(activeUser.getAccessRight("statistics.userinvoices.select"),"javascript:getUserInvoices()",getTran(request,"Web","statistics.userinvoices",sWebLanguage)));
        out.print(ScreenHelper.writeTblFooter()+"<br>");
    }
%>
</form>

<script>
function jasperReports(){
    var URL = "/statistics/jasperReports.jsp";
	openPopup(URL,600,400,"OpenClinic");
  }
function downloadPBFdocs(query,db){
    var URL = "/statistics/downloadPBFdocs.jsp&query="+query+"&db="+db+"&begin="+document.getElementsByName('begin')[0].value+"&end="+document.getElementsByName('end')[0].value;
	openPopup(URL,400,300,"OpenClinic");
  }
function downloadPBFdocsNoService(query,db){
    var URL = "/statistics/downloadPBFdocs.jsp&noservice=yes&query="+query+"&db="+db+"&begin="+document.getElementsByName('begin')[0].value+"&end="+document.getElementsByName('end')[0].value;
	openPopup(URL,400,300,"OpenClinic");
  }
function downloadPBFdocsInsurer(query,db){
    var URL = "/statistics/downloadPBFdocs.jsp&noservice=yes&insurer=yes&query="+query+"&db="+db+"&begin="+document.getElementsByName('begin')[0].value+"&end="+document.getElementsByName('end')[0].value;
	openPopup(URL,400,300,"OpenClinic");
  }
function downloadInvoicesSummary(query,db){
    var URL = "/statistics/downloadInvoicesSummary.jsp&query="+query+"&db="+db+"&begin="+document.getElementsByName('begin')[0].value+"&end="+document.getElementsByName('end')[0].value;
	openPopup(URL,400,300,"OpenClinic");
  }
function downloadBloodgifts(query,db){
	window.open("<c:url value='/statistics/downloadBloodgifts.jsp'/>?query="+query+"&db="+db+"&begin="+document.getElementsByName('begin')[0].value+"&end="+document.getElementsByName('end')[0].value);
  }
function cntsActivityReport(query,db){
	window.open("<c:url value='/statistics/downloadBloodgiftsPdf.jsp'/>?query="+query+"&cntssite="+document.getElementById("cntssite").value+"&db="+db+"&begin="+document.getElementsByName('begincnts')[0].value+"&end="+document.getElementsByName('endcnts')[0].value);
  }
function cntsHemovigilanceReport(query,db){
	openPopup("/cnts/showHemovigilance.jsp&begin="+document.getElementsByName('begincnts')[0].value,800,300);
  }
function downloadStats(query,db){
    window.open("<c:url value='/util/csvStats.jsp?'/>query="+query+"&db="+db+"&begin="+document.getElementsByName('begin')[0].value+"&end="+document.getElementsByName('end')[0].value);
  }
function downloadTechnicalStats(query,db){
    window.open("<c:url value='/util/csvStats.jsp?'/>query="+query+"&db="+db+"&begin="+document.getElementsByName('begintech')[0].value+"&end="+document.getElementsByName('endtech')[0].value);
  }
  function downloadDatacenterStats(query,db){
    window.open("<c:url value='/datacenterstatistics/csvStats.jsp?'/>query="+query+"&db="+db+"&begin="+document.getElementsByName('begin')[0].value+"&end="+document.getElementsByName('end')[0].value);
  }
  function minisanteReport(){
    window.open("<c:url value='/statistics/createMonthlyReportPdf.jsp?'/>start="+document.getElementById('begin2').value+"&end="+document.getElementById('end2').value+"&ts=<%=getTs()%>");
  }
  function coreStatistics(){
	    var URL = "/statistics/coreStats.jsp&start="+document.getElementById('begin2').value+"&end="+document.getElementById('end2').value;
	    openPopup(URL,800,600,"OpenClinic");
	  }
  function coreStatistics(){
	    var URL = "/statistics/coreStats.jsp&start="+document.getElementById('begin2').value+"&end="+document.getElementById('end2').value;
	    openPopup(URL,800,600,"OpenClinic");
	  }
  function nationalreport(){
	    var URL = "/statistics/nationalReport.jsp&ts=<%=getTs()%>";
	    openPopup(URL,400,400,"OpenClinic");
	  }
  function getMFPUnsignedInvoices(){
    var URL = "/statistics/findMFPUnsignedInvoices.jsp&start="+document.getElementById('beginmfp').value+"&end="+document.getElementById('endmfp').value+"&serviceid="+document.getElementById('mfpserviceid').value+"&ts=<%=getTs()%>";
    openPopup(URL,800,600,"OpenClinic");
  }
  function getProductStockFile(){
    var URL = "/statistics/pharmacy/getProductStockFile.jsp&start="+document.getElementById('beginpharmacy').value+"&end="+document.getElementById('endpharmacy').value+"&productstockid="+document.getElementById('productstockid').value+"&ts=<%=getTs()%>";
	openPopup(URL,800,600,"OpenClinic");
  }
  function getMFPUnvalidatedInvoices(){
    var URL = "/statistics/findMFPUnvalidatedInvoices.jsp&start="+document.getElementById('beginmfp').value+"&end="+document.getElementById('endmfp').value+"&serviceid="+document.getElementById('mfpserviceid').value+"&ts=<%=getTs()%>";
	openPopup(URL,800,600,"OpenClinic");
  }
  function getMFPAcceptedUnsignedInvoices(){
    var URL = "/statistics/findMFPUnsignedInvoices.jsp&acceptedonly=1&start="+document.getElementById('beginmfp').value+"&end="+document.getElementById('endmfp').value+"&serviceid="+document.getElementById('mfpserviceid').value+"&ts=<%=getTs()%>";
	openPopup(URL,800,600,"OpenClinic");
  }
  function minisanteReportDH(){
	    window.open("<c:url value='/statistics/createMonthlyReportPdfDH.jsp?'/>start="+document.getElementById('begin2').value+"&end="+document.getElementById('end2').value+"&ts=<%=getTs()%>");
	  }
  function dhis2report(){
      var URL="/statistics/createDHIS2Report.jsp";
		openPopup(URL,600,300,"OpenClinic");
	  }
  function hospitalReport(){
    window.open("<c:url value='/statistics/printHospitalReportChapterSelection.jsp?'/>start="+document.getElementById('begin2').value+"&end="+document.getElementById('end2').value+"&ts=<%=getTs()%>");
  }
  function getMFPSummary(){
      var URL="/statistics/createMFPSummary.jsp&start="+document.getElementById('beginmfp').value+"&end="+document.getElementById('endmfp').value+"&serviceid="+document.getElementById('mfpserviceid').value+"&ts=<%=getTs()%>";
		openPopup(URL,400,600,"OpenClinic");
  }

  function insuranceReport(){
	    window.location.href="<c:url value='main.jsp?Page=/statistics/insuranceStats.jsp&'/>start="+document.getElementById('begin3').value+"&end="+document.getElementById('end3').value+"&ts=<%=getTs()%>";
	  }
  function patientslistvisits(){
    var URL = "statistics/patientslistvisits.jsp&start="+document.getElementById('begin3b').value+"&end="+document.getElementById('end3b').value+"&statserviceid="+document.getElementById('statserviceid').value+"&ts=<%=getTs()%>";
    openPopup(URL,800,600,"OpenClinic");
  }
  function patientslistadmissions(){
	var URL = "statistics/patientslistadmissions.jsp&start="+document.getElementById('begin3b').value+"&end="+document.getElementById('end3b').value+"&statserviceid="+document.getElementById('statserviceid').value+"&ts=<%=getTs()%>";
	openPopup(URL,800,600,"OpenClinic");
  }
  function patientslistsummary(){
	var URL = "statistics/patientslistsummary.jsp&start="+document.getElementById('begin3b').value+"&end="+document.getElementById('end3b').value+"&statserviceid="+document.getElementById('statserviceid').value+"&ts=<%=getTs()%>";
	openPopup(URL,1024,600,"OpenClinic");
  }
  function insuranceReport(){
    window.location.href="<c:url value='main.jsp?Page=/statistics/insuranceStats.jsp&'/>start="+document.getElementById('begin3').value+"&end="+document.getElementById('end3').value+"&ts=<%=getTs()%>";
  }
  function incomeVentilation(){
	<%
		if(MedwanQuery.getInstance().getConfigInt("enableCPLR",0)==0){
	%>
	  var URL = "statistics/incomeVentilation.jsp&start="+document.getElementById('begin3').value+"&end="+document.getElementById('end3').value+"&ts=<%=getTs()%>";
	<%
		}
		else {
	%>
	  var URL = "statistics/incomeVentilationCPLR.jsp&start="+document.getElementById('begin3').value+"&end="+document.getElementById('end3').value+"&ts=<%=getTs()%>";
	<%
		}
	%>
	openPopup(URL,800,600,"OpenClinic");
  }
  function incomeVentilationExtended(){
    var URL = "statistics/incomeVentilationExtended.jsp&start="+document.getElementById('begin3').value+"&end="+document.getElementById('end3').value+"&ts=<%=getTs()%>";
	openPopup(URL,800,600,"OpenClinic");
  }
  function incomeVentilationPerformers(){
    var URL = "statistics/incomeVentilationPerformers.jsp&start="+document.getElementById('begin3').value+"&end="+document.getElementById('end3').value+"&ts=<%=getTs()%>";
	openPopup(URL,800,600,"OpenClinic");
  }
  function paymentrate(){
		var URL = "statistics/insurarIncome.jsp&start="+document.getElementById('begin3').value+"&end="+document.getElementById('end3').value+"&ts=<%=getTs()%>";
		openPopup(URL,500,600,"OpenClinic");
	  }
  function extractspt(){
		var URL = "statistics/extractSPT.jsp&start="+document.getElementById('begin3b').value+"&end="+document.getElementById('end3b').value+"&ts=<%=getTs()%>";
		openPopup(URL,500,400,"OpenClinic");
	  }
  function getOpenInvoices(){
		var URL = "statistics/openInvoiceLists.jsp&start="+document.getElementById('beginfin').value+"&end="+document.getElementById('endfin').value+"&ts=<%=getTs()%>";
		openPopup(URL,800,600,"OpenClinic");
	  }
  function getUserInvoices(){
		var URL = "statistics/getInvoicesPerUser.jsp&ts=<%=getTs()%>";
		openPopup(URL,800,600,"OpenClinic");
	  }
  function getClosedNonZeroInvoices(){
	var URL = "statistics/closedNonZeroInvoiceLists.jsp&start="+document.getElementById('beginfin').value+"&end="+document.getElementById('endfin').value+"&ts=<%=getTs()%>";
	openPopup(URL,800,600,"OpenClinic");
  }
  function getCanceledInvoices(){
	var URL = "statistics/canceledInvoiceLists.jsp&start="+document.getElementById('beginfin').value+"&end="+document.getElementById('endfin').value+"&ts=<%=getTs()%>";
	openPopup(URL,800,600,"OpenClinic");
  }
  function getIssuedInsurerInvoices(){
	var URL = "statistics/issuedInsurerInvoiceList.jsp&start="+document.getElementById('beginfin').value+"&end="+document.getElementById('endfin').value+"&ts=<%=getTs()%>";
    openPopup(URL,800,600,"OpenClinic");
  }
  function searchService(serviceUidField,serviceNameField){
    openPopup("_common/search/searchService.jsp&ts=<%=getTs()%>&showinactive=1&VarCode="+serviceUidField+"&VarText="+serviceNameField);
    document.getElementsByName(serviceNameField)[0].focus();
  }
  function oldandnewcases(){
    var URL = "statistics/oldAndNewCases.jsp&start="+document.getElementById('begincnar').value+"&end="+document.getElementById('endcnar').value+"&ts=<%=getTs()%>";
    openPopup(URL,200,300,"OpenClinic");
  }
  function newpatients(){
	var URL = "statistics/newPatients.jsp&start="+document.getElementById('begincnar').value+"&end="+document.getElementById('endcnar').value+"&ts=<%=getTs()%>";
	openPopup(URL,200,200,"OpenClinic");
  }
  function agedistribution(){
	var URL = "statistics/ageDistribution.jsp&start="+document.getElementById('begincnar').value+"&end="+document.getElementById('endcnar').value+"&ts=<%=getTs()%>";
    openPopup(URL,200,650,"OpenClinic");
  }
  function genderdistribution(){
    var URL = "statistics/genderGraph.jsp?start="+document.getElementById('begincnar').value+"&end="+document.getElementById('endcnar').value+"&ts=<%=getTs()%>";
    window.open(URL);
  }
  function labStatistics(){
	    var URL = "statistics/labStatistics.jsp&start="+document.getElementById('begintech').value+"&end="+document.getElementById('endtech').value+"&ts=<%=getTs()%>";
		openPopup(URL,800,600,"OpenClinic");
	  }    
  function labExtraction(){
	    var URL = "statistics/labExtraction.jsp?language=<%=sWebLanguage%>&start="+document.getElementById('begintech').value+"&end="+document.getElementById('endtech').value+"&ts=<%=getTs()%>";
		open(URL,"OpenClinic");
	  }    
  function showDataExtractionResults(){
	    var URL = "statistics/showDataExtractResults.jsp";
		openPopup(URL,800,600,"OpenClinic");
  }
  function checkDataExtractionResults(){
      var today = new Date();
      var url= '<c:url value="/statistics/checkDataExtractionResults.jsp"/>?ts='+today;
      new Ajax.Request(url,{
          method: "POST",
          postBody: "",
          onSuccess: function(resp){
              var label = resp.responseText;
              if(label.indexOf("<OK>")>-1){
            	  showDataExtractionResults();
              }
          },
          onFailure: function(){
          }
      }
	  );
  }
  
  window.setInterval("checkDataExtractionResults();",2000);
</script>