<%@page import="java.util.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>
<%
	String structure=checkString(request.getParameter("structure"));
	String quantity=checkString(request.getParameter("quantity"));
	String nomenclature=checkString(request.getParameter("nomenclature"));
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = null;
	if(request.getParameter("submitbutton")!=null){
		ps = conn.prepareStatement("delete from oc_standards where structure=? and nomenclature=?");
		ps.setString(1,structure);
		ps.setString(2,nomenclature);
		ps.execute();
		ps.close();
		ps = conn.prepareStatement("insert into oc_standards(structure,nomenclature,quantity) values(?,?,?)");
		ps.setString(1,structure);
		ps.setString(2,nomenclature);
		ps.setDouble(3,Double.parseDouble(quantity));
		ps.execute();
		ps.close();
	}
	else if(request.getParameter("deletebutton")!=null){
		ps = conn.prepareStatement("delete from oc_standards where structure=? and nomenclature=?");
		ps.setString(1,structure);
		ps.setString(2,nomenclature);
		ps.execute();
		ps.close();
	}
%>
<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='2'><%=getTran(request,"web.manage","manageStandards",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","typeofstructure",sWebLanguage) %></td>
			<td class='admin'>
				<select name='structure' id='structure' class='text'>
					<%=ScreenHelper.writeSelect(request, "structuretype", structure, sWebLanguage) %>
				</select>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","nomenclature",sWebLanguage) %></td>
			<td class='admin'>
	            <input type="text" class="text" readonly id="FindNomenclatureCode" name="FindNomenclatureCode" size="50" maxLength="80" value="<%=getTranNoLink("admin.nomenclature.asset",nomenclature,sWebLanguage)%>">
	            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchNomenclature('nomenclature','FindNomenclatureCode');">
	            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="SearchForm.FindNomenclatureCode.value='';SearchForm.nomenclature.value='';">
	            <input type="hidden" name="nomenclature" id="nomenclature" value="<%=nomenclature%>">&nbsp;
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","quantity",sWebLanguage) %></td>
			<td class='admin'><input name='quantity' id='quantity' type='text' size='5' value='<%=quantity %>'/></td>
		</tr>
		<tr>
			<td class='admin'></td>
			<td class='admin'><input type='submit' name='submitbutton' value='<%=getTranNoLink("web","save",sWebLanguage)%>'/>&nbsp;<input type='submit' name='deletebutton' value='<%=getTranNoLink("web","delete",sWebLanguage)%>'/></td>
		</tr>
	</table>
</form>
<table width='100%'>
	<%
		ps = conn.prepareStatement("select * from oc_standards order by structure,nomenclature");
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
			String snm="";
			String nm[] = rs.getString("nomenclature").split(";");
			for(int n=0;n<nm.length;n++){
				if(n>0){
					snm+=", ";
				}
				snm+=nm[n].toUpperCase()+" - "+getTran(request,"admin.nomenclature.asset",nm[n],sWebLanguage);
			}
			out.println("<tr><td class='admin2'>"+rs.getString("structure").toUpperCase()+"</td><td class='admin2'>"+rs.getString("quantity")+"</td><td class='admin2'><a href='javascript:editstandard(\""+rs.getString("structure")+"\",\""+rs.getString("nomenclature")+"\",\""+rs.getString("quantity")+"\")'>"+snm+"</a></td></tr>");
		}
		rs.close();
		ps.close();
		conn.close();
	%>
</table>
<script>
	function searchNomenclature(CategoryUidField,CategoryNameField){
	    openPopup("/_common/search/searchNomenclature.jsp&ts=<%=getTs()%>&FindType=asset&VarCode="+CategoryUidField+"&VarText="+CategoryNameField);
	}
	
	function editstandard(structure,nomenclature,quantity){
		document.getElementById('structure').value=structure;
		document.getElementById('nomenclature').value=nomenclature;
		document.getElementById('quantity').value=quantity;
		transactionForm.submit();
	}
</script>