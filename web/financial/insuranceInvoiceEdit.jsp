<%@page import="be.openclinic.finance.*,
                java.util.Date,
                java.text.DecimalFormat,be.mxs.common.util.system.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"financial.insuranceinvoice","edit",activeUser)%>
<%=sJSPROTOTYPE%>
<%=sJSNUMBER%>

<%
    String sFindInsurarInvoiceUID = checkString(request.getParameter("FindInsurarInvoiceUID"));

	/// DEBUG /////////////////////////////////////////////////////////////////////////////////////
	if(Debug.enabled){
		Debug.println("\n****************** financial/insuranceInvoiceEdit.jsp *****************");
		Debug.println("sFindInsurarInvoiceUID : "+sFindInsurarInvoiceUID+"\n");
	}    
	///////////////////////////////////////////////////////////////////////////////////////////////

    InsurarInvoice insurarInvoice;
    String sInsurarText = "";
    if(sFindInsurarInvoiceUID.length() > 0){
        insurarInvoice = InsurarInvoice.getViaInvoiceUID(sFindInsurarInvoiceUID);
        Insurar insurar = Insurar.get(checkString(insurarInvoice.getInsurarUid()));
        if(insurar!=null){
            sInsurarText = checkString(insurar.getName());
        }
    }
    else{
        insurarInvoice = new InsurarInvoice();
    }
%>
<form name="FindForm" id="FindForm" method="POST">
    <%=writeTableHeader("web","insuranceInvoiceEdit",sWebLanguage)%>
    
    <table class="menu" width="100%" cellpadding="0" cellspacing="1">
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web.finance","invoiceid",sWebLanguage)%></td>
            <td class="admin2">
                <input type="text" class="text" name="FindInsurarInvoiceUID" id="FindInsurarInvoiceUID" onblur="isNumber(this)" value="<%=sFindInsurarInvoiceUID%>">
                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchInsurarInvoice();">
                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="doClear();">

                <%-- BUTTONS --%>
                <input type="button" class="button" name="ButtonFind" value="<%=getTranNoLink("web","find",sWebLanguage)%>" onclick="doFind()">
                <input type="button" class="button" name="ButtonNew" value="<%=getTranNoLink("web","new",sWebLanguage)%>" onclick="doNew();searchInsurar();">
            </td>
        </tr>
    </table>
</form>

<script>
  FindForm.FindInsurarInvoiceUID.focus();

  function searchInsurarInvoice(){
    openPopup("/_common/search/searchInsurarInvoice.jsp&ts=<%=getTs()%>&doFunction=doFind()&ReturnFieldInvoiceNr=FindInsurarInvoiceUID&FindInvoiceInsurar=<%=sFindInsurarInvoiceUID%>");
  }

  function doFind(){
    if(FindForm.FindInsurarInvoiceUID.value.length > 0){
      FindForm.submit();
    }
  }

  function doNew(){
    FindForm.FindInsurarInvoiceUID.value = "";
    FindForm.submit();
  }

  function doClear(){
    FindForm.FindInsurarInvoiceUID.value = "";
    FindForm.FindInsurarInvoiceUID.focus();
  }
</script>

<div id="divOpenInsurarInvoices" style="height:120px;width:100%" class="searchResults"></div>

