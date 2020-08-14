<%@page import="java.util.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>

<%!
    //--- SORT MENU -------------------------------------------------------------------------------
    private String sortMenu(Hashtable hMenu){
        Vector keys = new Vector(hMenu.keySet());
        Collections.sort(keys);
        Iterator iter = keys.iterator();

        // to html
        String sLabel, sLink, sOut = "";
        int rowIdx = 0;
        
        while(iter.hasNext()){
            sLabel = (String)iter.next();
            sLink = (String)hMenu.get(sLabel);
            sOut+= writeTblChild(sLink,sLabel,rowIdx++,true);
        }

        return sOut;
    }
%>

<table width="100%" cellpadding="0" cellspacing="0">
<tr>
<td width="50%" style="vertical-align:top;">
    <%-- MANAGEMENT --%>
    <table width="100%" cellspacing="2" cellpadding="0">
        <tr>
            <td>
                <%
                    Hashtable hMenu = new Hashtable();
	                hMenu.put(getTran(request,"web","manageAssetNomenclature",sWebLanguage),"main.do?Page=system/manageAssetNomenclature.jsp");
	                hMenu.put(getTran(request,"web","manageAssetComponentNomenclature",sWebLanguage),"main.do?Page=system/manageAssetComponentNomenclature.jsp");
                    hMenu.put(getTran(request,"web.manage","ManageServices",sWebLanguage),"main.do?Page=system/manageServices.jsp");
                    hMenu.put(getTran(request,"web.manage","ManagePassword",sWebLanguage),"main.do?Page=system/managePassword.jsp");
                    hMenu.put(getTran(request,"web.manage","ManageServers",sWebLanguage),"main.do?Page=system/manageServers.jsp");
                    hMenu.put(getTran(request,"web.manage","intrusionmanagement",sWebLanguage),"main.do?Page=system/manageIntrusions.jsp");
                    hMenu.put(getTran(request,"web.manage","ManageAssetSuppliers",sWebLanguage),"main.do?Page=assets/manage_suppliers.jsp");
                    hMenu.put(getTran(request,"web.manage","ManageStandards",sWebLanguage),"main.do?Page=system/manageStandards.jsp");
                    hMenu.put(getTran(request,"web.manage","managelibrary",sWebLanguage),"main.do?Page=system/manageLibrary.jsp");

                    out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","Manage",sWebLanguage),sCONTEXTPATH)+
                    		  sortMenu(hMenu)+
                    		  ScreenHelper.writeTblFooter());
                %>
            </td>
        </tr>
    </table>
    
    <div style="height:12px;">
    
    <%-- DATABASE --%>
    <table width="100%" cellspacing="2" cellpadding="0">
        <tr>
            <td>
                <% 
                    hMenu = new Hashtable();
                    hMenu.put(getTran(request,"Web.Occup","medwan.common.execute-sql",sWebLanguage),"main.do?Page=system/executeSQL.jsp");
                    hMenu.put(getTran(request,"web.manage","MonitorConnections",sWebLanguage),"main.do?Page=system/monitorConnections.jsp");
                    hMenu.put(getTran(request,"web.manage","MonitorAccess",sWebLanguage),"main.do?Page=system/monitorAccess.jsp");
                    hMenu.put(getTran(request,"web.manage","ViewErrors",sWebLanguage),"main.do?Page=system/monitorErrors.jsp");
                    hMenu.put(getTran(request,"web.manage","processUpdateQueries",sWebLanguage),"main.do?Page=system/processUpdateQueries.jsp");

                    out.print(ScreenHelper.writeTblHeader(getTran(request,"web.manage","Database",sWebLanguage),sCONTEXTPATH)+
                    		  sortMenu(hMenu)+
                    		  ScreenHelper.writeTblFooter());
                %>
            </td>
        </tr>
    </table>
    
    <div style="height:12px;">
    
    <%-- SETUP --%>
    <table width="100%" cellspacing="2" cellpadding="0">
        <tr>
            <td>
                <%
                    hMenu = new Hashtable();
	                hMenu.put(getTran(request,"Web.Occup","medwan.common.db-management",sWebLanguage),"main.do?Page=system/checkDB.jsp");
	                hMenu.put(getTran(request,"Web.Occup","cleandb",sWebLanguage),"main.do?Page=system/cleanDb.jsp");
                    hMenu.put(getTran(request,"web.manage","ManageConfiguration",sWebLanguage),"main.do?Page=system/manageConfig.jsp");
                    hMenu.put(getTran(request,"web.manage","ManageConfigurationTabbed",sWebLanguage),"main.do?Page=system/manageConfigTabbed.jsp");
                    hMenu.put(getTran(request,"web.manage","ManageConfigurationPerCategory",sWebLanguage),"main.do?Page=util/configparameters.jsp");
                    hMenu.put(getTran(request,"web.manage","ManageServerId",sWebLanguage),"main.do?Page=system/manageServerId.jsp");
                    hMenu.put(getTran(request,"web.manage","applications",sWebLanguage),"main.do?Page=system/manageApplications.jsp");
                    hMenu.put(getTran(request,"web.manage","manageSiteLabels",sWebLanguage),"main.do?Page=system/manageSiteLabels.jsp");
                    hMenu.put(getTran(request,"web.manage","manageSlaveServer",sWebLanguage),"main.do?Page=system/manageSlaveServer.jsp");
                    hMenu.put(getTran(request,"web.manage","manageGglobalhealthbarometerdata",sWebLanguage),"main.do?Page=system/manageGlobalHealthBarometerData.jsp");
                    hMenu.put(getTran(request,"web.manage","manageDateFormat",sWebLanguage),"main.do?Page=system/manageDateFormat.jsp");
                    hMenu.put(getTran(request,"web.manage","gmaoconfig",sWebLanguage),"main.do?Page=system/manageGMAO.jsp");

                    out.print(ScreenHelper.writeTblHeader(getTran(request,"web.manage","setup",sWebLanguage),sCONTEXTPATH)+
                    		  sortMenu(hMenu)+
                    		  ScreenHelper.writeTblFooter());
                %>
            </td>
        </tr>
    </table>
