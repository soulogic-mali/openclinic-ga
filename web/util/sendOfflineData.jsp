<%@page import="be.mxs.common.util.db.PersonMerger"%>
<%@page import="org.apache.poi.util.DocumentHelper"%>
<%@page import="org.apache.commons.httpclient.*,org.apache.commons.httpclient.methods.*,java.io.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<table width='100%'>
	<tr class='admin'><td colspan='2'>Synchronizing offline data...</td></tr>
<%
	String xml="",objecttype="";
	boolean bComplete=true,bInitialized=false;;
	Connection conn = SH.getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from oc_sync where processed is null order by created");
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		bInitialized=true;
		String type = rs.getString("type");
		String oldid = rs.getString("oldid");
		java.util.Date created = rs.getTimestamp("created");
		if(type.equalsIgnoreCase("admin")){
			AdminPerson person = AdminPerson.getAdminPerson(oldid);
			out.println("<tr><td class='admin' width='1%'>"+oldid+"&nbsp;</td><td class='admin2'>Patient record <b>"+person.getFullName()+"</b> created on "+SH.formatDate(created, SH.fullDateFormatSS)+"</td></tr>");
			out.flush();
			xml = person.toXml();
			objecttype="admin";
		}
		else if(type.equalsIgnoreCase("encounter")){
    		MedwanQuery.getInstance().getObjectCache().removeObject("encounter", SH.getServerId()+"."+oldid);
			Encounter encounter = Encounter.get(SH.getServerId()+"."+oldid);
			out.println("<tr><td class='admin' width='1%'>"+oldid+"&nbsp;</td><td class='admin2'>Patient encounter at <b>"+getTranNoLink("service",encounter.getServiceUID(),sWebLanguage)+"</b> for <b>"+encounter.getPatient().getFullName()+"</b> created on "+SH.formatDate(created, SH.fullDateFormatSS)+"</td></tr>");
			out.flush();
			xml=encounter.toXml();
			objecttype="encounter";
		}
		else if(type.equalsIgnoreCase("transaction")){
    		MedwanQuery.getInstance().getObjectCache().removeObject("transaction", SH.getServerId()+"."+oldid);
			TransactionVO transaction = TransactionVO.get(SH.getServerId(), Integer.parseInt(oldid));
			out.println("<tr><td class='admin' width='1%'>"+oldid+"&nbsp;</td><td class='admin2'>Transaction <b>"+getTranNoLink("web.occup",transaction.getTransactionType(),sWebLanguage)+"</b> for <b>["+transaction.getPatient().personid+"] "+transaction.getPatient().getFullName()+"</b> created on "+SH.formatDate(created, SH.fullDateFormatSS)+"</td></tr>");
			out.flush();
			xml = transaction.toXml();
			objecttype="transaction";
		}
		//Send object to destination server
		HttpClient client = new HttpClient();
		PostMethod method = new PostMethod(SH.cs("offlineSyncServerAPI","http://localhost/openclinic/api/postOfflineData.jsp"));
		NameValuePair[] nvp = new NameValuePair[3];
		nvp[0]= new NameValuePair("objecttype",objecttype);
		nvp[1]= new NameValuePair("xml",xml);
		nvp[2]= new NameValuePair("updateuser",activeUser.userid);
		method.setQueryString(nvp);
		String authStr = SH.cs("offlineSyncServer.username", "nil") + ":" + SH.cs("offlineSyncServer.password", "nil");
		String authEncoded = Base64.getEncoder().encodeToString(authStr.getBytes());
	    method.setRequestHeader("Authorization", "Basic "+authEncoded);
		try{
			int statusCode = client.executeMethod(method);
			String sResponse=method.getResponseBodyAsString();
			Document doc = org.dom4j.DocumentHelper.parseText(sResponse);
			Element eResponse = doc.getRootElement();
			if(eResponse.attributeValue("type").equalsIgnoreCase("admin")){
				new PersonMerger().update(Integer.parseInt(eResponse.attributeValue("newid")), Integer.parseInt(eResponse.attributeValue("oldid")), false);
				out.println("<tr><td><img src='"+sCONTEXTPATH+"/_img/icons/icon_check.png'/></td><td class='admin'>Updated to "+eResponse.attributeValue("newid")+"</td></tr>");
				SH.updateSync("admin", eResponse.attributeValue("oldid"), eResponse.attributeValue("newid"));
			}
			else if(eResponse.attributeValue("type").equalsIgnoreCase("encounter")){
				Encounter.updateEncounterUid(SH.getServerId()+"."+eResponse.attributeValue("oldid"), SH.getServerId()+"."+eResponse.attributeValue("newid"));
				out.println("<tr><td><img src='"+sCONTEXTPATH+"/_img/icons/icon_check.png'/></td><td class='admin'>Updated to "+eResponse.attributeValue("newid")+"</td></tr>");
				SH.updateSync("encounter", eResponse.attributeValue("oldid"), eResponse.attributeValue("newid"));
			}
			else if(eResponse.attributeValue("type").equalsIgnoreCase("transaction")){
				TransactionVO.updateTransactionUid(SH.getServerId()+"."+eResponse.attributeValue("oldid"), SH.getServerId()+"."+eResponse.attributeValue("newid"));
				out.println("<tr><td><img src='"+sCONTEXTPATH+"/_img/icons/icon_check.png'/></td><td class='admin'>Updated to "+eResponse.attributeValue("newid")+"</td></tr>");
				SH.updateSync("transaction", eResponse.attributeValue("oldid"), eResponse.attributeValue("newid"));
			}
			else if(eResponse.attributeValue("type").equalsIgnoreCase("error")){
				out.println("<tr><td><img src='"+sCONTEXTPATH+"/_img/icons/icon_error.gif'/></td><td class='adminred'>Error detected: <b>"+eResponse.attributeValue("message")+"</b>. Process stopped.</td></tr>");	
				bComplete=false;
				break;
			}
		}
		catch(Exception e){
			out.println("<tr><td><img src='"+sCONTEXTPATH+"/_img/icons/icon_error.gif'/></td><td class='adminred'>Error detected: <b>Could not connect to "+SH.cs("offlineSyncServerAPI","http://localhost/openclinic/api/postOfflineData.jsp")+"</b>. Process stopped. Please check URL and API credentials.</td></tr>");	
			bComplete=false;
		}
	}
	ps.close();
	conn.close();
	if(!bInitialized){
		out.println("<tr><td class='admin2' colspan='2'>No data in synchronization queue.</td></tr>");	
	}
%>
		<tr class='admin'><td colspan='2'>...End of synchronization</td></tr>
</table>
<p/>
<% 	if(bComplete){ %>
	<center>
		<input class='button' type='button' name='syncButtonPartial' value='<%=getTranNoLink("web","partialofflineserverdata",sWebLanguage)%>' onclick='partialOfflineServerData()'/>&nbsp;
		<input class='button' type='button' name='syncButtonFull' value='<%=getTranNoLink("web","fullofflineserverdata",sWebLanguage)%>' onclick='fullOfflineServerData()'/>
	</center>
<%	} %>
<script>
	function fullOfflineServerData(){
		window.location.href='<%=sCONTEXTPATH%>/main.do?Page=util/fullServerCopy.jsp';
	}
	function partialOfflineServerData(){
		window.location.href='<%=sCONTEXTPATH%>/main.do?Page=util/partialServerCopy.jsp';
	}
</script>

