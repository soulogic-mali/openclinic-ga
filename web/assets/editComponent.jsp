<%@page import="be.openclinic.assets.Asset,
               java.text.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%@include file="../assets/includes/commonFunctions.jsp"%>
<%
	String componentuid = checkString(request.getParameter("componentuid"));
	String assetuid=componentuid.split("\\.")[0]+"."+componentuid.split("\\.")[1];
	int objectid = Integer.parseInt(componentuid.split("\\.")[2]);
	String nomenclature = componentuid.replaceAll(assetuid+"."+objectid+".", "");
	String type="";
	String status="";
	String characteristics="";
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from oc_assetcomponents where oc_component_objectid=? and oc_component_assetuid=? and oc_component_nomenclature=?");
	ps.setInt(1,objectid);
	ps.setString(2,assetuid);
	ps.setString(3,nomenclature);
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		if(type.indexOf(checkString(rs.getString("oc_component_type")))<0){
			if(type.length()>0){
				type+=", ";
			}
			type+=checkString(rs.getString("oc_component_type"));
		}
		status=checkString(rs.getString("oc_component_status"));
		if(characteristics.indexOf(checkString(rs.getString("oc_component_characteristics")))<0){
			if(characteristics.length()>0){
				characteristics+=", ";
			}
			characteristics+=checkString(rs.getString("oc_component_characteristics"));
		}
	}
	rs.close();
	ps.close();
	
	if(request.getParameter("submit")!=null){
		//Save the component data
		type=request.getParameter("type");
		status=request.getParameter("status");
		characteristics=request.getParameter("characteristics");
		ps = conn.prepareStatement("delete from oc_assetcomponents where oc_component_assetuid=? and oc_component_nomenclature=? and oc_component_objectid=?");
		ps.setString(1, assetuid);
		ps.setString(2, nomenclature);
		ps.setInt(3,objectid);
		ps.execute();
		ps.close();
		ps = conn.prepareStatement("insert into oc_assetcomponents(oc_component_assetuid,oc_component_nomenclature,oc_component_type,oc_component_status,oc_component_characteristics,oc_component_objectid) "+
				" values(?,?,?,?,?,?)");
		ps.setString(1, assetuid);
		ps.setString(2, nomenclature);
		ps.setString(3, type);
		ps.setString(4, status);
		ps.setString(5, characteristics);
		ps.setInt(6, objectid);
		ps.execute();
		ps.close();
		conn.close();
		out.println("<script>window.opener.loadComponents();window.close();</script>");
		out.flush();
	}
	else {
		conn.close();
	}
	
%>
<form name='transactionForm' method='post'>
	<input type='hidden' name='componentuid' id='componentuid' value='<%=componentuid %>'/>
	<table width='100%'>
		<tr class='admin'><td colspan='2'><%=getTran(request,"web","editcomponent",sWebLanguage) %></td></tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","componentid",sWebLanguage) %></td>
			<td class='admin2'><%= componentuid%></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","type",sWebLanguage) %> *</td>
			<td class='admin2'><input class='text' type='text' size='80' name='type' id='type' value='<%= type%>'/></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","functionalstatus",sWebLanguage) %></td>
			<td class='admin2'>
				<select class='text' name='status' id='status'>
					<option/>
					<%=ScreenHelper.writeSelect(request,"component.status",status,sWebLanguage) %>
				</select>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","characteristics",sWebLanguage) %></td>
			<td class='admin2'><textarea onkeyup="resizeTextarea(this,8);" class='text' cols='80' name='characteristics' id='characteristics'><%=characteristics %></textarea></td>
		</tr>
	</table>
	<input type='submit' name='submit' value='<%=getTranNoLink("web","save",sWebLanguage) %>' class='button'/>
</form>