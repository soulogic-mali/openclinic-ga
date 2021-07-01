<%@page import="org.dom4j.io.SAXReader,
                java.net.URL,
                org.dom4j.Document,
                org.dom4j.Element,
                be.mxs.common.util.db.MedwanQuery,
                be.mxs.common.util.system.*,
                org.dom4j.DocumentException,
                java.net.MalformedURLException,
                java.sql.PreparedStatement,
                java.util.Iterator,be.mxs.common.util.system.SessionMessage,be.openclinic.sync.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/helper.jsp"%>
<%@include file="/includes/SingletonContainer.jsp"%>

<%
if(!request.isSecure() && MedwanQuery.getInstance(true).getConfigString("forceInsecureRedirect","").length()>0){
	out.println("<script>window.location.href='"+MedwanQuery.getInstance(true).getConfigString("forceInsecureRedirect","")+"';</script>");
	out.flush();
}
if(MedwanQuery.getInstance(true).getConfigString("edition","openclinic").equalsIgnoreCase("mpi")){
	out.println("<script>window.location.href='"+sCONTEXTPATH+"/mpiLogin.jsp';</script>");
	out.flush();
}

	response.setHeader("Content-Type","text/html; charset=ISO-8859-1");
	session.setAttribute("javaPOSServer",checkString(request.getParameter("javaPOSServer")));
