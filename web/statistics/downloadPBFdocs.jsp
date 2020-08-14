<%@page import="be.openclinic.pharmacy.*,be.openclinic.medical.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sQuery=request.getParameter("query");
	String sDb=request.getParameter("db");
	String sBegin=request.getParameter("begin");
	String sEnd=request.getParameter("end");
%>
<table width='100%'>
	<%if(!checkString(request.getParameter("noservice")).equalsIgnoreCase("yes")){ %>
	<tr>
		<td class='admin'><%=getTran(request,"web","service",sWebLanguage) %></td>
		<td class='admin2'>
             <input type="hidden" name="doctor" id='doctor' value="">
             <input type='hidden' name='service' id='service' value=''>
             <input class='text' type='text' name='servicename' id='servicename' readonly size='40' value=''>
             <img src='_img/icons/icon_search.png' class='link' alt='<%=getTranNoLink("Web","select",sWebLanguage)%>' onclick='searchService();'>
             <img src='_img/icons/icon_delete.png' class='link' alt='<%=getTranNoLink("Web","clear",sWebLanguage)%>' onclick='clearService();'>
		</td>
	</tr>
<% 	}
	else{
%>
             <input type="hidden" name="doctor" id='doctor' value="">
             <input type='hidden' name='service' id='service' value=''>
<%
	}
	if(checkString(request.getParameter("insurer")).equalsIgnoreCase("yes")){ %>
	<tr>
		<td class='admin'><%=getTran(request,"web","insurer",sWebLanguage) %></td>
		<td class='admin2'>
            <input type="hidden" name="EditInsurarUID" id="EditInsurarUID" value="">
            <input type="text" class="text" readonly name="EditInsurarText" id="EditInsurarText" value="" size="40">
            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchInsurar();">
            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="doClearInsurar()">
		</td>
	</tr>
<% 	}
	if("pbf.burundi.consultationslist*cnrkr.burundi.consultationslist".contains(checkString(request.getParameter("query")))){%>
	<tr>
		<td class='admin'><%=getTran(request,"web","physician",sWebLanguage) %></td>
		<td class='admin2'>
                <input class="text" type="text" name="doctorname" id="doctorname" readonly size="40" value="">
                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTran(null,"web","select",sWebLanguage)%>" onclick="searchManager('doctor','doctorname');">
                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTran(null,"web","clear",sWebLanguage)%>" onclick="document.getElementById('doctor').value='';document.getElementById('doctorname').value='';">
		</td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","include",sWebLanguage) %></td>
		<td class='admin2'>
			<table>
				<tr><td><input type="checkbox" name="includevisits" id="includevisits" checked value="1"/><%=getTran(request,"web","visits",sWebLanguage) %></td></tr>
				<tr><td><input type="checkbox" name="includeadmissions" id="includeadmissions" value="1"/><%=getTran(request,"web","admissions",sWebLanguage) %></td></tr>
				<tr><td><hr/></td></tr>
				<tr><td><input type="checkbox" name="diagsicd10" id="diagsicd10" checked value="1"/><%=getTran(request,"web","icd10diagnoses",sWebLanguage) %></td></tr>
				<tr><td><input type="checkbox" name="diagsrfe" id="diagsrfe" value="1"/><%=getTran(request,"web","rfes",sWebLanguage) %></td></tr>
				<tr><td><input type="checkbox" name="diagsfreetext" id="diagsfreetext" value="1"/><%=getTran(request,"web","freetextdiagnoses",sWebLanguage) %></td></tr>
			</table>
		</td>
	</tr>

<%	} 
	else if("pbf.burundi.surgerylist".contains(checkString(request.getParameter("query")))){%>
	<tr>
		<td class='admin'><%=getTran(request,"web","include",sWebLanguage) %></td>
		<td class='admin2'>
			<table>
				<tr><td><input type="checkbox" name="diagsicd10" id="diagsicd10" checked value="1"/><%=getTran(request,"web","icd10diagnoses",sWebLanguage) %></td></tr>
				<tr><td><input type="checkbox" name="diagsrfe" id="diagsrfe" value="1"/><%=getTran(request,"web","rfes",sWebLanguage) %></td></tr>
				<tr><td><input type="checkbox" name="diagsfreetext" id="diagsfreetext" value="1"/><%=getTran(request,"web","freetextdiagnoses",sWebLanguage) %></td></tr>
			</table>
		</td>
	</tr>
<%	}
	else if(checkString(request.getParameter("query")).startsWith("pbf.burundi.lab")){%>
	<tr>
		<td class='admin'><%=getTran(request,"web","labanalysis",sWebLanguage) %></td>
		<td class='admin2'>
			<%
				String labanalysis = MedwanQuery.getInstance().getConfigString(request.getParameter("query"), "unknownexam");
				if(labanalysis.equalsIgnoreCase("unknownexam")){
					out.println(getTranNoLink("web","definelabexamparameter",sWebLanguage)+": <b>"+request.getParameter("query")+"</b>");
				}
				else{
					LabAnalysis analysis = LabAnalysis.getLabAnalysisByLabcode(labanalysis);
					if(analysis==null){
						out.println(getTranNoLink("web","definelabexamparameter",sWebLanguage)+": <b>"+request.getParameter("query")+"</b>");
					}
					else{
						out.println("["+analysis.getLabcode()+"] "+getTran(request,"labanalysis",analysis.getLabId()+"",sWebLanguage));
					}
				}
			%>
		</td>
	</tr>
<%	}
%>
	<tr>
		<td colspan='2'><input type='button' name='find' value='<%=getTran(null,"web","find",sWebLanguage) %>' onclick='findinvoices();'/></td>
	</tr>
