<%@page import="be.openclinic.adt.*"%>
<%@include file="/includes/validateUser.jsp" %>
<%
	//Eerst zoeken we alle resources die aan het huidige planninguid gekoppeld werden
	String patientuid = checkString(request.getParameter("patientuid"));
	String planninguid = checkString(request.getParameter("planninguid"));
	if(planninguid.length()==0){
		planninguid=checkString(request.getParameter("tempplanninguid"));
	}
	if(planninguid.length()==0){
		planninguid="0."+new java.util.Date().getTime();
		out.println("<script>window.opener.document.getElementById('tempplanninguid').value='"+planninguid+"'</script>");
		out.flush();
	}
	java.util.Date begindate = new java.util.Date();
	java.util.Date enddate = new java.util.Date();
	try{
		begindate = new java.util.Date(ScreenHelper.getSQLDate(request.getParameter("date")).getTime()+Long.parseLong(request.getParameter("begin")));
	}
	catch(Exception e){}
	try{
		enddate = new java.util.Date(ScreenHelper.getSQLDate(request.getParameter("date")).getTime()+Long.parseLong(request.getParameter("end")));
	}
	catch(Exception e){}
	String activeservice="";
	if(patientuid.length()>0){
		Encounter activeEncounter=Encounter.getActiveEncounter(patientuid);
		if(activeEncounter!=null){
			activeservice=activeEncounter.getServiceUID();
		}
	}
%>
<form name="transactionForm" method="post">
	<table width='100%'>
		<tr class='admin'>
			<td>
				<select name='resource' id='resource' onchange='loadResourceReservations()'>	
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
			<td><%=getTran(request,"web","from",sWebLanguage) %><%=ScreenHelper.writeDateTimeField("begin", "transactionForm", begindate, sWebLanguage, sCONTEXTPATH,"loadResourceReservations()' onkeyup='loadResourceReservations()") %></td>
			<td><%=getTran(request,"web","till",sWebLanguage) %><%=ScreenHelper.writeDateTimeField("end", "transactionForm", enddate, sWebLanguage, sCONTEXTPATH,"loadResourceReservations()' onkeyup='loadResourceReservations()") %></td>
			<td>
				<input type='button' class='button' name='addButton' id='addButton' value='<%=getTran(null,"web","add",sWebLanguage) %>' onclick='saveReservation()'/>
				<input type='button' class='button' name='exitButton' id='exitButton' value='<%=getTran(null,"web","close",sWebLanguage) %>' onclick='window.close();'/>
			</td>
		</tr>
	</table>
</form>
<span id='reservations'></span>
<p/>
<hr>
<p/>
<span id='resourcereservations'></span>

<script>
	function loadReservations(){
		var today = new Date();
		var url= '<c:url value="/planning/ajax/getResourcesForPlanning.jsp"/>?planninguid=<%=planninguid%>&delete=yes&language=<%=sWebLanguage%>&ts='+today;
		new Ajax.Request(url,{
		method: "POST",
		   parameters: "",
		   onSuccess: function(resp){
			   $('reservations').innerHTML=resp.responseText;
			   window.opener.document.getElementById('resources').innerHTML=resp.responseText;
			   var imgtds = window.opener.document.all;
			   for(n=0;n<imgtds.length;n++){
				   if(imgtds[n].id.indexOf('imgtd')>-1){
					   imgtds[n].style.display='none';
				   }
			   }
			}
		});
	}
	
	function loadResourceReservations(){
		var today = new Date();
		var url= '<c:url value="/planning/ajax/getResourcesForPeriod.jsp"/>?excludeplanninguid=<%=planninguid%>&resourceuid='+document.getElementById('resource').value+'&begintime='+document.getElementById('beginTime').value+'&endtime='+document.getElementById('endTime').value+'&begin='+document.getElementById('begin').value+'&end='+document.getElementById('end').value+'&language=<%=sWebLanguage%>&ts='+today+'&activeservice=<%=activeservice%>';
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
	
	function saveReservation(){
		if(document.getElementById('resource').value.length>0){
			var today = new Date();
			var url= '<c:url value="/planning/ajax/saveReservation.jsp"/>?planninguid=<%=planninguid%>&resourceuid='+document.getElementById('resource').value+'&begin='+document.getElementById('begin').value+'&begintime='+document.getElementById('beginTime').value+'&end='+document.getElementById('end').value+'&endtime='+document.getElementById('endTime').value+'&userid=<%=activeUser.userid%>&language=<%=sWebLanguage%>&ts='+today;
			new Ajax.Request(url,{
			method: "POST",
			   parameters: "",
			   onSuccess: function(resp){
				   loadReservations();
				}
			});
		}			
	}
	
	function deleteResource(uid){
		if(yesnoDeleteDialog()){
			var today = new Date();
			var url= '<c:url value="/planning/ajax/deleteReservation.jsp"/>?uid='+uid+'&ts='+today;
			new Ajax.Request(url,{
			method: "POST",
			   parameters: "",
			   onSuccess: function(resp){
				   loadReservations();
				}
			});
		}
	}
	
	loadReservations();
	loadResourceReservations();
</script>