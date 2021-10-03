<%@page import="be.openclinic.assets.*,be.openclinic.util.*,
                be.mxs.common.util.system.HTMLEntities,
                java.util.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%@include file="../../../assets/includes/commonFunctions.jsp"%>
<table width='100%'>
	<%
		try{
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			PreparedStatement ps=null;
			ResultSet rs = null;
			String assetuid = checkString(request.getParameter("assetuid"));
			if(assetuid.length()>0){
				Asset asset = Asset.get(assetuid);
				boolean bLocked = asset.getObjectId()>-1 && ((asset.getLockedBy()>-1 && asset.getLockedBy()!=MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",-1)) || (asset.getLockedBy()==-1 && MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",-1)!=0));
				ps = conn.prepareStatement("select * from oc_assetcomponents where oc_component_assetuid=? order by oc_component_nomenclature,oc_component_objectid");
				ps.setString(1,assetuid);
				rs = ps.executeQuery();
				String type="",status="",characteristics="";
				while(rs.next()){
					Nomenclature nomenclature = Nomenclature.get("assetcomponent",rs.getString("oc_component_nomenclature"));
					if(nomenclature!=null){
						out.println("<tr>");
						out.println("<td valign='bottom' width='1%' nowrap>"+(!bLocked && activeUser.getAccessRight("assets.edit")?"<img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' onclick='deleteComponent(\""+assetuid+"."+rs.getString("oc_component_objectid")+"."+rs.getString("oc_component_nomenclature")+"\",\""+assetuid+"\")'/> <img src='"+sCONTEXTPATH+"/_img/icons/icon_edit.png' onclick='editComponent(\""+assetuid+"."+rs.getString("oc_component_objectid")+"."+rs.getString("oc_component_nomenclature")+"\")'/>":"")+rs.getString("oc_component_nomenclature")+" "+nomenclature.getFullyQualifiedName(sWebLanguage)+"</td>");
						type=checkString(rs.getString("oc_component_type"));
						status=checkString(rs.getString("oc_component_status"));
						characteristics=checkString(rs.getString("oc_component_characteristics"));
						if(type.length()>0){
							out.println("<td  valign='bottom' width='5%'>&nbsp;</td>");
							out.println("<td  valign='bottom'><b>"+type+"</b></td>");
							out.println("<td  valign='bottom' nowrap><b>"+getTran(request,"component.status",status,sWebLanguage)+"</b></td>");
							out.println("<td  valign='bottom' ><b>"+characteristics+"</b></td>");
						}
						else{
							out.println("<td colspan='3'/>");
						}
						out.println("</tr>");
					}
				}
				rs.close();
				ps.close();
			}
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
	%>
</table>