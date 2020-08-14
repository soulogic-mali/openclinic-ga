package pe.gob.sis;

import java.util.Vector;

public class Procedimientos extends SIS_Object{

	public Procedimientos() {
		super(11, "SIS_PROCEDIMIENTOS");
	}

	public static Vector getForFUA(String uid){
		return SIS_Object.getForFUA("SIS_PROCEDIMIENTOS", 11, uid);
	}
	
	public static void moveToHistory(String uid){
		moveToHistory("SIS_PROCEDIMIENTOS", 11, uid);
	}
	
	public String getErrors(){
		String errors = "";
		for(int n=1;n<=fields;n++){
			if(!isValid(n)){
				if(errors.length()>0){
					errors+=",";
				}
				errors+=n;
			}
		}
		return errors;
	}

	boolean isValid(int fieldid){
		if("*1*3*".contains("*"+fieldid+"*")){
			return getValueInt(fieldid)>0;
		}
		else if("*2*".contains("*"+fieldid+"*")){
			return FUA.isValidCPT(getValueString(fieldid));
		}
		else if("*7*".contains("*"+fieldid+"*")){
			return getValueString(fieldid).length()==0 || getValueInt(fieldid)==1 || getValueInt(fieldid)==3;
		}
		return true;
	}

}
