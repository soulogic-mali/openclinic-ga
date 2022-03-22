<%@ page import="be.mxs.common.util.system.HTMLEntities" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>
<%
	Debug.println(1);
    String editOldLabelID   = checkString(request.getParameter("EditOldLabelID")).toLowerCase(),
           editOldLabelType = checkString(request.getParameter("EditOldLabelType")).toLowerCase();

    String tmpLang, sOutput = "", sEditShowlink = "", sValue;
    Label label = null;
    // supported languages
    String supportedLanguages = MedwanQuery.getInstance().getConfigString("supportedLanguages");
    if(supportedLanguages.length()==0) supportedLanguages = "nl,fr";
	Debug.println(2);

    StringTokenizer tokenizer = new StringTokenizer(supportedLanguages, ",");
    while (tokenizer.hasMoreTokens()) {
        tmpLang = tokenizer.nextToken();
    	Debug.println(3);
        label = Label.get(editOldLabelType,editOldLabelID,tmpLang);
    	Debug.println(4);

        if (label!=null){
            sEditShowlink = label.showLink;
            sValue = label.value.replaceAll("\n","<BR>").replaceAll("\r","");
        }
        else {
            sValue = "";
        }
    	Debug.println(5);
        sOutput += "\"EditLabelValue"+tmpLang.toUpperCase()+"\":\""+sValue.replaceAll("\"","<quot>")+"\",";
    	Debug.println(6);
    }
%>
{
<%=sOutput%>
"editShowLink":"<%=sEditShowlink%>"
}
