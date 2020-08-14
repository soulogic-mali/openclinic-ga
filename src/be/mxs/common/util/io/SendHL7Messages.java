package be.mxs.common.util.io;

import java.io.IOException;
import java.sql.SQLException;

import be.openclinic.hl7.HL7Server;

public class SendHL7Messages {

	public static void main(String[] args) throws IOException, ClassNotFoundException, SQLException {
	    Class.forName("com.mysql.jdbc.Driver");	
	    HL7Server.setConnection(args[0]);
		HL7Server.sendTransactions();
		if(HL7Server.getConfigInt("enableHL7MessagesAutoPurge", 1)==1) {
			HL7Server.purgeMessages();
		}
		System.exit(0);
	}

}
