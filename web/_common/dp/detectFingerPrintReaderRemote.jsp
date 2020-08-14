<%@page import="be.mxs.common.util.io.*,com.digitalpersona.uareu.*"%>
<%
	DigitalPersona dp = new DigitalPersona();
	Reader reader = dp.getReader();
	String sModel="";
	if(reader!=null){
		sModel=reader.GetDescription().id.product_name;
	}
%>
{
	"model":"<%=sModel%>"
}