%>
<html>
<%
	if(MedwanQuery.getInstance().getConfigInt("disableMobileInterface",0)==0 && !"1".equalsIgnoreCase(checkString(request.getParameter("nomobile")))){
		// Automatically redirect mobile devices to OpenClinic Mobile login
%>
<script>
	(function(a,b){if(/android|avantgo|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(a)||/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|e\-|e\/|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(di|rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|xda(\-|2|g)|yas\-|your|zeto|zte\-/i.test(a.substr(0,4)))window.location=b})(navigator.userAgent||navigator.vendor||window.opera,'mobile/login.jsp');
</script>
<%
	}
%>
<head>
    <link rel="shortcut icon" href="favourite.ico"/>
    <META HTTP-EQUIV="Refresh" CONTENT="600">
    <%=sCSSDEFAULT%>
    <%=sJSCHAR%>
    <%=sJSPROTOTYPE%>
    <%=sJSCOOKIE%>
    <%=sJSDROPDOWNMENU%>
    <%=sJSSCRIPTS%>
    
    <%
    MedwanQuery.getInstance("http://"+request.getServerName()+":"+request.getServerPort()+request.getRequestURI().replaceAll(request.getServletPath(),"")+"/"+sAPPDIR);
    reloadSingleton(request.getSession());
    if(MedwanQuery.getInstance().getConfigInt("initializeSlaveCounters",0)==1){
		OpenclinicSlaveExporter openclinicSlaveExporter = new OpenclinicSlaveExporter(new SessionMessage());
		openclinicSlaveExporter.initializeCounters();
		MedwanQuery.getInstance().setConfigString("initializeSlaveCounters", "0");
    }
    UpdateSystem systemUpdate = new UpdateSystem();
    if(MedwanQuery.getInstance().getConfigString("doInitialSetup","").length()>0){
    	systemUpdate.updateSetup("os",MedwanQuery.getInstance().getConfigString("doInitialSetup",""),request);
    	MedwanQuery.getInstance().setConfigString("doInitialSetup","");
    }
    if(MedwanQuery.getInstance().getConfigString("edition","").equalsIgnoreCase("gmao")){
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	PreparedStatement ps = conn.prepareStatement("delete from oc_assets where (oc_asset_service = '' or oc_asset_service is null) and oc_asset_updatetime<?");
    	ps.setTimestamp(1, new Timestamp(new java.util.Date().getTime()-24*3600*1000));
    	ps.execute();
    	ps.close();
    	conn.close();
    }
    //*** retreive application version ***
    String version = "version unknown";
    try{
		if(MedwanQuery.getInstance().getConfigString("configureCountry","").length() > 0){
			systemUpdate.initialSetup("country", MedwanQuery.getInstance().getConfigString("configureCountry",""),request);
			MedwanQuery.getInstance().reloadConfigValues();
			MedwanQuery.getInstance().reloadLabels();
			MedwanQuery.getInstance().setConfigString("configureCountry","");
		}
    	String sDoc = MedwanQuery.getInstance().getConfigString("templateSource") + "application.xml";
        SAXReader reader = new SAXReader(false);
        Document document = reader.read(new URL(sDoc));
        Element element = document.getRootElement().element("version");
    	String sUpdateVersion = ""+MedwanQuery.getInstance().getConfigInt("updateVersion",0);
    	String sMajor = sUpdateVersion.substring(0,1),
    		   sMinor = sUpdateVersion.substring(1,sUpdateVersion.length()-3), 
    		   sBug   = sUpdateVersion.substring(sUpdateVersion.length()-3);  
    	if(sMinor.startsWith("0")) sMinor = sMinor.substring(1);  
    	if(sBug.startsWith("0")) sBug = sBug.substring(1);
    	sUpdateVersion = sMajor+"."+sMinor+"."+sBug;
        version = "v" + sUpdateVersion + " (" + element.attribute("date").getValue() + ")";
        session.setAttribute("ProjectVersion", version);
    }
    catch (Exception e) {
    	e.printStackTrace();
        // nothing
    }
    //close visits open at last midnight
    if(MedwanQuery.getInstance().getConfigInt("autoCloseVisits", 1)==1 && !MedwanQuery.getInstance().getConfigString("lastAutoCloseVisits","").equals(new SimpleDateFormat("yyyyMMdd").format(new java.util.Date()))){
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sSQL = "update oc_encounters set oc_encounter_enddate =oc_encounter_begindate,oc_encounter_outcome='missing' where oc_encounter_type='visit' and oc_encounter_enddate is null and oc_encounter_begindate<?";
            PreparedStatement ps = oc_conn.prepareStatement(sSQL);
            ps.setDate(1,new java.sql.Date(new java.util.Date().getTime()-(MedwanQuery.getInstance().getConfigInt("autoCloseVisitsAfterDays",1)-1)*ScreenHelper.getTimeDay()));
            ps.execute();
            ps.close();
            if(MedwanQuery.getInstance().getConfigString("lengthFunction").equalsIgnoreCase("len")){
            	//SQL Server
	            sSQL = "update oc_encounter_services set oc_encounter_serviceenddate=oc_encounter_enddate"+
	            		" from oc_encounter_services a, oc_encounters b"+
	            		" where"+
	            		" a.oc_encounter_objectid=b.oc_encounter_objectid and"+
	            		" a.oc_encounter_serviceenddate is null and"+
	            		" b.oc_encounter_enddate is not null";
            }
            else{
	            //MySQL
	            sSQL = "update oc_encounter_services a, oc_encounters b set oc_encounter_serviceenddate=oc_encounter_enddate"+
	            		" where"+
	            		" a.oc_encounter_objectid=b.oc_encounter_objectid and"+
	            		" a.oc_encounter_serviceenddate is null and"+
	            		" b.oc_encounter_enddate is not null";
            }            
            ps = oc_conn.prepareStatement(sSQL);
            ps.execute();
            ps.close();
            MedwanQuery.getInstance().setConfigString("lastAutoCloseVisits", new SimpleDateFormat("yyyyMMdd").format(new java.util.Date()));
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        try{
			oc_conn.close();
		} 
        catch(SQLException e){
			e.printStackTrace();
		}
    	
    }

    //close long admissions
    if(MedwanQuery.getInstance().getConfigInt("autoCloseAdmissions", 0)==1 && !MedwanQuery.getInstance().getConfigString("lastAutoCloseAdmissions","").equals(new SimpleDateFormat("yyyyMMdd").format(new java.util.Date()))){
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
        	String sSQL=MedwanQuery.getInstance().getConfigString("closeAdmisionServicesQuery","update oc_encounter_services,servicesview set oc_encounter_serviceenddate=date_add(oc_encounter_servicebegindate,INTERVAL (select max(serviceadmissionlimit) from servicesview where oc_encounter_serviceuid=serviceid) day) where OC_ENCOUNTER_SERVICEENDDATE is null and serviceadmissionlimit>0 and datediff(now(),OC_ENCOUNTER_SERVICEBEGINDATE)>serviceadmissionlimit and oc_encounter_serviceuid=serviceid and oc_encounter_serviceenddate is null");;
            if(MedwanQuery.getInstance().getConfigString("lengthFunction").equalsIgnoreCase("len")){
            	//SQL Server
	            sSQL = "update oc_encounter_services set oc_encounter_serviceenddate=dateadd(day,(select max(serviceadmissionlimit) from servicesview where oc_encounter_serviceuid=serviceid),oc_encounter_servicebegindate)"+
	            		" from oc_encounter_services a, servicesview b"+
	            		" where"+
	            		" a.oc_encounter_serviceenddate is null and"+
	            		" serviceadmissionlimit>0 and"+
	            		" oc_encounter_serviceuid=serviceid and"+
	            		" oc_encounter_serviceenddate is null";
            }
            PreparedStatement ps = oc_conn.prepareStatement(sSQL);
            ps.execute();
            ps.close();
         	sSQL=MedwanQuery.getInstance().getConfigString("closeAdmisionServicesQuery2","update oc_encounters set oc_encounter_enddate=(select max(oc_encounter_serviceenddate) from oc_encounter_services where oc_encounter_services.oc_encounter_serverid=oc_encounters.oc_encounter_serverid and oc_encounter_services.oc_encounter_objectid=oc_encounters.oc_encounter_objectid) where oc_encounter_enddate is null and  not exists (select * from oc_encounter_services where oc_encounter_services.oc_encounter_serverid=oc_encounters.oc_encounter_serverid and oc_encounter_services.oc_encounter_objectid=oc_encounters.oc_encounter_objectid and oc_encounter_serviceenddate is null)");
            ps = oc_conn.prepareStatement(sSQL);
            ps.execute();
            ps.close();
            MedwanQuery.getInstance().setConfigString("lastAutoCloseAdmissions", new SimpleDateFormat("yyyyMMdd").format(new java.util.Date()));
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        try{
			oc_conn.close();
		} 
        catch(SQLException e){
			e.printStackTrace();
		}
    	
    }

    //*** process 'updatequeries.xml' containing queries that need to be executed at login ***
    Object updateQueriesProcessedDate = application.getAttribute("updateQueriesProcessedDateOC");
    boolean processUpdateQueries = (updateQueriesProcessedDate == null);
    if (processUpdateQueries) {
		UpdateQueries.updateQueries(application);
    }
    else {
        // display last date of processing update queries
        if (updateQueriesProcessedDate != null && Debug.enabled) {
            SimpleDateFormat fullDateFormat = ScreenHelper.fullDateFormatSS;
            Debug.println("INFO : UpdateQueries last processed at " + fullDateFormat.format(updateQueriesProcessedDate));
        }
    }
%>
</head>
<body class="Geenscroll login" onkeydown="checkKeyDown()">
<script>
	function checkPopupsEnabled(){
		var newWin=window.open("checkPopup.jsp","","width=1,height=1");
		if(!newWin || newWin.closed || typeof newWin.closed=='undefined') 
		{ 
		     alert('<%=getTranNoLink("web","popupsblocked","en")%>');
		}
		if(newWin){
			newWin.close();
		}
	}
	
    if(window.parent.location.href.indexOf("/login.jsp")>-1){
    	checkPopupsEnabled();
    }

</script>

<%
	if("openinsurance".equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("edition",""))){
        %><div id="loginopeninsurance"><%
	}
	else{
        %><div id="login"><%
	}
