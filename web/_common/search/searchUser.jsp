<%@page import="org.dom4j.DocumentException,
                java.util.Vector"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=sJSSORTTABLE%>

<%
    String sFindLastname   = checkString(request.getParameter("FindLastname")),
           sFindFirstname  = checkString(request.getParameter("FindFirstname")),
           sReturnPersonID = checkString(request.getParameter("ReturnPersonID")),
           sReturnUserID   = checkString(request.getParameter("ReturnUserID")),
           sReturnName     = checkString(request.getParameter("ReturnName")),
           sSetGreenField  = checkString(request.getParameter("SetGreenField"));
	String sFunctionToPerformWithId = checkString(request.getParameter("FunctionToPerformWithId"));

    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
    	Debug.println("\n********************* _common/search/searchUser.jsp *******************");
    	Debug.println("sFindLastname   : "+sFindLastname);
    	Debug.println("sFindFirstname  : "+sFindFirstname);
    	Debug.println("sReturnPersonID : "+sReturnPersonID);
    	Debug.println("sReturnUserID   : "+sReturnUserID);
    	Debug.println("sReturnName     : "+sReturnName);
    	Debug.println("sSetGreenField  : "+sSetGreenField+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////

%>
<form name="SearchForm" method="POST" onkeydown="if(enterEvent(event,13)){doFind();};">
    <%=writeTableHeader("web","searchUser",sWebLanguage," window.close()")%>
    
    <table width="100%" cellspacing="0" cellpadding="0" class="menu">
        <tr height="25">
            <%-- lastname --%>
            <td class="admin2"><%=getTran(request,"Web","lastname",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" name="FindLastname" id="FindLastname" size="28" maxLength="255" value="<%=sFindLastname%>" >
            </td>
            
            <%-- firstname --%>
            <td class="admin2"><%=getTran(request,"Web","firstname",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" name="FindFirstname" id="FindFirstname" size="28" maxLength="255" value="<%=sFindFirstname%>">
            </td>
            
            <%-- BUTTONS --%>
            <td class="admin2" style="text-align:right;">
                <input class="button" type="button" name="searchButton" value="<%=getTranNoLink("Web","find",sWebLanguage)%>" onClick="doFind();">
                <input class="button" type="button" name="clearButton" value="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="clearSearchFields();">&nbsp;
            </td>
        </tr>
        
        <%-- SEARCH RESULTS --%>
        <tr>
            <td style="vertical-align:top;" colspan="5" class="white" width="100%">
                <div id="divFindRecords"></div>
            </td>
        </tr>
    </table>
    <br>
    
    <%-- CLOSE BUTTON --%>
    <center>
        <input type="button" class="button" name="closeButton" value='<%=getTranNoLink("Web","Close",sWebLanguage)%>' onclick='window.close()'>
    </center>
    
    <%-- hidden fields --%>
    <input type="hidden" name="ReturnPersonID" value="<%=sReturnPersonID%>">
    <input type="hidden" name="FindServiceID" value="<%=request.getParameter("FindServiceID")%>">
    <input type="hidden" name="ReturnUserID" value="<%=sReturnUserID%>">
    <input type="hidden" name="ReturnName" value="<%=sReturnName%>">
    <input type="hidden" name="SetGreenField" value="<%=sSetGreenField%>">
    <input type="hidden" name="displayImmatNew" value="<%=checkString(request.getParameter("displayImmatNew"))%>">
    <input type="hidden" name="displayImmatNew2" value="">
    <input type="hidden" name="FunctionToPerformWithId" value="<%=sFunctionToPerformWithId%>">
</form>

<script>
  window.resizeTo(600,480);
  window.setTimeout("SearchForm.FindLastname.focus();",300);

  <%-- CLEAR SEARCH FIELDS --%>
  function clearSearchFields(){
    SearchForm.FindLastname.value = "";
    SearchForm.FindFirstname.value = "";
    SearchForm.FindLastname.focus();
  }

  <%-- DO FIND --%>
  function doFind(){
    ajaxChangeSearchResults('_common/search/searchByAjax/searchUserShow.jsp',SearchForm);
  }

  <%-- SET PERSON --%>
  function setPerson(sPersonID, sUserID, sName){
    if('<%=sReturnPersonID%>'.length > 0){
      window.opener.document.getElementsByName('<%=sReturnPersonID%>')[0].value = sPersonID;
      if(window.opener.document.getElementsByName('<%=sReturnPersonID%>')[0].onchange!=null){
        window.opener.document.getElementsByName('<%=sReturnPersonID%>')[0].onchange();
      }
    }

    if('<%=sReturnUserID%>'.length > 0){
      if(window.opener.document.getElementsByName('<%=sReturnUserID%>').length>0){
	    window.opener.document.getElementsByName('<%=sReturnUserID%>')[0].value = sUserID;
	    if(window.opener.document.getElementsByName('<%=sReturnUserID%>')[0].onchange!=null){
	      window.opener.document.getElementsByName('<%=sReturnUserID%>')[0].onchange();
	    }
      }
      else{
        window.opener.document.getElementById('<%=sReturnUserID%>').value = sUserID;
        if(window.opener.document.getElementById('<%=sReturnUserID%>').onchange!=null){
          window.opener.document.getElementById('<%=sReturnUserID%>').onchange();
        }
   	  }
    }

    if('<%=sReturnName%>'.length > 0){
      if(window.opener.document.getElementsByName('<%=sReturnName%>').length>0){
	    window.opener.document.getElementsByName('<%=sReturnName%>')[0].value = sName;
	    if(window.opener.document.getElementsByName('<%=sReturnName%>')[0].onchange!=null){
	      window.opener.document.getElementsByName('<%=sReturnName%>')[0].onchange();
	    }
      }
      else{
	    window.opener.document.getElementById('<%=sReturnName%>').value = sName;
	    if(window.opener.document.getElementById('<%=sReturnName%>').onchange!=null){
	      window.opener.document.getElementById('<%=sReturnName%>').onchange();
	    }
      }
    }

    if('<%=sSetGreenField%>'.length > 0){
      window.opener.document.getElementsByName('<%=sReturnName%>')[0].className = 'green';
    }
    if(window.opener.document.getElementsByName('<%=sReturnUserID%>').length>0){
      if(window.opener.document.getElementsByName('<%=sReturnUserID%>')[0]!=null){
        if(window.opener.document.getElementsByName('<%=sReturnUserID%>')[0].onchange!=null){
          window.opener.document.getElementsByName('<%=sReturnUserID%>')[0].onchange();
        }
      }
    }
    else{
	  if(window.opener.document.getElementById('<%=sReturnUserID%>')!=null){
        if(window.opener.document.getElementById('<%=sReturnUserID%>').onchange!=null){
          window.opener.document.getElementById('<%=sReturnUserID%>').onchange();
        }
      }
	}
    <%
	// perform function in opener if one specified
	if(sFunctionToPerformWithId.length() > 0){
	    %>
	     if(window.opener.<%=sFunctionToPerformWithId%>!=null){
	       window.opener.<%=sFunctionToPerformWithId%>(sUserID);
	     }
	   <%
	}

    %>
    window.close();
  }

  <%-- popup : search service --%>
  function searchService(serviceUidField, serviceNameField){
    openPopup("/_common/search/searchService.jsp&ts=<%=getTs()%>&VarCode="+serviceUidField+"&VarText="+serviceNameField);
  }

  <%-- ACTIVATE TAB --%>
  function activateTab(sTab){

    <% 
      // hide all TRs
      if(request.getParameter("FindServiceID")!=null){
        %>
          if(document.getElementById('FindLastname').value.length==0 && document.getElementById('FindFirstname').value.length==0){
	          document.getElementById('tr_tab1').style.display = 'none';
	          document.getElementById('td1').className = "tabunselected";
	
	          if(sTab=='tab_1'){
	            document.getElementById('tr_tab1').style.display = '';
	            document.getElementById('td1').className = "tabselected";
	          }
      	  }
        <%
      }
    %>

    <%-- varia tab --%>
    document.getElementById('tr_tabvaria').style.display = 'none';
    document.getElementById('td2').className = "tabunselected";

    if(sTab=='tab_varia'){
      document.getElementById('tr_tabvaria').style.display = '';
      document.getElementById('td2').className = "tabselected";
    }
  }
  
  doFind();
</script>