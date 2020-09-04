<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

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
	              writeTblChildWithCode("javascript:oldandnewcases()",getTran(request,"Web","statistics.oldandnewcases",sWebLanguage))+
	              writeTblChildWithCode("javascript:newpatients()",getTran(request,"Web","statistics.newpatients",sWebLanguage))+
	              writeTblChildWithCode("javascript:agedistribution()",getTran(request,"Web","statistics.agedistribution",sWebLanguage)));
        out.print(ScreenHelper.writeTblFooter()+"<br>");
	}

    //*** 2 - QUICK DIAGNOSIS ENTRY ***************************************************************
    if(activeUser.getAccessRight("patient.administration.add") || activeUser.getAccessRight("statistics.quickdiagnosisentry")){
         out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","statistics.quickdiagnosisentry",sWebLanguage),sCONTEXTPATH));
         out.print(writeTblChildWithCode("javascript:openPopup(\"statistics/quickFile.jsp\",1000,600,\"quickFile\");void(0);",getTran(request,"Web","statistics.quickdiagnosisentry",sWebLanguage)));
         out.print(ScreenHelper.writeTblFooter()+"<br>");
    }

    //*** 3 - PATHOLOGY ***************************************************************************
    if(activeUser.getAccessRight("statistics.globalpathologydistribution.select")){
        out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","statistics.pathologystats",sWebLanguage),sCONTEXTPATH));
        out.print(writeTblChildNoButton("main.do?Page=statistics/diagnosisStats.jsp",getTran(request,"Web","statistics.globalpathology",sWebLanguage))+
        		  writeTblChildNoButton("main.do?Page=statistics/mortality.jsp",getTran(request,"Web","statistics.mortality",sWebLanguage))+
                  writeTblChildNoButton("main.do?Page=statistics/diagnosesList.jsp",getTran(request,"Web","statistics.diagnosisList",sWebLanguage)));
        out.print(ScreenHelper.writeTblFooter()+"<br>");
    }

    //*** 4 - TECHNICAL STATS *********************************************************************
    if(activeUser.getAccessRight("statistics.select")){        
        out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","statistics.technicalstats",sWebLanguage),sCONTEXTPATH));
        out.println(writeTblChildWithCode("javascript:downloadTechnicalStats(\"undelivered.rwamaterial.orders\",\"openclinic\");",getTran(request,"Web","statistics.download.undelivered.rwamaterial.orders",sWebLanguage)));
        out.print("<tr>"+
                   "<td class='admin2' colspan='2'>"+
                    getTran(request,"web","from",sWebLanguage)+"&nbsp;"+writeDateField("begintech","stats",firstdayPreviousMonth,sWebLanguage)+"&nbsp;&nbsp;"+
                    getTran(request,"web","to",sWebLanguage)+"&nbsp;"+writeDateField("endtech","stats",lastdayPreviousMonth,sWebLanguage)+
                   "</td>"+
                  "</tr>"+
                  writeTblChildWithCode("javascript:labStatistics()",getTran(request,"Web","statistics.lab",sWebLanguage))+
			      writeTblChildWithCode("javascript:labExtraction()",getTran(request,"Web","statistics.lab.extraction",sWebLanguage)));
        out.print(ScreenHelper.writeTblFooter()+"<br>");
    }

    //*** 5 - ACTIVITY STATS **********************************************************************
    if(activeUser.getAccessRight("statistics.select")){
        out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","statistics.activitystats",sWebLanguage),sCONTEXTPATH));
        out.print(writeTblChildNoButton("main.do?Page=statistics/databaseStatistics.jsp",getTran(request,"Web","statistics.activitystats.database",sWebLanguage))+
                  writeTblChildNoButton("main.do?Page=statistics/diagnosticCodingStats.jsp",getTran(request,"Web","statistics.activitystats.diagnosticcoding",sWebLanguage))+
                  writeTblChildNoButton("main.do?Page=statistics/encounterCodingStats.jsp",getTran(request,"Web","statistics.activitystats.encountercoding",sWebLanguage))+
                  writeTblChildNoButton("main.do?Page=statistics/recordViewingStats.jsp",getTran(request,"Web","statistics.activitystats.recordviewing",sWebLanguage))+
                  writeTblChildNoButton("main.do?Page=statistics/transactionViewingStats.jsp",getTran(request,"Web","statistics.activitystats.transactionviewing",sWebLanguage)));
                  //writeTblChildNoButton("main.do?Page=statistics/prestationCodingStats.jsp",getTran(request,"Web","statistics.activitystats.prestationcoding",sWebLanguage))
        out.print(ScreenHelper.writeTblFooter()+"<br>");

        //*** 5a - INSURANCE AND INVOICING STATS ***************        
        out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","statistics.insuranceandinvoicingstats",sWebLanguage),sCONTEXTPATH));
        out.print("<tr>"+
                   "<td class='admin2' colspan='2'>"+
                    getTran(request,"web","from",sWebLanguage)+"&nbsp;"+writeDateField("begin3","stats",firstdayPreviousMonth,sWebLanguage)+"&nbsp;&nbsp;"+
                    getTran(request,"web","to",sWebLanguage)+"&nbsp;"+writeDateField("end3","stats",lastdayPreviousMonth,sWebLanguage)+
                   "</td>"+
                  "</tr>");
        out.print(writeTblChildWithCode("javascript:insuranceReport()",getTran(request,"Web","statistics.insurancestats.distribution",sWebLanguage))+
	              writeTblChildWithCode("javascript:incomeVentilation()",getTran(request,"Web","statistics.incomeVentilationPerFamily",sWebLanguage))+
	              writeTblChildWithCode("javascript:incomeVentilationExtended()",getTran(request,"Web","statistics.incomeVentilationPerCategoryAndService",sWebLanguage))+
	              writeTblChildWithCode("javascript:incomeVentilationPerformers()",getTran(request,"Web","statistics.incomeVentilationPerPerformer",sWebLanguage))+
	              writeTblChildWithCode("javascript:paymentrate()",getTran(request,"Web","statistics.paymentrate",sWebLanguage)));
        out.print(ScreenHelper.writeTblFooter()+"<br>");
        
        String service = activeUser.activeService.code;
        String serviceName = activeUser.activeService.getLabel(sWebLanguage);
        
        String today = ScreenHelper.formatDate(new java.util.Date()); // now

        //*** 5b - TREATED PATIENTS ****************************
        out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","statistics.treatedpatients",sWebLanguage),sCONTEXTPATH));
        out.print("<tr>"+
                   "<td class='admin2' colspan='2'>"+
                    getTran(request,"web","from",sWebLanguage)+"&nbsp;"+writeDateField("begin3b","stats",today,sWebLanguage)+"&nbsp;&nbsp;"+
                    getTran(request,"web","to",sWebLanguage)+"&nbsp;"+writeDateField("end3b","stats",today,sWebLanguage)+
                   "</td>"+
                  "</tr>"+
			      writeTblChildWithCode("javascript:extractspt()",getTran(request,"Web","statistics.extractspt",sWebLanguage)));

        
        out.print("<tr>"+
                   "<td class='admin2' colspan='2'>"+getTran(request,"Web","service",sWebLanguage)+" "+
                    "<input type='hidden' name='statserviceid' id='statserviceid' value='"+service+"'>"+
                    "<input class='text' type='text' name='statservicename' id='statservicename' readonly size='"+sTextWidth+"' value='"+serviceName+"'>&nbsp;"+
                    "<img src='_img/icons/icon_search.png' class='link' alt='"+getTranNoLink("Web","select",sWebLanguage)+"' onclick='searchService(\"statserviceid\",\"statservicename\");'>&nbsp;"+
                    "<img src='_img/icons/icon_delete.png' class='link' alt='"+getTranNoLink("Web","clear",sWebLanguage)+"' onclick='statserviceid.value=\"\";statservicename.value=\"\";'>"+
                   "</td>"+
                  "</tr>"+
                  writeTblChildWithCode("javascript:patientslistvisits()",getTran(request,"Web","statistics.patientslist.visits",sWebLanguage))+
                  writeTblChildWithCode("javascript:patientslistadmissions()",getTran(request,"Web","statistics.patientslist.admissions",sWebLanguage))+
                  writeTblChildWithCode("javascript:patientslistsummary()",getTran(request,"Web","statistics.patientslist.summary",sWebLanguage)));
        out.print(ScreenHelper.writeTblFooter()+"<br>");

        //*** 5c - SERVICE STATS *******************************
        out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","statistics.servicestats",sWebLanguage),sCONTEXTPATH)+
                  writeTblChildNoButton("main.do?Page=statistics/hospitalStats.jsp",getTran(request,"Web","statistics.hospitalstats.global",sWebLanguage))+
                  writeTblChildNoButton("main.do?Page=statistics/serviceStats.jsp",getTran(request,"Web","statistics.servicestats.contacts",sWebLanguage))+
                  writeTblChildNoButton("main.do?Page=statistics/districtStats.jsp",getTran(request,"Web","statistics.districtstats",sWebLanguage)));

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
        );
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
        out.print(writeTblChildWithCodeNoButton("javascript:downloadStats(\"patients.list\",\"openclinic\");",getTran(request,"Web","statistics.download.patients",sWebLanguage))+
                  "<tr>"+
        		   "<td class='admin2' colspan='2'>"+
                    getTran(request,"web","from",sWebLanguage)+"&nbsp;"+writeDateField("begin","stats",b,sWebLanguage)+"&nbsp;&nbsp;"+
        		    getTran(request,"web","to",sWebLanguage)+"&nbsp;"+writeDateField("end","stats",e,sWebLanguage)+
        		   "</td>"+
        		  "</tr>"+
                  writeTblChildWithCodeNoButton("javascript:downloadStats(\"global.list\",\"openclinic\");",getTran(request,"Web","statistics.download.global",sWebLanguage))+
                  writeTblChildWithCodeNoButton("javascript:downloadStats(\"globalrfe.list\",\"openclinic\");",getTran(request,"Web","statistics.download.globalrfe",sWebLanguage))+
                  writeTblChildWithCodeNoButton("javascript:downloadStats(\"encounter.list\",\"openclinic\");",getTran(request,"Web","statistics.download.encounterlist",sWebLanguage))+
                  writeTblChildWithCodeNoButton("javascript:downloadStats(\"diagnosis.list\",\"openclinic\");",getTran(request,"Web","statistics.download.diagnosislist",sWebLanguage))+
                  writeTblChildWithCodeNoButton("javascript:downloadStats(\"rfe.list\",\"openclinic\");",getTran(request,"Web","statistics.download.rfelist",sWebLanguage))+
                  writeTblChildWithCodeNoButton("javascript:downloadStats(\"document.list\",\"openclinic\");",getTran(request,"Web","statistics.download.documentlist",sWebLanguage))+
                  writeTblChildWithCodeNoButton("javascript:downloadStats(\"user.list\",\"admin\");",getTran(request,"Web","statistics.download.userlist",sWebLanguage))+
                  writeTblChildWithCodeNoButton("javascript:downloadStats(\"service.list\",\"openclinic\");",getTran(request,"Web","statistics.download.servicelist",sWebLanguage))+
                  writeTblChildWithCodeNoButton("javascript:downloadStats(\"debet.list\",\"openclinic\");",getTran(request,"Web","statistics.download.debetlist",sWebLanguage))+
                  writeTblChildWithCodeNoButton("javascript:downloadStats(\"debet.list.per.encounter\",\"openclinic\");",getTran(request,"Web","statistics.download.debetlist.per.encounter",sWebLanguage))+
                  writeTblChildWithCodeNoButton("javascript:downloadStats(\"prestation.list\",\"openclinic\");",getTran(request,"Web","statistics.download.prestationlist",sWebLanguage))+
                  writeTblChildWithCodeNoButton("javascript:downloadStats(\"wicketcredits.list\",\"openclinic\");",getTran(request,"Web","statistics.download.wicketcredits",sWebLanguage))+
                  writeTblChildWithCodeNoButton("javascript:downloadStats(\"lab.list\",\"openclinic\");",getTran(request,"Web","statistics.download.labresults",sWebLanguage))+
                  writeTblChildWithCodeNoButton("javascript:downloadStats(\"imaging.list\",\"openclinic\");",getTran(request,"Web","statistics.download.imagingresults",sWebLanguage))+
                  writeTblChildWithCodeNoButton("javascript:downloadInvoicesSummary(\"hmk.invoices.list\",\"openclinic\");",getTran(request,"Web","statistics.download.invoicessummary",sWebLanguage))+
                  (MedwanQuery.getInstance().getConfigInt("enablePBFBurundi",0)==1?writeTblChildWithCodeNoButton("javascript:downloadPBFdocs(\"pbf.burundi.consultationslist\",\"openclinic\");",getTran(request,"Web","statistics.download.pbfburundi",sWebLanguage)):"")+
                  (MedwanQuery.getInstance().getConfigInt("enablePBFBurundi",0)==1?writeTblChildWithCodeNoButton("javascript:downloadPBFdocs(\"pbf.burundi.admissionslist\",\"openclinic\");",getTran(request,"Web","statistics.download.pbfburundi.admissions",sWebLanguage)):"")+
                  (MedwanQuery.getInstance().getConfigInt("enablePBFBurundi",0)==1?writeTblChildWithCodeNoButton("javascript:downloadPBFdocsNoService(\"pbf.burundi.surgerylist\",\"openclinic\");",getTran(request,"Web","statistics.download.pbfburundi.surgerylist",sWebLanguage)):"")+
                  (MedwanQuery.getInstance().getConfigInt("enablePBFBurundi",0)==1?writeTblChildWithCodeNoButton("javascript:downloadPBFdocsNoService(\"pbf.burundi.deliverieslist\",\"openclinic\");",getTran(request,"Web","statistics.download.pbfburundi.deliverieslist",sWebLanguage)):"")+
                  (MedwanQuery.getInstance().getConfigInt("enablePBFBurundi",0)==1?writeTblChildWithCodeNoButton("javascript:downloadPBFdocsNoService(\"pbf.burundi.lab.hiv\",\"openclinic\");",getTran(request,"Web","statistics.download.pbfburundi.labhiv",sWebLanguage)):"")+
                  (MedwanQuery.getInstance().getConfigInt("enablePBFBurundi",0)==1?writeTblChildWithCodeNoButton("javascript:downloadPBFdocsNoService(\"pbf.burundi.lab.tb\",\"openclinic\");",getTran(request,"Web","statistics.download.pbfburundi.tb",sWebLanguage)):"")+
                  (MedwanQuery.getInstance().getConfigInt("enablePBFBurundi",0)==1?writeTblChildWithCodeNoButton("javascript:downloadPBFdocsNoService(\"pbf.burundi.familyplanninglist\",\"openclinic\");",getTran(request,"Web","statistics.download.pbfburundi.familyplanninglist",sWebLanguage)):"")+
                  (MedwanQuery.getInstance().getConfigInt("enablePBFBurundi",0)==1?writeTblChildWithCodeNoButton("javascript:downloadPBFdocsInsurer(\"insurer.userlist\",\"openclinic\");",getTran(request,"Web","statistics.download.insurer.userlist",sWebLanguage)):"")+
                  (MedwanQuery.getInstance().getConfigInt("enableMaliVaccinations",0)==1?writeTblChildWithCodeNoButton("javascript:downloadStats(\"vida\",\"stats\");",getTran(request,"Web","statistics.download.vida",sWebLanguage)):"")+
                  (MedwanQuery.getInstance().getConfigInt("enableCNRKR",0)==1?writeTblChildWithCodeNoButton("javascript:downloadStats(\"cnrkr.burundi.consultationslist\",\"openclinic\");",getTran(request,"Web","cnrkr.consultation.activitylist",sWebLanguage)):"")+
                  (MedwanQuery.getInstance().getConfigInt("enableCNRKR",0)==1?writeTblChildWithCodeNoButton("javascript:downloadStats(\"cnrkr.burundi.kinelist\",\"openclinic\");",getTran(request,"Web","cnrkr.kine.activitylist",sWebLanguage)):"")+
			      (MedwanQuery.getInstance().getConfigInt("datacenterEnabled",0)==1?writeTblChildWithCodeNoButton("javascript:downloadDatacenterStats(\"service.income.list\",\"stats\");",getTran(request,"Web","statistics.download.serviceincomelist",sWebLanguage)):""));
        out.print(ScreenHelper.writeTblFooter()+"<br>");

        //*** 5e - PATHOLOGY ***********************************	    
        out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","financial",sWebLanguage),sCONTEXTPATH));	    
        out.print(writeTblChildNoButton("main.do?Page=statistics/toInvoiceLists.jsp",getTran(request,"Web","statistics.toinvoicelists",sWebLanguage))+
                  "<tr>"+
                   "<td class='admin2' colspan='2'>"+
                    getTran(request,"web","from",sWebLanguage)+"&nbsp;"+writeDateField("beginfin","stats",firstdayPreviousMonth,sWebLanguage)+"&nbsp;&nbsp;"+
                    getTran(request,"web","to",sWebLanguage)+"&nbsp;"+writeDateField("endfin","stats",lastdayPreviousMonth,sWebLanguage)+
                   "</td>"+
                  "</tr>"+
                  writeTblChildWithCode("javascript:getOpenInvoices()",getTran(request,"Web","statistics.openinvoicelists",sWebLanguage))+
                  writeTblChildWithCode("javascript:getClosedNonZeroInvoices()",getTran(request,"Web","statistics.closednonzeroinvoicelists",sWebLanguage))+
                  writeTblChildWithCode("javascript:getCanceledInvoices()",getTran(request,"Web","statistics.canceledinvoicelists",sWebLanguage))+
                  writeTblChildWithCode("javascript:getIssuedInsurerInvoices()",getTran(request,"Web","statistics.issuedinsurerinvoices",sWebLanguage))+
        		  writeTblChildWithCode("javascript:getUserInvoices()",getTran(request,"Web","statistics.userinvoices",sWebLanguage)));
        out.print(ScreenHelper.writeTblFooter()+"<br>");

        //*** 5f - MFP *****************************************
        if(MedwanQuery.getInstance().getConfigInt("enableMFP",0)==1){
	        out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","MFP",sWebLanguage),sCONTEXTPATH));
	        out.print("<tr>"+
	                   "<td class='admin2' colspan='2'>"+
	                    getTran(request,"web","from",sWebLanguage)+"&nbsp;"+writeDateField("beginmfp","stats",sBeginOfYear,sWebLanguage)+"&nbsp;&nbsp;"+
	                    getTran(request,"web","to",sWebLanguage)+"&nbsp;"+writeDateField("endmfp","stats",sEndOfYear,sWebLanguage)+
	                   "</td>"+
	                  "</tr>"+
                      "<tr>"+
	                   "<td class='admin2'>"+getTran(request,"Web","service",sWebLanguage)+"</td>"+
                       "<td class='admin2' colspan='2'>"+
	                    "<input type='hidden' name='mfpserviceid' id='mfpserviceid' value='"+service+"'>"+
                        "<input class='text' type='text' name='mfpservicename' id='mfpservicename' readonly size='"+sTextWidth+"' value='"+serviceName+"'>&nbsp;"+
                        "<img src='_img/icons/icon_search.png' class='link' alt='"+getTranNoLink("Web","select",sWebLanguage)+"' onclick='searchService(\"mfpserviceid\",\"mfpservicename\");'>&nbsp;"+
                        "<img src='_img/icons/icon_delete.png' class='link' alt='"+getTranNoLink("Web","clear",sWebLanguage)+"' onclick='mfpserviceid.value=\"\";mfpservicename.value=\"\";'>"+
                       "</td>"+
               	      "</tr>"+
                      writeTblChildWithCode("javascript:getMFPSummary()",getTran(request,"Web","statistics.mfpsummary",sWebLanguage))+
	                  writeTblChildWithCode("javascript:getMFPUnsignedInvoices()",getTran(request,"Web","statistics.mfpunsignedinvoices",sWebLanguage))+
	                  writeTblChildWithCode("javascript:getMFPAcceptedUnsignedInvoices()",getTran(request,"Web","statistics.mfpacceptedunsignedinvoices",sWebLanguage))+
	                  writeTblChildWithCode("javascript:getMFPUnvalidatedInvoices()",getTran(request,"Web","statistics.mfpunvalidatedinvoices",sWebLanguage)));
	        out.print(ScreenHelper.writeTblFooter()+"<br>");
        }
    }

    //*** 6 - CHIN ********************************************************************************
    if(activeUser.getAccessRight("statistics.chin.select")){      
        out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","chin",sWebLanguage),sCONTEXTPATH));
        out.print("<tr>"+
                writeTblChildWithCode("javascript:nationalreport()",getTran(request,"Web","nationalreport",sWebLanguage))+
                writeTblChildWithCode("javascript:dhis2report()",getTran(request,"Web","dhis2report",sWebLanguage))+
                   "<td class='admin2' colspan='2'>"+
                    getTran(request,"web","from",sWebLanguage)+"&nbsp;"+writeDateField("begin2","stats",firstdayPreviousMonth,sWebLanguage)+"&nbsp;&nbsp;"+
                    getTran(request,"web","to",sWebLanguage)+"&nbsp;"+writeDateField("end2","stats",lastdayPreviousMonth,sWebLanguage)+
                   "</td>"+
                  "</tr>"+
                  writeTblChildWithCode("javascript:coreStatistics()",getTran(request,"Web","statistics.activitystats.corestats",sWebLanguage))+
                  writeTblChildWithCode("javascript:hospitalReport()",getTran(request,"Web","chin.global.hospital.report",sWebLanguage))+
                  writeTblChildWithCode("javascript:minisanteReport()",getTran(request,"Web","chin.minisantereport.health.center",sWebLanguage))+
                  writeTblChildWithCode("javascript:minisanteReportDH()",getTran(request,"Web","chin.minisantereport.district.hospital",sWebLanguage))+
                  writeTblChildWithCode("javascript:jasperReports()",getTran(request,"Web","statistics.activitystats.jasperReports",sWebLanguage))+
                  writeTblChildWithCode("javascript:openPopup(\"chin/chinGraph.jsp&ts="+getTs()+"\",1000,750)",getTran(request,"Web","chin.actualsituation",sWebLanguage))+
                  writeTblChildWithCode("javascript:window.location.href=\"main.jsp?Page=healthnet/index.jsp&ts="+getTs()+"\"",getTran(request,"Web","chin.healthnet",sWebLanguage)));
        out.print(ScreenHelper.writeTblFooter());
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