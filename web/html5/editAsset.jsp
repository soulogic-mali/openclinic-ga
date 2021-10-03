<%@page import="be.openclinic.assets.*"%>
<%@include file="/includes/validateUser.jsp"%>
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
<%=sCSSNORMAL %>
<%=sJSPROTOTYPE %>
<%=sJSSCRPTACULOUS%>
<%
	if(SH.p(request,"action").equalsIgnoreCase("save")){
		Asset asset = new Asset();
		asset.setServiceuid(SH.c((String)session.getAttribute("activeService")));
		asset.setUid("-1");
		if(SH.p(request,"assetuid").length()>0){
			asset=Asset.get(SH.p(request,"assetuid"));
		}
		asset.setNomenclature(SH.p(request,"nomenclature"));
		asset.setCode(SH.p(request,"code"));
		asset.setDescription(SH.p(request,"description"));
		asset.setSerialnumber(SH.p(request,"serialnumber"));
		asset.setAssetType(SH.p(request,"assettype"));
		asset.setCharacteristics(SH.p(request,"characteristics"));
		asset.setSupplierUid(SH.p(request,"supplieruid"));
		asset.setSaleClient(SH.p(request,"saleclient"));
		asset.setPurchaseDate(SH.parseDate(SH.p(request,"purchasedate")));
		asset.setSaleDate(SH.parseDate(SH.p(request,"saledate")));
		try{
			asset.setQuantity(Integer.parseInt(SH.p(request,"quantity")));
		}
		catch(Exception e){
			asset.setQuantity(1);
		}
		try{
			asset.setPurchasePrice(Double.parseDouble(SH.p(request,"purchaseprice")));
		}
		catch(Exception e){
			asset.setPurchasePrice(0);
		}
		try{
			asset.setSaleValue(Double.parseDouble(SH.p(request,"salevalue")));
		}
		catch(Exception e){
			asset.setSaleValue(0);
		}
		asset.setComment1(SH.p(request,"comment1"));
		asset.setComment2(SH.p(request,"comment2"));
		asset.setComment4(SH.p(request,"comment4"));
		asset.setComment5(SH.p(request,"comment5"));
		asset.setComment6(SH.p(request,"comment6"));
		asset.setComment7(SH.p(request,"comment7"));
		asset.setComment9(SH.p(request,"comment9"));
		asset.setComment10(SH.p(request,"comment10"));
		asset.setComment11(SH.p(request,"comment11"));
		asset.setComment12(SH.p(request,"comment12"));
		asset.setComment13(SH.p(request,"comment13"));
		asset.setComment14(SH.p(request,"comment14"));
		asset.setComment16(SH.p(request,"comment16"));
		asset.setComment17(SH.p(request,"comment17"));
		asset.store(activeUser.userid);
		out.println("<script>window.location.href='manageAssets.jsp?nomenclature="+asset.getNomenclature()+"&action=search&highlight="+asset.getUid()+"';</script>");
		out.flush();
	}
