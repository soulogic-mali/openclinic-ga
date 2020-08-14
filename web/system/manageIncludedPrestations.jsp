<%@page import="be.openclinic.finance.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>
<%
	String sEditForfaitUid=checkString(request.getParameter("EditForfaitUID"));
	String sEditForfaitName=checkString(request.getParameter("EditForfaitName"));
	if(sEditForfaitUid.length()>0){
		Prestation forfait = Prestation.get(sEditForfaitUid);
		if(forfait!=null){
			sEditForfaitName=forfait.getDescription();
		}
		else{
			sEditForfaitUid="";
		}
	}
	
	if(sEditForfaitUid.length()>0 && request.getParameter("submit")!=null){
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("delete from oc_forfaitprestations where oc_forfaitprestation_forfaituid=?");
		ps.setString(1,sEditForfaitUid);
		ps.execute();
		ps.close();
		ps = conn.prepareStatement("insert into oc_forfaitprestations(oc_forfaitprestation_forfaituid,oc_forfaitprestation_prestationuid) values(?,?)");
		ps.setString(1, sEditForfaitUid);
		Enumeration pars = request.getParameterNames();
		while(pars.hasMoreElements()){
			String parName=(String)pars.nextElement();
			if(parName.startsWith("cb.") && request.getParameter(parName).equalsIgnoreCase("1")){
				ps.setString(2, parName.replaceAll("cb.",""));
				ps.execute();
			}
		}
		ps.close();
		conn.close();
	}
%>

<%=sJSSORTTABLE%>
<form name='SearchForm' method='post'>
	<table width='100%'>
		<tr class='admin'><td colspan='5'><%=getTran(request,"web.manage","manageForfaitPrestations",sWebLanguage) %></td></tr>
		<tr>
            <td class="admin"><%=getTran(request,"web","forfait",sWebLanguage)%></td>
            <td class="admin2" colspan='4'>
                <input type="hidden" name="EditForfaitUID" id="EditForfaitUID" value="<%=sEditForfaitUid%>"/>
                <input class="text" type="text" readonly name="EditForfaitName" value="<%=sEditForfaitName%>" size="<%=sTextWidth%>"/>
              
                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchPrestation('EditForfaitUID','EditForfaitName');">
                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.EditForfaitName.value='';transactionForm.EditForfaitUid.value='';">
            </td>
		</tr>
		<tr>
			<td colspan='5'>
				<div id='divFindRecords'></div>
			</td>
		</tr>
		<tr><td colspan='5'><center><input class='button' type='submit' name='submit' value='<%=getTran(null,"web","save",sWebLanguage)%>'/></center></td></tr>
	</table>
</form>

<script>
	function searchPrestation(forfaitUidField,forfaitNameField){
	    openPopup("/_common/search/searchPrestation.jsp&ts=<%=getTs()%>"+
	              "&ReturnFieldUid="+forfaitUidField+
	              "&ReturnFieldDescr="+forfaitNameField+
	              "&doFunction=searchPrestations()"+
	              "&restrictedlistonly=1");
	}
	
	function searchPrestations(){
	    ajaxChangeSearchResults("_common/search/searchByAjax/searchForfaitPrestationsShow.jsp",SearchForm);
	}
	
	function selectchecks(){
		var els = document.all;
		for(n=0;n<els.length;n++){
			if(els[n].type && els[n].type=='checkbox' && !els[n].checked){
				els[n].checked=true;
			}
		}
	}

  <%-- AJAX CHANGE SEARCH RESULTS --%>
  function ajaxChangeSearchResults(urlForm,SearchForm,moreParams){
    document.getElementById('divFindRecords').innerHTML = "<div style='text-align:center;padding-top:2px;'><img src='<%=sCONTEXTPATH%>/_img/themes/<%=checkString((String)session.getAttribute("UserTheme"))%>/ajax-loader.gif'/><br/>Loading..</div>";
    var url = urlForm;
    var params = Form.serialize(SearchForm)+moreParams;
    var myAjax = new Ajax.Updater("divFindRecords",url,{
      method: "POST",
      evalScripts: true,
      parameters:params,
      onSuccess:function(resp){
        document.getElementById("divFindRecords").innerHTML = trim(resp.responseText);
      },
      onFailure:function(){
        $("divFindRecords").innerHTML = "Problem with ajax request";
      }
    });
  }

<%
	if(sEditForfaitUid.length()>0){
%>
	searchPrestations();
<%
	}
%>

</script>