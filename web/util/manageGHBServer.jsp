<%@page import="org.dom4j.*,java.io.*,java.nio.charset.StandardCharsets,org.apache.commons.httpclient.methods.multipart.*,java.nio.file.*,org.apache.commons.io.*,org.apache.commons.httpclient.*,org.apache.commons.httpclient.methods.*"%>
<%@page import="be.openclinic.system.Encryption,be.mxs.common.util.system.HTMLEntities"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	if(checkString(request.getParameter("action")).equalsIgnoreCase("submit")){
		//First check if a base url was provided
		String baseurl=checkString(request.getParameter("ghb_ref_baseurl"));
		if(baseurl.length()>0){
			MedwanQuery.getInstance().setConfigString("ghb_ref_baseurl",baseurl);
			MedwanQuery.getInstance().setConfigString("ghb_ref_url",baseurl+"/util/saveGHBServer.jsp");
			MedwanQuery.getInstance().setConfigString("ghb_ref_updateurl",baseurl+"/util/getGHBServers.jsp");
			MedwanQuery.getInstance().setConfigString("ghb_ref_getpubkeyurl",baseurl+"/util/getGHBPubkey.jsp");
			MedwanQuery.getInstance().setConfigString("ghb_ref_storemessageurl",baseurl+"/util/storeGHBMessage.jsp");
			MedwanQuery.getInstance().setConfigString("ghb_ref_countmessagesurl",baseurl+"/util/getGHBMessageCount.jsp");
			MedwanQuery.getInstance().setConfigString("ghb_ref_readmessagesurl",baseurl+"/util/readGHBMessages.jsp");
			MedwanQuery.getInstance().setConfigString("ghb_ref_readmessageurl",baseurl+"/util/readGHBMessage.jsp");
			MedwanQuery.getInstance().setConfigString("ghb_ref_delivermessageurl",baseurl+"/util/deliverGHBMessage.jsp");
		}
		//Submit the data to central server
		HttpClient client = new HttpClient();
		PostMethod post = new PostMethod(MedwanQuery.getInstance().getConfigString("ghb_ref_url","http://www.globalhealthbarometer.net/globalhealthbarometer/util/saveGHBServer.jsp"));
		org.apache.commons.httpclient.methods.multipart.Part[] parts= {
				new StringPart("ghb_ref_serverid",checkString(request.getParameter("ghb_ref_serverid"))),
				new StringPart("ghb_ref_domain",checkString(request.getParameter("ghb_ref_domain"))),
				new StringPart("ghb_ref_name",HTMLEntities.htmlentities(checkString(request.getParameter("ghb_ref_name")))),
				new StringPart("ghb_ref_contact",checkString(request.getParameter("ghb_ref_contact"))),
				new StringPart("ghb_ref_telephone",checkString(request.getParameter("ghb_ref_telephone"))),
				new StringPart("ghb_ref_email",checkString(request.getParameter("ghb_ref_email"))),
				new StringPart("ghb_ref_pubkey",checkString(request.getParameter("ghb_ref_pubkey"))),
				new StringPart("ghb_ref_token",checkString(request.getParameter("ghb_ref_token")).trim()),
				new StringPart("ghb_ref_cryptoken",MedwanQuery.getInstance().getConfigString("ghb_ref_privkey", "").length()==0?"":Encryption.encryptTextWithPrivateKey(request.getParameter("ghb_ref_token").trim(),MedwanQuery.getInstance().getConfigString("ghb_ref_privkey", "")))
			};
		post.setRequestEntity(new MultipartRequestEntity(parts, post.getParams()));
		int statusCode = client.executeMethod(post);
		String sResponse = IOUtils.toString(post.getResponseBodyAsStream(), StandardCharsets.UTF_8);
		if(sResponse.contains("<response")){
			Document document=DocumentHelper.parseText(sResponse.substring(sResponse.indexOf("<response")));
			Element root = document.getRootElement();
			if(root.attributeValue("error").equalsIgnoreCase("0")){
				MedwanQuery.getInstance().setConfigString("ghb_ref_projectdomain",checkString(request.getParameter("ghb_ref_projectdomain")));
				MedwanQuery.getInstance().setConfigString("ghb_ref_domain",checkString(request.getParameter("ghb_ref_domain")));
				MedwanQuery.getInstance().setConfigString("ghb_ref_name",HTMLEntities.htmlentities(checkString(request.getParameter("ghb_ref_name"))));
				MedwanQuery.getInstance().setConfigString("ghb_ref_contact",checkString(request.getParameter("ghb_ref_contact")));
				MedwanQuery.getInstance().setConfigString("ghb_ref_telephone",checkString(request.getParameter("ghb_ref_telephone")));
				MedwanQuery.getInstance().setConfigString("ghb_ref_email",checkString(request.getParameter("ghb_ref_email")));
				MedwanQuery.getInstance().setConfigString("ghb_ref_pubkey",checkString(request.getParameter("ghb_ref_pubkey")));
				//The command was successfully performed, store received elements
				if(root.element("serverid")!=null){
					MedwanQuery.getInstance().setConfigString("ghb_ref_serverid",root.elementText("serverid"));
				}
				if(root.element("privkey")!=null){
					MedwanQuery.getInstance().setConfigString("ghb_ref_privkey",root.elementText("privkey"));
				}
				if(root.element("pubkey")!=null){
					MedwanQuery.getInstance().setConfigString("ghb_ref_pubkey",root.elementText("pubkey"));
				}
			}
			else{
				out.println("<script>alert('"+root.attributeValue("error")+"');</script>");
				out.flush();
			}
		}
	}
	else if(checkString(request.getParameter("action")).equalsIgnoreCase("delete")){
		//Submit the data to central server
		HttpClient client = new HttpClient();
		PostMethod post = new PostMethod(MedwanQuery.getInstance().getConfigString("ghb_ref_url","http://www.globalhealthbarometer.net/globalhealthbarometer/util/saveGHBServer.jsp"));
		org.apache.commons.httpclient.methods.multipart.Part[] parts= {
				new StringPart("ghb_ref_serverid",checkString(request.getParameter("ghb_ref_serverid"))),
				new StringPart("ghb_ref_token",checkString(request.getParameter("ghb_ref_token"))),
				new StringPart("delete","1"),
				new StringPart("ghb_ref_cryptoken",MedwanQuery.getInstance().getConfigString("ghb_ref_privkey", "").length()==0?"":Encryption.encryptTextWithPrivateKey(request.getParameter("ghb_ref_token"),MedwanQuery.getInstance().getConfigString("ghb_ref_privkey", "")))
			};
		post.setRequestEntity(new MultipartRequestEntity(parts, post.getParams()));
		int statusCode = client.executeMethod(post);
		String sResponse = IOUtils.toString(post.getResponseBodyAsStream(), StandardCharsets.UTF_8);
		if(sResponse.contains("<response")){
			Document document=DocumentHelper.parseText(sResponse.substring(sResponse.indexOf("<response")));
			Element root = document.getRootElement();
			if(root.attributeValue("error").equalsIgnoreCase("0")){
				MedwanQuery.getInstance().setConfigString("ghb_ref_projectdomain","");
				MedwanQuery.getInstance().setConfigString("ghb_ref_domain","");
				MedwanQuery.getInstance().setConfigString("ghb_ref_name","");
				MedwanQuery.getInstance().setConfigString("ghb_ref_contact","");
				MedwanQuery.getInstance().setConfigString("ghb_ref_telephone","");
				MedwanQuery.getInstance().setConfigString("ghb_ref_email","");
				MedwanQuery.getInstance().setConfigString("ghb_ref_pubkey","");
				MedwanQuery.getInstance().setConfigString("ghb_ref_privkey","");
				MedwanQuery.getInstance().setConfigString("ghb_ref_serverid","");
			}
			else{
				out.println("<script>alert('"+root.attributeValue("error")+"');</script>");
				out.flush();
			}
		}
	}
