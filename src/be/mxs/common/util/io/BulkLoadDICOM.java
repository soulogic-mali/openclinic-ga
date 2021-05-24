package be.mxs.common.util.io;

import java.io.File;

import org.dcm4che2.io.DicomInputStream;

import be.mxs.common.util.system.Debug;
import be.openclinic.archiving.*;
import uk.org.primrose.vendor.standalone.PrimroseLoader;

public class BulkLoadDICOM {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
    	try {
    		Debug.enabled=true;
			System.out.println("------------------------------ Loading "+args[0]);
    		PrimroseLoader.load(args[0], true);
			System.out.println("------------------------------ Loaded");
			ScanDirectoryMonitor2 mon = new ScanDirectoryMonitor2();
			mon.loadConfig();
			System.out.println("------------------------------ Scanning directory");
			//DicomInputStream din = new DicomInputStream(new File("test"));
			mon.bulkLoadDICOM();
	    	Thread.sleep(10000);
		}
    	catch (Exception e) {
			e.printStackTrace();
		}
		System.exit(0);
	}

}
