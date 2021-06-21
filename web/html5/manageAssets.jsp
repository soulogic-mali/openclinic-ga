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
<html>
	<body onresize='window.parent.document.getElementById("ocframe").style.height=screen.height;'>
		<div>
			<form name='transactionForm' method='post'>
				<input type='hidden' name='highlight' id='highlight' value='<%=SH.p(request,"highlight")%>'/>
				<table width='100%'>
					<tr>
						<td style='font-size:4vw;text-align: left' nowrap>
							<%=SH.c((String)session.getAttribute("activeService")).toUpperCase() %><br/>
							<b style='font-size:4vw;text-align: left'><%=getTranNoLink("service",SH.c((String)session.getAttribute("activeService")),sWebLanguage) %></b>
						</td>
						<td style='font-size:8vw;text-align: right'>
							<img onclick="window.location.href='welcomegmao.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/home.png'/>
						</td>
					</tr>
					<tr>
						<td colspan='2' class='mobileadmin' style='font-size:6vw;'>
							<%=getTranNoLink("web","searchassets",sWebLanguage)%>
							<img onclick='search();' style='max-width:10%;height:auto;vertical-align:middle' src='<%=sCONTEXTPATH %>/_img/icons/mobile/search.png'/>
							<img onclick='newAsset();' style='max-width:10%;height:auto;vertical-align:middle' src='<%=sCONTEXTPATH %>/_img/icons/mobile/new.png'/>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web","type",sWebLanguage)%>
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
		                	<select name='type' id='type' style='width: 95% !important;font-size: 4vw;height: 6vw;' onchange='loadNomenclature();'>
		                		<option/>
		                		<option style='width: 95% !important;font-size: 4vw' value='I'><%=getTranNoLink("web","infrastructure",sWebLanguage) %></option>
		                		<option style='width: 95% !important;font-size: 4vw' value='E'><%=getTranNoLink("web","equipment",sWebLanguage) %></option>
							</select>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web","code",sWebLanguage)%>
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
							<input type='text' style='width: 95% !important;font-size: 4vw;height: 6vw;' name='code' id='code' size='10' value='<%=SH.p(request,"code")%>'/>
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web","description",sWebLanguage)%>
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
		                	<select name='description' id='description' style='width: 95% !important;font-size: 4vw;height: 6vw;'>
		                		<option/>
							<%
								Connection conn = SH.getOpenclinicConnection();
								String children = Service.getChildIdsAsString(SH.c((String)session.getAttribute("activeService")),500); 
								PreparedStatement ps = conn.prepareStatement("select distinct oc_asset_description from oc_assets where oc_asset_service in ("+children+") order by oc_asset_description");
								ResultSet rs = ps.executeQuery();
								while(rs.next()){
									String label = rs.getString("oc_asset_description");
									if(label.length()>25){
										label = label.substring(0,25)+"...";
									}
									out.println("<option "+(SH.p(request,"description").equalsIgnoreCase(rs.getString("oc_asset_description"))?"selected":"")+" style='width: 95% !important;font-size: 4vw' value='"+rs.getString("oc_asset_description")+"'>"+label+"</option>");
								}
								rs.close();
								ps.close();
								conn.close();
							%>
							</select><br/><br/>
							<input type='text' style='width: 95% !important;font-size: 4vw;height: 6vw;' name='descriptiontext' id='descriptiontext' size='10' value=''/>
							
						</td>
					</tr>
					<tr>
						<td class='mobileadmin' style='font-size:4vw;'>
							<%=getTranNoLink("web","nomenclature",sWebLanguage)%>
						</td>
						<td class='mobileadmin2' style='font-size:4vw;'>
		                	<select name='nomenclature' id='nomenclature' style='width: 95% !important;font-size: 4vw;height: 6vw;'>
							</select>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<p/>
		<div id='searchresults'></div>
		<script>
			function loadNomenclature(doit){
			    var url = "<c:url value='/'/>html5/loadNomenclature.jsp";
			    new Ajax.Request(url,{
			      method: "POST",
			      parameters: "type="+document.getElementById('type').value+"&nomenclature=<%=SH.p(request,"nomenclature")%>",
			      onSuccess: function(resp){
			        document.getElementById('nomenclature').innerHTML=resp.responseText;
			        if(doit=='search'){
			        	search();
			        }
			      }
			    });
			}
			
			function search(){
			    var url = "<c:url value='/'/>html5/searchAssets.jsp";
			    new Ajax.Request(url,{
			      method: "POST",
			      parameters: 	"type="+document.getElementById('type').value+
			    				"&code="+document.getElementById('code').value+
			      				"&description="+document.getElementById('description').value+
			      				"&descriptiontext="+document.getElementById('descriptiontext').value+
			      				"&highlight="+document.getElementById('highlight').value+
			      				"&nomenclature="+document.getElementById('nomenclature').value,
			      onSuccess: function(resp){
			        document.getElementById('searchresults').innerHTML=resp.responseText;
			        document.getElementById('highlight').value='';
			      }
			    });
			}
			
			function editAsset(uid){
				window.location.href="editAsset.jsp?assetuid="+uid;
			}
			
			function newAsset(){
				window.location.href="editAsset.jsp";
			}
			
			loadNomenclature('<%=SH.p(request,"action").equalsIgnoreCase("search")?"search":""%>');
			
		</script>
		<script>
			window.parent.parent.scrollTo(0,0);
		</script>
	</body>
</html>