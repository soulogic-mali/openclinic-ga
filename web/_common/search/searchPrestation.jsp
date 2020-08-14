<%@page import="be.openclinic.finance.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=sJSSORTTABLE%>

<%
    String sFindPrestationCode  = checkString(request.getParameter("FindPrestationCode")),
           sFindPrestationDescr = checkString(request.getParameter("FindPrestationDescr")),
           sFindPrestationType  = checkString(request.getParameter("FindPrestationType")),
           sFindPrestationPrice = checkString(request.getParameter("FindPrestationPrice"));

    String sFunction         = checkString(request.getParameter("doFunction")),
	       sFunctionVariable = checkString(request.getParameter("doFunctionVariable"));

    String sReturnFieldUid       = checkString(request.getParameter("ReturnFieldUid")),
           sReturnFieldCode      = checkString(request.getParameter("ReturnFieldCode")),
           sReturnFieldDescr     = checkString(request.getParameter("ReturnFieldDescr")),
           sReturnFieldDescrHtml = checkString(request.getParameter("ReturnFieldDescrHtml")),
           sReturnFieldType      = checkString(request.getParameter("ReturnFieldType")),
           sReturnFieldPrice     = checkString(request.getParameter("ReturnFieldPrice"));

    String sCurrency = MedwanQuery.getInstance().getConfigParam("currency","€");
    String sCheckInsurance = checkString(request.getParameter("checkInsurance"));
    String sEncounterUid = checkString(request.getParameter("encounteruid"));
    if(sCheckInsurance.length()>0){
    	Insurance insurance = null;
    	if(sCheckInsurance.split("\\.").length==2){
    		insurance = Insurance.get(sCheckInsurance);
    	}
    	if(insurance==null || insurance.getUid()==null || insurance.getUid().length()==0 || insurance.getUid().split("\\.").length<2){
    		out.println("<script>window.opener.setTimeout(\"alert('"+getTranNoLink("web","selectinsurancefirst",sWebLanguage)+"')\",100);window.close();</script>");
    		out.flush();
    	}
    }
    
    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
    	Debug.println("\n****************** _common/search/searchPrestation.jsp *****************");
    	Debug.println("sFindPrestationCode   : "+sFindPrestationCode);
    	Debug.println("sFindPrestationDescr  : "+sFindPrestationDescr);
    	Debug.println("sFindPrestationType   : "+sFindPrestationType);
    	Debug.println("sFindPrestationPrice  : "+sFindPrestationPrice+"\n");
    	
    	Debug.println("sFunction             : "+sFunction);
    	Debug.println("sFunctionVariable     : "+sFunctionVariable+"\n");
    	
    	Debug.println("sReturnFieldUid       : "+sReturnFieldUid);
    	Debug.println("sReturnFieldCode      : "+sReturnFieldCode);
    	Debug.println("sReturnFieldDescr     : "+sReturnFieldDescr);
    	Debug.println("sReturnFieldDescrHtml : "+sReturnFieldDescrHtml);
    	Debug.println("sReturnFieldType      : "+sReturnFieldType);
    	Debug.println("sReturnFieldPrice     : "+sReturnFieldPrice+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////
%>
<form name="SearchForm" method="POST" >
    <%-- hidden fields --%>
    <input type="hidden" name="Action">
    <input type="hidden" name="ReturnFieldUid" value="<%=sReturnFieldUid%>">
    <input type="hidden" name="ReturnFieldCode" value="<%=sReturnFieldCode%>">
    <input type="hidden" name="ReturnFieldDescr" value="<%=sReturnFieldDescr%>">
    <input type="hidden" name="ReturnFieldType" value="<%=sReturnFieldType%>">
    <input type="hidden" name="ReturnFieldPrice" value="<%=sReturnFieldPrice%>">
    <input type="hidden" name="CheckInsurance" value="<%=sCheckInsurance%>">
    <input type="hidden" name="encounteruid" value="<%=sEncounterUid%>">

    <%=writeTableHeader("web","searchprestation",sWebLanguage," window.close();")%>
    <table width="100%" cellspacing="1" cellpadding="0" class="menu">
        <%
            if(!"no".equalsIgnoreCase(checkString(request.getParameter("header")))){
        %>
        <%-- CODE --%>
        <% if(checkString(request.getParameter("keyword")).length()==0){%>
        
        <tr>
            <td class="admin2" width="120" nowrap><%=getTran(request,"web","keywords",sWebLanguage)%></td>
            <td class="admin2" width="380" nowrap>
            	<%=ScreenHelper.writeAutocompleteLabelField("keywords", 60, "prestation.keyword", "searchPrestations()") %>
            </td>
        </tr>
        <%
        	}
        	else{
        %>
        	<input type='hidden' name='keywords' id='keywords' value='<%=request.getParameter("keyword") %>'/>
        	<input type='hidden' name='keywordsid' id='keywordsid' value='<%=request.getParameter("keyword") %>'/>
        <%
        	}
        %>
        
        <%-- CODE --%>
        <tr>
            <td class="admin2" width="120" nowrap><%=getTran(request,"web","code",sWebLanguage)%></td>
            <td class="admin2" width="380" nowrap>
                <input onkeyup="if(enterEvent(event,13)){searchPrestations();}" type="text" class="text" name="FindPrestationCode" size="20" maxlength="20" value="<%=sFindPrestationCode%>">
            </td>
        </tr>
        
        <%-- DESCRIPTION --%>
        <tr>
            <td class="admin2"><%=getTran(request,"web","description",sWebLanguage)%></td>
            <td class="admin2">
                <input  onkeyup="if(enterEvent(event,13)){searchPrestations();}" type="text" class="text" name="FindPrestationDescr" size="60" maxlength="60" value="<%=sFindPrestationDescr%>">
            </td>
        </tr>
        
        <%-- TYPE --%>
        <tr>
            <td class="admin2"><%=getTran(request,"web","type",sWebLanguage)%></td>
            <td class="admin2">
                <select class="text" name="FindPrestationType">
                    <option value=""></option>
                    <%=ScreenHelper.writeSelect(request,"prestation.type",sFindPrestationType,sWebLanguage)%>
                </select>
            </td>
        </tr>
        
        <%-- PRICE --%>
        <tr>
            <td class="admin2"><%=getTran(request,"web","price",sWebLanguage)%></td>
            <td class="admin2">
                <input  onkeyup="if(enterEvent(event,13)){searchPrestations();}" type="text" class="text" name="FindPrestationPrice" size="10" maxlength="8" onKeyUp="if(!isNumber(this)){this.value='';}" value="<%=sFindPrestationPrice%>">&nbsp;<%=sCurrency%>
            </td>
        </tr>
        
        <%-- SORT --%>
        <tr>
            <td class="admin2"><%=getTran(request,"web","sort",sWebLanguage)%></td>
            <td class="admin2">
                <select class="text" name="FindPrestationSort">
                    <option value="">
                    <option value="OC_PRESTATION_DESCRIPTION"><%=getTran(request,"web","description",sWebLanguage)%></option>
                    <option value="OC_PRESTATION_CODE"><%=getTran(request,"web","code",sWebLanguage)%></option>
                    <option value="OC_PRESTATION_PRICE"><%=getTran(request,"web","price",sWebLanguage)%></option>
                </select>
            </td>
        </tr>
        
        <%-- BUTTONS --%>
        <tr height="25">
            <td class="admin2">&nbsp;</td>
            <td class="admin2">
                <input class="button" type="button" onClick="searchPrestations();" name="searchButton" value="<%=getTranNoLink("Web","search",sWebLanguage)%>">&nbsp;
                <input class="button" type="button" onClick="clearFields();" name="clearButton" value="<%=getTranNoLink("Web","clear",sWebLanguage)%>">
            </td>
        </tr>
        <%
            }
        %>
    </table>
    <br>
    
    <div id="divFindRecords"></div>
        
    <%-- BUTTONS --%>
    <%=ScreenHelper.alignButtonsStart()%>
        <input type="button" class="button" name="buttonclose" value="<%=getTranNoLink("Web","Close",sWebLanguage)%>" onclick="window.close();">
    <%=ScreenHelper.alignButtonsStop()%>
</form>

<script>
  window.resizeTo(800,600);

  <%-- CLEAR FIELDS --%>
  function clearFields(){
    SearchForm.FindPrestationCode.value = "";
    SearchForm.FindPrestationDescr.value = "";
    SearchForm.FindPrestationType.selectedIndex = 0;
    SearchForm.FindPrestationPrice.value = "";
    SearchForm.FindPrestationSort.selectedIndex = 0;
        
    SearchForm.FindPrestationCode.focus();
  }

  <%-- SEARCH PRESTATIONS --%>
  function searchPrestations(){
    SearchForm.Action.value = "search";
    if(document.getElementById("keywords").value.length==0){
    	document.getElementById("keywordsid").value="";
    }
    ajaxChangeSearchResults('_common/search/searchByAjax/searchPrestationShow.jsp',SearchForm);
  }

  <%-- SET PRESTATION --%>
  function setPrestation(uid,code,descr,type,price){
    if("<%=sReturnFieldUid%>".length > 0){
      window.opener.document.getElementsByName("<%=sReturnFieldUid%>")[0].value = uid;
    }
    if("<%=sReturnFieldCode%>".length > 0){
      window.opener.document.getElementsByName("<%=sReturnFieldCode%>")[0].value = code;
    }
    if("<%=sReturnFieldDescr%>".length > 0){
        window.opener.document.getElementsByName("<%=sReturnFieldDescr%>")[0].title = descr;
    	if(descr.length>57){
    		descr=descr.substring(0,57)+"...";
    	}
      window.opener.document.getElementsByName("<%=sReturnFieldDescr%>")[0].value = descr;
    }
    if("<%=sReturnFieldDescrHtml%>".length > 0){
      window.opener.document.getElementById("<%=sReturnFieldDescrHtml%>").innerHTML = descr;
    }
    if("<%=sReturnFieldType%>".length > 0){
      window.opener.document.getElementsByName("<%=sReturnFieldType%>")[0].value = type;
    }
    if("<%=sReturnFieldPrice%>".length > 0){
      window.opener.document.getElementsByName("<%=sReturnFieldPrice%>")[0].value = price;
    }

	<%
	    if(sFunction.length() > 0){
	        out.print("window.opener."+sFunction+";");
	    }
	%>

    window.close();
  }
  
  <%-- SET PRESTATION VARIABLE --%>
  function setPrestationVariable(uid,code,descr,type,price){
  	price2 = prompt("<%=getTran(null,"web","enterprice",sWebLanguage)%>",price);
  	if(price*1.00>0 && price2*1.00>price*1.00){
  		alert('<%=getTranNoLink("web","valuemustnotbehigherthan",sWebLanguage)%> '+price);
  	}
  	else if(price*1.00<0 && price2*1.00<price*1.00){
  		alert('<%=getTranNoLink("web","valuemustnotbelowerthan",sWebLanguage)%> '+price);
  	}
  	else if(price*1.00<0 && price2*1.00>0){
  		alert('<%=getTranNoLink("web","valuemustbenegative",sWebLanguage)%>');
  	}
  	else if(price*1.00>0 && price2*1.00<0){
  		alert('<%=getTranNoLink("web","valuemustbepositive",sWebLanguage)%>');
  	}
  	else{
  		price=price2;
	    if("<%=sReturnFieldUid%>".length > 0){
	      window.opener.document.getElementsByName("<%=sReturnFieldUid%>")[0].value = uid;
	    }
	    if("<%=sReturnFieldCode%>".length > 0){
	      window.opener.document.getElementsByName("<%=sReturnFieldCode%>")[0].value = code;
	    }
	    if("<%=sReturnFieldDescr%>".length > 0){
	    	if(descr.length>77){
	    		descr=descr.substring(0,77)+"...";
	    	}
	      window.opener.document.getElementsByName("<%=sReturnFieldDescr%>")[0].value = descr;
	    }
	    if("<%=sReturnFieldDescrHtml%>".length > 0){
	    	if(descr.length>77){
	    		descr=descr.substring(0,77)+"...";
	    	}
	      window.opener.document.getElementById("<%=sReturnFieldDescrHtml%>").innerHTML = descr;
	    }
	    if("<%=sReturnFieldType%>".length > 0){
	      window.opener.document.getElementsByName("<%=sReturnFieldType%>")[0].value = type;
	    }
	    if("<%=sReturnFieldPrice%>".length > 0){
	      window.opener.document.getElementsByName("<%=sReturnFieldPrice%>")[0].value = price;
	    }
		<%
		    if(sFunctionVariable.length() > 0){
		        out.print("window.opener."+sFunctionVariable+";");
		    }
	    %>
	
	    window.close();
  	}
  }

    
  window.setTimeout("document.getElementsByName('<%=MedwanQuery.getInstance().getConfigString("defaultPrestationSearchField","FindPrestationDescr")%>')[0].focus();",300);
  
  <% if(checkString(request.getParameter("keyword")).length()>0){%>
  	window.setTimeout("searchPrestations();",200);
  <%}%>
</script>