<%@page import="be.openclinic.adt.Planning" %>
<%@page import="be.dpms.medwan.common.model.vo.occupationalmedicine.ExaminationVO" %>
<%@page import="java.util.*" %>
<%@page import="be.openclinic.common.ObjectReference" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=sJSSORTTABLE%>
<%=sJSSTRINGFUNCTIONS%>

<%String sTextFind = getTran(request,"web", "find", sWebLanguage);%>

<table class="list" width="100%" cellspacing="0">
    <%-- PAGE TITLE --%>
    <tr class="admin">
        <td colspan="7"><%=getTran(request,"curative","planning.status.title",sWebLanguage)%>&nbsp;
        <a href="<c:url value='/main.do'/>?Page=planning/findPlanning.jsp&ts=<%=getTs()%>"><img height='16px' src="<c:url value='/_img/icons/icon_newpage.png'/>" class="link" alt="<%=getTranNoLink("web","planning",sWebLanguage)%>" style="vertical-align:middle;"></a></td>
    </tr>
    <%
        String sClass = "";
        SimpleDateFormat hhmmDateFormat = new SimpleDateFormat("HH:mm");
        List lPatientFuturePlannings = Planning.getPatientFuturePlannings(activePatient.personid, ScreenHelper.stdDateFormat.format(new java.util.Date()));
        if(lPatientFuturePlannings.size() > 0){
            %>
            <tr>
                <td style="padding:0;">
            		<table id="searchresultsInsurance" width="100%" cellspacing="0" class="sortable" style="border:0;">
            		
		                <%-- HEADER --%>
		                <tr class="gray">
		                    <td><%=getTran(request,"web.occup","medwan.common.date",sWebLanguage)%></td>
		                    <td><%=getTran(request,"web","from",sWebLanguage)%></td>
		                    <td><%=getTran(request,"web","to",sWebLanguage)%></td>
		                    <td><%=getTran(request,"planning","cancelationdate",sWebLanguage)%></td>
		                    <td><%=getTran(request,"planning","user",sWebLanguage)%></td>
		                    <td><%=getTran(request,"web","context",sWebLanguage)%></td>
		                    <td><%=getTran(request,"web","prestation",sWebLanguage)%></td>
		                    <td><%=getTran(request,"web","description",sWebLanguage)%></td>
		                </tr>
            <%
            Planning planning;
            String[] aHour;
            Calendar calPlanningStop;
            Hashtable hFuture = new Hashtable();

            for (int i = 0; i < lPatientFuturePlannings.size(); i++){
                planning = (Planning) lPatientFuturePlannings.get(i);
                hFuture.put(planning.getPlannedDate(), planning);
            }

            Vector v = new Vector(hFuture.keySet());
            Collections.sort(v);
            Collections.reverse(v);
            Iterator it = v.iterator();
            java.util.Date dTmp;
            ObjectReference orContact;
            ExaminationVO examination;
            String sTextAdd = getTran(request,"web", "add", sWebLanguage);

            while (it.hasNext()){
                // alternate row-style
                if(sClass.equals("")) sClass = "1";
                else                   sClass = "";

                dTmp = (java.util.Date) it.next();
                planning = (Planning) hFuture.get(dTmp);

                calPlanningStop = Calendar.getInstance();
                calPlanningStop.setTime(planning.getPlannedDate());
                calPlanningStop.set(Calendar.SECOND, 0);
                calPlanningStop.set(Calendar.MILLISECOND, 0);

                if(planning.getEstimatedtime().length() > 0){
                    try {
                        aHour = planning.getEstimatedtime().split(":");
                        calPlanningStop.setTime(planning.getPlannedDate());
                        calPlanningStop.add(Calendar.HOUR, Integer.parseInt(aHour[0]));
                        calPlanningStop.add(Calendar.MINUTE, Integer.parseInt(aHour[1]));
                    }
                    catch (Exception e1){
                        calPlanningStop.setTime(planning.getPlannedDate());
                    }
                }

                %>
                    <tr onclick="openAppointment('<%=planning.getUid()%>')" class="list<%=sClass%>" style="cursor:pointer" >
                        <td><%=ScreenHelper.getSQLDate(planning.getPlannedDate())%></td>
                        <td><%=hhmmDateFormat.format(planning.getPlannedDate())%></td>
                        <td><%=hhmmDateFormat.format(planning.getPlannedEndDate())%></td>
                        <td><%=ScreenHelper.getSQLDate(planning.getCancelationDate())%></td>
                        <td>
                            <%
                             	User user = activeUser;
                             	String userService=user.getParameter("defaultserviceid");
                             	if(userService!=null && userService.length()>0){
                             		userService=" ("+userService.toUpperCase()+": "+getTran(request,"service",userService,sWebLanguage)+")";
                             	}
                             	
                                if(planning.getUserUID().equals(activeUser.userid)){
	                                out.print("<b>"+user.person.firstname.toUpperCase()+" "+user.person.lastname.toUpperCase()+userService+"</b>");
                                }
                                else{
                                    user = new User();
                                 	user.initialize(Integer.parseInt(planning.getUserUID()));
                                 	user.person.initialize(user.personid);
                                 	userService=user.getParameter("defaultserviceid");
                                 	if(userService!=null && userService.length()>0){
                                 		userService=" ("+userService.toUpperCase()+": "+getTran(request,"service",userService,sWebLanguage)+")";
                                 	}
                                    out.print(user.person.firstname.toUpperCase()+" "+user.person.lastname.toUpperCase()+userService);
                                }
                            %>
                        </td>
                        <td><%=getTran(request,"Web.Occup",planning.getContextID(),sWebLanguage)%></td>
                        <td>
                            <%
                                orContact = planning.getContact();
                                if(orContact != null){
                                    if(orContact.getObjectType().equalsIgnoreCase("examination") && checkString(orContact.getObjectUid()).length()>0){
                                        examination = MedwanQuery.getInstance().getExamination(orContact.getObjectUid(), sWebLanguage);
                                        if(checkString(planning.getTransactionUID()).length()==0){
                                            out.print("<img src='_img/icons/icon_add.gif' onclick='doExamination(\""+planning.getUid()+"\",\""+planning.getPatientUID()+"\",\""+examination.getTransactionType()+"\")' alt='"+sTextAdd+"' class='link'/> "
                                               +getTran(request,"examination", examination.getId().toString(), sWebLanguage));
                                        }
                                        else {
                                            out.print("<img src='_img/icons/icon_search.png' onclick='openExamination(\""+planning.getTransactionUID().split("\\.")[0]+"\",\""+planning.getTransactionUID().split("\\.")[1]+"\",\""+planning.getPatientUID()+"\",\""+examination.getTransactionType()+"\")' alt='"+sTextFind+"' class='link'/> "
                                               +getTran(request,"examination", examination.getId().toString(), sWebLanguage));
                                        }
                                    }
                                }
                            %>
                        </td>
                        <td><%=planning.getDescription()%></td>
                    </tr>
                      
                <%
            }
            %>
                  	        </table>
                        </td>
                    </tr>  
            <%
        }
        else{
        	//out.print("&nbsp;"+getTran(request,"web","noRecordsFound",sWebLanguage));
        }
    %>
