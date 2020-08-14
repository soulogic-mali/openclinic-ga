<%@include file="/includes/validateUser.jsp"%>
<%=sJSPROTOTYPE %>

<font class='h1red'><%=ScreenHelper.convertToUUID(activePatient.personid)+" </font><font class='h1'>- "+activePatient.getFullName()+" °"+activePatient.dateOfBirth+" "+getTran(request,"gender",activePatient.gender,sWebLanguage)%></font>

<table width='100%'>
	<tr>
		<td width='65%' style='vertical-align: top'>
			<div style='height: 400px; overflow: auto'>
			<table width='100%'>
			<%
				String sInitialPreview="";
				Vector pacstran = MedwanQuery.getInstance().getTransactionsByType(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_PACS");
				if(pacstran.size()>0){
					SortedMap pacstransorted=new TreeMap(Collections.reverseOrder());
					for (int n=0;n<pacstran.size();n++){
						TransactionVO tran = (TransactionVO)pacstran.elementAt(n);
						if(tran!=null){
							try{
								String seriesid="00000000000"+checkString(tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID"));
								pacstransorted.put(new SimpleDateFormat("yyyyMMdd").format(tran.getUpdateTime())+"."+checkString(tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID"))+
										"."+seriesid.substring(seriesid.length()-11), tran);
							}
							catch(Exception e){
								e.printStackTrace();
							}
						}
					}
					String cls="invertedgrey";
					String color="#808080";
					Iterator ipacs = pacstransorted.keySet().iterator();
					int counter=0;
					while(ipacs.hasNext()){
						String key = (String)ipacs.next();
						TransactionVO tran =(TransactionVO)pacstransorted.get(key);
						%>
							<tr class='<%=cls %>' id='tr_<%=counter++%>;<%=color%>'>
								<td style='padding: 5px' nowrap width='1%'>
									<input type='checkbox' id='cb.<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")%>_<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID")%>'/>
									<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYDATE") %>&nbsp;
									<div id='imgdiv_<%=counter%>'/>
								</td>
								<td style='padding: 5px'><%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID") %><br/>
									<%=getTran(request,"web", "seriesid", sWebLanguage) %>: <%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID") %>
								</td>
								<td style='padding: 5px'><%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_MODALITY") %></td>
								<td style='padding: 5px'>
									<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYDESCRIPTION") %><br/>
									<a href='javascript: preview("tr_<%=counter-1%>;<%=color%>","<%=sCONTEXTPATH %>/pacs/getDICOMJpeg.jsp?excludeFromFilter=1&uid=<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")%>;<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID") %>");'><%=getTran(request,"web","preview",sWebLanguage) %></a>&nbsp;
									<a href='javascript: preview("tr_<%=counter-1%>;<%=color%>","<%=sCONTEXTPATH %>/pacs/getDICOMJpeg.jsp?excludeFromFilter=1&uid=<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")%>;<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID") %>");view("<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")%>","<%=tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID")%>","imgdiv_<%=counter%>");'><%=getTran(request,"web","view",sWebLanguage) %></a>
								</td>
							</tr>
						<%
						if(counter==1){
							sInitialPreview="<script>preview('tr_"+(counter-1)+";"+color+"','"+sCONTEXTPATH+"/pacs/getDICOMJpeg.jsp?excludeFromFilter=1&uid="+tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")+";"+tran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID")+"');</script>";
						}
						if(cls.equalsIgnoreCase("invertedgrey")){
							cls="invertedgrey2";
							color="#606060";
						}
						else{
							cls="invertedgrey";
							color="#808080";
						}
					}
				}
				else{ 
					%>
					<tr>
						<td class='tdgrey'><%=getTran(request,"web","noimages",sWebLanguage)%></td>
					</tr>
					<%
				}
			%>
			</table>
			</div>
		</td>
		<td width='35%' style='vertical-align: top'>
			<table width='100%'>
				<tr>
					<td>
						<img style='max-width: 100%; max-height: 400px;' id='previewDicom'/>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<IFRAME style="display:none" id='hf2' onclick="showProgress(false);" name="hidden-form"></IFRAME>


<script>
	document.getElementById('menu_pacs').style.display='';
	
	function showProgress(doit,imgdiv){
		if(doit==true){
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
	
	function preview(id,src){
		var elements = document.all;
		for(n=0;n<elements.length;n++){
			if(elements[n].id && elements[n].id.indexOf('tr_')==0){
				elements[n].style.backgroundColor=elements[n].id.split(";")[1];
			}
		}
		document.getElementById(id).style.backgroundColor='darkblue';
		document.getElementById('previewDicom').src=src;
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
			//showProgress(true,imgdiv);
	    <%
			}
	    %>
	    window.open(url,"hidden-form");
	}
</script>
<%=sInitialPreview%>
