<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=sJSSORTTABLE%>

<%
    if(activePatient!=null && activePatient.personid.length()>0){
        AdminFamilyRelation afr;

        if(activePatient.familyRelations.size() > 0){
            %>
                <table width="100%" id="searchresults" cellspacing="0" class="sortable" style="border-top:none;">
                    <%-- HEADER --%>
                    <tr class="admin">
                        <td width="5" nowrap></td>
                        <td width="20%"><%=getTran(request,"web.admin","sourceperson",sWebLanguage)%></td>
                        <td width="20%"><%=getTran(request,"web.admin","destinationperson",sWebLanguage)%></td>
                        <td width="60%"><%=getTran(request,"web.admin","relationtype",sWebLanguage)%></td>
                    </tr>

                    <%
                        String sClass = "1";
                        String showDossierTran = getTran(request,"web","showDossier",sWebLanguage);
                        for(int i=0; i<activePatient.familyRelations.size(); i++){
                            afr = (AdminFamilyRelation)activePatient.familyRelations.get(i);

                            if(afr!=null){
                                // alternate row-style
                                if(sClass.equals("1")) sClass = "";
                                else                   sClass = "1";

                                %>
                                <%-- source id --%>
                                <%
                                String sSourceFullName      = ScreenHelper.getFullPersonName(afr.sourceId+""),
                                          sDestinationFullName = ScreenHelper.getFullPersonName(afr.destinationId+""),
                                          sRelationType        = getTran(request,"admin.familyrelation",afr.relationType,sWebLanguage);
								if(activePatient.personid.equalsIgnoreCase(afr.sourceId)){
           		                %>
                   		            <tr class="list<%=sClass%>">
	                       	        <td>&nbsp;</td>
                                       <td>&nbsp;<%=sSourceFullName%></td>
                                       <td title="<%=showDossierTran%>">&nbsp;<a href="javascript:showDossier('<%=afr.destinationId%>');"><%=sDestinationFullName%></a></td>
                                       <td>&nbsp;<%=sRelationType%></td>
                                      </tr>
                                <%
								}
								else {
                                %>
                                    <tr class="list<%=sClass%>">
                                        <td>&nbsp;</td>
                                        <td>&nbsp;<%=sDestinationFullName%></td>
                                        <td title="<%=showDossierTran%>">&nbsp;<a href="javascript:showDossier('<%=afr.sourceId%>');"><%=sSourceFullName%></a></td>
                                        <td>&nbsp;<%=sRelationType%></td>
                                    </tr>
	                            <%
								}
                            }
                        }
                    %>
                </table>
            <%
        }
        else{
            // no records found
            %><div><%=getTran(request,"web","nofamilyrelationsfound",sWebLanguage)%></div><%
        }
    }
%>

<script>
  <%-- SHOW DOSSIER --%>
  function showDossier(personid){
    document.location.href = "<%=sCONTEXTPATH%>/main.do?Page=curative/index.jsp&PersonID="+personid+"&ts=<%=getTs()%>";
  }
</script>

<%-- BUTTONS -------------------------------------------------------------------------------------%>
<%
    String sShowButton = checkString(request.getParameter("ShowButton"));
    if(!sShowButton.equals("false")){
        %>
            <%=ScreenHelper.alignButtonsStart()%>
                <%
                    if(activeUser.getAccessRight("patient.administration.edit")){
                        %><input type="button" class="button" onclick="window.location.href='<c:url value="/patientedit.do"/>?Tab=AdminFamilyRelation&ts=<%=getTs()%>'" value="<%=getTranNoLink("Web","edit",sWebLanguage)%>"><%
                    }
                %>
            <%=ScreenHelper.alignButtonsStop()%>
        <%
    }
%>