<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

&nbsp;&nbsp;<a href="#" onMouseOver="window.status='';return true;" onClick="doClick('<c:url value="/main.do"/>?ts=<%=getTs()%>');">Home</a>
<%
    String sPage = checkString(request.getParameter("Page"));

    if(sPage.length() > 0 && !sPage.equalsIgnoreCase("null")){
        String sPatientID = "";
        if(activePatient!=null){
            sPatientID = checkString(activePatient.personid);
        }

        if(sPage.indexOf("patientnew")>0){
            %>&gt;&nbsp;Patient&nbsp;&gt;&nbsp;<%=getTran(request,"Web","New",sWebLanguage)%>&nbsp;<img src="<c:url value="/_img/themes/default/pijl.gif"/>">&nbsp;<%=getTran(request,"Web","actualpersonaldata",sWebLanguage)%><%
        }
        else if(sPage.indexOf("patientdata")>-1){
            %><img src="<c:url value="/_img/themes/default/pijl.gif"/>">&nbsp;<%=getTran(request,"Web","Administration",sWebLanguage)%><%
        }
        else if(sPage.indexOf("config")>-1){
            %><img src="<c:url value="/_img/themes/default/pijl.gif"/>">&nbsp;<%=getTran(request,"Web","config",sWebLanguage)%><%
        }
        else if(sPage.indexOf("patientedit")>-1){
            %>
                <img src="<c:url value="/_img/themes/default/pijl.gif"/>">&nbsp;<a href="#" onMouseOver="window.status='';return true;" onClick="doClick('<c:url value="/patientdata.do"/>?PatientID=<%=sPatientID%>&ts=<%=getTs()%>');"><%=getTran(request,"Web","Administration",sWebLanguage)%></a>
                <img src="<c:url value="/_img/themes/default/pijl.gif"/>">&nbsp;<%=getTran(request,"Web","actualpersonaldata",sWebLanguage)%>
            <%
        }
        else if(sPage.indexOf("patienthistory")>-1){
            %>
                <img src="<c:url value="/_img/themes/default/pijl.gif"/>">&nbsp;<a href="#" onMouseOver="window.status='';return true;" onClick="doClick('<c:url value="/patientdata.do"/>?PatientID=<%=sPatientID%>&ts=<%=getTs()%>');"><%=getTran(request,"Web","Administration",sWebLanguage)%></a>
                <img src="<c:url value="/_img/themes/default/pijl.gif"/>">&nbsp;<%=getTran(request,"Web","history",sWebLanguage)%>
            <%
        }
        else if(sPage.indexOf("patientslist")>-1){
            %>
                <img src="<c:url value="/_img/themes/default/pijl.gif"/>">&nbsp;Patient&nbsp;
                <img src="<c:url value="/_img/themes/default/pijl.gif"/>">&nbsp;<%=getTran(request,"Web","Find",sWebLanguage)%>
            <%
        }
        else if(sPage.indexOf("userprofile")>-1){
            %>
                <img src="<c:url value="/_img/themes/default/pijl.gif"/>">&nbsp;<%=getTran(request,"Web","System",sWebLanguage)%>
                <img src="<c:url value="/_img/themes/default/pijl.gif"/>">&nbsp;<a href="#" onMouseOver="window.status='';return true;" onClick="doClick('<c:url value="/main.do"/>?Page=userprofile/index.jsp&PatientID=<%=sPatientID%>&ts=<%=getTs()%>');"><%=getTran(request,"Web","MyProfile",sWebLanguage)%></a>
            <%
        }
        else if(sPage.indexOf("permissions")>-1){
            %>
                <img src="<c:url value="/_img/themes/default/pijl.gif"/>">&nbsp;<%=getTran(request,"Web","System",sWebLanguage)%>
                <img src="<c:url value="/_img/themes/default/pijl.gif"/>">&nbsp;<a href="#" onMouseOver="window.status='';return true;" onClick="doClick('<c:url value="/main.do"/>?Page=permissions/index.jsp&PatientID=<%=sPatientID%>&ts=<%=getTs()%>');"><%=getTran(request,"Web","Permissions",sWebLanguage)%>
            <%
        }
        else if(sPage.indexOf("system")>-1){
            %><img src="<c:url value="/_img/themes/default/pijl.gif"/>">&nbsp;<a href="#" onMouseOver="window.status='';return true;" onClick="doClick('<c:url value="/main.do"/>?Page=system/menu.jsp');"><%=getTran(request,"Web","System",sWebLanguage)%></a><%
        }
        else if((sPage.indexOf("healthrecord")>-1)||(sPage.indexOf("curative")>-1)){
            %><img src="<c:url value="/_img/themes/default/pijl.gif"/>">&nbsp;<a href="#" onMouseOver="window.status='';return true;" onClick="doClick('<c:url value="/main.do"/>?Page=curative/index.jsp');"><%=getTran(request,"Web","curative",sWebLanguage)%></a><%
        }
        else if(sPage.indexOf("labos")>-1){
            %><img src="<c:url value="/_img/themes/default/pijl.gif"/>">&nbsp;<a href="#" onMouseOver="window.status='';return true;" onClick="doClick('<c:url value="/main.do"/>?Page=labos/index.jsp');"><%=getTran(request,"Web","labos",sWebLanguage)%></a><%
        }
        else if(sPage.indexOf("xrays")>-1){
            %><img src="<c:url value="/_img/themes/default/pijl.gif"/>">&nbsp;<a href="#" onMouseOver="window.status='';return true;" onClick="doClick('<c:url value="/main.do"/>?Page=xrays/index.jsp');"><%=getTran(request,"Web","xrays",sWebLanguage)%></a><%
        }
        else if(sPage.indexOf("financial")>-1){
            %><img src="<c:url value="/_img/themes/default/pijl.gif"/>">&nbsp;<%=getTran(request,"Web","financial",sWebLanguage)%><%
        }
        else if(sPage.indexOf("medical")>-1){
            %><img src="<c:url value="/_img/themes/default/pijl.gif"/>">&nbsp;<a href="#" onMouseOver="window.status='';return true;" onClick="doClick('<c:url value="/main.do"/>?Page=medical/index.jsp');"><%=getTran(request,"Web","medical",sWebLanguage)%></a><%
        }
        else if(sPage.indexOf("pharmacy")>-1){
            %><img src="<c:url value="/_img/themes/default/pijl.gif"/>">&nbsp;<a href="#" onMouseOver="window.status='';return true;" onClick="doClick('<c:url value="/main.do"/>?Page=pharmacy/index.jsp');"><%=getTran(request,"Web","pharmacy",sWebLanguage)%></a><%
        }
        else if(sPage.indexOf("center")>-1){
            %><img src="<c:url value="/_img/themes/default/pijl.gif"/>">&nbsp;<a href="#" onMouseOver="window.status='';return true;" onClick="doClick('<c:url value="/main.do"/>?Page=center/index.jsp');"><%=getTran(request,"Web","centerinfo",sWebLanguage)%></a><%
        }
    }
%>

<script>
  function doClick(url){
    if(checkSaveButton()){
      window.location.href = url;
    }
  }
</script>