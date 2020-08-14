<%@page import="java.io.*,be.openclinic.assets.*"%>
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
	
	public void checkItem(ResultSet r,String serviceid,String columns,String nomenclature,String name){
		//First we try to find the surface of the infrastructure item, if it is <=0, then discard the item
		double surface = 0;		
		String[] c = columns.split(";");
		for(int n=0;n<c.length;n++){
			try{
				surface+=r.getDouble(c[n]);
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		if(surface>0){
			System.out.println("Found "+surface+" m2 of "+name+" for "+serviceid);
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			try{
				Asset asset = null;
				PreparedStatement ps = conn.prepareStatement("select * from oc_assets where oc_asset_service=? and oc_asset_nomenclature=?");
				ps.setString(1,serviceid);
				ps.setString(2,nomenclature);
				ResultSet rs = ps.executeQuery();
				if(rs.next()){
					System.out.println("Updating existing asset");
					//This asset already exists, we are going to update it
					asset = Asset.get(rs.getString("oc_asset_serverid")+"."+rs.getString("oc_asset_objectid"));
					asset.setQuantity(surface);
				}
				else{
					System.out.println("Creating new asset");
					//This asset doesn't exist yet, we need to create it
					asset = new Asset();
					asset.setUid("-1");
					asset.setCode(serviceid+"."+nomenclature);
					asset.setDescription(name);
					asset.setQuantity(surface);
					asset.setServiceuid(serviceid);
					asset.setNomenclature(nomenclature);
					asset.setComment12(r.getString("fabrication"));
				}
				asset.store("4");
				rs.close();
				ps.close();
				conn.close();
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}		
	}
%>
<%
	int i=0;
	Connection conn = MedwanQuery.getInstance().getLongAdminConnection();
	PreparedStatement ps = conn.prepareStatement("select * from burundi where serviceid is not null");
	ResultSet rs = ps.executeQuery();
	while (rs.next()){
		i++;
		String serviceid=rs.getString("serviceid");
		System.out.println(i+". Checking serviceid "+serviceid);
		checkItem(rs,serviceid,"cds_1","I.CDS.1","Locaux administratifs");
		checkItem(rs,serviceid,"cds_c_1","I.CDS.C.1","Promotion de santé");
		checkItem(rs,serviceid,"cds_c_2","I.CDS.C.2","Soins ambulatoires");
		checkItem(rs,serviceid,"cds_c_3","I.CDS.C.3","Maternité");
		checkItem(rs,serviceid,"cds_x_4;cds_x_4_a","I.CDS.X.4","Hébergement	");
		checkItem(rs,serviceid,"cds_x_5;cds_x_5_a;cds_x_5_b;cds_x_5_c;cds_x_5_d;cds_x_5_e;cds_x_5_f;cds_x_5_g","I.CDS.X.5","Latrines");
		checkItem(rs,serviceid,"cds_x_6","I.CDS.X.6","Morgue");
		checkItem(rs,serviceid,"cds_x_7","I.CDS.X.7","Cuisine");
		checkItem(rs,serviceid,"cds_x_8","I.CDS.X.8","Incinérateur");
		checkItem(rs,serviceid,"cds_x_14","I.CDS.X.14","Passages");
		checkItem(rs,serviceid,"cds_x_15","I.CDS.X.15","Buanderie");
		checkItem(rs,serviceid,"cds_x_21;cds_x_21_a;cds_x_21_b;cds_x_21_c","I.CDS.X.21","Logement responsable");
		checkItem(rs,serviceid,"hd_a_1","I.HD.A.1","Accueil du public");
		checkItem(rs,serviceid,"hd_a_3","I.HD.A.3","Administration");
		checkItem(rs,serviceid,"hd_c_4","I.HD.C.4","Radiologie");
		checkItem(rs,serviceid,"hd_c_5","I.HD.C.5","Laboratoire");
		checkItem(rs,serviceid,"hd_c_6","I.HD.C.6","Pharmacie");
		checkItem(rs,serviceid,"hd_c_7","I.HD.C.7","Echographie");
		checkItem(rs,serviceid,"hd_c_8","I.HD.C.8","Urgences");
		checkItem(rs,serviceid,"hd_c_9","I.HD.C.9","Bloc opératoire");
		checkItem(rs,serviceid,"hd_c_10","I.HD.C.10","Bloc obstétrical");
		checkItem(rs,serviceid,"hd_c_2","I.HD.C.2","Consultation externe");
		checkItem(rs,serviceid,"hd_c_12","I.HD.C.11.1","Hospitalisation médecine interne");
		checkItem(rs,serviceid,"hd_c_13","I.HD.C.11.2","Hospitalisation chirurgie");
		checkItem(rs,serviceid,"hd_c_14","I.HD.C.11.3","Hospitalisation pédiatrie");
		checkItem(rs,serviceid,"hd_c_15","I.HD.C.11.4","Hospitalisation gynécologie et obstétrique");
		checkItem(rs,serviceid,"hd_n_24","I.HD.N.24","Hospitalisation nutrition");
		checkItem(rs,serviceid,"hd_n_25","I.HD.N.25","Cuisine nutrition");
		checkItem(rs,serviceid,"hd_t_38","I.HD.T.38","Local de maintenance technique");
		checkItem(rs,serviceid,"hd_x_11","I.HD.X.11","Stérilisation");
		checkItem(rs,serviceid,"hd_x_17","I.HD.X.17","Cafétéria");
		checkItem(rs,serviceid,"hd_x_18","I.HD.X.18","Buanderie");
		checkItem(rs,serviceid,"hd_x_19","I.HD.X.19","Morgue");
		checkItem(rs,serviceid,"hd_x_26;hd_x_26_a;hd_x_26_b;hd_x_26_c","I.HD.X.26","Logements");
		checkItem(rs,serviceid,"hd_x_27;hd_x_27_a;hd_x_27_b;hd_x_27_c","I.HD.X.27","Logements annexes");
	}
	rs.close();
	ps.close();
	conn.close();
%>