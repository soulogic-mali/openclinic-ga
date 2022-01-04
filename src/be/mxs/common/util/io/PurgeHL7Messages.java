package be.mxs.common.util.io;

import java.io.IOException;
import java.sql.SQLException;

import be.openclinic.hl7.HL7Server;
import uk.org.primrose.GeneralException;
import uk.org.primrose.vendor.standalone.PrimroseLoader;

public class PurgeHL7Messages {

	public static void main(String[] args) throws IOException, ClassNotFoundException, SQLException, GeneralException {
	    PrimroseLoader.load(args[0],true);
		HL7Server.purgeMessages();
		System.exit(0);
	}

}
