<%@page import="be.mxs.common.util.system.Picture,
                java.io.File,
                java.io.FileOutputStream"%>
<%@page import="java.util.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"curative","select",activeUser)%>
<%=sJSPROTOTYPE %>
<%!
    //--- CONDITIONAL INCLUDE ---------------------------------------------------------------------
    private void conditionalInclude(String page, PageContext pageContext, String accessright, User user){
        if(user.getAccessRight(accessright)){
            ScreenHelper.setIncludePage(customerInclude(page),pageContext);
        }
    }

    //--- GET LAST ACCESS -------------------------------------------------------------------------
    private String getLastAccess(String patientId, String sWebLanguage, HttpServletRequest request){
        //SimpleDateFormat dateformat = new SimpleDateFormat("dd-MM-yyyy '"+getTranNoLink("web.occup"," - ",sWebLanguage)+"' HH:mm:ss");
        List l = AccessLog.getLastAccess(patientId,2);
        String s = "";
        if(l.size() > 1){
        	try{
	            Object[] ss = (Object[])l.get(1);
	            Timestamp t = (Timestamp)ss[0];
	            Hashtable u = User.getUserName((String)ss[1]);
	            s+= "<div style='float:right'>"+
	                 "<span style='font-weight:normal'>"+getTranNoLink("web.occup","last.access",sWebLanguage)+"  "+(t==null?"?":ScreenHelper.fullDateFormat.format(t))+" "+getTranNoLink("web","by",sWebLanguage)+" <b>"+(u==null?"?":u.get("firstname")+" "+u.get("lastname"))+"</b></span>";
	               
                // 2x history
	            s+=" | <a href='javascript:void(0)' onclick='getAccessHistory(20)' class='link history' title='"+getTranNoLink("web","history",sWebLanguage)+"' alt=\""+getTranNoLink("web","history",sWebLanguage)+"\">...</a>"+
	                  "<a href='javascript:void(0)' onclick='getAdminHistory(20)' class='link adminhistory' title='"+getTranNoLink("web","adminhistory",sWebLanguage)+"' alt=\""+getTranNoLink("web","history",sWebLanguage)+"\">...</a>";
	                  
	            s+= "</div>";
        	}
        	catch(Exception e){
        		e.printStackTrace();
        	}
        }
        
        return s;
    }
%>

<%
	if(activePatient==null){
		%><script>window.location.href='<c:url value="main.do?CheckService=true&CheckMedicalCenter=true"/>';</script><%
		out.flush();
	}

	String sVip = "";
	if("1".equalsIgnoreCase((String)activePatient.adminextends.get("vip"))){
	    sVip="<img border='0' src='_img/icons/icon_vip.jpg' alt='"+getTranNoLink("web","vip",sWebLanguage)+"'/>";
	}
	
	String sDiscontinued="";
	Encounter activeEncounter= Encounter.getActiveEncounter(activePatient.personid);
	if(MedwanQuery.getInstance().getConfigInt("enableEncounterStatusWarning",0)==1 && activeEncounter!=null){
		sDiscontinued="<img border='0' src='"+sCONTEXTPATH+"/_img/icons/icon_warning.gif'/> <font style='font-size:15px' color='red'>"+getTran(request,"web","discontinuedaccident",sWebLanguage)+"</font>";
	}
	
	String sMPI="";
	if(MedwanQuery.getInstance().getConfigInt("enableMPI",0)==1){
		String sMPIID = checkString((String)activePatient.adminextends.get("mpiid"));
		if(sMPIID.length()>0){
			sMPI=" - <a href='javascript:showMPI()'><font style='font-size:12px'>"+getTran(request,"web","mpiid",sWebLanguage)+": "+sMPIID+"</font></a>";
		}
		else{
			sMPI=" - <a href='javascript:showMPI()'><font style='font-size:12px'>"+getTran(request,"web","mpiid",sWebLanguage)+": </font><img height='14px' style='vertical-align: middle' src='"+sCONTEXTPATH+"/_img/icons/icon_erase.gif'/></a>";
		}
	}
%>
<script>
  window.document.title="<%=sWEBTITLE+" "+getWindowTitle(request,sWebLanguage)%>";