<form name="EditForm" id="EditForm" method="POST">
<table class="list" width="100%" cellspacing="1" cellpadding="0">
    <%-- INSURANCE COMPANY --%>
    <tr>
        <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"medical.accident","insurancecompany",sWebLanguage)%></td>
        <td class="admin2">
            <input type="hidden" name="EditNumber" value="<%=checkString(insurarInvoice.getNumber())%>">
            <input type="hidden" name="EditInsurarUID" value="<%=checkString(insurarInvoice.getInsurarUid())%>">
            <input type="text" class="text" readonly name="EditInsurarText" value="<%=sInsurarText%>" size="100">
           
            <%
                if(checkString(insurarInvoice.getUid()).length()==0){
                    %>
			            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchInsurar();">
			            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="doClearInsurar()">
                    <%
                }
            %>
        </td>
    </tr>
    
    <tbody id="invoicedetails" style="visibility:hidden">
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web.finance","invoiceid",sWebLanguage)%></td>
            <td class="admin2">
                <input type="text" class="text" readonly name="EditInvoiceUID" id="EditInvoiceUID" value="<%=checkString(insurarInvoice.getInvoiceUid())%>">
				<%
					if(checkString(insurarInvoice.getNumber()).length()>0 && !insurarInvoice.getInvoiceUid().equalsIgnoreCase(insurarInvoice.getInvoiceNumber())){
	            		out.print("("+insurarInvoice.getInvoiceNumber()+")");
	            	}
				%>
            </td>
        </tr>
                
        <%-- DATE --%>
        <tr>
            <td class="admin"><%=getTran(request,"Web","date",sWebLanguage)%> *</td>
            <%
                Date activeDate = insurarInvoice.getDate();
                if(activeDate==null) activeDate = new Date();
            %>
            <td class="admin2"><%=ScreenHelper.writeDateField("EditDate","EditForm",ScreenHelper.getSQLDate(activeDate),true,false,sWebLanguage,sCONTEXTPATH) %></td>
        </tr>
                
        <%-- STATUS --%>
        <tr>
            <td class='admin'><%=getTran(request,"Web.finance","patientinvoice.status",sWebLanguage)%> *</td>
            <td class='admin2'>
                <select class="text" id="EditStatus" name="EditStatus" onchange="doStatus()" <%=insurarInvoice.getStatus()!=null && (insurarInvoice.getStatus().equalsIgnoreCase("closed") || insurarInvoice.getStatus().equalsIgnoreCase("canceled"))?"disabled":""%>>
                    <option/>
                    <%
                        String activeStatus = checkString(insurarInvoice.getStatus());
                        if(activeStatus.length()==0){
                            activeStatus = "open";
                        }
                    %>
                    <%=ScreenHelper.writeSelect(request,"finance.patientinvoice.status",activeStatus,sWebLanguage)%>
                </select>
                &nbsp;
                <%
                	String pointer = Pointer.getLastPointer("INSINVXML."+insurarInvoice.getUid());
                	if(pointer.length()>0){
                		out.println("<img src='"+sCONTEXTPATH+"/_img/icons/icon_info.gif'/>");
                		out.println(ScreenHelper.formatDate(new SimpleDateFormat("yyyy-MM-dd").parse(pointer.split(";")[0]))+": ");
                		out.println("<b>"+ScreenHelper.getTran("paodes.invoicestatus",pointer.split(";")[1],sWebLanguage)+"</b> ("+pointer.split(";")[2]+"%)");
                	}
                %>
            </td>
        </tr>
                
        <%-- PERIOD --%>
        <tr id="period" style="visibility:hidden">
            <td class='admin'><%=getTran(request,"web","period",sWebLanguage)%></td>
            <td class="admin2">
            	<table width="100%">
            		<tr>
            			<td>
            				<table width='100%'>
            					<tr>
            						<td>
		            					<input type='checkbox' name='showunassigned' id='showunassigned' value='1'/><%=getLabel(request,"web","showunassigned",sWebLanguage,"showunassigned")%>
		            				</td>
		            			</tr>
            					<tr>
            						<td>
		            					<input type='checkbox' name='showsummarizedonly' id='showsummarizedonly' value='1'/><%=getLabel(request,"web","showsummarizedonly",sWebLanguage,"showsummarizedonly")%>
		            				</td>
		            			</tr>
		            		</table>
		            	</td>
		        		<td>
			                <%
			                    Date previousmonth = new Date(ScreenHelper.parseDate(new SimpleDateFormat("01/MM/yyyy").format(new Date())).getTime()-1);
			                %>
			                <%=writeDateField("EditBegin","EditForm",new SimpleDateFormat("01/MM/yyyy").format(previousmonth),sWebLanguage)%>
			                <%=getTran(request,"web","to",sWebLanguage)%>
			                <%=writeDateField("EditEnd","EditForm",ScreenHelper.stdDateFormat.format(previousmonth),sWebLanguage)%>
			                <input type="hidden" name="EditInvoiceService" id="EditInvoiceService" value="">
			                <%
			                    if(insurarInvoice==null || insurarInvoice.getStatus()==null || insurarInvoice.getStatus().equalsIgnoreCase("open")){
			                        %>
						            <input class="text" type="text" name="EditInvoiceServiceName" id="EditInvoiceServiceName" readonly size="40" value="">
						            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchService('EditInvoiceService','EditInvoiceServiceName');">
						            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="document.getElementById('EditInvoiceService').value='';document.getElementById('EditInvoiceServiceName').value='';">
			                        <%
			                    }
			                %>                        
			                &nbsp;<input type="button" class="button" name="updateDebets" id="updateDebets" value="<%=getTranNoLink("web","update",sWebLanguage)%>" onclick="changeInsurar(0);"/>
			                &nbsp;<input type="button" class="button" name="updateBalance" value="<%=getTranNoLink("web","updateBalance",sWebLanguage)%>" onclick="updateBalance2();"/>
			            </td>
                	</tr>
                </table>
            </td>
        </tr>
                
        <%-- BALANCE --%>
        <tr>
            <td class="admin"><%=getTran(request,"web.finance","balance",sWebLanguage)%></td>
            <td class="admin2">
                <input class="text" readonly type='text' id='EditBalance' name='EditBalance' value='<%=SH.formatDouble(insurarInvoice.getBalance()) %>' size='20'> <%=MedwanQuery.getInstance().getConfigParam("currency","€")%>
            </td>
        </tr>
        
        <%-- DEBETS/PRESTATIONS --%>
        <tr>
            <td class="admin"><%=getTran(request,"web.finance","prestations",sWebLanguage)%></td>
            <td class="admin2">
                <div id="divPrestations" class="searchResults" style="height:120px;width:100%"></div>
                
                <div style="padding-top:3px">
                    <input class="button" type="button" name="ButtonDebetSelectAll" id="ButtonDebetSelectAll" value="<%=getTranNoLink("web","selectall",sWebLanguage)%>" onclick="selectAll('cbDebet',true,'ButtonDebetSelectAll','ButtonDebetDeselectAll',true);">&nbsp;
                    <input class="button" type="button" name="ButtonDebetDeselectAll" id="ButtonDebetDeselectAll" value="<%=getTranNoLink("web","deselectall",sWebLanguage)%>" onclick="selectAll('cbDebet',false,'ButtonDebetDeselectAll','ButtonDebetSelectAll',true);">
                </div>
            </td>
        </tr>
                
        <%-- CREDITS/PAYMENTS --%>
        <tr>
            <td class="admin"><%=getTran(request,"web.finance","credits",sWebLanguage)%></td>
            <td class="admin2">
                <div id="divCredits" class="searchResults" style="height:120px;width:100%"></div>
                
                <div style="padding-top:3px">
                    <input class="button" type="button" name="ButtonInsurarInvoiceSelectAll" id="ButtonInsurarInvoiceSelectAll" value="<%=getTranNoLink("web","selectall",sWebLanguage)%>" onclick="selectAll('cbCredit',true,'ButtonInsurarInvoiceSelectAll','ButtonInsurarInvoiceDeselectAll',false);">&nbsp;
                    <input class="button" type="button" name="ButtonInsurarInvoiceDeselectAll" id="ButtonInsurarInvoiceDeselectAll" value="<%=getTranNoLink("web","deselectall",sWebLanguage)%>" onclick="selectAll('cbCredit',false,'ButtonInsurarInvoiceDeselectAll','ButtonInsurarInvoiceSelectAll',false);">
                </div>
            </td>
        </tr>
                
        <%-- BUTTONS & PRINT --%>
        <tr height="24">
            <td class="admin"/>
            <td class="admin2">
                <%
                    if(!(checkString(insurarInvoice.getStatus()).equalsIgnoreCase("closed") || 
                         checkString(insurarInvoice.getStatus()).equalsIgnoreCase("canceled"))){
                        %><input class='button' type="button" name="ButtonSave" value='<%=getTranNoLink("Web","save",sWebLanguage)%>' onclick="doSave(this);">&nbsp;<%
                    }

                    // pdf print button for existing invoices
                    if(checkString(insurarInvoice.getUid()).length() > 0){
                        %><%=getTran(request,"Web.Occup","PrintLanguage",sWebLanguage)%><%
                        		
                     String sPrintLanguage = activeUser.person.language;
                     if(sPrintLanguage.length()==0){
                         sPrintLanguage = sWebLanguage;
                     }

                        String sSupportedLanguages = MedwanQuery.getInstance().getConfigString("supportedLanguages","en,fr");
                    %>

                <select class="text" name="PrintLanguage">
                    <%
                        String tmpLang;
                        StringTokenizer tokenizer = new StringTokenizer(sSupportedLanguages,",");
                        while(tokenizer.hasMoreTokens()){
                            tmpLang = tokenizer.nextToken();

                            %><option value="<%=tmpLang%>"<%if (tmpLang.equalsIgnoreCase(sPrintLanguage)){out.print(" selected");}%>><%=getTranNoLink("Web.language",tmpLang,sWebLanguage)%></option><%
                        }
                    %>
                </select>
                <select class="text" name="PrintType">
                    <option value="sortbydate" <%=MedwanQuery.getInstance().getConfigString("defaultInvoiceSortType","sortbydate").equalsIgnoreCase("sortbydate")?"selected":""%>><%=getTranNoLink("web","sortbydate",sWebLanguage)%></option>
                    <option value="sortbypatient" <%=MedwanQuery.getInstance().getConfigString("defaultInvoiceSortType","sortbydate").equalsIgnoreCase("sortbypatient")?"selected":""%>><%=getTranNoLink("web","sortbypatient",sWebLanguage)%></option>
                    <option value="sortbyservice" <%=MedwanQuery.getInstance().getConfigString("defaultInvoiceSortType","sortbydate").equalsIgnoreCase("sortbyservice")?"selected":""%>><%=getTranNoLink("web","sortbyservice",sWebLanguage)%></option>
                </select>
                <%
                	String defaultmodel = MedwanQuery.getInstance().getConfigString("defaultInvoiceModel","default");
                	if(insurarInvoice.getInsurar()!=null && insurarInvoice.getInsurar().getDefaultInsurarInvoiceModel()!=null){
                		defaultmodel = insurarInvoice.getInsurar().getDefaultInsurarInvoiceModel();
                	}
                %>
                <select class="text" name="PrintModel">
                    <option value="default" <%=defaultmodel.equalsIgnoreCase("default")?"selected":""%>><%=getTranNoLink("web","defaultmodel",sWebLanguage)%></option>
	             	<%
	             		if(MedwanQuery.getInstance().getConfigInt("enableRwanda",1)==1){
		             		%>
		                       <option value="rama" <%=defaultmodel.equalsIgnoreCase("rama")?"selected":""%>><%=getTranNoLink("web","ramamodel",sWebLanguage)%></option>
		                       <option value="ramanew" <%=defaultmodel.equalsIgnoreCase("ramanew")?"selected":""%>><%=getTranNoLink("web","ramanewmodel",sWebLanguage)%></option>
		                       <option value="ramacsv" <%=defaultmodel.equalsIgnoreCase("ramacsv")?"selected":""%>><%=getTranNoLink("web","ramacsvmodel",sWebLanguage)%></option>
		                       <option value="rssbcsv" <%=defaultmodel.equalsIgnoreCase("rssbcsv")?"selected":""%>><%=getTranNoLink("web","rssbcsvmodel",sWebLanguage)%></option>
		                       <option value="ctams" <%=defaultmodel.equalsIgnoreCase("ctams")?"selected":""%>><%=getTranNoLink("web","ctamsmodel",sWebLanguage)%></option>
		              		<%
	             		}
	             	
		              	if(MedwanQuery.getInstance().getConfigInt("enableMFP",0)==1){
		                    %>
		                    	<option value="mfp" <%=defaultmodel.equalsIgnoreCase("mfp")?"selected":""%>><%=getTranNoLink("web","mfpmodel",sWebLanguage)%></option>
	                            <option value="mfpcsv" <%=defaultmodel.equalsIgnoreCase("mfpcsv")?"selected":""%>><%=getTranNoLink("web","mfpcsvmodel",sWebLanguage)%></option>
		                    <%
		           		}
		              	if(MedwanQuery.getInstance().getConfigInt("enableCCBRT",0)==1){
		                    %>
		                    	<option value="ccbrtacsv" <%=defaultmodel.equalsIgnoreCase("ccbrtacsv")?"selected":""%>><%=getTranNoLink("web","ccbrtacsvmodel",sWebLanguage)%></option>
		                    	<option value="ccbrtbcsv" <%=defaultmodel.equalsIgnoreCase("ccbrtbcsv")?"selected":""%>><%=getTranNoLink("web","ccbrtbcsvmodel",sWebLanguage)%></option>
		                    <%
		           		}
		              	
		              	if(SH.cs("edition","openclinic").equalsIgnoreCase("bloodbank")){
		                    %>
		                    	<option value="cnts" <%=defaultmodel.equalsIgnoreCase("cnts")?"selected":""%>><%=getTranNoLink("web","CNTS-BI",sWebLanguage)%></option>
		                    <%
		           		}
		              	
                    	if(MedwanQuery.getInstance().getConfigInt("enableBurundi",0)==1){
		                    %>
	                            <option value="hmk" <%=defaultmodel.equalsIgnoreCase("hmk")?"selected":""%>><%=getTranNoLink("web","hmkmodel",sWebLanguage)%></option>
	                            <option value="ascoma" <%=defaultmodel.equalsIgnoreCase("ascoma")?"selected":""%>><%=getTranNoLink("web","ascomamodel",sWebLanguage)%></option>
	                            <option value="brarudi" <%=defaultmodel.equalsIgnoreCase("brarudi")?"selected":""%>><%=getTranNoLink("web","brarudimodel",sWebLanguage)%></option>
	                            <option value="ambusa" <%=defaultmodel.equalsIgnoreCase("ambusa")?"selected":""%>><%=getTranNoLink("web","ambusamodel",sWebLanguage)%></option>
	                            <option value="cplrcsv" <%=defaultmodel.equalsIgnoreCase("cplrcsv")?"selected":""%>><%=getTranNoLink("web","cplrcsvmodel",sWebLanguage)%></option>
	                            <option value="msplscsv" <%=defaultmodel.equalsIgnoreCase("msplscsv")?"selected":""%>><%=getTranNoLink("web","msplscsvmodel",sWebLanguage)%></option>
	                            <option value="cmck" <%=defaultmodel.equalsIgnoreCase("cmck")?"selected":""%>><%=getTranNoLink("web","cmckmodel",sWebLanguage)%></option>
	                            <option value="cmckcsv" <%=defaultmodel.equalsIgnoreCase("cmckcsv")?"selected":""%>><%=getTranNoLink("web","cmckcsvmodel",sWebLanguage)%></option>
                        	<%
           				}
                       	%>
                        </select>
                            <%
                                if(insurarInvoice.getStatus().equalsIgnoreCase("closed")){
                            %>
                                <input class="button" type="button" name="ButtonPrint" value='<%=getTranNoLink("Web","printinvoice",sWebLanguage)%>' onclick="doPrintPdf('<%=insurarInvoice.getUid()%>');">
                            <%
	                            	if(MedwanQuery.getInstance().getConfigInt("enableInsurerInvoiceXMLSend",0)==1){
	                        %>
                                	<input class="button" type="button" name="ButtonSend" value='<%=getTranNoLink("Web","sendinvoice",sWebLanguage)%>' onclick="doSendPdf('<%=insurarInvoice.getUid()%>');">
	                        <% 
	                            	}
                                }
                                else{
                            %>
                                <input class="button" type="button" name="ButtonPrint" value='<%=getTranNoLink("Web","printprestationlist",sWebLanguage)%>' onclick="doPrintPdf('<%=insurarInvoice.getUid()%>');">
                            <%
                                }
                            }
                        %>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<%=getTran(request,"Web","colored_fields_are_obligate",sWebLanguage)%>

