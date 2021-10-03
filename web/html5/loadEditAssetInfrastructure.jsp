<%@page import="be.openclinic.assets.*"%>
<%@ page errorPage="/includes/error.jsp" %>
<%@ include file="/includes/validateUser.jsp" %>
<%
	Asset asset = new Asset();
	Connection conn = SH.getOpenClinicConnection();
	String assetuid = SH.p(request,"assetuid");
	if(assetuid.length()>0){
		asset=Asset.get(assetuid);
	}
%>
<table width='100%'>
	<% if(SH.p(request,"assetuid").length()>0){%>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("web","ID",sWebLanguage)%>
		</td>
		<td class='mobileadmin2' style='font-size:4vw;'>
			<%=SH.p(request,"assetuid") %>
		</td>
	</tr>
	<% }%>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("web","service",sWebLanguage)%>
		</td>
		<td class='mobileadmin2' style='font-size:4vw;'>
			<%=asset.getServerId()+" - "+getTranNoLink("service",asset.getServiceuid(),sWebLanguage) %>
		</td>
	</tr>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("web","nomenclature",sWebLanguage)%>&nbsp;*
		</td>
		<td class='mobileadmin2' style='font-size:4vw;'>
	       	<select name='nomenclature' id='nomenclature' style='width: 95% !important;font-size: 4vw;height: 6vw;'>
	       		<option style='font-size:4vw;'/>
	       		<%
	       			PreparedStatement ps = conn.prepareStatement("select * from oc_labels where oc_label_type='admin.nomenclature.asset' and oc_label_language=? and oc_label_id like 'i%' order by oc_label_id");
	       			ps.setString(1,sWebLanguage);
	       			ResultSet rs = ps.executeQuery();
	       			while(rs.next()){
	       				out.println("<option "+(SH.c(rs.getString("oc_label_id")).equalsIgnoreCase(asset.getNomenclature())?"selected":"")+" value='"+rs.getString("oc_label_id")+"' style='font-size:4vw;'>"+SH.c(rs.getString("oc_label_id")).toUpperCase()+" - "+SH.c(rs.getString("oc_label_value")).toUpperCase()+"</option>");
	       			}
	       			rs.close();
	       			ps.close();
	       		%>
			</select>
		</td>
	</tr>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("web","code",sWebLanguage)%>&nbsp;*
		</td>
		<td class='mobileadmin2' style='font-size:4vw;'>
			<input type='text' style='width: 95% !important;font-size: 4vw;height: 6vw;' name='code' id='code' size='10' value='<%=asset.getCode()%>'/>
		</td>
	</tr>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("web","description",sWebLanguage)%>&nbsp;*
		</td>
		<td class='mobileadmin2' style='font-size:4vw;'>
			<input type='text' style='width: 95% !important;font-size: 4vw;height: 6vw;' name='description' id='description' size='10' value='<%=asset.getDescription()%>'/>
		</td>
	</tr>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("web.assets","surface",sWebLanguage)%>
		</td>
		<td class='mobileadmin2' style='font-size:4vw;'>
			<input type='text' style='width: 95% !important;font-size: 4vw;height: 6vw;' name='comment17' id='comment17' size='10' value='<%=asset.getComment17()%>'/>
		</td>
	</tr>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("web.assets","infrastructure.status",sWebLanguage)%>&nbsp;*
		</td>
		<td class='mobileadmin2' style='font-size:4vw;'>
	       	<select name='comment9' id='comment9' style='width: 95% !important;font-size: 4vw;height: 6vw;'>
	       		<option style='font-size:4vw;'/>
                <%=ScreenHelper.writeSelectWithStyle(request,"assets.status",checkString(asset.getComment9()),sWebLanguage,"font-size: 4vw;")%>
            </select>
            <input type='hidden' name='comment7' id='comment7'/>
		</td>
	</tr>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("web.assets","serialnumber",sWebLanguage)%>
		</td>
		<td class='mobileadmin2' style='font-size:4vw;'>
			<input type='text' style='width: 95% !important;font-size: 4vw;height: 6vw;' name='serialnumber' id='serialnumber' size='10' value='<%=asset.getSerialnumber()%>'/>
		</td>
	</tr>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("web.assets","characteristics",sWebLanguage)%>
		</td>
		<td class='mobileadmin2' style='font-size:4vw;'>
			<textarea style='width: 95% !important;font-size: 4vw;height: 45vw;' cols='10' rows='2' name='characteristics' id='characteristics'><%=checkString(asset.getCharacteristics().replaceAll("<br>", "\n"))%></textarea>
		</td>
	</tr>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("web.assets","supplier",sWebLanguage)%>
		</td>
		<td class='mobileadmin2' style='font-size:4vw;'>
			<input type='text' style='width: 95% !important;font-size: 4vw;height: 6vw;' name='supplieruid' id='supplieruid' size='10' value='<%=asset.getSupplierUid()%>'/>
		</td>
	</tr>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("web.assets","purchaseDate",sWebLanguage)%>
		</td>
		<td class='mobileadmin2' style='font-size:4vw;'>
			<input style='width: 80% !important;padding:4px; font-size: 4vw;' type='date' name='purchasedate' id='purchasedate' value='<%=asset.getPurchaseDate()==null?"":new SimpleDateFormat("yyyy-MM-dd").format(asset.getPurchaseDate()) %>' size='10'/>
		</td>
	</tr>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("web.assets","productiondate",sWebLanguage)%>
		</td>
		<td class='mobileadmin2' style='font-size:4vw;'>
			<input style='width: 80% !important;padding:4px; font-size: 4vw;' type='date' name='comment11' id='comment11' value='<%=SH.c(asset.getComment11()).length()==0||SH.parseDate(asset.getComment11(),"yyyy-MM-dd")==null?"":asset.getComment11() %>' size='10'/>
		</td>
	</tr>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("web.assets","infrastructure.deliverydate",sWebLanguage)%>&nbsp;*
		</td>
		<td class='mobileadmin2' style='font-size:4vw;'>
			<input style='width: 80% !important;padding:4px; font-size: 4vw;' type='date' name='comment12' id='comment12' value='<%=SH.c(asset.getComment12()).length()==0||SH.parseDate(asset.getComment12(),"yyyy-MM-dd")==null?"":asset.getComment12() %>' size='10'/>
		</td>
	</tr>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("web.assets","datefirstuse",sWebLanguage)%>
		</td>
		<td class='mobileadmin2' style='font-size:4vw;'>
			<input style='width: 80% !important;padding:4px; font-size: 4vw;' type='date' name='comment13' id='comment13' value='<%=SH.c(asset.getComment13()).length()==0||SH.parseDate(asset.getComment13(),"yyyy-MM-dd")==null?"":asset.getComment13() %>' size='10'/>
		</td>
	</tr>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("web.assets","purchasePrice",sWebLanguage)%>&nbsp;*
		</td>
		<td class='mobileadmin2' style='font-size:4vw;'>
			<input type='text' style='width: 95% !important;font-size: 4vw;height: 6vw;' name='purchaseprice' id='purchaseprice' size='10' value='<%=asset.getPurchasePrice()%>'/>
		</td>
	</tr>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("web.assets","fundingsource",sWebLanguage)%>&nbsp;*
		</td>
		<td class='mobileadmin2' style='font-size:4vw;'>
			<input type='text' style='width: 95% !important;font-size: 4vw;height: 6vw;' name='comment6' id='comment6' size='10' value='<%=asset.getComment6()%>'/>
		</td>
	</tr>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("web.assets","endofwarantydate",sWebLanguage)%>
		</td>
		<td class='mobileadmin2' style='font-size:4vw;'>
			<input style='width: 80% !important;padding:4px; font-size: 4vw;' type='date' name='comment14' id='comment14' value='<%=SH.c(asset.getComment14()).length()==0||SH.parseDate(asset.getComment14(),"yyyy-MM-dd")==null?"":asset.getComment14() %>' size='10'/>
		</td>
	</tr>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("web.assets","saleDate",sWebLanguage)%>
		</td>
		<td class='mobileadmin2' style='font-size:4vw;'>
			<input style='width: 80% !important;padding:4px; font-size: 4vw;' type='date' name='saledate' id='saledate' value='<%=SH.c(asset.getSaleDate()).length()==0?"":new SimpleDateFormat("yyyy-MM-dd").format(asset.getSaleDate()) %>' size='10'/>
		</td>
	</tr>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("web.assets","saleValue",sWebLanguage)%>
		</td>
		<td class='mobileadmin2' style='font-size:4vw;'>
			<input type='text' style='width: 95% !important;font-size: 4vw;height: 6vw;' name='salevalue' id='salevalue' size='10' value='<%=asset.getSaleValue()%>'/>
		</td>
	</tr>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("web.assets","saleClient",sWebLanguage)%>
		</td>
		<td class='mobileadmin2' style='font-size:4vw;'>
			<input type='text' style='width: 95% !important;font-size: 4vw;height: 6vw;' name='saleclient' id='saleclient' size='10' value='<%=asset.getSaleClient()%>'/>
		</td>
	</tr>
	<%	if(assetuid.length()>0){ %>
	<tr>
		<td class='mobileadmin' style='font-size:4vw;'>
			<%=getTranNoLink("web","lastmodificationby",sWebLanguage)%>
		</td>
		<td class='mobileadmin2' style='font-size:4vw;'>
			<%=User.getFullUserName(asset.getUpdateUser()) %> (<%=ScreenHelper.formatDate(asset.getUpdateDateTime(), ScreenHelper.fullDateFormat) %>)
		</td>
	</tr>
	<% } %>
</table>
<%
	conn.close();
%>