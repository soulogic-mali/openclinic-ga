<%@page import="be.openclinic.medical.Problem,
                java.util.Vector"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<table width="100%" cellspacing="0">
    <tr class="admin">
        <td colspan="3">
            <%=getTran(request,"web.occup","medwan.common.problemlist",sWebLanguage)%>&nbsp;
            <a href="javascript:showProblemlist();"><img src="<c:url value='/_img/icons/icon_edit.png'/>" class="link" alt="<%=getTranNoLink("web","editproblemlist",sWebLanguage)%>" style="vertical-align:-4px;"></a>
        </td>
    </tr>
    
    <%
        Vector activeProblems = Problem.getActiveProblems(activePatient.personid);
        Problem activeProblem;

        if(activeProblems.size() > 0){
	        for(int n=0; n<activeProblems.size(); n++){
	            activeProblem = (Problem)activeProblems.elementAt(n);
	           
	            String sCode = "";
	            if(activeProblem.getCode()!=null && activeProblem.getCode().length()>0){
	            	sCode = (MedwanQuery.getInstance().getCodeTran(activeProblem.getCodeType()+"code"+activeProblem.getCode(),sWebLanguage));
	            }
	            
	            // controleren op toegangsrecht-restricties voor deze diagnose
	            if(activeUser.getAccessRight("occup.restricteddiagnosis.select") || !MedwanQuery.getInstance().isRestrictedDiagnosis(activeProblem.getCodeType(),activeProblem.getCode())){
	                out.print("<tr valign='top'>"+
	                           "<td><b>"+activeProblem.getCode()+"</b></td>"+
	                           "<td><b>"+sCode.trim()+"</b><i>"+(sCode.trim().length()>0?" ":"")+checkString(activeProblem.getComment()).trim()+"</i></td>"+
	                           "<td>"+ScreenHelper.stdDateFormat.format(activeProblem.getBegin())+"</td>"+
	                          "</tr>");
	            }
	            else{
	                out.print("<tr valign='top'>"+
	                           "<td style='{color: red}'><b><i>!!!</i></b></td>"+
	                           "<td style='{color: red}'><b><i>"+getTran(request,"web","diagnosis.restrictedaccess",sWebLanguage).toUpperCase()+"</i></td>"+
	                           "<td>"+ScreenHelper.stdDateFormat.format(activeProblem.getBegin())+"</td>"+
	                          "</tr>");
	            }
	        }
        }
        Vector inactiveProblems = Problem.getInactiveProblems(activePatient.personid);
        Problem inactiveProblem;

        if(inactiveProblems.size() > 0){
	        for(int n=0; n<inactiveProblems.size(); n++){
	            inactiveProblem = (Problem)inactiveProblems.elementAt(n);
	           
	            String sCode = "";
	            if(inactiveProblem.getCode()!=null && inactiveProblem.getCode().length()>0){
	            	sCode = (MedwanQuery.getInstance().getCodeTran(inactiveProblem.getCodeType()+"code"+inactiveProblem.getCode(),sWebLanguage))+" ("+getTran(request,"web","inactive",sWebLanguage)+")";
	            }
	            
	            // controleren op toegangsrecht-restricties voor deze diagnose
	            if(activeUser.getAccessRight("occup.restricteddiagnosis.select") || !MedwanQuery.getInstance().isRestrictedDiagnosis(inactiveProblem.getCodeType(),inactiveProblem.getCode())){
	                out.print("<tr valign='top' style='color: grey'>"+
	                           "<td>"+inactiveProblem.getCode()+"</td>"+
	                           "<td>"+sCode.trim()+"<i>"+(sCode.trim().length()>0?" ":"")+checkString(inactiveProblem.getComment()).trim()+"</i></td>"+
	                           "<td>"+ScreenHelper.stdDateFormat.format(inactiveProblem.getBegin())+"</td>"+
	                          "</tr>");
	            }
	            else{
	                out.print("<tr valign='top'>"+
	                           "<td style='{color: red}'><b><i>!!!</i></b></td>"+
	                           "<td style='{color: red}'><b><i>"+getTran(request,"web","diagnosis.restrictedaccess",sWebLanguage).toUpperCase()+"</i></td>"+
	                           "<td>"+ScreenHelper.stdDateFormat.format(inactiveProblem.getBegin())+"</td>"+
	                          "</tr>");
	            }
	        }
        }

        // vertical pusher
        %><tr height="99%"><td/></tr><%
    %>
</table>
