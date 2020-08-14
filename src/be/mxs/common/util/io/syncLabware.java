package be.mxs.common.util.io;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Vector;

import net.admin.User;
import uk.org.primrose.vendor.standalone.PrimroseLoader;
import be.mxs.common.model.vo.healthrecord.TransactionVO;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Mail;
import be.mxs.common.util.system.Pointer;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.finance.Insurance;
import be.openclinic.medical.LabAnalysis;

public class syncLabware {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		//Find date of last export
		try {
			int line=1;
			if(args.length<3){
				System.out.println("\n\nWRONG SYNTAX! USAGE:");
				System.out.println("  syncLabware <db.cfg> <sqlserver_host> <sqlserver_port> <sqlserver_database> <sqlserver_user> <sqlserver_password>");
				return;
			}
			StringBuffer exportfile = new StringBuffer();
			// This will load the MySQL driver for OpenClinic
			PrimroseLoader.load(args[0], true);
		    Connection oc_conn =  MedwanQuery.getInstance().getOpenclinicConnection();
		    System.out.println(line+++". Successfully connected to OpenClinic MySQL database");
			// This will load the MS SQLServer driver for Labware
		    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");			
		    Connection lw_conn =  DriverManager.getConnection("jdbc:sqlserver://"+args[1]+":"+args[2]+";databaseName="+args[3]+";user="+args[4]+";password="+args[5]);
		    System.out.println(line+++". Successfully connected to Labware MS SQLServer database");
			
		    
		    //For the first run, synchronize all labrequests for the past 24 hours
			String language=MedwanQuery.getInstance().getConfigString("LabwareLanguage","fr");
		    Date lastLabwareSync = new java.util.Date(new java.util.Date().getTime()-24*3600*1000);
			PreparedStatement ps = oc_conn.prepareStatement("select oc_value from oc_config where oc_key='lastLabwareSync'");
		    ResultSet rs = ps.executeQuery();
		    if(rs.next()){
		    	lastLabwareSync = new SimpleDateFormat("yyyyMMddHHmmssSSS").parse(rs.getString("oc_value"));
			    System.out.println(line+++". lastLabwareSync="+lastLabwareSync);
		    }
		    rs.close();
		    ps.close();
		    java.util.Date maxdate = lastLabwareSync;
		    
		    System.out.println("\n\n");
		    System.out.println("******************************************************************");
		    System.out.println("*      Transfer new lab analysis requests to Labware server      *");
		    System.out.println("******************************************************************");
		    System.out.println("\n\n");

		    //Find all lab analysis that where requested in OpenClinic after lastLabwareSync
		    ps = oc_conn.prepareStatement("select * from requestedlabanalyses r, adminview a, privateview p, transactions t where t.serverid=r.serverid and t.transactionid=r.transactionid and a.personid=p.personid and p.stop is null and a.personid=r.patientid and t.ts>? order by t.ts");
		    ps.setTimestamp(1, new java.sql.Timestamp(lastLabwareSync.getTime()));
		    rs = ps.executeQuery();
		    while(rs.next()){
		    	try{
			    	//Collect the data necessary for transmitting to the Labware server
			    	int LW_PID = rs.getInt("patientid");
			    	String LW_P_FNAME = sNull(rs.getString("firstname"));
			    	String LW_P_LNAME = sNull(rs.getString("lastname")).toUpperCase();
			    	String LW_P_GENDER = sNull(rs.getString("gender")).toUpperCase();
			    	java.util.Date LW_P_DOB = rs.getDate("dateofbirth");
			    	String LW_P_PROVINCE = rs.getString("district");
			    	String LW_P_COMMUNE = rs.getString("sector");
			    	String LW_P_ZONE = "";
			    	String LW_P_QUARTIER = rs.getString("address");
			    	String LW_P_COLLINE = rs.getString("city");
			    	String LW_NUMPHONE = rs.getString("mobile");
			    	String LW_CARTE_MFP = getMFPAffiliateNumber(LW_PID);
			    	String LW_MATRICULE_MFP = getMFPImmatriculation(LW_PID);
			    	int LW_REQ_ORDER_ID = rs.getInt("transactionid");
			    	String LW_P_PREGNANT = isPatientPregnant(LW_REQ_ORDER_ID);
			    	String LW_P_STAGE = getEncounterStatus(LW_REQ_ORDER_ID);
			    	String LW_REQ_BY = getPrescriber(LW_REQ_ORDER_ID);
			    	String LW_REQ_TESTID = rs.getString("analysiscode");
			    	String LW_REQ_ID = LW_REQ_ORDER_ID+"."+LW_REQ_TESTID;
			    	String LW_REQ_TESTNAME = "";
			    	String LW_REQ_CATEGORY_ID = "";
			    	String LW_REQ_CATEGORY_NAME = "";
					LabAnalysis analysis = LabAnalysis.getLabAnalysisByLabcode(LW_REQ_TESTID);
					if(analysis!=null){
				    	LW_REQ_TESTNAME = ScreenHelper.getTranDb("labanalysis", analysis.getLabId()+"", language);
				    	LW_REQ_CATEGORY_ID = analysis.getSection();
				    	LW_REQ_CATEGORY_NAME = ScreenHelper.getTranDb("labanalysis.section", LW_REQ_CATEGORY_ID, language);
					}
			    	java.util.Date LW_REQ_TIME = rs.getTimestamp("ts");
			    	
			    	//First we check if this request doesn't exist yet in the Labware server
			    	PreparedStatement ps2 = lw_conn.prepareStatement("select * from LIMS_DEMANDES where REQ_ID=?");
			    	ps2.setString(1, LW_REQ_ID);
			    	ResultSet rs2 = ps2.executeQuery();
			    	if(!rs2.next() || rs2.getString("REQ_PROCESSED")==null){
				    	rs2.close();
				    	ps2.close();
					    System.out.println(line+++". Transmitting analysis "+LW_REQ_ID+"/"+LW_REQ_TESTNAME+" for patient "+LW_P_LNAME+", "+LW_P_FNAME);
				    	//Remove the existing data from the Labware server if it exists
				    	ps2 = lw_conn.prepareStatement("delete from LIMS_DEMANDES where REQ_ID=?");
				    	ps2.setString(1, LW_REQ_ID);
				    	ps2.execute();
				    	ps2.close();
				    	//Insert the request in the Labware server
				    	ps2 = lw_conn.prepareStatement("insert into LIMS_DEMANDES( PID,"
				    															+ "P_FNAME,"
				    															+ "P_LNAME,"
				    															+ "P_GENDER,"
				    															+ "P_DOB,"
				    															+ "P_PREGNANT,"
				    															+ "P_STAGE,"
				    															+ "P_PROVINCE,"
				    															+ "P_COMMUNE,"
				    															+ "P_ZONE,"
				    															+ "P_QUARTIER,"
				    															+ "P_COLLINE,"
				    															+ "NUMPHONE,"
				    															+ "CARTE_MFP,"
				    															+ "MATRICULE_MFP,"
				    															+ "REQ_ORDER_ID,"
				    															+ "REQ_BY,"
				    															+ "REQ_ID,"
				    															+ "REQ_TESTNAME,"
				    															+ "REQ_TESTID,"
				    															+ "REQ_CATEGORY_ID,"
				    															+ "REQ_CATEGORY_NAME,"
				    															+ "REQ_TIME)"
				    															+ " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
				    	ps2.setInt(1, LW_PID);
				    	ps2.setString(2, LW_P_FNAME);
				    	ps2.setString(3, LW_P_LNAME);
				    	ps2.setString(4, LW_P_GENDER);
				    	ps2.setDate(5, new java.sql.Date(LW_P_DOB.getTime()));
				    	ps2.setString(6, LW_P_PREGNANT);
				    	ps2.setString(7, LW_P_STAGE);
				    	ps2.setString(8, LW_P_PROVINCE);
				    	ps2.setString(9, LW_P_COMMUNE);
				    	ps2.setString(10, LW_P_ZONE);
				    	ps2.setString(11, LW_P_QUARTIER);
				    	ps2.setString(12, LW_P_COLLINE);
				    	ps2.setString(13, LW_NUMPHONE);
				    	ps2.setString(14, LW_CARTE_MFP);
				    	ps2.setString(15, LW_MATRICULE_MFP);
				    	ps2.setInt(16, LW_REQ_ORDER_ID);
				    	ps2.setString(17, LW_REQ_BY);
				    	ps2.setString(18, LW_REQ_ID);
				    	ps2.setString(19, LW_REQ_TESTNAME);
				    	ps2.setString(20, LW_REQ_TESTID);
				    	ps2.setString(21, LW_REQ_CATEGORY_ID);
				    	ps2.setString(22, LW_REQ_CATEGORY_NAME);
				    	ps2.setTimestamp(23, new java.sql.Timestamp(LW_REQ_TIME.getTime()));
				    	ps2.execute();
				    	ps2.close();
						MedwanQuery.getInstance().setConfigString("lastLabwareSync", new SimpleDateFormat("yyyyMMddHHmmssSSS").format(LW_REQ_TIME));
			    	}
			    	rs2.close();
			    	ps2.close();
		    	}
		    	catch(Exception el){
		    		el.printStackTrace();
		    	}
		    }
		    rs.close();
		    ps.close();
		    
		    if(MedwanQuery.getInstance().getConfigInt("enableLabwareResultsSync",0)==1){
		    	int OLD_LW_REQ_ORDER_ID=-1;
		    	String OLD_LW_REQ_TESTID="";
			    System.out.println("\n\n");
			    System.out.println("******************************************************************");
			    System.out.println("*      Transfer new lab analysis results to OpenClinic server    *");
			    System.out.println("******************************************************************");
			    System.out.println("\n\n");
	
			    //Find all lab analysis that where requested in OpenClinic after lastLabwareSync
			    ps = lw_conn.prepareStatement("select * from LIMS_RESULTATS where STATUS is NULL ORDER BY REQ_ID");
			    rs = ps.executeQuery();
			    while(rs.next()){
			    	try{
				    	String sStatusText="";
				    	int LW_PID = rs.getInt("PID");
				    	int LW_REQ_ORDER_ID = rs.getInt("REQ_ORDER_ID");
				    	String LW_REQ_TESTID = rs.getString("REQ_TESTID");
			    		String LW_TEST_RESULT = rs.getString("TEST_RESULT");
			    		String LW_REQ_TESTNAME = rs.getString("REQ_TESTNAME");
			    		String LW_TEST_REFRANGE = sNull(rs.getString("TEST_REFRANGE"));
			    		String LW_TEST_COMMENTS = rs.getString("TEST_COMMENTS");
			    		String LW_VERIFIED_BY = rs.getString("VERIFIED_BY");
			    		String LW_REVIEWED_BY = rs.getString("REVIEWED_BY");
			    		java.util.Date LW_VERIFIED_ON = rs.getTimestamp("VERIFIED_ON");
			    		java.util.Date LW_REVIEWED_ON = rs.getTimestamp("REVIEWED_ON");
			    		if(LW_REVIEWED_ON==null){
			    			LW_REVIEWED_ON=LW_VERIFIED_ON;
			    		}
					    System.out.println(line+++". Receiving lab result "+LW_REQ_ORDER_ID+"."+LW_REQ_TESTID+"/"+LW_REQ_TESTNAME+" for patient "+LW_PID);
				    	boolean bOk = true;
				    	if(LW_PID<0){
				    		bOk=false;
				    		sStatusText="PATIENT IDENTIFIER ["+LW_PID+"] IS INVALID";
				    	}
				    	else if(LW_REQ_ORDER_ID<0){
				    		bOk=false;
				    		sStatusText="LAB ORDER IDENTIFIER ["+LW_REQ_ORDER_ID+"] IS INVALID";
				    	}
				    	else if(sNull(LW_REQ_TESTID).length()==0){
				    		bOk=false;
				    		sStatusText="LAB TEST IDENTIFIER MISSING";
				    	}
				    	else if(sNull(LW_TEST_RESULT).length()==0){
				    		bOk=false;
				    		sStatusText="LAB TEST RESULT MISSING";
				    	}
				    	else if(LW_VERIFIED_ON==null){
				    		bOk=false;
				    		sStatusText="LAB TEST VERIFIED_ON DATE MISSING";
				    	}
				    	PreparedStatement ps2;
				    	ResultSet rs2;
				    	if(bOk){
					    	//Now check if a matching request exists
					    	ps2 = oc_conn.prepareStatement("select * from requestedlabanalyses where patientid=? and transactionid=? and analysiscode=?");
					    	ps2.setInt(1, LW_PID);
					    	ps2.setInt(2, LW_REQ_ORDER_ID);
					    	ps2.setString(3, LW_REQ_TESTID);
					    	rs2 = ps2.executeQuery();
					    	//Quality checks
					    	if(rs2.next()){
					    		rs2.close();
					    		ps2.close();
					    		String sSql= "update requestedlabanalyses set "
    									+ "resultvalue=?,"
    									+ "resultcomment=?,"
    									+ "finalvalidator=?,"
    									+ "technicalvalidator=?,"
    									+ "finalvalidationdatetime=?,"
    									+ "technicalvalidationdatetime=?,"
    									+ "resultrefmin=?,"
    									+ "resultrefmax=?,"
    									+ "resultmodifier=?,"
    									+ "resultunit=?"
    									+ " where patientid=? and transactionid=? and analysiscode=?";
					    		if(LW_REQ_ORDER_ID==OLD_LW_REQ_ORDER_ID && LW_REQ_TESTID.equals(OLD_LW_REQ_TESTID)) {
					    			sSql= "update requestedlabanalyses set "
	    									+ "resultvalue=resultvalue||'\n'||?,"
	    									+ "resultcomment=?,"
	    									+ "finalvalidator=?,"
	    									+ "technicalvalidator=?,"
	    									+ "finalvalidationdatetime=?,"
	    									+ "technicalvalidationdatetime=?,"
	    									+ "resultrefmin=?,"
	    									+ "resultrefmax=?,"
	    									+ "resultmodifier=?,"
	    									+ "resultunit=?"
	    									+ " where patientid=? and transactionid=? and analysiscode=?";
					    		}
					    		ps2=oc_conn.prepareStatement(sSql);
					    		if(LW_REQ_ORDER_ID==OLD_LW_REQ_ORDER_ID && LW_REQ_TESTID.equals(OLD_LW_REQ_TESTID)) {
					    			String value=LW_REQ_TESTNAME.split(";")[LW_REQ_TESTNAME.split(";").length-1]+": "+LW_TEST_RESULT.split(";")[0];
							    	if(LW_TEST_RESULT.split(";").length>1) {
							    		value+=" "+LW_TEST_RESULT.split(";")[1];
							    	}
					    			ps2.setString(1,value);
					    		}
					    		else {
					    			ps2.setString(1,LW_TEST_RESULT.split(";")[0]);
					    		}
					    		OLD_LW_REQ_ORDER_ID=LW_REQ_ORDER_ID;
					    		OLD_LW_REQ_TESTID=LW_REQ_TESTID;
					    		ps2.setString(2, LW_TEST_COMMENTS);
					    		if(User.getFullUserName(LW_REVIEWED_BY).length()==0){
					    			ps2.setInt(3, MedwanQuery.getInstance().getConfigInt("defaultLabwareFinalValidator",4));
					    		}
					    		else{
					    			ps2.setInt(3, Integer.parseInt(LW_REVIEWED_BY));
					    		}
					    		if(User.getFullUserName(LW_VERIFIED_BY).length()==0){
					    			ps2.setInt(4, MedwanQuery.getInstance().getConfigInt("defaultLabwareTechnicalValidator",4));
					    		}
					    		else{
					    			ps2.setInt(4, Integer.parseInt(LW_VERIFIED_BY));
					    		}
					    		ps2.setTimestamp(5, new java.sql.Timestamp(LW_VERIFIED_ON.getTime()));
					    		ps2.setTimestamp(6, new java.sql.Timestamp(LW_VERIFIED_ON.getTime()));
						    	if(LW_TEST_REFRANGE.split(";").length>1){
						    		ps2.setString(7, LW_TEST_REFRANGE.split(";")[0]);
						    		ps2.setString(8, LW_TEST_REFRANGE.split(";")[1]);
							    	if(LW_TEST_REFRANGE.split(";").length>2){
							    		ps2.setString(9, LW_TEST_REFRANGE.split(";")[2]);
							    	}
							    	else{
							    		ps2.setString(9, "");
							    	}
						    	}
						    	else{
						    		ps2.setString(7, "");
						    		ps2.setString(8, "");
						    		ps2.setString(9, LW_TEST_REFRANGE);
						    	}
					    		if((LW_REQ_ORDER_ID!=OLD_LW_REQ_ORDER_ID || !LW_REQ_TESTID.equals(OLD_LW_REQ_TESTID)) && LW_TEST_RESULT.split(";").length>1 ) {
						    		ps2.setString(10, LW_TEST_RESULT.split(";")[1]);
						    	}
						    	else {
						    		ps2.setString(10, "");
						    	}
					    		ps2.setInt(11, LW_PID);
						    	ps2.setInt(12, LW_REQ_ORDER_ID);
						    	ps2.setString(13, LW_REQ_TESTID);
						    	ps2.execute();
					    		ps2.close();
					    		ps2=lw_conn.prepareStatement("update LIMS_RESULTATS set STATUS='P',STATUS_TEXT='',PROCESSED_ON=? where PID=? and REQ_ORDER_ID=? and REQ_TESTID=?");
						    	ps2.setTimestamp(1, new java.sql.Timestamp(new java.util.Date().getTime()));
					    		ps2.setInt(2, LW_PID);
						    	ps2.setInt(3, LW_REQ_ORDER_ID);
						    	ps2.setString(4, LW_REQ_TESTID);
						    	ps2.execute();
						    	ps2.close();
					    	}
					    	else{
					    		rs2.close();
					    		ps2.close();
					    		sStatusText="LAB ANALYSIS ["+LW_REQ_TESTID+"] ON LAB ORDER ["+LW_REQ_ORDER_ID+"] FOR PATIENT ["+LW_PID+"] FOUND NO MATCHING RECORD IN OPENCLINIC DATABASE";
					    		bOk=false;
					    	}
				    	}
				    	if(!bOk){
				    		ps2=lw_conn.prepareStatement("update LIMS_RESULTATS set STATUS='F',STATUS_TEXT=?,PROCESSED_ON=? where PID=? and REQ_ORDER_ID=? and REQ_TESTID=?");
					    	ps2.setString(1, sStatusText);
				    		ps2.setTimestamp(2, new java.sql.Timestamp(new java.util.Date().getTime()));
				    		ps2.setInt(3, LW_PID);
					    	ps2.setInt(4, LW_REQ_ORDER_ID);
					    	ps2.setString(5, LW_REQ_TESTID);
					    	ps2.execute();
					    	ps2.close();
				    	}
				    }
				    catch (Exception el) {
						el.printStackTrace();
					}
			    }
			    rs.close();
			    ps.close();
		    }
		    else{
			    System.out.println(line+++". Labware results retrieval is DISABLED (enableLabwareResultsSync=0)");
		    }
		    System.out.println("\n\n");
		    
			oc_conn.close();
		    System.out.println(line+++". Successfully disconnected from OpenClinic MySQL database");
			lw_conn.close();
		    System.out.println(line+++". Successfully disconnected from Labware MS SQLServer database");

		} catch (Exception e) {
			e.printStackTrace();
		}
		System.exit(0);
	}