<div id="divMessage"></div>

<input type='hidden' name='EditInsurarInvoiceUID' id='EditInsurarInvoiceUID' value='<%=checkString(insurarInvoice.getUid())%>'>
</form>

<script>
  <%-- DO SAVE --%>
  function doSave(){
    if(EditForm.EditDate.value.length>0 && EditForm.EditStatus.selectedIndex > -1 && EditForm.EditInsurarUID.value.length>0){
      document.getElementById('divMessage').innerHTML = "<img src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/><br/>Saving";
        
      EditForm.ButtonSave.disabled = true;
      var images = document.getElementsByTagName("img");
      var selectedimages = [];
      for(i=0; i<images.length; i++){
        var elm = images[i];
        if(elm.name.indexOf('cbDebet') > -1){
          if(elm.src.indexOf('/check.gif')>0){
            var uid = elm.name.split("=")[0].replace('cbDebet','d');
            selectedimages.push(uid);
          }
        }
        else if(elm.name.indexOf('cbCredit') > -1){
          if(elm.src.indexOf('/check.gif')>0){
            var uid = elm.name.split("=")[0].replace('cbCredit','c');
            selectedimages.push(uid);
          }
        }
      }
      
      var url = '<c:url value="/financial/insuranceInvoiceSave.jsp"/>?ts='+new Date();
      new Ajax.Request(url,{
        method: "POST",
        postBody: 'EditDate='+EditForm.EditDate.value+
                  '&EditInsurarInvoiceUID='+EditForm.EditInsurarInvoiceUID.value+
                  '&EditInvoiceUID='+EditForm.EditInvoiceUID.value+
                  '&EditInsurarUID='+EditForm.EditInsurarUID.value+
                  '&EditStatus='+EditForm.EditStatus.value+
                  '&EditNumber='+EditForm.EditNumber.value+
                  '&EditCBs='+selectedimages.join()+
                  '&EditBalance='+EditForm.EditBalance.value,
        onSuccess: function(resp){
          var label = eval('('+resp.responseText+')');
          $('divMessage').innerHTML = label.Message;
          $('EditInsurarInvoiceUID').value = label.EditInsurarInvoiceUID;
          $('EditInvoiceUID').value = label.EditInvoiceUID;
          $('FindInsurarInvoiceUID').value = label.EditInvoiceUID;
          EditForm.ButtonSave.disabled = false;
          window.setTimeout("loadOpenInsurarInvoices()",200);
          window.setTimeout("doFind()",200);
        },
        onFailure: function(){
          $('divMessage').innerHTML = "Error in function manageTranslationsStore() => AJAX";
        }
      });
    }
    else{
                window.showModalDialog?alertDialog("web.manage","dataMissing"):alertDialogDirectText('<%=getTran(null,"web.manage","dataMissing",sWebLanguage)%>');
    }
  }

  <%-- COUNT DEBETS --%>
  function countDebets(){
    var tot = 0;
    var images = document.getElementsByTagName("img");
    for(i=0; i<images.length; i++){
      var elm = images[i];
      if(elm.name.indexOf('cbDebet') > -1){
        if(elm.src.indexOf('/check.gif')>0){
          var amount = elm.name.split("=")[1];
          tot = tot+parseFloat(amount.replace(",","."));
        }
      }
    }
    return tot;
  }

