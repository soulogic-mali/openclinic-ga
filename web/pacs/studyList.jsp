<%@page import="be.openclinic.mpi.PACS,org.hl7.fhir.r4.model.*,org.hl7.fhir.r4.model.ImagingStudy.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%@ page import="be.mxs.common.util.db.*" %>

<%=sJSPROTOTYPE %>
<%=sJSTOOLTIP%>

<script>
	var syncids='';
	var syncing=false;
</script>

<form name='transactionForm' id='transactionForm' method='post'>
	
<%	
String mpiserverurl=MedwanQuery.getInstance().getConfigString("MPIServerURL","http://mpi.ocf.world/openclinic");
try{
	String orderuid=SH.c(request.getParameter("orderuid"));
	java.util.Date minDate = new java.util.Date(0);
	if(orderuid.length()>0){
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("select t.updatetime from healthrecord h,transactions t,items i where h.personid=? and h.healthrecordid=t.healthrecordid and t.serverid=i.serverid and t.transactionid=i.transactionid and i.type='be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_IDENTIFICATION_RX' and i.value=?");
		ps.setString(1,activePatient.personid);
		ps.setString(2,orderuid);
		ResultSet rs = ps.executeQuery();
		if(rs.next()){
			minDate=rs.getDate("updatetime");
		}
		else{
			minDate=new java.util.Date();
		}
		rs.close();
		ps.close();
		conn.close();
	}
	//Find the list of all TRANSACTION_TYPE_PACS transactions for this patient
	HashSet allseries = new HashSet(), remoteseries = new HashSet();
	MedwanQuery.getInstance().setObjectCache(new ObjectCache());
	Vector pacstran = MedwanQuery.getInstance().getTransactionsByType(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_PACS");
	SortedMap pacstransorted=new TreeMap(Collections.reverseOrder());
	for (int n=0;n<pacstran.size();n++){
		TransactionVO tran = (TransactionVO)pacstran.elementAt(n);
		if(tran!=null && tran.getUpdateTime().after(minDate)){
			String seriesid="00000000000"+checkString(tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID"));
			String studyid=checkString(tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID"));
			pacstransorted.put(new SimpleDateFormat("yyyyMMdd").format(tran.getUpdateTime())+"."+studyid+
					"."+seriesid.substring(seriesid.length()-11), tran);
			allseries.add(studyid+"$"+seriesid);
		}
	}
	if(request.getParameter("loadMPI")!=null){
		//also add the transactions retrieved from the MPI if they don't already exist locally
		Vector<ImagingStudy> studies = PACS.searchMPI(activePatient.adminextends.get("mpiid"));
		for(int n=0;n<studies.size();n++){
			ImagingStudy study = studies.elementAt(n);
	    	String url=MedwanQuery.getInstance().getConfigString("MPIFhirServerURL","http://mpi.ocf.world/openclinic/fhir");
	    	String studyuid=study.getId().toString().replaceAll(url+"/", "").replaceAll(url, "").replaceAll("ImagingStudy/", "");
			Iterator<ImagingStudySeriesComponent> iSeries = study.getSeries().iterator();
			while(iSeries.hasNext()){
				ImagingStudySeriesComponent series = iSeries.next();
				String seriesuid="00000000000"+series.getId().toString();
				remoteseries.add(studyuid+"$"+seriesuid);
				if(!allseries.contains(studyuid+"$"+seriesuid)){
					TransactionVO tran = PACS.getTransaction(series, studyuid);
					pacstransorted.put(new SimpleDateFormat("yyyyMMdd").format(tran.getUpdateTime())+"."+studyuid+
							"."+seriesuid.substring(seriesuid.length()-11), tran);
					allseries.add(studyuid+"$"+seriesuid);
				}
			}
		}
	}
	if(pacstransorted.size()>5){
		if(MedwanQuery.getInstance().getConfigInt("enableRemoteWeasis", 1)==1){ %>
			<input type='button' class='button' name='viewselected1' value='<%=getTranNoLink("web","viewselected",sWebLanguage) %>' onclick='viewselected()'/>
		<%
		}
		if(MedwanQuery.getInstance().getConfigInt("enableLocalWeasis", 0)==1){
		%>
			<input type='button' class='button' name='viewselectedlocal1' value='<%=getTranNoLink("web","viewselectedlocal",sWebLanguage) %>' onclick='viewselectedlocal()'/>
		<%
		}
		if(request.getParameter("loadMPI")==null && MedwanQuery.getInstance().getConfigInt("enableMPI",0)==1){
		%>
			<input type='submit' class='button' name='loadMPI' value='<%=getTranNoLink("web","loadMPIimages",sWebLanguage) %>'/>
		<%
		}
	}
%>

<table width='100%'>
	<tr class='admin'>
		<%	if(request.getParameter("loadMPI")!=null){ %>
		<td><%=getTran(request,"web", "mpi", sWebLanguage) %></td>
		<%} %>
		<td><%=getTran(request,"web", "date", sWebLanguage) %></td>
		<td><%=getTran(request,"web", "studyid", sWebLanguage) %></td>
		<td><%=getTran(request,"web", "modality", sWebLanguage) %></td>
		<td><%=getTran(request,"web", "preview", sWebLanguage) %></td>
		<td><%=getTran(request,"web", "description", sWebLanguage) %></td>
	</tr>
<%
		int counter=0;
		Iterator ipacs = pacstransorted.keySet().iterator();
		while(ipacs.hasNext()){
			String key = (String)ipacs.next();
			TransactionVO tran =(TransactionVO)pacstransorted.get(key);
			if(tran.getUpdateUser()!=null && tran.getUpdateUser().equalsIgnoreCase("mpi")){
				%>
				<tr>
					<td class="admin">
						<img class='link' tooltiptext='<%=getTranNoLink("web","downloadimagefrommpi",sWebLanguage) %>' id='img_<%=counter%>' style='vertical-align: middle' width='20px' src='<%=sCONTEXTPATH %>/_img/icons/mobile/download.png' onclick='downloadimage(this,"<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")%>","<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID")%>")'/>&nbsp;
					</td>
					<td class="admin" nowrap>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYDATE") %>&nbsp;
						<div id='imgdiv_<%=counter%>'/>
					</td>
					<td class="admin2"><a href='javascript: remoteview("<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")%>","<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID")%>","imgdiv_<%=counter%>");'><%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID") %></a><br/>
						<%=getTran(request,"web", "seriesid", sWebLanguage) %>: <%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID") %>
					</td>
					<td class="admin2"><%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_MODALITY") %></td>
					<td class="admin2"> <center><img onerror='window.setTimeout("loadunknownimage(\"i_<%=counter%>\")",100);document.getElementById("img_<%=counter%>").style.display="none";' onclick='remoteview("<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")%>","<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID")%>","imgdiv_<%=counter%>")' style='max-width: 60px; max-height:60px;' src='<%=mpiserverurl %>/pacs/getDICOMJpeg.jsp?excludeFromFilter=1&uid=<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")%>;<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID") %>'/></center></td>
					<td class="admin2"><a href='javascript: remoteview("<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")%>","<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID")%>","imgdiv_<%=counter%>");'><%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYDESCRIPTION") %></a></td>
				</tr>
				<%
			}
			else{
				%>
				<tr>
				<%
					String uid = tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")+"$"+"00000000000"+tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID");
					if(request.getParameter("loadMPI")!=null){
				%>
					<td class="admin">
						<% 
							if(!remoteseries.contains(uid)){ 
								Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
								PreparedStatement ps2 = conn.prepareStatement("select * from oc_mpidocuments where oc_mpidocument_id=? and oc_mpidocument_sentdatetime is null");
								ps2.setString(1,tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")+"$"+tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID")+"$"+activePatient.adminextends.get("mpiid"));
								ResultSet rs2 = ps2.executeQuery();
								if(rs2.next()){
									%>
									<img class='link' tooltiptext='<%=getTranNoLink("web","synchronizingimage",sWebLanguage) %>' id='img_<%=counter%>' style='vertical-align: middle 'width='20px' src='<%=sCONTEXTPATH %>/_img/icons/mobile/sync.gif'/>&nbsp;
									<script>syncids+='img_<%=counter%>*<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")+"$"+tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID")+"$"+activePatient.adminextends.get("mpiid")%>;';</script>
									<% 	
								}
								else{
									rs2.close();
									ps2.close();
									ps2 = conn.prepareStatement("select * from oc_mpidocuments where oc_mpidocument_id=? and oc_mpidocument_sentdatetime is not null");
									ps2.setString(1,tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")+"$"+tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID")+"$"+activePatient.adminextends.get("mpiid"));
									rs2 = ps2.executeQuery();
									if(rs2.next()){
										//Image has already been sent to KHIN server but is not yet integrated in patient record
										%>
										<img tooltiptext='<%=getTranNoLink("web","imageavailableonbothsides",sWebLanguage) %>' id='img_<%=counter%>' style='vertical-align: middle 'width='20px' src='<%=sCONTEXTPATH %>/_img/icons/mobile/check.png'/>&nbsp;
										<% 	
									}
									else{
										//Image has not yet been sent to KHIN server
										%>
										<img class='link' tooltiptext='<%=getTranNoLink("web","uploadimagetompi",sWebLanguage) %>' id='img_<%=counter%>' style='vertical-align: middle 'width='20px' src='<%=sCONTEXTPATH %>/_img/icons/mobile/uploadcloud.png' onclick='uploadimage(this,"<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")%>","<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID")%>")'/>&nbsp;
										<% 	
									}
								}
								rs2.close();
								ps2.close();
								conn.close();
							} 
							else{
								%>
								<img tooltiptext='<%=getTranNoLink("web","imageavailableonbothsides",sWebLanguage)%>' id='img_<%=counter%>' style='vertical-align: middle 'width='20px' src='<%=sCONTEXTPATH %>/_img/icons/mobile/check.png'/>&nbsp;
								<% 	
							}
						%>
					</td>
				<%
					}
				%>
					<td class="admin" nowrap>
						<input class='text' type='checkbox' id='cb.<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")%>_<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID")%>_<%=counter%>'/>
						<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYDATE") %>&nbsp;
						<div id='imgdiv_<%=counter%>'/>
					</td>
					<td class="admin2"><a href='javascript: view("<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")%>","<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID")%>","imgdiv_<%=counter%>");'><%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID") %></a><br/>
						<%=getTran(request,"web", "seriesid", sWebLanguage) %>: <%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID") %>
					</td>
					<td class="admin2"><%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_MODALITY") %></td>
					<td class="admin2"> <center><img id='i_<%=counter%>' onerror='window.setTimeout("loadunknownimage(\"i_<%=counter%>\")",100);document.getElementById("img_<%=counter%>").style.display="none";' onclick='view("<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")%>","<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID")%>","imgdiv_<%=counter%>")' style='max-width: 60px; max-height:60px;' src='<%=sCONTEXTPATH %>/pacs/getDICOMJpeg.jsp?excludeFromFilter=1&uid=<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")%>;<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID") %>'/></center></td>
					<td class="admin2"><a href='javascript: view("<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")%>","<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID")%>","imgdiv_<%=counter%>");'><%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYDESCRIPTION") %></a></td>
				</tr>
				<%
			}
			counter++;
		}
	%>
	</table>
	
	<IFRAME style="display:none" id='hf2' onclick="showProgress(false);" name="hidden-form2"></IFRAME>
	<%	
	if(pacstransorted.size()>0){
		if(MedwanQuery.getInstance().getConfigInt("enableRemoteWeasis", 1)==1){ %>
			<input type='button' class='button' name='viewselected2' value='<%=getTranNoLink("web","viewselected",sWebLanguage) %>' onclick='viewselected()'/>
	<%
		}
		if(MedwanQuery.getInstance().getConfigInt("enableLocalWeasis", 0)==1){
	%>
			<input type='button' class='button' name='viewselectedlocal2' value='<%=getTranNoLink("web","viewselectedlocal",sWebLanguage) %>' onclick='viewselectedlocal()'/>
	<%
		}
		if(request.getParameter("loadMPI")==null && MedwanQuery.getInstance().getConfigInt("enableMPI",0)==1){
	%>
			<input type='submit' class='button' name='loadMPI' value='<%=getTranNoLink("web","loadMPIimages",sWebLanguage) %>'/>
	<%
		}
	}
	else{
		out.println(getTran(request,"web","noimages",sWebLanguage));
		if(request.getParameter("loadMPI")==null && MedwanQuery.getInstance().getConfigInt("enableMPI",0)==1){
		%>
			<input type='submit' class='button' name='loadMPI' value='<%=getTranNoLink("web","loadMPIimages",sWebLanguage) %>'/>
		<%
		}
	}
}
catch(Exception e){
	e.printStackTrace();
}
%>
</form>
<script>

