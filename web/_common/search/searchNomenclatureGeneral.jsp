<%@ page errorPage="/includes/error.jsp" %>
<%@ include file="/includes/validateUser.jsp" %>
<%@ page import="java.util.*" %>
<%
    // form data
    String sVarCode = checkString(request.getParameter("VarCode")),
           sVarText = checkString(request.getParameter("VarText")),
           sNoClose = checkString(request.getParameter("noclose")),
           sNoActive = checkString(request.getParameter("NoActive")),
           sFindType = checkString(request.getParameter("FindType")),
           sFindMode = checkString(request.getParameter("Mode")),
           sFindText = checkString(request.getParameter("FindText")).toUpperCase();
%>
<form name="SearchForm" method="POST" onSubmit="doFind();return false;" onkeydown="if(enterEvent(event,13)){doFind();}">
    <%-- hidden fields --%>
    <input type="hidden" name="VarCode" value="<%=sVarCode%>">
    <input type="hidden" name="NoActive" value="<%=sNoActive%>">
    <input type="hidden" name="VarText" value="<%=sVarText%>">
    <input type="hidden" name="FindCode">
    <input type="hidden" name="FindType" value="<%=sFindType%>">
    <input type="hidden" name="ViewCode">
    <input type="hidden" name="mode" value="<%=sFindMode%>">

    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="menu">
        <tr>
            <td width="100%" height="25">
                &nbsp;<%=getTran(request,"Web", "Find", sWebLanguage)%>&nbsp;&nbsp;
                <input type="text" name="FindText" class="text" value="<%=sFindText%>" size="40">

                <%-- buttons --%>
                <input class="button" type="button" name="FindButton" value="<%=getTranNoLink("Web","find",sWebLanguage)%>"
                       onClick="doFind();">&nbsp;
                <input class="button" type="button" name="ClearButton" value="<%=getTranNoLink("Web","clear",sWebLanguage)%>"
                       onClick="clearSearchFields();">
            </td>
        </tr>
        <tr>
            <td class="navigation_line" height="1"/>
        </tr>
        <%-- SEARCH RESULTS TABLE --%>
        <tr>
            <td class="white" style="vertical-align:top;">
                <div id="divFindRecords"></div>
            </td>
        </tr>
    </table>
    <br>
    <%-- CLOSE BUTTON --%>
    <center>
        <input type="button" class="button" name="buttonclose" value="<%=getTranNoLink("Web","Close",sWebLanguage)%>" onclick="window.close();">
    </center>
</form>
<script>
    doFind();
    window.resizeTo(550, 520);
    window.setTimeout("SearchForm.FindText.focus();",300);

    function selectParentCategory(sType,sCode, sText) {
        if('<%=sVarText%>'.length>0 && window.opener.document.getElementById('<%=sVarText%>')){
        	window.opener.document.getElementById('<%=sVarText%>').value = sText.split(';')[0];
            window.opener.document.getElementById('<%=sVarText%>').title = sText.split(';')[0];
        }

        if ('<%=sVarCode%>'.length>0 && window.opener.document.getElementById('<%=sVarCode%>')) {
            window.opener.document.getElementById('<%=sVarCode%>').value = sCode;
            if (window.opener.document.getElementById('<%=sVarCode%>').onchange) {
                window.opener.document.getElementById('<%=sVarCode%>').onchange();
            }
        }
		if('<%=sNoClose%>'!='1'){
			window.close();
		}
    }

    function populateCategory(sType,sID) {
        SearchForm.FindCode.value = sID;
        ajaxChangeSearchResults('_common/search/searchByAjax/searchNomenclatureGeneralShow.jsp', SearchForm);
    }
    <%-- CLEAR SEARCH FIELDS --%>
    function clearSearchFields() {
        SearchForm.FindText.value = "";
        SearchForm.FindText.focus();
    }

    function viewCategory(sType,sID) {
        SearchForm.FindCode.value = sID;
        SearchForm.ViewCode.value = sID;
        ajaxChangeSearchResults('_common/search/searchByAjax/searchNomenclatureGeneralShow.jsp', SearchForm);
    }

    function doFind() {
        SearchForm.FindCode.value = "";
        SearchForm.ViewCode.value = "";
        ajaxChangeSearchResults('_common/search/searchByAjax/searchNomenclatureGeneralShow.jsp', SearchForm);
    }
</script>