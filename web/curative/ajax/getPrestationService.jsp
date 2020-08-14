<%@page import="be.openclinic.finance.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%
String serviceid="",servicename="",encountertype="";
try{
	System.out.println(SH.p(request,"id")+"----------------------------------------------");
	Prestation prestation = Prestation.get(SH.p(request,"id"));
	if(prestation!=null && SH.c(prestation.getServiceUid()).length()>0){
		serviceid=prestation.getServiceUid();
		if(Service.hasBeds(serviceid)){
			encountertype="admission";
		}
		else if(Service.acceptsVisits(serviceid)){
			encountertype="visit";
		}
		else{
			serviceid="";
		}
		if(serviceid.length()>0){
			Service s = Service.getService(serviceid);
			if(s!=null){
				servicename=s.getLabel(sWebLanguage);
			}
		}
	}
}
catch(Exception e){
	e.printStackTrace();
}
%>
{
	"serviceid" : "<%=serviceid %>",
	"servicename" : "<%=servicename %>",
	"encountertype" : "<%=encountertype %>"
}