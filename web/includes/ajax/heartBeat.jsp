<%
	String message="";
	String tabid = request.getParameter("tabid");
	if(session.getAttribute("tabid")==null || ((String)session.getAttribute("tabid")).split(";").length<2){
		session.setAttribute("tabid", tabid+";"+new java.text.SimpleDateFormat("yyyyMMddHHmmssSSS").format(new java.util.Date()));
	}
	else if(new java.util.Date().getTime()-new java.text.SimpleDateFormat("yyyyMMddHHmmssSSS").parse(((String)session.getAttribute("tabid")).split(";")[1]).getTime()>5000){
		session.setAttribute("tabid", tabid+";"+new java.text.SimpleDateFormat("yyyyMMddHHmmssSSS").format(new java.util.Date()));
	}
	else if(((String)session.getAttribute("tabid")).split(";")[0].equals(tabid)){
		session.setAttribute("tabid", tabid+";"+new java.text.SimpleDateFormat("yyyyMMddHHmmssSSS").format(new java.util.Date()));
	}
	else {
		message="invalidate";
	}
%>
{
	"action" : "<%=message %>"
}