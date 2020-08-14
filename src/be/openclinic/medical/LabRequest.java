package be.openclinic.medical;

import be.mxs.common.model.vo.healthrecord.TransactionVO;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.io.ResetQueues;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.adt.Encounter;
import be.openclinic.system.SH;
import net.admin.AdminPerson;

import java.util.*;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

import org.hl7.fhir.r4.model.CodeableConcept;
import org.hl7.fhir.r4.model.Narrative;
import org.hl7.fhir.r4.model.Observation;
import org.hl7.fhir.r4.model.Quantity;
import org.hl7.fhir.r4.model.Reference;
import org.hl7.fhir.r4.model.ServiceRequest;
import org.hl7.fhir.r4.model.ServiceRequest.ServiceRequestIntent;
import org.hl7.fhir.r4.model.ServiceRequest.ServiceRequestPriority;
import org.hl7.fhir.r4.model.ServiceRequest.ServiceRequestStatus;
import org.hl7.fhir.r4.model.Type;
import org.jnp.interfaces.java.javaURLContextFactory;


public class LabRequest {
    private Hashtable analyses = new Hashtable();
    private int serverid;
    private int transactionid;
    private int userid;
    private int personid;
    private String patientname;
    private String patientgender;
    private String servicename="";
    private java.util.Date requestdate;
    private String comment;
    private java.util.Date patientdateofbirth;
    private boolean confirmed=true;

    public boolean isConfirmed() {
        return confirmed;
    }

    public void setConfirmed(boolean confirmed) {
        this.confirmed = confirmed;
    }

    public java.util.Date getPatientdateofbirth() {
        return patientdateofbirth;
    }

    public void setPatientdateofbirth(java.util.Date patientdateofbirth) {
        this.patientdateofbirth = patientdateofbirth;
    }

    public Hashtable getAnalyses() {
        return analyses;
    }

    public SortedMap getSortedAnalyses() {
        SortedMap s = new TreeMap();
        s.putAll(analyses);
        return s;
    }

    public void setAnalyses(Hashtable analyses) {
        this.analyses = analyses;
    }

    public int getServerid() {
        return serverid;
    }

    public void setServerid(int serverid) {
        this.serverid = serverid;
    }

    public int getTransactionid() {
        return transactionid;
    }

    public void setTransactionid(int transactionid) {
        this.transactionid = transactionid;
    }

    public int getUserid() {
        return userid;
    }

    public void setUserid(int userid) {
        this.userid = userid;
    }

    public int getPersonid() {
        return personid;
    }

    public void setPersonid(int personid) {
        this.personid = personid;
    }

    public String getPatientname() {
        return patientname;
    }

    public void setPatientname(String patientname) {
        this.patientname = patientname;
    }

    public String getPatientgender() {
        return patientgender;
    }

    public void setPatientgender(String patientgender) {
        this.patientgender = patientgender;
    }

    public String getServicename() {
        return servicename;
    }

    public void setServicename(String servicename) {
        this.servicename = servicename;
    }

    public java.util.Date getRequestdate() {
        return requestdate;
    }

    public void setRequestdate(java.util.Date requestdate) {
        this.requestdate = requestdate;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }
    
