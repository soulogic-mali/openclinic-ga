package be.mxs.common.util.io;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import be.mxs.common.util.db.MedwanQuery;
import be.openclinic.archiving.DicomUtils;
import uk.org.primrose.vendor.standalone.PrimroseLoader;

public class CompressDicom {

	public static void main(String[] args) {
		try {
			System.out.println("using primrose config: "+args[0]);
			PrimroseLoader.load(args[0], true);
			System.out.println("Primrose loaded");
			String SCANDIR_BASE = MedwanQuery.getInstance(false).getConfigString("scanDirectoryMonitor_basePath","/var/tomcat/webapps/openclinic/scan");
			System.out.println("SCANDIR_BASE = "+SCANDIR_BASE);
			String SCANDIR_TO   = MedwanQuery.getInstance(false).getConfigString("scanDirectoryMonitor_dirTo","to");
			int totalfiles = 0;
			while(true) {
				int n=0;
				System.out.println("Running query....");
				Connection conn = MedwanQuery.getInstance(false).getOpenclinicConnection();
				PreparedStatement ps = conn.prepareStatement("select * from oc_pacs where oc_pacs_compresseddatetime is null limit 520");
				ResultSet rs = ps.executeQuery();
				while(rs.next() && n++<500) {
					String studyuid = rs.getString("oc_pacs_studyuid");
					String series = rs.getString("oc_pacs_series");
					String sequence = rs.getString("oc_pacs_sequence");
					String filename = SCANDIR_BASE+"/"+SCANDIR_TO+"/"+rs.getString("oc_pacs_filename");
					java.io.File file = new java.io.File(filename);
					long decompressedsize=0;
					if(file.exists()) {
						decompressedsize=file.length();
					}
					try {
						if (decompressedsize>0 && DicomUtils.compressDicomDefault(filename)) {
							System.out.println(totalfiles+++": "+filename+" compressed (gain = "+(decompressedsize-new java.io.File(filename).length())/1024+" Kb - "+(decompressedsize-new java.io.File(filename).length())*100/decompressedsize+"% compression)");
							PreparedStatement ps2 = conn.prepareStatement("update oc_pacs set oc_pacs_compresseddatetime=? where oc_pacs_studyuid=? and oc_pacs_series=? and oc_pacs_sequence=?");
							ps2.setTimestamp(1, new java.sql.Timestamp(new java.util.Date().getTime()));
							ps2.setString(2, studyuid);
							ps2.setString(3, series);
							ps2.setString(4, sequence);
							ps2.execute();
							ps2.close();
						}
						else {
							System.out.println(totalfiles+++": !!!!!!!ERROR!!!!!!! could not compress "+filename);
							PreparedStatement ps2 = conn.prepareStatement("update oc_pacs set oc_pacs_compresseddatetime=? where oc_pacs_studyuid=? and oc_pacs_series=? and oc_pacs_sequence=?");
							ps2.setTimestamp(1, new java.sql.Timestamp(new java.text.SimpleDateFormat("dd/MM/yyyy").parse("01/01/1900").getTime()));
							ps2.setString(2, studyuid);
							ps2.setString(3, series);
							ps2.setString(4, sequence);
							ps2.execute();
							ps2.close();
						}
					}
					catch(Exception a) {
						a.printStackTrace();
						Thread.sleep(100);
					}
				}
				rs.close();
				ps.close();
				conn.close();
				if(n<500) {
					break;
				}
				Thread.sleep(1000);
			}
			System.exit(0);
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}

}
