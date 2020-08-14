package be.mxs.common.util.io;

import java.io.File;
import java.io.FileFilter;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Iterator;

import org.apache.commons.io.FileUtils;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import be.mxs.common.util.db.MedwanQuery;

public class QueueSAPMessages {

	public static void main(String[] args) {
		// Load queue configuration file
		// args[0] = config file
        try {
            SAXReader reader = new SAXReader(false);
			Document document = reader.read(new URL(args[0]));
			Element root = document.getRootElement();
			Iterator queues = root.elementIterator("queue");
			while(queues.hasNext()){
				Element queue = (Element)queues.next();
				if(queue.attributeValue("type")!=null && queue.attributeValue("type").equalsIgnoreCase("AR_INV")){
					String source = queue.attributeValue("source");
					String destination = queue.attributeValue("destination");
					System.out.println("Trying to move AR_INV message from "+source+" to "+destination);
					//First check if no active files exist in the active queue
					File fileOINV = new File(destination+"/OINV.csv");
					File fileINV1 = new File(destination+"/INV1.csv");
					if(fileOINV.exists() || fileINV1.exists()){
						System.out.println("There already exists an active file in the "+destination+" queue, nothing to do!");
					}
					else{
						//Pick the oldest OINV file from the source
						fileOINV=oldestFile(source+"/","OINV");
						if(fileOINV!=null){
							System.out.println("Oldest file in queue = "+fileOINV.getName());
							//Move file from queue to active
							fileINV1=new File(source+"/"+fileOINV.getName().replaceAll("OINV", "INV1"));
							if(fileINV1.exists()){
								FileUtils.moveFile(fileOINV, new File(destination+"/OINV.csv"));
								FileUtils.moveFile(fileINV1, new File(destination+"/INV1.csv"));
								System.out.println("Moved "+fileOINV.getName()+" to "+destination+"/OINV.csv");
								System.out.println("Moved "+fileINV1.getName()+" to "+destination+"/INV1.csv");
							}
							else{
								System.out.println("ERROR: orphan OINV file without INV1 equivalent: "+fileOINV.getName());
							}
						}
					}
				}
			}
		} catch (Exception e) {
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

