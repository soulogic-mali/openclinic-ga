<%@page import="be.mxs.common.util.system.*,be.mxs.common.util.db.*,be.mxs.common.util.io.*"%>
<%
	String translation="";
	try{
		String sourcelanguage = request.getParameter("sourcelanguage");
		String targetlanguage = request.getParameter("targetlanguage");
		String labeltype = request.getParameter("labeltype");
		String labelid = request.getParameter("labelid");
		String sourcelabel = ScreenHelper.getTranNoLink(labeltype, labelid, sourcelanguage);
		if(sourcelabel.equalsIgnoreCase(labelid)){
			sourcelabel = ScreenHelper.getTranNoLink(labeltype, labelid, MedwanQuery.getInstance().getConfigString("baseTranslationLanguage","fr"));
			sourcelanguage=MedwanQuery.getInstance().getConfigString("baseTranslationLanguage","fr");
		}
		translation = GoogleTranslate.translate(MedwanQuery.getInstance().getConfigString("googleTranslateKey","AIzaSyCuCDqEFvqpb2q4hDwm_syqwevWe_ZAPBE"),sourcelanguage,targetlanguage,sourcelabel);
		if(sourcelabel.substring(0, 1)==sourcelabel.substring(0, 1).toUpperCase()){
			translation=translation.substring(0,1).toUpperCase()+(translation.length()<=1?"":translation.substring(1));
		}
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>
{
"translation":"<%=translation%>"
}