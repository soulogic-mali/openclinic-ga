<%@page import="be.openclinic.assets.MaintenancePlan,
               java.text.*,be.openclinic.util.*,be.openclinic.assets.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<table width='100%'>
<%
	StringBuffer sResult = new StringBuffer();
	String sNomenclature=SH.c(request.getParameter("nomenclature"));
	Asset asset = Asset.get(request.getParameter("assetUID"));
	if(asset!=null && asset.hasValidUid()){
		sNomenclature=asset.getNomenclature();
	}
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from oc_defaultmaintenanceplans where oc_maintenanceplan_nomenclature=?");
	ps.setString(1, sNomenclature);
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		String uid=rs.getString("oc_maintenanceplan_uid");
		sResult.append("<tr>");
		sResult.append("<td class='admin' nowrap width='1%'>");
		if(activeUser.getAccessRight("assets.defaultmaintenanceplans.delete")){
			sResult.append("<img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' onclick='deleteDefault(\""+uid+"\")'/>");
		}
		if(activeUser.getAccessRight("maintenanceplans.edit")){
			sResult.append("</td><td class='admin2'><a href='javascript:selectDefault("+uid+")'>"+rs.getString("oc_maintenanceplan_name")+"</a></td><td class='admin2' nowrap width='1%'>"+getTran(request,"maintenanceplan.frequency",rs.getString("oc_maintenanceplan_frequency"),sWebLanguage)+"</td></tr>");		
		}
		else{
			sResult.append("</td><td class='admin2'>"+rs.getString("oc_maintenanceplan_name")+"</td><td class='admin2' nowrap width='1%'>"+getTran(request,"maintenanceplan.frequency",rs.getString("oc_maintenanceplan_frequency"),sWebLanguage)+"</td></tr>");		
		}
	}
%>
	<tr class='admin'>
		<td colspan='3'><%=getTran(request,"web","defaultplansfornomenclaturecode",sWebLanguage)+": "+sNomenclature %></td>
		<%= sResult %>
	</tr>
</table>

<script>
	function deleteDefault(uid){
		if(window.confirm('<%=getTranNoLink("web","areyousuretodelete",sWebLanguage)%>')){
		    var url = "<c:url value='/assets/ajax/maintenancePlan/deleteDefault.jsp'/>?ts="+new Date().getTime();
		    new Ajax.Request(url,{
		    	method: "POST",
		    	parameters: "maintenanceplanuid="+uid,
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
			window.opener.loadDefaultMaintenancePlan(uid);
			window.close();
		}
	}
</script>