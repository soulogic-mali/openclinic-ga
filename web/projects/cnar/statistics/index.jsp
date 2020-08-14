<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<form name="stats">
<%
	String service =activeUser.activeService.code;
	String serviceName = activeUser.activeService.getLabel(sWebLanguage);
	if(MedwanQuery.getInstance().getConfigInt("cnarEnabled",0)==1 && activeUser.getAccessRight("statistics.select")){
        String firstdayPreviousMonth="01/"+new SimpleDateFormat("MM/yyyy").format(new java.util.Date(new SimpleDateFormat("dd/MM/yyyy").parse("01/"+new SimpleDateFormat("MM/yyyy").format(new java.util.Date())).getTime()-100));
        String lastdayPreviousMonth=new SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date(new SimpleDateFormat("dd/MM/yyyy").parse("01/"+new SimpleDateFormat("MM/yyyy").format(new java.util.Date())).getTime()-100));
        out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","statistics.cnar",sWebLanguage),sCONTEXTPATH)
                +"<tr><td>"+getTran(request,"web","from",sWebLanguage)+"&nbsp;</td><td>"+writeDateField("begincnar","stats",firstdayPreviousMonth,sWebLanguage)+"&nbsp;"+getTran(request,"web","to",sWebLanguage)+"&nbsp;"+writeDateField("endcnar","stats",lastdayPreviousMonth,sWebLanguage)+"&nbsp;</td></tr>"
    			+"<tr><td class='admin2' colspan='2'>"+getTran(request,"cnar","statistics.consultations",sWebLanguage)+"</tr>"
                +writeTblChildWithCode("javascript:oldandnewcases()",getTran(request,"Web","statistics.oldandnewcases",sWebLanguage))
                +writeTblChildWithCode("javascript:newpatients()",getTran(request,"Web","statistics.newpatients",sWebLanguage))
                +writeTblChildWithCode("javascript:agedistribution()",getTran(request,"Web","statistics.agedistribution",sWebLanguage))
	            +writeTblChildWithCode("javascript:genderdistribution()",getTran(request,"Web","statistics.genderdistribution",sWebLanguage))
    			+"<tr><td class='admin2'  colspan='2'>"+getTran(request,"cnar","statistics.etiology",sWebLanguage)+"</tr>"
                +writeTblChildWithCode("javascript:cnaretiology()",getTran(request,"cnar","statistics.principal.causes.for.handicap",sWebLanguage))
    			+"<tr><td class='admin2'  colspan='2'>"+getTran(request,"cnar","statistics.diseases",sWebLanguage)+"</tr>"
    	        +writeTblChildWithCode("javascript:cnardiseases()",getTran(request,"cnar","statistics.principal.diseases",sWebLanguage))
    			+"<tr><td class='admin2'  colspan='2'>"+getTran(request,"cnar","statistics.careoffer",sWebLanguage)+"</tr>"
    	        +writeTblChildWithCode("javascript:cnarcasesmanaged()",getTran(request,"cnar","statistics.cases.managed",sWebLanguage))
    	        +writeTblChildWithCode("javascript:cnarkine()",getTran(request,"cnar","statistics.kine",sWebLanguage))
    	        +writeTblChildWithCode("javascript:cnarorthesis()",getTran(request,"cnar","statistics.orthesis.produced",sWebLanguage))
    	        +writeTblChildWithCode("javascript:cnarorthesisdetail()",getTran(request,"cnar","statistics.orthesis.produced.detail",sWebLanguage))
    	        +writeTblChildWithCode("javascript:cnarmobile()",getTran(request,"cnar","statistics.mobile",sWebLanguage))
    			+"<tr><td class='admin2'  colspan='2'>"+getTran(request,"cnar","statistics.careoffer.per.service",sWebLanguage)+"</tr>"
                +"<tr><td>"+getTran(request,"cnar","service",sWebLanguage)+"</td><td colspan='2'><input type='hidden' name='statserviceid2' id='statserviceid2' value='"+service+"'>"
                +"<input class='text' type='text' name='statservicename2' id='statservicename2' readonly size='"+sTextWidth+"' value='"+serviceName+"' onblur=''>"
                +"<img src='_img/icons/icon_search.png' class='link' alt='"+getTran(request,"Web","select",sWebLanguage)+"' onclick='searchService(\"statserviceid2\",\"statservicename2\");'>"
                +"<img src='_img/icons/icon_delete.png' class='link' alt='"+getTran(request,"Web","clear",sWebLanguage)+"' onclick='statserviceid2.value=\"\";statservicename2.value=\"\";'>"
                +"</td></tr>"
    	        +writeTblChildWithCode("javascript:cnarcasesmanagedperservice()",getTran(request,"cnar","statistics.cases.managed",sWebLanguage))
    			+"<tr><td class='admin2'  colspan='2'>"+getTran(request,"cnar","statistics.education",sWebLanguage)+"</tr>"
    	        +writeTblChildWithCode("javascript:cnareducation()",getTran(request,"cnar","statistics.education.communication",sWebLanguage))
                +ScreenHelper.writeTblFooter()+"<br>");
		
	}
    if(activeUser.getAccessRight("patient.administration.add")||activeUser.getAccessRight("statistics.quickdiagnosisentry")){

        out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","statistics.quickdiagnosisentry",sWebLanguage),sCONTEXTPATH)
            +writeTblChildWithCode("javascript:openPopup(\"statistics/quickFile.jsp\",800,600,\"quickFile\")",getTran(request,"Web","statistics.quickdiagnosisentry",sWebLanguage))
            +ScreenHelper.writeTblFooter()+"<br>");
    }

    if(activeUser.getAccessRight("statistics.globalpathologydistribution.select")){
        out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","statistics.pathologystats",sWebLanguage),sCONTEXTPATH)
            +writeTblChildNoButton("main.do?Page=statistics/diagnosisStats.jsp",getTran(request,"Web","statistics.globalpathology",sWebLanguage))
            +writeTblChildNoButton("main.do?Page=statistics/mortality.jsp",getTran(request,"Web","statistics.mortality",sWebLanguage))
            +writeTblChildNoButton("main.do?Page=statistics/diagnosesList.jsp",getTran(request,"Web","statistics.diagnosisList",sWebLanguage))
            +ScreenHelper.writeTblFooter()+"<br>");
    }

    if(activeUser.getAccessRight("statistics.select")) {
        out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","statistics.activitystats",sWebLanguage),sCONTEXTPATH)
                +writeTblChildNoButton("main.do?Page=statistics/databaseStatistics.jsp",getTran(request,"Web","statistics.activitystats.database",sWebLanguage))
                +writeTblChildNoButton("main.do?Page=statistics/diagnosticCodingStats.jsp",getTran(request,"Web","statistics.activitystats.diagnosticcoding",sWebLanguage))
                +writeTblChildNoButton("main.do?Page=statistics/encounterCodingStats.jsp",getTran(request,"Web","statistics.activitystats.encountercoding",sWebLanguage))
                +writeTblChildNoButton("main.do?Page=statistics/recordViewingStats.jsp",getTran(request,"Web","statistics.activitystats.recordviewing",sWebLanguage))
                +writeTblChildNoButton("main.do?Page=statistics/transactionViewingStats.jsp",getTran(request,"Web","statistics.activitystats.transactionviewing",sWebLanguage))
            +ScreenHelper.writeTblFooter()+"<br>");
        String firstdayPreviousMonth="01/"+new SimpleDateFormat("MM/yyyy").format(new java.util.Date(new SimpleDateFormat("dd/MM/yyyy").parse("01/"+new SimpleDateFormat("MM/yyyy").format(new java.util.Date())).getTime()-100));
        String lastdayPreviousMonth=new SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date(new SimpleDateFormat("dd/MM/yyyy").parse("01/"+new SimpleDateFormat("MM/yyyy").format(new java.util.Date())).getTime()-100));
        out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","statistics.insuranceandinvoicingstats",sWebLanguage),sCONTEXTPATH)
                +"<tr><td>"+getTran(request,"web","from",sWebLanguage)+"&nbsp;</td><td>"+writeDateField("begin3","stats",firstdayPreviousMonth,sWebLanguage)+"&nbsp;"+getTran(request,"web","to",sWebLanguage)+"&nbsp;"+writeDateField("end3","stats",lastdayPreviousMonth,sWebLanguage)+"&nbsp;</td></tr>"
                +writeTblChildWithCode("javascript:insuranceReport()",getTran(request,"Web","statistics.insurancestats.distribution",sWebLanguage))
	            +writeTblChildWithCode("javascript:incomeVentilation()",getTran(request,"Web","statistics.incomeVentilationPerFamily",sWebLanguage))
	            +writeTblChildWithCode("javascript:incomeVentilationExtended()",getTran(request,"Web","statistics.incomeVentilationPerCategoryAndService",sWebLanguage))
	        +ScreenHelper.writeTblFooter()+"<br>");
        String today=new SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date());
        out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","statistics.treatedpatients",sWebLanguage),sCONTEXTPATH)
                +"<tr><td>"+getTran(request,"web","from",sWebLanguage)+"&nbsp;</td><td>"+writeDateField("begin3b","stats",today,sWebLanguage)+"&nbsp;"+getTran(request,"web","to",sWebLanguage)+"&nbsp;"+writeDateField("end3b","stats",today,sWebLanguage)+"&nbsp;</td></tr>"
                +"<tr><td>"+getTran(request,"Web","service",sWebLanguage)+"</td><td colspan='2'><input type='hidden' name='statserviceid' id='statserviceid' value='"+service+"'>"
                +"<input class='text' type='text' name='statservicename' id='statservicename' readonly size='"+sTextWidth+"' value='"+serviceName+"' onblur=''>"
                +"<img src='_img/icons/icon_search.png' class='link' alt='"+getTran(request,"Web","select",sWebLanguage)+"' onclick='searchService(\"statserviceid\",\"statservicename\");'>"
                +"<img src='_img/icons/icon_delete.png' class='link' alt='"+getTran(request,"Web","clear",sWebLanguage)+"' onclick='statserviceid.value=\"\";statservicename.value=\"\";'>"
                +"</td></tr>"
                +writeTblChildWithCode("javascript:patientslistvisits()",getTran(request,"Web","statistics.patientslist.visits",sWebLanguage))
                +writeTblChildWithCode("javascript:patientslistadmissions()",getTran(request,"Web","statistics.patientslist.admissions",sWebLanguage))
	        +ScreenHelper.writeTblFooter()+"<br>");
        out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","statistics.servicestats",sWebLanguage),sCONTEXTPATH)
                +writeTblChildNoButton("main.do?Page=statistics/hospitalStats.jsp",getTran(request,"Web","statistics.hospitalstats.global",sWebLanguage))
                +writeTblChildNoButton("main.do?Page=statistics/serviceStats.jsp",getTran(request,"Web","statistics.servicestats.contacts",sWebLanguage))
                +writeTblChildNoButton("main.do?Page=statistics/districtStats.jsp",getTran(request,"Web","statistics.districtstats",sWebLanguage)));

        if(activeUser.getAccessRight("statistics.servicetransactions.select")){
            out.print(writeTblChildNoButton("main.do?Page=statistics/serviceTransactionStats.jsp",getTran(request,"Web","statistics.servicetransactions",sWebLanguage)));
        }
        if(activeUser.getAccessRight("statistics.episodesperdepartment.select")){
            out.print(writeTblChildNoButton("main.do?Page=statistics/showEncountersPerService.jsp",getTran(request,"Web","statistics.serviceepisodes",sWebLanguage)));
        }

        out.print(
            writeTblChildNoButton("main.do?Page=statistics/hospitalizedPatients.jsp",getTran(request,"Web","statistics.hospitalizedpatients",sWebLanguage))+
            writeTblChildNoButton("main.do?Page=statistics/serviceIncome.jsp",getTran(request,"Web","statistics.serviceIncome",sWebLanguage))+
            writeTblChildNoButton("main.do?Page=statistics/diagnosesPerSituation.jsp",getTran(request,"Web","statistics.diagnosespersituation",sWebLanguage))
            +ScreenHelper.writeTblFooter()+"<br>");

        out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","statistics.download",sWebLanguage),sCONTEXTPATH)
            +"<tr><td>"+getTran(request,"web","from",sWebLanguage)+"&nbsp;</td><td>"+writeDateField("begin","stats","01/01/"+new SimpleDateFormat("yyyy").format(new java.util.Date()),sWebLanguage)+"&nbsp;"+getTran(request,"web","to",sWebLanguage)+"&nbsp;"+writeDateField("end","stats","31/12/"+new SimpleDateFormat("yyyy").format(new java.util.Date()),sWebLanguage)+"&nbsp;</td></tr>"
            +writeTblChildWithCodeNoButton("javascript:downloadStats(\"global.list\",\"openclinic\");",getTran(request,"Web","statistics.download.global",sWebLanguage))
            +writeTblChildWithCodeNoButton("javascript:downloadStats(\"globalrfe.list\",\"openclinic\");",getTran(request,"Web","statistics.download.globalrfe",sWebLanguage))
            +writeTblChildWithCodeNoButton("javascript:downloadStats(\"encounter.list\",\"openclinic\");",getTran(request,"Web","statistics.download.encounterlist",sWebLanguage))
            +writeTblChildWithCodeNoButton("javascript:downloadStats(\"diagnosis.list\",\"openclinic\");",getTran(request,"Web","statistics.download.diagnosislist",sWebLanguage))
            +writeTblChildWithCodeNoButton("javascript:downloadStats(\"rfe.list\",\"openclinic\");",getTran(request,"Web","statistics.download.rfelist",sWebLanguage))
            +writeTblChildWithCodeNoButton("javascript:downloadStats(\"document.list\",\"openclinic\");",getTran(request,"Web","statistics.download.documentlist",sWebLanguage))
            +writeTblChildWithCodeNoButton("javascript:downloadStats(\"user.list\",\"admin\");",getTran(request,"Web","statistics.download.userlist",sWebLanguage))
            +writeTblChildWithCodeNoButton("javascript:downloadStats(\"service.list\",\"openclinic\");",getTran(request,"Web","statistics.download.servicelist",sWebLanguage))
            +(MedwanQuery.getInstance().getConfigInt("datacenterenabled",0)==1?writeTblChildWithCodeNoButton("javascript:downloadDatacenterStats(\"service.income.list\",\"stats\");",getTran(request,"Web","statistics.download.serviceincomelist",sWebLanguage)):"")
            +ScreenHelper.writeTblFooter()+"<br>");

         out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","financial",sWebLanguage),sCONTEXTPATH)
            +writeTblChildNoButton("main.do?Page=statistics/toInvoiceLists.jsp",getTran(request,"Web","statistics.toinvoicelists",sWebLanguage))
            +"<tr><td>"+getTran(request,"web","from",sWebLanguage)+"&nbsp;</td><td>"+writeDateField("beginfin","stats","01/"+new SimpleDateFormat("MM/yyyy").format(new java.util.Date()),sWebLanguage)+"&nbsp;"+getTran(request,"web","to",sWebLanguage)+"&nbsp;"+writeDateField("endfin","stats",new SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date()),sWebLanguage)+"&nbsp;</td></tr>"
            +writeTblChildWithCode("javascript:getOpenInvoices()",getTran(request,"Web","statistics.openinvoicelists",sWebLanguage))
            +writeTblChildWithCode("javascript:getClosedNonZeroInvoices()",getTran(request,"Web","statistics.closednonzeroinvoicelists",sWebLanguage))
            +writeTblChildWithCode("javascript:getCanceledInvoices()",getTran(request,"Web","statistics.canceledinvoicelists",sWebLanguage))
            +ScreenHelper.writeTblFooter()+"<br>");
    }

    if(activeUser.getAccessRight("statistics.chin.select")){
        String firstdayPreviousMonth="01/"+new SimpleDateFormat("MM/yyyy").format(new java.util.Date(new SimpleDateFormat("dd/MM/yyyy").parse("01/"+new SimpleDateFormat("MM/yyyy").format(new java.util.Date())).getTime()-100));
        String lastdayPreviousMonth=new SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date(new SimpleDateFormat("dd/MM/yyyy").parse("01/"+new SimpleDateFormat("MM/yyyy").format(new java.util.Date())).getTime()-100));
        out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","chin",sWebLanguage),sCONTEXTPATH)
                +"<tr><td>"+getTran(request,"web","from",sWebLanguage)+"&nbsp;</td><td>"+writeDateField("begin2","stats",firstdayPreviousMonth,sWebLanguage)+"&nbsp;"+getTran(request,"web","to",sWebLanguage)+"&nbsp;"+writeDateField("end2","stats",lastdayPreviousMonth,sWebLanguage)+"&nbsp;</td></tr>"
                +writeTblChildWithCode("javascript:hospitalReport()",getTran(request,"Web","chin.global.hospital.report",sWebLanguage))
                +writeTblChildWithCode("javascript:minisanteReport()",getTran(request,"Web","chin.minisantereport.health.center",sWebLanguage))
                +writeTblChildWithCode("javascript:minisanteReportDH()",getTran(request,"Web","chin.minisantereport.district.hospital",sWebLanguage))
                +writeTblChildWithCode("javascript:openPopup(\"chin/chinGraph.jsp&ts="+getTs()+"\",1000,750)",getTran(request,"Web","chin.actualsituation",sWebLanguage))
                +writeTblChildWithCode("main.jsp?Page=healthnet/index.jsp&ts="+getTs(),getTran(request,"Web","chin.healthnet",sWebLanguage))
           +ScreenHelper.writeTblFooter()+"<br>");
    }