</script>
<%-- 1 : ADMINISTRATIVE DATA --%>
<table width="100%" class="list" cellpadding="1" cellspacing="0">
    <tr>
        <td colspan="10" class="titleadmin">
            <div style="float:left;vertical-align:middle"><%=getTran(request,"web","administrative.data",sWebLanguage)+" "+sMPI+" "+sVip+" "+sDiscontinued%></div>
            <%=getLastAccess("A."+activePatient.personid,sWebLanguage,request)%>
        </td>
    </tr>
	
	<%
	    boolean pictureExists = Picture.exists(Integer.parseInt(activePatient.personid));
		if(pictureExists){
	        Picture picture = new Picture(Integer.parseInt(activePatient.personid));
	        try{
	        	String sDocumentsFolder = MedwanQuery.getInstance().getConfigString("DocumentsFolder","c:/projects/openclinic/documents");
	            File file = new File(sDocumentsFolder+"/"+activeUser.userid+".jpg");
	            FileOutputStream fileOutputStream = new FileOutputStream(file);
	            fileOutputStream.write(picture.getPicture());
	            fileOutputStream.close();
	            
	            // extra row and cell for picture
	            %>
			        <tr>
			            <td class="image" style="vertical-align:top;" width="143px"><img border="0" width="100%" src='<c:url value="/"/>documents/<%=activeUser.userid%>.jpg?ts=<%=getTs()%>'/></td>
			            <td style="vertical-align:top;">
			                <table width="100%" cellpadding="1" cellspacing="0">
	            <%
	        }
	        catch(Exception e){
	        	pictureExists = false;
	        }
	    }
    %>
    <tr><td colspan="2"><%conditionalInclude("curative/encounterStatus.jsp",pageContext,"adt.encounter.select",activeUser);%></td><tr>
    <tr>
        <td style="vertical-align:top;" height="100%" width="50%"><%conditionalInclude("curative/financialStatus.jsp",pageContext,"financial.balance.select",activeUser);%></td>
        <td style="vertical-align:top;" height="100%" width="50%"><%conditionalInclude("curative/insuranceStatus.jsp",pageContext,"financial.balance.select",activeUser);%></td>
    <tr>
    <tr><td colspan="2"><%conditionalInclude("curative/planningStatus.jsp",pageContext,"planning.select",activeUser);%></td><tr>

    <%
        if(pictureExists){
            %>
                        </table>
                    </td>
                </tr>
            <%
        }
    %>
</table>

<div style="height:2px;"></div>

<%-- 2 : MEDICAL DATA --%>
<% if(activeUser.getAccessRight("curative.select") && !activePatient.isVirtualInvoicingAccount()){%>
    <table width="100%" class="list" cellpadding="1" cellspacing="0">
        <tr><td colspan="6" class="titleadmin"><%=getTran(request,"web","medical.data",sWebLanguage)%></td></tr>
        <tr>
        	<%
        		if(activeUser.getAccessRight("medication.medicationschema.select")){
                    %><td colspan="4" style="vertical-align:top;" height="100%"><%conditionalInclude("curative/medicationStatus.jsp",pageContext,"medication.medicationschema.select",activeUser);%></td><%
        		}
        		else {
                    %><td colspan="4" style="vertical-align:top;" height="100%"><table width='100%'><tr class='admin'><td>&nbsp;</td></tr></table></td><%
        		}
        		if(activeUser.getAccessRight("occup.vaccinations.select")){
        	        %><td colspan="2" style="vertical-align:top;" height="100%"><%conditionalInclude("curative/vaccinationStatus.jsp",pageContext,"occup.vaccinations.select",activeUser);%></td><%
        		}
        		else {
                    %><td colspan="2" style="vertical-align:top;" height="100%"><table width='100%'><tr class='admin'><td>&nbsp;</td></tr></table></td><%
        		}
            %>
        <tr>
        <tr>
            <td colspan="2" style="vertical-align:top;" height="100%" width="30%"><%conditionalInclude("curative/warningStatus.jsp",pageContext,"occup.warning.select",activeUser);%></td>
            <td colspan="2" style="vertical-align:top;" height="100%" width="30%"><%conditionalInclude("curative/activeDiagnosisStatus.jsp",pageContext,"problemlist.select",activeUser);%></td>
            <td colspan="2" style="vertical-align:top;" height="100%"><%conditionalInclude("curative/rfeStatus.jsp",pageContext,"problemlist.select",activeUser);%></td>
        <tr>
        <tr>
            <td colspan="6"><%conditionalInclude("curative/medicalHistoryStatus.jsp",pageContext,"examinations.select",activeUser);%></td>
        <tr>
    </table>
<%}%>

<div id="responseByAjax">&nbsp;</div>
<div id="weekSchedulerFormByAjax" style="display:none;position:absolute;background:white">&nbsp;</div>

<%
	if(MedwanQuery.getInstance().getConfigInt("warnUserOfMissingMandatoryPatientInformation",0)==1){
		out.println(showMissingFields(activePatient));
	}
%>

