<%@ page import="be.openclinic.adt.*" %>
<%@include file="/includes/validateUser.jsp"%>
<%=sCSSNORMAL %>
<%
	String date = ScreenHelper.formatDate(new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(checkString(request.getParameter("date"))));
%>
<form name='transactionForm'>
	<table width='100%'>
		<tr>
			<td class='admin'><%=getTran(request,"web","date",sWebLanguage) %></td>
			<td class='admin2'>
				<%= ScreenHelper.writeDateField("newdate", "transactionForm", date, true, true, sWebLanguage, sCONTEXTPATH) %>
			</td>
		</tr>
	</table>
	<input onclick='setDate();' type='button' class='button' name='updateButton' value='<%=getTranNoLink("web","update",sWebLanguage) %>'/>
</form>

<script>
	function setDate(){
		var d = document.getElementById("newdate").value;
		window.opener.calendar.gotoDate(d.split("/")[2]+"-"+d.split("/")[1]+"-"+d.split("/")[0]);
		window.opener.calendar.render();
		window.opener.renderEvents();
		window.close();
	}
</script>