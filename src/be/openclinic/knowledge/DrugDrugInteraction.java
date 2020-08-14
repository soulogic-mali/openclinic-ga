package be.openclinic.knowledge;

import java.lang.reflect.Array;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.SortedMap;
import java.util.TreeMap;
import java.util.Vector;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.io.GoogleTranslate;
import be.mxs.common.util.system.ScreenHelper;

public class DrugDrugInteraction {
	private String interactionId;
	private String class1;
	private String class2;
	private int severity;
	
	public String getInteractionId() {
		return interactionId;
	}

	public void setInteractionId(String interactionId) {
		this.interactionId = interactionId;
	}

	public String getClass1() {
		return class1;
	}

	public void setClass1(String class1) {
		this.class1 = class1;
	}

	public String getClass2() {
		return class2;
	}

	public void setClass2(String class2) {
		this.class2 = class2;
	}

	public int getSeverity() {
		return severity;
	}

	public void setSeverity(int severity) {
		this.severity = severity;
	}
	
	public DrugDrugInteraction get(String interactionId){
		DrugDrugInteraction interaction = null;
		if(interactionId!=null){
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			try{
				PreparedStatement ps = conn.prepareStatement("select * from OC_DRUGINTERACTIONS where OC_DRUGINTERACTION_CODE=?");
				ps.setString(1, interactionId);
				ResultSet rs = ps.executeQuery();
				if(rs.next()){
					interaction=new DrugDrugInteraction();
					interaction.setInteractionId(interactionId);
					interaction.setClass1(rs.getString("OC_DRUGINTERACTION_CLASS1"));
					interaction.setClass2(rs.getString("OC_DRUGINTERACTION_CLASS2"));
					interaction.setSeverity(rs.getInt("OC_DRUGINTERACTION_SEVERITY"));
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
		return interaction;
	}

	public static Vector getInteractionsForClass(String classId){
		Vector interactions = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select * from OC_DRUGINTERACTIONS where OC_DRUGINTERACTION_ATCCLASS1=? OR OC_DRUGINTERACTION_ATCCLASS2=?");
			ps.setString(1, classId);
			ps.setString(2, classId);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				DrugDrugInteraction interaction=new DrugDrugInteraction();
				interaction.setInteractionId(rs.getString("OC_DRUGINTERACTION_CODE"));
				interaction.setClass1(rs.getString("OC_DRUGINTERACTION_CLASS1"));
				interaction.setClass2(rs.getString("OC_DRUGINTERACTION_CLASS2"));
				interaction.setSeverity(rs.getInt("OC_DRUGINTERACTION_SEVERITY"));
				interactions.add(interaction);
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
		return interactions;
	}
	
	public static Vector getInteractionsForATCCode(String atcCode){
		return getInteractionsForClasses(DrugInteractionClass.getInteractionIdsForATC(atcCode));
	}
	
	public static Vector getInteractionsForClasses(Vector classes){
		String codestring="(''";
		for(int n=0;n<classes.size();n++){
			codestring+=",'"+classes.elementAt(n)+"'";
		}
		codestring+=")";
		Vector interactions = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select distinct * from OC_DRUGINTERACTIONS where OC_DRUGINTERACTION_CLASS1 in "+codestring+" OR OC_DRUGINTERACTION_CLASS2 in "+codestring);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				DrugDrugInteraction interaction=new DrugDrugInteraction();
				interaction.setInteractionId(rs.getString("OC_DRUGINTERACTION_CODE"));
				interaction.setClass1(rs.getString("OC_DRUGINTERACTION_CLASS1"));
				interaction.setClass2(rs.getString("OC_DRUGINTERACTION_CLASS2"));
				interaction.setSeverity(rs.getInt("OC_DRUGINTERACTION_SEVERITY"));
				interactions.add(interaction);
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
		return interactions;
	}

	public static Vector getInteractionsBetweenATCCodes(String atcCode1,String atcCode2){
		return getInteractionsBetweenClasses(DrugInteractionClass.getInteractionIdsForATC(atcCode1),DrugInteractionClass.getInteractionIdsForATC(atcCode2));
	}
	
	public static Vector getInteractionsBetweenATCCodes(Vector atcCodes){
		return getInteractionsBetweenATCCodes(atcCodes,-1);
	}
	
	public static Vector getInteractionsBetweenATCCodes(Vector atcCodes, int minimumLevel){
		SortedMap interactions=new TreeMap();
		for(int n = 0;atcCodes.size()>1 && n<atcCodes.size();n++){
			String atcCode1 = ((ATCClass)atcCodes.elementAt(n)).getCode();
			//For every class, we are going to test interactions with all other classes
			for(int q=n+1;q<atcCodes.size();q++){
				String atcCode2 = ((ATCClass)atcCodes.elementAt(q)).getCode();
				Vector is = getInteractionsBetweenClasses(DrugInteractionClass.getInteractionIdsForATC(atcCode1),DrugInteractionClass.getInteractionIdsForATC(atcCode2));
				for(int r=0;r<is.size();r++){
					DrugDrugInteraction interaction = (DrugDrugInteraction)is.elementAt(r);
					if(interaction.severity>=minimumLevel){
						interactions.put(interaction.getInteractionId(),interaction);
					}
				}
			}
		}
		Iterator i = interactions.keySet().iterator();
		Vector interactionsVector=new Vector();
		while(i.hasNext()){
			interactionsVector.add(interactions.get(i.next()));
		}
		return interactionsVector;
	}
	
	public static Vector getInteractionsBetweenClasses(Vector classes1, Vector classes2){
		String codestring1="(''";
		for(int n=0;n<classes1.size();n++){
			codestring1+=",'"+classes1.elementAt(n)+"'";
		}
		codestring1+=")";
		String codestring2="(''";
		for(int n=0;n<classes2.size();n++){
			codestring2+=",'"+classes2.elementAt(n)+"'";
		}
		codestring2+=")";
		Vector interactions = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			String sSql="select * from OC_DRUGINTERACTIONS where (OC_DRUGINTERACTION_CLASS1 in "+codestring1+" AND OC_DRUGINTERACTION_CLASS2 in "+codestring2+") OR (OC_DRUGINTERACTION_CLASS1 in "+codestring2+" AND OC_DRUGINTERACTION_CLASS2 in "+codestring1+")";
			PreparedStatement ps = conn.prepareStatement(sSql);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				DrugDrugInteraction interaction=new DrugDrugInteraction();
				interaction.setInteractionId(rs.getString("OC_DRUGINTERACTION_CODE"));
				interaction.setClass1(rs.getString("OC_DRUGINTERACTION_CLASS1"));
				interaction.setClass2(rs.getString("OC_DRUGINTERACTION_CLASS2"));
				interaction.setSeverity(rs.getInt("OC_DRUGINTERACTION_SEVERITY"));
				interactions.add(interaction);
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
		return interactions;
	}

	public String getLabel(String sLanguage){
		String s = ScreenHelper.getTranNoLink("drugdruginteraction", getInteractionId()+"", sLanguage);
		if(s.equalsIgnoreCase(getInteractionId()+"")){
			s=GoogleTranslate.translate(MedwanQuery.getInstance().getConfigString("googleTranslateKey","AIzaSyAPk18gciaKdwl3Z2rmFSog4ZwBbmfhByg"), "fr", sLanguage, ScreenHelper.getTranNoLink("drugdruginteraction", getInteractionId()+"", "fr"));
			MedwanQuery.getInstance().storeLabel("drugdruginteraction", getInteractionId()+"", sLanguage, s, 4);
		}
		return(s);
	}
	
	public String getPrecaution(String sLanguage){
		String sLabel = ScreenHelper.getTranNoLink("drugdruginteraction.precaution",getInteractionId()+"",sLanguage);
		if(sLabel.equalsIgnoreCase(getInteractionId()+"")){
			sLabel=GoogleTranslate.translate(MedwanQuery.getInstance().getConfigString("googleTranslateKey","AIzaSyAPk18gciaKdwl3Z2rmFSog4ZwBbmfhByg"), "fr", sLanguage, ScreenHelper.getTranNoLink("drugdruginteraction.precaution", getInteractionId()+"", "fr"));
			MedwanQuery.getInstance().storeLabel("drugdruginteraction.precaution", getInteractionId()+"", sLanguage, sLabel, 4);
		}
		return sLabel;
	}
	
}
