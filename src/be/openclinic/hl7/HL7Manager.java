package be.openclinic.hl7;

import java.io.IOException;

import ca.uhn.hl7v2.DefaultHapiContext;
import ca.uhn.hl7v2.HL7Exception;
import ca.uhn.hl7v2.HapiContext;
import ca.uhn.hl7v2.model.v251.group.OML_O21_OBSERVATION_REQUEST;
import ca.uhn.hl7v2.model.v251.message.OML_O21;
import ca.uhn.hl7v2.model.v251.segment.*;
import ca.uhn.hl7v2.parser.Parser;


public class HL7Manager {

	public static OML_O21 createLabOrder() throws HL7Exception, IOException {
		OML_O21 message = new OML_O21();
		message.initQuickstart("OML", "O21", "P");
		
		//Set the basic patient data
		PID pid = message.getPATIENT().getPID();
		pid.getPatientName(0).getFamilyName().getSurname().setValue("Verbeke");
		pid.getPatientName(0).getGivenName().setValue("Frank");
		pid.getPatientIdentifierList(0).getIDNumber().setValue("9966");
		
		//Set the encounter data
		PV1 pv = message.getPATIENT().getPATIENT_VISIT().getPV1();
		pv.getPatientClass().setValue("O");
		
		//Create the order information
		ORC orc = message.getORDER().getORC();
		orc.getOrderControl().setValue("NW");
		
		//Create the observation request
		OBR obr = message.getORDER().getOBSERVATION_REQUEST().getOBR();
		obr.getUniversalServiceIdentifier().getIdentifier().setValue("1.5667");
				
		//Add tests
		int i = 0;
		OBX obx = message.getORDER().getOBSERVATION_REQUEST().getOBSERVATION(i).getOBX();
		obx.getObservationIdentifier().getIdentifier().setValue("Hb");
		obx.getObservationResultStatus().setValue("O");

        HapiContext context = new DefaultHapiContext();
        Parser parser = context.getPipeParser();
        String encodedMessage = parser.encode(message);

        parser = context.getXMLParser();
        encodedMessage = parser.encode(message);

		return message;
	}
	
}
