package be.mxs.common.util.io;

import java.sql.ResultSet;
import java.sql.PreparedStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.text.SimpleDateFormat;
import java.sql.Timestamp;
import java.util.Date;
import be.openclinic.archiving.DicomUtils;
import be.openclinic.system.SH;

import java.io.File;
import be.mxs.common.util.db.MedwanQuery;
import uk.org.primrose.vendor.standalone.PrimroseLoader;

public class CompressDicom
{
    public static void main(final String[] args) {
        try {
            System.out.println("Database connection url: " + args[0]);
		    PrimroseLoader.load(args[0],true);
		    Connection conn=SH.getOpenClinicConnection();
            System.out.println("Database connected");
            final String SCANDIR_BASE = Connect.getConfigString(conn,"scanDirectoryMonitor_basePath", "/var/tomcat/webapps/openclinic/scan");
            System.out.println("SCANDIR_BASE = " + SCANDIR_BASE);
            final String SCANDIR_TO = Connect.getConfigString(conn,"scanDirectoryMonitor_dirTo", "to");
            int totalfiles = 0,cycles=0;
            conn.close();
            while (true) {
                int n = 0,totalbatch=0;
    		    conn =  SH.getOpenClinicConnection();
                System.out.println(cycles+++" - Running query....");
                PreparedStatement ps = conn.prepareStatement("select * from oc_pacs where oc_pacs_compresseddatetime is null limit 520");
                ResultSet rs = ps.executeQuery();
                System.out.println("Query executed");
                while (rs.next() && n++ < 500) {
                    String studyuid = rs.getString("oc_pacs_studyuid");
                    String series = rs.getString("oc_pacs_series");
                    String sequence = rs.getString("oc_pacs_sequence");
                    String filename = String.valueOf(SCANDIR_BASE) + "/" + SCANDIR_TO + "/" + rs.getString("oc_pacs_filename");
                    File file = new File(filename);
                    if(new java.util.Date().getTime()-file.lastModified()<3600*1000) {
                    	//File is too recent, skip it
                    	continue;
                    }
                    totalbatch++;
                    long decompressedsize = 0L;
                    if (file.exists()) {
                        decompressedsize = file.length();
                    }
                    else {
                    	System.out.println("File "+filename+" doesn't exist!");
                    }
                    if(decompressedsize<64000) {
                    	System.out.println("File "+filename+" smaller than 64K. Not worth compressing...");
                        PreparedStatement ps2 = conn.prepareStatement("update oc_pacs set oc_pacs_compresseddatetime=? where oc_pacs_studyuid=? and oc_pacs_series=? and oc_pacs_sequence=?");
                        ps2.setTimestamp(1, new Timestamp(new Date().getTime()));
                        ps2.setString(2, studyuid);
                        ps2.setString(3, series);
                        ps2.setString(4, sequence);
                        ps2.execute();
                        ps2.close();
                    	continue;
                    }
                    try {
                        if (decompressedsize > 0L && DicomUtils.compressDicomDefault(filename)) {
                            System.out.println(String.valueOf(totalfiles++) + ": " + filename + " compressed (gain = " + (decompressedsize - new File(filename).length()) / 1024L + " Kb - " + (decompressedsize - new File(filename).length()) * 100L / decompressedsize + "% compression)");
                            PreparedStatement ps2 = conn.prepareStatement("update oc_pacs set oc_pacs_compresseddatetime=? where oc_pacs_studyuid=? and oc_pacs_series=? and oc_pacs_sequence=?");
                            ps2.setTimestamp(1, new Timestamp(new Date().getTime()));
                            ps2.setString(2, studyuid);
                            ps2.setString(3, series);
                            ps2.setString(4, sequence);
                            ps2.execute();
                            ps2.close();
                        }
                        else {
                            System.out.println(String.valueOf(totalfiles++) + ": !!!!!!!ERROR!!!!!!! could not compress " + filename);
                            PreparedStatement ps2 = conn.prepareStatement("update oc_pacs set oc_pacs_compresseddatetime=? where oc_pacs_studyuid=? and oc_pacs_series=? and oc_pacs_sequence=?");
                            ps2.setTimestamp(1, new Timestamp(new SimpleDateFormat("dd/MM/yyyy").parse("01/01/1900").getTime()));
                            ps2.setString(2, studyuid);
                            ps2.setString(3, series);
                            ps2.setString(4, sequence);
                            ps2.execute();
                            ps2.close();
                        }
                    }
                    catch (Exception a) {
                        a.printStackTrace();
                        Thread.sleep(100L);
                    }
                }
                rs.close();
                ps.close();
                conn.close();
                if(totalbatch==0) {
                	Thread.sleep(10000L);
                }
                else {
                    Thread.sleep(1000L);
                }
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        System.exit(0);
    }
}
