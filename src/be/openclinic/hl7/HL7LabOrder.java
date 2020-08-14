package be.openclinic.hl7;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.HashSet;

import be.mxs.common.model.vo.healthrecord.TransactionVO;
import be.mxs.common.util.db.MedwanQuery;
import be.openclinic.adt.Encounter;
import be.openclinic.finance.Insurance;
import be.openclinic.medical.LabAnalysis;
import ca.uhn.hl7v2.DefaultHapiContext;
import ca.uhn.hl7v2.HL7Exception;
import ca.uhn.hl7v2.HapiContext;
import ca.uhn.hl7v2.model.DataTypeException;
import ca.uhn.hl7v2.model.v251.message.OML_O33;
import ca.uhn.hl7v2.model.v251.segment.IN1;
import ca.uhn.hl7v2.model.v251.segment.OBR;
import ca.uhn.hl7v2.model.v251.segment.OBX;
import ca.uhn.hl7v2.model.v251.segment.ORC;
import ca.uhn.hl7v2.model.v251.segment.PID;
import ca.uhn.hl7v2.model.v251.segment.PV1;
import ca.uhn.hl7v2.parser.Parser;
import net.admin.AdminPerson;

public class HL7LabOrder {
	private OML_O33 message = new OML_O33();
	public HashSet labanalyses = new HashSet();
	public HashSet specimens = new HashSet();
	
	public OML_O33 getMessage() {
		return message;
	}

	public void setMessage(OML_O33 message) {
		this.message = message;
	}

	public HL7LabOrder() throws HL7Exception, IOException, SQLException {
		message.initQuickstart("OML", "O33", "P");
		if(HL7Server.getConfigString("labmiddleware","aliniq").equalsIgnoreCase("aliniq")) {
			message.getMSH().getMessageType().getMessageStructure().setValue("");
		}
		message.getMSH().getSendingApplication().getNamespaceID().setValue("OC");
		message.getMSH().getSendingApplication().getUniversalID().setValue("OpenClinic GA");
		if(!HL7Server.getConfigString("labmiddleware","aliniq").equalsIgnoreCase("aliniq")) {
			message.getSFT().getSoftwareVendorOrganization().getOrganizationName().setValue("Post-Factum");
			message.getSFT().getSoftwareCertifiedVersionOrReleaseNumber().setValue(HL7Server.getConfigString("updateVersion","0"));
			message.getSFT().getSoftwareProductName().setValue("OpenClinic GA");
			message.getSFT().getSoftwareBinaryID().setValue(HL7Server.getConfigString("updateVersion","0"));
		}
	}

	public void setPatient(int serverid, int transactionid) throws DataTypeException, SQLException {
		//Set the basic patient data
		PID pid = message.getPATIENT().getPID();
		pid.getPatientName(0).getFamilyName().getSurname().setValue(HL7Server.getTransactionLastname(serverid, transactionid));
		pid.getPatientName(0).getGivenName().setValue(HL7Server.getTransactionFirstname(serverid, transactionid));
		//PI = Internal patient identifier
		pid.getPatientID().getIdentifierTypeCode().setValue("PI");;
		pid.getPatientID().getIDNumber().setValue(HL7Server.getTransactionPersonId(serverid, transactionid)+"");
		java.util.Date dob = HL7Server.getTransactionDateOfBirth(serverid, transactionid);
		pid.getDateTimeOfBirth().getTime().setValue(dob==null?"":new SimpleDateFormat("yyyyMMdd").format(dob));
		pid.getAdministrativeSex().setValue(HL7Server.checkString(HL7Server.getTransactionGender(serverid, transactionid)).toUpperCase());
		pid.getPatientIdentifierList(0).getIDNumber().setValue(HL7Server.getTransactionPersonId(serverid, transactionid)+"");
	}
	
	public void setEncounter(int serverid, int transactionid) throws DataTypeException, SQLException {
		PV1 pv = message.getPATIENT().getPATIENT_VISIT().getPV1();
		pv.getSetIDPV1().setValue("1");
		pv.getPatientClass().setValue(HL7Server.getEncounterType(serverid, transactionid).equalsIgnoreCase("visit")?"O":"I");
		pv.getVisitNumber().getIDNumber().setValue(HL7Server.getEncounterUID(serverid, transactionid));
		pv.getAdmitDateTime().getTime().setValue(HL7Server.getEncounterBegin(serverid, transactionid));
		String userid = HL7Server.getEncounterManagerUid(serverid, transactionid);
		if(userid.length()>0) {
			pv.getAttendingDoctor(0).getIDNumber().setValue(userid);
			pv.getAttendingDoctor(0).getFamilyName().getSurname().setValue(HL7Server.getUserLastname(userid));
			pv.getAttendingDoctor(0).getGivenName().setValue(HL7Server.getUserFirstname(userid));
		}
	}
	
	public void setInsurance(int serverid, int transactionid) throws DataTypeException, SQLException {
		String uid = HL7Server.getDefaultInsurance(HL7Server.getTransactionPersonId(serverid, transactionid));
		if(uid.length()>0) {
			IN1 in1 = message.getPATIENT().getINSURANCE().getIN1();
			in1.getSetIDIN1().setValue("1");
			in1.getInsuranceCompanyID(0).getIDNumber().setValue(HL7Server.getDefaultInsurarUid(uid));
			in1.getInsuranceCompanyName(0).getOrganizationName().setValue(HL7Server.getDefaultInsurarName(uid));
			in1.getInsurancePlanID().getText().setValue(HL7Server.getDefaultInsuranceCategory(uid));
			in1.getInsuredSIDNumber(0).getIDNumber().setValue(HL7Server.getDefaultInsuranceNumber(uid));
		}
	}
	

	public static HL7LabOrder getHL7LabRequest(int serverid, int transactionid) {
		HL7LabOrder order = null;
		try {
			order = new HL7LabOrder();
			order.setEncounter(serverid,transactionid);
			order.setPatient(serverid,transactionid);
			if(!HL7Server.getConfigString("labmiddleware","aliniq").equalsIgnoreCase("aliniq")) {
				order.setInsurance(serverid,transactionid);
			}
			order.labanalyses = HL7Server.setLabRequest(serverid, transactionid,order.message);
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return order;
	}
	
	public void printER7() throws HL7Exception {
        HapiContext context = new DefaultHapiContext();
        Parser parser = context.getPipeParser();
        String encodedMessage = parser.encode(message);
	}
	
	public void printXML() throws HL7Exception {
        HapiContext context = new DefaultHapiContext();
        Parser parser = context.getXMLParser();
        String encodedMessage = parser.encode(message);
	}
}
