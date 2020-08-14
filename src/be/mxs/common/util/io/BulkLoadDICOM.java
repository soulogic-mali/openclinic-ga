package be.mxs.common.util.io;

import be.openclinic.archiving.ScanDirectoryMonitor;
import uk.org.primrose.vendor.standalone.PrimroseLoader;

public class BulkLoadDICOM {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
    	try {
			PrimroseLoader.load(args[0], true);
			ScanDirectoryMonitor.bulkLoadDICOM();
		}
    	catch (Exception e) {
			e.printStackTrace();
		}
		System.exit(0);

	}

}