%>
<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='2'><%=getTran(request,"web","ghb_referralnetwork_registration",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","serverid",sWebLanguage) %></td>
			<td class='admin2'><input type='hidden' name='ghb_ref_serverid' value='<%=MedwanQuery.getInstance().getConfigString("ghb_ref_serverid", "") %>'/><%=MedwanQuery.getInstance().getConfigString("ghb_ref_serverid", "") %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","projectdomain",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' size='80' name='ghb_ref_projectdomain' value='<%=MedwanQuery.getInstance().getConfigString("ghb_ref_projectdomain", "") %>'/></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","opencarenetbaseurl",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' size='80' name='ghb_ref_baseurl' value='<%=MedwanQuery.getInstance().getConfigString("ghb_ref_baseurl", "http://www.globalhealthbarometer.net/globalhealthbarometer") %>'/></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","serverdomain",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' size='80' name='ghb_ref_domain' value='<%=MedwanQuery.getInstance().getConfigString("ghb_ref_domain", "") %>'/></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","name",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' size='80' name='ghb_ref_name' value='<%=MedwanQuery.getInstance().getConfigString("ghb_ref_name", "") %>'/></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","contact",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' size='80' name='ghb_ref_contact' value='<%=MedwanQuery.getInstance().getConfigString("ghb_ref_contact", "") %>'/></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","telephone",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' size='80' name='ghb_ref_telephone' value='<%=MedwanQuery.getInstance().getConfigString("ghb_ref_telephone", "") %>'/></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","email",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' size='80' name='ghb_ref_email' value='<%=MedwanQuery.getInstance().getConfigString("ghb_ref_email", "") %>'/></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","pubkey",sWebLanguage) %></td>
			<td class='admin2'><textarea type='text' class='text' rows="4" cols='80' name='ghb_ref_pubkey' id='ghb_ref_pubkey'><%=MedwanQuery.getInstance().getConfigString("ghb_ref_pubkey", "") %></textarea></td>
		</tr>
		<tr>
			<td class='admin'>
				<%=getTran(request,"web","token",sWebLanguage)+" "+(SH.ci("enableOpenCarenetMaster",0)==0?"":"<img style='vertical-align: middle' src='"+sCONTEXTPATH+"/_img/icons/icon_new.png' onclick='createToken()'/>") %>
			</td>
			<td class='admin2'><input type='password' class='text' size='20' name='ghb_ref_token' id='ghb_ref_token'/></td>
		</tr>
	</table>
	<input type='hidden' name='action' id='action'/>
	<%
		if(MedwanQuery.getInstance().getConfigString("ghb_ref_serverid", "").length()==0){
			%>
			<input type='button' class='button' onclick='doSubmit()' name='submitButton' value='<%=getTranNoLink("web","registerserver",sWebLanguage) %>'/>
			<%
		}
		else {
			%>
			<input type='button' class='button' onclick='doSubmit()' name='submitButton' value='<%=getTranNoLink("web","update",sWebLanguage) %>'/>
			<input type='button' class='button' onclick='doSubmit(true);' name='renewButton' value='<%=getTranNoLink("web","newkey",sWebLanguage) %>'/>
			<input type='button' class='button' onclick='doDelete();' name='renewButton' value='<%=getTranNoLink("web","delete",sWebLanguage) %>'/>
			<%
		}
	%>
</form>

<script>
	function doSubmit(clean){
		if(document.getElementById('ghb_ref_token').value.length==0){
			alert('<%=getTranNoLink("web","datamissing",sWebLanguage)%>');
			document.getElementById('ghb_ref_token').focus();
		}
		else{
			if(clean){
				document.getElementById("ghb_ref_pubkey").value="";
			}
			document.getElementById('action').value='submit';
			transactionForm.submit();
		}
	}
	function doDelete(){
		if(document.getElementById('ghb_ref_token').value.length==0){
			alert('<%=getTranNoLink("web","datamissing",sWebLanguage)%>');
			document.getElementById('ghb_ref_token').focus();
		}
		else{
			document.getElementById('action').value='delete';
			transactionForm.submit();
		}
	}
	
	function createToken(){
		openPopup("util/setGHBServerToken.jsp&PopupWidth=400&PopupHeight=400");
	}
</script>
