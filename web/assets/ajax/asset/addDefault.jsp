<%@page import="be.openclinic.assets.MaintenancePlan,
               java.text.*,be.openclinic.util.*,be.openclinic.assets.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String code = checkString(request.getParameter("code"));
	String nomenclature = checkString(request.getParameter("nomenclature"));
	String description = checkString(request.getParameter("description"));
	String assetType = checkString(request.getParameter("assetType"));
	String supplierUID = checkString(request.getParameter("supplierUID"));
	String characteristics = checkString(request.getParameter("characteristics"));
	String comment1 = checkString(request.getParameter("comment1"));
	String comment2 = checkString(request.getParameter("comment2"));
	String comment3 = checkString(request.getParameter("comment3"));
	String comment4 = checkString(request.getParameter("comment4"));
	String comment5 = checkString(request.getParameter("comment5"));
	String comment7 = checkString(request.getParameter("comment7"));
	String comment8 = checkString(request.getParameter("comment8"));
	String comment9 = checkString(request.getParameter("comment9"));
	String comment10 = checkString(request.getParameter("comment10"));
	String comment15 = checkString(request.getParameter("comment15"));
	String comment16 = checkString(request.getParameter("comment16"));
	String comment17 = checkString(request.getParameter("comment17"));
	
	if(nomenclature.length()>0){
		try{
			Connection conn = SH.getOpenClinicConnection();
			PreparedStatement ps = conn.prepareStatement("select * from oc_defaultassets where oc_asset_nomenclature=? and oc_asset_description=?");
			ps.setString(1,nomenclature);
			ps.setString(2,description);
			ResultSet rs = ps.executeQuery();
			System.out.println("1");
			if(!SH.c(request.getParameter("overwrite")).equalsIgnoreCase("1") && rs.next()){
				out.println("NOK-400");
			}
			else{
				Asset asset = new Asset();
				asset.setDescription(description);
				asset.setCode(code);
				asset.setNomenclature(nomenclature);
				asset.setQuantity(1);
				asset.setAssetType(assetType);
				asset.setSupplierUid(supplierUID);
				asset.setCharacteristics(characteristics);
				asset.setComment1(comment1);
				asset.setComment2(comment2);
				asset.setComment3(comment3);
				asset.setComment4(comment4);
				asset.setComment5(comment5);
				asset.setComment7(comment7);
				asset.setComment8(comment8);
				asset.setComment9(comment9);
				asset.setComment10(comment10);
				asset.setComment15(comment15);
				asset.setComment16(comment16);
				asset.setComment17(comment17);
				asset.copyToDefault(nomenclature);
				out.println("OK-200");
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception i){
			i.printStackTrace();
		}
	}
	else{
		out.println("NOK-300");
	}
%>