</table>

<script>
	function findinvoices(){
		url="<c:url value='/util/csvStats.jsp?'/>query=<%=sQuery%>&db=<%=sDb%>&begin=<%=sBegin%>&end=<%=sEnd%>&doctor="+document.getElementById('doctor').value+"&service="+document.getElementById('service').value;
		if(document.getElementById('includeadmissions') && document.getElementById('includeadmissions').checked) {
			url+="&includeadmissions="+document.getElementById('includeadmissions').value;
		}
		if(document.getElementById('includevisits') && document.getElementById('includevisits').checked) {
			url+="&includevisits="+document.getElementById('includevisits').value;
		}
		if(document.getElementById('diagsicd10') && document.getElementById('diagsicd10').checked) {
			url+="&diagsicd10="+document.getElementById('diagsicd10').value;
		}
		if(document.getElementById('diagsrfe') && document.getElementById('diagsrfe').checked) {
			url+="&diagsrfe="+document.getElementById('diagsrfe').value;
		}
		if(document.getElementById('diagsfreetext') && document.getElementById('diagsfreetext').checked) {
			url+="&diagsfreetext="+document.getElementById('diagsfreetext').value;
		}
		if(document.getElementById('EditInsurarUID') && document.getElementById('EditInsurarUID').value.length>0) {
			url+="&insureruid="+document.getElementById('EditInsurarUID').value;
		}
		window.open(url);
		window.close();
	}

	function clearService(){
		document.getElementById('service').value='';
		document.getElementById('servicename').value='';
	}
	
	function searchService(){
	  	url="_common/search/searchService.jsp&ts=<%=getTs()%>&showinactive=1&VarCode=service&VarText=servicename";
	  	openPopup(url);
	  	document.getElementsByName(serviceNameField)[0].focus();
	}

	function searchManager(managerUidField,managerNameField){
	  openPopup("/_common/search/searchUser.jsp&ts=<%=getTs()%>&ReturnUserID="+managerUidField+"&ReturnName="+managerNameField+"&displayImmatNew=no");
	  document.getElementById('doctorname').focus();
	}

	function searchInsurar(){
	  openPopup("/_common/search/searchInsurar.jsp&ts=<%=getTs()%>&ReturnFieldInsurarUid=EditInsurarUID&ReturnFieldInsurarName=EditInsurarText&PopupHeight=500&PopupWith=500");
	}

	function doClearInsurar(){
	  document.getElementById('EditInsurarUID').value = "";
	  document.getElementById('EditInsurarText').value = "";
	}


</script>