<%-- COUNT CREDITS --%>
function countCredits(){
  var tot = 0;
  var images = document.getElementsByTagName("img");
  for(i=0; i<images.length; i++){
    var elm = images[i];
    if(elm.name.indexOf('cbCredit') > -1){
      if(elm.src.indexOf('/check.gif')>0){
        var amount = elm.name.split("=")[1];
        tot = tot+parseFloat(amount.replace(",","."));
      }
    }
  }
  return tot;
}

<%-- SELECT ALL --%>
function selectAll(sStartsWith,bValue,buttonDisable,buttonEnable,bAdd){
  var images = document.getElementsByTagName("img");
  for(i=0; i<images.length; i++){
    var elm = images[i];

    if(elm.name.indexOf(sStartsWith) > -1){
      if(bValue){
        elm.src = '_img/themes/default/check.gif';
      }
      else{
        elm.src = '_img/themes/default/uncheck.gif'; 
      }
    }
  }
  
  updateBalance2();
}

<%-- UPDATE BALANCE --%>
function updateBalance2(){
  EditForm.EditBalance.value = countDebets()-countCredits();
  EditForm.EditBalance.value = format_number(EditForm.EditBalance.value*1,<%=MedwanQuery.getInstance().getConfigInt("currencyDecimals",2)%>);
}

