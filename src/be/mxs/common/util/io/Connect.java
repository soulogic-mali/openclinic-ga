package be.mxs.common.util.io;

import java.sql.*;

public class Connect {
	public static Connection getConnection(String sUrl) throws SQLException {
		return DriverManager.getConnection(sUrl);
	}
	
	public static String getConfigString(Connection conn, String sKey, String sDefault)  {
		String s = sDefault;
		try {
			PreparedStatement ps = conn.prepareStatement("select * from oc_config where oc_key=?");
			ps.setString(1, sKey);
			ResultSet rs = ps.executeQuery();
			if(rs.next()) {
				s=rs.getString("oc_value");
				if(s==null || s.length()==0) {
					s=sDefault;
				}
			}
			rs.close();
			ps.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return s;
	}
}
