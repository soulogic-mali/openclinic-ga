<%@page import="be.openclinic.assets.*,
               java.text.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%
	String sSparepartUID = SH.p(request,"sparepartuid");
	String sCode = SH.p(request,"code");
	String sName = SH.p(request,"name");
	String sCost = SH.p(request,"cost");
	String sQuantity = SH.p(request,"quantity");
	String sLocation = SH.p(request,"location");
	String sComment = SH.p(request,"comment");
	String sBrand = SH.p(request,"brand");
	String sModel = SH.p(request,"model");
	String sType = SH.p(request,"type");
	String sAssetUid = SH.p(request,"assetuid");
	String sAction = SH.p(request,"action");
	String sExternalAction = SH.p(request,"s_action");
	StringBuffer sResult = new StringBuffer();
	
	if(sAction.length()==0 && sExternalAction.equalsIgnoreCase("search") && SH.p(request,"searchButton").length()==0 && SH.p(request,"saveButton").length()==0){
		if(SH.p(request,"s_assetuid").length()>0){
			sAssetUid=SH.p(request,"s_assetuid");
		};
		if(SH.p(request,"s_brand").length()>0){
			sBrand=SH.p(request,"s_brand");
		};
		if(SH.p(request,"s_model").length()>0){
			sModel=SH.p(request,"s_model");
		};
		if(SH.p(request,"s_type").length()>0){
			sType=SH.p(request,"s_type");
		};
		sAction="search";
	}
	if(SH.p(request,"searchButton").length()>0){
		sAction="search";
	}
	if(SH.p(request,"newButton").length()>0){
		sAction="new";
	}
	if(SH.p(request,"saveButton").length()>0){
		Connection conn = SH.getOpenClinicConnection();
		if(sSparepartUID.length()==0){
			sSparepartUID=SH.getServerId()+"."+MedwanQuery.getInstance().getOpenclinicCounter("OC_SPAREPARTS");
		}
		PreparedStatement ps = conn.prepareStatement("delete from oc_spareparts where oc_sparepart_serverid=? and oc_sparepart_objectid=?");
		ps.setInt(1,Integer.parseInt(sSparepartUID.split("\\.")[0]));
		ps.setInt(2,Integer.parseInt(sSparepartUID.split("\\.")[1]));
		ps.execute();
		ps.close();
		ps=conn.prepareStatement("insert into oc_spareparts(oc_sparepart_serverid,oc_sparepart_objectid,oc_sparepart_code,oc_sparepart_name,oc_sparepart_location"+
									",oc_sparepart_brand,oc_sparepart_model,oc_sparepart_type,oc_sparepart_quantity,oc_sparepart_cost,oc_sparepart_assetuid) values(?,?,?,?,?,?,?,?,?,?,?)");
		int nQuantity=0;
		double nCost=0;
		try{nQuantity=Integer.parseInt(sQuantity);}catch(Exception e){e.printStackTrace();};
		try{nCost=Double.parseDouble(sCost);}catch(Exception e){e.printStackTrace();};
		ps.setInt(1,Integer.parseInt(sSparepartUID.split("\\.")[0]));
		ps.setInt(2,Integer.parseInt(sSparepartUID.split("\\.")[1]));
		ps.setString(3,sCode);
		ps.setString(4,sName);
		ps.setString(5,sLocation);
		ps.setString(6,sBrand);
		ps.setString(7,sModel);
		ps.setString(8,sType);
		ps.setInt(9,nQuantity);
		ps.setDouble(10,nCost);
		ps.setString(11,sAssetUid);
		ps.execute();
		ps.close();
		conn.close();
		sCode="";
		sName="";
		sLocation="";
		sAction="search";
	}
