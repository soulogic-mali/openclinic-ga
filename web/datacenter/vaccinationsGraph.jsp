<%@page import="be.openclinic.datacenter.*,be.openclinic.medical.*" %>
<%@ page import="be.mxs.common.util.system.HTMLEntities" %>
<%@ page import="java.util.Date" %>
<%@include file="/includes/validateUser.jsp"%>
<%
	int serverId=Integer.parseInt(request.getParameter("serverid"));
	String type=request.getParameter("vaccinationtype");
	List lValues = Vaccination.getListValueGraph(serverId,type,sWebLanguage,activeUser.userid);

    String sJsArray = "[";
    for(Iterator it=lValues.iterator();it.hasNext();){
        Object[] o = (Object[])it.next();
        Date dDate = (Date)o[0];
        Integer iValue = (Integer)o[1];
        sJsArray+="["+dDate.getTime()+","+iValue+"],";
    }
    sJsArray+="]";
%>
<div style="float:left;padding-left:20px;">
<div id="barchart" style="width: 620px; height: 300px; position: relative;"></div>
    <div style="float:left;height:30px;font-size:15px;text-align:center;width:100%;"><%=ScreenHelper.getTranNoLink("web", "time", sWebLanguage)%></div>
</div>
<script>
    setGraph(<%=sJsArray%>);
    Modalbox.setTitle("<%=HTMLEntities.htmlentities(getTran(request,"datacenterserver", serverId + "", sWebLanguage)+"<br/>"+getTran(request,"web",type,sWebLanguage))%>");
</script>