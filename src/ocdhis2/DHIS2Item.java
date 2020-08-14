package ocdhis2;

import java.util.Hashtable;

import be.mxs.common.util.system.ScreenHelper;

public class DHIS2Item {
	private Hashtable values;
	private String type;
	
	public void setValue(String key, Object value){
		values.put(key, value);
	}
	
	public Object getValue(String key){
		return values.get(key);
	}
	
	public void setPersonId(String s){
		setValue("personid",s);
	}
	
	public String getPersonId(){
		return ScreenHelper.checkString((String)getValue("personid"));
	}
	
	public void setEncounterUid(String s){
		setValue("encounteruid",s);
	}
	
	public String getEncounterOrigin(){
		return ScreenHelper.checkString((String)getValue("encounterorigin"));
	}
	
	public void setEncounterOrigin(String s){
		setValue("encounterorigin",s);
	}
	
	public String getEncounterOutcome(){
		return ScreenHelper.checkString((String)getValue("encounteroutcome"));
	}
	
	public void setEncounterOutcome(String s){
		setValue("encounteroutcome",s);
	}
	
	public String getEncounterUid(){
		return ScreenHelper.checkString((String)getValue("encounteruid"));
	}
	
	public void setBegin(java.util.Date s){
		setValue("begin",s);
	}
	
	public java.util.Date getBegin(){
		return (java.util.Date)getValue("begin");
	}

	public void setEnd(java.util.Date s){
		setValue("end",s);
	}
	
	public java.util.Date getEnd(){
		return (java.util.Date)getValue("end");
	}
	
	public double getDuration(){
		if(getBegin()==null || getEnd()==null){
			return 0;
		}
		else{
			return ScreenHelper.nightsBetween(getBegin(), getEnd());
		}
	}

	public double getDuration(java.util.Date periodBegin, java.util.Date periodEnd){
		if(getBegin()==null || getEnd()==null){
			return 0;
		}
		java.util.Date b = getBegin();
		if(getBegin().before(periodBegin)){
			b = periodBegin;
		}
		java.util.Date e = getEnd();
		if(getEnd().after(periodEnd)){
			e = periodEnd;
		}
		return ScreenHelper.nightsBetween(b, e);
	}

}
