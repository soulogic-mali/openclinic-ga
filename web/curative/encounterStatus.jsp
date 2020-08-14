<%@page import="be.openclinic.adt.Encounter"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
    String sPatientUid;
    if(activePatient != null){
        sPatientUid = checkString(activePatient.personid);
    } 
    else {
        sPatientUid = "";
    }

    if (sPatientUid.length() > 0) {
        Encounter lastAdmissionEncounter = Encounter.getInactiveEncounterBefore(sPatientUid, "admission", new java.util.Date());
        Encounter lastVisitEncounter = Encounter.getInactiveEncounterBefore(sPatientUid, "visit", new java.util.Date());

        java.util.Date dLastAdmission = null;
        if (lastAdmissionEncounter != null) {
            dLastAdmission = lastAdmissionEncounter.getBegin();
        }
        java.util.Date dLastVisit = null;
        if (lastVisitEncounter != null) {
            dLastVisit = lastVisitEncounter.getBegin();
        }

        Encounter activeEncounter = Encounter.getActiveEncounter(sPatientUid);
%>
            <table width="100%" class="list" cellspacing="0" cellpadding="0" style="border-bottom:none;">
                <tr class="admin">
                    <td width="300">
                        <%=getTran(request,"curative","encounter.status.title",sWebLanguage)%>&nbsp;
                        <a href="<c:url value='/main.do'/>?Page=adt/historyEncounter.jsp&ts=<%=getTs()%>"><img height='16px' style='vertical-align: middle' src="<c:url value='/_img/icons/icon_history.png'/>" class="link" alt="<%=getTranNoLink("web","historyencounters",sWebLanguage)%>" style="vertical-align: middle"></a>
                        <a href="javascript:newEncounter();"><img height='16px' style='vertical-align: middle' src="<c:url value='/_img/icons/icon_newpage.png'/>" class="link" alt="<%=getTranNoLink("web","newencounter",sWebLanguage)%>" style="vertical-align:-4px;"></a>
						<%if(MedwanQuery.getInstance().getConfigString("quickConsult1."+activeUser.userid,"").split(";").length>MedwanQuery.getInstance().getConfigInt("minimumQuickConsultFields",3)-1){ %>
	                        <a href="javascript:newFastEncounter('<%=MedwanQuery.getInstance().getConfigString("quickConsult1."+activeUser.userid)%>');"><img height='20px' style='vertical-align: middle'  src="<c:url value='/_img/icons/icon_new1.png'/>" class="link" title="<%=getTranNoLink("web",MedwanQuery.getInstance().getConfigString("quickConsult1."+activeUser.userid).split(";")[0],sWebLanguage)+" "+getTranNoLink("service",MedwanQuery.getInstance().getConfigString("quickConsult1."+activeUser.userid).split(";")[2],sWebLanguage)+" "+(MedwanQuery.getInstance().getConfigString("quickConsult1."+activeUser.userid,"").split(";").length<5?"":getTranNoLink("encounter.situation",MedwanQuery.getInstance().getConfigString("quickConsult1."+activeUser.userid).split(";")[4],sWebLanguage))%>" style="vertical-align:-4px;"></a>
	                    <%} %>
						<%if(MedwanQuery.getInstance().getConfigString("quickConsult2."+activeUser.userid,"").split(";").length>MedwanQuery.getInstance().getConfigInt("minimumQuickConsultFields",3)-1){ %>
	                        <a href="javascript:newFastEncounter('<%=MedwanQuery.getInstance().getConfigString("quickConsult2."+activeUser.userid)%>');"><img height='20px' style='vertical-align: middle'  src="<c:url value='/_img/icons/icon_new2.png'/>" class="link" title="<%=getTranNoLink("web",MedwanQuery.getInstance().getConfigString("quickConsult2."+activeUser.userid).split(";")[0],sWebLanguage)+" "+getTranNoLink("service",MedwanQuery.getInstance().getConfigString("quickConsult2."+activeUser.userid).split(";")[2],sWebLanguage)+" "+(MedwanQuery.getInstance().getConfigString("quickConsult2."+activeUser.userid,"").split(";").length<5?"":getTranNoLink("encounter.situation",MedwanQuery.getInstance().getConfigString("quickConsult2."+activeUser.userid).split(";")[4],sWebLanguage))%>" style="vertical-align:-4px;"></a>
	                    <%} %>
						<%if(MedwanQuery.getInstance().getConfigString("quickConsult3."+activeUser.userid,"").split(";").length>MedwanQuery.getInstance().getConfigInt("minimumQuickConsultFields",3)-1){ %>
	                        <a href="javascript:newFastEncounter('<%=MedwanQuery.getInstance().getConfigString("quickConsult3."+activeUser.userid)%>');"><img height='20px' style='vertical-align: middle'  src="<c:url value='/_img/icons/icon_new3.png'/>" class="link" title="<%=getTranNoLink("web",MedwanQuery.getInstance().getConfigString("quickConsult3."+activeUser.userid).split(";")[0],sWebLanguage)+" "+getTranNoLink("service",MedwanQuery.getInstance().getConfigString("quickConsult3."+activeUser.userid).split(";")[2],sWebLanguage)+" "+(MedwanQuery.getInstance().getConfigString("quickConsult3."+activeUser.userid,"").split(";").length<5?"":getTranNoLink("encounter.situation",MedwanQuery.getInstance().getConfigString("quickConsult3."+activeUser.userid).split(";")[4],sWebLanguage))%>" style="vertical-align:-4px;"></a>
	                    <%} %>
						<%if(MedwanQuery.getInstance().getConfigString("quickConsult4."+activeUser.userid,"").split(";").length>MedwanQuery.getInstance().getConfigInt("minimumQuickConsultFields",3)-1){ %>
	                        <a href="javascript:newFastEncounter('<%=MedwanQuery.getInstance().getConfigString("quickConsult4."+activeUser.userid)%>');"><img height='20px' style='vertical-align: middle'  src="<c:url value='/_img/icons/icon_new4.png'/>" class="link" title="<%=getTranNoLink("web",MedwanQuery.getInstance().getConfigString("quickConsult4."+activeUser.userid).split(";")[0],sWebLanguage)+" "+getTranNoLink("service",MedwanQuery.getInstance().getConfigString("quickConsult4."+activeUser.userid).split(";")[2],sWebLanguage)+" "+(MedwanQuery.getInstance().getConfigString("quickConsult4."+activeUser.userid,"").split(";").length<5?"":getTranNoLink("encounter.situation",MedwanQuery.getInstance().getConfigString("quickConsult4."+activeUser.userid).split(";")[4],sWebLanguage))%>" style="vertical-align:-4px;"></a>
	                    <%} %>
						<%if(MedwanQuery.getInstance().getConfigString("quickConsult5."+activeUser.userid,"").split(";").length>MedwanQuery.getInstance().getConfigInt("minimumQuickConsultFields",3)-1){ %>
	                        <a href="javascript:newFastEncounter('<%=MedwanQuery.getInstance().getConfigString("quickConsult5."+activeUser.userid)%>');"><img height='20px' style='vertical-align: middle' src="<c:url value='/_img/icons/icon_new5.png'/>" class="link" title="<%=getTranNoLink("web",MedwanQuery.getInstance().getConfigString("quickConsult5."+activeUser.userid).split(";")[0],sWebLanguage)+" "+getTranNoLink("service",MedwanQuery.getInstance().getConfigString("quickConsult5."+activeUser.userid).split(";")[2],sWebLanguage)+" "+(MedwanQuery.getInstance().getConfigString("quickConsult5."+activeUser.userid,"").split(";").length<5?"":getTranNoLink("encounter.situation",MedwanQuery.getInstance().getConfigString("quickConsult5."+activeUser.userid).split(";")[4],sWebLanguage))%>" style="vertical-align:-4px;"></a>
	                    <%} %>
                    </td>
                    <td width="250"><i><%=getTran(request,"curative","encounter.last.hospitalisation",sWebLanguage)%>:
                        <%
                            if(dLastAdmission != null){
                                out.print("<a href='javascript:goRead(\""+lastAdmissionEncounter.getUid()+"\");'>"+ScreenHelper.stdDateFormat.format(dLastAdmission)+"</a>");
                            }
                        %></i>
                    </td>
                    <td><i><%=getTran(request,"curative","encounter.last.visit",sWebLanguage)%>:
                        <%
                            if(dLastVisit != null){
                                out.print("<a href='javascript:goRead(\""+lastVisitEncounter.getUid()+"\");'>"+ScreenHelper.stdDateFormat.format(dLastVisit)+"</a>");
                            }
                        %></i>
                    </td>
                </tr>
            </table>
    <%
        if(activeEncounter != null){
    %>
            <table width='100%' cellspacing='0' cellpadding="0" class='sortable' id="sortable">
                <tr class='gray'>
                    <td>
                        <%=getTran(request,"web","contactid",sWebLanguage)%>
                        <%
	                        if(checkString(activeEncounter.getType()).equalsIgnoreCase("visit") && activeEncounter.getEnd()==null && activeUser.getAccessRight("adt.encounter.edit")){
	                            %>&nbsp;<img class="link" src="<c:url value='/_img/themes/default/keywords.jpg'/>" onclick="closeEncounter('<%=activeEncounter.getUid() %>')" alt="<%=getTranNoLink("web","close",sWebLanguage)%>"  title="<%=getTran(null,"web","close",sWebLanguage)%>" style="vertical-align:-4px;"/><% 
	                        }
                       	%>
                    </td>
                    <td><%=getTran(request,"web","type",sWebLanguage)%></td>
                    <td><%=getTran(request,"web","begindate",sWebLanguage)%></td>
                    <td><%=getTran(request,"web","service",sWebLanguage)%></td>
                    <%
                        if(!checkString(activeEncounter.getType()).equalsIgnoreCase("visit")){
                            %><td><%=getTran(request,"web","bed",sWebLanguage)%></td><%
                        }
                    %>
                    <td><%=getTran(request,"web","careprovider",sWebLanguage)%></td>
                </tr>
                <tr class='<%=activeEncounter.getEnd()==null?"list":"listDisabled"%>' onmouseover="this.style.cursor='hand';" onmouseout="this.style.cursor='default';" onclick="goEdit('<%=activeEncounter.getUid()%>');">
                    <td>
                        <b><%=checkString(activeEncounter.getUid())%></b>
                        <img height='16px' style='vertical-align: middle' src="<c:url value='/_img/icons/icon_edit2.png'/>" class="link" alt="<%=getTranNoLink("web","edit",sWebLanguage)%>" onclick="goEdit('<%=activeEncounter.getUid()%>');"><%
	                        if(activeEncounter.getType().equalsIgnoreCase("admission") && activeEncounter.getDurationInDays()>Encounter.getAccountedAccomodationDays(activeEncounter.getUid())){
	                            %>&nbsp;<img class="link" src="<c:url value='/_img/icons/icon_money.gif'/>"  style="vertical-align:-4px;"/><%
	                        }
	                        if(activeEncounter.getEnd()!=null){
	                            %>&nbsp;<img class="link" src="<c:url value='/_img/icons/icon_keywords.gif'/>"  style="vertical-align:-4px;"/><%
	                        }
                        %>
                    </td>
                    <td>
                        <b><%=getTran(request,"web",checkString(activeEncounter.getType()),sWebLanguage)%></b>
                    </td>
                    <td>
                    <%
                        if(activeEncounter.getBegin() != null){
                            out.print(ScreenHelper.stdDateFormat.format(activeEncounter.getBegin()));
                        }
                    %>
                    </td>
                    <%
                        String sService = "";
                        if(activeEncounter.getService()!=null){
                            sService = "<i>"+activeEncounter.getService().code+": </i><b>"+getTran(request,"Service",activeEncounter.getService().code,sWebLanguage)+"</b>";
                        }
                    %>
                    <td><%=sService%>
                        <%
                        if(!checkString(activeEncounter.getType()).equalsIgnoreCase("visit")){
                            %></td><td><%
                            if(activeEncounter.getBed()!=null){
                                out.print("<i>"+activeEncounter.getBed().getServiceUID()+": </i><b>"+activeEncounter.getBed().getName()+"<b>");
                            }
                            %></td><%
                        }
                    %>
                    <td>
                    <%
                        User manager = activeEncounter.getManager();
                        if((manager!=null)&&(manager.userid != null) && (manager.userid.length() > 0)){
                            out.print(ScreenHelper.getFullUserName(manager.userid));
                        }
                    %>
                    </td>
                </tr>
            </table>
    <%
        }
    %>

<script>
  function goEdit(EncounterUid){
    window.location.href="<c:url value='/main.do'/>?Page=adt/editEncounter.jsp&EditEncounterUID=" + EncounterUid + "&ts=<%=getTs()%>";
  }

  function goRead(EncounterUid){
    openPopup("adt/editEncounter.jsp&ReadOnly=yes&Popup=yes&EditEncounterUID=" + EncounterUid + "&ts=<%=getTs()%>",800);
  }
    
  function closeEncounter(uid){
    var url= '<c:url value="/adt/closeEncounter.jsp"/>?uid='+uid;
	new Ajax.Request(url,{
	  method: "GET",
	  parameters: "",
	  onSuccess: function(resp){
	    window.location.reload();
	  }
	});
  }
</script>
<%
    }
    else{
        out.print(getTran(request,"web","nopatientselected",sWebLanguage));
    }
%>