</td>

<td width="50%" style="vertical-align:top;">
    <%-- SYNCHRONISATIE --%>
    <table width="100%" cellspacing="2" cellpadding="0">
        <tr>
            <td>
                <%
                    hMenu = new Hashtable();
                    hMenu.put(getTran(request,"web.manage","SynchronizeLabelsWithIni",sWebLanguage),"main.do?Page=system/syncLabelsWithIni.jsp");
                    hMenu.put(getTran(request,"web.manage","synchronization.of.counters",sWebLanguage),"main.do?Page=system/countersSync.jsp");
                    hMenu.put(getTran(request,"web.manage","update.all",sWebLanguage),"main.do?Page=util/updateSystem.jsp");
                    hMenu.put(getTran(request,"web.manage","configure.core",sWebLanguage),"main.do?Page=system/resetDefaults.jsp");
                    hMenu.put(getTran(request,"web.manage","load.file",sWebLanguage),"main.do?Page=system/loadTable.jsp");
                    hMenu.put(getTran(request,"web.manage","export.labels",sWebLanguage),"main.do?Page=system/exportLabels.jsp");

                    out.print(ScreenHelper.writeTblHeader(getTran(request,"web.manage","Synchronization",sWebLanguage),sCONTEXTPATH)+
                    		  sortMenu(hMenu)+
                    		  ScreenHelper.writeTblFooter());
                %>
            </td>
        </tr>
    </table>
    
    <div style="height:12px;">
    
    <%-- TRANSLATIONS --%>
    <table width="100%" cellspacing="2" cellpadding="0">
        <tr>
            <td>
                <%
                    hMenu = new Hashtable();
                    hMenu.put(getTran(request,"Web","ManageTranslations",sWebLanguage),"main.do?Page=system/manageTranslations.jsp");
                    hMenu.put(getTran(request,"Web","ManageTranslationsBulk",sWebLanguage),"main.do?Page=system/manageTranslationsBulk.jsp");
                    hMenu.put(getTran(request,"web.manage","Translations",sWebLanguage),"main.do?Page=system/reloadTranslations.jsp");

                    out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","Translations",sWebLanguage),sCONTEXTPATH)+
                              sortMenu(hMenu)+
                              ScreenHelper.writeTblFooter());
                %>
            </td>
        </tr>
    </table>
    
    
    <div style="height:12px;">
    
    <%-- OTHER --%>
    <table width="100%" cellspacing="2" cellpadding="0">
        <tr>
            <td>
                <%
                    int idx = 0;
                    hMenu = new Hashtable();
	                hMenu.put(getTran(request,"web.manage","memoryprofile",sWebLanguage),"main.do?Page=util/profile.jsp"); idx++;
	                hMenu.put(getTran(request,"web.manage","notifiermessages",sWebLanguage),"main.do?Page=system/manageNotifierMessages.jsp"); idx++;
                    hMenu.put(getTran(request,"web.manage","ManageSystemMessage",sWebLanguage),"main.do?Page=system/manageSystemMessage.jsp"); idx++;
                    hMenu.put(getTran(request,"web.manage","managereports",sWebLanguage),"main.do?Page=system/manageReports.jsp"); idx++;
                    hMenu.put(getTran(request,"web.manage","manageworddocuments",sWebLanguage),"main.do?Page=system/manageWordDocuments.jsp"); idx++;
                    hMenu.put(getTran(request,"web.manage","reloadservices",sWebLanguage),"main.do?Page=util/clearServices.jsp"); idx++;

                    // depends on selection of activePatient
                    out.print(ScreenHelper.writeTblHeader(getTran(request,"web.occup","medwan.common.other",sWebLanguage),sCONTEXTPATH)+
	                          sortMenu(hMenu)+
	                          (activePatient!=null?writeTblChildWithCode("javascript:printUserCard()",getTran(request,"web.manage","createusercard",sWebLanguage),idx++):"")+
	                          writeTblChildWithCode("javascript:toggleEditMode()",getTran(request,"web.manage","toggleeditmode",sWebLanguage)+" <span id='editmode'>("+(checkString((String)session.getAttribute("editmode")).equalsIgnoreCase("1")?getTran(request,"web","editon",sWebLanguage):getTran(request,"web","off",sWebLanguage))+")</span>",idx++)+
	                          ScreenHelper.writeTblFooter());
                %>
            </td>
        </tr>
    </table>
    
    <div style="height:12px;">
    
</td>
</tr>
</table>

<script>
  function printUserCard(){
	var url = "<c:url value='/userprofile/createUserCardPdf.jsp'/>"+
	          "?cardtype=<%=MedwanQuery.getInstance().getConfigString("userCardType","default")%>"+
	          "&ts=<%=getTs()%>";
    window.open(url,"Popup"+new Date().getTime(),"toolbar=no,status=yes,scrollbars=yes,resizable=yes,width=400,height=300,menubar=no").moveTo((screen.width-400)/2,(screen.height-300)/2);
  }
  
</script>