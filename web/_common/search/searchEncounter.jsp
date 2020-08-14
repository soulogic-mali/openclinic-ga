<%@page import="be.openclinic.adt.Bed,
                be.openclinic.adt.Encounter,
                java.util.Vector"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=sJSSORTTABLE%>

<%
    String sFindEncounterPatient = checkString(request.getParameter("FindEncounterPatient")),
           sFindEncounterManager = checkString(request.getParameter("FindEncounterManager")),
           sFindEncounterService = checkString(request.getParameter("FindEncounterService")),
           sFindEncounterBed     = checkString(request.getParameter("FindEncounterBed"));

    String sVarCode     = checkString(request.getParameter("VarCode")),
           sVarText     = checkString(request.getParameter("VarText")),
           sVarFunction = checkString(request.getParameter("VarFunction"));
    
    if(sVarCode.length()==0){
    	sVarCode = checkString(request.getParameter("Varcode"));
    }

    String sSelectEncounterPatient = ScreenHelper.normalizeSpecialCharacters(sFindEncounterPatient),
           sSelectEncounterManager = ScreenHelper.normalizeSpecialCharacters(sFindEncounterManager),
           sSelectEncounterService = ScreenHelper.normalizeSpecialCharacters(sFindEncounterService),
           sSelectEncounterBed     = ScreenHelper.normalizeSpecialCharacters(sFindEncounterBed);
    
    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
    	Debug.println("\n******************* _common/search/searchEncounter.jsp *****************");
    	Debug.println("sFindEncounterPatient   : "+sFindEncounterPatient);
    	Debug.println("sFindEncounterManager   : "+sFindEncounterManager);
    	Debug.println("sFindEncounterService   : "+sFindEncounterService);
    	Debug.println("sFindEncounterBed       : "+sFindEncounterBed);
    	Debug.println("sVarCode                : "+sVarCode);
    	Debug.println("sVarText                : "+sVarText);
    	Debug.println("sVarFunction            : "+sVarFunction);
    	Debug.println("sSelectEncounterPatient : "+sSelectEncounterPatient);
    	Debug.println("sSelectEncounterManager : "+sSelectEncounterManager);
    	Debug.println("sSelectEncounterService : "+sSelectEncounterService);
    	Debug.println("sSelectEncounterBed     : "+sSelectEncounterBed+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////
%>
<script>
  <%-- SET ENCOUNTER --%>
  function setEncounter(sEncounterUID,sEncounterName){
	if(window.opener.document.getElementsByName("<%=sVarCode%>")[0]){
	    window.opener.document.getElementsByName("<%=sVarCode%>")[0].value = sEncounterUID;
	    if(window.opener.document.getElementsByName("<%=sVarCode%>")[0].onchange){
	    	window.opener.document.getElementsByName("<%=sVarCode%>")[0].onchange();
	    }
  	}
    else if(window.opener.document.getElementById("<%=sVarCode%>")){
    	window.opener.document.getElementById("<%=sVarCode%>").value= sEncounterUID;
	    if(window.opener.document.getElementById("<%=sVarCode%>").onchange){
	    	window.opener.document.getElementById("<%=sVarCode%>").onchange();
	    }
    }

    if("<%=sVarText%>"!=""){
    	if(window.opener.document.getElementsByName("<%=sVarText%>")[0]){
      		window.opener.document.getElementsByName("<%=sVarText%>")[0].value = sEncounterName;
    	}
    }

    <%
        if(sVarFunction.length() > 0){
            %>window.opener.<%=sVarFunction%>;<%
        }
    %>

    window.close();
  }
</script>

<form name="SearchForm" method="POST" onSubmit="doFind();" onkeydown="if(enterEvent(event,13)){doFind();}">
    <%=writeTableHeader("financial","searchEncounter",sWebLanguage," window.close()")%>
        
    <%-- SEARCH RESULTS TABLE --%>
    <table class="sortable" id="searchresults" width="100%" cellpadding="1" cellspacing="0" style="padding-top:2px;">
        <%
            String sortColumn = "A.OC_ENCOUNTER_BEGINDATE DESC";
            Vector vEncounters = Encounter.selectLastEncounters("","","","","",sSelectEncounterManager,sSelectEncounterService,
            		                                            sSelectEncounterBed,sSelectEncounterPatient,sortColumn);
            Iterator iter = vEncounters.iterator();

            Encounter eTmp;
            boolean recsFound = false;
            StringBuffer results = new StringBuffer();
            
            String sClass = "";
            String sType = "";
            String sEnd = "";
            String sStart = "";
            String sTRClass = "";
            String sTRSelectClass = "";
            String sEncounterUID = "";
            String sService = "";

            while(iter.hasNext()){
                eTmp = (Encounter)iter.next();
                recsFound = true;

                // alternate row-style
                if(sClass.equals("")) sClass = "1";
                else                  sClass = "";

                // names
                sEncounterUID = eTmp.getUid();
                Encounter e = Encounter.get(sEncounterUID);
                if(e.getEnd()==null){
                    eTmp.setEnd(null);
                }

                if(eTmp.getType().length() > 0){
                    sType = getTran(request,"encountertype",eTmp.getType(),sWebLanguage);
                }

                if(eTmp.getServiceUID().length() > 0){
                    sService = getTran(request,"service",eTmp.getServiceUID(),sWebLanguage);
                }

                sStart = ScreenHelper.formatDate(eTmp.getBegin());

                if(eTmp.getEnd()!=null){
                	sEnd = ScreenHelper.formatDate(eTmp.getEnd());
                }
                else{
                    sEnd = "";
                }

                if(sEnd.length() > 0){
                    sTRClass = "listText"+sClass;
                    sTRSelectClass = "";
                }
                else{
                    sTRClass = "listbold"+sClass;
                    sTRSelectClass = "bold";
                }
                    
                results.append("<tr class='"+sTRClass+"' onmouseover=\"this.style.cursor='hand';\" onmouseout=\"this.style.cursor='default';\" onclick=\"setEncounter('"+sEncounterUID+"', '"+sService+", "+sStart+" -> "+sEnd+", "+sType+"');\">")
                        .append("<td>"+sEncounterUID+"</td>")
                        .append("<td>"+sStart+"</td>")
                        .append("<td>"+sEnd+"</td>")
                        .append("<td>"+sService+"</td>")
                        .append("<td>"+sType+"</td>")
                       .append("</tr>");
            }

            if(recsFound){
                %>
                    <%-- header --%>
                    <tr class="gray">
                        <td width="50">ID</td>
                        <td width="80" nowrap><%=getTran(request,"Web","start",sWebLanguage)%></td>
                        <td width="80" nowrap><%=getTran(request,"Web","end",sWebLanguage)%></td>
                        <td width="280"><%=getTran(request,"Web","service",sWebLanguage)%></td>
                        <td width="100" nowrap><%=getTran(request,"Web.encounter","type",sWebLanguage)%></td>
                    </tr>

                    <%=results%>
                <%
            }
            else{
                // display 'no results' message
                %>
                    <tr>
                        <td><%=getTran(request,"web","norecordsfound",sWebLanguage)%></td>
                    </tr>
                <%
            }
        %>
    </table>
    <br>

    <%-- BUTTONS --%>
    <center>
        <input type="button" class="button" name="buttonClose" value="<%=getTranNoLink("Web","Close",sWebLanguage)%>" onclick="window.close();">
    </center>
</form>

<script>window.resizeTo(550,455);</script>