package net.admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import be.mxs.common.util.db.MedwanQuery;

public class HealthStructure {
	public static Vector getRegions(){
		Vector regions = new Vector();
		try{
			Connection conn = MedwanQuery.getInstance().getAdminConnection();
			PreparedStatement ps = conn.prepareStatement("select distinct OC_STRUCTURE_REGION from OC_STRUCTURES ORDER BY OC_STRUCTURE_REGION");
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				regions.add(rs.getString("OC_STRUCTURE_REGION"));
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return regions;
	}

	public static Vector getDistricts(String region){
		Vector districts = new Vector();
		try{
			Connection conn = MedwanQuery.getInstance().getAdminConnection();
			PreparedStatement ps = conn.prepareStatement("select distinct OC_STRUCTURE_DISTRICT from OC_STRUCTURES where OC_STRUCTURE_REGION=? ORDER BY OC_STRUCTURE_DISTRICT");
			ps.setString(1, region);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				districts.add(rs.getString("OC_STRUCTURE_DISTRICT"));
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return districts;
	}

	public static Vector getPosts(String district){
		Vector posts = new Vector();
		try{
			Connection conn = MedwanQuery.getInstance().getAdminConnection();
			PreparedStatement ps = conn.prepareStatement("select distinct OC_STRUCTURE_HEALTHPOST from OC_STRUCTURES where OC_STRUCTURE_DISTRICT=? ORDER BY OC_STRUCTURE_HEALTHPOST");
			ps.setString(1, district);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				posts.add(rs.getString("OC_STRUCTURE_HEALTHPOST"));
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return posts;
	}

	public static Vector getVillages(String post){
		Vector villages = new Vector();
		try{
			Connection conn = MedwanQuery.getInstance().getAdminConnection();
			PreparedStatement ps = conn.prepareStatement("select distinct OC_STRUCTURE_VILLAGE from OC_STRUCTURES where OC_STRUCTURE_HEALTHPOST=? ORDER BY OC_STRUCTURE_VILLAGE");
			ps.setString(1, post);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				villages.add(rs.getString("OC_STRUCTURE_VILLAGE"));
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return villages;
	}

}