function showProgress(doit,imgdiv){
	if(doit==true && 0==<%=MedwanQuery.getInstance().getConfigInt("enableLocalWeasisViewer3.5",0)%>){
		document.getElementById(imgdiv).innerHTML="<center><img width='60px' src='<c:url value="/_img/themes/default/ajax-loader.gif"/>'/></center>";
	}
	else{
		var elements=document.getElementsByTagName("*");
		for(n=0;n<elements.length;n++){
			if(elements[n].id && elements[n].id.startsWith("imgdiv_")){
				elements[n].innerHTML="";
			}
		}
	}
}

function viewselected(){
	var studies='';
	var series='';
	var elements=document.getElementsByTagName("*");
	for(n=0;n<elements.length;n++){
		if(elements[n].id && elements[n].id.startsWith("cb.") && elements[n].checked){
			if(studies.length>0){
				studies+="_";
				series+="_";
			}
			studies+=elements[n].id.split('_')[0].substring(3);
			series+=elements[n].id.split('_')[1];
		}
	}
	if(studies.length>0){
	    var url = "<c:url value='/pacs/viewStudy.jsp'/>?studyuid="+studies+"&seriesid="+series;
	    window.open(url,"hidden-form2");
	}
}

function viewselectedlocal(){
	var studies='';
	var series='';
	var elements=document.getElementsByTagName("*");
	for(n=0;n<elements.length;n++){
		if(elements[n].id && elements[n].id.startsWith("cb.") && elements[n].checked){
			if(studies.length>0){
				studies+="_";
				series+="_";
			}
			studies+=elements[n].id.split('_')[0].substring(3);
			series+=elements[n].id.split('_')[1];
		    showProgress(true,'imgdiv_'+elements[n].id.split('_')[2]);
		}
	}
	if(studies.length>0){
	    var url = "<c:url value='/pacs/'/>viewStudyLocal<%=MedwanQuery.getInstance().getConfigInt("enableLocalWeasisViewer3.5",0)==1?"2":""%>.jsp?studyuid="+studies+"&seriesid="+series;
	    window.open(url,"hidden-form2");
	}
	else{
		alert('<%=getTranNoLink("web","firstselectimages",sWebLanguage)%>');
	}
}

