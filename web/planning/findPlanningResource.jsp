<%@page import="be.openclinic.adt.*,
                be.dpms.medwan.common.model.vo.occupationalmedicine.ExaminationVO,
                java.util.Calendar,
                java.util.Vector,
                java.util.Hashtable,
                java.util.Collections"%>
<%@page import="java.util.Date"%>
<%@include file="/includes/validateUser.jsp" %>

<form name='resourceForm' method='post'>
<table width='100%'>
	<tr class='admin'>
		<td>
			<select name='resource' id='resource' onchange='loadResourceReservations()'>
				<%=ScreenHelper.writeSelect(request,"planningresource", "", sWebLanguage) %>
			</select>
		</td>
		<td>
			<%=getTran(request,"web","from",sWebLanguage) %><%=ScreenHelper.writeDateField("begin", "resourceForm", ScreenHelper.getSQLDate(new java.util.Date()),true,true, sWebLanguage, sCONTEXTPATH,"loadResourceReservations()") %>
			<%if(activeUser.getAccessRight("planning.manageresourcelocks.add")){ %>
			 	&nbsp;&nbsp;&nbsp;&nbsp;<a href='main.do?Page=planning/manageResourceLocks.jsp'><%=getTran(request,"web.manage","managePlanningResourceLocks",sWebLanguage)%></a>
			<%} %>
		</td>
	</tr>
</table>
<span id='resourcereservations'></span>
</form>

<script>
	function openResourceAppointment(id){
	    if(id) actualAppointmentId = id;
	    var url = "<c:url value='/planning/ajax/editPlanning.jsp'/>" +
	              "?readonly=true&FindPlanningUID="+actualAppointmentId+"&ts="+new Date().getTime();
	    Modalbox.show(url,{title:'<%=getTran(null,"web","planning",sWebLanguage)%>',height:500,width:650,afterHide:function(){}},{evalScripts:true});
	}

	function loadResourceReservations(){
		var today = new Date();
		var url= '<c:url value="/planning/ajax/getResourcesForPeriodPerWeek.jsp"/>?resourceuid='+document.getElementById('resource').value+'&begin='+document.getElementById('begin').value+'&language=<%=sWebLanguage%>&ts='+today;
		new Ajax.Request(url,{
		method: "POST",
		   parameters: "",
		   onSuccess: function(resp){
			   $('resourcereservations').innerHTML=resp.responseText;
			}
		});
	}
	
	loadResourceReservations();
</script>