%>
<html>
	<body onresize='window.parent.document.getElementById("ocframe").style.height=screen.height;'>
		<div>
			<form name='transactionForm' method='post'>
				<input type='hidden' name='assetuid' id='assetuid' value='<%=SH.p(request,"assetuid")%>'/>
				<input type='hidden' name='action' id='action' value=''/>
				<table width='100%'>
					<tr>
						<td style='font-size:4vw;text-align: left' nowrap>
							<%=SH.c((String)session.getAttribute("activeService")).toUpperCase() %><br/>
							<b style='font-size:4vw;text-align: left'><%=getTranNoLink("service",SH.c((String)session.getAttribute("activeService")),sWebLanguage) %></b>
						</td>
						<td style='font-size:8vw;text-align: right' nowrap>
							<img onclick="window.location.href='manageAssets.jsp'" style='max-height: 40px' src='<%=sCONTEXTPATH%>/_img/icons/mobile/inventory.png'/>
							<img onclick="window.location.href='welcomegmao.jsp'" style='max-height: 40px' src='<%=sCONTEXTPATH%>/_img/icons/mobile/home.png'/>
						</td>
					</tr>
					<tr>
						<td colspan='2' class='mobileadmin' style='font-size:6vw;'>
							<%=getTranNoLink("web","manageasset",sWebLanguage)%>
							<img onclick='save();' style='max-height:32px;height:auto;vertical-align:middle' src='<%=sCONTEXTPATH %>/_img/icons/mobile/save.png'/>
							<img onclick='maintenancePlans();' style='max-height:40px;height:auto;vertical-align:middle' src='<%=sCONTEXTPATH %>/_img/icons/mobile/planning.png'/>
						</td>
					</tr>
					<tr id='typetr'>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web","type",sWebLanguage)%>
						</td>
						<%
							String type = "";
							if(SH.p(request,"assetuid").length()>0){
								Asset asset = Asset.get(SH.p(request,"assetuid"));
								if(asset!=null){
									type=(asset.getNomenclature()+" ").substring(0,1);
								}
							}
						%>
						<td class='mobileadmin2' style='font-size:4vw;'>
		                	<select name='type' id='type' style='width: 95% !important;font-size: 4vw;height: 6vw;' onchange='loadEditScreen()'>
		                		<option/>
		                		<option <%=type.equalsIgnoreCase("i")?"selected":"" %> style='width: 95% !important;font-size: 4vw' value='I'><%=getTranNoLink("web","infrastructure",sWebLanguage) %></option>
		                		<option <%=type.equalsIgnoreCase("e")?"selected":"" %> style='width: 95% !important;font-size: 4vw' value='E'><%=getTranNoLink("web","equipment",sWebLanguage) %></option>
							</select>
						</td>
					</tr>
				</table>
				<div id="editdiv"></div>
			</form>
		</div>
		<script>
			function loadEditScreen(){
				if(document.getElementById("type").value.length>0){
				    var url = "<c:url value='/'/>html5/loadEditAssetEquipment.jsp";
				    if(document.getElementById("type").value=='I'){
				    	url = "<c:url value='/'/>html5/loadEditAssetInfrastructure.jsp";
				    }
				    new Ajax.Request(url,{
				      method: "POST",
				      parameters: "assetuid="+document.getElementById('assetuid').value,
				      onSuccess: function(resp){
				        document.getElementById('editdiv').innerHTML=resp.responseText;
				        document.getElementById("typetr").style.display='none';
				      }
				    });
				}
				else{
			        document.getElementById('editdiv').innerHTML='';
				}
			}
			
			function save(){
			    if(requiredFieldsProvided()){    
					document.getElementById('action').value='save';
					transactionForm.submit();
			    }
			    else{
			    	alert('<%=getTranNoLink("web.manage","dataMissing",sWebLanguage)%>');
			    }
			}

			  function requiredFieldsProvided(){
				  if(document.getElementById("code").value.length == 0 ){
					  document.getElementById("code").focus();
					  return false;
				  }
				  else if(document.getElementById("description").value.length == 0 ){
					  document.getElementById("description").focus();
					  return false;
				  }
				  else if(document.getElementById("nomenclature").value.length == 0 ){
					  document.getElementById("nomenclature").focus();
					  return false;
				  }
				  else if('<%=SH.c(request.getParameter("assetType"))%>'=='equipment' && document.getElementById("comment7").value.length == 0 ){
					  document.getElementById("comment7").focus();
					  return false;
				  }
				  else if(document.getElementById("comment6").value.length == 0 ){
					  document.getElementById("comment6").focus();
					  return false;
				  }
				  else if(document.getElementById("comment12").value.length == 0 ){
					  document.getElementById("comment12").focus();
					  return false;
				  }
				  else if(document.getElementById("purchaseprice").value.length == 0 || isNaN(document.getElementById("purchaseprice").value) || document.getElementById("purchaseprice").value*1<=0){
					  document.getElementById("purchaseprice").focus();
					  return false;
				  }
				  else if('<%=SH.c(request.getParameter("assetType"))%>'=='infrastructure' && document.getElementById('comment9').value.length == 0){
					  document.getElementById("comment9").focus();
					  return false;
				  }
			    return true;           
			  }

			function maintenancePlans(){
				window.location.href='manageMaintenancePlans.jsp?assetuid=<%=SH.p(request,"assetuid")%>';
			}
			
			<% if(SH.p(request,"assetuid").length()>0){%>
				loadEditScreen();
			<% }%>
		</script>
		<script>
			window.parent.parent.scrollTo(0,0);
		</script>
	</body>
</html>