function view(studyuid,seriesid,imgdiv){
	<%
		if(MedwanQuery.getInstance().getConfigInt("enableRemoteWeasis", 1)==1){
	%>
    	var url = "<c:url value='/pacs/viewStudy.jsp'/>?studyuid="+studyuid+"&seriesid="+seriesid;
    <%
		}
		else{
    %>
		var url = "<c:url value='/pacs/'/>viewStudyLocal<%=MedwanQuery.getInstance().getConfigInt("enableLocalWeasisViewer3.5",0)==1?"2":""%>.jsp?studyuid="+studyuid+"&seriesid="+seriesid;
	    showProgress(true,imgdiv);
    <%
		}
    %>
    window.open(url,"hidden-form2");
}

function remoteview(studyuid,seriesid,imgdiv){
	<%
		if(MedwanQuery.getInstance().getConfigInt("enableRemoteWeasis", 1)==1){
	%>
    	var url = "<%=mpiserverurl%>/pacs/viewStudy.jsp?studyuid="+studyuid+"&seriesid="+seriesid;
    <%
		}
		else{
    %>
		var url = "<%=mpiserverurl%>/pacs/viewStudyLocal<%=MedwanQuery.getInstance().getConfigInt("enableLocalWeasisViewer3.5",0)==1?"2":""%>.jsp?studyuid="+studyuid+"&seriesid="+seriesid;
	    showProgress(true,imgdiv);
    <%
		}
    %>
    window.open(url,"hidden-form2");
}
 
