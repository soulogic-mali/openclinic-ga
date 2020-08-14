<%@ page import="be.mxs.common.util.system.HTMLEntities" %>
<%@page import="sun.misc.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>
<%!
    //--- ENCODE ----------------------------------------------------------------------------------
    public String encode(String sValue) {
        BASE64Encoder encoder = new BASE64Encoder();
        return encoder.encodeBuffer(sValue.getBytes());
    }

    //--- DECODE ----------------------------------------------------------------------------------
    public String decode(String sValue) {
        String sReturn = "";
        BASE64Decoder decoder = new BASE64Decoder();

        try {
            sReturn = new String(decoder.decodeBuffer(sValue));
        }
        catch (Exception e) {
            Debug.println("User decoding error: "+e.getMessage());
        }

        return sReturn;
    }
%>

<%
    String editOldLabelID   = checkString(request.getParameter("EditOldLabelID")).toLowerCase(),
           editOldLabelType = checkString(request.getParameter("EditOldLabelType")).toLowerCase();

    String tmpLang, sOutput = "", sEditShowlink = "", sValue;
    Label label = null;
    // supported languages
    String supportedLanguages = MedwanQuery.getInstance().getConfigString("supportedLanguages");
    if(supportedLanguages.length()==0) supportedLanguages = "nl,fr";

    StringTokenizer tokenizer = new StringTokenizer(supportedLanguages, ",");
    while (tokenizer.hasMoreTokens()) {
        tmpLang = tokenizer.nextToken();
        label = Label.get(editOldLabelType,editOldLabelID,tmpLang);

        if (label!=null){
            sEditShowlink = label.showLink;
            sValue = label.value.replaceAll("\n","<BR>").replaceAll("\r","");
            System.out.println("value="+sValue);
        }
        else {
            sValue = "";
        }

        sOutput += "\"EditLabelValue"+tmpLang.toUpperCase()+"\":\""+sValue.replaceAll("\"","<quot>")+"\",";
    }
    System.out.println(sOutput);
%>
{
<%=sOutput%>
"editShowLink":"<%=sEditShowlink%>"
}
