<%@page import="java.io.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%!
	public static void saveImage(String imageUrl, String destinationFile) throws IOException {
		if(ScreenHelper.checkString(imageUrl).length()>0){
			URL url = new URL(imageUrl);
			InputStream is = url.openStream();
			OutputStream os = new FileOutputStream(destinationFile);
		
			byte[] b = new byte[2048];
			int length;
		
			while ((length = is.read(b)) != -1) {
				os.write(b, 0, length);
			}
		
			is.close();
			os.close();
		}
	}
%>
<%
	Connection conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select service,service2,date,infra2.*,infra3.* from openclinic.infra3,openclinic.infra2,openclinic.infra1 where infra1.instance=infra2.instance and infra1.instance=infra3.instance");
	ResultSet rs = ps.executeQuery();
	while (rs.next()){
		String serviceuid = rs.getString("service")+"."+rs.getString("service2");
		//Let's find the matching asset
		PreparedStatement ps2 = conn.prepareStatement("select * from oc_assets where oc_asset_service=?");
		ps2.setString(1,serviceuid);
		ResultSet rs2 = ps2.executeQuery();
		if(rs2.next()){
			int assetobjectid=rs2.getInt("oc_asset_objectid");
			java.util.Date updatetime=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss").parse(rs.getString("date"));
			rs2.close();
			ps2.close();
			//First remove previous infra components
			ps2=conn.prepareStatement("delete from oc_assetcomponents where oc_component_assetuid=?");
			ps2.setString(1,"1."+assetobjectid);
			ps2.execute();
			ps2.close();
			//drinking water
			ps2=conn.prepareStatement("insert into oc_assetcomponents(oc_component_assetuid,oc_component_nomenclature,oc_component_type,oc_component_characteristics,oc_component_status,oc_component_objectid)"+
			" values(?,?,?,?,?,0)");
			ps2.setString(1,"1."+assetobjectid);
			ps2.setString(2,"V.5");
			ps2.setString(3,checkString(rs.getString("drinkingwater")));
			ps2.setString(4,checkString(rs.getString("drinkingwater_comment")));
			ps2.setString(5,rs.getString("drinkingwater_status"));
			ps2.execute();
			ps2.close();
			//REGIDESO water
			if(checkString(rs.getString("regideso_water")).equalsIgnoreCase("oui")){
				ps2=conn.prepareStatement("insert into oc_assetcomponents(oc_component_assetuid,oc_component_nomenclature,oc_component_type,oc_component_characteristics,oc_component_status,oc_component_objectid)"+
				" values(?,?,?,?,?,0)");
				ps2.setString(1,"1."+assetobjectid);
				ps2.setString(2,"V.5.1");
				ps2.setString(3,"Oui");
				ps2.setString(4,"");
				ps2.setString(5,"");
				ps2.execute();
				ps2.close();
			}
			//electricity
			ps2=conn.prepareStatement("insert into oc_assetcomponents(oc_component_assetuid,oc_component_nomenclature,oc_component_type,oc_component_characteristics,oc_component_status,oc_component_objectid)"+
			" values(?,?,?,?,?,0)");
			ps2.setString(1,"1."+assetobjectid);
			ps2.setString(2,"V.4");
			ps2.setString(3,checkString(rs.getString("electricity")));
			ps2.setString(4,checkString(rs.getString("electricity_comment")));
			ps2.setString(5,rs.getString("electricity_status"));
			ps2.execute();
			ps2.close();
			//REGIDESO electricity
			if(checkString(rs.getString("regideso_electricity")).equalsIgnoreCase("oui")){
				ps2=conn.prepareStatement("insert into oc_assetcomponents(oc_component_assetuid,oc_component_nomenclature,oc_component_type,oc_component_characteristics,oc_component_status,oc_component_objectid)"+
				" values(?,?,?,?,?,0)");
				ps2.setString(1,"1."+assetobjectid);
				ps2.setString(2,"V.4.1");
				ps2.setString(3,"Oui");
				ps2.setString(4,"");
				ps2.setString(5,"");
				ps2.execute();
				ps2.close();
			}
			//Transformator
			if(checkString(rs.getString("transformator")).equalsIgnoreCase("oui")){
				ps2=conn.prepareStatement("insert into oc_assetcomponents(oc_component_assetuid,oc_component_nomenclature,oc_component_type,oc_component_characteristics,oc_component_status,oc_component_objectid)"+
				" values(?,?,?,?,?,0)");
				ps2.setString(1,"1."+assetobjectid);
				ps2.setString(2,"V.1");
				ps2.setString(3,"Oui");
				ps2.setString(4,"");
				ps2.setString(5,rs.getString("transformator_status"));
				ps2.execute();
				ps2.close();
			}
			//Tableau Général Basse Tension
			if(checkString(rs.getString("tgbt")).equalsIgnoreCase("oui")){
				ps2=conn.prepareStatement("insert into oc_assetcomponents(oc_component_assetuid,oc_component_nomenclature,oc_component_type,oc_component_characteristics,oc_component_status,oc_component_objectid)"+
				" values(?,?,?,?,?,0)");
				ps2.setString(1,"1."+assetobjectid);
				ps2.setString(2,"V.2");
				ps2.setString(3,"Oui");
				ps2.setString(4,"");
				ps2.setString(5,rs.getString("tgbt_status"));
				ps2.execute();
				ps2.close();
			}
			//Tableau Général Basse Tension
			if(checkString(rs.getString("parafoudre")).equalsIgnoreCase("oui")){
				ps2=conn.prepareStatement("insert into oc_assetcomponents(oc_component_assetuid,oc_component_nomenclature,oc_component_type,oc_component_characteristics,oc_component_status,oc_component_objectid)"+
				" values(?,?,?,?,?,0)");
				ps2.setString(1,"1."+assetobjectid);
				ps2.setString(2,"V.14");
				ps2.setString(3,"Oui");
				ps2.setString(4,"");
				ps2.setString(5,rs.getString("parafoudre_status"));
				ps2.execute();
				ps2.close();
			}
			//Voieries, réseaux et divers
			ps2=conn.prepareStatement("insert into oc_assetcomponents(oc_component_assetuid,oc_component_nomenclature,oc_component_type,oc_component_characteristics,oc_component_status,oc_component_objectid)"+
			" values(?,?,?,?,?,0)");
			ps2.setString(1,"1."+assetobjectid);
			ps2.setString(2,"VIII.4");
			ps2.setString(3,checkString(rs.getString("vrd")));
			ps2.setString(4,"");
			ps2.setString(5,rs.getString("vrd_status"));
			ps2.execute();
			ps2.close();
			//Clôture de la parcelle
			if(checkString(rs.getString("fence")).equalsIgnoreCase("oui")){
				ps2=conn.prepareStatement("insert into oc_assetcomponents(oc_component_assetuid,oc_component_nomenclature,oc_component_type,oc_component_characteristics,oc_component_status,oc_component_objectid)"+
				" values(?,?,?,?,?,0)");
				ps2.setString(1,"1."+assetobjectid);
				ps2.setString(2,"VIII.1");
				ps2.setString(3,checkString(rs.getString("fence_type")));
				ps2.setString(4,checkString(rs.getString("fence_comment"))+", Hauteur: "+checkString(rs.getString("fence_height"))+"m, Longeur: "+checkString(rs.getString("fence_length")));
				ps2.setString(5,rs.getString("fence_status"));
				ps2.execute();
				ps2.close();
			}
			else if(checkString(rs.getString("fence_comment")).length()>0){
				ps2=conn.prepareStatement("insert into oc_assetcomponents(oc_component_assetuid,oc_component_nomenclature,oc_component_type,oc_component_characteristics,oc_component_status,oc_component_objectid)"+
				" values(?,?,?,?,?,0)");
				ps2.setString(1,"1."+assetobjectid);
				ps2.setString(2,"VIII.1");
				ps2.setString(3,"Non");
				ps2.setString(4,checkString(rs.getString("fence_comment")));
				ps2.setString(5,"");
				ps2.execute();
				ps2.close();
			}
			if(checkString(rs.getString("rainwater")).equalsIgnoreCase("oui")){
				ps2=conn.prepareStatement("insert into oc_assetcomponents(oc_component_assetuid,oc_component_nomenclature,oc_component_type,oc_component_characteristics,oc_component_status,oc_component_objectid)"+
				" values(?,?,?,?,?,0)");
				ps2.setString(1,"1."+assetobjectid);
				ps2.setString(2,"VII.2");
				ps2.setString(3,checkString(rs.getString("rainwater_type")));
				ps2.setString(4,checkString(rs.getString("rainwater_use"))+", Capacité: "+checkString(rs.getString("rainwater_capacity"))+"l");
				ps2.setString(5,rs.getString("fence_status"));
				ps2.execute();
				ps2.close();
			}
			if(checkString(rs.getString("field29")).equalsIgnoreCase("oui")){
				ps2=conn.prepareStatement("insert into oc_assetcomponents(oc_component_assetuid,oc_component_nomenclature,oc_component_type,oc_component_characteristics,oc_component_status,oc_component_objectid)"+
				" values(?,?,?,?,?,0)");
				ps2.setString(1,"1."+assetobjectid);
				ps2.setString(2,"V.5.2");
				ps2.setString(3,checkString(rs.getString("drinkingwater_access")));
				ps2.setString(4,"Capacité: "+checkString(rs.getString("drinkingwater_capacity"))+"l");
				ps2.setString(5,rs.getString("fence_status"));
				ps2.execute();
				ps2.close();
			}
			if(checkString(rs.getString("emergency_energy")).equalsIgnoreCase("oui")){
				ps2=conn.prepareStatement("insert into oc_assetcomponents(oc_component_assetuid,oc_component_nomenclature,oc_component_type,oc_component_characteristics,oc_component_status,oc_component_objectid)"+
				" values(?,?,?,?,?,0)");
				ps2.setString(1,"1."+assetobjectid);
				ps2.setString(2,"V.15");
				ps2.setString(3,checkString(rs.getString("emergency_energie_type")));
				String comment="";
				if(checkString(rs.getString("solarpanels_number")).length()>0){
					comment+=rs.getString("solarpanels_number")+" panneaux solaires";
				}
				if(checkString(rs.getString("solarpanels_location")).length()>0){
					comment+=", "+rs.getString("solarpanels_location");
				}
				if(checkString(rs.getString("max_lighting")).length()>0){
					comment+=", Autonomie: "+rs.getString("max_lighting");
				}
				if(checkString(rs.getString("emergencyenergy_power")).length()>0){
					comment+=", Puissance: "+rs.getString("emergencyenergy_power");
				}
				ps2.setString(4,comment);
				ps2.setString(5,"");
				ps2.execute();
				ps2.close();
			}
			if(checkString(rs.getString("foose_placenta")).equalsIgnoreCase("oui")){
				ps2=conn.prepareStatement("insert into oc_assetcomponents(oc_component_assetuid,oc_component_nomenclature,oc_component_type,oc_component_characteristics,oc_component_status,oc_component_objectid)"+
				" values(?,?,?,?,?,0)");
				ps2.setString(1,"1."+assetobjectid);
				ps2.setString(2,"VII.4");
				ps2.setString(3,checkString(rs.getString("fosse_placenta_type")));
				ps2.setString(4,checkString(rs.getString("fosse_placenta_type_comment")));
				ps2.setString(5,rs.getString("fosse_placenta_status"));
				ps2.execute();
				ps2.close();
			}
			if(checkString(rs.getString("fosse_biomed")).equalsIgnoreCase("oui")){
				ps2=conn.prepareStatement("insert into oc_assetcomponents(oc_component_assetuid,oc_component_nomenclature,oc_component_type,oc_component_characteristics,oc_component_status,oc_component_objectid)"+
				" values(?,?,?,?,?,0)");
				ps2.setString(1,"1."+assetobjectid);
				ps2.setString(2,"VII.7");
				ps2.setString(3,checkString(rs.getString("fosse_biomed_type")));
				ps2.setString(4,checkString(rs.getString("fosse_biomed_type_comment")));
				ps2.setString(5,rs.getString("fosse_biomed_status"));
				ps2.execute();
				ps2.close();
			}
			if(checkString(rs.getString("fosse_needles")).equalsIgnoreCase("oui")){
				ps2=conn.prepareStatement("insert into oc_assetcomponents(oc_component_assetuid,oc_component_nomenclature,oc_component_type,oc_component_characteristics,oc_component_status,oc_component_objectid)"+
				" values(?,?,?,?,?,0)");
				ps2.setString(1,"1."+assetobjectid);
				ps2.setString(2,"VII.5");
				ps2.setString(3,checkString(rs.getString("fosse_needles_type")));
				ps2.setString(4,checkString(rs.getString("fosse_needles_type_comment")));
				ps2.setString(5,rs.getString("fosse_needles_status"));
				ps2.execute();
				ps2.close();
			}
			ps2=conn.prepareStatement("insert into oc_assetcomponents(oc_component_assetuid,oc_component_nomenclature,oc_component_type,oc_component_characteristics,oc_component_status,oc_component_objectid)"+
			" values(?,?,?,?,?,0)");
			ps2.setString(1,"1."+assetobjectid);
			ps2.setString(2,"VIII.5");
			ps2.setString(3,checkString(rs.getString("roadaccessstatus")));
			ps2.setString(4,"");
			ps2.setString(5,(Integer.parseInt(checkString(rs.getString("roadaccess")).substring(0,1))+1)+"");
			ps2.execute();
			ps2.close();
			if(checkString(rs.getString("parking")).equalsIgnoreCase("oui")){
				ps2=conn.prepareStatement("insert into oc_assetcomponents(oc_component_assetuid,oc_component_nomenclature,oc_component_type,oc_component_characteristics,oc_component_status,oc_component_objectid)"+
				" values(?,?,?,?,?,0)");
				ps2.setString(1,"1."+assetobjectid);
				ps2.setString(2,"VII.4");
				ps2.setString(3,"Parking de "+checkString(rs.getString("parkingcapacity"))+" places");
				ps2.setString(4,"");
				ps2.setString(5,rs.getString("parking_status"));
				ps2.execute();
				ps2.close();
			}
			//First remove previous infra pictures
			ps2=conn.prepareStatement("delete from arch_documents where arch_document_reference=?");
			ps2.setString(1,"asset.1."+assetobjectid);
			ps2.execute();
			ps2.close();
			//Now get the images
			String sImage=rs.getString("view_entry");
			try{
				saveImage(sImage, "c:/temp/images/0/"+assetobjectid+".1.jpg");
				ps2=conn.prepareStatement("insert into arch_documents(arch_document_serverid,arch_document_objectid,arch_document_udi,arch_document_title,arch_document_category,arch_document_date,arch_document_reference,arch_document_storagename,arch_document_updatetime,arch_document_updateid)"+
				" values(?,?,?,?,?,?,?,?,?,?)");
				ps2.setInt(1,1);
				int n=MedwanQuery.getInstance().getOpenclinicCounter("ARCH_DOCUMENTS");
				ps2.setInt(2,n);
				ps2.setString(3,n+"");
				ps2.setString(4,"Vue de face");
				ps2.setString(5,"asset");
				ps2.setTimestamp(6,new Timestamp(new java.util.Date().getTime()));
				ps2.setString(7,"asset.1."+assetobjectid);
				ps2.setString(8,"0/"+assetobjectid+".1.jpg");
				ps2.setTimestamp(9,new Timestamp(new java.util.Date().getTime()));
				ps2.setInt(10,4);
				ps2.execute();
				ps2.close();
			}
			catch(Exception e){
				System.out.println("Could not get image "+sImage);
			}
			sImage=rs.getString("view_south");
			try{
				saveImage(sImage, "c:/temp/images/0/"+assetobjectid+".2.jpg");
				ps2=conn.prepareStatement("insert into arch_documents(arch_document_serverid,arch_document_objectid,arch_document_udi,arch_document_title,arch_document_category,arch_document_date,arch_document_reference,arch_document_storagename,arch_document_updatetime,arch_document_updateid)"+
				" values(?,?,?,?,?,?,?,?,?,?)");
				ps2.setInt(1,1);
				int n=MedwanQuery.getInstance().getOpenclinicCounter("ARCH_DOCUMENTS");
				ps2.setInt(2,n);
				ps2.setString(3,n+"");
				ps2.setString(4,"Vue du sud");
				ps2.setString(5,"asset");
				ps2.setTimestamp(6,new Timestamp(new java.util.Date().getTime()));
				ps2.setString(7,"asset.1."+assetobjectid);
				ps2.setString(8,"0/"+assetobjectid+".2.jpg");
				ps2.setTimestamp(9,new Timestamp(new java.util.Date().getTime()));
				ps2.setInt(10,4);
				ps2.execute();
				ps2.close();
			}
			catch(Exception e){
				System.out.println("Could not get image "+sImage);
			}
			sImage=rs.getString("view_north");
			try{
				saveImage(sImage, "c:/temp/images/0/"+assetobjectid+".3.jpg");
				ps2=conn.prepareStatement("insert into arch_documents(arch_document_serverid,arch_document_objectid,arch_document_udi,arch_document_title,arch_document_category,arch_document_date,arch_document_reference,arch_document_storagename,arch_document_updatetime,arch_document_updateid)"+
				" values(?,?,?,?,?,?,?,?,?,?)");
				ps2.setInt(1,1);
				int n=MedwanQuery.getInstance().getOpenclinicCounter("ARCH_DOCUMENTS");
				ps2.setInt(2,n);
				ps2.setString(3,n+"");
				ps2.setString(4,"Vue du nord");
				ps2.setString(5,"asset");
				ps2.setTimestamp(6,new Timestamp(new java.util.Date().getTime()));
				ps2.setString(7,"asset.1."+assetobjectid);
				ps2.setString(8,"0/"+assetobjectid+".3.jpg");
				ps2.setTimestamp(9,new Timestamp(new java.util.Date().getTime()));
				ps2.setInt(10,4);
				ps2.execute();
				ps2.close();
			}
			catch(Exception e){
				System.out.println("Could not get image "+sImage);
			}
			sImage=rs.getString("view_est");
			try{
				saveImage(sImage, "c:/temp/images/0/"+assetobjectid+".4.jpg");
				ps2=conn.prepareStatement("insert into arch_documents(arch_document_serverid,arch_document_objectid,arch_document_udi,arch_document_title,arch_document_category,arch_document_date,arch_document_reference,arch_document_storagename,arch_document_updatetime,arch_document_updateid)"+
				" values(?,?,?,?,?,?,?,?,?,?)");
				ps2.setInt(1,1);
				int n=MedwanQuery.getInstance().getOpenclinicCounter("ARCH_DOCUMENTS");
				ps2.setInt(2,n);
				ps2.setString(3,n+"");
				ps2.setString(4,"Vue de l´est");
				ps2.setString(5,"asset");
				ps2.setTimestamp(6,new Timestamp(new java.util.Date().getTime()));
				ps2.setString(7,"asset.1."+assetobjectid);
				ps2.setString(8,"0/"+assetobjectid+".4.jpg");
				ps2.setTimestamp(9,new Timestamp(new java.util.Date().getTime()));
				ps2.setInt(10,4);
				ps2.execute();
				ps2.close();
			}
			catch(Exception e){
				System.out.println("Could not get image "+sImage);
			}
			sImage=rs.getString("view_west");
			try{
				saveImage(sImage, "c:/temp/images/0/"+assetobjectid+".5.jpg");
				ps2=conn.prepareStatement("insert into arch_documents(arch_document_serverid,arch_document_objectid,arch_document_udi,arch_document_title,arch_document_category,arch_document_date,arch_document_reference,arch_document_storagename,arch_document_updatetime,arch_document_updateid)"+
				" values(?,?,?,?,?,?,?,?,?,?)");
				ps2.setInt(1,1);
				int n=MedwanQuery.getInstance().getOpenclinicCounter("ARCH_DOCUMENTS");
				ps2.setInt(2,n);
				ps2.setString(3,n+"");
				ps2.setString(4,"Vue de l´ouest");
				ps2.setString(5,"asset");
				ps2.setTimestamp(6,new Timestamp(new java.util.Date().getTime()));
				ps2.setString(7,"asset.1."+assetobjectid);
				ps2.setString(8,"0/"+assetobjectid+".5.jpg");
				ps2.setTimestamp(9,new Timestamp(new java.util.Date().getTime()));
				ps2.setInt(10,4);
				ps2.execute();
				ps2.close();
			}
			catch(Exception e){
				System.out.println("Could not get image "+sImage);
			}
			sImage=rs.getString("degradations");
			try{
				saveImage(sImage, "c:/temp/images/0/"+assetobjectid+".6.jpg");
				ps2=conn.prepareStatement("insert into arch_documents(arch_document_serverid,arch_document_objectid,arch_document_udi,arch_document_title,arch_document_category,arch_document_date,arch_document_reference,arch_document_storagename,arch_document_updatetime,arch_document_updateid)"+
				" values(?,?,?,?,?,?,?,?,?,?)");
				ps2.setInt(1,1);
				int n=MedwanQuery.getInstance().getOpenclinicCounter("ARCH_DOCUMENTS");
				ps2.setInt(2,n);
				ps2.setString(3,n+"");
				ps2.setString(4,"Dégradations apparentes");
				ps2.setString(5,"asset");
				ps2.setTimestamp(6,new Timestamp(new java.util.Date().getTime()));
				ps2.setString(7,"asset.1."+assetobjectid);
				ps2.setString(8,"0/"+assetobjectid+".6.jpg");
				ps2.setTimestamp(9,new Timestamp(new java.util.Date().getTime()));
				ps2.setInt(10,4);
				ps2.execute();
				ps2.close();
			}
			catch(Exception e){
				System.out.println("Could not get image "+sImage);
			}
			sImage=rs.getString("fence_view");
			try{
				saveImage(sImage, "c:/temp/images/0/"+assetobjectid+".7.jpg");
				ps2=conn.prepareStatement("insert into arch_documents(arch_document_serverid,arch_document_objectid,arch_document_udi,arch_document_title,arch_document_category,arch_document_date,arch_document_reference,arch_document_storagename,arch_document_updatetime,arch_document_updateid)"+
				" values(?,?,?,?,?,?,?,?,?,?)");
				ps2.setInt(1,1);
				int n=MedwanQuery.getInstance().getOpenclinicCounter("ARCH_DOCUMENTS");
				ps2.setInt(2,n);
				ps2.setString(3,n+"");
				ps2.setString(4,"Vue de la clôture");
				ps2.setString(5,"asset");
				ps2.setTimestamp(6,new Timestamp(new java.util.Date().getTime()));
				ps2.setString(7,"asset.1."+assetobjectid);
				ps2.setString(8,"0/"+assetobjectid+".7.jpg");
				ps2.setTimestamp(9,new Timestamp(new java.util.Date().getTime()));
				ps2.setInt(10,4);
				ps2.execute();
				ps2.close();
			}
			catch(Exception e){
				System.out.println("Could not get image "+sImage);
			}
			sImage=rs.getString("exterior_view");
			try{
				saveImage(sImage, "c:/temp/images/0/"+assetobjectid+".8.jpg");
				ps2=conn.prepareStatement("insert into arch_documents(arch_document_serverid,arch_document_objectid,arch_document_udi,arch_document_title,arch_document_category,arch_document_date,arch_document_reference,arch_document_storagename,arch_document_updatetime,arch_document_updateid)"+
				" values(?,?,?,?,?,?,?,?,?,?)");
				ps2.setInt(1,1);
				int n=MedwanQuery.getInstance().getOpenclinicCounter("ARCH_DOCUMENTS");
				ps2.setInt(2,n);
				ps2.setString(3,n+"");
				ps2.setString(4,"Vue des aménagements extérieurs");
				ps2.setString(5,"asset");
				ps2.setTimestamp(6,new Timestamp(new java.util.Date().getTime()));
				ps2.setString(7,"asset.1."+assetobjectid);
				ps2.setString(8,"0/"+assetobjectid+".8.jpg");
				ps2.setTimestamp(9,new Timestamp(new java.util.Date().getTime()));
				ps2.setInt(10,4);
				ps2.execute();
				ps2.close();
			}
			catch(Exception e){
				System.out.println("Could not get image "+sImage);
			}
		}
		rs2.close();
		ps2.close();
	}
	rs.close();
	ps.close();
	conn.close();
	
%>