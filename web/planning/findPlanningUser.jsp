<%@page import="be.openclinic.adt.Planning,
                be.dpms.medwan.common.model.vo.occupationalmedicine.ExaminationVO,
                java.util.Calendar,
                java.util.Vector,
                java.util.Hashtable,
                java.util.Collections"%>
<%@page import="java.util.Date"%>
<%@include file="/includes/validateUser.jsp" %>
<%=checkPermission(out,"planning.user","select",activeUser)%>
<%=sJSSTRINGFUNCTIONS%>

<%
    String sClass = "";
    Vector v;
    String sKey;
    
    String sFindUserDate = checkString(request.getParameter("FindUserDate"));
    String isPopup = checkString(request.getParameter("isPopup"));
    if(sFindUserDate.length()==0){
        sFindUserDate = checkString(request.getParameter("FindDate"));
        if(sFindUserDate.length()==0){
            sFindUserDate = getDate();
        }
    }
    
    String sFindUserUID = checkString(request.getParameter("FindUserUID"));
    if(sFindUserUID.length()==0){
        sFindUserUID = activeUser.userid;
    }
    User selectedUser = activeUser;
    if(!sFindUserUID.equalsIgnoreCase(activeUser.userid)){
    	selectedUser = User.get(Integer.parseInt(sFindUserUID));
    }
