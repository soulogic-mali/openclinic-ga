<%@ page import="be.openclinic.pharmacy.*,java.io.*,be.mxs.common.util.system.*,be.mxs.common.util.pdf.general.*,org.dom4j.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sServiceStockId=checkString(request.getParameter("ServiceStockUid"));
	String sReport=checkString(request.getParameter("report"));
%>
	<form name='transactionForm' method='post'>
		<table width='100%'>
			<tr>
				<td class='admin2'>
					<%=getTran(request,"web","begin",sWebLanguage)%>
				</td>
				<td class='admin2'>
					<%=writeDateField("FindBegin", "transactionForm", ScreenHelper.formatDate(new java.util.Date()), sWebLanguage)%>
				</td>
			</tr>
			<tr>
				<td class='admin2'>
					<%=getTran(request,"web","end",sWebLanguage)%>
				</td>
				<td class='admin2'>
					<%=writeDateField("FindEnd", "transactionForm", ScreenHelper.formatDate(new java.util.Date()), sWebLanguage)%>
				</td>
			</tr>
			<tr>
				<td class='admin2'>
					<%=getTran(request,"web","service",sWebLanguage)%>
				</td>
				<td class='admin2'>
                    <input type='hidden' name='serviceid' id='serviceid'>
                    <input class='text' type='text' name='servicename' id='servicename' readonly size='<%=sTextWidth%>' value=''>&nbsp;
                    <img src='_img/icons/icon_search.png' class='link' alt='<%=getTranNoLink("Web","select",sWebLanguage)%>' onclick='searchService("serviceid","servicename");'>&nbsp;
                    <img src='_img/icons/icon_delete.png' class='link' alt='<%=getTranNoLink("Web","clear",sWebLanguage)%>' onclick='serviceid.value="";servicename.value="";'>
				</td>
			</tr>
			<tr>
				<td class='admin2' colspan='2'>
					<input type='button' class="button" name='execute' value='<%=getTranNoLink("web","execute",sWebLanguage)%>' onclick='printReport();'/>
				</td>
			</tr>
		</table>
	</form>

	<script>
		function printReport(){
			window.open('<c:url value="pharmacy/getProductionReports.jsp"/>?begin='+document.getElementById('FindBegin').value+'&end='+document.getElementById('FindEnd').value+'&servicestockuid='+document.getElementById('serviceid').value+'&report=<%=sReport%>');
			window.close();
		}
		function searchService(serviceUidField,serviceNameField){
		    openPopup("_common/search/searchService.jsp&ts=<%=getTs()%>&showinactive=1&VarCode="+serviceUidField+"&VarText="+serviceNameField);
		    document.getElementsByName(serviceNameField)[0].focus();
		}

	</script>