<%@page import="be.openclinic.finance.Insurance"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%!
    //--- CONDITIONAL INCLUDE ---------------------------------------------------------------------
    private void conditionalInclude(String page, PageContext pageContext, String accessright, User user){
        if(user.getAccessRight(accessright)){
            ScreenHelper.setIncludePage(customerInclude(page),pageContext);
        }
    }
%>

<table id='table1' width='100%' height='100%'>
	<tr>
		<td id='td1' style="vertical-align:top;" height="100%" width="50%">
			<div id='insurance'>
			<%conditionalInclude("curative/insuranceStatusCompact.jsp",pageContext,"financial.balance.select",activeUser);%>
			</div>
			<%
				if(Insurance.getDefaultInsuranceForPatientLimited(activePatient.personid)!=null && Insurance.getDefaultInsuranceForPatientLimited(activePatient.personid).isAuthorized() && (activePatient.isDead()==null || activeUser.getAccessRightNoSA("deceasedpatient.add"))){
			%>
			<center><input type='button' class='button' id='prestationsButton' name='prestationsButton' value='=> <%=getTranNoLink("web","prestations",sWebLanguage)%>' onclick='showPrestations();'/></center>
			<%
				}
			%>
			<div id='prestations' style='display: none'>
			<%conditionalInclude("curative/prestationsCompact.jsp",pageContext,"financial.debet.add",activeUser);%>
			</div>
		</td>
		<td id='td2' style="vertical-align:top;" height="100%" width='50%'>
			<div id='payment' style='display: none'>
			<%conditionalInclude("curative/paymentCompact.jsp",pageContext,"financial.debet.add",activeUser);%>
			</div>
		</td>
	</tr>
</table>

<script>
	function showPrestations(){
		//todo: show prestations div
		document.getElementById('insurance').style.display='none';
		document.getElementById('prestations').style.display='';
		document.getElementById('payment').style.display='';
		document.getElementById('prestationsButton').style.display='none';
		document.getElementById('prestationname').focus();
  	    checkEncounterType();
	}
</script>