package be.mxs.common.util.io;

import java.io.IOException;
import java.sql.SQLException;

import be.openclinic.hl7.HL7Server;

public class StartHL7Server {

	public static void main(String[] args) throws InterruptedException, IOException, SQLException, ClassNotFoundException {
	    Class.forName("com.mysql.jdbc.Driver");	
	    HL7Server.setConnection(args[0]);
		HL7Server hl7server = new HL7Server();
		hl7server.start(HL7Server.getConfigInt("hl7serverPort",4001));
	}

}
