<%@page import="be.openclinic.adt.*"%>
<%@include file="/includes/validateUser.jsp" %>
<%
	long day=24*3600*1000;
	long month=30*day;
	
	java.util.Date begindate = new java.util.Date();
	java.util.Date enddate = new java.util.Date(new java.util.Date().getTime()+3*month);
%>
<form name="transactionForm" method="post">
	<table width='100%'>
		<tr class='admin'>
			<td><%=getTran(request,"web","resource",sWebLanguage) %></td>
			<td><%=getTran(request,"web","period",sWebLanguage) %></td>
			<td><%=getTran(request,"web","service",sWebLanguage) %></td>
			<td/>
		</tr>
		<tr>
			<td class='admin'>
				<select name='resource' id='resource' onchange='loadResourceLocks()'>	
					<option/>
					<%=ScreenHelper.writeSelect(request,"planningresource", "", sWebLanguage) %>
				</select>
           		<%
           			String authorizedresources = Reservation.getAccessibleResources(activeUser.userid);
           		%>
           		<script>
           			var options = document.getElementById('resource').options;
           			for(n=0;n<options.length;n++){
           				if('<%=authorizedresources%>'.indexOf(options[n].value)<0){
           					options[n].disabled=true;
           				}
           			}
           		</script>
			</td>
			<td class='admin'>
				<table>
					<tr>
						<td width='1%'><%=getTran(request,"web","from",sWebLanguage) %></td><td><%=ScreenHelper.writeDateTimeField("begin", "transactionForm", begindate, sWebLanguage, sCONTEXTPATH,"loadResourceLocks()") %></td>
					</tr>
					<tr>
						<td><%=getTran(request,"web","till",sWebLanguage) %></td><td><%=ScreenHelper.writeDateTimeField("end", "transactionForm", enddate, sWebLanguage, sCONTEXTPATH,"loadResourceLocks()") %></td>
					</tr>
				</table>
			</td>
            <td class='admin' nowrap>
                <input type="hidden" name="service" id="service">
                <input class="text" type="text" name="servicename" id="servicename" readonly size="<%=sTextWidth%>">
                
                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTran(null,"web","select",sWebLanguage)%>" onclick="searchService('service','servicename');">
                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTran(null,"web","clear",sWebLanguage)%>" onclick="transactionForm.service.value='';transactionForm.servicename.value='';">
            </td>
			<td class='admin' nowrap>
				<input type='button' class='button' name='addButton' id='addButton' value='<%=getTranNoLink("web","lock",sWebLanguage) %>' onclick='saveResourceLock();'/>
				<input type='button' class='button' name='exitButton' id='exitButton' value='<%=getTran(null,"web","back",sWebLanguage) %>' onclick='window.history.back();'/>
			</td>
		</tr>
	</table>
</form>
<hr>
<p/>
<span id='resourcereservations'></span>

<script>

	<%-- SEARCH SERVICE --%>
	function searchService(serviceUidField,serviceNameField){
	  openPopup("/_common/search/searchService.jsp&ts=<%=getTs()%>&VarSelectDefaultStay=true&VarCode="+serviceUidField+"&VarText="+serviceNameField);
	}

	function loadResourceLocks(){
		var today = new Date();
		var url= '<c:url value="/planning/ajax/getResourceLocksForPeriod.jsp"/>?resourceuid='+document.getElementById('resource').value+'&begintime='+document.getElementById('beginTime').value+'&endtime='+document.getElementById('endTime').value+'&begin='+document.getElementById('begin').value+'&end='+document.getElementById('end').value+'&language=<%=sWebLanguage%>&ts='+today;
		new Ajax.Request(url,{
		method: "POST",
		   parameters: "",
		   onSuccess: function(resp){
			   $('resourcereservations').innerHTML=resp.responseText;
			   if(document.getElementById('conflict') && document.getElementById('conflict').value=='1'){
				   document.getElementById('addButton').style.display='none';
			   }
			   else {
				   document.getElementById('addButton').style.display='';
			   }
			}
		});
	}
	
	function saveResourceLock(){
		if(document.getElementById('resource').value.length>0){
			var today = new Date();
			var url= '<c:url value="/planning/ajax/saveResourceLock.jsp"/>?resourceuid='+document.getElementById('resource').value+'&service='+document.getElementById('service').value+'&begin='+document.getElementById('begin').value+'&begintime='+document.getElementById('beginTime').value+'&end='+document.getElementById('end').value+'&endtime='+document.getElementById('endTime').value+'&userid=<%=activeUser.userid%>&language=<%=sWebLanguage%>&ts='+today;
			new Ajax.Request(url,{
			method: "POST",
			   parameters: "",
			   onSuccess: function(resp){
				   loadResourceLocks();
				}
			});
		}			
	}
	
	function deleteResourceLock(uid){
		if(yesnoDeleteDialog()){
			var today = new Date();
			var url= '<c:url value="/planning/ajax/deleteResourceLock.jsp"/>?uid='+uid+'&ts='+today;
			new Ajax.Request(url,{
			method: "POST",
			   parameters: "",
			   onSuccess: function(resp){
				   loadResourceLocks();
				}
			});
		}
	}
	
	loadResourceLocks();
</script>