<%-- DO BALANCE --%>
function doBalance(oObject,bAdd){
  var amount = oObject.name.split("=")[1];
  if(oObject.src.indexOf('/check.gif')>0){
    oObject.src='_img/themes/default/uncheck.gif';
  }
  else{
  	oObject.src='_img/themes/default/check.gif';
  }
  
  if(bAdd){
    if(oObject.src.indexOf('/check.gif')>0){
      EditForm.EditBalance.value = parseFloat(EditForm.EditBalance.value.replace(",","."))+parseFloat(amount.replace(",","."));
    }
    else{
      EditForm.EditBalance.value = parseFloat(EditForm.EditBalance.value.replace(",",".")) - parseFloat(amount.replace(",","."));
    }
  }
  else{
    if(oObject.src.indexOf('/check.gif')>0){
      EditForm.EditBalance.value = parseFloat(EditForm.EditBalance.value.replace(",",".")) - parseFloat(amount.replace(",","."));
    }
    else{
      EditForm.EditBalance.value = parseFloat(EditForm.EditBalance.value.replace(",","."))+parseFloat(amount.replace(",","."));
    }
  }
  
  EditForm.EditBalance.value = format_number(EditForm.EditBalance.value,<%=MedwanQuery.getInstance().getConfigInt("currencyDecimals",2)%>);
}

