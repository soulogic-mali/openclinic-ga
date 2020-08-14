<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
    String sGender = "&nbsp;", sComment = "&nbsp;", sNativeCountry = "&nbsp;", sLanguage = "&nbsp;", sNatreg = "&nbsp;", sVip="0"
            , sCivilStatus = "&nbsp;", sTracnetID = "&nbsp;", sPersonType = "&nbsp;", sTreatingPhysician = "&nbsp;", sComment3="", sComment4="", sComment5="", sDeathCertificateTo="", sDeathCertificateOn="", sExport="0", sLastExport="0";

    // language
    sWebLanguage = activeUser.person.language;
    if ((activePatient.language!=null)&&(activePatient.language.trim().length()>0)) {
        sLanguage = getTran(request,"Web.language",activePatient.language,sWebLanguage);
    }

    // Gender
    if ((activePatient.gender!=null)&&(activePatient.gender.trim().length()>0)) {
        if (activePatient.gender.equalsIgnoreCase("m")){
            sGender = getTran(request,"web.occup","male",sWebLanguage);
        }
        else if (activePatient.gender.equalsIgnoreCase("f")){
            sGender = getTran(request,"web.occup","female",sWebLanguage);
        }
        if(!activePatient.getBioGender().equalsIgnoreCase(activePatient.gender)){
        	sGender+=" ("+getTran(request,"web","biologicgenderdifferent",sWebLanguage)+")";
        }
    }
    // sTracnetID
    if (checkString((String)activePatient.adminextends.get("tracnetid")).length()>0) {
        sTracnetID = checkString((String)activePatient.adminextends.get("tracnetid"));
    }

    // sDeathCertificateTo
    if (checkString((String)activePatient.adminextends.get("deathcertificateto")).length()>0) {
    	sDeathCertificateTo = checkString((String)activePatient.adminextends.get("deathcertificateto"));
    }

    // sDeathCertificateOn
    if (checkString((String)activePatient.adminextends.get("deathcertificateon")).length()>0) {
    	sDeathCertificateOn = checkString((String)activePatient.adminextends.get("deathcertificateon"));
    }

    // sTreatingPhysician
    if (checkString(activePatient.comment1).length()>0) {
        sTreatingPhysician = activePatient.comment1;
    }

    // civilstatus
    if ((activePatient.comment2!=null)&&(activePatient.comment2.trim().length()>0)) {
        sCivilStatus = getTran(request,"civil.status",activePatient.comment2,sWebLanguage);
    }

    // comment
    if ((activePatient.comment!=null)&&(activePatient.comment.trim().length()>0)) {
        sComment = (activePatient.comment);
    }

    if ((activePatient.personType!=null)&&(activePatient.personType.trim().length()>0)) {
        sPersonType = (activePatient.personType);
    }

    // comment
    if ((activePatient.comment3!=null)&&(activePatient.comment3.trim().length()>0)) {
        sComment3 = (activePatient.comment3);
    }

    // comment
    if ((activePatient.comment4!=null)&&(activePatient.comment4.trim().length()>0)) {
        sComment4 = (activePatient.comment4);
    }

    // comment
    if ((activePatient.comment5!=null)&&(activePatient.comment5.trim().length()>0)) {
        sComment5 = (activePatient.comment5);
    }

    // nativeCountry
    if ((activePatient.nativeCountry!=null)&&(activePatient.nativeCountry.trim().length()>0)) {
        sNativeCountry = getTran(request,"Country",activePatient.nativeCountry,sWebLanguage);
    }

    // nat reg
    if (checkString(activePatient.getID("natreg")).length()>0) {
        sNatreg = activePatient.getID("natreg");
    }

    // VIP
    if (MedwanQuery.getInstance().getConfigInt("enableVip",0)==1 && checkString((String)activePatient.adminextends.get("vip")).length()>0) {
        sVip = (String)activePatient.adminextends.get("vip");
        if(sVip==null || sVip.length()==0){
        	sVip="0";
        }
    }

    // ExportRequest
    if (MedwanQuery.getInstance().getConfigInt("enableDatacenterPatientExport",0)==1 && activePatient.hasPendingExportRequest()) {
		sExport="1";
    }
%>
<%-- MAIN TABLE ----------------------------------------------------------------------------------%>
<table width='100%' cellspacing="1" class="list">
    <%=(
        setRow(request,"Web","nativecountry",sNativeCountry,sWebLanguage)
        +setRow(request,"Web","Language",sLanguage,sWebLanguage)
        +setRow(request,"Web","Gender",sGender,sWebLanguage)
        +setRow(request,"Web","documenttype",getTran(request,"documenttype",sPersonType,sWebLanguage),sWebLanguage)
        +setRow(request,"Web","natreg",sNatreg,sWebLanguage)
        +setRow(request,"Web","childorder",sTracnetID,sWebLanguage)
        +setRow(request,"Web","treating-physician",sTreatingPhysician,sWebLanguage)
        +setRow(request,"Web","civilstatus",sCivilStatus,sWebLanguage)
        +setRow(request,"Web","populationgroup",getTranNoLink("sis.populationgroup",sComment4,sWebLanguage),sWebLanguage)
        +setRow(request,"Web","ethnicgroup",getTranNoLink("sis.etnia",sComment5,sWebLanguage),sWebLanguage)
        +setRow(request,"Web","comment",sComment,sWebLanguage)
        +(MedwanQuery.getInstance().getConfigInt("enableVip",0)==1?setRow(request,"Web","vip",getTran(request,"vipstatus",sVip,sWebLanguage),sWebLanguage):"")
        +(MedwanQuery.getInstance().getConfigInt("enableDatacenterPatientExport",0)==1?setRow(request,"Web","datacenterpatientexport",getTran(request,"datacenterpatientexport",sExport,sWebLanguage),sWebLanguage):"")
        +(MedwanQuery.getInstance().getConfigInt("enableDatacenterPatientExport",0)==1?setRow(request,"Web","lastdatacenterpatientexport",activePatient.getLastSentExportRequest(),sWebLanguage):"")
        +(activePatient.isDead()!=null?setRow(request,"Web","deathcertificateon",sDeathCertificateOn,sWebLanguage)+setRow(request,"Web","deathcertificateto",sDeathCertificateTo,sWebLanguage):"")
        )
    %>
    <tr height='1'><td width='<%=sTDAdminWidth%>'/></tr>
</table>
<%
    String sShowButton = checkString(request.getParameter("ShowButton"));
    if (!sShowButton.equals("false")){
%>
<%-- BUTTONS -------------------------------------------------------------------------------------%>
<%=ScreenHelper.alignButtonsStart()%>
    <%
        if (activeUser.getAccessRight("patient.administration.edit")){
        %>
            <input type="button" class="button" onclick="window.location.href='<c:url value="/patientedit.do"/>?Tab=Admin&ts=<%=getTs()%>'" value="<%=getTran(null,"Web","edit",sWebLanguage)%>"/>
        <%
        }
    %>
<%=ScreenHelper.alignButtonsStop()%>
<%
    }
%>