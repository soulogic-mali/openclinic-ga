<%@page import="org.dom4j.DocumentException,
                java.util.*,
                be.openclinic.adt.Encounter,
                java.util.Date"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=sJSSORTTABLE%>
<%
    session.removeAttribute("activePatient");
    ScreenHelper.getSQLDate("");
    
    String simmatnew        = checkString(request.getParameter("findimmatnew")).toUpperCase(),
           sArchiveFileCode = checkString(request.getParameter("findArchiveFileCode")).toUpperCase(),
           sPersonID        = checkString(request.getParameter("findPersonID")).toUpperCase(),
           snatreg          = checkString(request.getParameter("findnatreg")),
           sName            = checkString(request.getParameter("findName")).toUpperCase(),
           sFirstname       = checkString(request.getParameter("findFirstname")).toUpperCase(),
           sDateOfBirth     = checkString(request.getParameter("findDateOfBirth")),
           sDistrict        = checkString(request.getParameter("findDistrict")),
           sSector        	= checkString(request.getParameter("findSector")),
           sUnit            = checkString(request.getParameter("findUnit"));

    String sAction  = checkString(request.getParameter("Action")),
           sRSIndex = checkString(request.getParameter("RSIndex"));

    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n************************ _common/patientslist.jsp *********************");
        Debug.println("sAction      : "+sAction);
        Debug.println("sRSIndex     : "+sRSIndex);
        Debug.println("simmatnew    : "+simmatnew);
        Debug.println("sArchiveFileCode : "+sArchiveFileCode);
        Debug.println("sPersonID    : "+sPersonID);
        Debug.println("snatreg      : "+snatreg);
        Debug.println("sName        : "+sName);
        Debug.println("sFirstname   : "+sFirstname);
        Debug.println("sDateOfBirth : "+sDateOfBirth);
        Debug.println("sDistrict    : "+sDistrict);
        Debug.println("sSector      : "+sSector);
        Debug.println("sUnit        : "+sUnit+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////

    List lResults = null;
    int iMaxResultSet = 100, iCounter = 0, iOverallCounter = 0;

    if(checkString(request.getParameter("ListAction")).length() > 0){
        lResults = (List)session.getAttribute("searchResultsList");
    }
    
    if(lResults==null && activeUser!=null){
        if(sAction.equals("MY_HOSPITALIZED")){
            lResults = AdminPerson.getUserHospitalized(activeUser.userid);
        } 
        else if(sAction.equals("MY_VISITS")){
            lResults = AdminPerson.getUserVisits(activeUser.userid);
        } 
        else if(sUnit.length() > 0){
        	//sDateOfBirth = ScreenHelper.convertToEUDate(sDateOfBirth); // to match with EU-date in database
            lResults = AdminPerson.getPatientsInEncounterServiceUID(simmatnew,sArchiveFileCode,snatreg,sName,sFirstname,sDateOfBirth,sUnit,sPersonID,sDistrict,sSector);
        } 
        else{
            if((simmatnew+sArchiveFileCode+snatreg+sName+sFirstname+sDateOfBirth+sPersonID+sDistrict+sSector).length()>0){
            	//sDateOfBirth = ScreenHelper.convertToEUDate(sDateOfBirth); // to match with EU-date in database
            	lResults = AdminPerson.getAllPatients(simmatnew,sArchiveFileCode,snatreg,sName,sFirstname,sDateOfBirth,sPersonID,sDistrict,iMaxResultSet,sSector);
            }
            else {
            	lResults = new ArrayList();
            }
        }
        session.setAttribute("searchResultsList",lResults);
    }

    boolean bRS = false;

    if(lResults.size() > 0){
        StringBuffer sResult = new StringBuffer(); 
        String sLink = "", sClass = "", sPage;
        sPage = activeUser.getParameter("DefaultPage");

        // put a new SessionContainerWO in het session when a patient is searched,
        // otherwise 'Previousvalue' has the content of the previous patient.
        // Keep the user !
        SessionContainerWO sessionContainerWO_old = (SessionContainerWO) session.getAttribute("be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER");
        session.setAttribute("be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER",null);
        SessionContainerWO sessionContainerWO_new = (SessionContainerWO) SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
        sessionContainerWO_new.setUserVO(sessionContainerWO_old.getUserVO());
        session.setAttribute("be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER",sessionContainerWO_new);

        SAXReader xmlReader = new SAXReader();
        String sDefaultPageXML = MedwanQuery.getInstance().getConfigString("templateSource")+"defaultPages.xml";
        Document document;

        Hashtable hDefaultPages = new Hashtable();
        boolean bXMLDocumentError = false;
        try{
            document = xmlReader.read(new URL(sDefaultPageXML));
            if(document!=null){
                Element root = document.getRootElement();
                if(root!=null){
                    Element ePage;
                    Iterator elements = root.elementIterator("defaultPage");
                    String sType, sPageLink;
                    while (elements.hasNext()){
                        ePage = (Element) elements.next();
                        sType = checkString(ePage.attributeValue("type")).toLowerCase();
                        sPageLink = checkString(ePage.elementText("page"));
                        hDefaultPages.put(sType,sPageLink);
                    }
                }
            }
        }
        catch(DocumentException e){
            Debug.println("XML-Document Exception in patientslist.jsp");
            bXMLDocumentError = true;
        }

        if(sPage==null || sPage.trim().length()==0 || bXMLDocumentError && (activeUser.getAccessRight("patient.administration.select"))){
            sPage = "patientdata.do?ts="+getTs()+"&personid=";
        }
        else {
            String sType = checkString((String) hDefaultPages.get(sPage.toLowerCase()));
            if(sType.length() > 0){
                if(sPage.equals("administration")){
                    sPage = "patientdata.do?ts="+getTs()+"&personid=";
                }
                else{
                    sPage = sType+"&ts="+getTs()+"&PersonID=";
                }
            }
            else{
                sPage = "";
            }
        }

        if(sRSIndex.length() > 0){
            iOverallCounter = Integer.parseInt(sRSIndex);
        }
        
        String sTmpServiceID, sInactive, sBed, sCity;
        AdminPerson tempPat;
        Encounter enc;
        boolean bShowCity=(MedwanQuery.getInstance().getConfigInt("showCityInPatientsList",0)==1);

        while((iOverallCounter+iCounter) < lResults.size() && iCounter < iMaxResultSet){
            tempPat = (AdminPerson) lResults.get(iCounter+iOverallCounter);
            sTmpServiceID = "";
            sBed="";

            enc = Encounter.getActiveEncounter(tempPat.personid);
            if(enc!=null){
                sInactive = "";
                sTmpServiceID = enc.getServiceUID();
                if(enc.getBed()!=null){
                	sBed = checkString(enc.getBed().getName());
                }
            }
            else {
                sInactive = "Text";
            }
            
            if("On".equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("showServiceInPatientList"))){
                if(sTmpServiceID.trim().length() > 0){
                	String img="";
                	if(MedwanQuery.getInstance().getConfigInt("checkPatientListInvoices",0)==1 && enc.hasInvoices()){
                		img+="<img src='"+sCONTEXTPATH+"/_img/icons/icon_money.gif'/>";
                	}
                	if(MedwanQuery.getInstance().getConfigInt("checkPatientListTransactions",0)==1 && enc.hasTransactions()){
                		img+="<img src='"+sCONTEXTPATH+"/_img/icons/icon_admin.gif'/>";
                	}
                	
                    String sHospDate = "<td>"+ScreenHelper.stdDateFormat.format(enc.getBegin())+" "+img+"</td>";
                    long duration = (new Date().getTime() - enc.getBegin().getTime());
                    long days = 24 * 3600 * 1000;
                    days = days * 90;
                    if(enc.getEnd()!=null){
	                    String manager= (!(enc==null) && enc.getManagerUID()!=null && enc.getManagerUID().length()>0? User.getFullUserName(enc.getManagerUID()):"");
	                    sTmpServiceID = "<td style='text-decoration: line-through'>"+sTmpServiceID+" "+getTran(request,"Service",sTmpServiceID,sWebLanguage)+"</td><td style='text-decoration: line-through'>"+manager+"</td><td style='text-decoration: line-through'>"+sBed+"</td><td style='text-decoration: line-through'>"+ScreenHelper.stdDateFormat.format(enc.getBegin())+" "+img+"</td>";
                    }
                    else{
	                    if(duration > days || duration < 0){
	                        sHospDate = "<td style='color: red'>"+ScreenHelper.formatDate(enc.getBegin())+" "+img+ "</td>";
	                    }
                    
	                    String manager= (!(enc==null) && enc.getManagerUID()!=null && enc.getManagerUID().length()>0? User.getFullUserName(enc.getManagerUID()):"");
	                    sTmpServiceID = "<td>"+sTmpServiceID+" "+getTran(request,"Service",sTmpServiceID,sWebLanguage)+"</td><td>"+manager+"</td><td>"+sBed+"</td>"+sHospDate;
                    }
                }
                else {
                    sTmpServiceID = "<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>";
                }
            }

            // alternate row-style
            if(sClass.equals("")) sClass = "1";
            else                  sClass = "";
            
            if(sPage.trim().length() > 0){
                sLink = sPage+checkString(tempPat.personid);
                sResult.append("<tr onClick='window.location.href=\""+sLink+"\";'");
            }
            else{
                sLink = "";
                sResult.append("<tr");
            }
            
            String sImmatNew = "";
            String sNatReg = "";
            Iterator iter = tempPat.ids.iterator();
            AdminID tempAdminID;

            while(iter.hasNext()){
                tempAdminID = (AdminID)iter.next();
                
                if(tempAdminID.type.equals("ImmatNew")){
                    sImmatNew = tempAdminID.value;
                } 
                else if(tempAdminID.type.equals("NatReg")){
                    sNatReg = tempAdminID.value;
                }
            }
            sCity="";
            if(bShowCity){
            	String[] privateDetails= new String[5];
            	AdminPrivateContact.getPrivateDetails(tempPat.personid, privateDetails);
            	sCity="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;("+checkString(privateDetails[4])+")";
            }
            sResult.append(" class=list"+sInactive+sClass+" >"
                   +"<td><img src='"+sCONTEXTPATH+"/_img/icons/icon_view.png' alt='"+getTranNoLink("Web","view",sWebLanguage)+"'></td>"
                   +"<td>"+checkString(sImmatNew)+"</td>"
                   +"<td>"+checkString(sNatReg)+"</td>"
                   +"<td><b>"+checkString(tempPat.lastname)+"  "+checkString(tempPat.firstname)+"</b>"+sCity+"</td>"
                   +"<td>"+checkString(tempPat.gender.toUpperCase())+"</td>"
                   +"<td>"+tempPat.dateOfBirth+"</td>"
                   +""+sTmpServiceID
                   +"</tr>");

            iCounter++;
        }

        String sNext = "", sPrevious = "&nbsp;";
        if(iOverallCounter > 0){
            sPrevious = "<A href='#' class='previousButton' title='"+getTranNoLink("Web","Previous",sWebLanguage)
                   +"' OnClick=\"SF.RSIndex.value='"+(iOverallCounter - iCounter - (iMaxResultSet - iCounter))+"';SF.ListAction.value='Previous';SF.submit();\">"
                   +"&nbsp;</a>";
        }
        if(lResults.size() > iOverallCounter+iCounter){
            sNext = "<a href='#' title='"+getTranNoLink("Web","Next",sWebLanguage)+"' OnClick=\"SF.RSIndex.value='"
                   +(iOverallCounter+iCounter)+"';SF.ListAction.value='Next';SF.submit();\"><img src='"+sCONTEXTPATH+"/_img/themes/default/arrow-right.gif' border='0'></a>";
        }
        
        if(iCounter==0){
            // display 'no results' message
            %><tr><td><%=getTran(request,"web","nopatientsfound",sWebLanguage)%></td></tr><%
        }
        else if(iOverallCounter+iCounter==1 && !bRS && sLink.length()>0){
            %><script>window.location.href = "<c:url value=''/><%=sLink%>";</script><%
        }
        else{
            %>
				<table width="100%" cellspacing="0" class="sortable" id="searchresults">
				    <%-- header --%>
				    <tr height="20" class="admin">
				        <td><%=sPrevious%></td>
				        <td><%=getTran(request,"Web","immatnew",sWebLanguage)%></td>
				        <td><%=getTran(request,"Web","natreg.short",sWebLanguage)%></td>
				        <td><%=getTran(request,"Web","name",sWebLanguage)%></td>
				        <td><%=getTran(request,"Web","gender",sWebLanguage)%>&nbsp;</td>
				        <td><%=getTran(request,"Web","dateofbirth",sWebLanguage)%></td>
				        <%
				            if("On".equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("showServiceInPatientList"))){
				                %>
				                    <td><%=getTran(request,"Web","service",sWebLanguage)%></td>
				                    <td><%=getTran(request,"Web","manager",sWebLanguage)%></td>
				                    <td><%=getTran(request,"Web","bed",sWebLanguage)%></td>
				                    <td><%=getTran(request,"Web","date",sWebLanguage)%></td>
				                <%
				            }
				
				            if(sNext.trim().length()>0){
				                %><td width="1%" align="right"><%=sNext%></td><%
				            }
				        %>
				    </tr>
				    <tbody class="hand"><%=sResult.toString()%></tbody>
				</table>

                <%-- previous, patient-count, next --%>
                <div style="text-align:right;padding:2px;">
                    <%                    
                        if(sPrevious.trim().length()>0){
                            %><div style="text-align:left;"><%=sPrevious%>&nbsp;&nbsp;</div><%
      		            }
                    %>
                    
                    <%=getTran(request,"web","totalpatients",sWebLanguage)+": "+lResults.size()%>
                
                    <%                    
                        if(sNext.trim().length()>0){
                            %>&nbsp;&nbsp;<a class="topButton" href="#topp">&nbsp;</a><%=sNext%><%
      		            }
                    %>
                </div>
            <%
        }
    }
    else{
        %><b><%=getTran(request,"web","nopatientsfound",sWebLanguage)%></b><%
        	
        // if admin : create dossier and go to agenda
        if((sName.length()>0 || sFirstname.length() > 0 || sDateOfBirth.length()>0 || simmatnew.length()>0) && 
        	activeUser.getAccessRight("patient.administration.add")){
	        %>
	            <br><br>
	            <img src="<%=sCONTEXTPATH%>/_img/themes/default/pijl.gif"/>&nbsp;<a href="<c:url value='/patientnew.do'/>?PatientNew=true&pLastname=<%=sName%>&pFirstname=<%=sFirstname%>&pImmatnew=<%=simmatnew%>&pNatreg=<%=snatreg%>&pDateofbirth=<%=sDateOfBirth%>&pDistrict=<%=sDistrict%>"><%=getTran(request,"web","new_patient",sWebLanguage)%></a><br>
	            <img src="<%=sCONTEXTPATH%>/_img/themes/default/pijl.gif"/>&nbsp;<a href="<c:url value='/_common/patient/patienteditSave.jsp'/>?Lastname=<%=sName%>&Firstname=<%=sFirstname%>&DateOfBirth=<%=sDateOfBirth%>&NatReg=<%=snatreg%>&ImmatNew=<%=simmatnew%>&PDistrict=<%=sDistrict%>&PBegin=<%=getDate()%>&NextPage=planning/findPlanning.jsp&SavePatientEditForm=ok"><%=getTran(request,"web","create_person_and_go_to_agenda",sWebLanguage)%></a>
	        <%
        }
        if( snatreg.length()>0 && activeUser.getAccessRight("patient.administration.add")){
	        %>
            <br><br>
            <img src="<%=sCONTEXTPATH%>/_img/themes/default/pijl.gif"/>&nbsp;<a href="javascript:loadFromSIS('<%=snatreg%>')"><%=getTran(request,"web","create_person_from_sis",sWebLanguage)%></a>
            &nbsp;<span id='sisloader'/>
        <%
        }
    }
%>
<script>
	function loadFromSIS(dni){
		document.getElementById('sisloader').innerHTML="<img height='10px' src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/>";
		var url = '<c:url value="/util/createPatientFromSIS.jsp"/>?dni='+dni+'&ts='+new Date().getTime();
		new Ajax.Request(url,{
		  	method: "POST",
		  	postBody: '',
		  	onSuccess: function(resp){
			    var s=eval('('+resp.responseText+')');
			    if(s.success==1){
			    	window.location.href='<%=sCONTEXTPATH%>/main.do?Page=curative/index.jsp&PersonID='+s.personid;
		    	}
			    else {
			    	document.getElementById('sisloader').innerHTML="&nbsp<h1><img src='<%=sCONTEXTPATH%>/_img/icons/icon_error.gif'/> "+s.error+"</h1>";
			    }
		  	},
		  	onFailure: function(){
		    	document.getElementById('sisloader').innerHTML="&nbsp<h1><img src='<%=sCONTEXTPATH%>/_img/icons/icon_error.gif'/> <%=getTranNoLink("web","error.searching.sis.database",sWebLanguage)%></h1>";
		  	}
		});
	}
</script>
