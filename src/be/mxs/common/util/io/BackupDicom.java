package be.mxs.common.util.io;

import java.io.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.apache.commons.io.FileUtils;

import be.mxs.common.util.db.MedwanQuery;
import be.openclinic.archiving.DicomUtils;
import uk.org.primrose.vendor.standalone.PrimroseLoader;

public class BackupDicom {

	public static void main(String[] args) {
		try {
			System.out.println("using primrose config: "+args[0]);
			PrimroseLoader.load(args[0], true);
			System.out.println("Primrose loaded");
			String destinationdir = args[1];
			System.out.println("Destination folder = "+destinationdir);
			if(!new File(destinationdir).exists()) {
				System.out.println("Destination folder does not exist");
				System.exit(0);
			}
			String SCANDIR_BASE = MedwanQuery.getInstance(false).getConfigString("scanDirectoryMonitor_basePath","/var/tomcat/webapps/openclinic/scan");
			System.out.println("SCANDIR_BASE = "+SCANDIR_BASE);
			String SCANDIR_TO   = MedwanQuery.getInstance(false).getConfigString("scanDirectoryMonitor_dirTo","to");
			int totalfiles = 0, nonexistingfiles=0,existingfiles=0;
			while(true) {
				int n=0;
				System.out.print("Running query");
				Connection conn = MedwanQuery.getInstance(false).getOpenclinicConnection();
				PreparedStatement ps = conn.prepareStatement("select * from oc_pacs where oc_pacs_compresseddatetime is null limit 1020");
				ResultSet rs = ps.executeQuery();
				while(rs.next() && n++<1000) {
					String studyuid = rs.getString("oc_pacs_studyuid");
					String series = rs.getString("oc_pacs_series");
					String sequence = rs.getString("oc_pacs_sequence");
					String filename = SCANDIR_BASE+"/"+SCANDIR_TO+"/"+rs.getString("oc_pacs_filename");
					java.io.File file = new java.io.File(filename);
					PreparedStatement ps2 = conn.prepareStatement("update oc_pacs set oc_pacs_compresseddatetime=? where oc_pacs_studyuid=? and oc_pacs_series=? and oc_pacs_sequence=?");
					ps2.setTimestamp(1, new java.sql.Timestamp(new java.text.SimpleDateFormat("dd/MM/yyyy").parse("01/01/1900").getTime()));
					if(file.exists()) {
						try {
							File destFile = new File(destinationdir+"/"+SCANDIR_TO+"/"+rs.getString("oc_pacs_filename"));
							if(!destFile.exists()) {
								FileUtils.forceMkdirParent(destFile);
								FileUtils.copyFile(file, destFile,true);
								totalfiles++;
							}
							else {
								existingfiles++;
							}
							ps2.setTimestamp(1, new java.sql.Timestamp(new java.util.Date().getTime()));
						}
						catch(Exception f) {
							f.printStackTrace();
							nonexistingfiles++;
						}
					}
					else {
						nonexistingfiles++;
					}
					ps2.setString(2, studyuid);
					ps2.setString(3, series);
					ps2.setString(4, sequence);
					ps2.execute();
					ps2.close();
					if(n%100==0) {
						System.out.print(".");
						if(n%1000==0) {
							System.out.println("");
						}
					}
					if(totalfiles>0 && totalfiles%1000==0) {
						System.out.println("\n"+totalfiles+" files backed up to "+destinationdir+" ("+filename+")");
					}
					if(nonexistingfiles>0 && nonexistingfiles%1000==0) {
						System.out.println("\n"+nonexistingfiles+" missing files detected ("+filename+")");
					}
					if(existingfiles>0 && existingfiles%1000==0) {
						System.out.println("\n"+existingfiles+" existing files detected ("+filename+")");
					}
				}
				rs.close();
				ps.close();
				conn.close();
				if(n<1000) {
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
