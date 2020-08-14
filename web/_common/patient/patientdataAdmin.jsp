<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
    String sGender = "&nbsp;", sComment = "&nbsp;", sNativeCountry = "&nbsp;", sLanguage = "&nbsp;", sNatreg = "&nbsp;", sVip="0", sNativeTown=""
            , sCivilStatus = "&nbsp;", sTracnetID = "&nbsp;", sTreatingPhysician = "&nbsp;", sComment3="", sDeathCertificateTo="", sDeathCertificateOn="", sExport="0", sLastExport="0";

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

    // comment3
    if ((activePatient.comment3!=null)&&(activePatient.comment3.trim().length()>0)) {
        sComment3 = (activePatient.comment3);
    }

    // nativeCountry
    if ((activePatient.nativeCountry!=null)&&(activePatient.nativeCountry.trim().length()>0)) {
        sNativeCountry = getTran(request,"Country",activePatient.nativeCountry,sWebLanguage);
    }

    // nativeCountry
    if ((activePatient.nativeTown!=null)&&(activePatient.nativeTown.trim().length()>0)) {
        sNativeTown = getTran(request,"NativeTown",activePatient.nativeTown,sWebLanguage);
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
<table width='100%' cellspacing="1" class="list" style="border-top:none;">
    <%=(
        (
            MedwanQuery.getInstance().getConfigInt("showAdminLanguage",1)==0?"":
            setRow(request,"Web","Language",sLanguage,sWebLanguage)
        )
        +(
            MedwanQuery.getInstance().getConfigInt("showAdminGender",1)==0?"":
            setRow(request,"Web","Gender",sGender,sWebLanguage)
        )
        +(
            MedwanQuery.getInstance().getConfigInt("showAdminNatReg",1)==0?"":
            setRow(request,"Web","natreg",sNatreg,sWebLanguage)
        )
        +(
                MedwanQuery.getInstance().getConfigInt("showAdminTracnetID",1)==0?"":
                setRow(request,"Web","tracnetid",sTracnetID,sWebLanguage)
            )
        +(
                MedwanQuery.getInstance().getConfigInt("showAdminNativeCountry",1)==0?"":
                setRow(request,"Web","NativeCountry",sNativeCountry,sWebLanguage)
            )
        +(
                MedwanQuery.getInstance().getConfigInt("showAdminNativeTown",1)==0?"":
                setRow(request,"Web","NativeTown",sNativeTown,sWebLanguage)
            )
        +(
            MedwanQuery.getInstance().getConfigInt("showAdminComment1",1)==0?"":
            setRow(request,"Web","treating-physician",sTreatingPhysician,sWebLanguage)
        )
        +(
            MedwanQuery.getInstance().getConfigInt("showAdminComment2",1)==0?"":
            setRow(request,"Web","civilstatus",sCivilStatus,sWebLanguage)
        )
        +(
                MedwanQuery.getInstance().getConfigInt("showAdminComment3",1)==0?"":
                setRow(request,"Web","comment3",sComment3,sWebLanguage)
            )
        +(
                MedwanQuery.getInstance().getConfigInt("showAdminComment4",1)==0?"":
                setRow(request,"Web","comment4",activePatient.getReceiverPersonIdsToHtmlTable(sWebLanguage),sWebLanguage)
            )
        +(
            MedwanQuery.getInstance().getConfigInt("showAdminComment",1)==0?"":
            setRow(request,"Web","comment",sComment,sWebLanguage)
        )
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
            <input type="button" class="button" onclick="window.location.href='<c:url value="/patientedit.do"/>?Tab=Admin&ts=<%=getTs()%>'" value="<%=getTranNoLink("Web","edit",sWebLanguage)%>"/>
        <%
        }
    %>
<%=ScreenHelper.alignButtonsStop()%>
<%
    }
%>