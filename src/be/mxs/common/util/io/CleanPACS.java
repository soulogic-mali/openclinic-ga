package be.mxs.common.util.io;

import java.io.File;
import java.io.IOException;
import java.lang.management.ManagementFactory;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import be.mxs.common.util.db.MedwanQuery;
import uk.org.primrose.GeneralException;
import uk.org.primrose.vendor.standalone.PrimroseLoader;

public class CleanPACS {

	public static void main(String[] args) throws GeneralException, IOException, SQLException {
		String processid=ManagementFactory.getRuntimeMXBean().getName();
		System.out.println(processid+" - Loading primrose configuration "+args[0]);
		try {
			PrimroseLoader.load(args[0], true);
			System.out.println(processid+" - Primrose loaded");
		}
		catch(Exception e) {
			System.out.println(processid+" - Error - Closing system");
			System.exit(0);
		}
		try {
			MedwanQuery.getInstance(false);
			System.out.println(processid+" - MedwanQuery loaded");
		}
		catch(Exception e) {
			System.out.println(processid+" - Error - Closing system");
			System.exit(0);
		}
		String path = MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_basePath", "/var/tomcat/webapps/openclinic/scan")+"/"+MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirTo ", "to");
		int linecounter=0;
		int totalrecords=0;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("select count(*) total from oc_pacs_double where updated is null");
		ResultSet rs = ps.executeQuery();
		if(rs.next()) {
			totalrecords=rs.getInt("total");
		}
		rs.close();
		ps.close();
		conn.close();
		while(true) {
			conn = MedwanQuery.getInstance().getOpenclinicConnection();
			ps = conn.prepareStatement("select * from oc_pacs_double where updated is null");
			rs = ps.executeQuery();
			int n=0;
			while(rs.next() && n++<3000) {
				linecounter++;
				String studyuid = rs.getString("oc_pacs_studyuid");
				String seriesid = rs.getString("oc_pacs_series");
				String sequenceid= rs.getString("oc_pacs_sequence");
				PreparedStatement ps2 = conn.prepareStatement("select * from oc_pacs where oc_pacs_studyuid=? and oc_pacs_series=? and oc_pacs_sequence=?");
				ps2.setString(1, studyuid);
				ps2.setString(2, seriesid);
				ps2.setString(3, sequenceid);
				ResultSet rs2 = ps2.executeQuery();
				int count = 0;
				while(rs2.next()) {
					if(count==0) {
						//This is the first image. Keep it if the file exists
						String filename = rs2.getString("oc_pacs_filename");
						System.out.println(linecounter+"/"+totalrecords+" - Checking file "+path+"/"+filename);
						File file = new File(path+"/"+filename);
						if(file.exists()) {
							System.out.println(linecounter+"/"+totalrecords+" - The file exists. This is the first existing file, so skip it");
							count++;
						}
						else {
							System.out.println(linecounter+"/"+totalrecords+" - he file "+filename+" does not exist. Only remove the record from oc_pacs.");
							PreparedStatement ps3 = conn.prepareStatement("delete from oc_pacs where oc_pacs_studyuid=? and oc_pacs_series=? and oc_pacs_sequence=? and oc_pacs_filename=?");
							ps3.setString(1, studyuid);
							ps3.setString(2, seriesid);
							ps3.setString(3, sequenceid);
							ps3.setString(4, filename);
							ps3.execute();
							ps3.close();
						}
					}
					else {
						String filename = rs2.getString("oc_pacs_filename");
						System.out.println(linecounter+"/"+totalrecords+" - Checking file "+path+"/"+filename);
						File file = new File(path+"/"+filename);
						if(file.exists()) {
							System.out.println(linecounter+"/"+totalrecords+" - This is existing file number "+(count+1)+". Delete it and remove the record from oc_pacs");
							file.delete();
						}
						else {
							System.out.println(linecounter+"/"+totalrecords+" - The file "+filename+" does not exist. Only remove the record from oc_pacs.");
						}
						PreparedStatement ps3 = conn.prepareStatement("delete from oc_pacs where oc_pacs_studyuid=? and oc_pacs_series=? and oc_pacs_sequence=? and oc_pacs_filename=?");
						ps3.setString(1, studyuid);
						ps3.setString(2, seriesid);
						ps3.setString(3, sequenceid);
						ps3.setString(4, filename);
						ps3.execute();
						ps3.close();
						count++;
					}
				}
				rs2.close();
				ps2.close();
				//The full list of double files has been treated. Close the double record.
				System.out.println(linecounter+"/"+totalrecords+" - Setting update field for setudyuid "+studyuid+" - series "+seriesid+" - sequence "+sequenceid);
				ps2 = conn.prepareStatement("update oc_pacs_double set updated=? where oc_pacs_studyuid=? and oc_pacs_series=? and oc_pacs_sequence=?");
				ps2.setTimestamp(1, new java.sql.Timestamp(new java.util.Date().getTime()));
				ps2.setString(2, studyuid);
				ps2.setString(3, seriesid);
				ps2.setString(4, sequenceid);
				ps2.execute();
				ps2.close();
			}
			rs.close();
			ps.close();
			conn.close();
			if(n<3000) {
				break;
			}
		}
	}

}
