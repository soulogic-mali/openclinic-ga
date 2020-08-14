package pe.gob.sis;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.Vector;

import be.mxs.common.model.vo.healthrecord.ItemVO;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.adt.Encounter;
import be.openclinic.common.OC_Object;
import be.openclinic.finance.Debet;
import be.openclinic.finance.Insurance;
import be.openclinic.finance.Insurar;
import be.openclinic.hr.Contract;
import be.openclinic.knowledge.Indication;
import be.openclinic.medical.Diagnosis;
import be.openclinic.medical.Prescription;
import net.admin.User;

public class FUA extends OC_Object{
	int personId;
	String encounteruid;
	Encounter encounter=null;
	Date date;
	String status;
	byte[] patientFingerPrint;
	int patientFingerPrintMatchScore;
	Date patientSignatureDateTime;
	Date sentDateTime;
	int signatureUser;
	Date signatureUserDateTime;
	Atencion atencion = null;
	Vector diagnosticos = new Vector();;
	Vector medicamentos = new Vector();
	Vector smi = new Vector();
	Vector insumos = new Vector();
	Vector procedimientos = new Vector();
	RecienNacido recienNacido = null;
	Vector serviciosAdicionales = new Vector();
	
	public String getErrors(){
		String errors="";
		SortedSet hErrors = new TreeSet();
		String[] s = atencion.getErrors().split(",");
		for(int n=0;n<s.length;n++){
			if(s[n].length()>0){
				hErrors.add("A"+s[n]);
			}
		}
		for(int i=0;i<diagnosticos.size();i++){
			Diagnosticos d = (Diagnosticos)diagnosticos.elementAt(i);
			s = d.getErrors().split(",");
			for(int n=0;n<s.length;n++){
				if(s[n].length()>0){
					hErrors.add("D"+s[n]);
				}
			}
		}
		for(int i=0;i<medicamentos.size();i++){
			Medicamentos d = (Medicamentos)medicamentos.elementAt(i);
			s = d.getErrors().split(",");
			for(int n=0;n<s.length;n++){
				if(s[n].length()>0){
					hErrors.add("M"+s[n]);
				}
			}
		}
		for(int i=0;i<insumos.size();i++){
			Insumos d = (Insumos)insumos.elementAt(i);
			s = d.getErrors().split(",");
			for(int n=0;n<s.length;n++){
				if(s[n].length()>0){
					hErrors.add("I"+s[n]);
				}
			}
		}
		for(int i=0;i<procedimientos.size();i++){
			Procedimientos d = (Procedimientos)procedimientos.elementAt(i);
			s = d.getErrors().split(",");
			for(int n=0;n<s.length;n++){
				if(s[n].length()>0){
					hErrors.add("P"+s[n]);
				}
			}
		}
		Iterator iErrors = hErrors.iterator();
		while(iErrors.hasNext()){
			if(errors.length()>0){
				errors+=",";
			}
			errors+=iErrors.next();
		}
		return errors;
	}
	
	public Encounter getEncounter(){
		if(encounter==null){
			encounter = Encounter.get(encounteruid);
		}
		return encounter;
	}
	public String getEncounteruid() {
		return encounteruid;
	}
	public void setEncounteruid(String encounteruid) {
		this.encounteruid = encounteruid;
	}
	public Atencion getAtencion() {
		return atencion;
	}
	public void setAtencion(Atencion atencion) {
		this.atencion = atencion;
	}
	public Vector getDiagnosticos() {
		return diagnosticos;
	}
	public void setDiagnosticos(Vector diagnosticos) {
		this.diagnosticos = diagnosticos;
	}
	public Vector getMedicamentos() {
		return medicamentos;
	}
	public void setMedicamentos(Vector medicamentos) {
		this.medicamentos = medicamentos;
	}
	public Vector getSmi() {
		return smi;
	}
	public void setSmi(Vector smi) {
		this.smi = smi;
	}
	public Vector getInsumos() {
		return insumos;
	}
	public void setInsumos(Vector insumos) {
		this.insumos = insumos;
	}
	public Vector getProcedimientos() {
		return procedimientos;
	}
	public void setProcedimientos(Vector procedimientos) {
		this.procedimientos = procedimientos;
	}
	public RecienNacido getRecienNacido() {
		return recienNacido;
	}
	public void setRecienNacido(RecienNacido recienNacido) {
		this.recienNacido = recienNacido;
	}
	public Vector getServiciosAdicionales() {
		return serviciosAdicionales;
	}
	public void setServiciosAdicionales(Vector serviciosAdicionales) {
		this.serviciosAdicionales = serviciosAdicionales;
	}
	public int getSignatureUser() {
		return signatureUser;
	}
	public void setSignatureUser(int signatureUser) {
		this.signatureUser = signatureUser;
	}
	public Date getSignatureUserDateTime() {
		return signatureUserDateTime;
	}
	public void setSignatureUserDateTime(Date signatureUserDateTime) {
		this.signatureUserDateTime = signatureUserDateTime;
	}
	public int getPersonId() {
		return personId;
	}
	public void setPersonId(int personId) {
		this.personId = personId;
	}
	public Date getDate() {
		return date;
	}
	public void setDate(Date date) {
		this.date = date;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public byte[] getPatientFingerPrint() {
		return patientFingerPrint;
	}
	public void setPatientFingerPrint(byte[] patientFingerPrint) {
		this.patientFingerPrint = patientFingerPrint;
	}
	public int getPatientFingerPrintMatchScore() {
		return patientFingerPrintMatchScore;
	}
	public void setPatientFingerPrintMatchScore(int patientFingerPrintMatchScore) {
		this.patientFingerPrintMatchScore = patientFingerPrintMatchScore;
	}
	public Date getPatientSignatureDateTime() {
		return patientSignatureDateTime;
	}
	public void setPatientSignatureDateTime(Date patientSignatureDateTime) {
		this.patientSignatureDateTime = patientSignatureDateTime;
	}
	public Date getSentDateTime() {
		return sentDateTime;
	}
	public void setSentDateTime(Date sentDateTime) {
		this.sentDateTime = sentDateTime;
	}
	
	public static boolean isValidDIGEMID(String code){
		boolean bIsValid=true;
		if(code.length()==0){
			bIsValid=false;
		}
		return bIsValid;
	}
	
	public static boolean isValidCPT(String code){
		boolean bIsValid=true;
		if(code.length()==0){
			bIsValid=false;
		}
		return bIsValid;
	}
	
	public static Vector getEncountersWithUnregisteredFUAData(int days){
		Vector encounters = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			String sisids="";
			String[] ids = MedwanQuery.getInstance().getConfigString("SIS","1.29").split(",");
			for(int n = 0;n<ids.length;n++){
				if(sisids.length()>0){
					sisids+=",";
				}
				sisids+="'"+ids[n]+"'";
			}
			String sql="select distinct d.oc_debet_encounteruid,oc_encounter_begindate,searchname"+
				"from oc_debets d,oc_encounters e,adminview a, oc_insurances i"+
				" where"+
				" a.personid=e.oc_encounter_patientuid and"+
				" e.oc_encounter_objectid=replace(d.oc_debet_encounteruid,'"+MedwanQuery.getInstance().getServerId()+".','') and"+
				" i.oc_insurance_objectid=replace(d.oc_debet_insuranceuid,'"+MedwanQuery.getInstance().getServerId()+".','') and"+
				" i.oc_insurance_insuraruid in ("+sisids+") and"+
				" (d.oc_debet_insurarinvoiceuid is null or d.oc_debet_insurarinvoiceuid='') and"+
				" oc_debet_date>?"+
				" order by oc_encounter_begindate,searchname";
			PreparedStatement ps = conn.prepareStatement(sql);
			long day = 24*3600*1000;
			ps.setTimestamp(1, new java.sql.Timestamp(new java.util.Date().getTime()-days*day));
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				encounters.add(Encounter.get(rs.getString("oc_debet_encounteruid")));
			}
			rs.close();
			ps.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally {
			try{
				conn.close();
			}
			catch(Exception d){
				d.printStackTrace();
			}
		}
		return encounters;
	}
	
