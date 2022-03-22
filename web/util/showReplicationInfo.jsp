<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<table width='100%'>
	<tr class='admin'><td colspan='4'><%=getTran(request,"web","replicationinfo",sWebLanguage) %></td></tr>
	<tr>
		<td class='admin' width='30%'><%=getTran(request,"web,","slaveserver",sWebLanguage)%></td>
		<td class='admin2' width='20%'><b><%=SH.cs("replicationServer","?") %></b></td>
		<td class='admin' width='20%'><%=getTran(request,"web,","Last_Lab",sWebLanguage)%></td>
		<td id='Last_Lab' width='30%' class='admin2'></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web,","Slave_IO_Running",sWebLanguage)%></td>
		<td id='Slave_IO_Running' class='admin2'></td>
		<td class='admin'><%=getTran(request,"web,","Last_Transaction",sWebLanguage)%></td>
		<td id='Last_Transaction' class='admin2'></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web,","Slave_SQL_Running",sWebLanguage)%></td>
		<td id='Slave_SQL_Running' class='admin2'></td>
		<td class='admin'><%=getTran(request,"web,","Last_Debet",sWebLanguage)%></td>
		<td id='Last_Debet' class='admin2'></td>
	</tr>
	<tr height='30px'>
		<td class='admin'><%=getTran(request,"web,","Slave_SQL_Running_State",sWebLanguage)%></td>
		<td id='Slave_SQL_Running_State' class='admin2'></td>
		<td class='admin'><%=getTran(request,"web,","Last_Image",sWebLanguage)%></td>
		<td id='Last_Image' class='admin2'></td>
	</tr>
	<tr height='100px'><td colspan='4' class='admin2'><center><img height='80px' src='<%=sCONTEXTPATH%>/_img/themes/default/replication.gif'/></center></td></tr>
	<tr height='50px'>
		<td class='admin'><%=getTran(request,"web,","Seconds_Behind_Master",sWebLanguage)%></td>
		<td id='Seconds_Behind_Master' class='admin2'></td>
		<td class='admin'><%=getTran(request,"web,","lastupdate",sWebLanguage)%></td>
		<td id='Last_Update' class='admin2'></td>
	</tr>
	<tr height='50px'>
		<td class='admin'><%=getTran(request,"web,","total_active_sessions",sWebLanguage)%></td>
		<td id='activeSessions' class='admin2'></td>
		<td class='admin'><%=getTran(request,"web,","systemload",sWebLanguage)%></td>
		<td id='systemLoad' class='admin2'></td>
	</tr>
</table>

<script>
	function loadReplicationInfo(){
		document.getElementById('Seconds_Behind_Master').innerHTML="<center><img height='10px' src='<%=sCONTEXTPATH %>/_img/themes/default/ajax-loader.gif'/></center>";
	    var url = '<c:url value="/util/getReplicationInfo.jsp"/>';
	    new Ajax.Request(url,{
	      parameters: "",
	      onSuccess: function(resp){
	        var info = eval('('+resp.responseText+')');
	        document.getElementById('Slave_IO_Running').innerHTML='<b>'+info.Slave_IO_Running+'</b>';
	        document.getElementById('Slave_SQL_Running').innerHTML='<b>'+info.Slave_SQL_Running+'</b>';
	        document.getElementById('Slave_SQL_Running_State').innerHTML='<b>'+info.Slave_SQL_Running_State+'</b>';
	        var color='lightgreen';
	        var textcolor='white';
	        if(info.Seconds_Behind_Master*1>3600){
	        	color='red';
	        }
	        else if(info.Seconds_Behind_Master*1>60){
	        	color='yellow';
	        	textcolor='black';
	        }
	        document.getElementById('Seconds_Behind_Master').innerHTML='<center><font style="font-size: 36px;font-weight: bolder;color: '+textcolor+'">'+info.Seconds_Behind_Master+'</font> <font style="font-size: 18px;font-weight: bolder;color: '+textcolor+'">sec</font></center>';
	        document.getElementById('Seconds_Behind_Master').style.backgroundColor=color;
	        document.getElementById('Last_Transaction').innerHTML='<b>'+info.Last_Transaction+'</b>';
	        document.getElementById('Last_Debet').innerHTML='<b>'+info.Last_Debet+'</b>';
	        document.getElementById('Last_Image').innerHTML='<b>'+info.Last_Image+'</b>';
	        document.getElementById('Last_Lab').innerHTML='<b>'+info.Last_Lab+'</b>';
	        document.getElementById('Last_Update').innerHTML='<b>'+info.Last_Update+'</b>';
	        document.getElementById('activeSessions').innerHTML='<center><font style="font-size: 36px;font-weight: bolder">'+info.activesessions+'</font></center>';
	        document.getElementById('systemLoad').innerHTML='<center><font style="font-size: 36px;font-weight: bolder">'+info.systemload+'</font></center>';
	        window.setTimeout("loadReplicationInfo()",5000);
	      }
	    });
	  }
	function skipError(){
	    var url = '<c:url value="/util/skipReplicationError.jsp"/>';
	    new Ajax.Request(url,{
	      parameters: "",
	      onSuccess: function(resp){
	        loadReplicationInfo();
	      }
	    });
	}
	  
	  loadReplicationInfo();
	  window.setTimeout("window.location.reload()",120000);
</script>