%>
<%	if(sAction.length()==0 || sAction.equalsIgnoreCase("search")){ %>
	<form name='searchForm' method='post'>
		<input type='hidden' name='sparepartuid' id='sparepartuid' value='<%=sSparepartUID %>'/>
		<input type='hidden' name='action' id='action' value=''/>
		<table width='100%'>
			<tr class='admin'><td colspan='6'><%=getTran(request,"web","gmao.spareparts",sWebLanguage) %></td></tr>
			<tr>
				<td class='admin'><%=getTran(request,"web","code",sWebLanguage) %></td>
				<td class='admin2'><input name='code' id='code' class='text' type='text' size='25' value='<%=sCode %>'/></td>
				<td class='admin'><%=getTran(request,"web","name",sWebLanguage) %></td>
				<td class='admin2'><input name='name' id='name' class='text' type='text' size='25' value='<%=sName %>'/></td>
				<td class='admin'><%=getTran(request,"web","asset",sWebLanguage) %></td>
				<td class='admin2'>
	                <input type="hidden" name="assetuid" id="assetuid" value="<%=sAssetUid%>">
	                <%
	                	String sAssetCode="";
	                	Asset asset = Asset.get(sAssetUid);
	                	if(asset!=null){
	                		sAssetCode=asset.getCode();
	                	}
	                %>
	                <input type="text" class="text" id="searchAssetCode" name="searchAssetCode" size="20" readonly value="<%=sAssetCode%>">
	                                   
	                <%-- buttons --%>
	                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("web","select",sWebLanguage)%>" onclick="selectAsset('assetuid','searchAssetCode');">
	                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("web","clear",sWebLanguage)%>" onclick="clearAssetSearchFields();">
	                <img src="<c:url value="/_img/icons/icon_view.png"/>" class="link" alt="<%=getTranNoLink("web","view",sWebLanguage)%>" onclick="viewAsset();">
				</td>
			</tr>
			<tr>
				<td class='admin'><%=getTran(request,"web","brand",sWebLanguage) %></td>
				<td class='admin2'><input name='brand' id='brand' class='text' type='text' size='25' value='<%=sBrand %>'/></td>
				<td class='admin'><%=getTran(request,"web","model",sWebLanguage) %></td>
				<td class='admin2'><input name='model' id='model' class='text' type='text' size='25' value='<%=sModel %>'/></td>
				<td class='admin'><%=getTran(request,"web","type",sWebLanguage) %></td>
				<td class='admin2'><input name='type' id='type' class='text' type='text' size='25' value='<%=sType %>'/></td>
			</tr>
			<tr>
				<td/>
				<td>
					<input type='submit' class='button' name='searchButton' id='searchButton' value='<%=getTranNoLink("web","search",sWebLanguage) %>'/>
					<input type='button' class='button' name='cleanButton' id='cleanButton' value='<%=getTranNoLink("web","clear",sWebLanguage) %>' onclick='clearSparePartSearchFields();'/>
					<% if(activeUser.getAccessRight("spareparts.add")){%>
						<input type='submit' class='button' name='newButton' id='newButton' value='<%=getTranNoLink("web","new",sWebLanguage) %>'/>
					<% } %>
				</td>
			</tr>
		</table>
	</form>
<%	} %>
<%	if(sAction.equalsIgnoreCase("search")){
		%>
		<table width='100%'>
			<tr class='admin'>
				<td><%=getTran(request,"web","code",sWebLanguage) %></td>
				<td><%=getTran(request,"web","name",sWebLanguage) %></td>
				<td><%=getTran(request,"web","asset",sWebLanguage) %></td>
				<td><%=getTran(request,"web","brand",sWebLanguage) %></td>
				<td><%=getTran(request,"web","model",sWebLanguage) %></td>
				<td><%=getTran(request,"web","type",sWebLanguage) %></td>
				<td><%=getTran(request,"web","location",sWebLanguage) %></td>
				<td><%=getTran(request,"web","quantity",sWebLanguage) %></td>
				<td><%=getTran(request,"web","cost",sWebLanguage) %></td>
			</tr>
		<%		
		Connection conn = SH.getOpenClinicConnection();
		PreparedStatement ps=null;
		ResultSet rs=null;
		boolean bAssetBased=false;
		if(sAssetUid.length()>0){
			String sql = "select * from oc_spareparts where 1=1";
			sql+=" and oc_sparepart_assetuid = ?";
			sql+=" order by oc_sparepart_name";
			ps =conn.prepareStatement(sql);
			ps.setString(1,sAssetUid);
			rs = ps.executeQuery();
			if(rs.next()){
				bAssetBased=true;
				rs.beforeFirst();
			}
			else{
				rs.close();
				ps.close();
			}
		}
		System.out.println(1);
		if(!bAssetBased){
			String sql = "select * from oc_spareparts where 1=1";
			if(sCode.length()>0){
				sql+=" and oc_sparepart_code = ?";
			}
			if(sName.length()>0){
				sql+=" and oc_sparepart_name like ?";
			}
			if(sBrand.length()>0){
				sql+=" and oc_sparepart_brand like ?";
			}
			if(sModel.length()>0){
				sql+=" and oc_sparepart_model like ?";
			}
			if(sType.length()>0){
				sql+=" and oc_sparepart_type like ?";
			}
			ps =conn.prepareStatement(sql);
			int idx=1;
			if(sCode.length()>0){
				ps.setString(idx++,sCode);
			}
			if(sName.length()>0){
				ps.setString(idx++,"%"+sName+"%");
			}
			if(sBrand.length()>0){
				ps.setString(idx++,"%"+sBrand+"%");
			}
			if(sModel.length()>0){
				ps.setString(idx++,"%"+sModel+"%");
			}
			if(sType.length()>0){
				ps.setString(idx++,"%"+sType+"%");
			}
			sql+=" order by oc_sparepart_name";
			rs = ps.executeQuery();
		}
		System.out.println(2);
		while(rs.next()){
			sResult.append("<tr>");
			sResult.append("<td class='admin'><a href='javascript:editSparePart(\""+rs.getString("oc_sparepart_serverid")+"."+rs.getString("oc_sparepart_objectid")+"\");'>"+rs.getString("oc_sparepart_code")+"</a></td>");
			sResult.append("<td class='admin2'>"+rs.getString("oc_sparepart_name")+"</td>");
			String sAsset="";
			Asset asset = Asset.get(rs.getString("oc_sparepart_assetuid"));
			if(asset!=null){
				sAsset=asset.getDescription();
			}
			sResult.append("<td class='admin2'>"+sAsset+"</td>");
			sResult.append("<td class='admin2'>"+rs.getString("oc_sparepart_brand")+"</td>");
			sResult.append("<td class='admin2'>"+rs.getString("oc_sparepart_model")+"</td>");
			sResult.append("<td class='admin2'>"+rs.getString("oc_sparepart_type")+"</td>");
			sResult.append("<td class='admin2'>"+rs.getString("oc_sparepart_location")+"</td>");
			sResult.append("<td class='admin2'>"+rs.getString("oc_sparepart_quantity")+"</td>");
			sResult.append("<td class='admin2'>"+rs.getString("oc_sparepart_cost")+"</td>");
			sResult.append("</tr>");
		}
		rs.close();
		ps.close();
		conn.close();
		if(sResult.length()>0){
			out.println(sResult.toString());
		}
		out.println("</table>");
	} 
