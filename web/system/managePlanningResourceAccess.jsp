<%@ page import="be.openclinic.adt.*,java.util.*,be.mxs.common.util.system.*,java.text.*" %>
<%@include file="/includes/validateUser.jsp" %>
<%=checkPermission(out,"system.management","select",activeUser)%><form name='transactionForm' method='post'>
	<table>
        <tr>
            <td class="admin" nowrap><%=getTran(request,"Web","resource",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
            	<select class='text' name='resource' id='resource' onchange='loadAuthorizedUsers();'>
            		<option/>
            		<%=ScreenHelper.writeSelect(request,"planningresource", "", sWebLanguage) %>
            	</select>
           		<%
           			String authorizedresources = Reservation.getAccessibleResources(activeUser.userid);
           		%>
           		<script>
           			var options = document.getElementById('resource').options;
           			for(n=0;n<options.length;n++){
           				if(<%=checkString(activeUser.getParameter("sa")).length()%>==0 && '<%=authorizedresources%>'.indexOf(options[n].value)<0){
           					options[n].disabled=true;
           				}
           			}
           		</script>
            </td>
        </tr>
        <tr>
            <td class="admin" nowrap><%=getTran(request,"Web","Authorizedusers",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <%-- add row --%>
                <input type="hidden" name="AuthorizedUserIdAdd" id="AuthorizedUserIdAdd" value="">
                <input class="text" type="text" name="AuthorizedUserNameAdd" size="<%=sTextWidth%>" value="" readonly>
               
                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchAuthorizedUser('AuthorizedUserIdAdd','AuthorizedUserNameAdd');">
                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.AuthorizedUserIdAdd.value='';transactionForm.AuthorizedUserNameAdd.value='';">
                <img src="<c:url value="/_img/icons/icon_add.gif"/>" class="link" alt="<%=getTranNoLink("Web","add",sWebLanguage)%>" onclick="addAuthorizedUser();">
            </td>
        </tr>
        <tr>
        	<td colspan="2">
			    <span id='authorizedusers'></span>
        	</td>
        </tr>
	</table>
</form>

<script>
	function searchAuthorizedUser(userUidField,userNameField){
	    openPopup("/_common/search/searchUser.jsp&ts=<%=getTs()%>&ReturnUserID="+userUidField+"&ReturnName="+userNameField+"&displayImmatNew=no");
	}
	
	function addAuthorizedUser(){
		var today = new Date();
		var url= '<c:url value="/system/ajax/addResourceAuthorizedUser.jsp"/>?resourceuid='+document.getElementById('resource').value+'&userid='+document.getElementById('AuthorizedUserIdAdd').value+'&ts='+today;
		new Ajax.Request(url,{
		method: "POST",
		   parameters: "",
		   onSuccess: function(resp){
			   transactionForm.AuthorizedUserIdAdd.value='';
			   transactionForm.AuthorizedUserNameAdd.value='';
			   loadAuthorizedUsers();
			}
		});
	}
	
	function deleteAuthorizedUser(userid){
		if(yesnoDeleteDialog()){
			var today = new Date();
			var url= '<c:url value="/system/ajax/deleteResourceAuthorizedUser.jsp"/>?resourceuid='+document.getElementById('resource').value+'&userid='+userid+'&ts='+today;
			new Ajax.Request(url,{
			method: "POST",
			   parameters: "",
			   onSuccess: function(resp){
				   loadAuthorizedUsers();
				}
			});
		}
	}
	
	function loadAuthorizedUsers(){
		var today = new Date();
		var url= '<c:url value="/system/ajax/getResourceAuthorizedUsers.jsp"/>?resourceuid='+document.getElementById('resource').value+'&ts='+today;
		new Ajax.Request(url,{
		method: "POST",
		   parameters: "",
		   onSuccess: function(resp){
			   $('authorizedusers').innerHTML=resp.responseText;
			}
		});
	}
	
	loadAuthorizedUsers();
</script>