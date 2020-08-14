<%@page import="java.sql.Statement,
                be.openclinic.statistics.HospitalStats,
                be.openclinic.statistics.BaseChart,
                be.openclinic.statistics.XYValue,
                be.mxs.common.util.system.StatFunctions,
                be.openclinic.common.KeyValue,
                java.text.DecimalFormat,
                java.util.Hashtable,
                java.util.Enumeration,
                java.text.SimpleDateFormat"%>
<%@include file="/includes/validateUser.jsp"%>
               
<%
    String sStart = checkString(request.getParameter("start")),
           sEnd   = checkString(request.getParameter("end"));

	/// DEBUG /////////////////////////////////////////////////////////////////////////////////////
	if(Debug.enabled){
		Debug.println("\n******************** statistics/insuranceStats.jsp ********************");
		Debug.println("sStart : "+sStart);
		Debug.println("sEnd   : "+sEnd+"\n");
	}
	///////////////////////////////////////////////////////////////////////////////////////////////
%>
 
<%=writeTableHeader("web","statistics.insurancestats.distribution",sWebLanguage," doBack()")%>
<div style="padding-top:5px;"/>
 
<%-- 1 - INPATIENTS (admissions) ----------------------------------------------------------------%>               
<table width="100%" class="list" cellspacing="1" cellpadding="0">
	<tr class="admin">
		<td colspan="3"><%=getTran(request,"hospital.statistics","inpatients",sWebLanguage)%></td>
	</tr>
	<tr class="gray">
		<td><%=getTran(request,"hospital.statistics","insurar",sWebLanguage)%></td>
		<td># <%=getTran(request,"hospital.statistics","admissions",sWebLanguage)%></td>
		<td>% <%=getTran(request,"hospital.statistics","total.admissions",sWebLanguage)%></td>
	</tr>

<%
	KeyValue[] kv = HospitalStats.getInsuranceCasesBasic(ScreenHelper.parseDate(sStart),
			                                             ScreenHelper.parseDate(sEnd),"admission");
	double ta = 0;
	for(int n=0; n<kv.length; n++){
		ta+= Double.parseDouble(kv[n].getValue());
	}

	DecimalFormat deci = new DecimalFormat("#.#");
	for(int n=0; n<kv.length; n++){
		out.print("<tr>"+
	               "<td>"+kv[n].getKey()+"</td>"+
				   "<td>"+kv[n].getValue()+"</td>"+
	               "<td>"+deci.format(100*Double.parseDouble(kv[n].getValue())/ta)+"%</td>"+
				  "</tr>");
	}

    %></table><%
    
	if(kv.length > 0){
		%><%=kv.length%> <%=getTran(request,"web","recordsFound",sWebLanguage)%><%
	}
	else{
		%><%=getTran(request,"web","noRecordsFound",sWebLanguage)%><%
    }
%>
<div style="padding-top:5px;"/>

<%-- 2 - OUTPATIENTS (visit) --------------------------------------------------------------------%>
<table width="100%" class="list" cellspacing="1" cellpadding="0">
	<tr class="admin">
		<td colspan="3"><%=getTran(request,"hospital.statistics","outpatients",sWebLanguage)%></td>
	</tr>
	<tr class="gray">
		<td><%=getTran(request,"hospital.statistics","insurar",sWebLanguage)%></td>
		<td># <%=getTran(request,"hospital.statistics","visits",sWebLanguage)%></td>
		<td>% <%=getTran(request,"hospital.statistics","total.visits",sWebLanguage)%></td>
	</tr>

<%
	kv = HospitalStats.getInsuranceCasesBasic(ScreenHelper.parseDate(sStart),
			                                  ScreenHelper.parseDate(sEnd),"visit");
	for(int n=0; n<kv.length; n++){
		ta+= Double.parseDouble(kv[n].getValue());
	}
	
	deci = new DecimalFormat("#.#");
	for(int n=0; n<kv.length; n++){
		out.print("<tr>"+
	               "<td>"+kv[n].getKey()+"</td>"+
				   "<td>"+kv[n].getValue()+"</td>"+
	               "<td>"+deci.format(100*Double.parseDouble(kv[n].getValue())/ta)+"%</td>"+
				  "</tr>");
	}

    %></table><%
    
	if(kv.length > 0){
		%><%=kv.length%> <%=getTran(request,"web","recordsFound",sWebLanguage)%><%
	}
	else{
		%><%=getTran(request,"web","noRecordsFound",sWebLanguage)%><%
    }
%>

<%=ScreenHelper.alignButtonsStart()%>
    <input type="button" class="button" name="backButton" value="<%=getTranNoLink("web","back",sWebLanguage)%>" onClick="doBack();"/>
<%=ScreenHelper.alignButtonsStop()%>

<script>
  <%-- DO BACK --%>
  function doBack(){
    window.location.href = "<c:url value='/main.do'/>?Page=statistics/index.jsp";
  }
</script>