%>
<%	if(sAction.equalsIgnoreCase("edit")||sAction.equalsIgnoreCase("new")){ 
		if(sSparepartUID.length()>0){
			Connection conn = SH.getOpenClinicConnection();
			PreparedStatement ps = conn.prepareStatement("select * from oc_spareparts where oc_sparepart_serverid=? and oc_sparepart_objectid=?");
			ps.setInt(1,Integer.parseInt(sSparepartUID.split("\\.")[0]));
			ps.setInt(2,Integer.parseInt(sSparepartUID.split("\\.")[1]));
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				sCode=rs.getString("oc_sparepart_code");
				sName=rs.getString("oc_sparepart_name");
				sLocation=rs.getString("oc_sparepart_location");
				sAssetUid=rs.getString("oc_sparepart_assetuid");
				sBrand=rs.getString("oc_sparepart_brand");
				sModel=rs.getString("oc_sparepart_model");
				sType=rs.getString("oc_sparepart_type");
				sQuantity=rs.getString("oc_sparepart_quantity");
				sCost=rs.getString("oc_sparepart_cost");
			}
			rs.close();
			ps.close();
			conn.close();
		}
		%>
		<form name='transactionForm' method='post'>
			<input type='hidden' name='sparepartuid' id='sparepartuid' value='<%=sSparepartUID %>'/>
			<input type='hidden' name='action' id='action' value=''/>
			<table width='100%'>
				<tr class='admin'><td colspan='6'><%=getTran(request,"web","gmao.spareparts",sWebLanguage) %></td></tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","code",sWebLanguage) %></td>
					<td class='admin2'><input name='code' id='code' class='text' type='text' size='25' value='<%=sCode %>'/></td>
					<td class='admin'><%=getTran(request,"web","name",sWebLanguage) %></td>
					<td class='admin2'><input name='name' id='name' class='text' type='text' size='25' value='<%=sName %>'/></td>
					<td class='admin'><%=getTran(request,"web","location",sWebLanguage) %></td>
					<td class='admin2'><input name='location' id='location' class='text' type='text' size='25' value='<%=sLocation %>'/></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","brand",sWebLanguage) %></td>
					<td class='admin2'><input name='brand' id='brand' class='text' type='text' size='25' value='<%=sBrand %>'/></td>
					<td class='admin'><%=getTran(request,"web","model",sWebLanguage) %></td>
					<td class='admin2'><input name='model' id='model' class='text' type='text' size='25' value='<%=sModel %>'/></td>
					<td class='admin'><%=getTran(request,"web","type",sWebLanguage) %></td>
					<td class='admin2'><input name='type' id='type' class='text' type='text' size='25' value='<%=sType %>'/></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","quantity",sWebLanguage) %></td>
					<td class='admin2'><input name='quantity' id='quantity' class='text' type='text' size='10' value='<%=sQuantity %>'/></td>
					<td class='admin'><%=getTran(request,"web","cost",sWebLanguage) %></td>
					<td class='admin2'><input name='cost' id='cost' class='text' type='text' size='10' value='<%=sCost %>'/></td>
					<td class='admin'><%=getTran(request,"web","asset",sWebLanguage) %></td>
					<td class='admin2'>
		                <input type="hidden" name="assetuid" id="assetuid" value="<%=sAssetUid%>">
		                <%
		                	String sAssetCode="";
		                	Asset asset = Asset.get(sAssetUid);
		                	if(asset!=null){
		                		sAssetCode=asset.getCode();
		                	}
		                %>
		                <input type="text" class="text" id="searchAssetCode" name="searchAssetCode" size="20" readonly value="<%=sAssetCode%>">
		                                   
		                <%-- buttons --%>
		                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("web","select",sWebLanguage)%>" onclick="selectAsset('assetuid','searchAssetCode');">
		                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("web","clear",sWebLanguage)%>" onclick="clearAssetSearchFields();">
		                <img src="<c:url value="/_img/icons/icon_view.png"/>" class="link" alt="<%=getTranNoLink("web","view",sWebLanguage)%>" onclick="viewAsset();">
					</td>
				</tr>
				<tr>
					<td/>
					<td>
						<input type='button' class='button' name='cancelButton' id='cancelButton' onclick='doCancel();' value='<%=getTranNoLink("web","cancel",sWebLanguage) %>'/>
						<% if(activeUser.getAccessRight("spareparts.edit")){%>
							<input type='submit' class='button' name='saveButton' id='saveButton' value='<%=getTranNoLink("web","save",sWebLanguage) %>'/>
						<% } %>
					</td>
				</tr>
			</table>
		</form>
