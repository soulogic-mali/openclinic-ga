<%@page import="be.openclinic.pharmacy.*,
                java.io.*,
                be.mxs.common.util.system.*,
                be.mxs.common.util.pdf.general.*,
                org.dom4j.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%
	String sServiceStockId = checkString(request.getParameter("ServiceStockUid"));
	long day = 24*3600*1000;
	long year = 365*day;
	
	String sBegin = "01/01/"+(Integer.parseInt(new SimpleDateFormat("yyyy").format(new java.util.Date()))-1),
		   sEnd   = "31/12/"+(Integer.parseInt(new SimpleDateFormat("yyyy").format(new java.util.Date()))-1);

	// US-date
    if(ScreenHelper.stdDateFormat.toPattern().equals("MM/dd/yyyy")){
        sEnd = "12/31/"+(Integer.parseInt(new SimpleDateFormat("yyyy").format(new java.util.Date()))-1);
    }

    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
    	Debug.println("\n****** statistics/pharmacy/getServiceIncomingStockOperations.jsp ******");
    	Debug.println("sServiceStockId : "+sServiceStockId);
    	Debug.println("sBegin          : "+sBegin);
    	Debug.println("sEnd            : "+sEnd+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
%>
<form name='transactionForm' method='post'>
	<table width="100%" cellpadding="0" cellspacing="1" class="list">
	    <%-- PERIOD --%>
		<tr>
			<td class='admin2' colspan="2">
				<%=getTran(request,"web","from",sWebLanguage)%> <%=writeDateField("FindBeginDate","transactionForm",sBegin,sWebLanguage)%>
				<%=getTran(request,"web","to",sWebLanguage)%> <%=writeDateField("FindEndDate","transactionForm",sEnd,sWebLanguage)%>
			</td>
		</tr>
		<tr>
			<td class='admin2' colspan="2">
				<%=getTran(request,"web","user",sWebLanguage)%>: 
				<select name='userid' id='userid' class='text'>
					<option value=""></option>
					<%
						ServiceStock serviceStock = ServiceStock.get(sServiceStockId);
						if(serviceStock!=null){
							Vector users = serviceStock.getAuthorizedUsers();
							for(int n=0; n<users.size();n++){
								User user = (User)users.elementAt(n);
					  			out.print("<option value='"+user.userid+"'>"+user.person.getFullName()+"</option>");
							}
						}
					%>
				</select>
			</td>
		</tr>
		<tr>
			<td class='admin'>
				<%=getTran(request,"web","format",sWebLanguage)%>
			</td>
			<td class='admin2'>
				<select name='outputformat' id='outputformat' class='text'>
					<option value='pdf'>PDF</option>
					<option value='excel'>Excel</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class='admin2' colspan="2">
				<input type='button' class="button" name='print' value='<%=getTranNoLink("web","print",sWebLanguage)%>' onclick='printReport();'/>
			</td>
		</tr>
	</table>
</form>

<script>
  function printReport(){
	window.open('<c:url value="pharmacy/printServiceIncomingStockOperations.jsp"/>?outputformat='+document.getElementById('outputformat').value+'&FindBeginDate='+document.getElementById('FindBeginDate').value+'&FindEndDate='+document.getElementById('FindEndDate').value+'&ServiceStockUid=<%=sServiceStockId%>&userid='+document.getElementById('userid').value);
	window.close();
  }
</script>