function doSendPdf(invoiceUid){
	var url = "<c:url value='popup.jsp?Page=/financial/sendInsurerInvoice.jsp'/>&invoiceuid=" + invoiceUid + "&ts=<%=getTs()%>";
    window.open(url, "InsurarInvoiceSend<%=new java.util.Date().getTime()%>", "height=200,width=300,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");
}

<%-- PRINT PDF --%>
function doPrintPdf(invoiceUid) {
    if(EditForm.PrintModel.value=='ramacsv'){
		var url = "<c:url value='/util/csvDocs.jsp'/>?invoiceuid=" + invoiceUid + "&ts=<%=getTs()%>&docid=invoice.rama";
		location.href=url;
    }
    else if(EditForm.PrintModel.value=='cmckcsv'){
		var url = "<c:url value='/util/csvDocs.jsp'/>?invoiceuid=" + invoiceUid + "&ts=<%=getTs()%>&docid=invoice.cmck";
		location.href=url;
    }
    else if(EditForm.PrintModel.value=='rssbcsv'){
		var url = "<c:url value='/util/csvDocs.jsp'/>?invoiceuid=" + invoiceUid + "&ts=<%=getTs()%>&docid=invoice.rssb";
		location.href=url;
    }
    else if(EditForm.PrintModel.value=='cplrcsv'){
		var url = "<c:url value='/util/csvDocs.jsp'/>?invoiceuid=" + invoiceUid + "&ts=<%=getTs()%>&docid=invoice.cplr";
		location.href=url;
    }
    else if(EditForm.PrintModel.value=='ccbrtacsv'){
		var url = "<c:url value='/util/csvDocs.jsp'/>?invoiceuid=" + invoiceUid + "&ts=<%=getTs()%>&docid=invoice.ccbrta";
		location.href=url;
    }
    else if(EditForm.PrintModel.value=='ccbrtbcsv'){
		var url = "<c:url value='/util/csvDocs.jsp'/>?invoiceuid=" + invoiceUid + "&ts=<%=getTs()%>&docid=invoice.ccbrtb";
		location.href=url;
    }
    else if(EditForm.PrintModel.value=='mfpcsv'){
		var url = "<c:url value='/util/csvDocs.jsp'/>?invoiceuid=" + invoiceUid + "&ts=<%=getTs()%>&docid=invoice.mfp";
		location.href=url;
    }
    else if(EditForm.PrintModel.value=='msplscsv'){
		var url = "<c:url value='/util/csvDocs.jsp'/>?invoiceuid=" + invoiceUid + "&ts=<%=getTs()%>&docid=invoice.mspls";
		location.href=url;
    }
    else {
		var url = "<c:url value='/financial/createInsurarInvoicePdf.jsp'/>?InvoiceUid=" + invoiceUid + "&ts=<%=getTs()%>&PrintLanguage=" + EditForm.PrintLanguage.value+ "&PrintType="+EditForm.PrintType.value+"&PrintModel="+EditForm.PrintModel.value;
	    window.open(url, "InsurarInvoicePdf<%=new java.util.Date().getTime()%>", "height=600,width=900,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");
    }
}

