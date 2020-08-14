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
                    <%=		
                        setRow("Web.admin","addresschangesince",apc.begin,sWebLanguage)+
                        (
                            MedwanQuery.getInstance().getConfigInt("showAdminPrivateCountry",1)==0?"":
                            setRow(request,"Web","country",sCountry,sWebLanguage)
                        )
                       +(
                            MedwanQuery.getInstance().getConfigInt("showAdminPrivateDistrict",1)==0?"":
                            setRow(request,"Web","region",apc.district,sWebLanguage)
                        )
                       +(
                            MedwanQuery.getInstance().getConfigInt("showAdminPrivateSector",1)==0?"":
                            setRow(request,"Web","district",apc.sector,sWebLanguage)
                        )
                       +(
                            MedwanQuery.getInstance().getConfigInt("showAdminPrivateZipcode",1)==0?"":
                            setRow(request,"Web","zipcode",apc.zipcode,sWebLanguage)
                        )
                       +(
                            MedwanQuery.getInstance().getConfigInt("showAdminPrivateProvince",1)==0?"":
                            setRow(request,"Web","province",sProvince,sWebLanguage)
                        )
                       +(
                            MedwanQuery.getInstance().getConfigInt("showAdminPrivateCity",1)==0?"":
                            setRow(request,"Web","city",apc.city,sWebLanguage)
                        )
                       +(
                            MedwanQuery.getInstance().getConfigInt("showAdminPrivateCell",1)==0?"":
                            setRow(request,"Web","cell",apc.cell,sWebLanguage)
                        )
                       +(
                            MedwanQuery.getInstance().getConfigInt("showAdminPrivateAddress",1)==0?"":
                            setRow(request,"Web","address",apc.address,sWebLanguage)
                        )
                       +(
                            MedwanQuery.getInstance().getConfigInt("showAdminPrivateEmail",1)==0?"":
                            setRow(request,"Web","email",apc.email,sWebLanguage)
                        )
                       +(
                            MedwanQuery.getInstance().getConfigInt("showAdminPrivateTelephone",1)==0?"":
                            setRow(request,"Web","telephone",apc.telephone,sWebLanguage)
                        )
                       +(
                            MedwanQuery.getInstance().getConfigInt("showAdminPrivateMobile",1)==0?"":
                            setRow(request,"Web","mobile",apc.mobile,sWebLanguage)
                        )
                       +(
                            MedwanQuery.getInstance().getConfigInt("showAdminPrivateFunction",1)==0?"":
                            setRow(request,"Web","function",apc.businessfunction,sWebLanguage)
                        )
                       +(
                            MedwanQuery.getInstance().getConfigInt("showAdminPrivateBusiness",1)==0?"":
                            setRow(request,"Web","business",apc.business,sWebLanguage)
                        )
                       +(
                            MedwanQuery.getInstance().getConfigInt("showAdminPrivateComment",1)==0?"":
                            setRow(request,"Web","comment",apc.comment,sWebLanguage)
                        )
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