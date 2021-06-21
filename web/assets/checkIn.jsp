<%@page import="java.util.Iterator,org.apache.commons.httpclient.*,org.apache.commons.httpclient.methods.*,org.apache.http.client.methods.*,
org.apache.http.impl.client.*,org.apache.http.message.*,org.apache.http.client.entity.*,org.apache.http.entity.mime.*,org.apache.http.*,org.apache.http.entity.*"%>
<%@page import="org.dom4j.*,java.net.*"%>
<%@page import="org.dom4j.io.SAXReader"%>
<%@page import="java.io.File,java.util.*,java.io.*"%>
<%@page import="be.mxs.common.util.db.MedwanQuery,java.sql.*,be.openclinic.assets.*,org.apache.commons.io.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%!
	java.util.Date std(String s){
		try{
			return new SimpleDateFormat("yyyyMMddHHmmssSSS").parse(s);
		}
		catch(Exception e){
			e.printStackTrace();
			return null;
		}
	}
%>
<%
try{
	//****************************************
	//Test checkin procedure
	//****************************************
	String sResult="DONE";
	int nGmaoServerId = MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",-1);
	out.println(getTran(request,"gmao","retrievingnegativelocalids",sWebLanguage)+"...");
	out.flush();
	if(Asset.hasNegativeIds()){
		String sNegativeIdsXml=Asset.getNegativeIds().toString();
		out.println(getTran(request,"gmao","done",sWebLanguage).toUpperCase()+"<br/>"+getTran(request,"gmao","gettingpositiveserverids",sWebLanguage)+"...");
		out.flush();
		sResult="done";
		try{
			String url = MedwanQuery.getInstance().getConfigString("GMAOCentralServer","http://localhost/openclinic")+"/assets/getServerIds.jsp";
			CloseableHttpClient client = HttpClients.createDefault();
			HttpPost httpPost = new HttpPost(url);
			List<org.apache.http.NameValuePair> params = new ArrayList<org.apache.http.NameValuePair>();
		    params.add(new BasicNameValuePair("xml", sNegativeIdsXml));
		    httpPost.setEntity(new UrlEncodedFormEntity(params));	
		    CloseableHttpResponse xml = client.execute(httpPost);
			String xmlIn=new BasicResponseHandler().handleResponse(xml);
			out.println(getTran(request,"gmao",sResult,sWebLanguage).toUpperCase()+"<br/>"+getTran(request,"gmao","updatinglocalids",sWebLanguage)+"...");
			out.flush();
			if(Asset.updateNegativeIds(xmlIn)){
				sResult="done";
			}
			else{
				sResult="error";
			}
		}
		catch(Exception a){
			sResult="error";
			a.printStackTrace();
		}
	}
	out.println(getTran(request,"gmao",sResult,sWebLanguage).toUpperCase()+"<br/>"+getTran(request,"gmao","copydocumentstoserver",sWebLanguage)+"...");
	out.flush();
	if(Asset.sendDocumentsToServer()){
		sResult="done";
	}
	else{
		sResult="error";
	}
	if(!Asset.hasNegativeIds()){
		//No negative IDs anymore, reset the counters if this is really a slave server (id>0)
		if(nGmaoServerId>0){
			MedwanQuery.getInstance().setOpenclinicCounter("ComponentObjectId", -100000);
			MedwanQuery.getInstance().setOpenclinicCounter("OC_ASSETS", -100000);
			MedwanQuery.getInstance().setOpenclinicCounter("OC_MAINTENANCEOPERATIONS", -100000);
			MedwanQuery.getInstance().setOpenclinicCounter("OC_MAINTENANCEPLANS", -100000);
			MedwanQuery.getInstance().setOpenclinicCounter("ARCH_DOCUMENTS", -100000);
		}
	}
	int nAssets=0;
	out.println(getTran(request,"gmao",sResult,sWebLanguage).toUpperCase()+"<br/>"+getTran(request,"gmao","uploadingrecordsfrom",sWebLanguage)+"...");
	out.flush();
	StringBuffer sb = new StringBuffer();
	sb.append("<gmao datetime='"+new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new java.util.Date())+"' user='"+activeUser.getFullName()+"'>");
	Vector checkedOutAssetUids=Asset.getCheckedOutAssetUids();
	for(int n=0;n<checkedOutAssetUids.size();n++){
		String uid = (String)checkedOutAssetUids.elementAt(n);
		sb.append(Asset.toXml(uid));
	}
	sb.append("</gmao>");
	try{
		String url = MedwanQuery.getInstance().getConfigString("GMAOCentralServer","http://localhost/openclinic")+"/assets/uploadAssets.jsp";
		CloseableHttpClient client = HttpClients.createDefault();
		HttpPost httpPost = new HttpPost(url);
		MultipartEntityBuilder builder = MultipartEntityBuilder.create();
		builder.setMode(HttpMultipartMode.BROWSER_COMPATIBLE);
		if(!new java.io.File(MedwanQuery.getInstance().getConfigString("tempDirectory","/tmp")).exists()){
			new java.io.File(MedwanQuery.getInstance().getConfigString("tempDirectory","/tmp")).mkdirs();
		}
		String sFilename=MedwanQuery.getInstance().getConfigString("tempDirectory","/tmp")+"/upload.xml";
		File file = new File(sFilename);
		if(file.exists()){
			file.delete();
		}
		FileUtils.writeStringToFile(file, sb.toString());
		builder.addBinaryBody("filename", file, ContentType.DEFAULT_BINARY, sFilename);
		HttpEntity entity = builder.build();
		httpPost.setEntity(entity);
		HttpResponse xml = client.execute(httpPost);
	    String xmlIn=new BasicResponseHandler().handleResponse(xml);
	    if(xmlIn.contains("<OK>")){
			if(checkString(request.getParameter("uploadonly")).equals("1")){
				out.println(getTran(request,"gmao","done",sWebLanguage).toUpperCase());
			}
			else{
				out.println("<br/>"+getTran(request,"gmao","uploadof",sWebLanguage)+" <b>"+checkedOutAssetUids.size()+"</b> "+getTran(request,"gmao","localymanagedassets",sWebLanguage)+"...");
				SAXReader reader = new SAXReader(false);
			    Document document = reader.read(new StringReader(sb.toString()));
			    Element rootElement = document.getRootElement(); //gmao
				Iterator<Element> iAssets = rootElement.elementIterator("asset");
				int nAssetCount=0,nPlanCount=0,nOperationCount=0;
				while(iAssets.hasNext()){
					Element eAsset = iAssets.next();
					if(SH.c(eAsset.elementText("lockeddate")).length()>0 && std(SH.c(eAsset.elementText("lockeddate"))).before(std(SH.c(eAsset.elementText("updatetime"))))){
						nAssetCount++;
					}
					Iterator<Element> iPlans = eAsset.element("maintenanceplans").elementIterator("maintenanceplan");
					while(iPlans.hasNext()){
						Element ePlan =iPlans.next();
						if(SH.c(eAsset.elementText("lockeddate")).length()>0 && std(SH.c(eAsset.elementText("lockeddate"))).before(std(SH.c(ePlan.elementText("updatetime"))))){
							nPlanCount++;
						}
						Iterator<Element> iOperations = ePlan.element("maintenanceoperations").elementIterator("maintenanceoperation");
						while(iOperations.hasNext()){
							Element eOperation =iOperations.next();
							if(SH.c(eAsset.elementText("lockeddate")).length()>0 && std(SH.c(eAsset.elementText("lockeddate"))).before(std(SH.c(eOperation.elementText("updatetime"))))){
								nOperationCount++;
							}
						}
					}
				}
				out.println(getTran(request,"gmao","done",sWebLanguage).toUpperCase()+" <br/>"+getTran(request,"gmao","modified",sWebLanguage)+" <b>"+nAssetCount+"</b> "+getTran(request,"web","assets",sWebLanguage)+", <b>"+nPlanCount+"</b> "+getTran(request,"web","maintenanceplans",sWebLanguage)+", <b>"+nOperationCount+"</b> "+getTran(request,"web","maintenanceoperations",sWebLanguage));
				out.println("<br/>"+getTran(request,"gmao","unlockingitemsoncentralserver",sWebLanguage)+"...");
				url = MedwanQuery.getInstance().getConfigString("GMAOCentralServer","http://localhost/openclinic")+"/assets/checkInAssetsForServerId.jsp";
				client = HttpClients.createDefault();
				httpPost = new HttpPost(url);
				List<org.apache.http.NameValuePair> params = new ArrayList<org.apache.http.NameValuePair>();
			    params.add(new BasicNameValuePair("serverid",nGmaoServerId+""));
			    httpPost.setEntity(new UrlEncodedFormEntity(params));	
			    xml = client.execute(httpPost);
			    xmlIn=new BasicResponseHandler().handleResponse(xml);
			    if(xmlIn.contains("<OK>")){
					out.println(getTran(request,"gmao","done",sWebLanguage).toUpperCase()+"<br/>"+getTran(request,"gmao","unlockingitemsonlocalserver",sWebLanguage)+" #"+nGmaoServerId+"...");
					Asset.checkInAssetsForServerId(nGmaoServerId);
					out.println(getTran(request,"gmao","done",sWebLanguage).toUpperCase()+"<br/>");
				}
				else {
					out.println("ERROR!<br/>"+getTran(request,"gmao","notunlockingitemsonlocalserver",sWebLanguage)+" #"+nGmaoServerId);
				}
			}
		}
		else {
			out.println("ERROR! ["+xmlIn+"]<br/>"+getTran(request,"gmao","notunlockingitemsoncentralserver",sWebLanguage)+"...");
		}
	}
	catch(Exception a){
		a.printStackTrace();
		out.println("ERROR! ["+a.getMessage()+"]<br/>"+getTran(request,"gmao","notunlockingitemsoncentralserver",sWebLanguage)+"...");
	}
}
catch(Exception e){
	e.printStackTrace();
}
%>
<p/>
<center>
	<input type='button' class='button' name='closeButton' value='<%=getTranNoLink("web","close",sWebLanguage)%>' onclick='window.close();'/>
	<input type='button' class='button' name='closeButton' value='<%=getTranNoLink("web","view",sWebLanguage)%>' onclick='viewContent();'/>
</center>

<script>
	function viewContent(){
		openPopup("assets/viewXmlDetails.jsp&filename=<%=MedwanQuery.getInstance().getConfigString("tempDirectory","/tmp")+"/upload.xml"%>",800,600);
	}
	window.opener.location.reload();
</script>