<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>

<%
	if(MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",100)==0){
%>
		<font style='font-size: 12px;color: red'><%=getTran(request,"gmao","unavailableoncentralserver",sWebLanguage) %></font>
<%
	}
	else{
		String sServiceUid = checkString(request.getParameter("serviceuid"));
%>

<%=checkPermission(out,"gmao.synchronisation","select",activeUser)%>
<table width='100%'>
	<tr class='admin'>
		<td colspan='2'><%=getTran(request,"web","assetsynchronization",sWebLanguage) %></td>
	</tr>
	<tr>
		<td colspan='2'><font style='font-size: 14px;color: red'><%=getTran(request,"gmao","checkoutfunction",sWebLanguage) %></font></td>
	</tr>
	<tr>
        <td class="admin"><%=getTran(request,"web","service",sWebLanguage)%></td>
        <td class="admin2">
            <input type="hidden" name="serviceuid" id="serviceuid" value="<%=sServiceUid%>">
            <input class="text" type="text" name="servicename" id="servicename" readonly size="60" value="<%=getTranNoLink("service",sServiceUid,sWebLanguage) %>" >
            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTran(null,"Web","select",sWebLanguage)%>" onclick="searchService('serviceuid','servicename');">
            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTran(null,"Web","delete",sWebLanguage)%>" onclick="document.getElementById('serviceuid').value='';document.getElementById('servicename').value='';">
            &nbsp;<input type='button' class='button' name='buttonDownloadCheckout' value='<%=getTranNoLink("web","downloadandcheckout",sWebLanguage) %>' onclick='checkout();'/>
            <!-- 
            &nbsp;<input type='button' class='button' name='buttonDownload' value='<%=getTranNoLink("web","download",sWebLanguage) %>' onclick='download();'/>
 			-->
         </td>                        
	</tr>	
	<tr>
		<td colspan='2'><br><br><br><br><br><br><hr/><font style='font-size: 14px;color: red'><%=getTran(request,"gmao","checkinfunction",sWebLanguage) %></font></td>
	</tr>
	<tr>
        <td class="admin"></td>
        <td class="admin2">
            &nbsp;<input type='button' class='button' name='buttonUploadCheckin' value='<%=getTranNoLink("web","uploadandcheckin",sWebLanguage) %>' onclick='checkin();'/>
            <!-- 
            &nbsp;<input type='button' class='button' name='buttonUpload' value='<%=getTranNoLink("gmao","upload",sWebLanguage) %>' onclick='upload();'/>
 			-->
        </td>                        
	</tr>	
</table>

<script>
	function searchService(serviceUidField,serviceNameField){
	  	openPopup("/_common/search/searchService.jsp&ts=<%=getTs()%>&lockservices=1&VarCode="+serviceUidField+"&VarText="+serviceNameField);
	  	document.getElementById(serviceNameField).focus();
	}
	
	function checkout(){
		if(document.getElementById('serviceuid').value.length==0){
			alert('<%=getTranNoLink("web","serviceidismandatory",sWebLanguage)%>');
		}
		else{
			openPopup("/assets/checkOut.jsp&ts=<%=getTs()%>&PopupWidth=400&PopupHeight=400&serviceuid="+document.getElementById('serviceuid').value);
			document.getElementById('serviceuid').value='';
			document.getElementById('servicename').value='';
		}
	}
	
	function checkin(){
	  	openPopup("/assets/checkIn.jsp&ts=<%=getTs()%>&PopupWidth=400&PopupHeight=400");
	}
	
	function download(){
		if(document.getElementById('serviceuid').value.length==0){
			alert('<%=getTranNoLink("web","serviceidismandatory",sWebLanguage)%>');
		}
		else{
		  	openPopup("/assets/checkOut.jsp&ts=<%=getTs()%>&downloadonly=1&PopupWidth=400&PopupHeight=400&serviceuid="+document.getElementById('serviceuid').value);
			document.getElementById('serviceuid').value='';
			document.getElementById('servicename').value='';
		}
	}
	
	function upload(){
	  	openPopup("/assets/checkIn.jsp&ts=<%=getTs()%>&uploadonly=1&PopupWidth=400&PopupHeight=400");
	}
</script>
<%
	}
%>