    public static ServiceRequest getFHIRLabOrder(String transactionUid) {
    	TransactionVO labTransaction =MedwanQuery.getInstance().loadTransaction(transactionUid);
    	if(labTransaction==null) {
    		return null;
    	}
		ServiceRequest laborder = new ServiceRequest();
		laborder.setId(labTransaction.getUid());
		laborder.setStatus(ServiceRequestStatus.ACTIVE);
		laborder.setIntent(ServiceRequestIntent.ORDER);
		laborder.addCategory().addCoding().setSystem("http://snomed.info/sct").setCode("108252007").setDisplay("Laboratory procedure");
		laborder.addSupportingInfo().setDisplay(labTransaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_CLINICAL_INFORMATION"));
		if(labTransaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_URGENCY").equalsIgnoreCase("urgent")) {
			laborder.setPriority(ServiceRequestPriority.URGENT);
		}
		else if(labTransaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_URGENCY").equalsIgnoreCase("normal")) {
			laborder.setPriority(ServiceRequestPriority.ROUTINE);
		}
		else if(labTransaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_URGENCY").equalsIgnoreCase("routine")) {
			laborder.setPriority(ServiceRequestPriority.ROUTINE);
		}
		else {
			laborder.setPriority(ServiceRequestPriority.NULL);
		}
		int personid = MedwanQuery.getInstance().getPersonIdFromHealthrecordId(labTransaction.getHealthrecordId());
		laborder.setSubject(new Reference("Patient/"+personid).setDisplay(AdminPerson.getFullName(personid+"")));
		Encounter encounter = Encounter.getActiveEncounterOnDate(new Timestamp(labTransaction.getUpdateTime().getTime()), personid+"");
		if(encounter!=null) {
			laborder.setEncounter(new Reference("Encounter/"+encounter.getUid()).setDisplay(SH.getTranNoLink("encountertype", encounter.getType(), SH.cs("DefaultLanguage", "en"))));
		}
		//Add specimen
		//Add order details
		CodeableConcept orderDetail = laborder.addOrderDetail();
		Hashtable<String,RequestedLabAnalysis> analyses = RequestedLabAnalysis.getLabAnalysesForLabRequest(labTransaction.getServerId(), labTransaction.getTransactionId());
		Enumeration<String> eAnalyses = analyses.keys();
		while(eAnalyses.hasMoreElements()) {
			String la_code = eAnalyses.nextElement();
			RequestedLabAnalysis la_analysis = analyses.get(la_code);
			orderDetail.addCoding().setSystem("openclinic").setCode(la_code).setDisplay(SH.getTranNoLink("labanalysis", LabAnalysis.idForCode(la_code), SH.cs("DefaultLanguage", "en")));
		}
		return laborder;
    }
    
    public HashSet getSampleReceptions() {
    	HashSet receptions = new HashSet();
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
        	PreparedStatement ps = oc_conn.prepareStatement("select distinct sampler,samplereceptiondatetime from requestedlabanalyses where serverid=? and transactionid=? order by samplereceptiondatetime");
        	ps.setInt(1, getServerid());
        	ps.setInt(2, getTransactionid());
        	ResultSet rs = ps.executeQuery();
        	while(rs.next()) {
        		int userid = rs.getInt("sampler");
        		if(userid>0) {
        			receptions.add(userid+";"+ScreenHelper.formatDate(rs.getTimestamp("samplereceptiondatetime"),new SimpleDateFormat("dd/MM/yyyy HH:mm")));
        		}
	        }
	        rs.close();
	        ps.close();
	    }
	    catch(Exception e){
	        e.printStackTrace();
	    }
	    try {
			oc_conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
    	return receptions;
    }
    
    public HashSet getSampleReceptions(String language) {
    	HashSet receptions = new HashSet();
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
        	PreparedStatement ps = oc_conn.prepareStatement("select distinct sampler,samplereceptiondatetime,monster from requestedlabanalyses,labanalysis where labcode=analysiscode and serverid=? and transactionid=? order by samplereceptiondatetime");
        	ps.setInt(1, getServerid());
        	ps.setInt(2, getTransactionid());
        	ResultSet rs = ps.executeQuery();
        	while(rs.next()) {
        		int userid = rs.getInt("sampler");
        		if(userid>0) {
        			receptions.add(userid+";"+ScreenHelper.formatDate(rs.getTimestamp("samplereceptiondatetime"),new SimpleDateFormat("dd/MM/yyyy HH:mm"))+";"+ScreenHelper.getTran("labanalysis.monster", rs.getString("monster"), language));
        		}
	        }
	        rs.close();
	        ps.close();
	    }
	    catch(Exception e){
	        e.printStackTrace();
	    }
	    try {
			oc_conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
    	return receptions;
    }


    public void loadRequestAnalyses(String worklistAnalyses){
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sQuery="select a.*,b.labgroup from RequestedLabAnalyses a,LabAnalysis b where a.analysiscode=b.labcode and b.deletetime is null and serverid=? and transactionid=? and analysiscode in ("+worklistAnalyses+")";
            PreparedStatement ps = oc_conn.prepareStatement(sQuery);
            ps.setInt(1,getServerid());
            ps.setInt(2,getTransactionid());
            ResultSet rs = ps.executeQuery();
            while (rs.next()){
                RequestedLabAnalysis requestedLabAnalysis = new RequestedLabAnalysis();
                requestedLabAnalysis.setLabgroup(rs.getString("labgroup"));
                requestedLabAnalysis.setAnalysisCode(rs.getString("analysiscode"));
                requestedLabAnalysis.setComment(rs.getString("comment"));
                requestedLabAnalysis.setPatientId(rs.getString("patientid"));
                requestedLabAnalysis.setRequestDate(new java.sql.Date(getRequestdate().getTime()));
                requestedLabAnalysis.setRequestUserId(getUserid()+"");
                requestedLabAnalysis.setResultComment(rs.getString("resultcomment"));
                requestedLabAnalysis.setResultDate(rs.getTimestamp("resultdate"));
                requestedLabAnalysis.setResultModifier(rs.getString("resultmodifier"));
                requestedLabAnalysis.setResultProvisional(rs.getString("resultprovisional"));
                setConfirmed(isConfirmed() && ScreenHelper.checkString(rs.getString("resultprovisional")).equalsIgnoreCase(""));
                requestedLabAnalysis.setResultRefMax(rs.getString("resultrefmax"));
                requestedLabAnalysis.setResultRefMin(rs.getString("resultrefmin"));
                requestedLabAnalysis.setResultUnit(rs.getString("resultunit"));
                requestedLabAnalysis.setResultUserId(rs.getString("resultuserid"));
                requestedLabAnalysis.setResultValue(rs.getString("resultvalue"));
                requestedLabAnalysis.setTechnicalvalidation(rs.getInt("technicalvalidator"));
                requestedLabAnalysis.setFinalvalidation(rs.getInt("finalvalidator"));
                java.util.Date d= rs.getTimestamp("technicalvalidationdatetime");
                if(d!=null){
                    requestedLabAnalysis.setTechnicalvalidationdatetime(new java.sql.Date(d.getTime()));
                }
                d= rs.getTimestamp("finalvalidationdatetime");
                if(d!=null){
                    requestedLabAnalysis.setFinalvalidationdatetime(new java.sql.Date(d.getTime()));
                }
                d= rs.getTimestamp("sampletakendatetime");
                if(d!=null){
                    requestedLabAnalysis.setSampletakendatetime(new java.sql.Date(d.getTime()));
                }
                d= rs.getTimestamp("samplereceptiondatetime");
                if(d!=null){
                    requestedLabAnalysis.setSamplereceptiondatetime(new java.sql.Date(d.getTime()));
                }
                d= rs.getTimestamp("worklisteddatetime");
                if(d!=null){
                    requestedLabAnalysis.setWorklisteddatetime(new java.sql.Date(d.getTime()));
                }
                requestedLabAnalysis.setSampler(rs.getInt("sampler"));
                getAnalyses().put(requestedLabAnalysis.getAnalysisCode(),requestedLabAnalysis);
            }
            rs.close();
            ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
    }
    public Vector getMissingScans(){
    	Vector missingScans = new Vector();
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sQuery="select distinct b.editorparameters from RequestedLabAnalyses a,LabAnalysis b"
            		+ " where a.analysiscode=b.labcode and b.deletetime is null and serverid=? and transactionid=? "
            		+ " and b.editor='scan' and not exists (select * from arch_documents where "+MedwanQuery.getInstance().getConfigString("lengthFunction","len")+"(arch_document_storagename)>0 and arch_document_reference=?"+MedwanQuery.getInstance().concatSign()+"replace(b.editorparameters,'TP:',''))";
            PreparedStatement ps = oc_conn.prepareStatement(sQuery);
            ps.setInt(1,getServerid());
            ps.setInt(2,getTransactionid());
            ps.setString(3,getServerid()+"."+getTransactionid()+".LAB.");
            ResultSet rs = ps.executeQuery();
            while (rs.next()){
            	missingScans.add(rs.getString("editorparameters"));
            }
            rs.close();
            ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
        return missingScans;
    }
    
    public void loadRequestAnalyses(java.util.Date date){
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sQuery="select a.*,b.labgroup from RequestedLabAnalyses a,LabAnalysis b where a.analysiscode=b.labcode and b.deletetime is null and serverid=? and transactionid=? and finalvalidationdatetime >= ?";
            PreparedStatement ps = oc_conn.prepareStatement(sQuery);
            ps.setInt(1,getServerid());
            ps.setInt(2,getTransactionid());
            ps.setTimestamp(3,new java.sql.Timestamp(date.getTime()));
            ResultSet rs = ps.executeQuery();
            while (rs.next()){
                RequestedLabAnalysis requestedLabAnalysis = new RequestedLabAnalysis();
                requestedLabAnalysis.setLabgroup(rs.getString("labgroup"));
                requestedLabAnalysis.setAnalysisCode(rs.getString("analysiscode"));
                requestedLabAnalysis.setComment(getComment());
                requestedLabAnalysis.setPatientId(rs.getString("patientid"));
                requestedLabAnalysis.setRequestDate(new java.sql.Date(getRequestdate().getTime()));
                requestedLabAnalysis.setRequestUserId(getUserid()+"");
                requestedLabAnalysis.setResultComment(rs.getString("resultcomment"));
                requestedLabAnalysis.setResultDate(rs.getTimestamp("resultdate"));
                requestedLabAnalysis.setResultModifier(rs.getString("resultmodifier"));
                requestedLabAnalysis.setResultProvisional(rs.getString("resultprovisional"));
                setConfirmed(isConfirmed() && ScreenHelper.checkString(rs.getString("resultprovisional")).equalsIgnoreCase(""));
                requestedLabAnalysis.setResultRefMax(rs.getString("resultrefmax"));
                requestedLabAnalysis.setResultRefMin(rs.getString("resultrefmin"));
                requestedLabAnalysis.setResultUnit(rs.getString("resultunit"));
                requestedLabAnalysis.setResultUserId(rs.getString("resultuserid"));
                requestedLabAnalysis.setResultValue(rs.getString("resultvalue"));
                requestedLabAnalysis.setTechnicalvalidation(rs.getInt("technicalvalidator"));
                requestedLabAnalysis.setFinalvalidation(rs.getInt("finalvalidator"));
                java.util.Date d= rs.getTimestamp("technicalvalidationdatetime");
                if(d!=null){
                    requestedLabAnalysis.setTechnicalvalidationdatetime(new java.sql.Date(d.getTime()));
                }
                d= rs.getTimestamp("finalvalidationdatetime");
                if(d!=null){
                    requestedLabAnalysis.setFinalvalidationdatetime(new java.sql.Date(d.getTime()));
                }
                d= rs.getTimestamp("sampletakendatetime");
                if(d!=null){
                    requestedLabAnalysis.setSampletakendatetime(new java.sql.Date(d.getTime()));
                }
                d= rs.getTimestamp("samplereceptiondatetime");
                if(d!=null){
                    requestedLabAnalysis.setSamplereceptiondatetime(new java.sql.Date(d.getTime()));
                }
                d= rs.getTimestamp("worklisteddatetime");
                if(d!=null){
                    requestedLabAnalysis.setWorklisteddatetime(new java.sql.Date(d.getTime()));
                }
                requestedLabAnalysis.setSampler(rs.getInt("sampler"));
                getAnalyses().put(requestedLabAnalysis.getAnalysisCode(),requestedLabAnalysis);
            }
            rs.close();
            ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
    }

    public LabRequest(){

    }

    public static LabRequest getUnsampledRequest(int serverid,String transactionid,String language){
        LabRequest labRequest = new LabRequest();
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sQuery="select distinct a.serverid,a.transactionid,a.patientid,d.gender,d.firstname,d.lastname,b.userid,d.dateofbirth,b.updatetime from RequestedLabAnalyses a, Transactions b, AdminView d where a.serverid=b.serverid and a.transactionId=b.transactionId and a.patientid=d.personid and a.serverid=? and a.transactionid=?";
            PreparedStatement ps = oc_conn.prepareStatement(sQuery);
            ps.setInt(1,serverid);
            ps.setInt(2,Integer.parseInt(transactionid.split("\\.")[0]));
            ResultSet rs = ps.executeQuery();
            while (rs.next()){
                //For every transaction ID, let's create a Labrequest
                labRequest.setServerid(rs.getInt("serverid"));
                labRequest.setTransactionid(rs.getInt("transactionid"));
                labRequest.setPersonid(rs.getInt("patientid"));
                labRequest.setPatientgender(rs.getString("gender"));
                labRequest.setPatientname(rs.getString("firstname")+" "+rs.getString("lastname"));
                labRequest.setRequestdate(rs.getTimestamp("updatetime"));
                labRequest.setUserid(rs.getInt("userid"));
                labRequest.setPatientdateofbirth(rs.getDate("dateofbirth"));
                Encounter encounter = Encounter.getActiveEncounter(labRequest.getPersonid()+"");
                if(encounter!=null){
                    if(encounter.getService()!=null){
                        labRequest.setServicename(encounter.getService().getLabel(language));
                    }
                }
            }
            rs.close();
            ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
        return labRequest;
    }

    public LabRequest(int serverid,int transactionid){
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sQuery="select distinct d.language,a.serverid,a.transactionid,a.patientid,d.gender,d.firstname,d.lastname,b.userid,d.dateofbirth,b.updatetime,b.creationdate from RequestedLabAnalyses a, Transactions b, AdminView d where a.serverid=b.serverid and a.transactionId=b.transactionId and a.patientid=d.personid and a.serverid=? and a.transactionid=?";
            PreparedStatement ps = oc_conn.prepareStatement(sQuery);
            ps.setInt(1,serverid);
            ps.setInt(2,transactionid);
            ResultSet rs = ps.executeQuery();
            while (rs.next()){
                String language=rs.getString("language");
                if(language==null){
                    language="f";
                }
                //For every transaction ID, let's create a Labrequest
                setServerid(rs.getInt("serverid"));
                setTransactionid(rs.getInt("transactionid"));
                setPersonid(rs.getInt("patientid"));
                setPatientgender(rs.getString("gender"));
                setPatientname(rs.getString("firstname")+" "+rs.getString("lastname"));
                setRequestdate(rs.getTimestamp("creationdate"));
                setUserid(rs.getInt("userid"));
                setPatientdateofbirth(rs.getDate("dateofbirth"));
                Encounter encounter = Encounter.getActiveEncounter(getPersonid()+"");
                if(encounter!=null){
                    if(encounter.getService()!=null){
                        setServicename(encounter.getService().getLabel(language));
                    }
                }
                loadRequestAnalyses();
            }
            rs.close();
            ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
    }
    
    public String getResultValue(String analysiscode){
    	String result="";
    	RequestedLabAnalysis labanalysis = (RequestedLabAnalysis)analyses.get(analysiscode);
    	if(labanalysis!=null){
    		LabAnalysis l = LabAnalysis.getLabAnalysisByLabcode(labanalysis.getAnalysisCode());
    		if(l!=null && l.getEditorparameters().startsWith("OP:CONC|")){
    			String s=l.getEditorparameters().replaceAll("OP:CONC\\|", "");
    			String[] sPars = s.split(",");
    			for(int n=0;n<sPars.length;n++){
    				if(getAnalyses().get(sPars[n].replaceAll("@", ""))!=null){
    					result+=((RequestedLabAnalysis)getAnalyses().get(sPars[n].replaceAll("@", ""))).getResultValue();
    				}
    				else{
    					result="";
    					break;
    				}
    			}
    		}
    		else{
    			result=labanalysis.getResultValue();
    		}
    	}
    	return result;
    }

    public void loadRequestAnalyses(){
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sQuery="select a.*,b.labgroup from RequestedLabAnalyses a,LabAnalysis b where a.analysiscode=b.labcode and b.deletetime is null and serverid=? and transactionid=?";
            PreparedStatement ps = oc_conn.prepareStatement(sQuery);
            ps.setInt(1,getServerid());
            ps.setInt(2,getTransactionid());
            ResultSet rs = ps.executeQuery();
            while (rs.next()){
                RequestedLabAnalysis requestedLabAnalysis = new RequestedLabAnalysis();
                requestedLabAnalysis.setServerId(rs.getInt("serverid")+"");
                requestedLabAnalysis.setTransactionId(rs.getInt("transactionid")+"");
                requestedLabAnalysis.setLabgroup(rs.getString("labgroup"));
                requestedLabAnalysis.setAnalysisCode(rs.getString("analysiscode"));
                requestedLabAnalysis.setComment(getComment());
                requestedLabAnalysis.setPatientId(rs.getString("patientid"));
                requestedLabAnalysis.setRequestDate(new java.sql.Date(getRequestdate().getTime()));
                requestedLabAnalysis.setRequestUserId(getUserid()+"");
                requestedLabAnalysis.setResultComment(rs.getString("resultcomment"));
                requestedLabAnalysis.setResultDate(rs.getTimestamp("resultdate"));
                requestedLabAnalysis.setResultModifier(rs.getString("resultmodifier"));
                requestedLabAnalysis.setResultProvisional(rs.getString("resultprovisional"));
                setConfirmed(isConfirmed() && ScreenHelper.checkString(rs.getString("resultprovisional")).equalsIgnoreCase(""));
                requestedLabAnalysis.setResultRefMax(rs.getString("resultrefmax"));
                requestedLabAnalysis.setResultRefMin(rs.getString("resultrefmin"));
                requestedLabAnalysis.setResultUnit(rs.getString("resultunit"));
                requestedLabAnalysis.setResultUserId(rs.getString("resultuserid"));
                requestedLabAnalysis.setResultValue(rs.getString("resultvalue"));
                requestedLabAnalysis.setTechnicalvalidation(rs.getInt("technicalvalidator"));
                requestedLabAnalysis.setFinalvalidation(rs.getInt("finalvalidator"));
                java.util.Date d= rs.getTimestamp("technicalvalidationdatetime");
                if(d!=null){
                    requestedLabAnalysis.setTechnicalvalidationdatetime(new java.sql.Date(d.getTime()));
                }
                d= rs.getTimestamp("finalvalidationdatetime");
                if(d!=null){
                    requestedLabAnalysis.setFinalvalidationdatetime(new java.sql.Date(d.getTime()));
                }
                d= rs.getTimestamp("sampletakendatetime");
                if(d!=null){
                    requestedLabAnalysis.setSampletakendatetime(new java.sql.Date(d.getTime()));
                }
                d= rs.getTimestamp("samplereceptiondatetime");
                if(d!=null){
                    requestedLabAnalysis.setSamplereceptiondatetime(new java.sql.Date(d.getTime()));
                }
                d= rs.getTimestamp("worklisteddatetime");
                if(d!=null){
                    requestedLabAnalysis.setWorklisteddatetime(new java.sql.Date(d.getTime()));
                }
                requestedLabAnalysis.setSampler(rs.getInt("sampler"));
                getAnalyses().put(requestedLabAnalysis.getAnalysisCode(),requestedLabAnalysis);
            }
            rs.close();
            ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
    }

    public void loadUnvalidatedRequestAnalyses(){
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sQuery="select a.*,b.labgroup from RequestedLabAnalyses a,LabAnalysis b where a.analysiscode=b.labcode and b.deletetime is null and serverid=? and transactionid=? and finalvalidator is null";
            PreparedStatement ps = oc_conn.prepareStatement(sQuery);
            ps.setInt(1,getServerid());
            ps.setInt(2,getTransactionid());
            ResultSet rs = ps.executeQuery();
            while (rs.next()){
                RequestedLabAnalysis requestedLabAnalysis = new RequestedLabAnalysis();
                requestedLabAnalysis.setLabgroup(rs.getString("labgroup"));
                requestedLabAnalysis.setAnalysisCode(rs.getString("analysiscode"));
                requestedLabAnalysis.setComment(getComment());
                requestedLabAnalysis.setPatientId(rs.getString("patientid"));
                requestedLabAnalysis.setRequestDate(new java.sql.Date(getRequestdate().getTime()));
                requestedLabAnalysis.setRequestUserId(getUserid()+"");
                requestedLabAnalysis.setResultComment(rs.getString("resultcomment"));
                requestedLabAnalysis.setResultDate(rs.getTimestamp("resultdate"));
                requestedLabAnalysis.setResultModifier(rs.getString("resultmodifier"));
                requestedLabAnalysis.setResultProvisional(rs.getString("resultprovisional"));
                setConfirmed(isConfirmed() && ScreenHelper.checkString(rs.getString("resultprovisional")).equalsIgnoreCase(""));
                requestedLabAnalysis.setResultRefMax(rs.getString("resultrefmax"));
                requestedLabAnalysis.setResultRefMin(rs.getString("resultrefmin"));
                requestedLabAnalysis.setResultUnit(rs.getString("resultunit"));
                requestedLabAnalysis.setResultUserId(rs.getString("resultuserid"));
                requestedLabAnalysis.setResultValue(rs.getString("resultvalue"));
                requestedLabAnalysis.setTechnicalvalidation(rs.getInt("technicalvalidator"));
                requestedLabAnalysis.setFinalvalidation(rs.getInt("finalvalidator"));
                java.util.Date d= rs.getTimestamp("technicalvalidationdatetime");
                if(d!=null){
                    requestedLabAnalysis.setTechnicalvalidationdatetime(new java.sql.Date(d.getTime()));
                }
                d= rs.getTimestamp("finalvalidationdatetime");
                if(d!=null){
                    requestedLabAnalysis.setFinalvalidationdatetime(new java.sql.Date(d.getTime()));
                }
                d= rs.getTimestamp("sampletakendatetime");
                if(d!=null){
                    requestedLabAnalysis.setSampletakendatetime(new java.sql.Date(d.getTime()));
                }
                d= rs.getTimestamp("samplereceptiondatetime");
                if(d!=null){
                    requestedLabAnalysis.setSamplereceptiondatetime(new java.sql.Date(d.getTime()));
                }
                d= rs.getTimestamp("worklisteddatetime");
                if(d!=null){
                    requestedLabAnalysis.setWorklisteddatetime(new java.sql.Date(d.getTime()));
                }
                requestedLabAnalysis.setSampler(rs.getInt("sampler"));
                getAnalyses().put(requestedLabAnalysis.getAnalysisCode(),requestedLabAnalysis);
            }
            rs.close();
            ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
    }

    public static Vector findOpenRequests(String worklistAnalyses,String language){
        Vector results = new Vector();
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            //First let's find all transactionid's for which at least one result is open
            String sQuery="select distinct a.serverid,a.transactionid,a.patientid,d.gender,d.firstname,d.lastname,b.userid,d.dateofbirth,b.updatetime from RequestedLabAnalyses a, Transactions b, AdminView d where a.serverid=b.serverid and a.transactionId=b.transactionId and a.patientid=d.personid and analysiscode in ("+worklistAnalyses+") and worklisteddatetime is not null and finalvalidator is null and finalvalidationdatetime is null and (resultvalue is null or resultvalue='' or technicalvalidator is null)";
            PreparedStatement ps = oc_conn.prepareStatement(sQuery);
            ResultSet rs = ps.executeQuery();
            while (rs.next()){
                //For every transaction ID, let's create a Labrequest
                LabRequest labRequest = new LabRequest();
                labRequest.setServerid(rs.getInt("serverid"));
                labRequest.setTransactionid(rs.getInt("transactionid"));
                labRequest.setPersonid(rs.getInt("patientid"));
                labRequest.setPatientgender(rs.getString("gender"));
                labRequest.setPatientname(rs.getString("firstname")+" "+rs.getString("lastname"));
                labRequest.setRequestdate(rs.getTimestamp("updatetime"));
                labRequest.setUserid(rs.getInt("userid"));
                labRequest.setPatientdateofbirth(rs.getDate("dateofbirth"));
                Encounter encounter = Encounter.getActiveEncounter(labRequest.getPersonid()+"");
                if(encounter!=null){
                    if(encounter.getService()!=null){
                        labRequest.setServicename(encounter.getService().getLabel(language));
                    }
                }
                labRequest.loadRequestAnalyses(worklistAnalyses);
                results.add(labRequest);
            }
            rs.close();
            ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
        return results;
    }

    public static Vector findMyValidatedRequestsSince(int userid,java.util.Date date,String language,int maxresults){
        Vector results = new Vector();
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            //First let's find all transactionid's for which at least one result is open
            String sQuery="select distinct a.serverid,a.transactionid,a.patientid,d.gender,d.firstname,d.lastname,b.userid,d.dateofbirth,b.updatetime from RequestedLabAnalyses a, Transactions b, AdminView d where a.serverid=b.serverid and a.transactionId=b.transactionId and a.patientid=d.personid and b.userid=? and finalvalidationdatetime >= ?";
            PreparedStatement ps = oc_conn.prepareStatement(sQuery);
            ps.setInt(1,userid);
            ps.setTimestamp(2,new Timestamp(date.getTime()));
            ResultSet rs = ps.executeQuery();
            while (rs.next() && results.size()<maxresults){
                //For every transaction ID, let's create a Labrequest
                LabRequest labRequest = new LabRequest();
                labRequest.setServerid(rs.getInt("serverid"));
                labRequest.setTransactionid(rs.getInt("transactionid"));
                labRequest.setPersonid(rs.getInt("patientid"));
                labRequest.setPatientgender(rs.getString("gender"));
                labRequest.setPatientname(rs.getString("firstname")+" "+rs.getString("lastname"));
                labRequest.setRequestdate(rs.getTimestamp("updatetime"));
                labRequest.setUserid(rs.getInt("userid"));
                labRequest.setPatientdateofbirth(rs.getDate("dateofbirth"));
                Encounter encounter = Encounter.getActiveEncounter(labRequest.getPersonid()+"");
                if(encounter!=null){
                    if(encounter.getService()!=null){
                        labRequest.setServicename(encounter.getService().getLabel(language));
                    }
                }
                labRequest.loadRequestAnalyses();
                results.add(labRequest);
            }
            rs.close();
            ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
        return results;
    }

    public static Vector findServiceValidatedRequestsSince(String serviceid,java.util.Date date,String language,int maxresults){
        Vector results = new Vector();
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            //First let's find all transactionid's for which at least one result is open
            String sQuery="select distinct a.serverid,a.transactionid,a.patientid,d.gender,d.firstname,d.lastname,b.userid,d.dateofbirth,b.updatetime " +
                    " from RequestedLabAnalyses a, Transactions b, AdminView d, OC_ENCOUNTERS e, OC_ENCOUNTER_SERVICES f" +
                    " where" +
                    " e.OC_ENCOUNTER_SERVERID=f.OC_ENCOUNTER_SERVERID AND" +
                    " e.OC_ENCOUNTER_OBJECTID=f.OC_ENCOUNTER_OBJECTID AND"+
                    " a.patientid="+ MedwanQuery.getInstance().convert("int","e.OC_ENCOUNTER_PATIENTUID")+" and" +
                    " f.OC_ENCOUNTER_SERVICEUID like ? and" +
                    " a.serverid=b.serverid and" +
                    " a.transactionId=b.transactionId and" +
                    " a.patientid=d.personid and" +
                    " finalvalidationdatetime >= ?";
            PreparedStatement ps = oc_conn.prepareStatement(sQuery);
            ps.setString(1,serviceid+"%");
            ps.setTimestamp(2,new Timestamp(date.getTime()));
            ResultSet rs = ps.executeQuery();
            while (rs.next() && results.size()<maxresults){
                //For every transaction ID, let's create a Labrequest
                LabRequest labRequest = new LabRequest();
                labRequest.setServerid(rs.getInt("serverid"));
                labRequest.setTransactionid(rs.getInt("transactionid"));
                labRequest.setPersonid(rs.getInt("patientid"));
                labRequest.setPatientgender(rs.getString("gender"));
                labRequest.setPatientname(rs.getString("firstname")+" "+rs.getString("lastname"));
                labRequest.setRequestdate(rs.getTimestamp("updatetime"));
                labRequest.setUserid(rs.getInt("userid"));
                labRequest.setPatientdateofbirth(rs.getDate("dateofbirth"));
                Encounter encounter = Encounter.getActiveEncounter(labRequest.getPersonid()+"");
                if(encounter!=null){
                    if(encounter.getService()!=null){
                        labRequest.setServicename(encounter.getServiceUID()+" "+encounter.getService().getLabel(language));
                    }
                }
                labRequest.loadRequestAnalyses();
                results.add(labRequest);
            }
            rs.close();
            ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
        return results;
    }

    public static Vector findUnvalidatedRequests(String worklistAnalyses,String language,int type){
        Vector results = new Vector();
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            //First let's find all transactionid's for which at least one result is open
            String sQuery="select distinct a.serverid,a.transactionid,a.patientid,d.gender,d.firstname,d.lastname,b.userid,d.dateofbirth,b.updatetime from RequestedLabAnalyses a, Transactions b, AdminView d where a.serverid=b.serverid and a.transactionId=b.transactionId and a.patientid=d.personid and analysiscode in ("+worklistAnalyses+") and worklisteddatetime>? and finalvalidationdatetime is null and not (resultvalue is null or resultvalue='')";
            if(type==1){
                 sQuery+=" and finalvalidator is null";
            }
            else if(type==0) {
                sQuery+=" and technicalvalidator is null";
            }
            PreparedStatement ps = oc_conn.prepareStatement(sQuery);
            long hour=3600*1000;
            long day = 24*hour;
            ps.setDate(1, new Date(new java.util.Date().getTime()-90*day));
            ResultSet rs = ps.executeQuery();
            while (rs.next()){
                //For every transaction ID, let's create a Labrequest
                LabRequest labRequest = new LabRequest();
                labRequest.setServerid(rs.getInt("serverid"));
                labRequest.setTransactionid(rs.getInt("transactionid"));
                labRequest.setPersonid(rs.getInt("patientid"));
                labRequest.setPatientgender(rs.getString("gender"));
                labRequest.setPatientname(rs.getString("firstname")+" "+rs.getString("lastname"));
                labRequest.setRequestdate(rs.getTimestamp("updatetime"));
                labRequest.setUserid(rs.getInt("userid"));
                labRequest.setPatientdateofbirth(rs.getDate("dateofbirth"));
                Encounter encounter = Encounter.getActiveEncounter(labRequest.getPersonid()+"");
                if(encounter!=null){
                    if(encounter.getService()!=null){
                        labRequest.setServicename(encounter.getService().getLabel(language));
                    }
                }
                labRequest.loadRequestAnalyses(worklistAnalyses);
                results.add(labRequest);
            }
            rs.close();
            ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
        return results;
    }

    public static Vector findUntreatedRequests(String language,int personid){
        Vector results = new Vector();
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            //First let's find all transactionid's for which at least one result is open
            String sQuery="select distinct a.serverid,a.transactionid,a.patientid,d.gender,d.firstname,d.lastname,b.userid,d.dateofbirth,b.updatetime from RequestedLabAnalyses a, Transactions b, AdminView d, Labanalysis e where a.serverid=b.serverid and a.transactionId=b.transactionId and a.patientid=d.personid and a.analysiscode=e.labcode and e.editor not in ('calculated','virtual') and finalvalidationdatetime is null and patientid=?";
            PreparedStatement ps = oc_conn.prepareStatement(sQuery);
            ps.setInt(1,personid);
            ResultSet rs = ps.executeQuery();
            while (rs.next()){
                //For every transaction ID, let's create a Labrequest
                LabRequest labRequest = new LabRequest();
                labRequest.setServerid(rs.getInt("serverid"));
                labRequest.setTransactionid(rs.getInt("transactionid"));
                labRequest.setPersonid(rs.getInt("patientid"));
                labRequest.setPatientgender(rs.getString("gender"));
                labRequest.setPatientname(rs.getString("firstname")+" "+rs.getString("lastname"));
                labRequest.setRequestdate(rs.getTimestamp("updatetime"));
                labRequest.setUserid(rs.getInt("userid"));
                labRequest.setPatientdateofbirth(rs.getDate("dateofbirth"));
                Encounter encounter = Encounter.getActiveEncounter(labRequest.getPersonid()+"");
                if(encounter!=null){
                    if(encounter.getService()!=null){
                        labRequest.setServicename(encounter.getService().getLabel(language));
                    }
                }
                labRequest.loadRequestAnalyses();
                results.add(labRequest);
            }
            rs.close();
            ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
        return results;
    }

    public static Vector findMyUntreatedRequests(String language,int userid){
        Vector results = new Vector();
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            //First let's find all transactionid's for which at least one result is open
            String sQuery="select distinct a.serverid,a.transactionid,a.patientid,d.gender,d.firstname,d.lastname,b.userid,d.dateofbirth,b.updatetime from RequestedLabAnalyses a, Transactions b, AdminView d where a.serverid=b.serverid and a.transactionId=b.transactionId and a.patientid=d.personid and finalvalidationdatetime is null and b.userid=?";
            PreparedStatement ps = oc_conn.prepareStatement(sQuery);
            ps.setInt(1,userid);
            ResultSet rs = ps.executeQuery();
            while (rs.next()){
                //For every transaction ID, let's create a Labrequest
                LabRequest labRequest = new LabRequest();
                labRequest.setServerid(rs.getInt("serverid"));
                labRequest.setTransactionid(rs.getInt("transactionid"));
                labRequest.setPersonid(rs.getInt("patientid"));
                labRequest.setPatientgender(rs.getString("gender"));
                labRequest.setPatientname(rs.getString("firstname")+" "+rs.getString("lastname"));
                labRequest.setRequestdate(rs.getTimestamp("updatetime"));
                labRequest.setUserid(rs.getInt("userid"));
                labRequest.setPatientdateofbirth(rs.getDate("dateofbirth"));
                Encounter encounter = Encounter.getActiveEncounter(labRequest.getPersonid()+"");
                if(encounter!=null){
                    if(encounter.getService()!=null){
                        labRequest.setServicename(encounter.getService().getLabel(language));
                    }
                }
                labRequest.loadUnvalidatedRequestAnalyses();
                results.add(labRequest);
            }
            rs.close();
            ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
        return results;
    }

    public static Vector findNotOnWorklistRequests(String worklistAnalyses,String language){
        Vector results = new Vector();
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            //First let's find all transactionid's for which at least one result is open
            String sQuery="select distinct a.serverid,a.transactionid,a.patientid,d.gender,d.firstname,d.lastname,b.userid,d.dateofbirth,b.updatetime from RequestedLabAnalyses a, Transactions b, AdminView d where a.serverid=b.serverid and a.transactionId=b.transactionId and a.patientid=d.personid and analysiscode in ("+worklistAnalyses+") and worklisteddatetime is null and finalvalidationdatetime is null and samplereceptiondatetime is not null";
            PreparedStatement ps = oc_conn.prepareStatement(sQuery);
            ResultSet rs = ps.executeQuery();
            while (rs.next()){
                //For every transaction ID, let's create a Labrequest
                LabRequest labRequest = new LabRequest();
                labRequest.setServerid(rs.getInt("serverid"));
                labRequest.setTransactionid(rs.getInt("transactionid"));
                labRequest.setPersonid(rs.getInt("patientid"));
                labRequest.setPatientgender(rs.getString("gender"));
                labRequest.setPatientname(rs.getString("firstname")+" "+rs.getString("lastname"));
                labRequest.setRequestdate(rs.getTimestamp("updatetime"));
                labRequest.setUserid(rs.getInt("userid"));
                labRequest.setPatientdateofbirth(rs.getDate("dateofbirth"));
                Encounter encounter = Encounter.getActiveEncounter(labRequest.getPersonid()+"");
                if(encounter!=null){
                    if(encounter.getService()!=null){
                        labRequest.setServicename(encounter.getService().getLabel(language));
                    }
                }
                labRequest.loadRequestAnalyses(worklistAnalyses);
                results.add(labRequest);
            }
            rs.close();
            ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
        return results;
    }

    public static Vector findRequestList(int personid){
        Vector results=new Vector();
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            //First let's find all transactionid's for which at least one result is open
            String sQuery="select distinct a.serverid,a.transactionid,b.updatetime from RequestedLabAnalyses a, Transactions b where a.serverid=b.serverid and a.transactionId=b.transactionId and a.patientid=? order by b.updatetime desc";
            PreparedStatement ps = oc_conn.prepareStatement(sQuery);
            ps.setInt(1,personid);
            ResultSet rs = ps.executeQuery();
            while (rs.next()){
                //For every transaction ID, let's create a Labrequest
                LabRequest labRequest = new LabRequest();
                labRequest.setServerid(rs.getInt("serverid"));
                labRequest.setTransactionid(rs.getInt("transactionid"));
                labRequest.setRequestdate(rs.getTimestamp("updatetime"));
                results.add(labRequest);
            }
            rs.close();
            ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
        return results;
    }

    public static Vector findRequestsSince(String worklistAnalyses,java.util.Date date,String language){
                Vector results = new Vector();
                Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            //First let's find all transactionid's for which at least one result is open
            String sQuery="select distinct a.serverid,a.transactionid,a.patientid,d.gender,d.firstname,d.lastname,b.userid,d.dateofbirth,b.updatetime from RequestedLabAnalyses a, Transactions b, AdminView d where a.serverid=b.serverid and a.transactionId=b.transactionId and a.patientid=d.personid and analysiscode in ("+worklistAnalyses+") and finalvalidationdatetime is null worklisteddatetime>?";
            PreparedStatement ps = oc_conn.prepareStatement(sQuery);
            ps.setDate(1,new java.sql.Date(date.getTime()));
            ResultSet rs = ps.executeQuery();
            while (rs.next()){
                //For every transaction ID, let's create a Labrequest
                LabRequest labRequest = new LabRequest();
                labRequest.setServerid(rs.getInt("serverid"));
                labRequest.setTransactionid(rs.getInt("transactionid"));
                labRequest.setPersonid(rs.getInt("patientid"));
                labRequest.setPatientgender(rs.getString("gender"));
                labRequest.setPatientname(rs.getString("firstname")+" "+rs.getString("lastname"));
                labRequest.setRequestdate(rs.getTimestamp("updatetime"));
                labRequest.setUserid(rs.getInt("userid"));
                labRequest.setPatientdateofbirth(rs.getDate("dateofbirth"));
                Encounter encounter = Encounter.getActiveEncounter(labRequest.getPersonid()+"");
                if(encounter!=null){
                    if(encounter.getService()!=null){
                        labRequest.setServicename(encounter.getService().getLabel(language));
                    }
                }
                labRequest.loadRequestAnalyses(worklistAnalyses);
                results.add(labRequest);
            }
            rs.close();
            ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
        return results;
    }

    public static Vector findUnsampledRequests(String service,String language){
        Hashtable transactions = new Hashtable();
    	Vector requests=new Vector();
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
        	String sQuery="select serverid,transactionid,requestdatetime " +
                    " from RequestedLabAnalyses a, OC_ENCOUNTERS b,OC_ENCOUNTER_SERVICES c" +
                    " where" +
                    " b.OC_ENCOUNTER_SERVERID=c.OC_ENCOUNTER_SERVERID AND" +
                    " b.OC_ENCOUNTER_OBJECTID=c.OC_ENCOUNTER_OBJECTID AND"+
                    " a.patientid="+ MedwanQuery.getInstance().convert("int","b.OC_ENCOUNTER_PATIENTUID")+" and" +
                    " sampletakendatetime is null and" +
                    " samplereceptiondatetime is null and"+
                    " requestdatetime>? and"+
                    " c.OC_ENCOUNTER_SERVICEUID like ?" +
                    " order by requestdatetime desc";
            if (service==null || service.length()==0){
            	sQuery="select serverid,transactionid,requestdatetime" +
                " from RequestedLabAnalyses" +
                " where" +
                " sampletakendatetime is null and" +
                " samplereceptiondatetime is null and"+
                " requestdatetime >?"+
                " order by requestdatetime desc";
            }
            PreparedStatement ps = oc_conn.prepareStatement(sQuery);
            long oneWeekAgo= new java.util.Date().getTime();
            oneWeekAgo-=1000*3600*24*7;
            ps.setDate(1,new java.sql.Date(oneWeekAgo));
            if (service!=null && service.length()>0){
            	ps.setString(2,service+"%");
            }
            ResultSet rs = ps.executeQuery();
            int serverid,transactionid;
            while (rs.next()){
            	serverid=rs.getInt("serverid");
            	transactionid=rs.getInt("transactionid");
            	if(transactions.get(serverid+"."+transactionid)==null){
            		requests.add(LabRequest.getUnsampledRequest(serverid,transactionid+"",language));
            		transactions.put(serverid+"."+transactionid, "1");
            	}
            }
            rs.close();
            ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
        return requests;
    }

    public static Vector findUnreceivedRequests(String language){
        Vector requests=new Vector();
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sQuery="select distinct serverid,transactionid" +
                    " from RequestedLabAnalyses a" +
                    " where" +
                    " samplereceptiondatetime is null and (resultvalue is null or resultvalue='') and finalvalidationdatetime is null and requestdatetime>?" +
                    " order by serverid,transactionid";
            PreparedStatement ps = oc_conn.prepareStatement(sQuery);
            long week = 60000*60*24*7;
            ps.setTimestamp(1, new java.sql.Timestamp(new java.util.Date().getTime()-week));
            ResultSet rs = ps.executeQuery();
            String activerequest="";
            while (rs.next()){
                int serverid=rs.getInt("serverid");
                int transactionid=rs.getInt("transactionid");
                if(!activerequest.equalsIgnoreCase(serverid+"."+transactionid)){
                    requests.add(LabRequest.getUnsampledRequest(serverid,transactionid+"",language));
                    activerequest=serverid+"."+transactionid;
                }
            }
            rs.close();
            ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
        return requests;
    }

    public Hashtable findOpenSamples(String language){
        Hashtable samples = new Hashtable();
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sQuery="select a.*,b.monster from RequestedLabAnalyses a, LabAnalysis b where a.analysiscode=b.labcode and b.deletetime is null and serverid=? and transactionid=? and sampletakendatetime is null and samplereceptiondatetime is null";
            PreparedStatement ps = oc_conn.prepareStatement(sQuery);
            ps.setInt(1,getServerid());
            ps.setInt(2,getTransactionid());
            ResultSet rs = ps.executeQuery();
            while (rs.next()){
                String monster=rs.getString("monster");
                if(monster==null || monster.trim().length()==0){
                    monster="?";
                }
                LabSample labSample=(LabSample)samples.get(monster);
                if(labSample==null){
                    labSample=new LabSample();
                }
                labSample.analyses.add(MedwanQuery.getInstance().getLabel("labanalysis",rs.getString("analysiscode"),language));
                labSample.type=ScreenHelper.checkDbString(monster);
                samples.put(monster,labSample);
            }
            rs.close();
            ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
        return samples;
    }

    public Hashtable findUnreceivedSamples(String language){
        Hashtable samples = new Hashtable();
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sQuery="select a.*,b.monster from RequestedLabAnalyses a, LabAnalysis b where a.analysiscode=b.labcode and b.deletetime is null and serverid=? and transactionid=? and samplereceptiondatetime is null";
            PreparedStatement ps = oc_conn.prepareStatement(sQuery);
            ps.setInt(1,getServerid());
            ps.setInt(2,getTransactionid());
            ResultSet rs = ps.executeQuery();
            while (rs.next()){
                String monster=rs.getString("monster");
                if(monster==null || monster.trim().length()==0){
                    monster="?";
                }
                LabSample labSample=(LabSample)samples.get(monster);
                if(labSample==null){
                    labSample=new LabSample();
                }
                labSample.analyses.add(MedwanQuery.getInstance().getLabel("labanalysis",rs.getString("analysiscode"),language));
                labSample.type=ScreenHelper.checkDbString(monster);
                samples.put(monster,labSample);
            }
            rs.close();
            ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
        return samples;
    }

    public Hashtable findAllSamples(String language){
        Hashtable samples = new Hashtable();
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sQuery="select a.*,b.monster from RequestedLabAnalyses a, LabAnalysis b where a.analysiscode=b.labcode and b.deletetime is null and serverid=? and transactionid=?";
            PreparedStatement ps = oc_conn.prepareStatement(sQuery);
            ps.setInt(1,getServerid());
            ps.setInt(2,getTransactionid());
            ResultSet rs = ps.executeQuery();
            while (rs.next()){
                String monster=rs.getString("monster");
                if(monster==null || monster.trim().length()==0){
                    monster="?";
                }
                LabSample labSample=(LabSample)samples.get(monster);
                if(labSample==null){
                    labSample=new LabSample();
                }
                labSample.analyses.add(MedwanQuery.getInstance().getLabel("labanalysis",rs.getString("analysiscode"),language));
                labSample.type=ScreenHelper.checkDbString(monster);
                samples.put(monster,labSample);
            }
            rs.close();
            ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
        return samples;
    }

    public static void setSampleTaken(int serverid,int transactionid,String sample,int userid){
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            if(sample!=null && !sample.equalsIgnoreCase("?")){
            	try {
	            	String sQuery="update RequestedLabAnalyses set sampletakendatetime=?,sampler=? from RequestedLabAnalyses a, LabAnalysis b where a.analysiscode=b.labcode and b.deletetime is null and serverid=? and transactionid=? and b.monster=? and sampletakendatetime is null";
	                PreparedStatement ps = oc_conn.prepareStatement(sQuery);
	                ps.setTimestamp(1,new java.sql.Timestamp(new java.util.Date().getTime()));
	                ps.setInt(2,userid);
	                ps.setInt(3,serverid);
	                ps.setInt(4,transactionid);
	                ps.setString(5,sample);
	                ps.executeUpdate();
	                ps.close();
            	}
            	catch (Exception es){
	            	String sQuery="update RequestedLabAnalyses a, LabAnalysis b set a.sampletakendatetime=?,a.sampler=? where a.analysiscode=b.labcode and b.deletetime is null and serverid=? and transactionid=? and b.monster=? and sampletakendatetime is null";
	                PreparedStatement ps = oc_conn.prepareStatement(sQuery);
	                ps.setTimestamp(1,new java.sql.Timestamp(new java.util.Date().getTime()));
	                ps.setInt(2,userid);
	                ps.setInt(3,serverid);
	                ps.setInt(4,transactionid);
	                ps.setString(5,sample);
	                ps.executeUpdate();
	                ps.close();
            	}
            }
            else {
            	try {
	                String sQuery="update RequestedLabAnalyses set sampletakendatetime=?,sampler=? from RequestedLabAnalyses a, LabAnalysis b where a.analysiscode=b.labcode and b.deletetime is null and serverid=? and transactionid=? and (b.monster is null or b.monster='') and sampletakendatetime is null";
	                PreparedStatement ps = oc_conn.prepareStatement(sQuery);
	                ps.setTimestamp(1,new java.sql.Timestamp(new java.util.Date().getTime()));
	                ps.setInt(2,userid);
	                ps.setInt(3,serverid);
	                ps.setInt(4,transactionid);
	                ps.executeUpdate();
	                ps.close();
            	}
            	catch (Exception es){
	                String sQuery="update RequestedLabAnalyses a, LabAnalysis b set sampletakendatetime=?,sampler=? where a.analysiscode=b.labcode and b.deletetime is null and serverid=? and transactionid=? and (b.monster is null or b.monster='') and sampletakendatetime is null";
	                PreparedStatement ps = oc_conn.prepareStatement(sQuery);
	                ps.setTimestamp(1,new java.sql.Timestamp(new java.util.Date().getTime()));
	                ps.setInt(2,userid);
	                ps.setInt(3,serverid);
	                ps.setInt(4,transactionid);
	                ps.executeUpdate();
	                ps.close();
            	}
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
    }

    public boolean hasBacteriology(){
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        boolean bBact=false;
        try{
            PreparedStatement ps = oc_conn.prepareStatement("select count(*) as total from OC_ANTIBIOGRAMS where OC_AB_REQUESTEDLABANALYSISUID like '"+this.getServerid()+"."+this.getTransactionid()+"%'");
            ResultSet rs = ps.executeQuery();
            bBact=rs.next() && rs.getInt("total")>0;
            rs.close();
            ps.close();
        }
        catch(Exception e){
        	e.printStackTrace();
        }
        finally{
            try{
    			oc_conn.close();
            }
            catch(Exception e){
            	e.printStackTrace();
            }
        }
        return bBact;
    }
    
    public static void setSampleReceived(int serverid,int transactionid,String sample){
    	setSampleReceived(serverid, transactionid, sample,-1);
    }
    public static void setSampleReceived(int serverid,int transactionid,String sample,int userid){
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            if(sample!=null && !sample.equalsIgnoreCase("?")){
                try{
                	//basic code Microsoft SQL server
	            	String sQuery="update RequestedLabAnalyses set samplereceptiondatetime=?, sampler=? from RequestedLabAnalyses a, LabAnalysis b where a.analysiscode=b.labcode and b.deletetime is null and serverid=? and transactionid=? and b.monster=? and samplereceptiondatetime is null";
	                PreparedStatement ps = oc_conn.prepareStatement(sQuery);
	                ps.setTimestamp(1,new java.sql.Timestamp(new java.util.Date().getTime()));
	                ps.setInt(2,userid);
	                ps.setInt(3,serverid);
	                ps.setInt(4,transactionid);
	                ps.setString(5,sample);
	                ps.executeUpdate();
	                ps.close();
                }
                catch(Exception e2){
                	//alternative code MySQL
	            	String sQuery="update RequestedLabAnalyses a, LabAnalysis b set a.samplereceptiondatetime=?, sampler=?  where a.analysiscode=b.labcode and b.deletetime is null and serverid=? and transactionid=? and b.monster=? and samplereceptiondatetime is null";
	                PreparedStatement ps = oc_conn.prepareStatement(sQuery);
	                ps.setTimestamp(1,new java.sql.Timestamp(new java.util.Date().getTime()));
	                ps.setInt(2,userid);
	                ps.setInt(3,serverid);
	                ps.setInt(4,transactionid);
	                ps.setString(5,sample);
	                ps.executeUpdate();
	                ps.close();
                }
            }
            else {
                try{
                	//basic code Microsoft SQL server
	                String sQuery="update RequestedLabAnalyses set samplereceptiondatetime=?, sampler=? from RequestedLabAnalyses a, LabAnalysis b where a.analysiscode=b.labcode and b.deletetime is null and serverid=? and transactionid=? and (b.monster is null or b.monster='') and samplereceptiondatetime is null";
	                PreparedStatement ps = oc_conn.prepareStatement(sQuery);
	                ps.setTimestamp(1,new java.sql.Timestamp(new java.util.Date().getTime()));
	                ps.setInt(2,userid);
	                ps.setInt(3,serverid);
	                ps.setInt(4,transactionid);
	                ps.executeUpdate();
	                ps.close();
                }
                catch(Exception e2){
                	//alternative code MySQL
	                String sQuery="update RequestedLabAnalyses a, LabAnalysis b set a.samplereceptiondatetime=?, sampler=? where a.analysiscode=b.labcode and b.deletetime is null and serverid=? and transactionid=? and (b.monster is null or b.monster='') and samplereceptiondatetime is null";
	                PreparedStatement ps = oc_conn.prepareStatement(sQuery);
	                ps.setTimestamp(1,new java.sql.Timestamp(new java.util.Date().getTime()));
	                ps.setInt(2,userid);
	                ps.setInt(3,serverid);
	                ps.setInt(4,transactionid);
	                ps.executeUpdate();
	                ps.close();
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
    }

}
