<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
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
	if(MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",100)==0){
%>
		<font style='font-size: 12px;color: red'><%=getTran(request,"gmao","unavailableoncentralserver",sWebLanguage) %></font>
<%
	}
	else{
		String sServiceUid = checkString(request.getParameter("serviceuid"));
%>

<%=checkPermission(out,"gmao.synchronisation","select",activeUser)%>
<table width='100%'>
	<tr class='admin'>
		<td colspan='2'><%=getTran(request,"web","assetsynchronization",sWebLanguage) %></td>
	</tr>
	<tr>
		<td colspan='2'><font style='font-size: 14px;color: red'><%=getTran(request,"gmao","checkoutfunction",sWebLanguage) %></font></td>
	</tr>
	<tr>
        <td class="admin"><%=getTran(request,"web","service",sWebLanguage)%></td>
        <td class="admin2">
            <input type="hidden" name="serviceuid" id="serviceuid" value="<%=sServiceUid%>">
            <input onblur="" class="text" type="text" name="servicename" id="servicename" size="60" value="<%=getTranNoLink("service",sServiceUid,sWebLanguage) %>" >
            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTran(null,"Web","select",sWebLanguage)%>" onclick="searchService('serviceuid','servicename');">
            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTran(null,"Web","delete",sWebLanguage)%>" onclick="document.getElementById('serviceuid').value='';document.getElementById('servicename').value='';">
            &nbsp;<input type='button' class='button' name='buttonDownloadCheckout' value='<%=getTranNoLink("web","downloadandcheckout",sWebLanguage) %>' onclick='checkout();'/>
            <!-- 
            &nbsp;<input type='button' class='button' name='buttonDownload' value='<%=getTranNoLink("web","download",sWebLanguage) %>' onclick='download();'/>
 			-->
			<div id="autocomplete_service" class="autocomple"></div>
         </td>                        
	</tr>	
	<%
		try{
			File file = new File(MedwanQuery.getInstance().getConfigString("tempDirectory","/tmp")+"/inventory.xml");
			if(file.exists()){
				SAXReader reader = new SAXReader(false);
			    Document document = reader.read(file);
			    Element rootElement = document.getRootElement();
				%>
				<tr>
					<td style='text-align: right'><%=getTran(request,"web","lastcheckout",sWebLanguage) %>: </td>
					<td><a href='javascript:viewXml("inventory.xml","all");'><b><%=SH.formatDate(new SimpleDateFormat("yyyyMMddHHmmssSSS").parse(rootElement.attributeValue("datetime")),SH.fullDateFormat) %></b> <%=getTran(request,"web","by",sWebLanguage)+" "+rootElement.attributeValue("user") %> <%=getTran(request,"web","for",sWebLanguage)+" "+rootElement.attributeValue("serviceid")+" - <b>"+getTranNoLink("service",rootElement.attributeValue("serviceid"),sWebLanguage)+"</b>"%></a></td>
				</tr>
				<tr>
					<td/>
					<td><b><%=rootElement.elements("asset").size() %></b> <%=getTran(request,"web","assetelements",sWebLanguage) %></td>
				</tr>
				<%
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
	%>
	<tr>
		<td colspan='2'><br><hr/><font style='font-size: 14px;color: red'><%=getTran(request,"gmao","checkinfunction",sWebLanguage) %></font></td>
	</tr>
	<tr>
        <td class="admin"></td>
        <td class="admin2">
            &nbsp;<input type='button' class='button' name='buttonUploadCheckin' value='<%=getTranNoLink("web","uploadandcheckin",sWebLanguage) %>' onclick='checkin();'/>
        </td>                        
	</tr>	
	<%
		try{
			File file = new File(MedwanQuery.getInstance().getConfigString("tempDirectory","/tmp")+"/upload.xml");
			if(file.exists()){
				SAXReader reader = new SAXReader(false);
			    Document document = reader.read(file);
			    Element rootElement = document.getRootElement();
				Iterator<Element> iAssets = rootElement.elementIterator("asset");
				int nTotal=0,nAssetCount=0,nPlanCount=0,nOperationCount=0;
				while(iAssets.hasNext()){
					nTotal++;
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
				%>
				<tr>
					<td style='text-align: right'><%=getTran(request,"web","lastupload",sWebLanguage) %>: </td>
					<td><a href='javascript:viewXml("upload.xml","");'><b><%=SH.formatDate(new SimpleDateFormat("yyyyMMddHHmmssSSS").parse(rootElement.attributeValue("datetime")),SH.fullDateFormat) %></b> <%=getTran(request,"web","by",sWebLanguage)+" "+rootElement.attributeValue("user") %></a></td>
				</tr>
				<tr>
					<td/>
					<td><b><%=nAssetCount%></b> <%=getTran(request,"web","of",sWebLanguage)%> <%=nTotal %> <%=getTran(request,"web","assetelements",sWebLanguage)%>, <b><%=nPlanCount%></b> <%=getTran(request,"web","maintenanceplans",sWebLanguage)%>, <b><%=nOperationCount%></b> <%=getTran(request,"web","maintenanceoperations",sWebLanguage)%></td>
				</tr>
				<%
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
	%>
</table>
<table width='100%'>
	<tr>
		<td colspan='2'><br><hr/><font style='font-size: 14px;color: red'><%=getTran(request,"gmao","ckeckedout",sWebLanguage) %></font></td>
	</tr>
<%
	Connection conn = SH.getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("SELECT DISTINCT oc_asset_service FROM oc_assets WHERE oc_asset_lockedby=? ORDER BY oc_asset_service");
	ps.setInt(1,SH.ci("GMAOLocalServerId",0));
	ResultSet rs = ps.executeQuery();
	boolean bInit=false;
	while(rs.next()){
		bInit=true;
		out.println("<tr><td class='admin' width='1%' nowrap>"+rs.getString("oc_asset_service").toUpperCase()+"&nbsp;</td><td class='admin2'>"+StringUtils.repeat("&nbsp;&nbsp;&nbsp;",rs.getString("oc_asset_service").split("\\.").length)+getTranNoLink("service",rs.getString("oc_asset_service"),sWebLanguage)+"</td></tr>");
	}
	rs.close();
	ps.close();
	conn.close();
	if(!bInit){
		out.println("<tr><td colspan='2'>"+getTran(request,"web","none",sWebLanguage)+"</td></tr>");
	}
%>
</table>

<script>
	new Ajax.Autocompleter('servicename','autocomplete_service','<%=sCONTEXTPATH%>/assets/findService.jsp',{
	  minChars:1,
	  method:'post',
	  afterUpdateElement: afterAutoCompleteService,
	  callback: composeCallbackURLService
	});

	function afterAutoCompleteService(field,item){
	  var regex = new RegExp('[-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.]*-idcache','i');
	  var nomimage = regex.exec(item.innerHTML);
	  var id = nomimage[0].replace('-idcache','');
	  document.getElementById("serviceuid").value = id;
	  document.getElementById("servicename").value=item.innerHTML.split("$")[1];
	}
	
	function composeCallbackURLService(field,item){
	  document.getElementById("serviceuid").value="";
	  var url = "";
	  if(field.id=="servicename"){
		url = "text="+field.value;
	  }
	  return url;
	}

	function searchService(serviceUidField,serviceNameField){
	  	openPopup("/_common/search/searchService.jsp&ts=<%=getTs()%>&lockservices=1&VarCode="+serviceUidField+"&VarText="+serviceNameField);
	  	document.getElementById(serviceNameField).focus();
	}
	
	function checkout(){
		if(document.getElementById('serviceuid').value.length==0){
			alert('<%=getTranNoLink("web","serviceidismandatory",sWebLanguage)%>');
		}
		else{
			openPopup("/assets/checkOut.jsp&ts=<%=getTs()%>&PopupWidth=600&PopupHeight=400&serviceuid="+document.getElementById('serviceuid').value);
			//document.getElementById('serviceuid').value='';
			//document.getElementById('servicename').value='';
		}
	}
	
	function checkin(){
	  	openPopup("/assets/checkIn.jsp&ts=<%=getTs()%>&PopupWidth=600&PopupHeight=400");
	}
	
	function download(){
		if(document.getElementById('serviceuid').value.length==0){
			alert('<%=getTranNoLink("web","serviceidismandatory",sWebLanguage)%>');
		}
		else{
		  	openPopup("/assets/checkOut.jsp&ts=<%=getTs()%>&downloadonly=1&PopupWidth=400&PopupHeight=400&serviceuid="+document.getElementById('serviceuid').value);
			//document.getElementById('serviceuid').value='';
			//document.getElementById('servicename').value='';
		}
	}
	
	function upload(){
	  	openPopup("/assets/checkIn.jsp&ts=<%=getTs()%>&uploadonly=1&PopupWidth=400&PopupHeight=400");
	}

	function viewXml(filename,filter){
		openPopup("assets/viewXmlDetails.jsp&filter="+filter+"&filename=<%=MedwanQuery.getInstance().getConfigString("tempDirectory","/tmp")%>/"+filename,800,600);
	}
</script>
<%
	}
%>