%>
<form name="formFindUser" method="post" action="<c:url value='/main.do'/>?Page=planning/findPlanning.jsp&Tab=user&ts=<%=getTs()%>">
    <%=writeTableHeader("planning","useropenplanning",sWebLanguage," doBack();")%>
    
    <table width="100%" class="list" cellspacing="0" cellpadding="0" style="border:none;" onKeyDown='if(enterEvent(event,13)){if(checkDate($("beginDate"))){refreshAppointments();}return false;}else{return true;}' >
        <tr style="height:30px;">
            <td width="80" class="admin2" id="FindUserUID_td">
            	<span id='usertd1'><%=getTran(request,"planning","user",sWebLanguage)%></span>
            	<span id='servicetd1'><%=getTran(request,"planning","service",sWebLanguage)%></span>
            </td>
            <td class="admin2" width="350">
            	<span id="usertd2">
            		<input type='hidden' name='FindUserDate' id='FindUserDate' value='<%=sFindUserDate %>'/>
	                <select class="text" id="FindUserUID" name="FindUserUID" onchange="formFindUser.submit();">
	                    <option value='<%=activeUser.userid %>'><%=activeUser.person.getFullName() %></option>
	                    <%
	                    	Connection conn = MedwanQuery.getInstance().getAdminConnection();
	                    	PreparedStatement ps = conn.prepareStatement("select * from userparameters where parameter='agenda_users' and (value like ? or value like ?)");
	                    	ps.setString(1,activeUser.userid+"=%");
	                    	ps.setString(2,"%;"+activeUser.userid+"=%");
	                    	ResultSet rs = ps.executeQuery();
	                    	String sUserID="",sSelected="";
	                    	while(rs.next()){
								sUserID=rs.getString("userid");
	                            if(sUserID.equalsIgnoreCase(sFindUserUID)){
	                                sSelected = "selected";
	                            }
	                            else{
	                                sSelected = "";
	                            }
	                            %><option value='<%=sUserID%>' <%=sSelected%>><%=User.getFullUserName(sUserID)%></option><%
	                    	}
	                    	rs.close();
	                    	ps.close();
	                    	conn.close();
	                    %>
	                </select>
                </span>
                <span id="servicetd2">
					<input type="hidden" name="FindServiceUID" id="FindServiceUID"  onchange="displayCountedWeek(makeDate($('beginDate').value),this.value);" value='<%=checkString((String)session.getAttribute("activePlanningServiceUid"))%>' onchange='if(checkDate($('beginDate')))refreshAppointments();'>
					<input class="text" type="text" name="FindServiceName" id="FindServiceName" readonly size="40" value='<%=checkString(((String)session.getAttribute("activePlanningServiceUid"))).length()>0?getTran(null,"service",checkString(((String)session.getAttribute("activePlanningServiceUid"))),sWebLanguage):""%>' >
					
					<img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTran(null,"web","select",sWebLanguage)%>" onclick="searchService('FindServiceUID','FindServiceName');">
					<img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTran(null,"web","clear",sWebLanguage)%>" onclick="formFindUser.FindServiceUID.value='';formFindUser.FindServiceName.value='';">
                </span>
            </td>
             <td class="admin2" width="75"><%=getTran(request,"web.control","week.of",sWebLanguage)%>
            </td>
            <td class="admin2" width="230">
                <input id="PatientID" type="hidden" value=''/>
                <input type="button" class="button" name="buttonPrevious" value=" < " onclick="refreshAppointments(displayPreviousWeek());"/>
                <input id="beginDate" type="text" class="text" name="beginDate" value="<%=sFindUserDate%>" maxLength="10"/>
                <input type="button" class="button" name="buttonNext" value=" > " onclick="refreshAppointments(displayNextWeek())"/>
                <script>writeMyDate("beginDate");</script>
            </td>
            <td class="admin2" width="*">
                <div style="float:left;height:20px;">
	                <input type="button" name="buttonsearch" class="button" value="<%=getTranNoLink("web","search",sWebLanguage)%>" onclick="if(checkDate($('beginDate')))refreshAppointments();"/>
	                <input type="button" name="buttonNew" class="button" value="<%=getTranNoLink("web","new",sWebLanguage)%>" onclick="openNewAppointment(null);"/>
	                <input type="button" name="buttonback" class="button" value="<%=getTranNoLink("web","back",sWebLanguage)%>" onclick="doBack()"/>
                </div>
                <div id="wait" style="width:130px;display:none">&nbsp;</div>
            </td>
        </tr>

    </table>
    <script>
    </script>
    <%=sJSWEEKPLANNERAJAX%>
    
    <%
	    long iZoom = Math.round(Double.parseDouble((checkString(selectedUser.getParameter("PlanningFindZoom")).equals("")?"40":checkString(selectedUser.getParameter("PlanningFindZoom")))));
	    if(iZoom==0){
	        iZoom = 40;
	    }
	    String sInterval = checkString(selectedUser.getParameter("PlanningExamDuration"));
	    if(sInterval.length()==0){
	        sInterval = 30+"";
	    }
	    String sFrom = checkString(selectedUser.getParameter("PlanningFindFrom")).split("\\.")[0];
	    if(sFrom.length()==0){
	        sFrom = "8" ;
	    }
	    String sUntil = checkString(selectedUser.getParameter("PlanningFindUntil"));
	    if(sUntil.length()==0){
	        sUntil = "20" ;
        }
    %>
    
    <script>
      var weekplannerStartHour = <%=Double.valueOf(Math.floor(Float.parseFloat(sFrom.replace(",",".")))).intValue()%>;
      var weekplannerStopHour = <%=Double.valueOf(Math.ceil(Float.parseFloat(sUntil.replace(",",".")))).intValue()%>;
      var itemRowHeight = <%=iZoom%>;
      var defaultAppointmentDuration = <%=sInterval%>;
      var patientName = '<%=(activePatient!=null)?activePatient.lastname+" "+activePatient.firstname:""%>';
	  	<%
		if(isPopup.equals("1")){
		%>
	    	var containerWidth = window.innerWidth-25;
	    	//var containerWidth = document.body.clientWidth-8;
		    var containerHeight = document.body.clientHeight;
		<%
		} else {
		%>
			  if(document.all){
			    var containerWidth = window.innerWidth-8;
			    var containerHeight = document.body.clientHeight - 285;
			  }
			  else{
			    var containerWidth = window.innerWidth-25;
			    var containerHeight = document.body.clientHeight - 271;
			  }
		<%
		}
		%>
    </script>
    <%=sJSWEEKPLANNER%><%=sCSSWEEKPLANNER%>
    <script>
      var externalSourceFile_items = '<c:url value='/planning/ajax/getCalendarItems.jsp?ts='/><%=getTs()%>';
      var externalSourceFile_save = '';
      var popupWindowUrl = '<c:url value='/planning/ajax/editPlanning.jsp?ts='/><%=getTs()%>';
    </script>
    <%
        User userSelected = new User();
        userSelected.initialize(Integer.parseInt(sFindUserUID));
        SimpleDateFormat hhmmDateFormat = new SimpleDateFormat("HH:mm");
        Calendar c = Calendar.getInstance();
        Date date = ScreenHelper.getSQLDate(sFindUserDate);
        c.setTime(date);
        int todayNumber = c.getFirstDayOfWeek();
    %>
    <div id="weekScheduler_container">
        <div id="weekScheduler_messages">&nbsp;</div>

        <div id="weekScheduler_top">
            <div class="spacer"><span></span>
                <div id="weekScheduler_warning" onmouseover="$('weekScheduler_warning_popup').show();">&nbsp;</div>
                <a class="print_user_button" href="javascript:;" onclick="printPlanning('');" title="<%=getTranNoLink("hrm.persinfo","printalltabs",sWebLanguage)%>" alt='<%=getTranNoLink("hrm.persinfo","printalltabs",sWebLanguage)%>'><img src="<c:url value="/_img/icons/icon_print.png" />" class="link" alt="print" /></a>
                <a class="print_patient_button" href="javascript:;" onclick="printPlanning('',true);" title="<%=getTranNoLink("hrm.persinfo","printalltabs",sWebLanguage)%>" alt='<%=getTranNoLink("hrm.persinfo","printalltabs",sWebLanguage)%>'><img src="<c:url value="/_img/icons/icon_print.png" />" class="link" alt="print" /></a>
            </div>
            <div class="days" id="weekScheduler_dayRow">
                <div id="top_day_1" class="<%=(todayNumber==1)?"today":""%>"><%=getTranNoLink("web", "monday", sWebLanguage)%> <span></span> <a class="print_user_button" title="<%=getTranNoLink("web","print",sWebLanguage)%>" href="javascript:;" onclick="printPlanning('<%=Calendar.MONDAY%>');" alt='print'><img src="<c:url value="/_img/icons/icon_print.png" />" class="link" alt="print" style="vertical-align:-4px;"/></a></div>
                <div id="top_day_2" class="<%=(todayNumber==2)?"today":""%>"><%=getTranNoLink("web", "Tuesday", sWebLanguage)%> <span></span> <a class="print_user_button" title="<%=getTranNoLink("web","print",sWebLanguage)%>" href="javascript:;" onclick="printPlanning('<%=Calendar.TUESDAY%>');" alt='print'><img src="<c:url value="/_img/icons/icon_print.png" />" class="link" alt="print" style="vertical-align:-4px;"/></a></div>
                <div id="top_day_3" class="<%=(todayNumber==3)?"today":""%>"><%=getTranNoLink("web", "Wednesday", sWebLanguage)%> <span></span> <a class="print_user_button" title="<%=getTranNoLink("web","print",sWebLanguage)%>" href="javascript:;" onclick="printPlanning('<%=Calendar.WEDNESDAY%>');" alt='print'><img src="<c:url value="/_img/icons/icon_print.png" />" class="link" alt="print" style="vertical-align:-4px;"/></a></div>
                <div id="top_day_4" class="<%=(todayNumber==4)?"today":""%>"><%=getTranNoLink("web", "Thursday", sWebLanguage)%> <span></span> <a class="print_user_button" title="<%=getTranNoLink("web","print",sWebLanguage)%>" href="javascript:;" onclick="printPlanning('<%=Calendar.THURSDAY%>');" alt='print'><img src="<c:url value="/_img/icons/icon_print.png" />" class="link" alt="print" style="vertical-align:-4px;"/></a></div>
                <div id="top_day_5" class="<%=(todayNumber==5)?"today":""%>"><%=getTranNoLink("web", "Friday", sWebLanguage)%> <span></span> <a class="print_user_button" title="<%=getTranNoLink("web","print",sWebLanguage)%>" href="javascript:;" onclick="printPlanning('<%=Calendar.FRIDAY%>');" alt='print'><img src="<c:url value="/_img/icons/icon_print.png" />" class="link" alt="print" style="vertical-align:-4px;"/></a></div>
                <div id="top_day_6" class="<%=(todayNumber==6)?"today":""%>"><%=getTranNoLink("web", "Saturday", sWebLanguage)%> <span></span> <a class="print_user_button" title="<%=getTranNoLink("web","print",sWebLanguage)%>" class="" href="javascript:;" onclick="printPlanning('<%=Calendar.SATURDAY%>');" alt='print'><img src="<c:url value="/_img/icons/icon_print.png" />" class="link" alt="print" style="vertical-align:-4px;"v/></a></div>
                <div id="top_day_0" class="<%=(todayNumber==7)?"today":""%>"><%=getTranNoLink("web", "Sunday", sWebLanguage)%> <span></span> <a class="print_user_button" title="<%=getTranNoLink("web","print",sWebLanguage)%>" class="" href="javascript:;" onclick="printPlanning('<%=Calendar.SUNDAY%>');" alt='print'><img src="<c:url value="/_img/icons/icon_print.png" />" class="link" alt="print" style="vertical-align:-4px;"/></a></div>
            </div>            
        </div>
        <div id="weekScheduler_content">
            <div id="weekScheduler_hours">
                <%
                    int startHourOfWeekPlanner = Double.valueOf(Math.floor(Float.parseFloat(sFrom.replace(",",".")))).intValue();    // Start hour of week planner
                    int endHourOfWeekPlanner = Double.valueOf(Math.floor(Float.parseFloat(sUntil.replace(",",".")))).intValue();    // End hour of weekplanner.
                    int endMinOfWeekPlanner = (sUntil.split("\\.").length>1)?Integer.parseInt(sUntil.split("\\.")[1]):0;
                    int iCalendarEnd = (endMinOfWeekPlanner==0)?endHourOfWeekPlanner-1:endHourOfWeekPlanner;

                    for(int i = startHourOfWeekPlanner; i <= iCalendarEnd; i++){
                        int hour = i;
                        String suffix = "00"; // Enable this line in case you want to show hours like 08:00 - 23:00
                        String time = hour+"<span class=\"content_hour\" style='line-height:"+iZoom+"px'>"+suffix+"</span>";
                        out.write("<div class='calendarContentTime' style='line-height:"+iZoom+"px;height:"+iZoom+"px'>"+time+"</div>");
                    }
                %>
            </div>
            <div id="weekScheduler_appointments">
                <% 
                    for(int i=0; i<7; i++){    // Looping through the days of a week
	                    out.write("<div class='weekScheduler_appointments_day'>");
	                    for(int j = startHourOfWeekPlanner; j <= iCalendarEnd; j++){
	                        out.write("<div id='weekScheduler_appointment_hour"+i+"_"+j+"' class='weekScheduler_appointmentHour' style='height:"+iZoom+"px;'><span class='line' style='height:"+((iZoom/2)-2)+"'>&nbsp;</span></div>\n");
	                    }
	                    out.write("</div>");
	                }
                %>
            </div>
        </div>
    </div>
    <div id="weekScheduler_warning_popup">
        <span class="close" onclick="$('weekScheduler_warning_popup').hide();">x</span>

        <p><%=getTran(request,"Web.UserProfile","agenda.hidden.appointments",sWebLanguage)%></p>
        <hr/>
        <a href="javascript:activateTab('managePlanning');"><%=getTranNoLink("Web.UserProfile","changeAgenda",sWebLanguage)%></a>
        <hr/>
        <p><%=getTran(request,"web.occup","medwan.common.appointment-list",sWebLanguage)%></p>
        <span id="weekScheduler_warning_list" style="display:block"></span>
    </div>
    <div id="responseByAjax" style="display:none;">&nbsp;</div>
    <div id="viewByAjax" style="display:none;">&nbsp;</div>
    <div id="weekScheduler_popup">
        <span class="close" onclick="remInfoPopup();">x</span>
        <ul>
            <li class="open">
                <a href="javascript:openAppointment();remInfoPopup();"><%=getTranNoLink("web.occup","medwan.common.open",sWebLanguage)%></a>
            </li>
            <%if(activeUser.getAccessRight("planning.delete")){ %>
            <li class="del">
                <a href="javascript:deleteAppointment2();remInfoPopup();"><%=getTranNoLink("web","delete",sWebLanguage)%></a>
            </li>
            <%} %>
            <li class="person">
                <a href="javascript:openDossier();"><%=getTranNoLink("web","showdossier",sWebLanguage)%></a>
            </li>
            <li class="before">
                <a href="javascript:createBeforeAppointment();remInfoPopup();"><%=getTranNoLink("web.control","insert.appointment.before",sWebLanguage)%></a>
            </li>
            <li style="border:none" class="after">
                <a href="javascript:createNextAppointment();remInfoPopup();"><%=getTranNoLink("web.control","insert.appointment.after",sWebLanguage)%></a>
            </li>
            <li style="border:none" class="print">
                <a href="javascript:printAppointment();remInfoPopup();"><%=getTranNoLink("web","print",sWebLanguage)%></a>
            </li>
        </ul>
    </div>
