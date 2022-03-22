<%@page import="java.util.Hashtable,
                java.util.Vector"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/_common/patient/patienteditHelper.jsp"%>

<%!
    //--- GET ENCLOSED FILE ID (immatnew of dossier) ----------------------------------------------
    public String getEnclosedFileId(String superFileId){
        return AdminPerson.getEnclosedFileId(superFileId);
    }
%>

<%
    String msgNames = "", msgImmatNew = "", msgNatReg = "";
    String link1Names = "", link2Names = "";
    String link1ImmatNew = "", link2ImmatNew = "";
    String link1NatReg = "", link2NatReg = "";
    String focusField = "";

    boolean doubleNamesFound = false;
    boolean doubleImmatNewFound = false;
    boolean doubleNatRegFound = false;

    if (activePatient != null) {
        // data to check on for doubles
        String sPersonID = checkString(request.getParameter("PersonID")).toUpperCase(),
               sName = checkString(request.getParameter("Lastname")).toUpperCase(),
               sFirstname = checkString(request.getParameter("Firstname")).toUpperCase(),
               sDateOfBirth = checkString(request.getParameter("DateOfBirth")),
               sImmatNew = checkString(request.getParameter("ImmatNew")).toUpperCase(),
               sNatReg = checkString(request.getParameter("NatReg")).toUpperCase();

        
        //--- CHECK ON DOUBLES --------------------------------------------------------------------
        //#####################################################################################
        //################################## CREATE ###########################################
        //#####################################################################################
        if (sPersonID == null || sPersonID.trim().length() == 0) {
            activePatient = new AdminPerson();
            activePatient.lastname = sName.toUpperCase();
            activePatient.firstname = sFirstname.toUpperCase();
            activePatient.dateOfBirth = sDateOfBirth;
            activePatient.updateuserid = activeUser.userid;
            session.setAttribute("activePatient",activePatient);

            //*** check double patients on IMMATNEW *******************************************
            if (sImmatNew.length() > 0) {
                String sPersonId = AdminPerson.getPersonIdByImmatnew(sImmatNew);

                if (sPersonId!=null) {
                    doubleImmatNewFound = true;
                    activePatient.checkImmatnew=false;

                    // double message
                    msgImmatNew = "<font color='red'>" +
                            getTran(request,"Web.PatientEdit", "patient.exists", sWebLanguage) + " " + getTran(request,"web", "immatnew", sWebLanguage) +
                            ". (" + sImmatNew + ")" +
                            "</font>" +
                            "<br><br>";

                    // click to open existing patient
                    link1ImmatNew = getTran(request,"Web.PatientEdit", "click", sWebLanguage) +
                            " <a href='javascript:showExistingPatient(" + sPersonId + ");'> " +
                            getTran(request,"Web.PatientEdit", "here", sWebLanguage) + "</a> " +
                            getTran(request,"Web.PatientEdit", "patient.open.fiche", sWebLanguage) + "<br><br>";

                    // click to open existing patient in new window
                    link1ImmatNew += getTran(request,"Web.PatientEdit", "click", sWebLanguage) +
                            " <a href='javascript:showExistingPatientInNewWindow(" + sPersonId + ");'> " +
                            getTran(request,"Web.PatientEdit", "here", sWebLanguage) + "</a> " +
                            getTran(request,"Web.PatientEdit", "patient.open.fiche.innewwindow", sWebLanguage) + "<br><br>";

                    // creation impossible
                    link2ImmatNew = getTran(request,"Web.PatientEdit", "patient.creation.impossible", sWebLanguage);
                }
            }

            //*** check double patients on NATREG *********************************************
            if (sNatReg.length() > 0 && MedwanQuery.getInstance().getConfigString("checkNatreg","1").equalsIgnoreCase("1")) {
                String sPersonId = AdminPerson.getPersonIdByNatReg(sNatReg);

                if (sPersonId!=null) {
                    doubleNatRegFound = true;
                    activePatient.checkNatreg=false;

                    // double message
                    msgNatReg = "<font color='red'>" +
                            getTran(request,"Web.PatientEdit", "patient.exists", sWebLanguage) + " " + getTran(request,"web", "natreg", sWebLanguage) + "." +
                            "<br>(" + sNatReg + ")" +
                            "</font>" +
                            "<br><br>";

                    // click to open existing patient
                    link1NatReg = getTran(request,"Web.PatientEdit", "click", sWebLanguage) +
                            " <a href='javascript:showExistingPatient(" + sPersonId + ");'> " +
                            getTran(request,"Web.PatientEdit", "here", sWebLanguage) + "</a> " +
                            getTran(request,"Web.PatientEdit", "patient.open.fiche", sWebLanguage) + "<br><br>";

                    // click to open existing patient in new window
                    link1NatReg += getTran(request,"Web.PatientEdit", "click", sWebLanguage) +
                            " <a href='javascript:showExistingPatientInNewWindow(" + sPersonId + ");'> " +
                            getTran(request,"Web.PatientEdit", "here", sWebLanguage) + "</a> " +
                            getTran(request,"Web.PatientEdit", "patient.open.fiche.innewwindow", sWebLanguage) + "<br><br>";

                    // click to create double patient
                    link2NatReg = getTran(request,"Web.PatientEdit", "click", sWebLanguage) +
                            " <a href='javascript:doSave();'> " +
                            getTran(request,"Web.PatientEdit", "here", sWebLanguage) + "</a> " +
                            getTran(request,"Web.PatientEdit", "patient.create.fiche", sWebLanguage);
                }
            }

            //*** check names and birthdate ***************************************************
            Hashtable hSelect = new Hashtable();

            if (sName.length() > 0) hSelect.put(" searchname = ? AND", sName + "," + sFirstname);
            if (sDateOfBirth.length() > 0) hSelect.put(" dateofbirth = ? AND", sDateOfBirth);

            // prepare query
            if (hSelect.size() > 0) {
                String sPersonId = AdminPerson.getPersonIdBySearchNameDateofBirth(hSelect);

                if (sPersonId!=null) {
                    doubleNamesFound = true;

                    // double melding
                    msgNames = "<font color='red'>" +
                            getTran(request,"Web.PatientEdit", "patient.exists.mv", sWebLanguage) + " " + getTran(request,"Web", "lastname", sWebLanguage) + ", " + getTran(request,"Web", "firstname", sWebLanguage) + ", " + getTran(request,"Web", "dateofbirth", sWebLanguage) + "." +
                            "<br>(" + sName + ", " + sFirstname + ", " + sDateOfBirth + ")" +
                            "</font>" +
                            "<br><br>";

                    // click to open existing patient
                    link1Names = getTran(request,"Web.PatientEdit", "click", sWebLanguage) +
                            " <a href='javascript:showExistingPatient(" + sPersonId + ");'> " +
                            getTran(request,"Web.PatientEdit", "here", sWebLanguage) + "</a> " +
                            getTran(request,"Web.PatientEdit", "patient.open.fiche", sWebLanguage) + "<br><br>";

                    // click to open existing patient in new window
                    link1Names += getTran(request,"Web.PatientEdit", "click", sWebLanguage) +
                            " <a href='javascript:showExistingPatientInNewWindow(" + sPersonId + ");'> " +
                            getTran(request,"Web.PatientEdit", "here", sWebLanguage) + "</a> " +
                            getTran(request,"Web.PatientEdit", "patient.open.fiche.innewwindow", sWebLanguage) + "<br><br>";

                    // click to create double patient
                    link2Names = getTran(request,"Web.PatientEdit", "click", sWebLanguage) +
                            " <a href='javascript:doSave();'> " +
                            getTran(request,"Web.PatientEdit", "here", sWebLanguage) + "</a> " +
                            getTran(request,"Web.PatientEdit", "patient.create.fiche", sWebLanguage);
                }
            }
        }
    }
        // [display double-message] OR save data
        if (doubleNamesFound || doubleImmatNewFound || doubleNatRegFound){
            %>
                <p style='padding:15px;'>
                    <%
                        int popupHeight = 0;
                        if(doubleImmatNewFound){
                            popupHeight = 130;
                            focusField = "ImmatNew";
                            %>
                                <%=msgImmatNew%>
                                <%=link1ImmatNew%>
                                <%=link2ImmatNew%>
                                <br>
                            <%
                        }
                        else{
                            if(doubleNamesFound){
                                popupHeight = 145;
                                focusField = "Lastname";
                                %>
                                    <%=msgNames%>
                                    <%=link1Names%>
                                    <%=link2Names%>
                                    <br>
                                <%
                            }

                            if(doubleNatRegFound){
                                if(popupHeight==0){
                                    popupHeight = 130;
                                }
                                else{
                                    popupHeight+= 50;
                                    %><br><%
                                }
                                focusField = "NatReg";
                                %>
                                    <%=msgNatReg%>
                                    <%=link1NatReg%>
                                    <%=link2NatReg%>
                                    <br>
                                <%
                            }
                        }
                    %>

                    <%-- CLOSE BUTTON --%>
                    <div align="center">
                        <input type="button" class="button" value="<%=getTranNoLink("web","close",sWebLanguage)%>" onClick="closeWindow();">
                    </div>
                </p>

                <script>
                  window.resizeTo(550,<%=popupHeight%>+50);

                  function showExistingPatient(personID){
                    window.opener.location.href = "<c:url value='/patientdata.do'/>?personid="+personID+"&ts=<%=getTs()%>";
                    window.close();
                  }

                  function showExistingPatientInNewWindow(personID){
                    window.open("<c:url value='/patientdata.do'/>?personid="+personID+"&ts=<%=getTs()%>","details","toolbar=yes, status=yes, scrollbars=yes, resizable=yes, menubar=yes, width=850, height=650");
                    window.close();
                  }

                  function doSave(){
                  	window.opener.document.getElementById('noimmatcheck').value='1';
                	window.opener.document.getElementById('nonatregcheck').value='1';
                    window.opener.doSubmit();
                    window.close();
                  }

                  function closeWindow(){
                    window.opener.activateTab("Admin");
                    window.opener.PatientEditForm.<%=focusField%>.focus();
                    window.close();
                  }
                </script>
            <%
        }
        // display double-message OR [save data]
        else {
            out.print("<script>window.opener.doSubmit();window.close();</script>");
            out.flush();
        }
    %>
