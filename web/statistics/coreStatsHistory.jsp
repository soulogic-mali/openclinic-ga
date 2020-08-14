<%@page import="be.openclinic.datacenter.TimeGraph" %>
<%@page import="java.util.Date" %>
<%@page import="org.jfree.data.time.Day" %>
<%@page import="be.mxs.common.util.system.HTMLEntities" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%
	String sTitle = "";
	String parameterId = request.getParameter("type");
	
	// revert one year by default
	java.util.Date beginDate = ScreenHelper.parseDate(new SimpleDateFormat("dd/MM/").format(new java.util.Date())+
	                             (Integer.parseInt(new SimpleDateFormat("yyyy").format(new java.util.Date()))-(request.getParameter("fullperiod")==null?1:999)));
	java.util.Date endDate = new java.util.Date(new java.util.Date().getTime()+24*3600*1000);

	List lValues = null;
   	lValues = TimeGraph.getCoreValueGraph(beginDate,endDate,parameterId,sWebLanguage,activeUser.userid);
    sTitle =  HTMLEntities.htmlentities(getTranNoLink("coreparameter", parameterId, sWebLanguage))+
       		(request.getParameter("fullperiod")!=null?" <a href=\\\"javascript:coreValueGraph('"+parameterId+"')\\\">("+
       		ScreenHelper.getTranNoLink("web", "lastyear", sWebLanguage)+")</a>":" <a href=\\\"javascript:coreValueGraphFull('"+parameterId+"')\\\">("+
       		ScreenHelper.getTranNoLink("web", "fullperiod", sWebLanguage)+")</a>");

    String sJsArray = "[";
    for(Iterator it=lValues.iterator();it.hasNext();){
        Object[] o = (Object[])it.next();
        Date dDate = (Date)o[0];
        Double iValue = (Double)o[1];
        sJsArray+="["+dDate.getTime()+","+iValue+"],";
    }
    sJsArray+="]";
%>

<div style="float:left;padding-left:20px;">
    <div id="barchart" style="width: 620px; height: 305px; position: relative;"></div>
        <div style="float:left;height:30px;font-size:15px;text-align:center;width:100%;"><%=ScreenHelper.getTranNoLink("web", "time", sWebLanguage)%><br/><input class='button' type='button' value='<%=getTranNoLink("web","close",sWebLanguage) %>' onclick='Modalbox.hide();'/></div>
    </div>
</div>

<script>
	function setGraph(array){
	    var options = {
	    lines: { show: true },
	    points: { show: false },
	    xaxis: { mode: "time",fillColor:"#00ff00",monthNames:["jan","Fev","Mar","Avr","Mai","Jun","Jul","Aou","Sep","Oct","Nov","Dec"]},
	    selection: { mode: "x" }
	    };
	
	    new Proto.Chart($('barchart'),
	    [
	        {data: array, label: "<%=ScreenHelper.getTranNoLink("web", "time", sWebLanguage)%>"}
	    ],options);
	}

  	setGraph(<%=sJsArray%>);
  	Modalbox.setTitle("<%=sTitle%>");
</script>