%>
    <div id="logo">
        <% if ("datacenter".equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("edition",""))) {
            session.setAttribute("edition", "datacenter");%>
        	<img src="projects/datacenter/_img/logo.jpg" border="0">
        <% } else if ("openlab".equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("edition",""))) {
            session.setAttribute("edition", "openlab");%>
        	<img src="projects/openlab/_img/logo.jpg" border="0">
        <% } else if ("openpharmacy".equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("edition",""))) {
            session.setAttribute("edition", "openpharmacy");%>
        	<img src="_img/openpharmacy_logo.jpg" border="0">
        <% } else if ("openinsurance".equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("edition",""))) {
            session.setAttribute("edition", "openinsurance");%>
        	<img src="_img/openinsurancelogo.jpg" border="0">
        <% } else if ("bloodbank".equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("edition",""))) {
            session.setAttribute("edition", "openinsurance");%>
        	<img src="_img/logo_bloodbank.jpg" border="0">
        <% } else if ("gmao".equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("edition",""))) {
            session.setAttribute("edition", "gmao");%>
        	<img src="_img/logo_gmao.jpg" border="0">
        <% } else {
            session.setAttribute("edition", "openclinic");%>
        	<img src="_img/logo.jpg" border="0">
        <% }%>
    </div>
    <%
    	String edition="";
		if("bloodbank".equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("edition",""))){
			edition="Blood Bank Edition<br/>";
		}
		else if("healthcenter".equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("edition.extension",""))){
			edition="<i>Health Center Edition</i> - ";
		}
    %>
    <div id="version"><%=edition+" "+version%>&nbsp;</div>
    <div id="fields">
        <form name="entranceform" action="checkLogin.do?ts=<%=getTs()%>" method="post" id="entranceform">
            <div id="login_field"><input class="text" name="login" id="loginfield" size="17" onblur="limitLength(this);"/></div>
            <div id="pwd_field"><input class="text" type="password" name="password" id="passwordfield" size="17" onblur="limitLength(this);"/></div>
          
            <div id="submit_button">
                <input class="button" type="button" name="Login" value="" onclick="doSubmit();">
                <span id="finger_button" title="Logon using fingerprint" onclick="readFingerprint();"></span>
            </div>     
            <div id="error_msg">
            <%
                String sMsg = checkString(request.getParameter("message"));
                if(sMsg.length() > 0){
                    out.write("<div>"+sMsg+"</div>");
                }
            %>
            </div>
        </form>
    </div>
    
    <div id="messages">
        <center>
        <br/>
        <%
            if(MedwanQuery.getInstance().getConfigInt("enableProductionWarning",0)==1){
        		out.print(ScreenHelper.getTranDb("web","productionsystemwarning","EN"));
	    	}
        	if(MedwanQuery.getInstance().getConfigInt("enableTestsystemRedirection",0)==1){
            	out.print(ScreenHelper.getTranDb("web","testsystemredirection","EN"));
        	}
        %>
        </center><br/>
        
        <center><%=MedwanQuery.getInstance().getConfigString("openclinicedition", "GA Open Source Edition") %> by:
        <% if (MedwanQuery.getInstance().getConfigString("mxsref", "rw").equalsIgnoreCase("rw")){ %>
        <img src="_img/flags/rwandaflag.jpg" height="15px" width="30px" alt="Rwanda"/>
        <a href="http://mxs.rwandamed.org" target="_new"><b>The Open-IT Group Ltd</b></a>
        <BR/> PO Box 3242 - Kigali Rwanda Tel +250 07884 32 435 -
        <a href="mailto:mxs@rwandamed.org">openit@rwandamed.org</a>
        <% } else if (MedwanQuery.getInstance().getConfigString("mxsref", "rw").equalsIgnoreCase("bi")){ 
        	if(MedwanQuery.getInstance().getConfigString("projectref","").equalsIgnoreCase("paiss")){
	        %>
		        <img src="_img/flags/enabel.png" height="20px" alt="Enabel Burundi"/>
		        <a href="http://www.enabel.be" target="_new"><b>Enabel Burundi - PAISS</b></a>
		        <BR/> Avenue de la Croix Rouge, BP 6708 - Bujumbura +257 222 775 48<br/>
	        <% 
        	}
        	else {
    	        %>
		        <img src="_img/flags/burundiflag.jpg" height="15px" width="30px" alt="Burundi"/>
		        <a href="http://www.openit-burundi.net" target="_new"><b>Open-IT Burundi SPRL</b></a>
		        <BR/> Avenue de l'ONU 6, BP 7205 - Bujumbura +257 78 837 342<br/>
		        <a href="mailto:info@openit-burundi.net">info@openit-burundi.net</a>
	        <% 
        	}
        } else if (MedwanQuery.getInstance().getConfigString("mxsref", "rw").equalsIgnoreCase("ml")){ %>
        <img src="_img/flags/maliflag.jpg" height="15px" width="30px" alt="Mali"/>
        <a href="http://www.sante.gov.ml/" target="_new"><b>ANTIM</b></a> et <a href="http://www.mxs.be" target="_new"><b>Post-Factum</b></a>
        <BR/> Hamdalaye ACI 2000, Rue 340, Porte 541, Bamako - Mali<br/>
        <a href="mailto:info@openit-burundi.net">antim@sante.gov.ml</a>
        <% } else { 
       		%>
		        <img src="_img/flags/pf.gif" height="16px" width="20px" alt="Post-Factum"/>
		        <b>Post-Factum bvba</b>
		        <BR/> Pastoriestraat 58, 3370 Boutersem Belgium -
		        <a href="mailto:info@post-factum.be">info@post-factum.be</a>
		    <%
         } %>
        </center>
    </div>