</table>
<script>
  var actualAppointmentId;
 
  function doClose(){
    Modalbox.hide();
  }
 
  function deleteAppointment2(){
    if(confirm("<%=getTran(null,"Web","AreYouSure",sWebLanguage)%>")){
      var url = "<c:url value='/planning/ajax/editPlanning.jsp'/>?ts=<%=getTs()%>";
      var params = "&Action=delete&Page=Curative&AppointmentID="+actualAppointmentId;
      var div = "responseByAjax";
      new Ajax.Request(url,{
        evalScripts: true,
        parameters:params,
        onComplete:function(request){
          $(div).update(request.responseText);
        }
      });
    }
  }
  
  function openAppointment(planningUid){
	<%
		if(MedwanQuery.getInstance().getConfigString("calendarVersion", "1").equalsIgnoreCase("1")){
	%>
	    actualAppointmentId = planningUid;
	    var url = "<c:url value='/planning/ajax/editPlanning.jsp'/>";
	    Modalbox.show(url,{title:'<%=getTranNoLink("web", "planning", sWebLanguage)%>',width: 650, height: 480, method:'post',params:"FindUserUID=<%=activeUser.userid%>&FindPlanningUID="+planningUid+"&ts=<%=getTs()%>"}, {evalScripts: true} );
    <%
		}
		else if(MedwanQuery.getInstance().getConfigString("calendarVersion", "1").equalsIgnoreCase("2")){
    %>
	    var url = "calendar/editEvent.jsp&id="+planningUid;
	    openPopup(url,500,300,'<%=getTranNoLink("web", "planning", sWebLanguage)%>');
    <%
		}
    %>
  }
  function goodTime(){
    if($("appointmentDateHour").value > $("appointmentDateEndHour").value){
      return false;
    } else if($("appointmentDateHour").value == $("appointmentDateEndHour").value && Number($("appointmentDateEndMinutes").value) < (Number($("appointmentDateMinutes").value)+10)){
      return false;
    } else {
      return true;
    }
  }
    
	function activateTab2(sTab){

	    document.getElementById('tr0_1-view').style.display = 'none';
	    td0_1.className="tabunselected";
	    if(sTab=='Main'){
	      document.getElementById('tr0_1-view').style.display = '';
	      td0_1.className="tabselected";
	    }

	    document.getElementById('tr1_1-view').style.display = 'none';
	    td1_1.className="tabunselected";
	    if(sTab=='Extended'){
	      document.getElementById('tr1_1-view').style.display = '';
	      td1_1.className="tabselected";
	    }
  	}

  function saveAppointment(){
    if($("EditPatientUID").value.length==0 || $F("EditUserUID123").length==0 || $F("appointmentDateDay").trim().length==0 ){
      if($("EditPatientUID").value.length==0){
        $("EditPatientUID").focus();
      }
      if($F("EditUserUID123").length==0){
        $("EditUserUID123").focus();
      }
      if($F("appointmentDateDay").trim().length==0){
        $("appointmentDateDay").focus();
      }
      alertDialog("web.manage","dataMissing");
    }
    else if(!goodTime()){
      alertDialog("web.errors","appointment.must.10.min.least");
    }
    else{
      var url = "<c:url value='/planning/ajax/editPlanning.jsp'/>?ts=<%=getTs()%>";
      var div = "responseByAjax";
      var params = "&Page=Curative&EditPlanningUID="+$F("EditPlanningUID")+"&appointmentDateDay="+$("appointmentDateDay").value +"&appointmentDateHour="+$("appointmentDateHour").value+"&appointmentDateMinutes="+
                   $("appointmentDateMinutes").value+"&appointmentDateEndDay="+$("appointmentDateDay").value+"&Action=save"+
                   "&appointmentDateEndHour="+$("appointmentDateEndHour").value+"&appointmentDateEndMinutes="+$("appointmentDateEndMinutes").value+
                   "&EditEffectiveDate="+$("EditEffectiveDate").value+"&EditEffectiveDateTime="+$("EditEffectiveDateTime").value+"&EditCancelationDateTime="+$("EditCancelationDateTime").value+"&EditCancelationDate="+$("EditCancelationDate").value+
                   "&EditUserUID123="+$("EditUserUID123").value+"&EditServiceUID="+$("EditServiceUID").value+"&EditPatientUID="+$("EditPatientUID").value+"&EditDescription="+encodeURIComponent($("EditDescription").value)+
                   "&EditContactUID="+$("EditContactUID").value+"&EditContactName="+$("EditContactName").value+"&EditContext="+$("EditContext").value+"&EditComment="+$("EditComment").value+"&EditPreparationDate="+$("EditPreparationDate").value+"&EditAdmissionDate="+$("EditAdmissionDate").value+"&EditOperationDate="+$("EditOperationDate").value+"&EditReportingPlace="+$("EditReportingPlace").value+"&EditSurgeon="+$("EditSurgeon").value;
      if($("EditTransactionUID")){
        params+="&EditTransactionUID="+$F("EditTransactionUID");
      }
      if($("ContactProduct") && $("ContactProduct").checked){
        params+="&EditContactType="+$("ContactProduct").value;
      }
      else if($("ContactExamination") && $("ContactExamination").checked){
        params+="&EditContactType="+$("ContactExamination").value;
      }
        
      new Ajax.Request(url,{
        parameters:params,
        evalScripts: true,
        onComplete:function(request){
          $(div).update(request.responseText);
        }
      });
    }
  }
  
  function searchPrestation(prestationUidField,prestationNameField){
    if(document.getElementById("ContactProduct").checked){
      openPopup("/_common/search/searchProduct.jsp&ts="+new Date().getTime()+"&ReturnProductUidField="+prestationUidField+"&ReturnProductNameField="+prestationNameField);
    }
    else if(document.getElementById("ContactExamination").checked){
      openPopup("/_common/search/searchExamination.jsp&ts="+new Date().getTime()+"&VarCode="+prestationUidField+"&VarText="+prestationNameField+"&VarUserID="+$("EditUserUID").value);
    }
  }
  
  function searchUser(fieldUID,fieldName){
    openPopup("/_common/search/searchUser.jsp&ts="+new Date().getTime()+"&ReturnUserID="+fieldUID+"&ReturnName="+fieldName+"&displayImmatNew=no");
  }
  function searchService(serviceUidField,serviceNameField){
    openPopup("/_common/search/searchService.jsp&ts=<%=getTs()%>&VarSelectDefaultStay=true&VarCode="+serviceUidField+"&VarText="+serviceNameField);
    document.getElementById(serviceNameField).focus();
  }
  function searchMyPatient(fieldUID, fieldName){
    openPopup("/_common/search/searchPatient.jsp&ts="+new Date().getTime()+"&ReturnPersonID="+fieldUID+"&ReturnName="+fieldName+"&displayImmatNew=no");
  }
  function doExamination(sPlanningUID,sPatientID,sTransactionType){
    window.location.href="<c:url value='/healthrecord/editTransaction.do'/>?be.mxs.healthrecord.createTransaction.transactionType="+sTransactionType+"&be.mxs.healthrecord.createTransaction.context=&PersonID="+sPatientID+"&UpdatePlanning="+sPlanningUID+"&ts=<%=getTs()%>";
  }
  function openExamination(ServerID,TransactionID,sPatientID,sTransactionType){
    window.location.href="<c:url value='/healthrecord/editTransaction.do'/>?be.mxs.healthrecord.createTransaction.transactionType="+sTransactionType+"&be.mxs.healthrecord.createTransaction.context=&be.mxs.healthrecord.server_id="+ServerID+"&be.mxs.healthrecord.transaction_id="+TransactionID+"&PersonID="+sPatientID+"&ts=<%=getTs()%>";
  }
  function changeContactType(){
    checkContext();
    $("EditContactUID").value = "";
    $("EditContactName").value = "";
  }
  function checkContext(){
    if(document.getElementById("ContactExamination").checked){
      document.getElementById("EditContext").disabled = false;
    }
    else{
      $("EditContext").value = -1;
      document.getElementById("EditContext").disabled = true;
    }
  }
  
  function printAppointment(){
	    var url = "<c:url value="/"/>planning/printAppointmentPdf.jsp?AppointmentUid="+actualAppointmentId;
	    printwindow=window.open(url,"PatientAppointment<%=getTs()%>","height=600,width=900,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");
	    window.setTimeout("closeDeadWindow();",5000);
	}

	function closeDeadWindow(){
		if(printwindow.document.URL==""){
			printwindow.close();
		}	
	}


</script>