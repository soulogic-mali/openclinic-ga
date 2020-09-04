<%@page import="be.openclinic.medical.*,be.openclinic.pharmacy.*,be.openclinic.common.*"%>
<%@page import="be.dpms.medwan.common.model.vo.administration.PersonVO"%>
<%@page import="be.dpms.medwan.common.model.vo.occupationalmedicine.ExaminationVO"%>
<%@page import="be.mxs.common.model.vo.healthrecord.*,be.mxs.common.model.vo.healthrecord.util.*"%>
<!DOCTYPE html>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<head>
	<link rel="apple-touch-icon" sizes="180x180" href="/openclinic/apple-touch-icon.png">
	<link rel="icon" type="image/png" sizes="32x32" href="/openclinic/favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="16x16" href="/openclinic/favicon-16x16.png">
	<link rel="manifest" href="/openclinic/site.webmanifest">
	<link rel="mask-icon" href="/openclinic/safari-pinned-tab.svg" color="#5bbad5">
	<meta name="msapplication-TileColor" content="#da532c">
	<meta name="theme-color" content="#ffffff">
</head>
<%@include file="/includes/validateUser.jsp"%>

<%
	String sTime1 = checkString(request.getParameter("time1")),
	sTime2 = checkString(request.getParameter("time2")),
	sTime3 = checkString(request.getParameter("time3")),
	sTime4 = checkString(request.getParameter("time4")),
	sTime5 = checkString(request.getParameter("time5")),
	sTime6 = checkString(request.getParameter("time6"));
	
	String sQuantity1 = checkString(request.getParameter("quantity1")),
	sQuantity2 = checkString(request.getParameter("quantity2")),
	sQuantity3 = checkString(request.getParameter("quantity3")),
	sQuantity4 = checkString(request.getParameter("quantity4")),
	sQuantity5 = checkString(request.getParameter("quantity5")),
	sQuantity6 = checkString(request.getParameter("quantity6"));
	
	PrescriptionSchema prescriptionSchema = new PrescriptionSchema();
	if(sTime1.length() > 0){
		prescriptionSchema.getTimequantities().add(new KeyValue(sTime1,sQuantity1));
	}
	if(sTime2.length() > 0){
		prescriptionSchema.getTimequantities().add(new KeyValue(sTime2,sQuantity2));
	}
	if(sTime3.length() > 0){
		prescriptionSchema.getTimequantities().add(new KeyValue(sTime3,sQuantity3));
	}
	if(sTime4.length() > 0){
		prescriptionSchema.getTimequantities().add(new KeyValue(sTime4,sQuantity4));
	}
	if(sTime5.length() > 0){
		prescriptionSchema.getTimequantities().add(new KeyValue(sTime5,sQuantity5));
	}
	if(sTime6.length() > 0){
		prescriptionSchema.getTimequantities().add(new KeyValue(sTime6,sQuantity6));
	}
	
    if(activeUser==null || activeUser.person==null){
        out.println("<script>window.location.href='login.jsp';</script>");
        out.flush();
    }
    else if(checkString(request.getParameter("formaction")).equalsIgnoreCase("save")){
    	Prescription newPrescription = new Prescription();
    	newPrescription.setBegin(new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("drugstart")));
    	newPrescription.setEnd(new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("drugend")));
    	newPrescription.setCreateDateTime(new java.util.Date());
    	newPrescription.setPatientUid(activePatient.personid);
    	newPrescription.setPrescriberUid(activeUser.userid);
    	newPrescription.setProductUid(request.getParameter("drugid"));
    	newPrescription.setTimeUnit(request.getParameter("drugtimeunit"));
    	newPrescription.setTimeUnitCount(Integer.parseInt(request.getParameter("drugtimeunitcount")));
    	newPrescription.setUpdateUser(activeUser.userid);
    	newPrescription.setUnitsPerTimeUnit(Double.parseDouble(request.getParameter("drugunitspertimeunit")));
    	newPrescription.setSupplyingServiceUid("");
    	newPrescription.setServiceStockUid("");
    	newPrescription.setUid("-1");
    	newPrescription.store();
    	
        prescriptionSchema.setPrescriptionUid(newPrescription.getUid());
        prescriptionSchema.store();
    	
    	out.println("<script>window.location.href='getDrugs.jsp';</script>");
    	out.flush();
    }
    else{
%>
    <%=sCSSNORMAL%>
    <%=sJSPROTOTYPE%>
    <%=sJSSCRPTACULOUS%>

<title><%=getTran(request,"web","editdrugprescription",sWebLanguage) %></title>
<html>
	<body onresize='window.parent.document.getElementById("ocframe").style.height=screen.height;'>
		<div>
			<form name='transactionForm' method='post'>
				<input type='hidden' name='formaction' id='formaction'/>
				<table width='100%'>
					<tr>
						<td colspan='2' style='font-size:8vw;text-align: right'>
							<img onclick="window.location.href='getDrugs.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/drugs.png'/>
							<img onclick="window.location.href='getPatient.jsp?searchpersonid=<%=activePatient.personid %>'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/patient.png'/>
							<img onclick="window.location.href='findPatient.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/find.png'/>
							<img onclick="window.location.href='welcome.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/home.png'/>
						</td>
					</tr>
					<tr>
						<td colspan='2' class='mobileadmin' style='font-size:6vw;'>
							<%
								out.println("["+activePatient.personid+"] "+activePatient.getFullName());
							%>
						</td>
					</tr>
					<tr>
						<td colspan='2' class='mobileadmin' style='font-size:6vw;'>
							<%=getTran(request,"web","newdrugprescription",sWebLanguage) %>
							<img onclick='save();' style='max-width:10%;height:auto;vertical-align:middle' src='<%=sCONTEXTPATH %>/_img/icons/mobile/save.png'/>
						</td>
					</tr>
	            	<tr>
		                <td class='mobileadmin' style='font-size: 4vw;'>
		                	<%=getTran(request,"web","product",sWebLanguage) %>
		                </td>
		                <td class='mobileadmin2' style='font-size: 4vw;'>
		                	<input type='text' style='width: 95% !important;font-size: 4vw;height: 6vw;' name='drugname' id='drugname' value=''%>
		                	<input type='hidden' name='drugid' id='drugid' value=''/>
							<div id="autocomplete_prescription" class="autocomple"></div>
		                </td>
	            	</tr>
	            	<tr>
		                <td class='mobileadmin' style='font-size: 4vw;'>
		                	<%=getTran(request,"web","dose",sWebLanguage) %>
		                </td>
		                <td class='mobileadmin2' style='font-size: 4vw;'>
		                	<select name='drugunitspertimeunit' id='drugunitspertimeunit'  style='font-size: 4vw;'>
		                		<option style='font-size: 4vw;' value='0.25'>1/4</option>
		                		<option style='font-size: 4vw;' value='0.5'>1/2</option>
			                <%
								for(int n=1;n<10;n++){
									out.println("<option style='font-size: 4vw;' value='"+n+"'>"+n+"</option>");
								}
			                %>
		                	</select>
		                	<span id='productunit' style='font-size: 4vw;'> /</span>
		                	<select name='drugtimeunitcount' id='drugtimeunitcount'  style='font-size: 4vw;'>
			                <%
								for(int n=1;n<10;n++){
									out.println("<option style='font-size: 4vw;' value='"+n+"'>"+n+"</option>");
								}
			                %>
		                	</select>
		                	<select name='drugtimeunit' id='drugtimeunit' style='font-size: 4vw;'>
		                		<%=ScreenHelper.writeSelectWithStyle(request, "prescription.timeunit", "", sWebLanguage,"font-size: 4vw;") %>
		                	</select>
		                </td>
	            	</tr>
					<tr>
						<td class='mobileadmin' style='font-size: 4vw;'>
							<%=getTranNoLink("web","start",sWebLanguage) %>&nbsp;
						</td>
						<td class='mobileadmin2' style='font-size: 4vw;'>
							<input style='padding:4px; font-size: 4vw;' type='date' name='drugstart' value='<%=new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>' size='10'/>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size: 4vw;'>
							<%=getTranNoLink("web","end",sWebLanguage) %>&nbsp;
						</td>
						<td class='mobileadmin2' style='font-size: 4vw;'>
							<input style='padding:4px; font-size: 4vw;' type='date' name='drugend' value='' size='10'/>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size: 4vw;'>
							<%=getTranNoLink("web","drugschema",sWebLanguage) %>&nbsp;
						</td>
						<td class='mobileadmin2' style='font-size: 4vw;'>
					        <table>
					            <tr>
					                <td nowrap>
					                	<select name="time1" id="time1" style='font-size: 4vw;' onchange='checktime(1);'>
					                		<option/>
					                		<%
					                			for(int n=0;n<24;n++){
					                				out.println("<option style='font-size: 4vw;' value="+n+" "+(checkString(prescriptionSchema.getTimeQuantity(0).getKey()).length()>0 && n==Integer.parseInt(prescriptionSchema.getTimeQuantity(0).getKey())?"selected":"")+">"+n+"</option>");
					                			}
					                		%>
					                	</select> 
					                	<%=getTran(request,"web","abbreviation.hour",sWebLanguage)%>
					                </td>
					                <td nowrap>
					                	<select name="time2" id="time2" style='font-size: 4vw;'onchange='checktime(2);'>
					                		<option/>
					                		<%
					                			for(int n=0;n<24;n++){
					                				out.println("<option style='font-size: 4vw;' value="+n+" "+(checkString(prescriptionSchema.getTimeQuantity(1).getKey()).length()>0 && n==Integer.parseInt(prescriptionSchema.getTimeQuantity(1).getKey())?"selected":"")+">"+n+"</option>");
					                			}
					                		%>
					                	</select> 
					                	<%=getTran(request,"web","abbreviation.hour",sWebLanguage)%>
					                </td>
					                <td nowrap>
					                	<select name="time3" id="time3" style='font-size: 4vw;'onchange='checktime(3);'>
					                		<option/>
					                		<%
					                			for(int n=0;n<24;n++){
					                				out.println("<option style='font-size: 4vw;' value="+n+" "+(checkString(prescriptionSchema.getTimeQuantity(2).getKey()).length()>0 && n==Integer.parseInt(prescriptionSchema.getTimeQuantity(2).getKey())?"selected":"")+">"+n+"</option>");
					                			}
					                		%>
					                	</select> 
					                	<%=getTran(request,"web","abbreviation.hour",sWebLanguage)%>
					                </td>
					                <td nowrap>
					                	<select name="time4" id="time4" style='font-size: 4vw;'onchange='checktime(4);'>
					                		<option/>
					                		<%
					                			for(int n=0;n<24;n++){
					                				out.println("<option style='font-size: 4vw;' value="+n+" "+(checkString(prescriptionSchema.getTimeQuantity(3).getKey()).length()>0 && n==Integer.parseInt(prescriptionSchema.getTimeQuantity(3).getKey())?"selected":"")+">"+n+"</option>");
					                			}
					                		%>
					                	</select> 
					                	<%=getTran(request,"web","abbreviation.hour",sWebLanguage)%>
					                </td>
					                <td nowrap>
					                	<select name="time5" id="time5" style='font-size: 4vw;'onchange='checktime(5);'>
					                		<option/>
					                		<%
					                			for(int n=0;n<24;n++){
					                				out.println("<option style='font-size: 4vw;' value="+n+" "+(checkString(prescriptionSchema.getTimeQuantity(4).getKey()).length()>0 && n==Integer.parseInt(prescriptionSchema.getTimeQuantity(4).getKey())?"selected":"")+">"+n+"</option>");
					                			}
					                		%>
					                	</select> 
					                	<%=getTran(request,"web","abbreviation.hour",sWebLanguage)%>
					                </td>
					            </tr>
					            <tr>
					                <td nowrap>
					                	<select name="quantity1" id="quantity1" style='font-size: 4vw;'>
					                		<option/>
					                		<%
					                			for(int n=1;n<11;n++){
					                				out.println("<option style='font-size: 4vw;' value="+n+" "+(checkString(prescriptionSchema.getTimeQuantity(0).getValue()).length()>0 && n==Integer.parseInt(prescriptionSchema.getTimeQuantity(0).getValue())?"selected":"")+">"+n+"</option>");
					                			}
					                		%>
					                	</select> 
					                	#
					                </td>
					                <td nowrap>
					                	<select name="quantity2" id="quantity2" style='font-size: 4vw;'>
					                		<option/>
					                		<%
					                			for(int n=1;n<11;n++){
					                				out.println("<option style='font-size: 4vw;' value="+n+" "+(checkString(prescriptionSchema.getTimeQuantity(1).getValue()).length()>0 && n==Integer.parseInt(prescriptionSchema.getTimeQuantity(1).getValue())?"selected":"")+">"+n+"</option>");
					                			}
					                		%>
					                	</select> 
					                	#
					                </td>
					                <td nowrap>
					                	<select name="quantity3" id="quantity3" style='font-size: 4vw;'>
					                		<option/>
					                		<%
					                			for(int n=1;n<11;n++){
					                				out.println("<option style='font-size: 4vw;' value="+n+" "+(checkString(prescriptionSchema.getTimeQuantity(2).getValue()).length()>0 && n==Integer.parseInt(prescriptionSchema.getTimeQuantity(2).getValue())?"selected":"")+">"+n+"</option>");
					                			}
					                		%>
					                	</select> 
					                	#
					                </td>
					                <td nowrap>
					                	<select name="quantity4" id="quantity4" style='font-size: 4vw;'>
					                		<option/>
					                		<%
					                			for(int n=1;n<11;n++){
					                				out.println("<option style='font-size: 4vw;' value="+n+" "+(checkString(prescriptionSchema.getTimeQuantity(3).getValue()).length()>0 && n==Integer.parseInt(prescriptionSchema.getTimeQuantity(3).getValue())?"selected":"")+">"+n+"</option>");
					                			}
					                		%>
					                	</select> 
					                	#
					                </td>
					                <td nowrap>
					                	<select name="quantity5" id="quantity5" style='font-size: 4vw;'>
					                		<option/>
					                		<%
					                			for(int n=1;n<11;n++){
					                				out.println("<option style='font-size: 4vw;' value="+n+" "+(checkString(prescriptionSchema.getTimeQuantity(4).getValue()).length()>0 && n==Integer.parseInt(prescriptionSchema.getTimeQuantity(4).getValue())?"selected":"")+">"+n+"</option>");
					                			}
					                		%>
					                	</select> 
					                	#
					                </td>
					            </tr>
					        </table>
						</td>
					</tr>
				</table>
			</form>
		</div>
	</body>
</html>
<%
}
%>
<script>
	function checktime(n){
		if(document.getElementById('time'+n).value.length>0){
			if(document.getElementById('quantity'+n).value.length==0){
				document.getElementById('quantity'+n).value=1;
			}
		}
		else{
			document.getElementById('quantity'+n).value='';
		}
	}
	
	new Ajax.Autocompleter('drugname','autocomplete_prescription','../medical/ajax/getDrugs.jsp?serviceStockUid=NONE',{
	  minChars:1,
	  method:'post',
	  afterUpdateElement:afterAutoComplete,
	  callback:composeCallbackURL
	});
		
	function afterAutoComplete(field,item){
	  var regex = new RegExp('[-0123456789.]*-idcache','i');
	  var nomimage = regex.exec(item.innerHTML);
	  var id = nomimage[0].replace('-idcache','');
	  clearEditFields();
	  document.getElementById("drugid").value = id;
	  getProduct();
	}
	
	function composeCallbackURL(field,item){
	  var url = "";
	  if(field.id=="drugname"){
		url = "field=drugname&style=style='font-size: 4vw;'&findDrugName="+field.value;
	  }
	  return url;
	}

	function getProduct(){
	    var url = "<c:url value='/'/>medical/ajax/getProduct.jsp";
	    var params = "productUid="+document.getElementById("drugid").value;
	    new Ajax.Request(url,{
	      method: "POST",
	      parameters: params,
	      onSuccess: function(resp){
	        var product =  eval('('+resp.responseText+')');
	        document.getElementById("drugname").value=product.name;
	        document.getElementById("drugunitspertimeunit").value=product.unitspertimeunit;
	        document.getElementById("drugtimeunitcount").value=product.timeunitcount;
	        document.getElementById("drugtimeunit").value=product.timeunit;
	        document.getElementById("productunit").innerHTML=product.productunit+" /";
	      }
	    });
	}

	function clearEditFields(){
		  transactionForm.drugname.value = "";
		  transactionForm.drugunitspertimeunit.value = "";

		  transactionForm.drugtimeunitcount.value = "";
		  transactionForm.drugtimeunit.value = "";

		  transactionForm.drugid.value = "";
		}

	function save(){
		if(document.getElementById('drugtimeunit').value=='type2day'){
			var schemaquantity=0;
			var schemaexists=false;
			for(n=1;n<6;n++){
				if(document.getElementById('time'+n).value.length>0){
					schemaexists=true;
				}
				if(document.getElementById('quantity'+n).value.length>0){
					schemaquantity+=document.getElementById('quantity'+n).value*1;
				}
			}
			if(schemaexists && !(schemaquantity==document.getElementById('drugunitspertimeunit').value*1)){
				alert('<%=getTranNoLink("web","prescriptionquantitydiffersfromschemaquantity",sWebLanguage)%>');
				return;
			}
		}
		document.getElementById("formaction").value="save";
		transactionForm.submit();
	}

	
</script>
