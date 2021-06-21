<%@page import="be.openclinic.assets.MaintenancePlan,
               java.text.*,be.openclinic.util.*,be.openclinic.assets.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<table width='100%'>
<%
	StringBuffer sResult = new StringBuffer();
	String sNomenclature=SH.c(request.getParameter("nomenclature"));
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from oc_defaultassets where oc_asset_nomenclature=?");
	ps.setString(1, sNomenclature);
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		String uid=rs.getString("oc_asset_uid");
		sResult.append("<tr>");
		sResult.append("<td class='admin' nowrap width='1%'>");
		if(activeUser.getAccessRight("assets.defaultassets.delete")){
			sResult.append("<img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' onclick='deleteDefault(\""+uid+"\")'/>");
		}
		if(activeUser.getAccessRight("assets.edit")){
			sResult.append("</td><td class='admin2'><a href='javascript:selectDefault(\""+uid+"\")'>"+rs.getString("oc_asset_description")+"</a></td></tr>");		
		}
		else{
			sResult.append("</td><td class='admin2'>"+rs.getString("oc_asset_description")+"</td></tr>");		
		}
	}
%>
	<tr class='admin'>
		<td colspan='3'><%=getTran(request,"web","defaultassetsfornomenclaturecode",sWebLanguage)+": "+sNomenclature %></td>
		<%= sResult %>
	</tr>
</table>

<script>
	function deleteDefault(uid){
		if(window.confirm('<%=getTranNoLink("web","areyousuretodelete",sWebLanguage)%>')){
		    var url = "<c:url value='/assets/ajax/asset/deleteDefault.jsp'/>?ts="+new Date().getTime();
		    new Ajax.Request(url,{
		    	method: "POST",
		    	parameters: "assetuid="+uid,
		    	onSuccess: function(resp){
					window.location.reload();
		    	},
		    	onFailure: function(resp){
		    	}
		  	});
		}
	}
	
	function selectDefault(uid){
		if(window.confirm('<%=getTranNoLink("web","areyousuretoloadmodel",sWebLanguage)%>')){
			window.opener.loadDefaultAsset(uid);
			window.close();
		}
	}
</script>