</div>
<script>
  Event.observe(window,"load",function(){
    changeInputColor();
    $("entranceform").login.focus();
  });
  
  function doSubmit(){
	    if(!window.sessionStorage.getItem('tabid')){
	    	window.sessionStorage.setItem('tabid',new Date().getMilliseconds());
	    }
	    var url = "<c:url value='/includes/ajax/heartBeat.jsp'/>?tabid="+window.sessionStorage.getItem('tabid')+"&ts="+new Date().getTime();
	    new Ajax.Request(url,{
	      onSuccess: function(resp){
	        var data = eval("("+resp.responseText+")");
	    	if(data.action.length>0){	
	    		if(data.action=="invalidate"){
	    			alert('<%=getTranNoLink("web","cannothaveseveraltabsopen","en")%>');
	    		}
	    		else{
      			    $("entranceform").submit();
	    		}
	    	}
	    	else{    	  
	  		    $("entranceform").submit();
	    	}
	      }
	    });
	}
	    
  
  function readFingerprint(){
    <%
        if(checkString(MedwanQuery.getInstance().getConfigString("referringServer")).length()==0){
            %>openPopup("_common/readUserFingerPrint.jsp?ts=<%=getTs()%>&referringServer=<%="http://"+request.getServerName()+":"+request.getServerPort()+"/"+sCONTEXTPATH%>",400,300);<%
        }
        else{
            %>openPopup("_common/readUserFingerPrint.jsp?ts=<%=getTs()%>&referringServer=<%=MedwanQuery.getInstance().getConfigString("referringServer")+sCONTEXTPATH%>",400,300);<%
        }
    %>
  }
  
  function openPopup(page,width,height){
    window.open(page,"Popup"+new Date().getTime(),"toolbar=no,status=yes,scrollbars=yes,resizable=yes,width="+width+",height="+height+",menubar=no").moveTo((screen.width-width)/2,(screen.height-height)/2);
  }
  
	function checkKeyDown(evt){
		evt = evt || window.event;
	  var kcode = evt.keyCode || evt.which;
	  if(document.getElementById("loginfield").value.length>0 && document.getElementById("passwordfield").value.length>0 && kcode && kcode==13){
	    doSubmit();
	    return true;
	  } 
	  else{
	    return false;
	  }
	}


</script>
</body>
</html>