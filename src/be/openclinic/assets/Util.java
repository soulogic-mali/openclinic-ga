package be.openclinic.assets;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.SortedMap;
import java.util.SortedSet;
import java.util.TreeMap;
import java.util.TreeSet;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;
import net.admin.Service;

public class Util {
	
	public static int countAssets(Hashtable<String,String> parameters) {
		int count = 0;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try {
			String sSql="select count(*) total from oc_assets where 1=1";
			Enumeration<String> pars = parameters.keys();
			while(pars.hasMoreElements()) {
				String key = pars.nextElement();
				String value = parameters.get(key);
				if(value.split(";")[0].equalsIgnoreCase("in")) {
					sSql+=" and "+key+" in ("+value.split(";")[1]+")";
				}
				else if(value.split(";")[0].equalsIgnoreCase("like")) {
					sSql+=" and "+key+" like "+value.split(";")[1];
				}
				else if(value.split(";")[0].equalsIgnoreCase("notlike")) {
					sSql+=" and "+key+" NOT like "+value.split(";")[1];
				}
				else if(value.split(";")[0].equalsIgnoreCase("equals")) {
					sSql+=" and "+key+" = "+value.split(";")[1];
				}
				else if(value.split(";")[0].equalsIgnoreCase("notequals")) {
					sSql+=" and NOT "+key+" = "+value.split(";")[1];
				}
				else if(value.split(";")[0].equalsIgnoreCase("copy")) {
					sSql+=" and "+key+value.split(";")[1];
				}
			}
			PreparedStatement ps = conn.prepareStatement(sSql);
			ResultSet rs = ps.executeQuery();
			if(rs.next()) {
				count=rs.getInt("total");
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return count;
	}
	
	public static int countMaintenanceOperations(Hashtable<String,String> parameters) {
		int count = 0;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try {
			String sSql="select count(distinct oc_maintenanceoperation_objectid) total from oc_assets a,oc_maintenanceplans p,oc_maintenanceoperations o where a.oc_asset_objectid=replace(oc_maintenanceplan_assetuid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','') and oc_maintenanceplan_objectid=replace(oc_maintenanceoperation_maintenanceplanuid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','')";
			Enumeration<String> pars = parameters.keys();
			while(pars.hasMoreElements()) {
				String key = pars.nextElement();
				String value = parameters.get(key);
				if(value.split(";")[0].equalsIgnoreCase("in")) {
					sSql+=" and "+key+" in ("+value.split(";")[1]+")";
				}
				else if(value.split(";")[0].equalsIgnoreCase("like")) {
					sSql+=" and "+key+" like "+value.split(";")[1];
				}
				else if(value.split(";")[0].equalsIgnoreCase("notlike")) {
					sSql+=" and "+key+" NOT like "+value.split(";")[1];
				}
				else if(value.split(";")[0].equalsIgnoreCase("equals")) {
					sSql+=" and "+key+" = "+value.split(";")[1];
				}
				else if(value.split(";")[0].equalsIgnoreCase("notequals")) {
					sSql+=" and NOT "+key+" = "+value.split(";")[1];
				}
				else if(value.split(";")[0].equalsIgnoreCase("copy")) {
					sSql+=" and "+key+value.split(";")[1];
				}
			}
			System.out.println(sSql);
			PreparedStatement ps = conn.prepareStatement(sSql);
			ResultSet rs = ps.executeQuery();
			if(rs.next()) {
				count=rs.getInt("total");
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return count;
	}
	
	public static String analyzeMaintenanceOperations(Hashtable<String,String> parameters,String returnValue) {
		String s="";
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try {
			String sSql="select "+returnValue+" total from oc_assets a,oc_maintenanceplans p,oc_maintenanceoperations o where a.oc_asset_objectid=replace(oc_maintenanceplan_assetuid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','') and oc_maintenanceplan_objectid=replace(oc_maintenanceoperation_maintenanceplanuid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','')";
			Enumeration<String> pars = parameters.keys();
			while(pars.hasMoreElements()) {
				String key = pars.nextElement();
				String value = parameters.get(key);
				if(value.split(";")[0].equalsIgnoreCase("in")) {
					sSql+=" and "+key+" in ("+value.split(";")[1]+")";
				}
				else if(value.split(";")[0].equalsIgnoreCase("like")) {
					sSql+=" and "+key+" like "+value.split(";")[1];
				}
				else if(value.split(";")[0].equalsIgnoreCase("notlike")) {
					sSql+=" and "+key+" NOT like "+value.split(";")[1];
				}
				else if(value.split(";")[0].equalsIgnoreCase("equals")) {
					sSql+=" and "+key+" = "+value.split(";")[1];
				}
				else if(value.split(";")[0].equalsIgnoreCase("notequals")) {
					sSql+=" and NOT "+key+" = "+value.split(";")[1];
				}
				else if(value.split(";")[0].equalsIgnoreCase("copy")) {
					sSql+=" and "+key+value.split(";")[1];
				}
			}
			System.out.println(sSql);
			PreparedStatement ps = conn.prepareStatement(sSql);
			ResultSet rs = ps.executeQuery();
			if(rs.next()) {
				s=rs.getString("total");
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return s;
	}
	
	public static SortedMap getNormsForService(String serviceid){
		SortedMap norms = new TreeMap();
		//First check which kind of structure we have
		Connection conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
		try{
			Service service = Service.getService(serviceid);
			if(service!=null && ScreenHelper.checkString(service.costcenter).length()>0 ){
				PreparedStatement ps = conn.prepareStatement("select * from oc_standards where structure=? and quantity>0 order by nomenclature");
				ps.setString(1, service.costcenter);
				ResultSet rs = ps.executeQuery();
				while(rs.next()){
					double total = 0, nonfunctional=0;
					String[] noms = rs.getString("nomenclature").split(";");
					double quantity = rs.getDouble("quantity");
					for(int n=0;n<noms.length;n++){
						String nomenclature = noms[n];
						PreparedStatement ps2 = conn.prepareStatement("select count(*) total from oc_assets where (oc_asset_service=? OR oc_asset_service like ?) and (oc_asset_nomenclature=? or oc_asset_nomenclature like ?) and (oc_asset_saledate is null OR oc_asset_saledate>?) and (oc_asset_comment7 is null or oc_asset_comment7='' or oc_asset_comment7<3)");
						ps2.setString(1, serviceid);
						ps2.setString(2, serviceid+".%");
						ps2.setString(3,nomenclature);
						ps2.setString(4,nomenclature+".%");
						ps2.setTimestamp(5, new java.sql.Timestamp(new java.util.Date().getTime()));
						ResultSet rs2 = ps2.executeQuery();
						if(rs2.next()){
							total+=rs2.getInt("total");
						}
						rs2.close();
						ps2.close();
						ps2 = conn.prepareStatement("select count(*) total from oc_assets where (oc_asset_service=? OR oc_asset_service like ?) and (oc_asset_nomenclature=? or oc_asset_nomenclature like ?) and (oc_asset_saledate is null OR oc_asset_saledate>?) and oc_asset_comment7='3'");
						ps2.setString(1, serviceid);
						ps2.setString(2, serviceid+".%");
						ps2.setString(3,nomenclature);
						ps2.setString(4,nomenclature+".%");
						ps2.setTimestamp(5, new java.sql.Timestamp(new java.util.Date().getTime()));
						rs2 = ps2.executeQuery();
						if(rs2.next()){
							nonfunctional+=rs2.getInt("total");
						}
						rs2.close();
						ps2.close();
					}
					norms.put(noms[0],quantity+";"+total+";"+nonfunctional);
				}
				rs.close();
				ps.close();
				conn.close();
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return norms;
	}
	
	public static SortedMap getServicesForNorm(String structure,String nomenclature){
		SortedMap norms = new TreeMap();
		Connection conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
		Connection conna = MedwanQuery.getInstance().getLongAdminConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select * from oc_standards where structure=? and nomenclature=?");
			ps.setString(1, structure);
			ps.setString(2,nomenclature);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				double quantity = rs.getDouble("quantity");
				rs.close();
				ps.close();
				ps=conna.prepareStatement("select * from services where costcenter=? order by serviceid");
				ps.setString(1, structure);
				rs=ps.executeQuery();
				while(rs.next()){
					String serviceid = rs.getString("serviceid");
					double total = 0, nonfunctional=0;
					PreparedStatement ps2 = conn.prepareStatement("select count(*) from oc_assets where (oc_asset_service=? or oc_asset_service like ?) and (oc_asset_nomenclature=? or oc_asset_nomenclature like ?) and (oc_asset_saledate is null OR oc_asset_saledate>?) and (oc_asset_comment7 is null or oc_asset_comment7='' or oc_asset_comment7<3)");
					ps2.setString(1, serviceid);
					ps2.setString(2, serviceid+".%");
					ps2.setString(3, nomenclature);
					ps2.setString(4, nomenclature+".%");
					ps2.setTimestamp(5, new java.sql.Timestamp(new java.util.Date().getTime()));
					ResultSet rs2 = ps2.executeQuery();
					if(rs2.next()){
						total = rs2.getDouble("total");
					}
					rs2.close();
					ps2.close();
					ps2 = conn.prepareStatement("select count(*) from oc_assets where (oc_asset_service=? or oc_asset_service like ?) and (oc_asset_nomenclature=? or oc_asset_nomenclature like ?) and (oc_asset_saledate is null OR oc_asset_saledate>?) and oc_asset_comment7='3'");
					ps2.setString(1, serviceid);
					ps2.setString(2, serviceid+".%");
					ps2.setString(3, nomenclature);
					ps2.setString(4, nomenclature+".%");
					ps2.setTimestamp(5, new java.sql.Timestamp(new java.util.Date().getTime()));
					rs2 = ps2.executeQuery();
					if(rs2.next()){
						nonfunctional = rs2.getDouble("total");
					}
					rs2.close();
					ps2.close();
					norms.put(serviceid, quantity+";"+total+";"+nonfunctional);
				}
			}
			rs.close();
			ps.close();
			conn.close();
			conna.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return norms;
	}

}