function downloadimage(img,studyuid,seriesuid){
	img.src='<%=sCONTEXTPATH %>/_img/icons/mobile/sync.gif';
	img.setAttribute('tooltiptext','<%=getTranNoLink("web","synchronizingimage",sWebLanguage) %>');
	refreshTooltip(img);
    var params = "studyuid="+studyuid+"&seriesuid="+seriesuid;
	var url = '<%=sCONTEXTPATH%>/mpi/downloadImagingStudy.jsp';
	new Ajax.Request(url,{
	method: "GET",
	parameters: params,
	onSuccess: function(resp){
		syncids+=img.id+"*"+studyuid+"$"+seriesuid+"$<%=activePatient.adminextends.get("mpiid")%>;";
		checkSyncStatus();
	}
	});
}

function uploadimage(img,studyuid,seriesuid){
	img.src='<%=sCONTEXTPATH %>/_img/icons/mobile/sync.gif';
	img.setAttribute('tooltiptext','<%=getTranNoLink("web","synchronizingimage",sWebLanguage) %>');
	refreshTooltip(img);
    var params = "studyuid="+studyuid+"&seriesuid="+seriesuid;
	var url = '<%=sCONTEXTPATH%>/mpi/uploadImagingStudy.jsp';
	new Ajax.Request(url,{
	method: "GET",
	parameters: params,
	onSuccess: function(resp){
		syncids+=img.id+"*"+studyuid+"$"+seriesuid+"$<%=activePatient.adminextends.get("mpiid")%>;";
		checkSyncStatus();
	}
	});
}

