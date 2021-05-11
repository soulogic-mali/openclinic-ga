<%
	String e = (String)session.getAttribute("sptexit");
	if(e==null){
		e="";
	}
	session.removeAttribute("sptexit");
%>
{
	"sptexit" : "<%=e.split(";")[0] %>",
	"sptpath" : "<%=e.split(";").length<=1?"":e.split(";")[1] %>"
}