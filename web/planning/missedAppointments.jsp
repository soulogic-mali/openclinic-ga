<%@ page import="be.openclinic.adt.Planning,
be.dpms.medwan.common.model.vo.occupationalmedicine.ExaminationVO,
java.util.*" %>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"planning.patient","select",activeUser)%>

<%
    String sAction = checkString(request.getParameter("Action"));

    //--- DELETE ----------------------------------------------------------------------------------
    if(sAction.equals("delete")){
        String sEditPlanningUID = checkString(request.getParameter("EditPlanningUID"));
        Planning.delete(sEditPlanningUID);

        %>
          <script>
            window.location.href = "<c:url value='/main.do'/>?Page=planning/findPlanning.jsp&Tab=missedAppointments&ts=<%=getTs()%>";
          </script>
        <%
    }

if (activePatient!=null){
    String sFindPatientDate = checkString(request.getParameter("FindPatientDate"));

    if (sFindPatientDate.length()==0){
        sFindPatientDate = checkString(request.getParameter("FindDate"));

        if (sFindPatientDate.length()==0){
            sFindPatientDate = getDate();
        }
    }
%>

<form name="appointmentsForm" method="post" action="<c:url value='/main.do'/>?Page=planning/findPlanning.jsp&Tab=missedAppointments&ts=<%=getTs()%>">
    <%-- hidden fields --%>
    <input type="hidden" name="Action">
    <input type="hidden" name="EditPlanningUID">

<%=writeTableHeader("planning","missedAppointments",sWebLanguage," doBack();")%>
<%
    String sClass = "";
    SimpleDateFormat hhmmDateFormat = new SimpleDateFormat("HH:mm");

    Vector vPatientMissedPlannings = Planning.getPatientMissedPlannings(activePatient.personid);

    if (vPatientMissedPlannings.size()>0){
        %>
            <br/>

            <table class="list" width="100%" cellspacing="0" cellpadding="0">
                <tr class="admin">
                    <td width="20">&nbsp;</td>
                    <td width="80"><%=getTran(request,"web.occup","medwan.common.date",sWebLanguage)%></td>
                    <td width="50"><%=getTran(request,"web","from",sWebLanguage)%></td>
                    <td width="50"><%=getTran(request,"web","to",sWebLanguage)%></td>
                    <td width="200"><%=getTran(request,"planning","user",sWebLanguage)%></td>
                    <td width="250"><%=getTran(request,"web","prestation",sWebLanguage)%></td>
                    <td><%=getTran(request,"web","description",sWebLanguage)%></td>
                </tr>

                <%
                    Planning planning;
                    String[] aHour;
                    Calendar calPlanningStop;
                    ObjectReference orContact;
                    ExaminationVO examination;
                    
                    String sTextAdd = getTranNoLink("web","add",sWebLanguage);
                    SimpleDateFormat fullDateFormat = ScreenHelper.fullDateFormat;

                    Iterator iter = vPatientMissedPlannings.iterator();
                    while(iter.hasNext()){
                        planning = (Planning)iter.next();

                        calPlanningStop = Calendar.getInstance();
                        calPlanningStop.setTime(planning.getPlannedDate());
                        calPlanningStop.set(Calendar.SECOND, 00);
                        calPlanningStop.set(Calendar.MILLISECOND, 00);

                        if(checkString(planning.getEstimatedtime()).length() > 0){
                            try{
                                aHour = planning.getEstimatedtime().split(":");
                                calPlanningStop.setTime(planning.getPlannedDate());
                                calPlanningStop.add(Calendar.HOUR,Integer.parseInt(aHour[0]));
                                calPlanningStop.add(Calendar.MINUTE,Integer.parseInt(aHour[1]));
                            }
                            catch(Exception e1){
                                calPlanningStop.setTime(planning.getPlannedDate());
                            }
                        }

                        // alternate row-style
                        if(sClass.equals("")) sClass = "1";
                        else                  sClass = "";

                        %>
                            <tr class="list<%=sClass%>" >
                                <td><a href="javascript:actualAppointmentId='<%=planning.getUid()%>';deleteAppointment2('missedappointements');"><img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","delete",sWebLanguage)%>"></a></td>
                                <td><a href="javascript:openAppointment('<%=planning.getUid()%>','missedappointments');"><%=ScreenHelper.getSQLDate(planning.getPlannedDate())%></a></td>
                                <td><a href="javascript:openAppointment('<%=planning.getUid()%>','missedappointments');"><%=hhmmDateFormat.format(planning.getPlannedDate())%></a></td>
                                <td><a href="javascript:openAppointment('<%=planning.getUid()%>','missedappointments');"><%=hhmmDateFormat.format(calPlanningStop.getTime())%></a></td>
                                <td><a href="javascript:openAppointment('<%=planning.getUid()%>','missedappointments');">
                                    <%
                                        if(planning.getUserUID().equals(activeUser.userid)){
                                            out.print("<b>"+ScreenHelper.getFullUserName(planning.getUserUID())+"</b>");
                                        }
                                        else{
                                            out.print(ScreenHelper.getFullUserName(planning.getUserUID()));
                                        }
                                    %>
                                </a></td>
                                <td><a href="javascript:openAppointment('<%=planning.getUid()%>','missedappointments');">
                                    <%
                                        orContact = planning.getContact();
                                        if(orContact != null){
                                            if(orContact.getObjectType().equalsIgnoreCase("examination")){
                                                examination = MedwanQuery.getInstance().getExamination(orContact.getObjectUid(), sWebLanguage);
                                                if(examination!=null && examination.getTransactionType()!=null){
	                                                if(checkString(planning.getTransactionUID()).length()==0){
	                                                    out.print("<img src='_img/icons/icon_add.gif' onclick='doExamination(\""+planning.getUid()+"\",\"" + planning.getPatientUID() + "\",\"" + examination.getTransactionType() + "\")' alt='" + sTextAdd + "' class='link'/> "
	                                                        + getTran(request,"examination", examination.getId().toString(), sWebLanguage));
	                                                }
	                                                else{
	                                                    String sTextFind = getTran(request,"web", "find", sWebLanguage);
	                                                    out.print("<img src='_img/icons/icon_search.png' onclick='openExamination(\""+planning.getTransactionUID().split("\\.")[0]+"\",\""+planning.getTransactionUID().split("\\.")[1]+"\",\"" + planning.getPatientUID() + "\",\"" + examination.getTransactionType() + "\")' alt='" + sTextFind + "' class='link'/> "
	                                                        + getTran(request,"examination", examination.getId().toString(), sWebLanguage));
	                                                }
                                                }
                                            }
                                        }
                                    %>
                                </a></td>
                                <td><a href="javascript:openAppointment('<%=planning.getUid()%>','missedappointments');"><%=planning.getDescription()%></a></td>
                            </tr>
                        <%
                    }
                %>
            </table>
            <%=vPatientMissedPlannings.size()%> <%=getTran(request,"web","recordsFound",sWebLanguage)%>
            <br>
        <%
    }
%>
            <br/>
			<hr/>
            <br/>
<%=writeTableHeader("planning","canceledAppointments",sWebLanguage," doBack();")%>
<%

    Vector vPatientCanceledPlannings = Planning.getPatientCanceledPlannings(activePatient.personid);

    if (vPatientCanceledPlannings.size()>0){
        %>
            <table class="list" width="100%" cellspacing="0" cellpadding="0">
                <tr class="admin">
                    <td width="20">&nbsp;</td>
                    <td width="80"><%=getTran(request,"web.occup","medwan.common.date",sWebLanguage)%></td>
                    <td width="50"><%=getTran(request,"web","from",sWebLanguage)%></td>
                    <td width="50"><%=getTran(request,"web","to",sWebLanguage)%></td>
                    <td width="200"><%=getTran(request,"planning","user",sWebLanguage)%></td>
                    <td width="250"><%=getTran(request,"web","cancelationdate",sWebLanguage)%></td>
                    <td><%=getTran(request,"web","description",sWebLanguage)%></td>
                </tr>

                <%
                    Planning planning;
                    String[] aHour;
                    Calendar calPlanningStop;
                    ObjectReference orContact;
                    ExaminationVO examination;
                    
                    String sTextAdd = getTranNoLink("web","add",sWebLanguage);
                    SimpleDateFormat fullDateFormat = ScreenHelper.fullDateFormat;

                    Iterator iter = vPatientCanceledPlannings.iterator();
                    while(iter.hasNext()){
                        planning = (Planning)iter.next();

                        calPlanningStop = Calendar.getInstance();
                        calPlanningStop.setTime(planning.getPlannedDate());
                        calPlanningStop.set(Calendar.SECOND, 00);
                        calPlanningStop.set(Calendar.MILLISECOND, 00);

                        if(checkString(planning.getEstimatedtime()).length() > 0){
                            try{
                                aHour = planning.getEstimatedtime().split(":");
                                calPlanningStop.setTime(planning.getPlannedDate());
                                calPlanningStop.add(Calendar.HOUR,Integer.parseInt(aHour[0]));
                                calPlanningStop.add(Calendar.MINUTE,Integer.parseInt(aHour[1]));
                            }
                            catch(Exception e1){
                                calPlanningStop.setTime(planning.getPlannedDate());
                            }
                        }

                        // alternate row-style
                        if(sClass.equals("")) sClass = "1";
                        else                  sClass = "";

                        %>
                            <tr class="list<%=sClass%>" >
                                <td></td>
                                <td><%=ScreenHelper.getSQLDate(planning.getPlannedDate())%></td>
                                <td><%=hhmmDateFormat.format(planning.getPlannedDate())%></td>
                                <td><%=hhmmDateFormat.format(calPlanningStop.getTime())%></td>
                                <td>
                                    <%
                                        if(planning.getUserUID().equals(activeUser.userid)){
                                            out.print("<b>"+ScreenHelper.getFullUserName(planning.getUserUID())+"</b>");
                                        }
                                        else{
                                            out.print(ScreenHelper.getFullUserName(planning.getUserUID()));
                                        }
                                    %>
                                </td>
                                <td><%=ScreenHelper.getSQLDate(planning.getCancelationDate())%></td>
                                <td><%=planning.getDescription()%></td>
                            </tr>
                        <%
                    }
                %>
            </table>
            <%=vPatientCanceledPlannings.size()%> <%=getTran(request,"web","recordsFound",sWebLanguage)%>
            <br>
        <%
    }
%>
            <br/>
			<hr/>
            <br/>
<%=writeTableHeader("planning","noshows",sWebLanguage," doBack();")%>
<%
    Vector vPatientPlannings = Planning.getPatientPlannings(activePatient.personid, "", null, null);

    if (vPatientPlannings.size()>0){
        %>
            <table class="list" width="100%" cellspacing="0" cellpadding="0">
                <tr class="admin">
                    <td width="20">&nbsp;</td>
                    <td width="80"><%=getTran(request,"web.occup","medwan.common.date",sWebLanguage)%></td>
                    <td width="50"><%=getTran(request,"web","from",sWebLanguage)%></td>
                    <td width="50"><%=getTran(request,"web","to",sWebLanguage)%></td>
                    <td width="200"><%=getTran(request,"planning","user",sWebLanguage)%></td>
                    <td><%=getTran(request,"web","description",sWebLanguage)%></td>
                </tr>

                <%
                    Planning planning;
                    String[] aHour;
                    Calendar calPlanningStop;
                    ObjectReference orContact;
                    ExaminationVO examination;
                    
                    String sTextAdd = getTranNoLink("web","add",sWebLanguage);
                    SimpleDateFormat fullDateFormat = ScreenHelper.fullDateFormat;

                    Iterator iter = vPatientPlannings.iterator();
                    while(iter.hasNext()){
                        planning = (Planning)iter.next();
                        if(!checkString(planning.getNoshow()).equalsIgnoreCase("1")){
                        	continue;
                        }

                        calPlanningStop = Calendar.getInstance();
                        calPlanningStop.setTime(planning.getPlannedDate());
                        calPlanningStop.set(Calendar.SECOND, 00);
                        calPlanningStop.set(Calendar.MILLISECOND, 00);

                        if(checkString(planning.getEstimatedtime()).length() > 0){
                            try{
                                aHour = planning.getEstimatedtime().split(":");
                                calPlanningStop.setTime(planning.getPlannedDate());
                                calPlanningStop.add(Calendar.HOUR,Integer.parseInt(aHour[0]));
                                calPlanningStop.add(Calendar.MINUTE,Integer.parseInt(aHour[1]));
                            }
                            catch(Exception e1){
                                calPlanningStop.setTime(planning.getPlannedDate());
                            }
                        }

                        // alternate row-style
                        if(sClass.equals("")) sClass = "1";
                        else                  sClass = "";

                        %>
                            <tr class="list<%=sClass%>" >
                                <td></td>
                                <td><%=ScreenHelper.getSQLDate(planning.getPlannedDate())%></td>
                                <td><%=hhmmDateFormat.format(planning.getPlannedDate())%></td>
                                <td><%=hhmmDateFormat.format(calPlanningStop.getTime())%></td>
                                <td>
                                    <%
                                        if(checkString(planning.getUserUID()).equals(activeUser.userid)){
                                            out.print("<b>"+ScreenHelper.getFullUserName(planning.getUserUID())+"</b>");
                                        }
                                        else{
                                            out.print(ScreenHelper.getFullUserName(planning.getUserUID()));
                                        }
                                    %>
                                </td>
                                <td><%=planning.getDescription()%></td>
                            </tr>
                        <%
                    }
                %>
            </table>
            <%=vPatientPlannings.size()%> <%=getTran(request,"web","recordsFound",sWebLanguage)%>
            <br>
        <%
    }
%>
<br/>

<input type="button" name="buttonback" class="button" value="<%=getTranNoLink("web","back",sWebLanguage)%>" onclick="doBack();"/>   
</form>
<%
}
else{
    out.print(getTran(request,"web","noactivepatient",sWebLanguage));
}
%>