</form>

<script>
  function refreshAppointments(_date){
    if(_date) $('beginDate').value = _date;
    displayCountedWeek(makeDate($('beginDate').value),$("FindUserUID").options[$("FindUserUID").selectedIndex].value);
  }
  
  var printwindow;
  
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
  
  <%-- UPDATE APPOINTMENT DATE--%>
  function updateAppointment(params){
    var url = "<c:url value='/planning/ajax/editPlanning.jsp'/>?ts="+new Date().getTime();
    new Ajax.Request(url,{
      evalScripts:true,
      parameters:params,
      onComplete:function(request){
        $("responseByAjax").update(request.responseText);
      }
    });
  	updateCountedHeaderDates(dateStartOfWeek,$("FindUserUID").options[$("FindUserUID").selectedIndex].value);
  }

  <%-- OPEN APPOINTMENT --%>
  function createAppointment(params){
	if($("servicetd2").style.display.length==0 && $('FindServiceUID').value.length==0){
		alert('<%=getTranNoLink("web","selectservicefirst",sWebLanguage)%>');
	}
	else {
	    var url = "<c:url value='/planning/ajax/editPlanning.jsp'/>?ts="+new Date().getTime();
	    <%
	        // active patient selected by default
	        if(activePatient!=null){
	            out.write("params+='&PatientId="+activePatient.personid+"';");
	            out.write("params+='&PatientName="+((activePatient!=null)?activePatient.lastname+" "+activePatient.firstname:"")+" ("+activePatient.getID("immatnew")+")';");
	        }
	    %>
	    params+= "&FindUserUID="+$("FindUserUID").value+"&EditUserUID123="+$("FindUserUID").value+"&FindServiceUID="+$('FindServiceUID').value+"&EditPatientUID=<%=(activePatient!=null)?activePatient.personid:""%>";
	    Modalbox.show(url,{title:'<%=getTran(null,"web","planning",sWebLanguage)%>',height:500,width:650,afterHide:function(){refreshAppointments();}},{evalScripts:true});
  	}
  }
  
  <%-- OPEN APPOINTMENT --%>
  function openAppointment(id,page){
    if(id) actualAppointmentId = id;
    var url = "<c:url value='/planning/ajax/editPlanning.jsp'/>" +
              "?FindUserUID="+$("FindUserUID").value +
              "&Date="+$("beginDate").value+"&FindPlanningUID="+actualAppointmentId+"&ts="+new Date().getTime();
    if(page) url+="&Page="+page;
    Modalbox.show(url,{title:'<%=getTran(null,"web","planning",sWebLanguage)%>',height:500,width:650,afterHide:function(){refreshAppointments();}},{evalScripts:true});
  }

  <%-- DELETE APPOINTMENT --%>
  function deleteAppointment2(page){
    if(confirm("<%=getTran(null,"Web","AreYouSure",sWebLanguage)%>")){
      var url = "<c:url value='/planning/ajax/editPlanning.jsp'/>?ts="+new Date().getTime();
      var params = "&Action=delete&AppointmentID="+actualAppointmentId;
      if(page) params+="&Page="+page;
      new Ajax.Request(url,{
        evalScripts:true,
        parameters:params,
        onComplete:function(request){
          $("responseByAjax").update(request.responseText);
        }
      });
    }
    updateCountedHeaderDates(dateStartOfWeek,$("FindUserUID").options[$("FindUserUID").selectedIndex].value);
  }
  
  <%-- BACK --%>
  function doClose(){
    if(Modalbox.initialized){
      Modalbox.hide();
    }
    else{
      refreshAppointments();
    }
  }
  
  function goodTime(){
    if($("appointmentDateHour").value > $("appointmentDateEndHour").value){
      return false;
    }
    else if($("appointmentDateHour").value==$("appointmentDateEndHour").value && Number($("appointmentDateEndMinutes").value) < (Number($("appointmentDateMinutes").value)+5)){
      return false;
    }
    else{
      return true;
    }
  }

  function openNewAppointment(params){
		if($("servicetd2").style.display.length==0 && $('FindServiceUID').value.length==0){
			alert('<%=getTranNoLink("web","selectservicefirst",sWebLanguage)%>');
			refreshAppointments();
		}
		else {
		    if(params==null){
		      params = "&Action=new&FindUserUID="+$F('FindUserUID')+"&FindServiceUID="+$F('FindServiceUID')+"&AppointmentID=-1&inputId="+actualAppointmentId
		         +'&appointmentDateDay='+$("beginDate").value
		         +'&appointmentDateHour=<%=sFrom%>'
		         +'&appointmentDateMinutes=0'
		         +'&appointmentDateEndDay='+$("beginDate").value
		         +'&appointmentDateEndHour=<%=(Double.valueOf(sFrom).intValue()+1)+""%>'
		         +'&appointmentDateEndMinutes=0';
		    }
		
		    var url = "<c:url value='/planning/ajax/editPlanning.jsp'/>?ts="+new Date().getTime();
		    Modalbox.show(url,{title:'<%=getTran(null,"web","planning",sWebLanguage)%>',height:500,width:650,params:params,afterHide:function(){refreshAppointments();}},{evalScripts:true});
		}
  }
  
  <%-- SAVE APPOINTMENT --%>
  function saveAppointment(){
	  <%
	  	if(MedwanQuery.getInstance().getConfigInt("enableCCBRT",0)==1){
	  		out.println("checkActivity();");
	  	}
	  	else {
	  		out.println("saveValidatedAppointment();");
	  	}
	  %>
  }
 
	function saveValidatedAppointment(){

	if( $F("EditUserUID123").length==0 || $F("appointmentDateDay").trim().length==0 ){
      if($F("EditUserUID123").length==0){
        $("EditUserUID123").focus();
      }
      if($F("appointmentDateDay").trim().length==0){
        $("appointmentDateDay").focus();
      }
      alertDialog("web.manage","dataMissing");
    }
    <%if(MedwanQuery.getInstance().getConfigInt("appointmentActivityMandatory",0)==1){%>
		else if($F("EditContactUID").trim().length==0){
    		$("EditContactUID").focus();
    		alertDialog("web.manage","dataMissing");
  		}
	<%}%>
    else if(!goodTime()){
      alertDialog("web.errors","appointment.must.5.min.least");
    }
    else{
      var url = "<c:url value='/planning/ajax/editPlanning.jsp'/>?ts="+new Date().getTime();
      var params = "&EditPlanningUID="+$F("EditPlanningUID")+"&appointmentDateDay="+$("appointmentDateDay").value +"&appointmentDateHour="+$("appointmentDateHour").value+"&appointmentDateMinutes="+
                   $("appointmentDateMinutes").value+"&appointmentDateEndDay="+$("appointmentDateDay").value+"&Action=save"+
                   "&appointmentDateEndHour="+$("appointmentDateEndHour").value+"&appointmentDateEndMinutes="+$("appointmentDateEndMinutes").value+
                   "&EditEffectiveDate="+$("EditEffectiveDate").value+"&EditEffectiveDateTime="+$("EditEffectiveDateTime").value+"&EditCancelationDateTime="+$("EditCancelationDateTime").value+"&EditConfirmationDate="+$("EditConfirmationDate").value+"&EditCancelationDate="+$("EditCancelationDate").value+
                   "&EditUserUID123="+$("EditUserUID123").value+"&FindServiceUID="+$("FindServiceUID").value+"&EditServiceUID="+$("EditServiceUID").value+"&EditPatientUID="+$("EditPatientUID").value+"&EditDescription="+encodeURIComponent($("EditDescription").value)+"&EditComment="+encodeURIComponent($("EditComment").value)+
                   "&EditContactUID="+$("EditContactUID").value+"&appointmentRepeatUntil="+$("appointmentRepeatUntil").value+"&EditContactName="+$("EditContactName").value+"&EditNoshow="+$("EditNoshow").checked+"&EditContext="+$("EditContext").value+"&EditPreparationDate="+$("EditPreparationDate").value+"&EditAdmissionDate="+$("EditAdmissionDate").value+"&EditOperationDate="+$("EditOperationDate").value+"&EditReportingPlace="+$("EditReportingPlace").value+"&EditSurgeon="+$("EditSurgeon").value+"&tempplanninguid="+$("tempplanninguid").value;

      if($("EditTransactionUID")){
        params+="&EditTransactionUID="+$F("EditTransactionUID");
      }
      if($F("EditPage").length>0) params+="&Page="+$F("EditPage");

      if($("ContactProduct") && $("ContactProduct").checked){
        params+="&EditContactType="+$("ContactProduct").value;
      }
      else if($("ContactExamination") && $("ContactExamination").checked){
        params+="&EditContactType="+$("ContactExamination").value;
      }
      else if($("ContactPrestation") && $("ContactPrestation").value=='prestation'){
        params+="&EditContactType="+$("ContactPrestation").value;
      }
      
      new Ajax.Request(url,{
    	parameters:params,
        evalScripts: true,
        onComplete:function(request){
          $("responseByAjax").update(request.responseText);
        }
      });
    }
  	updateCountedHeaderDates(dateStartOfWeek,$("FindUserUID").options[$("FindUserUID").selectedIndex].value);
  }
  
  function doSelectUser(sUid){
    window.location.href="<c:url value='/main.do'/>?Page=planning/editPlanning.jsp&FindPlanningUID="+sUid+"&FindUserUID="+formFindUser.FindUserUID.value+"&FindDate="+formFindUser.FindUserDate.value+"&Tab=user&ts="+new Date().getTime();
  }
  function doSearchUser(){
    formFindUser.buttonsearch.disabled = true;
    formFindUser.submit();
  }
  function doSelectHourUser(sHour){
    window.location.href = "<c:url value='/main.do'/>?Page=planning/editPlanning.jsp&FindUserUID="+formFindUser.FindUserUID.value+"&FindDate="+formFindUser.FindUserDate.value+"&FindHour="+sHour+"&Tab=user&ts="+new Date().getTime();
  }
  function setInsertImpossibleMsg(){
    clientMsg.setError("<%=getTranNoLink("web.userprofile","agenda.insert.not.possible",sWebLanguage)%>",null, 6000);
  }
  function searchUser(fieldUID, fieldName){
    openPopup("/_common/search/searchUser.jsp&ts="+new Date().getTime()+"&ReturnUserID="+fieldUID+"&ReturnName="+fieldName+"&displayImmatNew=no");
  }
  function searchMyPatient(fieldUID, fieldName){
    openPopup("/_common/search/searchPatient.jsp&ts="+new Date().getTime()+"&ReturnPersonID="+fieldUID+"&ReturnName="+fieldName+"&displayImmatNew=no");
  }
  function searchPrestation(prestationUidField, prestationNameField){
    if(document.getElementById("ContactProduct").checked){
      openPopup("/_common/search/searchProduct.jsp&ts="+new Date().getTime()+"&ReturnProductUidField="+prestationUidField+"&ReturnProductNameField="+prestationNameField);
    }
    else if(document.getElementById("ContactExamination").checked){
      openPopup("/_common/search/searchExamination.jsp&ts="+new Date().getTime()+"&VarCode="+prestationUidField+"&VarText="+prestationNameField+"&VarUserID="+$("EditUserUID123").value);
    }
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

  function resizeSheduler(containerHeight,containerWidth){
	<%
	  if(isPopup.equals("1")){
	%>
	   	containerWidth = window.innerWidth-25;
	<%
	} 
	%>
    $("weekScheduler_content").style.height = ((weekplannerStopHour-weekplannerStartHour)*<%=iZoom%>+50)+"px";
    $("weekScheduler_container").style.width = containerWidth+"px";
    var divs = $("weekScheduler_content").getElementsByClassName("weekScheduler_appointments_day");
    var divs2 = $("weekScheduler_dayRow").getElementsByTagName("DIV");
    for(i=0; i<divs.length; i++){
      var w = ((containerWidth/7)-11);
      divs[i].style.width =w+"px";
      divs2[i].style.width = w+"px";
    }
  }
  
  function openDossier(id,setEffectiveDate){
    if(!setEffectiveDate){
      setEffectiveDate = "";
    }
    var url = "<c:url value='/planning/ajax/openDossier.jsp'/>?FindPlanningUID="+actualAppointmentId+"&setEffectiveDate="+setEffectiveDate+"&ts="+new Date().getTime();
    new Ajax.Updater("responseByAjax",url,{evalScripts:true});
  }
  
  function redirectToDossier(personId){
      if(personId)window.location.href = "<c:url value='/main.do'/>?Page=curative/index.jsp&PersonID="+personId+"&ts="+new Date().getTime();
  }

        <%-- SET SELECT MINUTES OF EDIT FORM --%>
        function setCorrectAppointmentDate(minH,minM,maxH,maxM){
            if($("appointmentDateHour").value==minH){
                setMinuteSelect('appointmentDateMinutes',minM);
            }else if($("appointmentDateHour").value==maxH){
                
                 setMinuteSelect('appointmentDateMinutes',null,(maxM));
            }else{
               setMinuteSelect('appointmentDateMinutes');// set all minutes
            }

            if($("appointmentDateEndHour").value==minH){
                setMinuteSelect('appointmentDateEndMinutes',minM);
            }else if($("appointmentDateEndHour").value>=maxH ){
                if($("appointmentDateEndHour").value==maxH && maxM==0){
                   $("appointmentDateEndMinutes").options.length = 1;
                   $("appointmentDateEndMinutes").options.value = '00';
                   $("appointmentDateEndMinutes").options.text = '00';
                }else{
                   $("appointmentDateEndHour").value=maxH;
                   setMinuteSelect('appointmentDateEndMinutes',null,maxM);
                }
            }else{
               setMinuteSelect('appointmentDateEndMinutes');// set all minutes
            }
        	updateCountedHeaderDates(dateStartOfWeek,$("FindUserUID").options[$("FindUserUID").selectedIndex].value);
        }
  function setMinuteSelect(field,minM,maxM){
      var i = 0;
      var cpt = 0;
      var selected = $(field).value;
    if(minM){
      if(minM>$(field).value)selected = minM;
      $(field).options.length = (55/5)-(minM/5)+1;
      i = minM;
      for(i;i<=55;i=i+5){
       $(field).options[cpt].text = (i>=10)?i:"0"+i;
       $(field).options[cpt].value = i;
       if(selected==i)$(field).options[cpt].selected = true;
       cpt++;
     }
   }
   else if(maxM){
     if(maxM<parseInt($(field).value)){
       selected = maxM;
     }
     $(field).options.length = (55/5)-((55/5)-(maxM/5))+1;

      for(i;i<=maxM;i=i+5){
        $(field).options[cpt].text = (i>=10)?i:"0"+i;
        $(field).options[cpt].value = i;
        if(selected==i){
          $(field).options[cpt].selected = true;
        }
        cpt++;
      }
    }
    else{
      // to normalize
      if($(field).options.length<12){
        $(field).options.length = 12;
        for(i;i<=55;i=i+5){
          $(field).options[cpt].text = (i>=10)?i:"0"+i;
          $(field).options[cpt].value = i;
          if(selected==i)$(field).options[cpt].selected = true;
          cpt++;
        }
      }
    }
  }
  
  function printPlanning(day,isPatient){
	  if($("servicetd2").style.display.length==0 && $('FindServiceUID').value.length==0){
			alert('<%=getTranNoLink("web","selectservicefirst",sWebLanguage)%>');
	  }
	  else{
	    var url = "<c:url value='/planning/ajax/getCalendarPdf.jsp'/>?ts="+new Date().getTime();
	    var params = '&dayToShow='+day+'&PatientID=<%=activePatient!=null?activePatient.personid:""%>'+($("servicetd2").style.display.length==0?'&FindServiceUID='+$F('FindServiceUID'):'')+'&FindUserUID='+$F("FindUserUID")+'&year='+dateStartOfWeek.getFullYear()+'&month='+(dateStartOfWeek.getMonth() / 1+1)+'&day='+dateStartOfWeek.getDate();	// Specifying which file to get
	    if(isPatient){
	      params+="&ispatient="+isPatient;  
	    }
	    window.open(url+params,"PatientAppointment<%=getTs()%>","height=600,width=900,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");
  	  }
  }
  
  function searchService(serviceUidField,serviceNameField){
	    openPopup("/_common/search/searchService.jsp&ts=<%=getTs()%>&VarSelectDefaultStay=true&VarCode="+serviceUidField+"&VarText="+serviceNameField);
	    document.getElementById(serviceNameField).focus();
	  }

	function validateNoShow(){
		if(document.getElementById("EditEffectiveDate_popcal").onclick){
			document.getElementById("EditEffectiveDate_popcal").tag=document.getElementById("EditEffectiveDate_popcal").onclick;
			document.getElementById("EditEffectiveDate_today").tag=document.getElementById("EditEffectiveDate_today").onclick;
		}
		if(document.getElementById("EditNoshow").checked){
			document.getElementById("EditEffectiveDate").value='';
			document.getElementById("EditEffectiveDate").setAttribute("readonly",true);
			document.getElementById("EditEffectiveDateTime").value='';
			document.getElementById("EditEffectiveDateTime").setAttribute("readonly",true);
			document.getElementById("EditEffectiveDate_popcal").tag=document.getElementById("EditEffectiveDate_popcal").onclick;
			document.getElementById("EditEffectiveDate_popcal").onclick=false;
			document.getElementById("EditEffectiveDate_today").tag=document.getElementById("EditEffectiveDate_today").onclick;
			document.getElementById("EditEffectiveDate_today").onclick=false;
		}
		else{
			document.getElementById("EditEffectiveDate").setAttribute("readonly",false);
			document.getElementById("EditEffectiveDateTime").setAttribute("readonly",false);
			document.getElementById("EditEffectiveDate_popcal").onclick=document.getElementById("EditEffectiveDate_popcal").tag;
			document.getElementById("EditEffectiveDate_today").onclick=document.getElementById("EditEffectiveDate_today").tag;
		}
	}
  	function selectTimeSlot(){
  		var params="uid="+document.getElementById('EditContactUID').value+"&start="+document.getElementById('appointmentDateHour').value+":"+document.getElementById('appointmentDateMinutes').value;	
  	    var url = "<c:url value='/planning/ajax/getTimeslot.jsp'/>?ts="+new Date().getTime();
  	    new Ajax.Request(url,{
  	      evalScripts:true,
  	      parameters:params,
  	      onSuccess:function(request){
  	        var resp = request.responseText.trim();
  	        if(resp.length>0){
  	        	var duration = resp.split(":")[0];
  	        	if(duration>0 && (document.getElementById('appointmentDateEndHour').value != resp.split(":")[1] || document.getElementById('appointmentDateEndMinutes').value != resp.split(":")[2] ) && window.confirm('<%=getTranNoLink("web","set.appointmentduration.to",sWebLanguage)%> '+duration+' <%=getTranNoLink("web","minutes",sWebLanguage)%>?')){
	  	        	document.getElementById('appointmentDateEndHour').value = resp.split(":")[1];
	  	        	document.getElementById('appointmentDateEndMinutes').value = resp.split(":")[2];
  	        	}
  	        }
  	      }
  	    });
  	}

	window.setTimeout("validateNoShow()",500);

  clientMsg.setDiv("weekScheduler_messages");
  resizeSheduler(containerHeight,containerWidth);
</script>