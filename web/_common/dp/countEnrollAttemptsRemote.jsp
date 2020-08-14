<%@include file="/includes/helper.jsp"%>
<%
	if(request.getParameter("initiate")!=null){
		MedwanQuery.getInstance().getCountersInUse().put("enrollcounter",0);
	}
	int count=0;
	if(MedwanQuery.getInstance().getCountersInUse().get("enrollcounter")!=null){
		count=(Integer)MedwanQuery.getInstance().getCountersInUse().get("enrollcounter");
	}
%>
{
	"count":"<%=count%>"
}