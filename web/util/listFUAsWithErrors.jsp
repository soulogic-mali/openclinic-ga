<%@page import="pe.gob.sis.*"%>
<%@page import="org.jnp.interfaces.java.javaURLContextFactory"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String year = checkString(request.getParameter("year"));
	String month = checkString(request.getParameter("month"));
	
	if(year.length()==0){
		year = new SimpleDateFormat("yyyy").format(new java.util.Date());
	}
	if(month.length()==0){
		month = new SimpleDateFormat("M").format(new java.util.Date());
	}
	
	int nyear= Integer.parseInt(year);
	int nmonth= Integer.parseInt(month);
%>
<%=sJSPROTOTYPE %>
<form name="transactionForm" method="post">
	<table width='100%'>
		<tr class='admin'>
			<td colspan='2'><%=getTran(request,"web.manage","sendFUAs",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin' width='1%' nowrap><%=getTran(request,"web","year",sWebLanguage) %>&nbsp;&nbsp;</td>
			<td class='admin2'>
				<select name='year' id='year' class='text' onchange=''>
					<%
						for(int n=nyear; n>nyear-10;n--){
							out.println("<option value='"+n+"'>"+n+"</option>");
						}
					%>
				</select>
			</td>
		</tr>
		<tr>
			<td class='admin' width='1%' nowrap><%=getTran(request,"web","month",sWebLanguage) %>&nbsp;&nbsp;</td>
			<td class='admin2'>
				<select name='month' id='month' class='text' onchange='listFUAs();'>
					<%
						for(int n=1;n<13;n++){
							out.println("<option value='"+n+"' "+(n==nmonth?"selected":"")+">"+n+"</option>");
						}
					%>
				</select>
			</td>
		</tr>
	</table>
</form>
<div id='fualist'/>
<script>
  function listFUAs(){
      var params = "year="+document.getElementById("year").value+
                   "&month="+document.getElementById("month").value+
                   "&error=1";
      var url = '<c:url value="/util/listFUAs.jsp"/>?ts='+new Date().getTime();
      new Ajax.Request(url,{
        method: "POST",
        parameters: params,
        onSuccess: function(resp){
          document.getElementById("fualist").innerHTML = resp.responseText;
        }
      });
  }
  listFUAs();

</script>
