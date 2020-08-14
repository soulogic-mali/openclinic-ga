package be.openclinic.knowledge;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.Vector;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;

public class ContraIndication {
	String contraIndicationId;
	String icd10CodeMin;
	String icd10CodeMax;
	
	public String getContraIndicationId() {
		return contraIndicationId;
	}
	
	public void setContraIndicationId(String contraIndicationId) {
		this.contraIndicationId = contraIndicationId;
	}
	
	public String getIcd10CodeMin() {
		return icd10CodeMin;
	}
	
	public void setIcd10CodeMin(String icd10CodeMin) {
		this.icd10CodeMin = icd10CodeMin;
	}
	
	public String getIcd10CodeMax() {
		return icd10CodeMax;
	}
	
	public void setIcd10CodeMax(String icd10CodeMax) {
		this.icd10CodeMax = icd10CodeMax;
	}
	
	public ContraIndication(String contraIndicationId) {
		super();
		this.contraIndicationId = contraIndicationId;
	}
	
	public String getLabel(String sLanguage){
		return ScreenHelper.getTranNoLink("contraindication", getContraIndicationId(), sLanguage);
	}
	
	public static ContraIndication get(String contraIndicationId){
		ContraIndication contraIndication = null;
		if(contraIndicationId!=null){
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			try{
				PreparedStatement ps = conn.prepareStatement("select * from OC_DRUGICONTRANDICATIONS where OC_DRUGCONTRAINDICATION_CODE=?");
				ps.setString(1, contraIndicationId);
				ResultSet rs = ps.executeQuery();
				if(rs.next()){
					contraIndication=new ContraIndication(contraIndicationId);
					contraIndication.setIcd10CodeMin(rs.getString("OC_DRUGCONTRAINDICATION_ICD10CODEMIN"));
					contraIndication.setIcd10CodeMax(rs.getString("OC_DRUGCONTRAINDICATION_ICD10CODEMAX"));
				}
				rs.close();
				ps.close();
			}
			catch(Exception e){
				e.printStackTrace();
			}
			finally{
				try{
					conn.close();
				}
				catch(Exception e){
					e.printStackTrace();
				}
			}
		}
		return contraIndication;
	}
	
	public static Vector getContraIndicationsForICD10Code(String icd10code){
		Vector contraIndications = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select * from OC_DRUGCONTRAINDICATIONS where OC_DRUGCONTRAINDICATION_ICD10CODEMIN<=? AND OC_DRUGCONTRAINDICATION_ICD10CODEMAX>=?");
			ps.setString(1, icd10code);
			ps.setString(2, icd10code);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				ContraIndication contraIndication=new ContraIndication(rs.getString("OC_DRUGCONTRAINDICATION_CODE"));
				contraIndication.setIcd10CodeMin(rs.getString("OC_DRUGCONTRAINDICATION_ICD10CODEMIN"));
				contraIndication.setIcd10CodeMax(rs.getString("OC_DRUGCONTRAINDICATION_ICD10CODEMAX"));
				contraIndications.add(contraIndication);
			}
			rs.close();
			ps.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			try{
				conn.close();
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		return contraIndications;
	}
	
	public static Vector getContraIndicationsForATCCode(String atcCode){
		Vector contraIndications = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select distinct a.OC_DRUGCONTRAINDICATION_CODE from OC_DRUGCONTRAINDICATIONS a,OC_DRUGCONTRAINDICATIONLINKS b where "
					+ "a.OC_DRUGCONTRAINDICATION_CODE=b.OC_DRUGCONTRAINDICATIONLINK_CODE and OC_DRUGCONTRAINDICATIONLINK_ATCCODE=?");
			ps.setString(1, atcCode);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				ContraIndication contraIndication=new ContraIndication(rs.getString("OC_DRUGCONTRAINDICATION_CODE"));
				contraIndications.add(contraIndication);
			}
			rs.close();
			ps.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			try{
				conn.close();
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		return contraIndications;
	}
	
	public static Vector getContraIndicatedICD10CodesForATCCodes(Vector atcCodes){
		HashSet hICD10Codes = new HashSet();
		for(int n=0;n<atcCodes.size();n++){
			Vector ic = getContraIndicatedICD10CodesForATCCode((String)atcCodes.elementAt(n));
			for(int i=0;i<ic.size();i++){
				hICD10Codes.add(ic.elementAt(i));
			}
		}
		Vector icd10Codes=new Vector();
		Iterator iICD10Codes = hICD10Codes.iterator();
		while(iICD10Codes.hasNext()){
			icd10Codes.add(iICD10Codes.next());
		}
		return icd10Codes;
	}
	
	public static Vector getContraIndicatedICD10CodesForATCCode(String atcCode){
		Vector icd10codes = new Vector();
		SortedSet hIcd10Codes = new TreeSet();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select * from OC_DRUGCONTRAINDICATIONS a,OC_DRUGCONTRAINDICATIONLINKS b where "
					+ "a.OC_DRUGCONTRAINDICATION_CODE=b.OC_DRUGCONTRAINDICATIONLINK_CODE and OC_DRUGCONTRAINDICATIONLINK_ATCCODE=?");
			ps.setString(1, atcCode);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				PreparedStatement ps2 = conn.prepareStatement("select * from icd10 where code>=? and code<=?");
				ps2.setString(1, rs.getString("OC_DRUGCONTRAINDICATION_ICD10CODEMIN"));
				ps2.setString(2, rs.getString("OC_DRUGCONTRAINDICATION_ICD10CODEMAX"));
				ResultSet rs2 = ps2.executeQuery();
				while(rs2.next()){
					hIcd10Codes.add(rs2.getString("code"));
				}
				rs2.close();
				ps2.close();
			}
			rs.close();
			ps.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			try{
				conn.close();
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		Iterator iIcd10Codes = hIcd10Codes.iterator();
		while(iIcd10Codes.hasNext()){
			icd10codes.add(iIcd10Codes.next());
		}
		return icd10codes;
	}
	
	public static Vector getContraIndicatedATCCodesForICD10Codes(Vector icd10codes){
		HashSet hAtcCodes = new HashSet();
		for(int n=0;n<icd10codes.size();n++){
			Vector ac = getContraIndicatedATCCodesForICD10Code((String)icd10codes.elementAt(n));
			for(int i=0;i<ac.size();i++){
				hAtcCodes.add(ac.elementAt(i));
			}
		}
		Vector atcCodes=new Vector();
		Iterator iAtcCodes = hAtcCodes.iterator();
		while(iAtcCodes.hasNext()){
			atcCodes.add(iAtcCodes.next());
		}
		return atcCodes;
	}
	
	public static Vector getContraIndicatedATCCodesForICD10Code(String icd10code){
		Vector atccodes = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select distinct OC_DRUGCONTRAINDICATIONLINK_ATCCODE from OC_DRUGCONTRAINDICATIONS a,OC_DRUGCONTRAINDICATIONLINKS b where "
					+ "a.OC_DRUGCONTRAINDICATION_CODE=b.OC_DRUGCONTRAINDICATIONLINK_CODE and OC_DRUGCONTRAINDICATION_ICD10CODEMIN<=? AND OC_DRUGCONTRAINDICATION_ICD10CODEMAX>=?");
			ps.setString(1, icd10code);
			ps.setString(2, icd10code);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				atccodes.add(ATCClass.get(rs.getString("OC_DRUGCONTRAINDICATIONLINK_ATCCODE")));
			}
			rs.close();
			ps.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			try{
				conn.close();
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		return atccodes;
	}
	
	
}