%>
</form>
<script type="text/javascript">
	function downloadStats(query,db){
	    var w=window.open("<c:url value='/util/csvStats.jsp?'/>query="+query+"&db="+db+"&begin="+document.getElementsByName('begin')[0].value+"&end="+document.getElementsByName('end')[0].value);
	}
	function downloadDatacenterStats(query,db){
	    var w=window.open("<c:url value='/datacenterstatistics/csvStats.jsp?'/>query="+query+"&db="+db+"&begin="+document.getElementsByName('begin')[0].value+"&end="+document.getElementsByName('end')[0].value);
	}
    function minisanteReport(){
        var w=window.open("<c:url value='/statistics/createMonthlyReportPdf.jsp?'/>start="+document.getElementById('begin2').value+"&end="+document.getElementById('end2').value+"&ts=<%=getTs()%>");
    }
    function minisanteReportDH(){
        var w=window.open("<c:url value='/statistics/createMonthlyReportPdfDH.jsp?'/>start="+document.getElementById('begin2').value+"&end="+document.getElementById('end2').value+"&ts=<%=getTs()%>");
    }
    function hospitalReport(){
        var w=window.open("<c:url value='/statistics/printHospitalReportChapterSelection.jsp?'/>start="+document.getElementById('begin2').value+"&end="+document.getElementById('end2').value+"&ts=<%=getTs()%>");
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
    function incomeVentilation(){
		var URL = "statistics/incomeVentilation.jsp&start="+document.getElementById('begin3').value+"&end="+document.getElementById('end3').value+"&statserviceid="+document.getElementById('statserviceid').value+"&ts=<%=getTs()%>";
		openPopup(URL,800,600,"OpenClinic");
    }
    function incomeVentilationExtended(){
		var URL = "statistics/incomeVentilationExtended.jsp&start="+document.getElementById('begin3').value+"&end="+document.getElementById('end3').value+"&statserviceid="+document.getElementById('statserviceid').value+"&ts=<%=getTs()%>";
		openPopup(URL,800,600,"OpenClinic");
    }
    function getOpenInvoices(){
		var URL = "statistics/openInvoiceLists.jsp&start="+document.getElementById('beginfin').value+"&end="+document.getElementById('endfin').value+"&ts=<%=getTs()%>";
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
    function oldandnewcases(){
		var URL = "statistics/oldAndNewCasesCNAR.jsp&start="+document.getElementById('begincnar').value+"&end="+document.getElementById('endcnar').value+"&ts=<%=getTs()%>";
		openPopup(URL,200,200,"OpenClinic");
    }
    function cnaretiology(){
		var URL = "statistics/cnarEtiology.jsp&start="+document.getElementById('begincnar').value+"&end="+document.getElementById('endcnar').value+"&ts=<%=getTs()%>";
		openPopup(URL,800,600,"OpenClinic");
    }
    function cnarcasesmanaged(){
		var URL = "statistics/cnarCasesManaged.jsp&start="+document.getElementById('begincnar').value+"&end="+document.getElementById('endcnar').value+"&ts=<%=getTs()%>";
		openPopup(URL,800,600,"OpenClinic");
    }
    function cnarcasesmanagedperservice(){
		var URL = "statistics/cnarCasesManagedPerService.jsp&serviceuid="+document.getElementById('statserviceid2').value+"&start="+document.getElementById('begincnar').value+"&end="+document.getElementById('endcnar').value+"&ts=<%=getTs()%>";
		openPopup(URL,800,600,"OpenClinic");
    }
    function cnarkine(){
		var URL = "statistics/cnarKine.jsp&start="+document.getElementById('begincnar').value+"&end="+document.getElementById('endcnar').value+"&ts=<%=getTs()%>";
		openPopup(URL,800,600,"OpenClinic");
    }
    function cnarorthesis(){
		var URL = "statistics/cnarOrthesis.jsp&start="+document.getElementById('begincnar').value+"&end="+document.getElementById('endcnar').value+"&ts=<%=getTs()%>";
		openPopup(URL,800,600,"OpenClinic");
    }
    function cnarorthesisdetail(){
		var URL = "statistics/cnarOrthesisDetail.jsp&start="+document.getElementById('begincnar').value+"&end="+document.getElementById('endcnar').value+"&ts=<%=getTs()%>";
		openPopup(URL,800,600,"OpenClinic");
    }
    function cnarmobile(){
		var URL = "statistics/cnarMobile.jsp&start="+document.getElementById('begincnar').value+"&end="+document.getElementById('endcnar').value+"&ts=<%=getTs()%>";
		openPopup(URL,800,600,"OpenClinic");
    }
    function cnareducation(){
		var URL = "statistics/cnarEducation.jsp&start="+document.getElementById('begincnar').value+"&end="+document.getElementById('endcnar').value+"&ts=<%=getTs()%>";
		openPopup(URL,800,600,"OpenClinic");
    }
    function cnardiseases(){
		var URL = "statistics/cnarDiseases.jsp&start="+document.getElementById('begincnar').value+"&end="+document.getElementById('endcnar').value+"&ts=<%=getTs()%>";
		openPopup(URL,800,600,"OpenClinic");
    }
    function newpatients(){
		var URL = "statistics/newPatients.jsp&start="+document.getElementById('begincnar').value+"&end="+document.getElementById('endcnar').value+"&ts=<%=getTs()%>";
		openPopup(URL,200,200,"OpenClinic");
    }
    function agedistribution(){
		var URL = "statistics/ageDistributionCNAR.jsp&start="+document.getElementById('begincnar').value+"&end="+document.getElementById('endcnar').value+"&ts=<%=getTs()%>";
		openPopup(URL,200,650,"OpenClinic");
    }
    function genderdistribution(){
		var URL = "statistics/genderGraph.jsp?start="+document.getElementById('begincnar').value+"&end="+document.getElementById('endcnar').value+"&ts=<%=getTs()%>";
		window.open(URL);
    }
    function searchService(serviceUidField,serviceNameField){
        openPopup("_common/search/searchService.jsp&ts=<%=getTs()%>&showinactive=1&VarCode="+serviceUidField+"&VarText="+serviceNameField);
        document.getElementsByName(serviceNameField)[0].focus();
    }
    
</script>