	public static Vector getEncountersWithoutFUA(int personid){
		Vector encounters = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			String sisids="";
			String[] ids = MedwanQuery.getInstance().getConfigString("SIS","1.29,1.30").split(",");
			for(int n = 0;n<ids.length;n++){
				if(sisids.length()>0){
					sisids+=",";
				}
				sisids+="'"+ids[n]+"'";
			}
			String sql="select distinct d.oc_debet_encounteruid,oc_encounter_begindate"+
				" from oc_debets d,oc_encounters e, oc_insurances i"+
				" where"+
				" e.oc_encounter_patientuid=? and"+
				" e.oc_encounter_objectid=replace(d.oc_debet_encounteruid,'"+MedwanQuery.getInstance().getServerId()+".','') and"+
				" i.oc_insurance_objectid=replace(d.oc_debet_insuranceuid,'"+MedwanQuery.getInstance().getServerId()+".','') and"+
				" i.oc_insurance_insuraruid in ("+sisids+") and"+
				" (d.oc_debet_insurarinvoiceuid is null or d.oc_debet_insurarinvoiceuid='') and"+
				" not exists (select * from SIS_FUA where SIS_FUA_STATUS='open' and SIS_FUA_ENCOUNTERUID=d.oc_debet_encounteruid)"+
				" order by oc_encounter_begindate";
			PreparedStatement ps = conn.prepareStatement(sql);
			long day = 24*3600*1000;
			ps.setInt(1, personid);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				encounters.add(Encounter.get(rs.getString("oc_debet_encounteruid")));
			}
			rs.close();
			ps.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally {
			try{
				conn.close();
			}
			catch(Exception d){
				d.printStackTrace();
			}
		}
		return encounters;
	}

	public static Vector getFUAToBeUpdated(int personid){
		Vector fuas = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			String sisids="";
			String[] ids = MedwanQuery.getInstance().getConfigString("SIS","1.29").split(",");
			for(int n = 0;n<ids.length;n++){
				if(sisids.length()>0){
					sisids+=",";
				}
				sisids+="'"+ids[n]+"'";
			}
			String sql="select distinct SIS_FUA_SERVERID,SIS_FUA_OBJECTID,oc_encounter_begindate"+
				" from oc_debets d,oc_encounters e, oc_insurances i, SIS_FUA s"+
				" where"+
				" e.oc_encounter_patientuid=? and"+
				" e.oc_encounter_objectid=replace(d.oc_debet_encounteruid,'"+MedwanQuery.getInstance().getServerId()+".','') and"+
				" i.oc_insurance_objectid=replace(d.oc_debet_insuranceuid,'"+MedwanQuery.getInstance().getServerId()+".','') and"+
				" i.oc_insurance_insuraruid in ("+sisids+") and"+
				" (d.oc_debet_insurarinvoiceuid is null or d.oc_debet_insurarinvoiceuid='') and"+
				" SIS_FUA_ENCOUNTERUID=d.oc_debet_encounteruid and"+
				" SIS_FUA_STATUS='open'"+
				" order by oc_encounter_begindate";
			PreparedStatement ps = conn.prepareStatement(sql);
			long day = 24*3600*1000;
			ps.setInt(1, personid);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				fuas.add(FUA.get(rs.getString("SIS_FUA_SERVERID")+"."+rs.getString("SIS_FUA_OBJECTID")));
			}
			rs.close();
			ps.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally {
			try{
				conn.close();
			}
			catch(Exception d){
				d.printStackTrace();
			}
		}
		return fuas;
	}
	
	public static Vector getEncountersWithFUA (int personid){
		Vector fuas = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			String sql="select distinct SIS_FUA_SERVERID,SIS_FUA_OBJECTID,SIS_FUA_ENCOUNTERUID,SIS_FUA_DATE"+
				" from SIS_FUA s"+
				" where"+
				" SIS_FUA_PERSONID=? "+
				" order by SIS_FUA_DATE DESC";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, personid);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				fuas.add(FUA.get(rs.getString("SIS_FUA_SERVERID")+"."+rs.getString("SIS_FUA_OBJECTID")));
			}
			rs.close();
			ps.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally {
			try{
				conn.close();
			}
			catch(Exception d){
				d.printStackTrace();
			}
		}
		return fuas;
	}
	
	public static Vector getFUASForEncounter (String encounteruid){
		Vector fuas = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			String sql="select distinct SIS_FUA_SERVERID,SIS_FUA_OBJECTID,SIS_FUA_DATE"+
				" from SIS_FUA s"+
				" where"+
				" SIS_FUA_ENCOUNTERUID=? "+
				" order by SIS_FUA_DATE DESC";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, encounteruid);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				fuas.add(FUA.get(rs.getString("SIS_FUA_SERVERID")+"."+rs.getString("SIS_FUA_OBJECTID")));
			}
			rs.close();
			ps.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally {
			try{
				conn.close();
			}
			catch(Exception d){
				d.printStackTrace();
			}
		}
		return fuas;
	}
	
	public static Vector getEncountersWithFUA (int personid,String status){
		Vector fuas = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			String sql="select distinct SIS_FUA_ENCOUNTERUID,SIS_FUA_DATE"+
				" from SIS_FUA s"+
				" where"+
				" SIS_FUA_PERSONID=? and"+
				" SIS_FUA_STATUS=?"+
				" order by SIS_FUA_DATE DESC";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, personid);
			ps.setString(2, status);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				fuas.add(FUA.get(rs.getString("oc_debet_encounteruid")));
			}
			rs.close();
			ps.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally {
			try{
				conn.close();
			}
			catch(Exception d){
				d.printStackTrace();
			}
		}
		return fuas;
	}
	
	public static FUA get(String uid){
		FUA fua = null;
		if(isValidUid(uid)){
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			try{
				PreparedStatement ps = conn.prepareStatement("select * from SIS_FUA where SIS_FUA_SERVERID=? and SIS_FUA_OBJECTID=?");
				ps.setInt(1, Integer.parseInt(uid.split("\\.")[0]));
				ps.setInt(2, Integer.parseInt(uid.split("\\.")[1]));
				ResultSet rs = ps.executeQuery();
				if(rs.next()){
					fua = new FUA();
					fua.setCreateDateTime(new java.util.Date());
					fua.setDate(rs.getDate("SIS_FUA_DATE"));
					fua.setPatientFingerPrint(rs.getBytes("SIS_FUA_PATIENTFINGERPRINT"));
					fua.setPatientFingerPrintMatchScore(rs.getInt("SIS_FUA_PATIENTFINGERPRINTMATCHSCORE"));
					fua.setPatientSignatureDateTime(rs.getTimestamp("SIS_FUA_PATIENTSIGNATUREDATETIME"));
					fua.setPersonId(rs.getInt("SIS_FUA_PERSONID"));
					fua.setEncounteruid(rs.getString("SIS_FUA_ENCOUNTERUID"));
					fua.setSentDateTime(rs.getTimestamp("SIS_FUA_SENTDATETIME"));
					fua.setSignatureUser(rs.getInt("SIS_FUA_SIGNATUREUSER"));
					fua.setSignatureUserDateTime(rs.getTimestamp("SIS_FUA_SIGNATUREUSERDATETIME"));
					fua.setStatus(rs.getString("SIS_FUA_STATUS"));
					fua.setUid(uid);
					fua.setUpdateDateTime(rs.getTimestamp("SIS_FUA_UPDATETIME"));
					fua.setUpdateUser(rs.getString("SIS_FUA_UPDATEUSER"));
					fua.setVersion(rs.getInt("SIS_FUA_VERSION"));
				}
				rs.close();
				ps.close();
				fua.atencion = Atencion.getForFUA(uid);
				fua.diagnosticos = Diagnosticos.getForFUA(fua.atencion.getValueString(1));
				fua.cleanDiagnosticos();
				fua.medicamentos = Medicamentos.getForFUA(fua.atencion.getValueString(1));
				fua.insumos = Insumos.getForFUA(fua.atencion.getValueString(1));
				fua.procedimientos = Procedimientos.getForFUA(fua.atencion.getValueString(1));
				fua.smi = SMI.getForFUA(fua.atencion.getValueString(1));
				fua.recienNacido = RecienNacido.getForFUA(fua.atencion.getValueString(1));
			}
			catch(Exception e){
				e.printStackTrace();
			}
			finally {
				try{
					conn.close();
				}
				catch(Exception d){
					d.printStackTrace();
				}
			}
		}
		return fua;
	}
	
	public void store(){
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps;
		try{
			if(hasValidUid()){
				//Move to history
				String sql = "insert into SIS_FUA_HISTORY("
						+ " SIS_FUA_SERVERID,"
						+ " SIS_FUA_OBJECTID,"
						+ " SIS_FUA_PERSONID,"
						+ " SIS_FUA_DATE,"
						+ " SIS_FUA_UPDATETIME,"
						+ " SIS_FUA_UPDATEUSER,"
						+ " SIS_FUA_VERSION,"
						+ " SIS_FUA_STATUS,"
						+ " SIS_FUA_PATIENTFINGERPRINT,"
						+ " SIS_FUA_PATIENTFINGERPRINTMATCHSCORE,"
						+ " SIS_FUA_PATIENTSIGNATUREDATETIME,"
						+ " SIS_FUA_SENTDATETIME,"
						+ " SIS_FUA_SIGNATUREUSER,"
						+ " SIS_FUA_SIGNATUREUSERDATETIME,"
						+ " SIS_FUA_ENCOUNTERUID)"
						+ " SELECT "
						+ " SIS_FUA_SERVERID,"
						+ " SIS_FUA_OBJECTID,"
						+ " SIS_FUA_PERSONID,"
						+ " SIS_FUA_DATE,"
						+ " SIS_FUA_UPDATETIME,"
						+ " SIS_FUA_UPDATEUSER,"
						+ " SIS_FUA_VERSION,"
						+ " SIS_FUA_STATUS,"
						+ " SIS_FUA_PATIENTFINGERPRINT,"
						+ " SIS_FUA_PATIENTFINGERPRINTMATCHSCORE,"
						+ " SIS_FUA_PATIENTSIGNATUREDATETIME,"
						+ " SIS_FUA_SENTDATETIME,"
						+ " SIS_FUA_SIGNATUREUSER,"
						+ " SIS_FUA_SIGNATUREUSERDATETIME,"
						+ " SIS_FUA_ENCOUNTERUID"
						+ " FROM SIS_FUA WHERE SIS_FUA_SERVERID=? AND SIS_FUA_OBJECTID=?";
				ps = conn.prepareStatement(sql);
				ps.setInt(1, getServerId());
				ps.setInt(2, getObjectId());
				ps.execute();
				ps.close();
				ps = conn.prepareStatement("DELETE FROM SIS_FUA WHERE SIS_FUA_SERVERID=? AND SIS_FUA_OBJECTID=?");
				ps.setInt(1, getServerId());
				ps.setInt(2, getObjectId());
				ps.execute();
				ps.close();
				setVersion(getVersion()+1);
			}
			else{
				setVersion(1);
				setUid(MedwanQuery.getInstance().getServerId()+"."+MedwanQuery.getInstance().getOpenclinicCounter("SIS_FUA"));
			}
			setUpdateDateTime(new java.util.Date());
			String sql="INSERT INTO SIS_FUA("
					+ " SIS_FUA_SERVERID,"
					+ " SIS_FUA_OBJECTID,"
					+ " SIS_FUA_PERSONID,"
					+ " SIS_FUA_DATE,"
					+ " SIS_FUA_UPDATETIME,"
					+ " SIS_FUA_UPDATEUSER,"
					+ " SIS_FUA_VERSION,"
					+ " SIS_FUA_STATUS,"
					+ " SIS_FUA_PATIENTFINGERPRINT,"
					+ " SIS_FUA_PATIENTFINGERPRINTMATCHSCORE,"
					+ " SIS_FUA_PATIENTSIGNATUREDATETIME,"
					+ " SIS_FUA_SENTDATETIME,"
					+ " SIS_FUA_SIGNATUREUSER,"
					+ " SIS_FUA_SIGNATUREUSERDATETIME,"
					+ " SIS_FUA_ENCOUNTERUID)"
					+ " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, getServerId());
			ps.setInt(2, getObjectId());
			ps.setInt(3, getPersonId());
			ps.setDate(4, atencion!=null?new java.sql.Date(atencion.getValueDateTime(39).getTime()):new java.sql.Date(getDate().getTime()));
			ps.setTimestamp(5, new java.sql.Timestamp(getUpdateDateTime().getTime()));
			ps.setInt(6, ScreenHelper.checkString(getUpdateUser()).length()==0?-1:Integer.parseInt(getUpdateUser()));
			ps.setInt(7, getVersion());
			ps.setString(8, getStatus());
			ps.setBytes(9, getPatientFingerPrint());
			ps.setInt(10, getPatientFingerPrintMatchScore());
			ps.setTimestamp(11, getPatientSignatureDateTime()==null?null:new java.sql.Timestamp(getPatientSignatureDateTime().getTime()));
			ps.setTimestamp(12, getSentDateTime()==null?null:new java.sql.Timestamp(getSentDateTime().getTime()));
			ps.setInt(13, getSignatureUser());
			ps.setTimestamp(14, getSignatureUserDateTime()==null?null:new java.sql.Timestamp(getSignatureUserDateTime().getTime()));
			ps.setString(15, getEncounteruid());
			ps.execute();
			ps.close();
			
			//Now also store all child parts
			if(atencion!=null){
				atencion.store();
			}
			Diagnosticos.moveToHistory(atencion.getValueString(1));
			for(int n=0;n<diagnosticos.size();n++){
				Diagnosticos d = (Diagnosticos)diagnosticos.elementAt(n);
				d.store();
			}
			Medicamentos.moveToHistory(atencion.getValueString(1));
			for(int n=0;n<medicamentos.size();n++){
				Medicamentos d = (Medicamentos)medicamentos.elementAt(n);
				d.store();
			}
			SMI.moveToHistory(atencion.getValueString(1));
			for(int n=0;n<smi.size();n++){
				SMI d = (SMI)smi.elementAt(n);
				d.store();
			}
			Insumos.moveToHistory(atencion.getValueString(1));
			for(int n=0;n<insumos.size();n++){
				Insumos d = (Insumos)insumos.elementAt(n);
				d.store();
			}
			Procedimientos.moveToHistory(atencion.getValueString(1));
			for(int n=0;n<procedimientos.size();n++){
				Procedimientos d = (Procedimientos)procedimientos.elementAt(n);
				d.store();
			}
			if(recienNacido!=null){
				recienNacido.store();
			}
			ServiciosAdicionales.moveToHistory(atencion.getValueString(1));
			for(int n=0;n<serviciosAdicionales.size();n++){
				ServiciosAdicionales d = (ServiciosAdicionales)serviciosAdicionales.elementAt(n);
				d.store();
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally {
			try{
				conn.close();
			}
			catch(Exception d){
				d.printStackTrace();
			}
		}
	}
	
	public static int getNextAvailableFUANumber(){
		int number = -1;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps;
		try{
			//First get last used FUA number and add one
			ps=conn.prepareStatement("select * from SIS_FUA order by SIS_FUA_OBJECTID DESC");
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				number = rs.getInt("SIS_FUA_OBJECTID")+1;
			}
			rs.close();
			ps.close();
			//Now pick available ranges for FUAs
			String[] ranges = MedwanQuery.getInstance().getConfigString("sis.fuaranges","20000-25000").split(",");
			for(int n=0;n<ranges.length;n++){
				if(number<Integer.parseInt(ranges[n].split("-")[0])){
					number=Integer.parseInt(ranges[n].split("-")[0]);
					break;
				}
				else if(number<Integer.parseInt(ranges[n].split("-")[1])){
					break;
				}
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally {
			try{
				conn.close();
			}
			catch(Exception d){
				d.printStackTrace();
			}
		}
		return number;
	}
	
	public void loadAtencion(SIS_Object acreditacion){
		Encounter encounter = Encounter.get(getEncounteruid());
		if(encounter!=null && encounter.hasValidUid()){
			atencion = new Atencion();
			atencion.setUid(getUid());
			atencion.setValue(1, encounter.getObjectId()+"");
			atencion.setValue(2, MedwanQuery.getInstance().getConfigString("disa", "350"));
			atencion.setValue(3, new SimpleDateFormat("YY").format(encounter.getEnd()));
			atencion.setValue(4, getObjectId()+"");
			atencion.setValue(5, MedwanQuery.getInstance().getConfigString("udr", "038"));
			atencion.setValue(6, MedwanQuery.getInstance().getConfigString("code.ipress.susalud", "00006212"));
			atencion.setValue(7, MedwanQuery.getInstance().getConfigString("category.ipress.susalud", "16"));
			atencion.setValue(8, MedwanQuery.getInstance().getConfigString("nivel.ipress.susalud", "3"));
			atencion.setValue(9, MedwanQuery.getInstance().getConfigString("digitalizationpoint.ipress.susalud", ""));
			atencion.setValue(10, "N");
			atencion.setValue(11, "");
			atencion.setValue(12, "");
			atencion.setValue(13, "");
			atencion.setValue(14, MedwanQuery.getInstance().getConfigString("convenio.ogti", "0"));
			atencion.setValue(15, acreditacion.getValueString(13));
			atencion.setValue(16, acreditacion.getValueString(25));
			atencion.setValue(17, acreditacion.getValueString(26));
			atencion.setValue(18, acreditacion.getValueString(27));
			atencion.setValue(19, acreditacion.getValueString(28));
			atencion.setValue(20, acreditacion.getValueString(20));
			atencion.setValue(21, acreditacion.getValueString(21));
			atencion.setValue(22, acreditacion.getValueString(29));
			atencion.setValue(23, acreditacion.getValueString(30));
			atencion.setValue(24, acreditacion.getValueString(3));
			atencion.setValue(25, acreditacion.getValueString(4));
			atencion.setValue(26, acreditacion.getValueString(5));
			atencion.setValue(27, acreditacion.getValueString(6));
			atencion.setValue(28, acreditacion.getValueString(7));
			atencion.setValue(29, "");
			atencion.setValue(30, ScreenHelper.formatDate(acreditacion.getValueShortDate(23)));
			atencion.setValue(31, acreditacion.getValueString(22));
			atencion.setValue(32, acreditacion.getValueString(24));
			atencion.setValue(33, encounter.getPatientUID()+"");
			atencion.setValue(34, ScreenHelper.checkString(encounter.getOrigin()));
			if(atencion.getValueInt(31)==1){
				atencion.setValue(35, "0");
			}
			else{
				Vector items = MedwanQuery.getInstance().getItemHistory(MedwanQuery.getInstance().getHealthRecordIdFromPersonId(Integer.parseInt(encounter.getPatientUID())), "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_PATIENTTYPE2");
				if(items.size()>0){
					ItemVO item = (ItemVO)items.elementAt(0);
					long day = 24*3600*1000;
					if(!item.getDate().before(new Date(encounter.getBegin().getTime()-day))){
						if(item.getValue().equalsIgnoreCase("2")||item.getValue().equalsIgnoreCase("4")){
							atencion.setValue(35, "1");
						}
						else if(item.getValue().equalsIgnoreCase("1")){
							atencion.setValue(35, "2");
						}
						else{
							atencion.setValue(35, "0");
						}
					}
					else{
						atencion.setValue(35, "0");
					}
				}
				else{
					atencion.setValue(35, "0");
				}
			}
			atencion.setValue(36,ScreenHelper.checkString(encounter.getCareModality())); 
			atencion.setValue(37,""); 
			atencion.setValue(38,""); 
			atencion.setValue(39,ScreenHelper.formatDate(encounter.getEnd(),ScreenHelper.fullDateFormat));
			atencion.setValue(40, ScreenHelper.checkString(encounter.getEtiology()));
			atencion.setValue(41, ScreenHelper.checkString(encounter.getReferenceSheet()));
			atencion.setValue(42,ScreenHelper.checkString(encounter.getCareType())); 
			atencion.setValue(43,MedwanQuery.getInstance().getConfigString("typeofstaff", "1")); 
			atencion.setValue(44,MedwanQuery.getInstance().getConfigString("carelocation", "1")); 
			atencion.setValue(45, ScreenHelper.checkString(encounter.getOutcome()));
			if(encounter.getType().equalsIgnoreCase("admission")){
				atencion.setValue(46,ScreenHelper.formatDate(encounter.getBegin())); 
				atencion.setValue(47,ScreenHelper.formatDate(encounter.getEnd())); 
			}
			else{
				atencion.setValue(46,""); 
				atencion.setValue(47,""); 
			}
			atencion.setValue(48, ScreenHelper.checkString(encounter.getCounterReference()));
			atencion.setValue(49, ScreenHelper.checkString(encounter.getCounterReferenceSheet()));
			if(atencion.getValueInt(31)==1){
				atencion.setValue(50, "");
			}
			else{
				Vector items = MedwanQuery.getInstance().getItemHistory(MedwanQuery.getInstance().getHealthRecordIdFromPersonId(Integer.parseInt(encounter.getPatientUID())), "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_DATE_DR");
				if(items.size()>0){
					ItemVO item = (ItemVO)items.elementAt(0);
					try{
						java.util.Date date = ScreenHelper.parseDate(item.getValue());
						if(date.after(new java.util.Date())){
							atencion.setValue(50, item.getValue());
						}
					}
					catch(Exception e){
						e.printStackTrace();
					}
				}
				if(atencion.getValueString(50).length()==0){
					items = MedwanQuery.getInstance().getItemHistory(MedwanQuery.getInstance().getHealthRecordIdFromPersonId(Integer.parseInt(encounter.getPatientUID())), "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_AGE_ECHOGRAPHY");
					if(items.size()>0){
						ItemVO item = (ItemVO)items.elementAt(0);
						try{
							java.util.Date date = ScreenHelper.parseDate(item.getValue());
							if(date.after(new java.util.Date())){
								atencion.setValue(50, item.getValue());
							}
						}
						catch(Exception e){
							e.printStackTrace();
						}
					}
				}
				if(atencion.getValueString(50).length()==0){
					atencion.setValue(50, "");
				}
			}
			atencion.setValue(51, "");
			atencion.setValue(52, "");
			atencion.setValue(53, "");
			atencion.setValue(54, "");
			atencion.setValue(55, "");
			atencion.setValue(56, "");
			atencion.setValue(57, "");
			atencion.setValue(58, "");
			if(encounter.getOutcome().equalsIgnoreCase("7")){
				atencion.setValue(59, ScreenHelper.formatDate(encounter.getEnd()));
			}
			else{
				atencion.setValue(59, "");
			}
			atencion.setValue(60,MedwanQuery.getInstance().getConfigString("ipressflexibaloffer", "")); 
			atencion.setValue(61, ScreenHelper.checkString(encounter.getPatient().comment5));
			String insuranceuid = Insurance.getActiveInsurance(encounter.getPatientUID(), MedwanQuery.getInstance().getConfigString("SIS","1.29"));
			if(ScreenHelper.checkString(insuranceuid).length()==0){
				atencion.setValue(62, "");
			}
			else{
				Insurance insurance = Insurance.get(insuranceuid);
				if(insurance!=null){
					atencion.setValue(62, ScreenHelper.checkString(insurance.getMemberEmployer()));
					atencion.setValue(63, ScreenHelper.checkString(insurance.getMemberImmat()));
				}
			}
			atencion.setValue(64,ScreenHelper.checkString(encounter.getService().getInscode())); //Todo: put on FUA form!
			if(atencion.getValueString(45).equalsIgnoreCase("9")){
				atencion.setValue(65, ScreenHelper.formatDate(encounter.getEnd()));
			}
			else{
				atencion.setValue(65, ""); 
			}
			atencion.setValue(66, ""); //Todo: put on FUA form!
			atencion.setValue(67, ""); //Todo: put on FUA form!
			atencion.setValue(68, ""); //Todo: put on FUA form!
			atencion.setValue(69, ""); //Todo: put on FUA form!
			atencion.setValue(70, ""); //Todo: put on FUA form!
			atencion.setValue(71, ""); //Todo: put on FUA form!
			encounter.setManager(null);
			if(encounter.getManager()==null){
				atencion.setValue(72, "");
				atencion.setValue(73, "");
				atencion.setValue(74, "");
				atencion.setValue(75, "");
				atencion.setValue(76, "");
				atencion.setValue(77, "");
				atencion.setValue(78, "");
			}
			else{
				atencion.setValue(72, ScreenHelper.checkString(encounter.getManager().person.personType));
				atencion.setValue(73, ScreenHelper.checkString(encounter.getManager().person.getID("natreg")));
				List contracts = Contract.getContractsForPerson(Integer.parseInt(encounter.getManager().personid));
				Contract activeContract = null;
				Iterator iContracts = contracts.iterator();
				while(iContracts.hasNext()){
					Contract contract = (Contract)iContracts.next();
					if(contract.isActive()){
						activeContract = contract;
						break;
					}
				}
				if(activeContract==null){
					atencion.setValue(74, "");
					atencion.setValue(75, "");
					atencion.setValue(76, "");
					atencion.setValue(77, "");
					atencion.setValue(78, "");
				}
				else{
					atencion.setValue(74, ScreenHelper.checkString(activeContract.functionCode));
					atencion.setValue(75, ScreenHelper.checkString(activeContract.ref1));
					atencion.setValue(76, ScreenHelper.checkString(activeContract.ref2));
					atencion.setValue(77, ScreenHelper.checkString(activeContract.ref3));
					atencion.setValue(78, ScreenHelper.checkString(activeContract.ref4));
				}
			}
			atencion.setValue(79, new SimpleDateFormat("yyyy").format(encounter.getEnd()));
			atencion.setValue(80, new SimpleDateFormat("MM").format(encounter.getEnd()));
			atencion.setValue(81, "1");
			atencion.setValue(82,MedwanQuery.getInstance().getConfigString("dnidigitador", ""));
			atencion.setValue(83, ScreenHelper.formatDate(encounter.getEnd(),ScreenHelper.fullDateFormat));
			atencion.setValue(84, "");
			atencion.setValue(85, MedwanQuery.getInstance().getConfigString("updateVersion"));
		}
	}
	
	public void cleanDiagnosticos(){
		//Avoid double diagnostics
		HashSet existingDiagnoses = new HashSet();
		Vector tempDiags = (Vector)diagnosticos.clone();
		diagnosticos = new Vector();
		for(int n=0;n<tempDiags.size();n++){
			Diagnosticos d = (Diagnosticos)tempDiags.elementAt(n);
			if(!existingDiagnoses.contains(d.getValueString(2))){
				diagnosticos.addElement(d);
				existingDiagnoses.add(d.getValueString(2));
			}
		}
	}
	
	public void loadDiagnosticos(){
		//Avoid double diagnostics
		HashSet existingDiagnoses = new HashSet();
		for(int n=0;n<diagnosticos.size();n++){
			Diagnosticos d = (Diagnosticos)diagnosticos.elementAt(n);
			existingDiagnoses.add(d.getValueString(2));
		}
		Vector diagnoses = Diagnosis.selectDiagnoses("", "", getEncounteruid(), "", "", "", "", "", "", "", "", "icd10", "OC_DIAGNOSIS_GRAVITY DESC");
		for(int n=0;n<diagnoses.size();n++){
			Diagnosis diagnosis = (Diagnosis)diagnoses.elementAt(n);
			if(!existingDiagnoses.contains(diagnosis.getCode().replaceAll("\\.", ""))){
				Diagnosticos d = new Diagnosticos();
				d.setCreateDateTime(new java.util.Date());
				d.setUpdateDateTime(new java.util.Date());
				d.setUpdateUser(getUpdateUser());
				d.setVersion(1);
				d.setValue(1, atencion.getValueString(1));
				d.setValue(2, diagnosis.getCode().replaceAll("\\.", ""));
				d.setValue(3, (n+1)+"");
				d.setValue(4, ScreenHelper.checkString(diagnosis.getPOA()).equalsIgnoreCase("1")?"I":"E");
				if(!ScreenHelper.checkString(diagnosis.getNC()).equalsIgnoreCase("1")){
					d.setValue(5, "4");
				}
				else{
					if(diagnosis.getCertainty()>=500){
						d.setValue(5, "1");
					}
					else{
						d.setValue(5, "2");
					}
				}
				diagnosticos.add(d);
			}
		}
	}
	
	public void loadMedicamentos(){
		Encounter encounter = Encounter.get(getEncounteruid());
		Vector debets = Debet.getUnassignedInsurarDebets(MedwanQuery.getInstance().getConfigString("SIS","1.29"),getEncounteruid());
		for(int n = 0; n<debets.size();n++){
			Debet debet = (Debet)debets.elementAt(n);
			if(debet.getPrestation().getReferenceObject().getObjectType().equalsIgnoreCase("M")){
				Medicamentos m = new Medicamentos();
				m.setValue(1, encounter.getObjectId()+"");
				m.setValue(2, ScreenHelper.checkString(debet.getPrestation().getReferenceObject().getObjectUid()));
				if(ScreenHelper.checkString(debet.getDiagnosisUid()).length()>0){
					Diagnosis diagnosis = Diagnosis.get(debet.getDiagnosisUid());
					if(diagnosis!=null && diagnosis.getCode()!=null){
						//Let's check if the diagnosis exists in the FUA
						for(int i=0;i<diagnosticos.size() && m.getValueString(3).length()==0;i++){
							Diagnosticos d = (Diagnosticos)diagnosticos.elementAt(i);
							if(d.getValueString(2).equalsIgnoreCase(diagnosis.getCode().replaceAll("\\.", ""))){
								m.setValue(3, d.getValueString(3));
							}
						}
					}
				}
				m.setValue(6, "");
				m.setValue(7, "");
				Vector prescriptions = Prescription.find(getPersonId()+"", "", "", ScreenHelper.formatDate(encounter.getBegin()),  ScreenHelper.formatDate(encounter.getEnd()), "", "", "");
				for(int q = 0;q<prescriptions.size();q++){
					Prescription prescription = (Prescription)prescriptions.elementAt(q);
					if(ScreenHelper.checkString(prescription.getProduct().getPrestationcode()).equalsIgnoreCase(debet.getPrestation().getUid()) && ScreenHelper.checkString(prescription.getDiagnosisUid()).length()>0){
						m.setValue(6, ScreenHelper.formatDate(prescription.getBegin()));
						m.setValue(7, prescription.getUid());
						if(m.getValueString(2).length()==0){
							m.setValue(2,ScreenHelper.checkString(prescription.getProduct().getBarcode()));
						}
						if(m.getValueString(3).length()==0){
							Diagnosis diagnosis = Diagnosis.get(prescription.getDiagnosisUid());
							if(diagnosis!=null && diagnosis.getCode()!=null){
								//Let's check if the diagnosis exists in the FUA
								for(int i=0;i<diagnosticos.size() && m.getValueString(3).length()==0;i++){
									Diagnosticos d = (Diagnosticos)diagnosticos.elementAt(i);
									if(d.getValueString(2).equalsIgnoreCase(diagnosis.getCode().replaceAll("\\.", ""))){
										m.setValue(3, d.getValueString(3));
									}
								}
							}
						}
					}
					else if(ScreenHelper.checkString(prescription.getProduct().getAtccode()).equalsIgnoreCase(debet.getPrestation().getATCCode()) && ScreenHelper.checkString(prescription.getDiagnosisUid()).length()>0){
						m.setValue(6, ScreenHelper.formatDate(prescription.getBegin()));
						m.setValue(7, prescription.getUid());
						if(m.getValueString(2).length()==0){
							m.setValue(2,ScreenHelper.checkString(prescription.getProduct().getBarcode()));
						}
						if(m.getValueString(3).length()==0){
							Diagnosis diagnosis = Diagnosis.get(prescription.getDiagnosisUid());
							if(diagnosis!=null && diagnosis.getCode()!=null){
								//Let's check oif the diagnosis exists in the FUA
								for(int i=0;i<diagnosticos.size() && m.getValueString(3).length()==0;i++){
									Diagnosticos d = (Diagnosticos)diagnosticos.elementAt(i);
									if(d.getValueString(2).equalsIgnoreCase(diagnosis.getCode().replaceAll("\\.", ""))){
										m.setValue(3, d.getValueString(3));
									}
								}
							}
						}
					}
				}
				if(m.getValueString(3).length()==0 && ScreenHelper.checkString(debet.getPrestation().getATCCode()).length()>0){
					for(int i=0;i<diagnosticos.size() && m.getValueString(3).length()==0;i++){
						Diagnosticos d = (Diagnosticos)diagnosticos.elementAt(i);
						String diag = d.getValueString(2);
						if(diag.length()>3){
							diag=diag.substring(0,3)+"."+diag.substring(3);
						}
						if(Indication.isATCCodeIndicatedForICD10Code(debet.getPrestation().getATCCode(), diag)){
							m.setValue(3, d.getValueString(3));
						}
					}
				}
				m.setValue(4, debet.getQuantity()+"");
				m.setValue(5, debet.getQuantity()+"");
				m.setValue(8, debet.getUid());
				medicamentos.add(m);
			}
		}
	}
	
	public void loadSMI(){
		//TODO: any of these acts in HEP?
	}
	
	public void loadInsumos(){
		Encounter encounter = Encounter.get(getEncounteruid());
		Vector debets = Debet.getUnassignedInsurarDebets(MedwanQuery.getInstance().getConfigString("SIS","1.29"),getEncounteruid());
		for(int n = 0; n<debets.size();n++){
			Debet debet = (Debet)debets.elementAt(n);
			if(debet.getPrestation().getReferenceObject().getObjectType().equalsIgnoreCase("C")){
				Insumos m = new Insumos();
				m.setValue(1, encounter.getObjectId()+"");
				m.setValue(2, ScreenHelper.checkString(debet.getPrestation().getReferenceObject().getObjectUid()));
				if(ScreenHelper.checkString(debet.getDiagnosisUid()).length()>0){
					Diagnosis diagnosis = Diagnosis.get(debet.getDiagnosisUid());
					if(diagnosis!=null && diagnosis.getCode()!=null){
						//Let's check if the diagnosis exists in the FUA
						for(int i=0;i<diagnosticos.size() && m.getValueString(3).length()==0;i++){
							Diagnosticos d = (Diagnosticos)diagnosticos.elementAt(i);
							if(d.getValueString(2).equalsIgnoreCase(diagnosis.getCode().replaceAll("\\.", ""))){
								m.setValue(3, d.getValueString(3));
							}
						}
					}
				}
				m.setValue(6, "");
				m.setValue(7, "");
				Vector prescriptions = Prescription.find(getPersonId()+"", "", "", ScreenHelper.formatDate(encounter.getBegin()),  ScreenHelper.formatDate(encounter.getEnd()), "", "", "");
				for(int q = 0;q<prescriptions.size();q++){
					Prescription prescription = (Prescription)prescriptions.elementAt(q);
					if(ScreenHelper.checkString(prescription.getProduct().getPrestationcode()).equalsIgnoreCase(debet.getPrestation().getUid()) && ScreenHelper.checkString(prescription.getDiagnosisUid()).length()>0){
						m.setValue(6, ScreenHelper.formatDate(prescription.getBegin()));
						m.setValue(7, prescription.getUid());
						if(m.getValueString(2).length()==0){
							m.setValue(2,ScreenHelper.checkString(prescription.getProduct().getBarcode()));
						}
						if(m.getValueString(3).length()==0){
							Diagnosis diagnosis = Diagnosis.get(prescription.getDiagnosisUid());
							if(diagnosis!=null && diagnosis.getCode()!=null){
								//Let's check oif the diagnosis exists in the FUA
								for(int i=0;i<diagnosticos.size() && m.getValueString(3).length()==0;i++){
									Diagnosticos d = (Diagnosticos)diagnosticos.elementAt(i);
									if(d.getValueString(2).equalsIgnoreCase(diagnosis.getCode().replaceAll("\\.", ""))){
										m.setValue(3, d.getValueString(3));
									}
								}
							}
						}
					}
					else if(ScreenHelper.checkString(prescription.getProduct().getAtccode()).equalsIgnoreCase(debet.getPrestation().getATCCode()) && ScreenHelper.checkString(prescription.getDiagnosisUid()).length()>0){
						m.setValue(6, ScreenHelper.formatDate(prescription.getBegin()));
						m.setValue(7, prescription.getUid());
						if(m.getValueString(2).length()==0){
							m.setValue(2,ScreenHelper.checkString(prescription.getProduct().getBarcode()));
						}
						if(m.getValueString(3).length()==0){
							Diagnosis diagnosis = Diagnosis.get(prescription.getDiagnosisUid());
							if(diagnosis!=null && diagnosis.getCode()!=null){
								//Let's check oif the diagnosis exists in the FUA
								for(int i=0;i<diagnosticos.size() && m.getValueString(3).length()==0;i++){
									Diagnosticos d = (Diagnosticos)diagnosticos.elementAt(i);
									if(d.getValueString(2).equalsIgnoreCase(diagnosis.getCode().replaceAll("\\.", ""))){
										m.setValue(3, d.getValueString(3));
									}
								}
							}
						}
					}
				}
				if(m.getValueString(3).length()==0 && ScreenHelper.checkString(debet.getPrestation().getATCCode()).length()>0){
					for(int i=0;i<diagnosticos.size() && m.getValueString(3).length()==0;i++){
						Diagnosticos d = (Diagnosticos)diagnosticos.elementAt(i);
						String diag = d.getValueString(2);
						if(diag.length()>3){
							diag=diag.substring(0,3)+"."+diag.substring(3);
						}
						if(Indication.isATCCodeIndicatedForICD10Code(debet.getPrestation().getATCCode(), diag)){
							m.setValue(3, d.getValueString(3));
						}
					}
				}
				m.setValue(4, debet.getQuantity()+"");
				m.setValue(5, debet.getQuantity()+"");
				m.setValue(8, debet.getUid());
				insumos.add(m);
			}
		}
	}
	
	public void loadProcedimientos(){
		Encounter encounter = Encounter.get(getEncounteruid());
		Vector debets = Debet.getUnassignedInsurarDebets(MedwanQuery.getInstance().getConfigString("SIS","1.29"),getEncounteruid());
		for(int n = 0; n<debets.size();n++){
			Debet debet = (Debet)debets.elementAt(n);
			if(!(debet.getPrestation().getReferenceObject().getObjectType().equalsIgnoreCase("C") || debet.getPrestation().getReferenceObject().getObjectType().equalsIgnoreCase("M"))){
				Procedimientos m = new Procedimientos();
				m.setValue(1, encounter.getObjectId()+"");
				m.setValue(2, ScreenHelper.checkString(debet.getPrestation().getNomenclature()));
				if(ScreenHelper.checkString(debet.getDiagnosisUid()).length()>0){
					Diagnosis diagnosis = Diagnosis.get(debet.getDiagnosisUid());
					if(diagnosis!=null && diagnosis.getCode()!=null){
						//Let's check if the diagnosis exists in the FUA
						for(int i=0;i<diagnosticos.size() && m.getValueString(3).length()==0;i++){
							Diagnosticos d = (Diagnosticos)diagnosticos.elementAt(i);
							if(d.getValueString(2).equalsIgnoreCase(diagnosis.getCode().replaceAll("\\.", ""))){
								m.setValue(3, d.getValueString(3));
							}
						}
					}
				}
				m.setValue(4, debet.getQuantity()+"");
				m.setValue(5, debet.getQuantity()+"");
				m.setValue(6,"");
				int userid=-1;
				if(ScreenHelper.checkString(debet.getPerformeruid()).length()>0){
					userid=Integer.parseInt(debet.getPerformeruid());
				}
				else if(ScreenHelper.checkString(encounter.getManagerUID()).length()>0) {
					userid=Integer.parseInt(encounter.getManagerUID());
				}
				if(userid>-1){
					User user = User.get(userid);
					m.setValue(7, ScreenHelper.checkString(user.person.personType));
					m.setValue(8, ScreenHelper.checkString(user.person.getID("natreg")));
					List contracts = Contract.getContractsForPerson(Integer.parseInt(user.person.personid));
					Contract activeContract = null;
					Iterator iContracts = contracts.iterator();
					while(iContracts.hasNext()){
						Contract contract = (Contract)iContracts.next();
						if(contract.isActive()){
							activeContract = contract;
							break;
						}
					}
					if(activeContract==null){
						m.setValue(9, "");
						m.setValue(10, "");
					}
					else{
						m.setValue(9, ScreenHelper.checkString(activeContract.functionCode));
						m.setValue(10, ScreenHelper.checkString(activeContract.ref1));
					}
				}
				else{
					m.setValue(7, "");
					m.setValue(8, "");
					m.setValue(9, "");
					m.setValue(10, "");
				}
				m.setValue(11, debet.getUid());
				procedimientos.add(m);
			}
		}
	}
	
	public void loadRecienNacido(){
		//TODO: any of these acts in HEP?
	}
	
	public void loadServiciosAdicionales(){
		//TODO: any of these acts in HEP?
	}
	
	public static FUA createFromEncounter(String encounteruid, int userid){
		FUA fua = null;
		Encounter encounter = Encounter.get(encounteruid);
		if(encounter!=null){
			SIS_Object acreditacion = Acreditacion.getLast(Integer.parseInt(encounter.getPatientUID()));
			if(acreditacion!=null){
				fua = new FUA();
				fua.setDate(encounter.getEnd());
				fua.setPersonId(Integer.parseInt(encounter.getPatientUID()));
				if(ScreenHelper.checkString(encounter.getManagerUID()).length()>0){
					fua.setSignatureUser(Integer.parseInt(encounter.getManagerUID()));
				}
				fua.setStatus("open");;
				fua.setUid(MedwanQuery.getInstance().getServerId()+"."+getNextAvailableFUANumber());
				fua.setUpdateUser(userid+"");
				fua.setCreateDateTime(new java.util.Date());
				fua.setVersion(1);
				fua.setEncounteruid(encounter.getUid());
				fua.loadAtencion(acreditacion);
				fua.update();
			}
		}
		return fua;
	}
	
	public void update(){
		SIS_Object acreditacion = Acreditacion.getLast(Integer.parseInt(getEncounter().getPatientUID()));
		atencion=new Atencion();
		loadAtencion(acreditacion);
		diagnosticos=new Vector();
		loadDiagnosticos();
		loadMedicamentos();
		loadInsumos();
		loadProcedimientos();
		loadSMI();
		loadRecienNacido();
		loadServiciosAdicionales();
	}
	
	public void initialize(){
		Medicamentos.moveToHistory(atencion.getValueString(1));
		setMedicamentos(new Vector());
		Insumos.moveToHistory(atencion.getValueString(1));
		setInsumos(new Vector());
		Procedimientos.moveToHistory(atencion.getValueString(1));
		setProcedimientos(new Vector());
		ServiciosAdicionales.moveToHistory(atencion.getValueString(1));
		setServiciosAdicionales(new Vector());
		SMI.moveToHistory(atencion.getValueString(1));
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps;
		try{
			//First get last used FUA number and add one
			ps=conn.prepareStatement("update OC_DEBETS set OC_DEBET_INSURARINVOICEUID=null where OC_DEBET_INSURARINVOICEUID=?");
			ps.setString(1, getEncounteruid());
			ps.execute();
			ps.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally {
			try{
				conn.close();
			}
			catch(Exception d){
				d.printStackTrace();
			}
		}
		update();
	}
	
	public double getAmount(){
		double amount = 0;
		for(int n=0;n<medicamentos.size();n++){
			Medicamentos m = (Medicamentos)medicamentos.elementAt(n);
			Debet d = Debet.get(m.getValueString(8));
			if(d!=null){
				amount+=d.getInsurarAmount();
			}
		}
		for(int n=0;n<insumos.size();n++){
			Insumos m = (Insumos)insumos.elementAt(n);
			Debet d = Debet.get(m.getValueString(8));
			if(d!=null){
				amount+=d.getInsurarAmount();
			}
		}
		for(int n=0;n<procedimientos.size();n++){
			Procedimientos m = (Procedimientos)procedimientos.elementAt(n);
			Debet d = Debet.get(m.getValueString(11));
			if(d!=null){
				amount+=d.getInsurarAmount();
			}
		}
		return amount;
	}
}
