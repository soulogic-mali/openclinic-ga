<%@page import="be.openclinic.knowledge.Indication"%>
<%@page import="be.openclinic.medical.Diagnosis"%>
<%@ page import="be.openclinic.finance.*,be.openclinic.adt.Encounter,java.util.*" %>
<%@ page import="java.util.Date" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String uid = checkString(request.getParameter("uid"));
	Debet debet = Debet.get(uid);
	if(request.getParameter("submit")!=null && checkString(request.getParameter("EditDiagnosis")).length()>0){
		debet.setDiagnosisUid(request.getParameter("EditDiagnosis"));
		debet.store();
    	out.println("<script>window.opener.location.reload();window.close();</script>");
    	out.flush();
	}
%>
<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='2'><%=getTran(request,"web","editdiagnosis",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","date",sWebLanguage) %></td>
			<td class='admin2'><%=ScreenHelper.formatDate(debet.getDate()) %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","prestation",sWebLanguage) %></td>
			<td class='admin2'><%=debet.getPrestation().getDescription() %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","quantity",sWebLanguage) %></td>
			<td class='admin2'><%=debet.getQuantity() %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","service",sWebLanguage) %></td>
			<td class='admin2'><%=getTranNoLink("service",debet.getServiceUid(),sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","user",sWebLanguage) %></td>
			<td class='admin2'><%=User.getFullUserName(debet.getUpdateUser()) %></td>
		</tr>
		<tr>
		    <td class="admin" nowrap><%=getTran(request,"Web","indication",sWebLanguage)%>&nbsp;</td>
		    <td class="admin2">
		    	<select class='text' name='EditDiagnosis' id='EditDiagnosis'>
		    		<option/>
		    		<%
		    			Encounter encounter = debet.getEncounter();
		    			if(encounter!=null && encounter.hasValidUid()){
		    				Vector diagnoses = Diagnosis.selectDiagnoses("", "", encounter.getUid(), "", "", "", "", "", "", "", "", "icd10", "OC_DIAGNOSIS_GRAVITY DESC");
		    				for(int n=0;n<diagnoses.size();n++){
		    					Diagnosis diagnosis = (Diagnosis)diagnoses.elementAt(n);
		    					String sSelected="";
		    					if(Indication.isATCCodeIndicatedForICD10Code(debet.getPrestation().getATCCode(), diagnosis.getCode())){
		    						sSelected="selected";
		    					}
		    					out.println("<option "+sSelected+" "+(diagnosis.getUid().equalsIgnoreCase(debet.getDiagnosisUid())?"selected":"")+" value='"+diagnosis.getUid()+"'>"+diagnosis.getCode()+" - "+diagnosis.getLabel(sWebLanguage)+"</option>");
		    				}
		    			}
		    		%>
		    	</select>
		    </td>
		</tr>
	</table>
	<center>
		<input type='submit' class='button' name='submit' value='<%=getTranNoLink("web","save",sWebLanguage) %>'/>
	</center>
</form>