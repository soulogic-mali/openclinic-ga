package be.openclinic.hl7;

import java.io.IOException;
import java.sql.SQLException;

import ca.uhn.hl7v2.DefaultHapiContext;
import ca.uhn.hl7v2.HL7Exception;
import ca.uhn.hl7v2.HapiContext;
import ca.uhn.hl7v2.app.Connection;
import ca.uhn.hl7v2.app.Initiator;
import ca.uhn.hl7v2.llp.LLPException;
import ca.uhn.hl7v2.model.Message;
import ca.uhn.hl7v2.model.v251.message.ACK;
import ca.uhn.hl7v2.parser.CanonicalModelClassFactory;
import ca.uhn.hl7v2.parser.Parser;

public class HL7Sender {
	public static boolean send(Message message, String host, int port) {
		Connection connection = null;
		HapiContext context = null;
		try {
			context = new DefaultHapiContext();
	        CanonicalModelClassFactory mcf = new CanonicalModelClassFactory("2.5.1");
	        context.setModelClassFactory(mcf);			
	        boolean useTls=false;
			connection = context.newClient(host, port, useTls);
			Initiator initiator = connection.getInitiator();
			System.out.println("Sending message to "+host+":"+port+"...");
			System.out.println("-- begin HL7 message --");
			System.out.println(context.getPipeParser().encode(message).replaceAll("\r","\n\r"));
			System.out.println("-- end HL7 message --");
			Message response = initiator.sendAndReceive(message);
			Parser p = context.getPipeParser();
			String responseString = p.encode(response);
			System.out.println("Received response from "+host+":"+port+" -> \n" + responseString.replaceAll("\r","\r\n"));
	    	ACK ack = (ACK)response;
	    	System.out.println("Response type: "+ack.getMSA().getAcknowledgmentCode().getValue());
	    	System.out.println("Control ID: "+ack.getMSA().getMessageControlID().getValue());
	    	if("*AA*CA*".contains(ack.getMSA().getAcknowledgmentCode().getValue().toUpperCase())) {
	    		HL7Server.setTransactionACK(ack.getMSA().getMessageControlID().getValue(), ack.getMSH().getDateTimeOfMessage().getTime().getValueAsCalendar().getTime());
	    	}
	    	else {
	    		HL7Server.setTransactionError(ack.getMSA().getMessageControlID().getValue(), responseString);
	    	}
			if(connection!=null && connection.isOpen()) {
				System.out.println("Closing connection");
		    	connection.close();
		    	context.close();
				connection=null;
				context=null;
				if(connection==null || !connection.isOpen()) {
					System.out.println("Connection closed");
				}
				else {
					System.out.println("Connection NOT closed");
				}
			}
	    	return true;
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		if(connection!=null && connection.isOpen()) {
			System.out.println("Closing connection");
	    	connection.close();
			System.out.println("Connection open: "+connection.isOpen());
	    	try {
				context.close();
				connection=null;
				context=null;
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			if(connection==null || !connection.isOpen()) {
				System.out.println("Connection closed");
			}
			else {
				System.out.println("Connection NOT closed");
			}
		}
		return false;
	}
}
