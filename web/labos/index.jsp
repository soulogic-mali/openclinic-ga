<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%=ScreenHelper.writeTblHeader(getTran(request,"web","labos",sWebLanguage),sCONTEXTPATH)%>
<%
    if(activePatient!=null){
    	//*** PATIENT ***
        out.print("<tr><td colspan='2' class='admin'>"+getTran(request,"web","patient",sWebLanguage)+"</td></tr>");
        if(activeUser.getAccessRight("labos.patientlaboresults.select")) out.print(writeTblChild("main.do?Page=labos/showLabRequestList.jsp",getTran(request,"Web","patientLaboResults",sWebLanguage)));
        if(activeUser.getAccessRight("labos.openpatientlaboresults.select")) out.print(writeTblChild("main.do?Page=labos/manageLaboResults.jsp&type=patient&open=true&Action=find",getTran(request,"Web","openPatientLaboResults",sWebLanguage)));
        out.print("<tr><td colspan='2'></td></tr>");
    }

    //*** USER ***
    out.print("<tr><td colspan='2' class='admin'>"+getTran(request,"web","user",sWebLanguage)+"</td></tr>");
    if(activeUser.getAccessRight("labos.userlaboresults.select")) out.print(writeTblChild("main.do?Page=labos/manageLaboUserResults.jsp&type=user&resultsOnly=true&Action=find",getTran(request,"Web","userLaboResults",sWebLanguage)));
    if(activeUser.getAccessRight("labos.openuserlaboresults.select"))out.print(writeTblChild("main.do?Page=labos/manageLaboUserOpenResults.jsp&type=user&open=true&Action=find",getTran(request,"Web","openUserLaboResults",sWebLanguage)));
    if(activeUser.getAccessRight("labos.servicelaboresults.select"))out.print(writeTblChild("main.do?Page=labos/manageLaboServiceResults.jsp&type=user&open=true&Action=find",getTran(request,"web","serviceLaboResults",sWebLanguage)));
    if(activeUser.getAccessRight("labos.requestswithoutsamples.select"))out.print(writeTblChild("main.do?Page=labos/manageUnsampledLabRequests.jsp&type=patient&open=true&Action=find",getTran(request,"web","unsampledRequests",sWebLanguage)));
    out.print("<tr><td colspan='2'></td></tr>");
    
    //*** LABO ***
    out.print("<tr><td colspan='2' class='admin'>"+getTran(request,"web","laboratory",sWebLanguage)+"</td></tr>");
    if(activeUser.getAccessRight("labos.samplereception.select"))out.print(writeTblChild("main.do?Page=labos/manageLabSampleReception.jsp&open=true&Action=find",getTran(request,"web","sampleReception",sWebLanguage)));
    if(activeUser.getAccessRight("labos.prepareworklists.select"))out.print(writeTblChild("main.do?Page=labos/prepareWorklists.jsp&open=true&Action=find",getTran(request,"web","prepareWorklists",sWebLanguage)));
    if(activeUser.getAccessRight("labos.worklists.select"))out.print(writeTblChild("main.do?Page=labos/manageWorklists.jsp&open=true&Action=find",getTran(request,"web","workLists",sWebLanguage)));
    if(activeUser.getAccessRight("labos.biologicvalidationbyworklist.select"))out.print(writeTblChild("main.do?Page=labos/manageWorklistFinalValidation.jsp&open=true&Action=find",getTran(request,"web","workListFinalValidation",sWebLanguage)));
    if(activeUser.getAccessRight("labos.biologicvalidationbyrequest.select"))out.print(writeTblChild("main.do?Page=labos/manageRequestFinalValidation.jsp&open=true&Action=find",getTran(request,"web","requestFinalValidation",sWebLanguage)));
    if(activeUser.getAccessRight("labos.printnewresults.select"))out.print(writeTblChild("main.do?Page=labos/manageLaboPrintResults.jsp&open=true&Action=find",getTran(request,"web","printnewlabresults",sWebLanguage)));
    if(activeUser.getAccessRight("labos.fastresults.select"))out.print(writeTblChild("main.do?Page=labos/manageLaboResultsEdit.jsp&type=patient&open=true&Action=find",getTran(request,"web","fastresultsedit",sWebLanguage)));
    out.print("<tr><td colspan='2'></td></tr>");
    
    //*** WHO ***
    out.print("<tr><td colspan='2' class='admin'>WHONet</td></tr>");
    out.print(writeTblChild("main.do?Page=system/exportToWHONet.jsp",getTran(request,"Web.Manage","exporttowhonet",sWebLanguage)));
%>
<%=ScreenHelper.writeTblFooter()%>