<%	}%>
<script>
	function doCancel(){
		document.getElementById("code").value="";
		document.getElementById("name").value="";
		document.getElementById("location").value="";
		document.getElementById("action").value="search";
		transactionForm.submit();
	}
  	function selectAsset(uidField,codeField){
    	var url = "/_common/search/searchAsset.jsp&ts=<%=getTs()%>&PopupWidth=600&PopupHeight=500"+
			  "&ReturnFieldUid="+uidField+
              "&ReturnFieldCode="+codeField;
    	openPopup(url);
    	document.getElementById(codeField).focus();
  	}  
  
	function viewAsset(){
		if(document.getElementById("assetuid") && document.getElementById("assetuid").value.length>0){
			window.location.href='<c:url value="/main.do?Page=assets/manage_assets.jsp&action=edit&EditAssetUID="/>'+document.getElementById("assetuid").value;
		}
	}

	<%-- CLEAR ASSET FIELDS --%>
  	function clearAssetSearchFields(){
    	$("assetuid").value = "";
    	$("searchAssetCode").value = "";
    	$("searchAssetCode").focus();
  	}
  	function clearSparePartSearchFields(){
  		document.getElementById("assetuid").value='';
  		document.getElementById("searchAssetCode").value = "";
  		document.getElementById("code").value='';
  		document.getElementById("name").value='';
  		document.getElementById("brand").value='';
  		document.getElementById("model").value='';
  		document.getElementById("type").value='';
  	}
  	function editSparePart(uid){
  		document.getElementById('action').value='edit';
  		document.getElementById('sparepartuid').value=uid;
  		searchForm.submit();
  	}
</script>
