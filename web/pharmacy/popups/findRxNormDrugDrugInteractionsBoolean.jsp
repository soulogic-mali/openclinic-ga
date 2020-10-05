<%@ page import="be.openclinic.pharmacy.*,java.io.*,org.dom4j.*,org.dom4j.io.*,be.mxs.common.util.io.*,org.apache.commons.httpclient.*,org.apache.commons.httpclient.methods.*,be.mxs.common.util.db.*,be.mxs.common.util.system.*,be.openclinic.finance.*,net.admin.*,java.util.*,java.text.*,be.openclinic.adt.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	boolean bWaitingList = checkString(request.getParameter("waitinglist")).equalsIgnoreCase("1");
	boolean bHasInteractions = false;
	try{	
		SortedMap sm = null;
		if(request.getParameter("key")!=null){
			String key=checkString(request.getParameter("key"));
			while(key.indexOf(";;")>-1){
				key=key.replaceAll(";;",";");
			}
			key=key.replaceAll(";", "+");
			sm = Utils.getDrugDrugInteractions(key);
			bHasInteractions = sm.size()>0;
		}
		else {
			sm=Utils.getPatientDrugDrugInteractions(activePatient.personid,bWaitingList);
			bHasInteractions = sm.size()>0;
		}
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>
{
	"interactionsexist": "<%=bHasInteractions?1:0 %>"
}