function searchInsurar(){
  openPopup("/_common/search/searchInsurar.jsp&ts=<%=getTs()%>&ReturnFieldInsurarUid=EditInsurarUID&ReturnFieldInsurarName=EditInsurarText&doFunction=changeInsurar(0)&excludePatientSelfIsurarUID=true&PopupHeight=500&PopupWith=500");
}

function doClearInsurar(){
  EditForm.EditInsurarUID.value = "";
  EditForm.EditInsurarText.value = "";
}

function doStatus(){
}

function loadOpenInsurarInvoices(){
  var url = '<c:url value="/financial/insurarInvoiceGetOpenInsurarInvoices.jsp"/>?ts='+new Date();
  new Ajax.Request(url,{
    method: "GET",
    parameters: "",
    onSuccess: function(resp){
      $('divOpenInsurarInvoices').innerHTML = resp.responseText;
    }
  });
}

function setInsurarInvoice(sUid){
  FindForm.FindInsurarInvoiceUID.value = sUid;
  FindForm.submit();
}

<%-- CHANGE INSURAR --%>
function changeInsurar(counter){
  var tot = 0;
  if(EditForm.EditInsurarUID.value.length>0){
    document.getElementById("invoicedetails").style.visibility="visible";   
  }
  else{
    document.getElementById("invoicedetails").style.visibility="hidden";
  }
  
  var url = '<c:url value="/financial/insurarInvoiceGetPrestations.jsp"/>?ts='+<%=getTs()%>;
  document.getElementById('divPrestations').innerHTML = "<img src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/><br/>Loading..";
  
  var pb = 'InsurarUid='+EditForm.EditInsurarUID.value+
           '&EditBegin='+EditForm.EditBegin.value+
           '&EditEnd='+EditForm.EditEnd.value+
           '&EditInvoiceService='+EditForm.EditInvoiceService.value+
           '&ShowUnassigned='+document.getElementById('showunassigned').checked+
           '&ShowSummarized='+document.getElementById('showsummarizedonly').checked+
           '&EditInsurarInvoiceUID=<%=checkString(insurarInvoice.getUid())%>';
  new Ajax.Request(url,{
    method: "POST",
    postBody: pb,
    onSuccess: function(resp){
      var s = resp.responseText;
      $('divPrestations').innerHTML = s;
      tot = tot+countDebets();
      document.getElementById('EditBalance').value=format_number(tot,<%=MedwanQuery.getInstance().getConfigInt("currencyDecimals",2)%>);
    }
  });

  var url = '<c:url value="/financial/insurarInvoiceGetCredits.jsp"/>?ts='+<%=getTs()%>;
  document.getElementById('divCredits').innerHTML = "<img src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/><br/>Loading..";
  new Ajax.Request(url,{
    method: "POST",
    postBody: 'InsurarUid='+EditForm.EditInsurarUID.value+
              '&EditInsurarInvoiceUID=<%=checkString(insurarInvoice.getUid())%>',
    onSuccess: function(resp){
      $('divCredits').innerHTML = resp.responseText;
      tot=tot-countCredits();
      document.getElementById('EditBalance').value=format_number(tot,<%=MedwanQuery.getInstance().getConfigInt("currencyDecimals",2)%>);
    }
  });
  
  if(document.getElementById("invoicedetails").style.visibility=="visible" && !(EditForm.EditInsurarUID.value.length>0 && (document.getElementById("EditStatus").value=='closed' || document.getElementById("EditStatus").value=='canceled'))){
    document.getElementById('period').style.visibility='visible';
  }
  else{
    document.getElementById('period').style.visibility='hidden';
  }
}

function openPatientInvoice(uid){
    openPopup("/financial/patientInvoiceEdit.jsp&ts=<%=getTs()%>&PopupWidth="+(screen.width-200)+"&PopupHeight=600&showpatientname=true&FindPatientInvoiceUID="+uid);
}

  function searchService(serviceUidField,serviceNameField){
    openPopup("/_common/search/searchService.jsp&ts=<%=getTs()%>&VarCode="+serviceUidField+"&VarText="+serviceNameField);
    document.getElementById(serviceNameField).focus();
  }

  FindForm.FindInsurarInvoiceUID.focus();
  loadOpenInsurarInvoices();
</script>

<script>window.setTimeout("document.getElementById('updateDebets').onclick();",1000);</script>