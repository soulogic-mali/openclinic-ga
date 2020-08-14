<%@page import="be.openclinic.pharmacy.*,
                java.io.*,
                be.mxs.common.util.system.*,
                be.mxs.common.util.pdf.general.*,
                org.dom4j.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	long day = 24*3600*1000;
	long year = 365*day;
	String sBegin = new SimpleDateFormat("01/MM/yyyy").format(Miscelaneous.addMonthsToDate(new java.util.Date(), -1));
	String sEnd = ScreenHelper.formatDate(new java.util.Date(Miscelaneous.addMonthsToDate(ScreenHelper.parseDate(sBegin),1).getTime()-100));
	if(request.getParameter("begin")!=null){
		sBegin=request.getParameter("begin");
	}
	if(request.getParameter("end")!=null){
		sBegin=request.getParameter("end");
	}
	
	// US-date
    if(ScreenHelper.stdDateFormat.toPattern().equals("MM/dd/yyyy")){
        sEnd = "12/31/"+(Integer.parseInt(new SimpleDateFormat("yyyy").format(new java.util.Date()))-1);
    }

    /// DEBUG ////////////////////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
    	Debug.println("\n****** statistics/pharmacy/getServiceIncomingStockOperationsPerCategoryItem.jsp *******");
    	Debug.println("sBegin          : "+sBegin);
    	Debug.println("sEnd            : "+sEnd+"\n");
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
%>
<form name='transactionForm' method='post'>
	<table width="100%" cellpadding="0" cellspacing="1" class="list">
	    <%-- PERIOD --%>
		<tr>
			<td class='admin2'>
				<%=getTran(request,"web","from",sWebLanguage)%> <%=writeDateField("FindBeginDate","transactionForm",sBegin,sWebLanguage)%>
				<%=getTran(request,"web","to",sWebLanguage)%> <%=writeDateField("FindEndDate","transactionForm",sEnd,sWebLanguage)%>
			</td>
			<td class='admin2'>
				<input type='button' class="button" name='execute' value='<%=getTranNoLink("web","execute",sWebLanguage)%>' onclick='printReport();'/>
			</td>
		</tr>
	</table>
</form>

<script>
  function printReport(){
	openPopup('<c:url value="util/timeFilterReportGenerator.jsp"/>&begin='+document.getElementById('FindBeginDate').value+'&end='+document.getElementById('FindEndDate').value,600,400,"OpenClinicReport");
	window.close();
  }
</script>