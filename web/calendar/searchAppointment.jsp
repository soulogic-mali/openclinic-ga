<%@include file="/includes/validateUser.jsp"%>
<%= sJSPROTOTYPE %>
<%
	String sActiveLocation = checkString((String)session.getAttribute("calendarLocation"));
	String sActiveCalendarUser = checkString((String)session.getAttribute("calendarUser"));
%>
<form name='transactionForm' id='transactionForm' method='POST'>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='2'><%=getTran(request,"web","searchAppointment",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","location",sWebLanguage) %></td>
			<td class='admin2'>
				<select class='text' name='location' id='location'>
					<option/>
					<%=ScreenHelper.writeSelect(request,"appointment.location",sActiveLocation,sWebLanguage) %>
				</select>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","user",sWebLanguage) %></td>
			<td class='admin2'>
				<input type='hidden' name='userid' id='userid' value='<%=sActiveCalendarUser %>'/>
				<input type='text' class='text' size='60' name='username' id='username' readonly value='<%=sActiveCalendarUser.length()==0?"":User.getFullUserName(sActiveCalendarUser)%>'/>
				<img style='vertical-align: middle' src='<%=sCONTEXTPATH %>/_img/icons/icon_search.png' onclick='showSearchUserPopup("userid","username")'/>
				<img style='vertical-align: middle' src='<%=sCONTEXTPATH %>/_img/icons/icon_delete.png' onclick='document.getElementById("userid").value="";document.getElementById("username").value="";'/>
			</td>
		</td>
		<tr>
			<td class='admin'><%=getTran(request,"web","resource",sWebLanguage) %></td>
			<td class='admin2'>
				<input type='hidden' name='resourceid' id='resourceid'/>
				<input type='text' class='text' name='resourcename' id='resourcename' size='30' readonly/>
                <img style='vertical-align: middle' src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchNomenclature('resourceid','resourcename');">
                <img style='vertical-align: middle' src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="document.getElementById('resourceid').value='';document.getElementById('resourcename').value='';">
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","begin",sWebLanguage) %></td>
			<td class='admin2'>
				<%=ScreenHelper.writeDateField("begin","transactionForm",ScreenHelper.formatDate(new java.util.Date()),false,true,sWebLanguage,sCONTEXTPATH) %>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","end",sWebLanguage) %></td>
			<td class='admin2'>
				<%=ScreenHelper.writeDateField("end","transactionForm","",false,true,sWebLanguage,sCONTEXTPATH) %>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","timeframe",sWebLanguage) %></td>
			<td class='admin2'>
				<select class='text' name='beginhour' id='beginhour'>
					<%
						for(int n=0;n<24;n++){
							out.println("<option value='"+n+"' "+(Integer.parseInt(checkString(activeUser.getParameter("agenda_begin"),"08"))==n?"selected":"")+">"+ScreenHelper.padLeft(n+"","0",2)+"</option>");
						}
					%>
				</select> - 
				<select class='text' name='endhour' id='endhour'>
					<%
						for(int n=0;n<24;n++){
							out.println("<option value='"+n+"' "+(Integer.parseInt(checkString(activeUser.getParameter("agenda_end"),"18"))==n?"selected":"")+">"+ScreenHelper.padLeft(n+"","0",2)+"</option>");
						}
					%>
				</select>
			</td>
		</tr>
	</table>
	<input type='button' onclick='doSearch()' name='searchButton' id='searchButton' class='button' value='<%=getTranNoLink("web","search",sWebLanguage) %>'/>
	<input type='button' onclick='window.close();' name='closeButton' id='closeButton' class='button' value='<%=getTranNoLink("web","close",sWebLanguage) %>'/>
</form>
<div style='overflow-y: auto; height: 280px' id='searchResults'></div>

<script>
	function showSearchUserPopup(pid,personName){
	  	var url = "<c:url value="/popup.jsp?Page=_common/search/searchUser.jsp"/>&ts=<%=getTs()%>&PopupWidth=600&PopupHeight=400"+
	              "&ReturnUserID="+pid+
	              "&ReturnName="+personName;
	  	window.open(url,"searchUserPopup","height=1,width=1,toolbar=no,status=no,scrollbars=no,resizable=no,menubar=no");
	}
	
	function doSearch(){
		document.getElementById('searchResults').innerHTML='<img height="14px" src="<%=sCONTEXTPATH%>/_img/themes/default/ajax-loader.gif"/>';
		var url='<%=sCONTEXTPATH%>/calendar/searchFreeAppointment.jsp';
		var params=	"location="+document.getElementById('location').value
					+"&userid="+document.getElementById('userid').value
					+"&begin="+document.getElementById('begin').value
					+"&end="+document.getElementById('end').value
					+"&resourceid="+document.getElementById('resourceid').value
					+"&beginhour="+document.getElementById('beginhour').value
					+"&endhour="+document.getElementById('endhour').value
					;
		new Ajax.Request(url,{
			method: "POST",
			parameters: params,
			onSuccess: function(resp){
			   	document.getElementById('searchResults').innerHTML=resp.responseText;
	        },
	        onError: function(resp){
				alert("error");
	        }
	    });
	}
    function searchNomenclature(CategoryUidField,CategoryNameField){
	    openPopup("/_common/search/searchCalendarResource.jsp&ts=<%=getTs()%>&Mode=manage&begin=25000101000000&end=19000101000000&FindType=calendarresource&VarCode="+CategoryUidField+"&VarText="+CategoryNameField);
	}
</script>