<script>
  function getAccessHistory(nb){
	var url = "<c:url value='/curative/ajax/getHistoryAccess.jsp'/>?nb="+nb+"&ts="+new Date().getTime();
    Modalbox.show(url,{title:'<%=getTranNoLink("web","history",sWebLanguage)%>',width:420,height:370},{evalScripts:true});
  }
  
  function getAdminHistory(nb){
    var url = "<c:url value='/curative/ajax/getHistoryAdmin.jsp'/>?nb="+nb+"&ts="+new Date().getTime();
    Modalbox.show(url,{title:'<%=getTranNoLink("web","adminhistory",sWebLanguage)%>',width:420,height:370},{evalScripts:true});
  }
  
  function showMPI(){
    var url = "<c:url value='/curative/showMPI.jsp'/>?ts="+new Date().getTime();
    Modalbox.show(url,{title:'<%=getTranNoLink("web","MPIdata",sWebLanguage)%>',width:900,height:500},{evalScripts:true});
  }

  <%-- ACTIVATE TAB --%>
  function activateMPITab(sTab){
	  document.getElementById("MPI0-view").style.display = "none";
	  td0.className = "tabunselected";
	  if(sTab=="demographics"){
	    document.getElementById("MPI0-view").style.display = "";
	    td0.className = "tabselected";
	  }
	  document.getElementById("MPI1-view").style.display = "none";
	  td1.className = "tabunselected";
	  if(sTab=="identifiers"){
	    document.getElementById("MPI1-view").style.display = "";
	    td1.className = "tabselected";
	  }
  }
  
  function loadSearchMPI(){
	    var params = "";
		var url = "<%=sCONTEXTPATH%>/curative/searchMPI.jsp";
		new Ajax.Request(url,{
		method: "POST",
		parameters: params,
		onSuccess: function(resp){
			document.getElementById('divmpi').innerHTML=resp.responseText;
		}
		});
  }
  
  function mpiget(mpiid){
		document.getElementById('divmpisearch').style.display='';
	    document.getElementById('divmpisearch').innerHTML = "<img src='<c:url value="/_img/themes/default/ajax-loader.gif"/>'/>";
	    var params = "mpiid="+mpiid;
		var url = "<%=sCONTEXTPATH%>/curative/getMPIID.jsp";
		new Ajax.Request(url,{
		method: "POST",
		parameters: params,
		onSuccess: function(resp){
			document.getElementById('divmpisearch').innerHTML='<td>'+resp.responseText+'</td>';
		}
		});
  }
  
  function mpisearch(mpiid){
		document.getElementById('divmpisearch').style.display='';
	    document.getElementById('divmpisearch').innerHTML = "<img src='<c:url value="/_img/themes/default/ajax-loader.gif"/>'/>";
	    var params = "mpiid="+mpiid;
		var url = "<%=sCONTEXTPATH%>/curative/searchProbabilisticMPIID.jsp";
		new Ajax.Request(url,{
		method: "POST",
		parameters: params,
		onSuccess: function(resp){
			document.getElementById('divmpisearch').innerHTML='<td>'+resp.responseText+'</td>';
		}
		});
  }
  
  function creatempi(){
	    var params = "";
		var url = "<%=sCONTEXTPATH%>/curative/createMPIID.jsp";
		new Ajax.Request(url,{
		method: "POST",
		parameters: params,
		onSuccess: function(resp){
			Modalbox.hide();
			window.location.reload();
		}
		});
  }
  
  function updatempi(){
	  var params="";
	  var elements = document.all;
	  for(n=0;n<elements.length;n++){
		  if(elements[n].id && elements[n].id.indexOf('rb_')==0 && elements[n].checked){
			  params+=elements[n].id.substring(3)+"="+elements[n].value+"&";
		  }
	  }
		var url = "<%=sCONTEXTPATH%>/curative/updateMPIID.jsp";
		new Ajax.Request(url,{
		method: "POST",
		parameters: params,
		onSuccess: function(resp){
			showMPI();
		}
		});
  }
  
  function usempiid(mpiid){
	  if(window.confirm('<%=getTranNoLink("web","linkpatient",sWebLanguage)+" "+activePatient.getFullName()+" "+getTranNoLink("web","tompiid",sWebLanguage)%> '+mpiid+'?')){
		document.getElementById('divmpisearch').style.display='';
	    document.getElementById('divmpisearch').innerHTML = "<img src='<c:url value="/_img/themes/default/ajax-loader.gif"/>'/>";
	    var params = "mpiid="+mpiid+"&personid=<%=activePatient.personid%>";
		var url = "<%=sCONTEXTPATH%>/curative/linkMPIID.jsp";
		new Ajax.Request(url,{
		method: "POST",
		parameters: params,
		onSuccess: function(resp){
			Modalbox.hide();
			window.location.reload();
		}
		});
	  }
  }

  function unlinkmpiid(mpiid){
	  if(window.confirm('<%=getTranNoLink("web","detachpatient",sWebLanguage)+" "+activePatient.getFullName()+" "+getTranNoLink("web","frommpiid",sWebLanguage)%> '+mpiid+'?')){
	    var params = "";
		var url = "<%=sCONTEXTPATH%>/curative/unlinkMPIID.jsp";
		new Ajax.Request(url,{
		method: "POST",
		parameters: params,
		onSuccess: function(resp){
			Modalbox.hide();
			window.location.reload();
		}
		});
	  }
  }
</script>
