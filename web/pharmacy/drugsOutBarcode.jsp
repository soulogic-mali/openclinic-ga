<%@page import="be.openclinic.pharmacy.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>

<%
    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n********************* pharmacy/drugsOutBarcode.jsp ********************");
        Debug.println("no parameters");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////
%>

<form name="drugsOutForm" method="post">
    <table width="100%" class="list" cellpadding="0" cellspacing="1">  
    	<tr class='admin'>
    		<td colspan='2'><%=getTran(request,"web","drugsoutbarcode",sWebLanguage) %>&nbsp;&nbsp;&nbsp;&nbsp;<span id="interactionswarning">&nbsp;</span></td>
    	</tr>      
        <%-- SERVICE STOCK --%>
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web","servicestock",sWebLanguage)%></td>
            <td class="admin2">
                <select class='text' name="servicestock" id="servicestock" onchange="setDefaultPharmacy();doAdd('yes');">
                    <option value=""><%=getTranNoLink("web","choose",sWebLanguage)%></option>
                    <%
                        String defaultPharmacy = (String)session.getAttribute("defaultPharmacy");
                        Vector servicestocks = ServiceStock.getStocksByUser(activeUser.userid);
                        
                        ServiceStock stock;
                        for(int n=0; n<servicestocks.size(); n++){
                            stock = (ServiceStock)servicestocks.elementAt(n);
                            out.print("<option value='"+stock.getUid()+"' "+(stock.getUid().equals(defaultPharmacy)?"selected":"")+">"+stock.getName().toUpperCase()+"</option>");
                        }
                    %>
                </select>
            </td>
        </tr>
        
        <%-- PRODUCT --%>
        <tr>
            <td class='admin'><%=getTran(request,"web","product",sWebLanguage)%></td>
            <td class='admin2'>
		        <input type="hidden" name="EditProductUid" id="EditProductUid" value="">
            	<input type='text' class='text' name='drugbarcode' id='drugbarcode' size='60' onkeyup='if(document.getElementById("EditProductUid").value.length>0 && enterEvent(event,13)){doAdd("");document.getElementById("EditProductUid").value=""}'/>
				<div id="autocomplete_prescription" class="autocomple"></div>
            </td>
        </tr>
        
        <%-- QUANTITY --%>
        <tr>
            <td class='admin'><%=getTran(request,"web","quantity",sWebLanguage)%></td>
            <td class='admin2'><input type='text' class='text' name='quantity' id='quantity' size='5' value='1'/></td>
        </tr>
        <%
        	String sEditEncounterUid="";
			Encounter encounter = Encounter.getActiveEncounter(activePatient.personid);
			if(encounter!=null){
				sEditEncounterUid = encounter.getUid();
			}
        %>
        <%-- ENCOUNTER --%>
        <tr id='encounterline'>
            <td class='admin'><%=getTran(request,"web","encounter",sWebLanguage)%>&nbsp;*</td>
            <td class='admin2'>
                <input type="hidden" name="EditEncounterUID" id="EditEncounterUID" value="<%=sEditEncounterUid%>" onchange='doAdd("yes")'>
                <%
	                encounter = Encounter.get(sEditEncounterUid);
					String sEditEncounterName = "";
	                if(encounter!=null && encounter.getEncounterDisplayName(sWebLanguage)!=null && encounter.getEncounterDisplayName(sWebLanguage).indexOf("null")==-1 ){
	                    sEditEncounterName = encounter.getEncounterDisplayName(sWebLanguage);
	                }		
                %>
                <input class="text" type="text" name="EditEncounterName" id="EditEncounterName" readonly size="<%=sTextWidth%>" value="<%=sEditEncounterName%>">
                
                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchEncounter('EditEncounterUID','EditEncounterName');">
                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="document.getElementById('EditEncounterUID').value='';document.getElementById('EditEncounterName').value='';">
            </td>
        </tr>
        <%-- PRESCRIBER --%>
        <tr>
            <td class='admin'><%=getTran(request,"web","prescriber",sWebLanguage)%></td>
            <td class='admin2'>
            	<select class='text' name='prescriber' id='prescriber'>
            		<option/>
            		<%
            			Connection conn = MedwanQuery.getInstance().getAdminConnection();
            			PreparedStatement ps = conn.prepareStatement("select distinct lastname,firstname,a.personid,userid from admin z,adminextends a,users b where z.personid=a.personid and a.personid=b.personid and b.stop is null and a.labelid='usergroup' and a.extendvalue='"+MedwanQuery.getInstance().getConfigString("physicianCategory", "192.0.0")+"' order by lastname,firstname");
            			ResultSet rs = ps.executeQuery();
            			while(rs.next()){
            				String name = rs.getString("lastname").toUpperCase()+", "+rs.getString("firstname");
            				String userid=rs.getString("userid");
            				if(userid.equalsIgnoreCase(activeUser.userid)){
            					out.println("<option value='"+userid+"' selected>"+name+"</option>");
            				}
            				else if(activeUser.getAccessRightNoSA("fastdrugsprescription.selectprescriber.add")){
            					out.println("<option value='"+userid+"'>"+name+"</option>");
            				}
            			}
            			rs.close();
            			ps.close();
            			conn.close();
            		%>
            	</select>
            </td>
        </tr>
        <tr>
            <td class='admin'><%=getTran(request,"web","comment",sWebLanguage)%></td>
            <td class='admin2'><input type='text' class='text' name='comment' id='comment' size='60' value=''/></td>
        </tr>
        
        <%-- BUTTONS --%>
        <tr>
            <td class='admin'>&nbsp;</td>
            <td class='admin'>
            	<%if(activeUser.getAccessRight("fastdrugsprescription.add")){ %>
                	<input type='button' class="button" name='addbutton' id='addbutton' value='<%=getTranNoLink("web","add",sWebLanguage)%>' onclick="doAdd('');"/>&nbsp;&nbsp;&nbsp;
                <%} %>
            	<%if(activeUser.getAccessRight("fastdrugsdelivery.add")){ %>
	                <input type='button' class="button" name='deliverbutton' id='deliverbutton' value='<%=getTranNoLink("web","deliver",sWebLanguage)%>' onclick="doDeliver('');"/>
                <%} %>
            	<%if(activeUser.getAccessRight("financial.patientinvoice.add")){ %>
	                <input type='button' class="button" name='invoicebutton' id='invoicebutton' value='<%=getTranNoLink("web","invoice",sWebLanguage)%>' onclick='window.opener.location.href="<c:url value="main.do?Page=financial/patientInvoiceEdit.jsp&autopharmacylist="/>"+document.getElementById("servicestock").value;window.close();'/>
                <%} %>
            	<%if(activeUser.getAccessRight("prescriptions.drugs.select")){ %>
	                <input type='button' class="button" name='prescriptionbutton' id='prescriptionbutton' value='<%=getTranNoLink("web","prescription",sWebLanguage)%>' onclick='printPaperPrescription();'/>
                <%} %>
            </td>
        </tr>
    </table>    