	static String sNull(String s){
		if(s==null){
			return "";
		}
		else{
			return s;
		}
	}
	
	
	static String getPrescriber(int transactionid){
		String s ="";
		TransactionVO transaction = MedwanQuery.getInstance().loadTransaction(1, transactionid);
		if(transaction!=null){
			s=transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_PRESCRIBER");
			if(sNull(s).trim().length()==0){
				s=User.getFullUserName(transaction.getUser().userId+"");
			}
		}
		return s;
	}
	
	static String getMFPImmatriculation(int personid){
		String s="";
		Vector insurances = Insurance.getCurrentInsurances(personid+"");
		for(int n=0;n<insurances.size();n++){
			Insurance insurance = (Insurance)insurances.elementAt(n);
			if(insurance.getExtraInsurarUid().equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("MFP","-1"))){
				s=insurance.getMemberImmat();
			}
		}
		return s;
	}
	
	static String getMFPAffiliateNumber(int personid){
		String s="";
		Vector insurances = Insurance.getCurrentInsurances(personid+"");
		for(int n=0;n<insurances.size();n++){
			Insurance insurance = (Insurance)insurances.elementAt(n);
			if(insurance.getExtraInsurarUid().equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("MFP","-1"))){
				s=insurance.getInsuranceNr();
			}
		}
		return s;
	}
	
	static String isPatientPregnant(int transactionid){
		String s ="Non applicable ou inconnu";
		TransactionVO transaction = MedwanQuery.getInstance().loadTransaction(1, transactionid);
		if(transaction!=null){
			s=transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_PREGNANT");
			if(sNull(s).equalsIgnoreCase("medwan.common.true")){
				s="Enceinte";
			}
			else{
				s="Non enceinte";
			}
		}
		return s;
	}
	
	static String getEncounterStatus(int transactionid){
		String s ="Inconnu";
		TransactionVO transaction = MedwanQuery.getInstance().loadTransaction(1, transactionid);
		if(transaction!=null){
			s=transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_EXTERNAL");
			if(sNull(s).equalsIgnoreCase("medwan.common.true")){
				s="Externe";
			}
			else{
				s="Interne";
			}
		}
		return s;
	}
}
