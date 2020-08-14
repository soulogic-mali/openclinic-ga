package be.mxs.common.util.io;

import java.io.File;
import java.io.FileFilter;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Iterator;

import org.apache.commons.io.FileUtils;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import be.mxs.common.util.db.MedwanQuery;

public class CheckSAPDTWRun {

	public static void main(String[] args) {
		try{
            SAXReader reader = new SAXReader(false);
			Document document = reader.read(new URL(args[0]));
			Element root = document.getRootElement();
			Element config = root.element("config");
			String errorlog = config.elementText("errorlog");
			String successlog = config.elementText("successlog");
			String dtwdb = config.elementText("dtwdb");
			Class.forName("net.ucanaccess.jdbc.UcanaccessDriver");
		    Connection con = DriverManager.getConnection("jdbc:ucanaccess://"+dtwdb,"","");
		    System.out.println("Con="+con);
		    PreparedStatement ps = con.prepareStatement("select * from OLOG order by LogID desc");
		    ResultSet rs = ps.executeQuery();
		    if(rs.next()){
		    	String logid=rs.getString("LogID");
				Iterator queues = root.elementIterator("queue");
				while(queues.hasNext()){
					Element queue = (Element)queues.next();
					if(queue.attributeValue("type")!=null && queue.attributeValue("type").equalsIgnoreCase("AR_INV")){
						String source = queue.attributeValue("source");
						String destination = queue.attributeValue("destination");
				    	String error=rs.getString("ErrorFilePath");
				    	if(error==null||error.trim().length()==0){
				    		//No error, move active file to successful processing log
							FileUtils.moveFile(new File(destination+"/OINV.csv"), new File(successlog+"/OINV."+logid+".csv"));
							FileUtils.moveFile(new File(destination+"/INV1.csv"), new File(successlog+"/INV1."+logid+".csv"));
				    	}
				    	else {
				    		//Error, move active file to error processing log
							FileUtils.moveFile(new File(destination+"/OINV.csv"), new File(errorlog+"/OINV."+logid+".csv"));
							FileUtils.moveFile(new File(destination+"/INV1.csv"), new File(errorlog+"/INV1."+logid+".csv"));
				    	}
					}
				}
		    }
		    rs.close();
		    ps.close();
		    con.close();
		}catch(Exception e){
		    e.printStackTrace();
		}
	}

	public static File oldestFile(String dir,String contains) {
	    File fl = new File(dir);
	    File[] files = fl.listFiles(new FileFilter() {          
	        public boolean accept(File file) {
	            return file.isFile();
	        }
	    });
	    long lastMod = Long.MAX_VALUE;
	    File choice = null;
	    if(files!=null){
		    for (File file : files) {
		        if (file.getName().contains(contains) && file.lastModified() < lastMod) {
		            choice = file;
		            lastMod = file.lastModified();
		        }
		    }
	    }
	    return choice;
	}
}

