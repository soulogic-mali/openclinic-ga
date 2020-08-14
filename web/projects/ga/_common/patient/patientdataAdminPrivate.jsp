<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
    if(activePatient!=null && activePatient.personid.length()>0){
        AdminPrivateContact apc = ScreenHelper.getActivePrivate(activePatient);
        String sCountry = "&nbsp;";
        if (checkString(apc.country).trim().length()>0) {
            sCountry = getTran(request,"Country",apc.country,sWebLanguage);
        }

        String sProvince = "&nbsp;";
        if (checkString(apc.province).trim().length()>0) {
            sProvince = getTran(request,"province",apc.province,sWebLanguage);
        }

        if (apc!=null){
            %>
                <table width="100%" cellspacing="1" class="list">
                    <%=		setRow("Web.admin","addresschangesince",apc.begin,sWebLanguage)+
        		            setRow(request,"Web","country",sCountry,sWebLanguage)+
        		            setRow(request,"Web","province",apc.district,sWebLanguage)+
        		            setRow(request,"Web","searchdistrict",apc.sector,sWebLanguage)+
        		            setRow(request,"Web","zipcode",apc.zipcode,sWebLanguage)+
        		            setRow(request,"Web","city",apc.city,sWebLanguage)+
        		            setRow(request,"Web","address",apc.address,sWebLanguage)+
        		            setRow(request,"Web","email",apc.email,sWebLanguage)+
        		            setRow(request,"Web","telephone",apc.telephone,sWebLanguage)+
        		            setRow(request,"Web","mobile",apc.mobile,sWebLanguage)+
        		            setRow(request,"Web","function",apc.businessfunction,sWebLanguage)+
        		            setRow(request,"Web","business",apc.business,sWebLanguage)+
        		            setRow(request,"Web","comment",apc.comment,sWebLanguage)
					%>
                    <tr height='1'><td width='<%=sTDAdminWidth%>'/></tr>
                </table>
            <%
        }
    }
%>
<%-- BUTTONS -------------------------------------------------------------------------------------%>
<%
    String sShowButton = checkString(request.getParameter("ShowButton"));
    if(!sShowButton.equals("false")){
        %>
            <%=ScreenHelper.alignButtonsStart()%>
                <input type="button" class="button" value="<%=getTran(null,"Web","history",sWebLanguage)%>" name="ButtonHistoryPrivate" onclick="parent.location='patienthistory.do?ts=<%=getTs()%>&contacttype=private'">&nbsp;
                <%
                    if (activeUser.getAccessRight("patient.administration.edit")){
                        %>
                            <input type="button" class="button" onclick="window.location.href='<c:url value="/patientedit.do"/>?Tab=AdminPrivate&ts=<%=getTs()%>'" value="<%=getTran(null,"Web","edit",sWebLanguage)%>">
                        <%
                    }
                %>
            <%=ScreenHelper.alignButtonsStop()%>
        <%
    }
%>