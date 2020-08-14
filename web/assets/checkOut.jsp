<%@page import="java.util.Iterator,org.apache.commons.httpclient.*,org.apache.commons.httpclient.methods.*,org.apache.http.client.methods.*,
org.apache.http.impl.client.*,org.apache.http.message.*,org.apache.http.client.entity.*,org.apache.commons.io.*"%>
<%@page import="org.dom4j.*,java.net.*"%>
<%@page import="org.dom4j.io.SAXReader"%>
<%@page import="java.io.File,java.util.*"%>
<%@page import="be.mxs.common.util.db.MedwanQuery,java.sql.*,be.openclinic.assets.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String service=checkString(request.getParameter("serviceuid"));
	//****************************************
	//Test checkin procedure
	//****************************************
	String sResult="done";
	int nGmaoServerId = MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",100);
	out.println(getTran(request,"gmao","retrievingallassetsforservice",sWebLanguage)+" <b>"+service+"</b>...");
	out.flush();
	String xmlIn="";
	try{
		String url = MedwanQuery.getInstance().getConfigString("GMAOCentralServer","http://localhost/openclinic")+"/assets/getUnlockedAssetsForServiceUid.jsp";
		out.println("<br/>"+getTran(request,"gmao","calling",sWebLanguage)+" "+url+"...");
		out.flush();
		CloseableHttpClient client = HttpClients.createDefault();
		HttpPost httpPost = new HttpPost(url);
		List<org.apache.http.NameValuePair> params = new ArrayList<org.apache.http.NameValuePair>();
	    params.add(new BasicNameValuePair("serviceid", service));
	    httpPost.setEntity(new UrlEncodedFormEntity(params));	
	    CloseableHttpResponse xml = client.execute(httpPost);
		xmlIn=new BasicResponseHandler().handleResponse(xml);
	}
	catch(Exception a){
		sResult="error";
		a.printStackTrace();
	}
	out.println(getTran(request,"gmao",sResult,sWebLanguage).toUpperCase()+"</br>"+getTran(request,"gmao","storingcontentinlocaldatabase",sWebLanguage)+"...");
	out.flush();
	StringBuffer sb = new StringBuffer();
	sb.append(xmlIn);
	if(!new java.io.File(MedwanQuery.getInstance().getConfigString("tempDirectrory","/tmp")).exists()){
		new java.io.File(MedwanQuery.getInstance().getConfigString("tempDirectrory","/tmp")).mkdirs();
	}
	FileUtils.writeStringToFile(new File(MedwanQuery.getInstance().getConfigString("tempDirectory","/tmp")+"/inventory.xml"), sb.toString());
	if(Asset.storeXml(sb)){
		sResult="done";
	}
	else{
		sResult="error";
	}
	if(checkString(request.getParameter("downloadonly")).equals("1")){
		out.println(getTran(request,"gmao",sResult,sWebLanguage).toUpperCase());
	}
	else{
		out.println(getTran(request,"gmao",sResult,sWebLanguage).toUpperCase()+"</br>"+getTran(request,"gmao","checkoutassetsoncentralserver",sWebLanguage)+"...");
		out.flush();
		String url = MedwanQuery.getInstance().getConfigString("GMAOCentralServer","http://localhost/openclinic")+"/assets/checkOutAssetsForServiceUid.jsp";
		CloseableHttpClient client = HttpClients.createDefault();
		xmlIn="";
		try{
			HttpPost httpPost = new HttpPost(url);
			List<org.apache.http.NameValuePair> params = new ArrayList<org.apache.http.NameValuePair>();
		    params.add(new BasicNameValuePair("userid",activeUser.userid));
		    params.add(new BasicNameValuePair("serviceid",service));
		    params.add(new BasicNameValuePair("serverid",nGmaoServerId+""));
		    httpPost.setEntity(new UrlEncodedFormEntity(params));	
		    CloseableHttpResponse xml = client.execute(httpPost);
		    xmlIn=new BasicResponseHandler().handleResponse(xml);
		}
		catch(Exception a){
			a.printStackTrace();
		}
	    if(xmlIn.contains("<OK>")){
			out.println(getTran(request,"gmao","done",sWebLanguage).toUpperCase()+"<br/>"+getTran(request,"gmao","checkoutassetsonlocalserver",sWebLanguage)+" #"+nGmaoServerId+"...");
			out.flush();
			if(Asset.checkOutAssetsForService(service,nGmaoServerId)){
				out.println(getTran(request,"gmao","done",sWebLanguage).toUpperCase()+"<br/>");
			}
			else{
				out.println(getTran(request,"gmao","error",sWebLanguage).toUpperCase()+"<br/>");
			}
			out.flush();
		}
		else {
			out.println(getTran(request,"gmao","error",sWebLanguage).toUpperCase()+"<br/>"+getTran(request,"gmao","checkoutassetsonlocalserver",sWebLanguage)+" #"+nGmaoServerId+"...");
			out.flush();
		}
	}
%>
<p/>
<center>
	<input type='button' class='button' name='closeButton' value='<%=getTranNoLink("web","close",sWebLanguage)%>' onclick='window.close();'/>
</center>