</form>
<form name="printPrescriptionForm" id="printPrescriptionForm" method="post" action="<c:url value='/'/>medical/createPrescriptionPdf.jsp">
    <input type="hidden" name="prescriptiondate" id="prescriptiondate" value="<%=ScreenHelper.stdDateFormat.format(new java.util.Date())%>"/>
    <input type="hidden" name="prescription" id="prescription" value=""/>
</form>


<%-- SEARCH RESULTS (ajax) --%>
<div name="divDrugsOut" id="divDrugsOut"></div>

<%=ScreenHelper.alignButtonsStart()%>
    <input type="button" class="button" name="closeButton" value="<%=getTranNoLink("web","close",sWebLanguage)%>" onclick="window.close();"/>
<%=ScreenHelper.alignButtonsStop()%>
            
<script>
  <%-- DO ADD --%>
  function doAdd(loadonly){
	if(loadonly!='yes' && document.getElementById("EditEncounterUID").value.length==0){
		alert('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
		return;
	}
	else if(loadonly!='yes' && document.getElementById("EditProductUid").value.length==0){
		alert('<%=getTranNoLink("web","no.product.specified",sWebLanguage)%>');
		return;
	}
	else if(loadonly!='yes' && document.getElementById("servicestock").value.length==0){
		alert('<%=getTranNoLink("web","no.servicestock.specified",sWebLanguage)%>');
		return;
	}
    var url = "<c:url value='/pharmacy/addDrugsOutBarcode.jsp'/>?loadonly="+loadonly+
              "&ServiceStock="+document.getElementById("servicestock").value+
              "&DrugUid="+document.getElementById("EditProductUid").value+
              "&DrugBarcode="+document.getElementById("drugbarcode").value+
              "&EncounterUid="+document.getElementById("EditEncounterUID").value+
              "&Quantity="+document.getElementById("quantity").value+
              "&prescriber="+document.getElementById("prescriber").value+
              "&Comment="+document.getElementById("prescriber").options[document.getElementById("prescriber").selectedIndex].text+(document.getElementById("prescriber").options[document.getElementById("prescriber").selectedIndex].text.length>0 && document.getElementById("comment").value.length>0?", ":"")+document.getElementById("comment").value+
              "&ts="+new Date().getTime();
    new Ajax.Request(url,{
      method: "POST",
      parameters: "",
      onSuccess: function(resp){
        var label = eval('('+resp.responseText+')');
        if(label.message && label.message.length>0){
          $("divDrugsOut").innerHTML = "<font color='red'>"+label.message+"</font>";
          window.setTimeout('doAdd("yes")',1000);
        }
        else{
          if(label.drugs.length > 0){
            $("divDrugsOut").innerHTML = label.drugs;
            if(document.getElementById('deliverbutton') &&label.drugs.indexOf("<NODELIVERY>")>-1){
            	document.getElementById('deliverbutton').style.visibility='hidden';
            }
            else if (document.getElementById('deliverbutton')){
            	document.getElementById('deliverbutton').style.visibility='visible';
            }
          }
          if(loadonly!='yes'){
        	  document.getElementById("drugbarcode").value = "";
        	  document.getElementById("EditProductUid").value = "";
          }
          else if(document.getElementById("drugbarcode").value.length>0){
        	  myautocompleter.activate();
          }
        }
        checkForInteractions();
      }
    });
    document.getElementById('drugbarcode').focus();  
  }
  
  function printPaperPrescription(){
	  var elements = document.all;
	  for(n=0;n<elements.length;n++){
		  if(elements[n].id && elements[n].id.startsWith('drugname.')){
			  document.getElementById('prescription').value+='R/ '+elements[n].innerHTML+"\n\n";
		  }
	  }
	  document.getElementById('printPrescriptionForm').submit();
  }
  
  <%-- DO DELETE --%>
  function doDelete(listuid){
    var url = '<c:url value="/pharmacy/deleteDrugsOutBarcode.jsp"/>?listuid='+listuid+'&ts='+new Date();
    new Ajax.Request(url,{
      method: "GET",
      parameters: "",
      onSuccess: function(resp){
        var label = eval('('+resp.responseText+')');
        if(label.message && label.message.length>0){
          $("divDrugsOut").innerHTML = "<font color='red'>"+label.message+"</font>";
          window.setTimeout('document.getElementById("quantity").value=0;doAdd("yes")',1000);
        }
        else{
          if(label.drugs.length > 0){
            $('divDrugsOut').innerHTML = label.drugs;
            if(document.getElementById('deliverbutton') && label.drugs.indexOf("<NODELIVERY>")>-1){
            	document.getElementById('deliverbutton').style.visibility='hidden';
            }
            else if(document.getElementById('deliverbutton')){
            	document.getElementById('deliverbutton').style.visibility='visible';
            }
          }
        }
        checkForInteractions();
      }
    });
    document.getElementById('drugbarcode').focus();
  }

  <%-- DO DELIVER --%>
  function doDeliver(listuid){
    var url = '<c:url value="/pharmacy/deliverDrugsOutBarcode.jsp"/>?listuid='+listuid+'&ts='+new Date();
    new Ajax.Request(url,{
      method: "GET",
      parameters: "",
      onSuccess: function(resp){
        var label = eval('('+resp.responseText+')');
        if(label.message && label.message.length>0){
        	$("divDrugsOut").innerHTML = "<font color='red'>"+label.message+"</font>";
            window.setTimeout('doAdd("yes")',1000);
        }
        else{
            //$('divDrugsOut').innerHTML = label.drugs;
            doAdd('yes');
            if(document.getElementById('deliverbutton') && label.drugs.indexOf("<NODELIVERY>")>-1){
            	document.getElementById('deliverbutton').style.visibility='hidden';
            }
            else if(document.getElementById('deliverbutton')){
            	document.getElementById('deliverbutton').style.visibility='visible';
            }
        }
      }
    });
  }
    
  <%-- DO DELIVER --%>
  function setDefaultPharmacy(){
    var url = '<c:url value="/pharmacy/setDefaultPharmacy.jsp"/>?serviceStockUid='+document.getElementById("servicestock").value+'&ts='+new Date();
    new Ajax.Request(url,{
      method: "GET",
      parameters: "",
      onSuccess: function(resp){
      }
    });
  }
    
	var myautocompleter = new Ajax.Autocompleter('drugbarcode','autocomplete_prescription','medical/ajax/getDrugs.jsp',{
		  minChars:1,
		  method:'post',
		  afterUpdateElement:afterAutoComplete,
		  callback:composeCallbackURL
		});
		
	function afterAutoComplete(field,item){
	  var regex = new RegExp('[-0123456789.]*-idcache','i');
	  var nomimage = regex.exec(item.innerHTML);
	  var id = nomimage[0].replace('-idcache','');
	  document.getElementById("EditProductUid").value = id;
	  document.getElementById("drugbarcode").value=document.getElementById("drugbarcode").value.substring(0,document.getElementById("drugbarcode").value.indexOf(id));
	}
		
	function composeCallbackURL(field,item){
	  var url = "";
	  if(field.id=="drugbarcode"){
		url = "field=findDrugName&findDrugName="+field.value+"&serviceStockUid="+document.getElementById("servicestock").value;
	  }
	  return url;
	}
  <%-- SEARCH ENCOUNTER --%>
  function searchEncounter(encounterUidField,encounterNameField){
    openPopup("/_common/search/searchEncounter.jsp&ts=<%=getTs()%>&VarCode="+encounterUidField+"&VarText="+encounterNameField+
    		  "&FindEncounterPatient=<%=activePatient.personid%>");
  }
  function checkForInteractions(){
	  	document.getElementById("interactionswarning").innerHTML="<img height='5px' src='<c:url value="/_img/themes/default/ajax-loader.gif"/>'/>";
	    var url = "<c:url value=''/>pharmacy/popups/findRxNormDrugDrugInteractionsBoolean.jsp";
	    var params = "waitinglist=1";
	    new Ajax.Request(url,{
	      method: "POST",
	      parameters: params,
	      onSuccess: function(resp){
	        var interactions =  eval('('+resp.responseText+')');
	        if(interactions.interactionsexist=='1'){
	        	document.getElementById("interactionswarning").innerHTML="<a href='javascript:findInteractions();'><img src='<c:url value='/_img/icons/icon_warning.gif'/>' title='<%=getTranNoLink("web","prescription_has_interactions",sWebLanguage)%>'/><%=getTranNoLink("web","prescription_has_interactions",sWebLanguage)%>!</a>";
	        }
	        else {
	        	document.getElementById("interactionswarning").innerHTML='&nbsp';
	        }
	      },
		onFailure: function(resp){
        	document.getElementById("interactionswarning").innerHTML='&nbsp';
	      }
	    });
	  }

  <%
  	if(MedwanQuery.getInstance().getConfigInt("enableRxNorm",0)==1){
  %>
  		checkForInteractions();
  <%
  	}
  %>
  
  function findInteractions(){
	    openPopup("/pharmacy/popups/findRxNormDrugDrugInteractions.jsp&waitinglist=1&ts=<%=getTs()%>",800,600);
	}

  doAdd('yes');
  document.getElementById('drugbarcode').focus();
</script>