package be.mxs.common.util.system;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Vector;

import be.mxs.common.util.db.MedwanQuery;

public class RxNormInteraction {
	
	public static Vector getInteractions(String key){
		Vector pointers = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		try{
			ps=conn.prepareStatement("select OC_RXNORMINTERACTION_VALUE from OC_RXNORMINTERACTION where OC_RXNORMINTERACTION_KEY=? and OC_RXNORMINTERACTION_UPDATETIME>?  order by OC_RXNORMINTERACTION_VALUE");
			ps.setString(1, key);
			long day = 24*60*60000;
			ps.setTimestamp(2, new java.sql.Timestamp(new java.util.Date().getTime()-day*MedwanQuery.getInstance().getConfigInt("RxNormInteractionValidity",90)));
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				pointers.add(rs.getString("OC_RXNORMINTERACTION_VALUE"));
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return pointers;
	}
	
	public static Vector getFullInteractions(String key){
		Vector pointers = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		try{
			ps=conn.prepareStatement("select OC_RXNORMINTERACTION_VALUE,OC_RXNORMINTERACTION_UPDATETIME from OC_RXNORMINTERACTIONS where OC_RXNORMINTERACTION_KEY=? and OC_RXNORMINTERACTION_UPDATETIME>? order by OC_RXNORMINTERACTION_VALUE");
			ps.setString(1, key);
			long day = 24*60*60000;
			ps.setTimestamp(2, new java.sql.Timestamp(new java.util.Date().getTime()-day*MedwanQuery.getInstance().getConfigInt("RxNormInteractionValidity",90)));
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				pointers.add(rs.getString("OC_RXNORMINTERACTION_VALUE")+";"+new SimpleDateFormat("yyyyMMddHHmmSSsss").format(rs.getTimestamp("OC_RXNORMINTERACTION_UPDATETIME")));
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return pointers;
	}
	
	public static String getInteraction(String key){
		String pointer = null;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		try{
			ps=conn.prepareStatement("select OC_RXNORMINTERACTION_VALUE from OC_RXNORMINTERACTIONS where OC_RXNORMINTERACTION_KEY=? and OC_RXNORMINTERACTION_UPDATETIME>?");
			ps.setString(1, key);
			long day = 24*60*60000;
			ps.setTimestamp(2, new java.sql.Timestamp(new java.util.Date().getTime()-day*MedwanQuery.getInstance().getConfigInt("RxNormInteractionValidity",90)));
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				pointer=rs.getString("OC_RXNORMINTERACTION_VALUE");
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return pointer;
	}
	
	public static String getLastInteraction(String key){
		String pointer = null;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		try{
			ps=conn.prepareStatement("select OC_RXNORMINTERACTION_VALUE from OC_RXNORMINTERACTIONS where OC_RXNORMINTERACTION_KEY like ?  and OC_RXNORMINTERACTION_UPDATETIME>? order by OC_RXNORMINTERACTION_UPDATETIME DESC");
			ps.setString(1, key+"%");
			long day = 24*60*60000;
			ps.setTimestamp(2, new java.sql.Timestamp(new java.util.Date().getTime()-day*MedwanQuery.getInstance().getConfigInt("RxNormInteractionValidity",90)));
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				pointer=rs.getString("OC_RXNORMINTERACTION_VALUE");
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return pointer;
	}
	
	public static Vector getInteractions(String key,java.util.Date start, java.util.Date end){
		Vector pointers = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		try{
			ps=conn.prepareStatement("select OC_RXNORMINTERACTION_VALUE from OC_RXNORMINTERACTIONS where OC_RXNORMINTERACTION_KEY=? and OC_RXNORMINTERACTION_UPDATETIME between ? and ? order by OC_RXNORMINTERACTION_VALUE");
			ps.setString(1, key);
			ps.setTimestamp(2, new java.sql.Timestamp(start.getTime()));
			ps.setTimestamp(3, new java.sql.Timestamp(end.getTime()));
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				pointers.add(rs.getString("OC_RXNORMINTERACTION_VALUE"));
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return pointers;
	}
	
	public static Vector getLooseInteractions(String key,java.util.Date start, java.util.Date end){
		Vector pointers = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		try{
			ps=conn.prepareStatement("select OC_RXNORMINTERACTION_VALUE from OC_RXNORMINTERACTIONS where OC_RXNORMINTERACTION_KEY like ? and OC_RXNORMINTERACTION_UPDATETIME between ? and ? order by OC_RXNORMINTERACTION_VALUE");
			ps.setString(1, key+"%");
			ps.setTimestamp(2, new java.sql.Timestamp(start.getTime()));
			ps.setTimestamp(3, new java.sql.Timestamp(end.getTime()));
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				pointers.add(rs.getString("OC_RXNORMINTERACTION_VALUE"));
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return pointers;
	}
	
	public static void deleteInteractions(String key){
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		try{
			ps=conn.prepareStatement("DELETE from OC_RXNORMINTERACTIONS where OC_RXNORMINTERACTION_KEY=?");
			ps.setString(1, key);
			ps.execute();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public static void deleteLooseInteractions(String key){
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		try{
			ps=conn.prepareStatement("DELETE from OC_RXNORMINTERACTIONS where OC_RXNORMINTERACTION_KEY like ?");
			ps.setString(1, key+"%");
			ps.execute();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public static void storeInteraction(String key,String value){
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		try{
			ps=conn.prepareStatement("INSERT INTO OC_RXNORMINTERACTIONS(OC_RXNORMINTERACTION_KEY,OC_RXNORMINTERACTION_VALUE,OC_RXNORMINTERACTION_UPDATETIME) values(?,?,?)");
			ps.setString(1, key);
			ps.setString(2, value.replaceAll("&#39;", "´"));
			ps.setTimestamp(3, new java.sql.Timestamp(new java.util.Date().getTime()));
			ps.execute();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public static void storeInteraction(String key,String value,java.util.Date updatetime){
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		try{
			ps=conn.prepareStatement("INSERT INTO OC_RXNORMINTERACTIONS(OC_RXNORMINTERACTION_KEY,OC_RXNORMINTERACTION_VALUE,OC_RXNORMINTERACTION_UPDATETIME) values(?,?,?)");
			ps.setString(1, key);
			ps.setString(2, value.replaceAll("&#39;", "´"));
			ps.setTimestamp(3, new java.sql.Timestamp(updatetime.getTime()));
			ps.execute();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public static void storeUniqueInteraction(String key,String value,java.util.Date updatetime){
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		try{
			ps=conn.prepareStatement("select * from OC_RXNORMINTERACTIONS where OC_RXNORMINTERACTION_KEY=? and OC_RXNORMINTERACTION_VALUE=?");
			ps.setString(1, key);
			ps.setString(2, value);
			ResultSet rs = ps.executeQuery();
			if(!rs.next()){
				rs.close();
				ps.close();
				ps=conn.prepareStatement("INSERT INTO OC_RXNORMINTERACTIONS(OC_RXNORMINTERACTION_KEY,OC_RXNORMINTERACTION_VALUE,OC_RXNORMINTERACTION_UPDATETIME) values(?,?,?)");
				ps.setString(1, key);
				ps.setString(2, value.replaceAll("&#39;", "´"));
				ps.setTimestamp(3, new java.sql.Timestamp(updatetime.getTime()));
				ps.execute();
				ps.close();
			}
			else {
				rs.close();
				ps.close();
			}
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	
}
