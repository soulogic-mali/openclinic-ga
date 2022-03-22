<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String transactionId = checkString(request.getParameter("transactionId"));
	String serverId = checkString(request.getParameter("serverId"));
	String destination = MedwanQuery.getInstance().getConfigString("defaultGHBdestination","");
	String destinationid="";
	String destinationname="";
	if(destination.split(";").length>1){
		destinationid=destination.split(";")[0];
		destinationname=destinationid+" - "+destination.split(";")[1];
	}
%>

<form name="transactionForm" id="transactionForm" method="post" action='util/sendReferral.jsp'>
	<table width='100%'>
		<tr class='admin'>
			<td><%=getTran(request,"web","selectdestination",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin'>
				<input type='hidden' name='destinationid' id='destinationid' value='<%=destinationid%>'/>
				<input type='text' class='text' name='destination' id='destination' value='<%=destinationname%>' size='50'/>
				<img style='vertical-align: middle' src='<%=sCONTEXTPATH %>/_img/icons/icon_sync.gif' name='syncButton' title='<%=getTranNoLink("web.manage","synchronise",sWebLanguage) %>' onclick='syncServers()'/>
				<img style='vertical-align: middle' src='<%=sCONTEXTPATH %>/_img/icons/icon_search.png' name='searchButton' title='<%=getTranNoLink("web","search",sWebLanguage) %>' onclick='searchServers()'/>
				&nbsp;&nbsp;&nbsp;&nbsp;<input type='button' name='send' value='<%=getTranNoLink("web","send",sWebLanguage) %>' onclick='doSend()'/>
				<div id="autocomplete_destination" class="autocomple"></div>
			</td>
		</tr>
		<tr class='admin'>
			<td><%=getTran(request,"web","selectcontent",sWebLanguage) %></td>
		</tr>
		<tr>
			<td>
				<table width='100%'>
				<%
					HashSet trans = new HashSet();
					if(transactionId.length()>0 && serverId.length()>0){
						TransactionVO transaction = MedwanQuery.getInstance().loadTransaction(Integer.parseInt(serverId), Integer.parseInt(transactionId));
						if(transaction!=null){
							trans.add(transaction.getServerId()+"."+transaction.getTransactionId());
							%>
								<tr class='admin'>
									<td><%=getTran(request,"web","activedocument",sWebLanguage) %></td>
								</tr>
								<tr><td><table width='100%'>
								<tr>
									<td class='admin2' width='1%' nowrap><input type='checkbox' class='text' name='cbSend_<%=transaction.getServerId()+"_"+transaction.getTransactionId() %>' checked/></td>
									<td class='admin2' width='15%'><%=ScreenHelper.formatDate(transaction.getUpdateTime()) %></td>
									<td class='admin2' width='50%'><b><%=getTran(request,"web.occup",transaction.getTransactionType(),sWebLanguage) %></b></td>
									<td class='admin2'><%=transaction.getUser().personVO.getFullName() %></td>
								</tr>
								</table></td></tr>
							<%
						}
					}
					Encounter encounter = Encounter.getActiveEncounter(activePatient.personid);
					if(encounter!=null){
						//Now also find other transactions from the active encounter
						Vector transactions = MedwanQuery.getInstance().getTransactionsByEncounter(Integer.parseInt(activePatient.personid), encounter.getUid());
						if(transactions.size()>0){
							%>
								<tr class='admin'>
									<td><%=getTran(request,"web","activeencounter",sWebLanguage) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='checkbox' class='text' onclick='if(this.checked){document.getElementById("contact_tr").style.display="";}else{document.getElementById("contact_tr").style.display="none";}'/><%=getTran(request,"web","show",sWebLanguage) %></td>
								</tr>
								<tr style='display: none' id='contact_tr'><td><table width='100%'>
							<%
							for(int n=0;n<transactions.size();n++){
								TransactionVO transaction = (TransactionVO)transactions.elementAt(n);
								if(transaction!=null && !trans.contains(transaction.getServerId()+"."+transaction.getTransactionId())){
									trans.add(transaction.getServerId()+"."+transaction.getTransactionId());
									%>
										<tr>
											<td class='admin2' width='1%' nowrap><input type='checkbox' class='text' name='cbSend_<%=transaction.getServerId()+"_"+transaction.getTransactionId() %>'/></td>
											<td class='admin2' width='15%'><%=ScreenHelper.formatDate(transaction.getUpdateTime()) %></td>
											<td class='admin2' width='50%'><b><%=getTran(request,"web.occup",transaction.getTransactionType(),sWebLanguage) %></b></td>
											<td class='admin2'><%=transaction.getUser()==null || transaction.getUser().personVO==null?"":transaction.getUser().personVO.getFullName() %></td>
										</tr>
									<%
								}
							}
							%>
								</table></td></tr>
							<%
						}
					}
					Vector transactions = MedwanQuery.getInstance().getTransactionsAfter(Integer.parseInt(activePatient.personid), ScreenHelper.parseDate("01/01/1900"));
					if(transactions.size()>0){
						%>
							<tr class='admin'>
								<td><%=getTran(request,"web","othertransactions",sWebLanguage) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='checkbox' class='text' onclick='if(this.checked){document.getElementById("other_tr").style.display="";}else{document.getElementById("other_tr").style.display="none";}'/><%=getTran(request,"web","show",sWebLanguage) %></td>
							</tr>
							<tr style='display: none' id='other_tr'><td><table width='100%'>
						<%
						for(int n=0;n<transactions.size();n++){
							TransactionVO transaction = (TransactionVO)transactions.elementAt(n);
							if(transaction!=null && trans!=null && !trans.contains(transaction.getServerId()+"."+transaction.getTransactionId())){
								trans.add(transaction.getServerId()+"."+transaction.getTransactionId());
								if(transaction.getServerId()==1){
								%>
									<tr>
										<td class='admin2' width='1%' nowrap><input type='checkbox' class='text' name='cbSend_<%=transaction.getServerId()+"_"+transaction.getTransactionId() %>'/></td>
										<td class='admin2' width='15%'><%=ScreenHelper.formatDate(transaction.getUpdateTime()) %></td>
										<td class='admin2' width='50%'><b><%=getTran(request,"web.occup",transaction.getTransactionType(),sWebLanguage) %></b></td>
										<td class='admin2'><%=transaction.getUser()==null || transaction.getUser().personVO==null?"":transaction.getUser().personVO.getFullName() %></td>
									</tr>
								<%
								}
								else{
									%>
									<tr>
										<td class='admin2' width='1%' nowrap><input type='checkbox' class='text' name='cbSend_<%=transaction.getServerId()+"_"+transaction.getTransactionId() %>'/></td>
										<td class='admin2' width='15%'><%=ScreenHelper.formatDate(transaction.getUpdateTime()) %></td>
										<td class='admin2' width='50%'><b><%=getTran(request,"web.occup",transaction.getTransactionType(),sWebLanguage) %></b></td>
										<td class='adminred'><%=transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REFERRAL_SOURCESITE") %></td>
									</tr>
								<%
								}
							}
						}
						%>
							</table></td></tr>
						<%
					}
				%>
				</table>
			</td>
		</tr>
	</table>
	
</form>

<script>
	function syncServers(){
	    var url = '<c:url value="/util/updateGHBServers.jsp"/>'+
	              '?ts='+new Date().getTime();
	    new Ajax.Request(url,{
	      parameters: "domain=<%=MedwanQuery.getInstance().getConfigString("ghb_ref_projectdomain","")%>",
	      onSuccess: function(resp){
	    	  alert('<%=getTranNoLink("web","serverssynchronizedfordomain",sWebLanguage)+" ["+MedwanQuery.getInstance().getConfigString("ghb_ref_projectdomain","")+"]"%>');
	      }
	    });
	  }

	var myautocompleter = new Ajax.Autocompleter('destination','autocomplete_destination','util/showGHBServers.jsp',{
		  minChars:1,
		  method:'post',
		  afterUpdateElement:afterAutoComplete,
		  callback:composeCallbackURL
		});
		
	function afterAutoComplete(field,item){
	  var regex = new RegExp('[-0123456789.]*-idcache','i');
	  var nomimage = regex.exec(item.innerHTML);
	  var id = nomimage[0].replace('-idcache','');
	  document.getElementById("destinationid").value = id;
	  document.getElementById("destination").value=id+" - "+document.getElementById("destination").value.substring(0,document.getElementById("destination").value.indexOf(id));
	}
		
	function composeCallbackURL(field,item){
	  var url = "";
	  if(field.id=="destination"){
		url = "findName="+field.value;
	  }
	  return url;
	}
	
	function doSend(){
		if(document.getElementById('destinationid').value.length>0 && document.getElementById('destination').value.length>0){
			transactionForm.submit();
		}
		else{
			alert('<%=getTranNoLink("web","datamissing",sWebLanguage)%>');
			document.getElementById('destination').focus();
		}
	}
	<%
	    if(MedwanQuery.getInstance().getConfigInt("enableArmyWeek",0)==1){
	%>
			doSend();
	<%
	    }
	%>
	
	function searchServers(){
		openPopup("_common/search/searchGHBServers.jsp&PopuWidth=400&PopupHeight=400");
	}
	document.getElementById("destination").focus();
</script>