function checkSyncStatus(){
	if(syncids.length>0 && !syncing){
		syncing=true;
		var url = '<%=sCONTEXTPATH%>/mpi/checkSyncStatus.jsp';
		new Ajax.Request(url,{
		method: "GET",
		parameters: "syncids="+syncids,
	    onSuccess: function(resp){
	        var label = eval('('+resp.responseText+')');
	        if(label.syncedids.length>0){
		        var synced = label.syncedids.split(";");
		        for(i=0;i<synced.length;i++){
		        	syncids=syncids.replace(synced[i]+";","");
		        	var img=document.getElementById(synced[i].split("*")[0]);
		        	if(img){
			        	img.src='<%=sCONTEXTPATH %>/_img/icons/mobile/check.png';
			        	img.setAttribute('tooltiptext','<%=getTranNoLink("web","imageavailableonbothsides",sWebLanguage) %>');
			        	img.onclick="";
			        	resetTooltip(img);
		        	}
		        }
	        }
	        else{
	        	window.setTimeout('checkSyncStatus()',2000);
	        }
	        syncing=false;
		},
        onFailure: function(){
	        if(syncids.length>0){
	        	window.setTimeout('checkSyncStatus()',2000);
	        }
	        syncing=false;
        }
		});
	}
}

function loadunknownimage(img){
	document.getElementById(img).src='<%=sCONTEXTPATH %>/_img/unknownxray.png?ts=<%=getTs()%>';
}

<%-- enable tooltips on info-icons --%>
window.onload = function(){
  var imgs = document.getElementsByTagName("img");
  
  for(var i=0; i<imgs.length; i++){
    if(imgs[i].id!=null && imgs[i].id.startsWith("img_")){
      enableTooltip(imgs[i].id);
    }
  }
};

if(syncids.length>0){
	checkSyncStatus();
}
</script>